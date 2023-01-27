class ZABSF_PP_CL_REWORK definition
  public
  final
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !INITIAL_REFDT type VVDATUM
      !INPUT_OBJECT type ZABSF_PP_S_INPUTOBJECT .
  methods SET_REFDT
    importing
      !NEW_REFDT type VVDATUM .
  methods GET_OPERATOR_REWORK
    importing
      !ARBPL type ARBPL
      !AUFNR type AUFNR
      !VORNR type VORNR
    changing
      !OPERATOR_TAB type ZABSF_PP_T_OPERADOR
      !RETURN_TAB type BAPIRET2_T .
  methods CREATE_ORDER_REWORK
    importing
      !ARBPL type ARBPL
      !MATNR type MATNR
      !DEFECTID type ZABSF_PP_E_DEFECTID
      !REWORK_QTY type RU_RMNGA
    changing
      !AUFNR_REWORK type AUFNR optional
      !RETURN_TAB type BAPIRET2_T .
  methods SET_QUANTITY_REWORK
    importing
      !ARBPL type ARBPL
      !AUFNR type AUFNR optional
      !VORNR type VORNR optional
      !MATNR type MATNR optional
      !SCRAP_QTY type RU_XMNGA optional
      !NUMB_CYCLE type NUMC10 optional
      !DEFECTID type ZABSF_PP_E_DEFECTID optional
      !GRUND type CO_AGRND optional
      !FLAG_CREATE type FLAG optional
      !REWORK_QTY type RU_RMNGA optional
      !FLAG_SCRAP_LIST type FLAG optional
      !CHARG_T type ZABSF_PP_T_BATCH_CONSUMPTION optional
      value(BACKOFFICE) type FLAG optional
      value(SHIFTID) type ZABSF_PP_E_SHIFTID optional
    exporting
      !CONF_TAB type ZABSF_PP_T_CONFIRMATION
    changing
      !AUFNR_REWORK type AUFNR optional
      !RETURN_TAB type BAPIRET2_T .
  methods GET_DEFECTS
    importing
      !ARBPL type ARBPL
      !MATNR type MATNR optional
      !AUFNR type AUFNR optional
      !VORNR type VORNR optional
      !REASONTYP type ZABSF_PP_E_REASONTYP
      !FLAG_SCRAP_LIST type FLAG optional
    changing
      !DEFECTS_TAB type ZABSF_PP_T_DEFECTS optional
      !REASON_TAB type ZABSF_PP_T_REASON optional
      !RETURN_TAB type BAPIRET2_T .
  methods UPDATE_ORDER_REWORK
    importing
      !ARBPL type ARBPL
      !MATNR type MATNR
      !DEFECTID type ZABSF_PP_E_DEFECTID optional
      !FLAG_CREATE type FLAG optional
      !REWORK_QTY type RU_RMNGA optional
    changing
      !AUFNR_REWORK type AUFNR optional
      !RETURN_TAB type BAPIRET2_T .
  methods SET_QUANTITY_SCRAP
    importing
      !ARBPL type ARBPL
      !AUFNR type AUFNR optional
      !VORNR type VORNR optional
      !MATNR type MATNR optional
      !SCRAP_QTY type RU_XMNGA optional
      !NUMB_CYCLE type NUMC10 optional
      !DEFECTID type ZABSF_PP_E_DEFECTID optional
      !GRUND type CO_AGRND optional
      !FLAG_CREATE type FLAG optional
      !REWORK_QTY type RU_RMNGA optional
      !FLAG_SCRAP_LIST type FLAG optional
      !CHARG_T type ZABSF_PP_T_BATCH_CONSUMPTION optional
      value(BACKOFFICE) type FLAG optional
      value(SHIFTID) type ZABSF_PP_E_SHIFTID optional
    exporting
      !CONF_TAB type ZABSF_PP_T_CONFIRMATION
    changing
      !AUFNR_REWORK type AUFNR optional
      !RETURN_TAB type BAPIRET2_T .
  methods GET_DEFECTS_LIST
    importing
      !ARBPL type ARBPL
      !MATNR type MATNR optional
      !AUFNR type AUFNR optional
      !VORNR type VORNR optional
      !REASONTYP type ZABSF_PP_E_REASONTYP
      !FLAG_SCRAP_LIST type FLAG optional
    changing
      !DEFECTS_TAB type ZABSF_PP_T_DEFECTS optional
      !REASON_TAB type ZABSF_PP_T_REASON optional
      !RETURN_TAB type BAPIRET2_T .
protected section.
private section.

  data REFDT type VVDATUM .
  data INPUTOBJ type ZABSF_PP_S_INPUTOBJECT .
  constants TIPO_ORDEM type ZABSF_PP_E_TIPORD value 'R' ##NO_TEXT.
ENDCLASS.



CLASS ZABSF_PP_CL_REWORK IMPLEMENTATION.


METHOD CONSTRUCTOR.
*Ref. Date
  refdt    = initial_refdt.

*App input data
  inputobj = input_object.
ENDMETHOD.


METHOD create_order_rework.
  DATA: it_orders     TYPE TABLE OF bapi_order_key,
        detail_return TYPE TABLE OF bapi_order_return.

  DATA: wa_detail_return TYPE bapi_order_return,
        orderdata        TYPE bapi_pp_order_create,
        order_number     TYPE bapi_order_key-order_number,
        wa_orders        TYPE bapi_order_key,
        ld_auart         TYPE aufart,
        ld_plnnr         TYPE plnnr,
        return           TYPE bapiret2.

  REFRESH detail_return.

  CLEAR: orderdata,
         order_number,
         wa_orders,
         ld_auart,
         ld_plnnr,
         return.

*Get order type
  SELECT SINGLE auart
    FROM zabsf_pp019
    INTO ld_auart
   WHERE areaid EQ inputobj-areaid
     AND tipord EQ tipo_ordem
     AND relev  NE space.

  IF sy-subrc NE 0.
*  No data found for area in customizig table
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'E'
        msgno      = '027'
        msgv1      = inputobj-areaid
      CHANGING
        return_tab = return_tab.
  ELSE.
*  Get Number of the task list
    SELECT SINGLE plnnr
      FROM zabsf_pp026
      INTO ld_plnnr
      WHERE areaid   EQ inputobj-areaid
        AND werks    EQ inputobj-werks
        AND arbpl    EQ arbpl
        AND defectid EQ defectid.

    IF sy-subrc NE 0 OR ld_plnnr IS INITIAL.
*    No data found for defect in customizig table
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'E'
          msgno      = '026'
          msgv1      = defectid
        CHANGING
          return_tab = return_tab.
    ELSE.
*    Data for creation of Rework Order
      orderdata-material = matnr.
      orderdata-plant = inputobj-werks.
      orderdata-planning_plant = inputobj-werks.
      orderdata-order_type = ld_auart .
      orderdata-quantity = rework_qty.
      orderdata-routing_group = ld_plnnr.

      CALL FUNCTION 'BAPI_PRODORD_CREATE'
        EXPORTING
          orderdata    = orderdata
        IMPORTING
          return       = return
          order_number = order_number.

      IF return IS NOT INITIAL.
        APPEND return TO return_tab.
      ELSE.
        wa_orders-order_number = order_number.
        APPEND wa_orders TO it_orders.

        CALL FUNCTION 'BAPI_PRODORD_RELEASE'
          EXPORTING
            release_control = '1'
