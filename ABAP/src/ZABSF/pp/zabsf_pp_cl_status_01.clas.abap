class ZABSF_PP_CL_STATUS_01 definition
  public
  final
  create public .

public section.

  interfaces ZIF_absf_pp_STATUS .

  methods CONSTRUCTOR
    importing
      !INITIAL_REFDT type VVDATUM
      !INPUT_OBJECT type Zabsf_pp_S_INPUTOBJECT optional .
protected section.
private section.

  data REFDT type VVDATUM .
  data INPUTOBJ type Zabsf_pp_S_INPUTOBJECT .
  constants OBJTYP_WRK type J_OBART value 'CA'. "#EC NOTEXT
  constants OBJTYP_ORD type J_OBART value 'OR'. "#EC NOTEXT
  constants NEW_STATUS type J_STATUS value 'AGU'. "#EC NOTEXT
ENDCLASS.



CLASS ZABSF_PP_CL_STATUS_01 IMPLEMENTATION.


METHOD CONSTRUCTOR.
*Ref. Date
  refdt    = initial_refdt.

*App input data
  inputobj = input_object.
ENDMETHOD.


METHOD zif_absf_pp_status~get_status_ord.
  DATA: flg_user_stat  TYPE xfeld VALUE 'X',
        only_active    TYPE xfeld VALUE 'X',
        user_line      TYPE bsvx-sttxt,
        user_line_long TYPE char30,
        objnr          TYPE jest-objnr.

*Create objnr for workcenter
  CONCATENATE objtyp_ord aufnr INTO objnr.

*Get status of workcenter
  CALL FUNCTION 'STATUS_TEXT_EDIT_LONG'
    EXPORTING
      flg_user_stat    = flg_user_stat
      objnr            = objnr
      only_active      = only_active
      spras            = sy-langu
    IMPORTING
      user_line        = user_line
      user_line_long   = user_line_long
    EXCEPTIONS
      object_not_found = 1
      OTHERS           = 2.

  IF sy-subrc <> 0.
* Implement suitable error handling here
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'E'
        msgno      = '015'
      CHANGING
        return_tab = return_tab.
  ELSE.
*  Id and description of status
    status = user_line.
    status_desc = user_line_long.
  ENDIF.
ENDMETHOD.


METHOD zif_absf_pp_status~get_status_vornr.
*Reference
  DATA lref_sf_prdord TYPE REF TO zabsf_pp_cl_prdord.

*Variables
  DATA: l_matnr        TYPE mcekpo-matnr,
        l_source_value TYPE i,
        l_source_unit  TYPE mara-meins.

*Create object of class prdord
  CREATE OBJECT lref_sf_prdord
    EXPORTING
      initial_refdt = refdt
      input_object  = inputobj.

*Get status operation
  SELECT SINGLE *
    FROM zabsf_pp021
    INTO @DATA(ls_pp_sf021)
   WHERE arbpl EQ @arbpl
     AND aufnr EQ @aufnr
     AND vornr EQ @vornr.

  IF sy-subrc EQ 0.
*  Order
    vornr_detail-aufnr = aufnr.
*  Operation
    vornr_detail-vornr = vornr.
*  Material
    vornr_detail-maktx = maktx.
*  Get quantity
    SELECT SINGLE *
      FROM zabsf_pp017
      INTO @DATA(ls_pp_sf017)
     WHERE aufnr EQ @aufnr
       AND vornr EQ @vornr.

    IF sy-subrc EQ 0.
*    Total quantity
      vornr_detail-gamng = ls_pp_sf017-gamng.
*    Good quantity
      vornr_detail-lmnga = ls_pp_sf017-lmnga.
*    Missing quantity
      vornr_detail-missingqty = ls_pp_sf017-missingqty.
*    Produced quantity
      vornr_detail-prdqty_box = ls_pp_sf017-prdqty_box.
*    Box quantity
      vornr_detail-boxqty = ls_pp_sf017-boxqty.