*           WORK_PROCESS_GROUP = 'COWORK_BAPI'
*           WORK_PROCESS_MAX   = 99
          IMPORTING
            return          = return
          TABLES
            orders          = it_orders
            detail_return   = detail_return.

        READ TABLE detail_return INTO wa_detail_return WITH KEY type = 'E'.

        IF sy-subrc NE 0.
          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
            EXPORTING
              wait = 'X'.

          aufnr_rework = order_number.

          CALL METHOD zabsf_pp_cl_log=>add_message
            EXPORTING
              msgty      = 'S'
              msgno      = '031'
              msgv1      = order_number
              msgv2      = matnr
            CHANGING
              return_tab = return_tab.
        ELSE.
          CLEAR wa_detail_return.


*        Details of operation
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

          CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
ENDMETHOD.


METHOD get_defects.
*Internal tables
  DATA: lt_zabsf_pp026 TYPE TABLE OF zabsf_pp026,
        lt_rework_temp TYPE TABLE OF ty_rework_temp,
        lt_zabsf_pp034 TYPE TABLE OF zabsf_pp034.

*Structures
  DATA: ls_rework_temp TYPE ty_rework_temp,
        ls_zabsf_pp026 TYPE zabsf_pp026,
        ls_zabsf_pp034 TYPE zabsf_pp034,
        ls_reason      TYPE zabsf_pp_s_reason.

*Variables
  DATA: l_objid TYPE cr_objid,
        l_auart TYPE aufart,
        l_langu TYPE sy-langu.

  FIELD-SYMBOLS <fs_defects> TYPE zabsf_pp_s_defects.

* Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.

**************************************************************************************
*                                    DEFECTS LIST                                    *
**************************************************************************************
  IF reasontyp EQ 'D'.
*  Get defects
    SELECT zabsf_pp026~defectid zabsf_pp026_t~defect_desc
      INTO CORRESPONDING FIELDS OF TABLE defects_tab
      FROM zabsf_pp026 AS zabsf_pp026
     INNER JOIN zabsf_pp026_t AS zabsf_pp026_t
        ON zabsf_pp026_t~arbpl EQ zabsf_pp026~arbpl
       AND zabsf_pp026_t~defectid EQ zabsf_pp026~defectid
     WHERE zabsf_pp026~areaid EQ inputobj-areaid
       AND zabsf_pp026~werks  EQ inputobj-werks
       AND zabsf_pp026~arbpl  EQ arbpl.

    IF sy-subrc EQ 0.
*    Operation completed successfully
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'S'
          msgno      = '013'
        CHANGING
          return_tab = return_tab.
    ELSE.
*    No defects found
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'E'
          msgno      = '032'
          msgv1      = inputobj-areaid
          msgv2      = arbpl
          msgv3      = inputobj-werks
        CHANGING
          return_tab = return_tab.
    ENDIF.

    IF inputobj-areaid NE 'MONT'.
*    Get objid of workcenter
      SELECT SINGLE objid
        FROM crhd
        INTO l_objid
       WHERE arbpl EQ arbpl
         AND werks EQ inputobj-werks.

*    Get order type
      SELECT SINGLE auart
        FROM zabsf_pp019
        INTO l_auart
       WHERE areaid EQ inputobj-areaid
         AND tipord EQ tipo_ordem
         AND relev  NE space.

      IF sy-subrc NE 0.
*      No order type found for area in customizig table
        CALL METHOD zabsf_pp_cl_log=>add_message
          EXPORTING
            msgty      = 'E'
            msgno      = '027'
            msgv1      = inputobj-areaid
          CHANGING
            return_tab = return_tab.
      ENDIF.

*    Get Number of the task list
      SELECT *
        FROM zabsf_pp026
        INTO CORRESPONDING FIELDS OF TABLE lt_zabsf_pp026
        FOR ALL ENTRIES IN defects_tab
       WHERE areaid   EQ inputobj-areaid
         AND werks    EQ inputobj-werks
         AND arbpl    EQ arbpl
         AND defectid EQ defects_tab-defectid.

*    Check if exist rework order for defects created
      LOOP AT defects_tab ASSIGNING <fs_defects>.
        READ TABLE lt_zabsf_pp026 INTO ls_zabsf_pp026 WITH KEY defectid = <fs_defects>-defectid.

        IF sy-subrc EQ 0.
*        Check if exist rework order
          SELECT aufk~aufnr aufk~auart aufk~objnr afko~plnnr afko~stlbez jest1~stat
            INTO CORRESPONDING FIELDS OF TABLE lt_rework_temp
            FROM aufk AS aufk
           INNER JOIN afko AS afko
              ON afko~aufnr EQ aufk~aufnr
           INNER JOIN jest AS jest
              ON jest~objnr EQ aufk~objnr
             AND jest~stat  EQ 'I0002'  "LIB
             AND jest~inact EQ space
            LEFT OUTER JOIN jest AS jest1
              ON jest1~objnr EQ aufk~objnr
             AND jest1~stat  EQ 'I0009' "CONF
             AND jest1~inact EQ space
           WHERE aufk~auart  EQ l_auart
             AND afko~stlbez EQ matnr
             AND afko~plnnr  EQ ls_zabsf_pp026-plnnr.

          DELETE lt_rework_temp WHERE stat EQ 'I0009'.

          IF lt_rework_temp[] IS NOT INITIAL.
            READ TABLE lt_rework_temp INTO ls_rework_temp INDEX 1.

            IF sy-subrc EQ 0.
              <fs_defects>-flag_exist = 'X'.
              <fs_defects>-aufnr = ls_rework_temp-aufnr.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDIF.

**************************************************************************************
*                                      SCRAP LIST                                    *
**************************************************************************************
  IF reasontyp EQ 'C'.
*  Reason for variances in completion confirmations
    SELECT grund grdtx
      FROM trugt
      INTO CORRESPONDING FIELDS OF TABLE reason_tab
      WHERE werks EQ inputobj-werks
        AND spras EQ sy-langu.

    IF sy-subrc NE 0.
      CLEAR l_langu.

*    Get alternative language
      SELECT SINGLE spras
        FROM zabsf_pp061
        INTO l_langu
       WHERE werks      EQ inputobj-werks
         AND is_default NE space.

*    Reason for variances in completion confirmations
      SELECT grund grdtx
        FROM trugt
        INTO CORRESPONDING FIELDS OF TABLE reason_tab
        WHERE werks EQ inputobj-werks
          AND spras EQ l_langu.
    ENDIF.

    IF reason_tab[] IS NOT INITIAL.
      IF flag_scrap_list IS NOT INITIAL.
        REFRESH lt_zabsf_pp034.

*      Get scrap quantity
        SELECT *
          FROM zabsf_pp034
          INTO CORRESPONDING FIELDS OF TABLE lt_zabsf_pp034
           FOR ALL ENTRIES IN reason_tab
         WHERE areaid EQ inputobj-areaid
           AND matnr  EQ matnr
           AND data   LE refdt
           AND grund  EQ reason_tab-grund.

        IF sy-subrc EQ 0.
          CLEAR ls_zabsf_pp034.

          LOOP AT lt_zabsf_pp034 INTO ls_zabsf_pp034.
            CLEAR ls_reason.

            READ TABLE reason_tab INTO ls_reason WITH KEY grund = ls_zabsf_pp034-grund.

            IF sy-subrc EQ 0.
              ADD ls_zabsf_pp034-scrap_qty TO ls_reason-scrap_qty.

              MODIFY TABLE reason_tab FROM ls_reason.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDIF.

*    Operation completed successfully
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'S'
          msgno      = '013'
        CHANGING
          return_tab = return_tab.
    ELSE.