*    Unit
      vornr_detail-gmein = ls_pp_sf017-gmein.
    ELSE.
*    Get total confirmed
      SELECT SUM( lmnga )
        FROM afru
        INTO (@DATA(l_lmnga))
        WHERE aufnr EQ @aufnr
          AND vornr EQ @vornr
          AND stokz EQ @space
          AND stzhl EQ @space.

*    Get total quantity
      SELECT SINGLE smeng, gmein
        FROM afru
        INTO (@DATA(l_smeng), @DATA(l_gmein))
        WHERE aufnr EQ @aufnr
          AND vornr EQ @vornr
          AND stokz EQ @space
          AND stzhl EQ @space.

*    Total quantity
      vornr_detail-gamng = l_smeng.
*    Good quantity
      vornr_detail-lmnga = l_lmnga.
*    Missing quantity
      vornr_detail-missingqty = l_smeng - l_lmnga.

*    Quantity of Box
*    Get basic unit of material
      SELECT SINGLE meins
        FROM mara
        INTO (@DATA(l_meins))
       WHERE matnr EQ @matnr.

      IF sy-subrc NE 0.
        l_meins = l_gmein.
      ENDIF.

*    Quantity to convert
      l_source_value = vornr_detail-gamng.
      l_matnr = matnr.
      l_source_unit = l_meins.

*    Convert Unit
      CALL METHOD lref_sf_prdord->convert_unit
        EXPORTING
          matnr        = l_matnr
          source_value = l_source_value
          source_unit  = l_source_unit
          lmnga        = vornr_detail-lmnga
        CHANGING
          prdqty_box   = vornr_detail-prdqty_box
          boxqty       = vornr_detail-boxqty.

*    Unit
      vornr_detail-gmein = l_gmein.
*    Status operation
      vornr_detail-status_oper = ls_pp_sf021-status_oper.
    ENDIF.
  ENDIF.
ENDMETHOD.


METHOD ZIF_ABSF_PP_STATUS~GET_STATUS_WRK.
*Internal tables
  DATA: lt_messtab TYPE STANDARD TABLE OF bdcmsgcoll.

*Variables
  DATA: l_user_line_long TYPE char30,
        l_user_line      TYPE bsvx-sttxt,
        l_stsma          TYPE jsto-stsma,
        l_objnr          TYPE jest-objnr,
        l_arbid          TYPE crhd-objid,
        l_werks          TYPE bdcdata-fval,
        l_resource       TYPE bdcdata-fval,
        l_subrc          TYPE syst-subrc.

*Constants
  CONSTANTS: c_flg_user_stat TYPE xfeld VALUE 'X',
             c_only_active   TYPE xfeld VALUE 'X'.

*Get object id of workcenter
  CALL FUNCTION 'CR_WORKSTATION_CHECK'
    EXPORTING
      arbpl     = arbpl
      werks     = werks
    IMPORTING
      arbid     = l_arbid
    EXCEPTIONS
      not_found = 1
      OTHERS    = 2.

  IF sy-subrc <> 0.
*  Implement suitable error handling here
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'E'
        msgno      = '015'
      CHANGING
        return_tab = return_tab.
  ENDIF.

*Create objnr for workcenter
  CONCATENATE objtyp_wrk l_arbid INTO l_objnr.

*Check if objecti exist
  SELECT SINGLE *
    FROM jsto
    INTO @DATA(ls_jsto)
   WHERE objnr EQ @l_objnr.

  IF sy-subrc NE 0.
    CLEAR: l_werks,
           l_resource.
*  Plant
    l_werks = werks.
*  Work center
    l_resource = arbpl.

    CALL FUNCTION 'ZABSF_PP_WRKCTR_MOD'
      EXPORTING
        werks_001    = l_werks
        resource_002 = l_resource
      IMPORTING
        subrc        = l_subrc
      TABLES
        messtab      = lt_messtab.
  ENDIF.

*Get status of workcenter
  CALL FUNCTION 'STATUS_TEXT_EDIT_LONG'
    EXPORTING
      flg_user_stat    = c_flg_user_stat
      objnr            = l_objnr
      only_active      = c_only_active
      spras            = sy-langu
    IMPORTING
      e_stsma          = l_stsma
      user_line        = l_user_line
      user_line_long   = l_user_line_long
    EXCEPTIONS
      object_not_found = 1
      OTHERS           = 2.

  IF sy-subrc <> 0.
* Implement suitable error handling here
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'E'
        msgno      = '015'
      CHANGING
        return_tab = return_tab.
  ELSE.
*  Id and description of status
    status = l_user_line.
    status_desc = l_user_line_long.
    stsma = l_stsma.
  ENDIF.
ENDMETHOD.


METHOD ZIF_ABSF_PP_STATUS~SET_REFDT.
*Set new reference date
  refdt = new_refdt.
ENDMETHOD.


METHOD ZIF_ABSF_PP_STATUS~SET_STATUS_ORD.
  DATA: wa_status_input  TYPE ZABSF_PP_s_status_ord,
*        lt_ZABSF_PP019  TYPE TABLE OF ZABSF_PP019,
*        wa_ZABSF_PP019  TYPE ZABSF_PP019,
        orders           TYPE TABLE OF bapi_order_key,
        ls_orders        TYPE bapi_order_key,
        detail_return    TYPE TABLE OF bapi_order_return,
        wa_detail_return TYPE bapi_order_return,
        return           TYPE bapiret2.

**Get status profile
*  SELECT *
*    FROM ZABSF_PP019
*    INTO CORRESPONDING FIELDS OF TABLE lt_ZABSF_PP019.

*Read all status of orders send
  LOOP AT status_input_tab INTO wa_status_input.
    REFRESH orders.

    CLEAR ls_orders.
*    CLEAR: wa_ZABSF_PP019,
*           ls_orders.

*    READ TABLE lt_ZABSF_PP019 INTO wa_ZABSF_PP019 WITH KEY auart = wa_status_input-auart.

    ls_orders = wa_status_input-aufnr.
    APPEND ls_orders TO orders.

*Reset user status for Production Order
    CALL FUNCTION 'BAPI_PRODORD_REVOKEUSERSTATUS'
      EXPORTING
        status_profile = stsma          "wa_ZABSF_PP019-status_profile
        status         = wa_status_input-status
      TABLES
        orders         = orders
        detail_return  = detail_return.

    CLEAR return.

*  Details of operation
    LOOP AT detail_return INTO wa_detail_return.
      CLEAR return.

      return-type = wa_detail_return-type.
      return-id = wa_detail_return-id.
      return-number = wa_detail_return-number.
      return-message = wa_detail_return-message.
      return-message_v1 = wa_detail_return-message_v1.
      return-message_v2 = wa_detail_return-message_v2.
      return-message_v3 = wa_detail_return-message_v3.
      return-message_v4 = wa_detail_return-message_v4.

      APPEND return TO return_tab.
    ENDLOOP.

* Set user status for Production Order
    CALL FUNCTION 'BAPI_PRODORD_SETUSERSTATUS'
      EXPORTING
        status_profile = stsma          "wa_ZABSF_PP019-status_profile
        status         = new_status
      TABLES
        orders         = orders
        detail_return  = detail_return.

    CLEAR return.

*  Details of operation
    LOOP AT detail_return INTO wa_detail_return.
      CLEAR return.

      return-type = wa_detail_return-type.
      return-id = wa_detail_return-id.
      return-number = wa_detail_return-number.
      return-message = wa_detail_return-message.
      return-message_v1 = wa_detail_return-message_v1.
      return-message_v2 = wa_detail_return-message_v2.
      return-message_v3 = wa_detail_return-message_v3.
      return-message_v4 = wa_detail_return-message_v4.

      APPEND return TO return_tab.
    ENDLOOP.
  ENDLOOP.