*    No reason found
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'E'
          msgno      = '033'
          msgv1      = inputobj-werks
        CHANGING
          return_tab = return_tab.
    ENDIF.
  ENDIF.
ENDMETHOD.


method get_defects_list.
*>> BMR INSERT 18.11.2016 - filter defects by area.
  data: lv_veran type ap_veran,
        lt_sf072 type table of zabsf_pp072,
        ls_sf072 like line of lt_sf072.
*<<
*Internal tables
  data: "lt_ZABSF_PP026 TYPE TABLE OF ZABSF_PP026,
    lt_rework_temp type table of ty_rework_temp,
    lt_zabsf_pp034 type table of zabsf_pp034.

*Structures
  data: ls_rework_temp type ty_rework_temp,
        "ls_ZABSF_PP026 TYPE ZABSF_PP026,
        ls_zabsf_pp034 type zabsf_pp034,
        ls_reason      type zabsf_pp_s_reason.

*Variables
  data: l_langu type sy-langu.

*Constants
  constants: c_at03 type zabsf_pp_e_tarea_id value 'AT03'. "Repetitive production functionalities


*Set local language for user
  l_langu = inputobj-language.

  set locale language l_langu.

**************************************************************************************
*                                    DEFECTS LIST                                    *
**************************************************************************************
  if reasontyp eq 'D'.
*  Get defects
    select zabsf_pp026~defectid zabsf_pp026_t~defect_desc
      into corresponding fields of table defects_tab
      from zabsf_pp026 as zabsf_pp026
     inner join zabsf_pp026_t as zabsf_pp026_t
        on zabsf_pp026_t~arbpl eq zabsf_pp026~arbpl
       and zabsf_pp026_t~defectid eq zabsf_pp026~defectid
     where zabsf_pp026~areaid eq inputobj-areaid
       and zabsf_pp026~werks  eq inputobj-werks
       and zabsf_pp026~arbpl  eq arbpl.

    if sy-subrc eq 0.
*    Operation completed successfully
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgty      = 'S'
          msgno      = '013'
        changing
          return_tab = return_tab.
    else.
*    No defects found
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgty      = 'E'
          msgno      = '032'
          msgv1      = inputobj-areaid
          msgv2      = arbpl
          msgv3      = inputobj-werks
        changing
          return_tab = return_tab.
    endif.

*  Get area type
    select single tarea_id
      from zabsf_pp008
      into (@data(l_tarea_id))
     where areaid eq @inputobj-areaid
       and werks  eq @inputobj-werks
       and endda  gt @sy-datum
       and begda  lt @sy-datum.

    if l_tarea_id ne c_at03.
*    Get objid of workcenter
      select single objid
        from crhd
        into (@data(l_objid))
       where arbpl eq @arbpl
         and werks eq @inputobj-werks.

*    Get order type
      select single auart
        from zabsf_pp019
        into (@data(l_auart))
       where areaid eq @inputobj-areaid
         and tipord eq @tipo_ordem
         and relev  ne @space.

      if sy-subrc ne 0.
*      No order type found for area in customizig table
        call method zabsf_pp_cl_log=>add_message
          exporting
            msgty      = 'E'
            msgno      = '027'
            msgv1      = inputobj-areaid
          changing
            return_tab = return_tab.
      endif.

*    Get Number of the task list
      select *
        from zabsf_pp026
        into table @data(lt_zabsf_pp026)
        for all entries in @defects_tab
       where areaid   eq @inputobj-areaid
         and werks    eq @inputobj-werks
         and arbpl    eq @arbpl
         and defectid eq @defects_tab-defectid.

*    Check if exist rework order for defects created
      loop at defects_tab assigning field-symbol(<fs_defects>).
        read table lt_zabsf_pp026 into data(ls_zabsf_pp026) with key defectid = <fs_defects>-defectid.

        if sy-subrc eq 0.
*        Check if exist rework order
          select aufk~aufnr aufk~auart aufk~objnr afko~plnnr afko~stlbez jest1~stat
            into corresponding fields of table lt_rework_temp
            from aufk as aufk
           inner join afko as afko
              on afko~aufnr eq aufk~aufnr
           inner join jest as jest
              on jest~objnr eq aufk~objnr
             and jest~stat  eq 'I0002'  "LIB
             and jest~inact eq space
            left outer join jest as jest1
              on jest1~objnr eq aufk~objnr
             and jest1~stat  eq 'I0009' "CONF
             and jest1~inact eq space
           where aufk~auart  eq l_auart
             and afko~stlbez eq matnr
             and afko~plnnr  eq ls_zabsf_pp026-plnnr.

          delete lt_rework_temp where stat eq 'I0009'.

          if lt_rework_temp[] is not initial.
            read table lt_rework_temp into ls_rework_temp index 1.

            if sy-subrc eq 0.
              <fs_defects>-flag_exist = 'X'.
              <fs_defects>-aufnr = ls_rework_temp-aufnr.
            endif.
          endif.
        endif.
      endloop.
    endif.
  endif.

**************************************************************************************
*                                      SCRAP LIST                                    *
**************************************************************************************
  if reasontyp eq 'C'.
*  Reason for variances in completion confirmations
    select grund grdtx
      from trugt
      into corresponding fields of table reason_tab
      where werks eq inputobj-werks
        and spras eq sy-langu.

    if sy-subrc ne 0.
      clear l_langu.

*    Get alternative language
      select single spras
        from zabsf_pp061
        into l_langu
       where werks      eq inputobj-werks
         and is_default eq space.

*    Reason for variances in completion confirmations
      select grund grdtx
        from trugt
        into corresponding fields of table reason_tab
        where werks eq inputobj-werks
          and spras eq l_langu.
    endif.

    if reason_tab[] is not initial.
      if flag_scrap_list is not initial.
*        REFRESH lt_ZABSF_PP034.
*
**      Get scrap quantity
*        SELECT *
*          FROM ZABSF_PP034
*          INTO CORRESPONDING FIELDS OF TABLE lt_ZABSF_PP034
*           FOR ALL ENTRIES IN reason_tab
*         WHERE areaid EQ inputobj-areaid
*           AND matnr  EQ matnr
*           AND data   LE refdt
*           AND grund  EQ reason_tab-grund.
*
*        IF sy-subrc EQ 0.
*          CLEAR ls_ZABSF_PP034.
*
*          LOOP AT lt_ZABSF_PP034 INTO ls_ZABSF_PP034.
*            CLEAR ls_reason.
*
*            READ TABLE reason_tab INTO ls_reason WITH KEY grund = ls_ZABSF_PP034-grund.
*
*            IF sy-subrc EQ 0.
*              ADD ls_ZABSF_PP034-scrap_qty TO ls_reason-scrap_qty.
*
*              MODIFY TABLE reason_tab FROM ls_reason.
*            ENDIF.
*          ENDLOOP.
*        ENDIF.

        clear l_objid.

*      Get objid of workcenter
        select single objid
          from crhd
          into @l_objid
         where arbpl eq @arbpl
           and werks eq @inputobj-werks.

*      Get number of confirmation
        select single afvc~rueck
          from afko as afko
         inner join afvc as afvc
            on afvc~aufpl eq afko~aufpl
         where afko~aufnr eq @aufnr
           and afvc~vornr eq @vornr
           and afvc~arbid eq @l_objid
           and afvc~werks eq @inputobj-werks
          into (@data(l_rueck)).

*      Get scrap quantity
        select *
          from afru
          into table @data(lt_afru)
           for all entries in @reason_tab
         where rueck eq @l_rueck
           and grund eq @reason_tab-grund
           and aufnr eq @aufnr
           and vornr eq @vornr
           and stokz eq @space
           and stzhl eq @space.

        if lt_afru[] is not initial.
*        Scrap quantity by grund
          loop at reason_tab assigning field-symbol(<fs_reason>).
            loop at lt_afru into data(ls_afru) where grund eq <fs_reason>-grund.
              add ls_afru-xmnga to <fs_reason>-scrap_qty.
            endloop.
          endloop.
        endif.
      endif.

*>> BMR INSERT 03.06.2020 - Filtrar defeitos por centro de trabalho
      select defectid
        into table @data(lt_defects_tab)
        from zabsf_pp026 as zabsf_pp026
       where areaid eq @inputobj-areaid
         and werks  eq @inputobj-werks
         and arbpl  eq @arbpl.
      if sy-subrc eq 0.
*    Operation completed successfully
        loop at reason_tab into data(ls_reason_str).
          read table lt_defects_tab transporting no fields with key defectid = ls_reason_str-grund.
          if sy-subrc ne 0.
            delete reason_tab.
          endif.
        endloop.
      else.
*    No defects found
        refresh reason_tab.
        call method zabsf_pp_cl_log=>add_message
          exporting
            msgty      = 'E'
            msgno      = '032'
            msgv1      = inputobj-areaid
            msgv2      = arbpl
            msgv3      = inputobj-werks
          changing
            return_tab = return_tab.
      endif.

    else.
*    No reason found
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgty      = 'E'
          msgno      = '033'
          msgv1      = inputobj-werks
        changing
          return_tab = return_tab.
    endif.
  endif.
endmethod.


METHOD get_operator_rework.
  DATA lref_sf_operator TYPE REF TO zif_absf_pp_operator.

  DATA ld_class TYPE recaimplclname.

*Get class of interface
  SELECT SINGLE imp_clname
      FROM zabsf_pp003
      INTO ld_class
     WHERE werks EQ inputobj-werks
       AND id_class EQ '3'
       AND endda GE refdt
       AND begda LE refdt.

  TRY .
      CREATE OBJECT lref_sf_operator TYPE (ld_class)
        EXPORTING
          initial_refdt = refdt
          input_object  = inputobj.

    CATCH cx_sy_create_object_error.
*    No data for object in customizing table
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'E'
          msgno      = '019'
          msgv1      = ld_class
        CHANGING
          return_tab = return_tab.

      EXIT.
  ENDTRY.

*Get operator rework
  CALL METHOD lref_sf_operator->get_operator
    EXPORTING
      arbpl        = arbpl
      aufnr        = aufnr
      vornr        = vornr
      tipord       = tipo_ordem
    CHANGING
      operator_tab = operator_tab
      return_tab   = return_tab.
ENDMETHOD.


METHOD set_quantity_rework.
  DATA: it_timetickets TYPE TABLE OF bapi_pp_timeticket,
        it_rework_temp TYPE TABLE OF ty_rework_temp,
*        it_header      TYPE TABLE OF bapi_order_header1,
        detail_return  TYPE TABLE OF bapi_coru_return.

  DATA: wa_rework_temp   TYPE ty_rework_temp,
        wa_timetickets   TYPE bapi_pp_timeticket,
        wa_zabsf_pp004   TYPE zabsf_pp004,
        ls_zabsf_pp017   TYPE zabsf_pp017,
        wa_zabsf_pp034   TYPE zabsf_pp034,
        propose          TYPE bapi_pp_conf_prop,
        wa_detail_return TYPE bapi_coru_return,
*        order_objects    TYPE bapi_pp_order_objects,
*        orderdata        TYPE bapi_pp_order_change,
*        orderdatax       TYPE bapi_pp_order_changex,
*        wa_header        TYPE bapi_order_header1,
        return           TYPE bapiret2,
        ls_return        TYPE bapiret1,
        ld_plnnr         TYPE plnnr,
        ld_auart         TYPE aufart,
        ld_objid         TYPE cr_objid,
        ld_seqid         TYPE zabsf_pp_e_seqid,
        ld_shiftid       TYPE zabsf_pp_e_shiftid,
        lv_reverse       TYPE ru_lmnga,
        lv_lmnga         TYPE ru_lmnga,
        lv_rmnga         TYPE ru_rmnga,
        lv_xmnga         TYPE ru_xmnga.

  CONSTANTS c_opt TYPE zabsf_pp_e_areaid VALUE 'OPT'.

  REFRESH it_timetickets.

  CLEAR: wa_timetickets,
         ls_zabsf_pp017,
         ld_shiftid.

  TRANSLATE inputobj-oprid TO UPPER CASE. "CLS 16.06.2015
*Get shift witch operator is associated
  SELECT SINGLE shiftid
    FROM zabsf_pp052
    INTO ld_shiftid
   WHERE areaid EQ inputobj-areaid
     AND oprid EQ inputobj-oprid.

  IF sy-subrc NE 0.
*  Operator is not associated with shift
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'E'
        msgno      = '061'
        msgv1      = inputobj-oprid
      CHANGING
        return_tab = return_tab.

    EXIT.
  ENDIF.

  IF rework_qty IS NOT INITIAL AND defectid IS INITIAL.
*  Must be filled obligatory fields
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'E'
        msgno      = '025'
      CHANGING
        return_tab = return_tab.
  ENDIF.

  IF aufnr IS NOT INITIAL.
*  Get sequence for save new data
    SELECT MAX( seqid )
      FROM zabsf_pp004
      INTO ld_seqid
     WHERE aufnr EQ aufnr.

    ADD 1 TO ld_seqid.

*  Save quantity and scrap quantity of production order
*  Fill data to timeticket
    wa_timetickets-orderid = aufnr.
    wa_timetickets-operation = vornr.

    APPEND wa_timetickets TO it_timetickets.

    CLEAR wa_timetickets.

    IF it_timetickets[] IS NOT INITIAL.
*    Propose data for quantity
      propose-quantity = 'X'.

      CALL FUNCTION 'BAPI_PRODORDCONF_GET_TT_PROP'
        EXPORTING
          propose     = propose
        IMPORTING
          return      = ls_return
        TABLES
          timetickets = it_timetickets.

      LOOP AT it_timetickets INTO wa_timetickets.
        CLEAR wa_zabsf_pp004.

        wa_timetickets-ex_created_by = inputobj-oprid.
        wa_timetickets-kaptprog = ld_shiftid.

*      Check if fields scrap_qty, rework_qty and defectid was filled
        IF scrap_qty IS NOT INITIAL AND grund IS NOT INITIAL.
          CLEAR wa_timetickets-yield.
*        Insert data for confirmation of scrap quantity
          wa_timetickets-scrap = scrap_qty.
          wa_timetickets-dev_reason = grund.

*          APPEND wa_timetickets TO it_timetickets.
          MODIFY it_timetickets FROM wa_timetickets.
        ELSEIF rework_qty IS NOT INITIAL AND defectid IS NOT INITIAL.
          CLEAR wa_timetickets-yield.
*        Insert data for confirmation of rework quantity
          wa_timetickets-rework = rework_qty.

*          APPEND wa_timetickets TO it_timetickets.
          MODIFY it_timetickets FROM wa_timetickets.