ENDMETHOD.


method zif_absf_pp_status~set_status_vornr.

  data: ls_zabsf_pp084 type zabsf_pp084,
        ls_zabsf_pp021 type zabsf_pp021.

*Check if exist status for operation
  select single *
    from zabsf_pp021
    into @data(ls_pp_sf021)
   where arbpl eq @arbpl
     and aufnr eq @aufnr
     and vornr eq @vornr.

  if sy-subrc eq 0.
*  Get next status
    select single status_next
      from zabsf_pp022
      into (@data(l_status_next))
     where objty       eq @objty
       and status_last eq @ls_pp_sf021-status_oper
       and actionid    eq @actionid.

    if sy-subrc eq 0.
*    Update with new status
*      update zabsf_pp021 from @( value #( base ls_pp_sf021 status_oper = l_status_next ) ).

      ls_pp_sf021-status_oper = l_status_next.
      update zabsf_pp021 from ls_pp_sf021.


      if sy-subrc ne 0.
*      Send message
        call method zabsf_pp_cl_log=>add_message
          exporting
            msgty      = 'E'
            msgno      = '012'
          changing
            return_tab = return_tab.
      else.
*      Save record
        commit work and wait.

        status_out = l_status_next.

*      Send message
        call method zabsf_pp_cl_log=>add_message
          exporting
            msgty      = 'S'
            msgno      = '013'
          changing
            return_tab = return_tab.
      endif.
      "eliminiar da tabela de sequências
      if actionid eq 'INIT'.
        delete from zabsf_pp084 where werks = inputobj-werks
                                  and aufnr = aufnr
                                  and vornr = vornr
                                  and arbpl = arbpl.
        commit work.
      endif.
      "inserir novamente na tabela de sequências
      if l_status_next eq 'AGU'.
        "verificar se já existe entrada na tabela
        select single aufnr
          from zabsf_pp084
          into @data(lv_aufnr_var)
          where werks eq @inputobj-werks
            and arbpl eq @arbpl
            and vornr eq @vornr
            and aufnr eq @aufnr.
        "se existir, não actualiza
        if sy-subrc ne 0.
          "inserir ordem na tabela de sequencias
          select max( sequence )
            from zabsf_pp084
            into @data(lv_sequence_var)
            where werks eq @inputobj-werks
              and arbpl eq @arbpl
              and vornr eq @vornr.
          "incrementar uma posição
          add 1 to lv_sequence_var.
          "inserir linha
*          modify zabsf_pp084 from @( value #(  werks       = inputobj-werks
*                                               arbpl       = arbpl
*                                               aufnr       = aufnr
*                                               vornr       = vornr
*                                               sequence    = lv_sequence_var ) ).

          ls_zabsf_pp084-werks = inputobj-werks.
          ls_zabsf_pp084-arbpl = arbpl.
          ls_zabsf_pp084-aufnr = aufnr.
          ls_zabsf_pp084-vornr = vornr.
          ls_zabsf_pp084-sequence = lv_sequence_var.
          modify zabsf_pp084 from ls_zabsf_pp084.

          commit work.
        endif.
      endif.

    endif.
  else.
*  Get next status
    select single status_next
      from zabsf_pp022
      into @l_status_next
     where objty       eq @objty
       and status_last eq 'INI'"BMR - forçar que o primeiro status seja AGU em vez de INI @space
       and status_next ne @space
       and actionid    eq @actionid.

*  Insert new line in database
*    insert into zabsf_pp021 values @( value #(  arbpl       = arbpl
*                                                 aufnr       = aufnr
*                                                 vornr       = vornr
*                                                 status_oper = l_status_next ) ).

    ls_zabsf_pp021-arbpl       = arbpl.
    ls_zabsf_pp021-aufnr       = aufnr.
    ls_zabsf_pp021-vornr       = vornr.
    ls_zabsf_pp021-status_oper = l_status_next.
    insert into zabsf_pp021 values ls_zabsf_pp021.

    if sy-subrc ne 0.