*        Save defectid of rework
          wa_zabsf_pp004-seqid = ld_seqid.
          wa_zabsf_pp004-aufnr = aufnr.
          wa_zabsf_pp004-defectid = defectid.
          wa_zabsf_pp004-rework = rework_qty.
          wa_zabsf_pp004-vorme = wa_timetickets-conf_quan_unit.
          wa_zabsf_pp004-oprid = inputobj-oprid.
          wa_zabsf_pp004-data = sy-datum.
          wa_zabsf_pp004-timer = sy-uzeit.

          INSERT INTO zabsf_pp004 VALUES wa_zabsf_pp004.

          IF sy-subrc NE 0.
*          Operation completed successfully
            CALL METHOD zabsf_pp_cl_log=>add_message
              EXPORTING
                msgty      = 'E'
                msgno      = '012'
              CHANGING
                return_tab = return_tab.
          ENDIF.
        ELSEIF ( rework_qty IS NOT INITIAL AND defectid IS NOT INITIAL ) AND
               ( scrap_qty IS NOT INITIAL AND grund IS NOT INITIAL ).

          CLEAR wa_timetickets-yield.
*        Insert data for confirmation of rework quantity and scrap quantity
          wa_timetickets-scrap = scrap_qty.
          wa_timetickets-dev_reason = grund.
          wa_timetickets-rework = rework_qty.

*          APPEND wa_timetickets TO it_timetickets.
          MODIFY it_timetickets FROM wa_timetickets.

*        Save defectid of rework
          wa_zabsf_pp004-seqid = ld_seqid.
          wa_zabsf_pp004-aufnr = aufnr.
          wa_zabsf_pp004-defectid = defectid.
          wa_zabsf_pp004-rework = rework_qty.
          wa_zabsf_pp004-vorme = wa_timetickets-conf_quan_unit.
          wa_zabsf_pp004-oprid = inputobj-oprid.
          wa_zabsf_pp004-data = sy-datum.
          wa_zabsf_pp004-timer = sy-uzeit.

          INSERT INTO zabsf_pp004 VALUES wa_zabsf_pp004.

          IF sy-subrc NE 0.
*          Operation completed successfully
            CALL METHOD zabsf_pp_cl_log=>add_message
              EXPORTING
                msgty      = 'E'
                msgno      = '012'
              CHANGING
                return_tab = return_tab.
          ENDIF.
        ENDIF.
      ENDLOOP.

*    Create confirmation
      CALL FUNCTION 'BAPI_PRODORDCONF_CREATE_TT'
        IMPORTING
          return        = ls_return
        TABLES
          timetickets   = it_timetickets
          detail_return = detail_return.

      IF ls_return IS INITIAL.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = 'X'.

        IF flag_scrap_list IS NOT INITIAL AND inputobj-areaid EQ c_opt.
          CLEAR wa_zabsf_pp034.

          wa_zabsf_pp034-areaid = inputobj-areaid.
          wa_zabsf_pp034-wareid = 'SAP'.
          wa_zabsf_pp034-matnr = matnr.
          wa_zabsf_pp034-grund = grund.
          wa_zabsf_pp034-scrap_qty = scrap_qty * ( -1 ).
          wa_zabsf_pp034-data = refdt.
          wa_zabsf_pp034-time = sy-uzeit.
          wa_zabsf_pp034-oprid = inputobj-oprid.

*<< PAP - 01.04.2015 - Adicionar unidade de medida - GMEIN
          SELECT SINGLE meins
            FROM mara
            INTO wa_zabsf_pp034-gmein
           WHERE matnr EQ matnr.
*>> PAP - 01.04.2015 - Adicionar unidade de medida - GMEIN

          INSERT zabsf_pp034 FROM wa_zabsf_pp034.

          IF sy-subrc EQ 0.
*            Operation completed successfully
            CALL METHOD zabsf_pp_cl_log=>add_message
              EXPORTING
                msgty      = 'S'
                msgno      = '013'
              CHANGING
                return_tab = return_tab.
          ELSE.
*            Operation not completed successfully
            CALL METHOD zabsf_pp_cl_log=>add_message
              EXPORTING
                msgty      = 'E'
                msgno      = '012'
              CHANGING
                return_tab = return_tab.

            CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
          ENDIF.
        ENDIF.


        IF defectid IS NOT INITIAL AND rework_qty IS NOT INITIAL.
*        Update quantity of rework order
          CALL METHOD me->update_order_rework
            EXPORTING
              arbpl        = arbpl
              matnr        = matnr
              defectid     = defectid
              flag_create  = flag_create
              rework_qty   = rework_qty
            CHANGING
              aufnr_rework = aufnr_rework
              return_tab   = return_tab.
        ENDIF.

        IF rework_qty IS NOT INITIAL OR scrap_qty IS NOT INITIAL.
          CLEAR: lv_reverse,
                 lv_lmnga,
                 lv_rmnga,
                 lv_xmnga.

*        Get value in Database
          SELECT SINGLE *
            FROM zabsf_pp017
            INTO CORRESPONDING FIELDS OF ls_zabsf_pp017
           WHERE aufnr EQ aufnr
             AND matnr EQ matnr
             AND vornr EQ vornr.

          IF sy-subrc EQ 0.

            READ TABLE detail_return INTO wa_detail_return WITH KEY message_v1 = aufnr.

            IF sy-subrc EQ 0.
              IF wa_detail_return-conf_no IS NOT INITIAL.
*              Reverse quantity
                SELECT SUM( lmnga )
                  FROM afru
                  INTO lv_reverse
                 WHERE rueck EQ wa_detail_return-conf_no
                   AND aufnr EQ aufnr
                   AND stokz NE space
                   AND stzhl NE space.

*              Get data
                SELECT SUM( lmnga ) SUM( rmnga ) SUM( xmnga )
                  FROM afru
                  INTO (lv_lmnga, lv_rmnga, lv_xmnga)
                 WHERE rueck EQ wa_detail_return-conf_no
                   AND aufnr EQ aufnr
                   AND stokz EQ space
                   AND stzhl EQ space.

*              Update missing quantity
*                ls_ZABSF_PP017-missingqty = ls_ZABSF_PP017-missingqty - rework_qty - scrap_qty.
                ls_zabsf_pp017-missingqty = ls_zabsf_pp017-gamng - lv_lmnga - lv_rmnga - lv_xmnga - lv_reverse.

*              Update database
                UPDATE zabsf_pp017 FROM ls_zabsf_pp017.

              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
      ELSE.
        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

*      Details of operation
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
      ENDIF.
    ENDIF.
  ELSE.
*  Update rework order
    CALL METHOD me->update_order_rework
      EXPORTING
        arbpl        = arbpl
        matnr        = matnr
        defectid     = defectid
        flag_create  = flag_create
        rework_qty   = rework_qty
      CHANGING
        aufnr_rework = aufnr_rework
        return_tab   = return_tab.
  ENDIF.
ENDMETHOD.


  method set_quantity_scrap.
*  Internal tables
    data: lt_timetickets_prop        type table of bapi_pp_timeticket,
          lt_goodsmovements_prop     type table of bapi2017_gm_item_create,
          lt_link_conf_goodsmov_prop type table of bapi_link_conf_goodsmov,
          lt_timetickets             type table of bapi_pp_timeticket,
          lt_goodsmovements          type table of bapi2017_gm_item_create,
          lt_link_conf_goodsmov      type table of bapi_link_conf_goodsmov,
          lt_detail_return           type table of bapi_coru_return,
          lt_charg_temp              type zabsf_pp_t_batch_consumption,
          lt_return_tab2             type bapiret2_t.

*  Structures
    data: ls_timetickets_prop   type bapi_pp_timeticket,
          ls_timetickets        type bapi_pp_timeticket,
          ls_goodsmovements     type bapi2017_gm_item_create,
          ls_link_conf_goodsmov type bapi_link_conf_goodsmov,
          ls_propose            type bapi_pp_conf_prop,
          ls_zabsf_pp004        type zabsf_pp004,
          ls_return             type bapiret1,
          ls_return_conf        type bapiret2,
          ls_return_tab         type bapiret2,
          ls_conf_data          type zabsf_pp_s_conf_adit_data,
          ls_charg_temp         type zabsf_pp_s_batch_consumption,
          ls_conf_tab           type zabsf_pp_s_confirmation.

*  Reference
    data: lref_sf_prdord type ref to zabsf_pp_cl_prdord.

*  Variables
    data: l_flag type flag.
    data: l_error.
*  Constants
    constants: c_move_typ   type bwart  value '261',
               c_inspection type aufart value 'ZINS'.

    refresh lt_timetickets_prop.

    clear: ls_timetickets_prop.


* Create Object
    create object lref_sf_prdord
      exporting
        initial_refdt = refdt
        input_object  = inputobj.



*  Upper case operator
    translate inputobj-oprid to upper case.

*  User
    if inputobj-pernr is initial.
      inputobj-pernr = inputobj-oprid.
    endif.

    if backoffice is initial.
*    Get shift witch operator is associated
      select single shiftid
        from zabsf_pp052
        into (@data(l_shiftid))
       where areaid eq @inputobj-areaid
         and oprid  eq @inputobj-oprid.

      if sy-subrc ne 0.
*      Operator is not associated with shift
        call method zabsf_pp_cl_log=>add_message
          exporting
            msgty      = 'E'
            msgno      = '061'
            msgv1      = inputobj-oprid
          changing
            return_tab = return_tab.

        exit.
      endif.
    else.
*    Shift ID
      l_shiftid = shiftid.
    endif.

*  Check lenght of time
    data(l_lengh) = strlen( inputobj-timeconf ).

    data(l_wait) = 20.

    if l_lengh lt 6.
      concatenate '0' inputobj-timeconf into data(l_time).
    else.
      l_time = inputobj-timeconf - l_wait.
    endif.

*  Save quantity of rework
    if rework_qty is not initial and defectid is initial.
*    Must be filled obligatory fields
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgty      = 'E'
          msgno      = '025'
        changing
          return_tab = return_tab.
    endif.

    if aufnr is not initial.
*    Get sequence for save new data
      select max( seqid )
        from zabsf_pp004
        into (@data(l_seqid))
       where aufnr eq @aufnr.

      add 1 to l_seqid.

*    Save quantity and scrap quantity of production order
*    Fill data to timeticket
      ls_timetickets_prop-orderid = aufnr.
      ls_timetickets_prop-operation = vornr.
      ls_timetickets_prop-scrap = scrap_qty.

      append ls_timetickets_prop to lt_timetickets_prop.

      if lt_timetickets_prop[] is not initial.
*      Propose data for quantity
*        ls_propose-quantity = abap_true.
        ls_propose-goodsmovement = abap_true.

        call function 'BAPI_PRODORDCONF_GET_TT_PROP'
          exporting
            propose            = ls_propose
          importing
            return             = ls_return
          tables
            timetickets        = lt_timetickets_prop
            goodsmovements     = lt_goodsmovements_prop
            link_conf_goodsmov = lt_link_conf_goodsmov_prop
            detail_return      = lt_detail_return.

        if ls_return is not initial.
*          Message error
          append ls_return to return_tab.

          loop at lt_detail_return into data(ls_detail_return).
            if ( ls_detail_return-type ne 'I' and ls_detail_return-type ne 'S' ).
              clear ls_return_conf.

              ls_return_conf-type = ls_detail_return-type.
              ls_return_conf-id = ls_detail_return-id.
              ls_return_conf-number = ls_detail_return-number.
              ls_return_conf-message = ls_detail_return-message.
              ls_return_conf-message_v1 = ls_detail_return-message_v1.
              ls_return_conf-message_v2 = ls_detail_return-message_v2.
              ls_return_conf-message_v3 = ls_detail_return-message_v3.
              ls_return_conf-message_v4 = ls_detail_return-message_v4.

              append ls_return_conf to return_tab.
            endif.
          endloop.
        endif.

        clear ls_timetickets_prop.
        refresh lt_timetickets.

        loop at lt_timetickets_prop into ls_timetickets_prop.
          clear ls_zabsf_pp004.

*        Move same fields
          move-corresponding ls_timetickets_prop to ls_timetickets.

*        Record date
          if inputobj-dateconf is not initial.
            ls_timetickets-exec_start_date = ls_timetickets-exec_fin_date = inputobj-dateconf.
            ls_timetickets-postg_date = inputobj-dateconf.
          endif.

*        Record time
          if l_time is not initial.
            ls_timetickets-exec_start_time = ls_timetickets-exec_fin_time = l_time.
          endif.

*        Counter Number of employees in Production Order
          select count( * )
            from zabsf_pp014
            into (@data(l_nr_operator))
           where arbpl  eq @arbpl
             and aufnr  eq @ls_timetickets-orderid
             and vornr  eq @ls_timetickets-operation
             and tipord eq 'N'
             and status eq 'A'.

          if l_nr_operator is not initial.
*          Number of employees
            ls_timetickets-no_of_employee = l_nr_operator.
          endif.

*        User and shift
          ls_timetickets-ex_created_by = inputobj-oprid.
          ls_timetickets-kaptprog = l_shiftid.

*        Check if fields scrap_qty, rework_qty and defectid was filled
          if scrap_qty is not initial and grund is not initial.
            clear ls_timetickets-yield.

*          Insert data for confirmation of scrap quantity
            ls_timetickets-scrap = scrap_qty.
            ls_timetickets-dev_reason = grund.

*          Add quantity scrap to confirm
            append ls_timetickets to lt_timetickets.
          elseif rework_qty is not initial and defectid is not initial.
            clear ls_timetickets-yield.

*          Insert data for confirmation of rework quantity
            ls_timetickets-rework = rework_qty.

*          Add quantity rework to confirm
            append ls_timetickets to lt_timetickets.

*          Save defectid of rework
*            INSERT INTO zabsf_pp004 VALUES @( VALUE #( seqid    = l_seqid
*                                                        aufnr    = aufnr
*                                                        defectid = defectid
*                                                        rework   = rework_qty
*                                                        vorme    = ls_timetickets-conf_quan_unit
*                                                        oprid    = inputobj-oprid
*                                                        data     = inputobj-dateconf
*                                                        timer    = l_time ) ).
            ls_zabsf_pp004-seqid    = l_seqid.
            ls_zabsf_pp004-aufnr    = aufnr.
            ls_zabsf_pp004-defectid = defectid.
            ls_zabsf_pp004-rework   = rework_qty.
            ls_zabsf_pp004-vorme    = ls_timetickets-conf_quan_unit.
            ls_zabsf_pp004-oprid    = inputobj-oprid.
            ls_zabsf_pp004-data     = inputobj-dateconf.
            ls_zabsf_pp004-timer    = l_time.
            insert into zabsf_pp004 values ls_zabsf_pp004.

            if sy-subrc ne 0.