*    Send message
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgty      = 'E'
          msgno      = '012'
        changing
          return_tab = return_tab.
    else.
*    Save record
      commit work and wait.

      "inserir ordem na tabela de sequencias
      select max( sequence )
        from zabsf_pp084
        into @lv_sequence_var
        where werks eq @inputobj-werks
          and arbpl eq @arbpl
          and vornr eq @vornr.
      "incrementar uma posição
      add 1 to lv_sequence_var.
      "inserir linha
*      modify zabsf_pp084 from @( value #(  werks       = inputobj-werks
*                                           arbpl       = arbpl
*                                           aufnr       = aufnr
*                                           vornr       = vornr
*                                           sequence    = lv_sequence_var ) ).
      ls_zabsf_pp084-werks       = inputobj-werks.
      ls_zabsf_pp084-arbpl       = arbpl.
      ls_zabsf_pp084-aufnr       = aufnr.
      ls_zabsf_pp084-vornr       = vornr.
      ls_zabsf_pp084-sequence    = lv_sequence_var.
      modify zabsf_pp084 from ls_zabsf_pp084.

      "commit base de dados
      commit work and wait.

      status_out = l_status_next.

*    Send message
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgty      = 'S'
          msgno      = '013'
        changing
          return_tab = return_tab.
    endif.
  endif.
endmethod.


METHOD zif_absf_pp_status~set_status_wrk.
*Structures
  DATA: ls_return TYPE bapiret2.

*Reference
  DATA lref_sf_status TYPE REF TO zabsf_pp_cl_status_01.

*Variables
  DATA: l_objnr       TYPE j_objnr,
        l_stsma       TYPE jsto-stsma,
        l_user_line   TYPE bsvx-sttxt,
        l_status_desc TYPE j_txt30.

*Constants
  CONSTANTS: c_flg_user_stat TYPE xfeld VALUE 'X',
             c_only_active   TYPE xfeld VALUE 'X'.

*Get id of workcenter
  SELECT SINGLE objid
    FROM crhd
    INTO (@DATA(l_objid))
   WHERE arbpl EQ @arbpl
     AND werks EQ @werks.

*Object type of workcenter
  CONCATENATE objtyp_wrk l_objid INTO l_objnr.

*Get status of workcenter
  CALL FUNCTION 'STATUS_TEXT_EDIT_LONG'
    EXPORTING
      flg_user_stat    = c_flg_user_stat
      objnr            = l_objnr
      only_active      = c_only_active
      spras            = sy-langu
    IMPORTING
      e_stsma          = l_stsma
      user_line        = l_user_line
      user_line_long   = l_status_desc   "user_line_long
    EXCEPTIONS
      object_not_found = 1
      OTHERS           = 2.

*Get id of user status E0001, E0002, E0003, E0004
  SELECT SINGLE estat
    FROM tj30t
    INTO (@DATA(l_estat))
   WHERE stsma EQ @l_stsma
     AND txt04 EQ @l_user_line
     AND txt30 EQ @l_status_desc
     AND spras EQ @sy-langu.

*Get id of new user status E0001, E0002, E0003, E0004
  SELECT SINGLE estat
    FROM tj30t
    INTO (@DATA(l_new_estat))
   WHERE stsma EQ @stsma
     AND txt04 EQ @status
     AND spras EQ @sy-langu.

  IF l_estat NE l_new_estat.
*  Change user status
    CALL FUNCTION 'ZABSF_PP_SET_USER_STATUS_WRKCT'
      EXPORTING
        objnr      = l_objnr
        old_status = l_estat
        new_status = l_new_estat
      IMPORTING
        return     = ls_return.

    IF ls_return IS NOT INITIAL.
      APPEND ls_return TO return_tab.
    ENDIF.
  ENDIF.
ENDMETHOD.
ENDCLASS.