*            Operation completed successfully
              call method zabsf_pp_cl_log=>add_message
                exporting
                  msgty      = 'E'
                  msgno      = '012'
                changing
                  return_tab = return_tab.
            endif.
          elseif ( rework_qty is not initial and defectid is not initial ) and
                 ( scrap_qty is not initial and grund is not initial ).

            clear ls_timetickets-yield.

*          Insert data for confirmation of rework quantity and scrap quantity
            ls_timetickets-scrap = scrap_qty.
            ls_timetickets-dev_reason = grund.
            ls_timetickets-rework = rework_qty.

            append ls_timetickets to lt_timetickets.

*          Save defectid of rework
*            INSERT INTO zabsf_pp004 VALUES @( VALUE #( seqid    = l_seqid
*                                                        aufnr    = aufnr
*                                                        defectid = defectid
*                                                        rework   = rework_qty
*                                                        vorme    = ls_timetickets-conf_quan_unit
*                                                        oprid    = inputobj-oprid
*                                                        data     = inputobj-dateconf
*                                                        timer    = l_time ) ).
            ls_zabsf_pp004-seqid    = l_seqid.
            ls_zabsf_pp004-aufnr    = aufnr.
            ls_zabsf_pp004-defectid = defectid.
            ls_zabsf_pp004-rework   = rework_qty.
            ls_zabsf_pp004-vorme    = ls_timetickets-conf_quan_unit.
            ls_zabsf_pp004-oprid    = inputobj-oprid.
            ls_zabsf_pp004-data     = inputobj-dateconf.
            ls_zabsf_pp004-timer    = l_time.
            insert into zabsf_pp004 values ls_zabsf_pp004.
            if sy-subrc ne 0.
*            Operation completed successfully
              call method zabsf_pp_cl_log=>add_message
                exporting
                  msgty      = 'E'
                  msgno      = '012'
                changing
                  return_tab = return_tab.
            endif.
          endif.
        endloop.

*      Create data to goods movements
        if lt_goodsmovements_prop[] is not initial.
          if charg_t[] is initial.
*          Get batches consumption
            select *
              from zabsf_pp069
              into table @data(lt_pp_sf069)
             where werks eq @inputobj-werks
               and aufnr eq @aufnr
               and vornr eq @vornr.

            if lt_pp_sf069[] is not initial.
              loop at lt_pp_sf069 into data(ls_pp_sf069).
                clear ls_charg_temp.

                ls_charg_temp-charg = ls_pp_sf069-batch.

                move-corresponding ls_pp_sf069 to ls_charg_temp.

                append ls_charg_temp to lt_charg_temp.
              endloop.
            else.
              "BMR COMMENT - not used!
*            No indication of batch of consumption in the previous screen
*              CALL METHOD zabsf_pp_cl_log=>add_message
*                EXPORTING
*                  msgty      = 'E'
*                  msgno      = '087'
*                CHANGING
*                  return_tab = return_tab.
*
*              EXIT.
            endif.
          else.
            lt_charg_temp[] = charg_t[].
          endif.

          loop at lt_charg_temp into data(ls_charg).
*>> BMR INSERT - add leading zeros to batch number.
            call function 'CONVERSION_EXIT_ALPHA_INPUT'
              exporting
                input  = ls_charg-charg
              importing
                output = ls_charg-charg.
*<< BMR END INSERT

            loop at lt_goodsmovements_prop into data(ls_goodsmovements_prop) where material  eq ls_charg-matnr
                                                                               and move_type eq c_move_typ.
              clear ls_goodsmovements.

*            Move same fields to output table
              move-corresponding ls_goodsmovements_prop to ls_goodsmovements.

*            Batch consumption
              ls_goodsmovements-batch = ls_charg-charg.

*            Append to output table
              append ls_goodsmovements to lt_goodsmovements.
            endloop.
          endloop.
        endif.



        if ( backoffice is initial ).
          clear l_error.
*        Check validation for Consumption batchs
          call method lref_sf_prdord->check_available_stock
            exporting
              areaid             = 'PP01'
              arbpl              = arbpl
              aufnr              = aufnr
              goodsmovements_tab = lt_goodsmovements
              is_scrap           = 'X'
            importing
              msg_error          = l_error
*             return_tab         = return_tab
              return_tab         = lt_return_tab2.

*        Exit if exist errors
          if l_error is not initial.
**         Send error msg to Shopfloor
            move lt_return_tab2[] to return_tab[].
            exit.
          else.
**         Send success msg to Shopfloor
            read table lt_return_tab2 transporting no fields
                                      with key type = 'S'.
            if ( sy-subrc = 0 ).
              move lt_return_tab2[] to return_tab[].
            endif.
          endif.
        endif.


*      Link to confirmation of good movement
        if lt_link_conf_goodsmov_prop[] is not initial.
*        Remove line for movement type 101
          describe table lt_goodsmovements lines data(l_lines_f).
          describe table lt_goodsmovements_prop lines data(l_lines_p).

          if l_lines_f ne l_lines_p.
            delete lt_link_conf_goodsmov_prop index l_lines_p.
          endif.

          loop at lt_link_conf_goodsmov_prop into data(ls_link_conf_goodsmov_prop).
*          Move same fields to output table
            move-corresponding ls_link_conf_goodsmov_prop to ls_link_conf_goodsmov.

*          Append to output table
            append ls_link_conf_goodsmov to lt_link_conf_goodsmov.
          endloop.
        endif.

*      Free lock
        call function 'DEQUEUE_ALL'.

*      Create confirmation
        call function 'BAPI_PRODORDCONF_CREATE_TT'
          exporting
            post_wrong_entries = '2'
          importing
            return             = ls_return
          tables
            timetickets        = lt_timetickets
            goodsmovements     = lt_goodsmovements
            link_conf_goodsmov = lt_link_conf_goodsmov
            detail_return      = lt_detail_return.

        if ls_return is initial.
*        Save data
          call function 'BAPI_TRANSACTION_COMMIT'
            exporting
              wait = 'X'.

          if defectid is not initial and rework_qty is not initial.
            wait up to 2 seconds.

*          Update quantity of rework order
            call method me->update_order_rework
              exporting
                arbpl        = arbpl
                matnr        = matnr
                defectid     = defectid
                flag_create  = flag_create
                rework_qty   = rework_qty
              changing
                aufnr_rework = aufnr_rework
                return_tab   = return_tab.
          endif.

          if rework_qty is not initial or scrap_qty is not initial.
*          Check is material is initial
            if matnr is initial.
*             Get material from Production Order
              select single plnbez, stlbez
                from afko
                into (@data(l_plnbez), @data(l_stlbez))
               where aufnr eq @aufnr.

*            Material
              if l_plnbez is not initial.
                data(l_matnr) = l_plnbez.
              else.
                l_matnr = l_stlbez.
              endif.
            else.
              l_matnr = matnr.
            endif.

*          Get value in Database
            select single *
              from zabsf_pp017
              into @data(ls_zabsf_pp017)
             where aufnr eq @aufnr
               and matnr eq @l_matnr
               and vornr eq @vornr.

            if sy-subrc eq 0.
              clear ls_detail_return.

*            Read number of confirmation
              loop at lt_detail_return into ls_detail_return where message_v1 = aufnr.
                clear ls_return_tab.

                ls_return_tab-type = ls_detail_return-type.
                ls_return_tab-id = ls_detail_return-id.
                ls_return_tab-number = ls_detail_return-number.
                ls_return_tab-message = ls_detail_return-message.
                ls_return_tab-message_v1 = ls_detail_return-message_v1.
                ls_return_tab-message_v2 = ls_detail_return-message_v2.
                ls_return_tab-message_v3 = ls_detail_return-message_v3.
                ls_return_tab-message_v4 = ls_detail_return-message_v4.

                append ls_return_tab to return_tab.

                if ls_detail_return-conf_no is not initial and ( ls_detail_return-type eq 'I' or ls_detail_return-type eq 'S' ).
                  clear ls_conf_tab.

*                Confirmation number
                  ls_conf_tab-conf_no = ls_detail_return-conf_no.
                  ls_conf_tab-conf_cnt = ls_detail_return-conf_cnt.
*                Confirmation counter
                  append ls_conf_tab to conf_tab.

*                Check if was inspection order
                  select single @abap_true
                    from aufk
                    into @data(l_exist)
                   where aufnr eq @aufnr
                     and auart eq @c_inspection.

                  if l_exist eq abap_true.
*                  Change status
                    call function 'Z_PP02_CHANGE_STATUS'
                      exporting
                        iv_rueck = ls_detail_return-conf_no
                        iv_rmzhl = ls_detail_return-conf_cnt
                        iv_oprid = inputobj-oprid
                      importing
                        ev_flag  = l_flag.
                  endif.

*                Reverse quantity
                  select sum( lmnga )
                    from afru
                    into (@data(l_reverse))
                   where rueck eq @ls_detail_return-conf_no
                     and aufnr eq @aufnr
                     and stokz ne @space
                     and stzhl ne @space.

*                Get data of quantities
                  select sum( lmnga ), sum( rmnga ), sum( xmnga )
                    from afru
                    into (@data(l_lmnga), @data(l_rmnga), @data(l_xmnga))
                   where rueck eq @ls_detail_return-conf_no
                     and aufnr eq @aufnr
                     and stokz eq @space
                     and stzhl eq @space.

**                Update missing quantity
*                  ls_ZABSF_PP017-missingqty = ls_ZABSF_PP017-gamng - l_lmnga - l_rmnga - l_xmnga - l_reverse.

*                Update database
*                  update zabsf_pp017 from @( value #( base ls_zabsf_pp017 missingqty = ls_zabsf_pp017-gamng - l_lmnga - l_rmnga - l_reverse ) ).
                    ls_zabsf_pp017-missingqty = ls_zabsf_pp017-gamng - l_lmnga - l_rmnga - l_reverse.
                    update zabsf_pp017 from ls_zabsf_pp017.
*                  UPDATE ZABSF_PP017 FROM @( VALUE #( BASE ls_ZABSF_PP017 missingqty = ls_ZABSF_PP017-gamng - l_lmnga - l_rmnga - l_xmnga - l_reverse ) ).

*                Save additional data of confirmation
*                Work center
                  ls_conf_data-arbpl = arbpl.
*                Production order
                  ls_conf_data-aufnr = aufnr.
*                Production order operation
                  ls_conf_data-vornr = vornr.
*                Confirmation number
                  ls_conf_data-conf_no = ls_detail_return-conf_no.
*                Confirmation counter
                  ls_conf_data-conf_cnt = ls_detail_return-conf_cnt.
*                Cycle number
                  ls_conf_data-numb_cycle = numb_cycle.
*                Card
                  select single ficha
                    from zabsf_pp066
                    into @ls_conf_data-ficha
                   where werks eq @inputobj-werks
                     and aufnr eq @aufnr
                     and vornr eq @vornr.

*                Shift ID
                  ls_conf_data-shiftid = l_shiftid.

                  if lref_sf_prdord is not bound.
*                  Create object
                    create object lref_sf_prdord
                      exporting
                        initial_refdt = refdt
                        input_object  = inputobj.
                  endif.

*                Save aditional data of confirmation
                  call method lref_sf_prdord->save_data_confirmation
                    exporting
                      is_conf_data = ls_conf_data
                    changing
                      return_tab   = return_tab.
                endif.
              endloop.
            endif.
          endif.
        else.
*        Return data
          call function 'BAPI_TRANSACTION_ROLLBACK'.

*        Details of operation
          loop at lt_detail_return into ls_detail_return.
            clear ls_return_tab.

            ls_return_tab-type = ls_detail_return-type.
            ls_return_tab-id = ls_detail_return-id.
            ls_return_tab-number = ls_detail_return-number.
            ls_return_tab-message = ls_detail_return-message.
            ls_return_tab-message_v1 = ls_detail_return-message_v1.
            ls_return_tab-message_v2 = ls_detail_return-message_v2.
            ls_return_tab-message_v3 = ls_detail_return-message_v3.
            ls_return_tab-message_v4 = ls_detail_return-message_v4.

            append ls_return_tab to return_tab.
          endloop.
        endif.
      endif.
    else.
*    Update rework order
      call method me->update_order_rework
        exporting
          arbpl        = arbpl
          matnr        = matnr
          defectid     = defectid
          flag_create  = flag_create
          rework_qty   = rework_qty
        changing
          aufnr_rework = aufnr_rework
          return_tab   = return_tab.
    endif.
  endmethod.


METHOD SET_REFDT.
*Set new reference date
  refdt = new_refdt.
ENDMETHOD.


METHOD update_order_rework.
  DATA: it_header TYPE TABLE OF bapi_order_header1.

  DATA: order_objects TYPE bapi_pp_order_objects,
        wa_header     TYPE bapi_order_header1,
        orderdata     TYPE bapi_pp_order_change,
        orderdatax    TYPE bapi_pp_order_changex,
        return        TYPE bapiret2.

  REFRESH it_header.

  CLEAR: order_objects,
         wa_header,
         orderdata,
         orderdatax,
         return.

  IF flag_create EQ 'X' AND rework_qty IS NOT INITIAL AND defectid IS NOT INITIAL.
*  Create rework order
    CALL METHOD me->create_order_rework
      EXPORTING
        arbpl      = arbpl
        matnr      = matnr
        defectid   = defectid
        rework_qty = rework_qty
      CHANGING
        return_tab = return_tab.
  ENDIF.

*Check if exist Rework Order
  IF rework_qty IS NOT INITIAL AND defectid IS NOT INITIAL AND aufnr_rework IS NOT INITIAL.
*  Header detail of rework order
    order_objects-header = 'X'.

*  Get details of rework order
    CALL FUNCTION 'BAPI_PRODORD_GET_DETAIL'
      EXPORTING
        number        = aufnr_rework
        order_objects = order_objects
      IMPORTING
        return        = return
      TABLES
        header        = it_header.

    IF return IS NOT INITIAL.
      APPEND return TO return_tab.
    ENDIF.

    IF it_header[] IS NOT INITIAL.
*    Header details of rework order
      READ TABLE it_header INTO wa_header INDEX 1.

*    Rework Quantity and details
      orderdatax-quantity = 'X'.
      orderdata-quantity = wa_header-target_quantity + rework_qty.

      CLEAR return.

*    Change scrap quantity and quantity of rework order
      CALL FUNCTION 'BAPI_PRODORD_CHANGE'
        EXPORTING
          number     = wa_header-order_number
          orderdata  = orderdata
          orderdatax = orderdatax
        IMPORTING
          return     = return.

      IF return IS NOT INITIAL.
        APPEND return TO return_tab.

        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      ELSE.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = 'X'.

        CALL METHOD zabsf_pp_cl_log=>add_message
          EXPORTING
            msgty      = 'S'
            msgno      = '029'
            msgv1      = wa_header-order_number
          CHANGING
            return_tab = return_tab.
      ENDIF.
    ENDIF.
  ENDIF.
ENDMETHOD.
ENDCLASS.
