class ZABSF_PP_CL_OPERATOR definition
  public
  final
  create public .

public section.

  interfaces ZIF_ABSF_PP_OPERATOR .

  methods CONSTRUCTOR
    importing
      !INITIAL_REFDT type VVDATUM
      !INPUT_OBJECT type ZABSF_PP_S_INPUTOBJECT .
  class-methods CHECK_IF_OPERATOR_IS_ASSGINED
    importing
      !ARBPL type ARBPL
      !AUFNR type AUFNR
      !VORNR type VORNR
      !OPERATOR_TAB type ZABSF_PP_T_OPERADOR
    exporting
      !E_ERROR type BOOLE_D
    changing
      !RETURN_TAB type BAPIRET2_T .
protected section.

  constants OPRID_STATUS_INACTIVE type ZABSF_PP_E_STATUS value 'I' ##NO_TEXT.
  constants OPRID_STATUS_ACTIVE type ZABSF_PP_E_STATUS value 'A' ##NO_TEXT.
  constants C_UNIT type ZABSF_PP_E_WORKUNIT value 'MIN' ##NO_TEXT.
private section.

  data REFDT type VVDATUM .
  data INPUTOBJ type ZABSF_PP_S_INPUTOBJECT .
ENDCLASS.



CLASS ZABSF_PP_CL_OPERATOR IMPLEMENTATION.


  METHOD check_if_operator_is_assgined.

*    READ TABLE operator_tab INTO DATA(ls_operator) INDEX 1.
*
*    CHECK ls_operator-status EQ 'A'.
** Check if user is allready assigned
*    SELECT SINGLE * FROM zabsf_pp014 INTO @DATA(ls_pp014)
*        WHERE status EQ @ls_operator-status
*          AND tipord EQ 'N' "@tipord.
*          AND oprid  EQ @ls_operator-oprid.
*
*    IF sy-subrc EQ 0.
*      e_error = abap_true.
*
*      CALL METHOD zabsf_pp_cl_log=>add_message
*        EXPORTING
*          msgty      = 'E'
*          msgno      = '122'
*          msgv1      = ls_operator-oprid
*          msgv2      = ls_pp014-aufnr
*          msgv3      = ls_pp014-vornr
*        CHANGING
*          return_tab = return_tab.
*      EXIT.
*    ENDIF.

  ENDMETHOD.


METHOD CONSTRUCTOR.
*Ref. Date
  refdt = initial_refdt.

*App input data
  inputobj = input_object.
ENDMETHOD.


METHOD zif_absf_pp_operator~get_operator.
  DATA: it_func        TYPE TABLE OF zabsf_pprhfncwrk,
        wa_func        TYPE zabsf_pprhfncwrk,
        it_zabsf_pp014 TYPE TABLE OF zabsf_pp014,
        wa_zabsf_pp014 TYPE zabsf_pp014,
        wa_oprid       TYPE zabsf_pp_s_operador,
        it_ZABSF_PPRHFNC    TYPE TABLE OF zabsf_pprhfnc,
        wa_ZABSF_PPRHFNC    TYPE zabsf_pprhfnc.

*Get operator information
  SELECT *
    FROM zabsf_pprhfnc
    INTO CORRESPONDING FIELDS OF TABLE it_ZABSF_PPRHFNC.

*Get operator by work center
  SELECT n_func arbpl
    FROM zabsf_pprhfncwrk
    INTO CORRESPONDING FIELDS OF TABLE it_func
    WHERE arbpl EQ arbpl
      AND begda LE refdt
      AND endda GE refdt.

  IF it_func[] IS NOT INITIAL.
    LOOP AT it_func INTO wa_func.
      CLEAR wa_zabsf_pp014.
*    Get name of operator
      READ TABLE it_ZABSF_PPRHFNC INTO wa_ZABSF_PPRHFNC WITH KEY n_func = wa_func-n_func.
      wa_oprid-nome = wa_ZABSF_PPRHFNC-nome.

*    Number of operator
      wa_oprid-oprid = wa_func-n_func.
      SELECT SINGLE *
        FROM zabsf_pp014
        INTO CORRESPONDING FIELDS OF wa_zabsf_pp014
       WHERE oprid  EQ wa_func-n_func
         AND arbpl  EQ wa_func-arbpl
         AND aufnr  EQ aufnr
         AND vornr  EQ vornr
         AND tipord EQ tipord
         AND status EQ 'A'.

      IF wa_zabsf_pp014 IS NOT INITIAL.
*      Status
        wa_oprid-status = wa_zabsf_pp014-status.
        APPEND wa_oprid TO operator_tab.
      ENDIF.
    ENDLOOP.
  ELSE.
*  No operator for the input (Work center)
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'I'
        msgno      = '008'
      CHANGING
        return_tab = return_tab.
  ENDIF.
ENDMETHOD.


  METHOD zif_absf_pp_operator~get_operator_ord.
*  Structures
    DATA: ls_oprid       TYPE zabsf_pp_s_operador,
          ls_zabsf_pp014 TYPE zabsf_pp014.

*  Get operator associated to Production Order
    SELECT *
      FROM zabsf_pp014
      INTO TABLE @DATA(lt_zabsf_pp014)
     WHERE arbpl  EQ @arbpl
       AND aufnr  EQ @aufnr
       AND vornr  EQ @vornr
       AND tipord EQ @tipord
       AND status EQ 'A'.

*>>BMR INSERT - order operators table
    SORT lt_zabsf_pp014 BY udate utime ASCENDING.
*<<<

    IF lt_zabsf_pp014[] IS NOT INITIAL.
      LOOP AT lt_zabsf_pp014 INTO ls_zabsf_pp014.
        CLEAR ls_oprid.

*      Operator
        ls_oprid-oprid = ls_zabsf_pp014-oprid.
*        data: lv_pernr_var  type pernr_d.
*        lv_pernr_var = conv #( ls_oprid-oprid ).

*      Operator name
*        SELECT SINGLE vorna, nachn
*          FROM pa0002
*          INTO (@DATA(l_vorna), @DATA(l_nachn))
*         WHERE pernr EQ @lv_pernr_var.
*
*        IF l_vorna IS NOT INITIAL OR l_nachn IS NOT INITIAL.
**        First and last name
*          CONCATENATE l_vorna l_nachn INTO ls_oprid-nome SEPARATED BY space.
*        ENDIF.

*      Status
        ls_oprid-status = ls_zabsf_pp014-status.

        APPEND ls_oprid TO operator_tab.
      ENDLOOP.
    ELSE.
*    No operator for the input (Work center)
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'I'
          msgno      = '008'
        CHANGING
          return_tab = return_tab.
    ENDIF.
  ENDMETHOD.


METHOD zif_absf_pp_operator~get_operator_rpoint.
  DATA: it_func          TYPE TABLE OF zabsf_pprhfncwrk,
        it_zabsf_pp045   TYPE TABLE OF zabsf_pp045,
        it_zabsf_pprhfnc TYPE TABLE OF zabsf_pprhfnc.

  DATA: wa_func          TYPE zabsf_pprhfncwrk,
        wa_zabsf_pp045   TYPE zabsf_pp045,
        wa_oprid         TYPE zabsf_pp_s_operador,
        wa_zabsf_pprhfnc TYPE zabsf_pprhfnc.

*Get operator information
  SELECT *
    FROM zabsf_pprhfnc
    INTO CORRESPONDING FIELDS OF TABLE it_zabsf_pprhfnc.

*Get operator by work center
  SELECT n_func arbpl
    FROM zabsf_pprhfncwrk
    INTO CORRESPONDING FIELDS OF TABLE it_func
    WHERE arbpl EQ rpoint
      AND begda LE refdt
      AND endda GE refdt.

  IF it_func[] IS NOT INITIAL.
    LOOP AT it_func INTO wa_func.
      CLEAR wa_zabsf_pp045.
*    Get name of operator
      READ TABLE it_zabsf_pprhfnc INTO wa_zabsf_pprhfnc WITH KEY n_func = wa_func-n_func.
      wa_oprid-nome = wa_zabsf_pprhfnc-nome.

*    Number of operator
      wa_oprid-oprid = wa_func-n_func.
      SELECT SINGLE *
        FROM zabsf_pp045
        INTO CORRESPONDING FIELDS OF wa_zabsf_pp045
       WHERE oprid  EQ wa_func-n_func
         AND rpoint EQ wa_func-arbpl
         AND status EQ 'A'.

      IF wa_zabsf_pp045 IS NOT INITIAL.
*      Status
        wa_oprid-status = wa_zabsf_pp045-status.
        APPEND wa_oprid TO operator_tab.
      ENDIF.
    ENDLOOP.
  ELSE.
*  No operator for the input (Work center)
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'I'
        msgno      = '008'
      CHANGING
        return_tab = return_tab.
  ENDIF.
ENDMETHOD.


METHOD zif_absf_pp_operator~get_operator_wrkctr.
  DATA: it_func     TYPE TABLE OF zabsf_pprhfncwrk,
        wa_func     TYPE zabsf_pprhfncwrk,
        it_ZABSF_PPRHFNC TYPE TABLE OF zabsf_pprhfnc,
        wa_ZABSF_PPRHFNC TYPE zabsf_pprhfnc,
        wa_oprid    TYPE zabsf_pp_s_operador.

*Get operator information
  SELECT *
    FROM zabsf_pprhfnc
    INTO CORRESPONDING FIELDS OF TABLE it_ZABSF_PPRHFNC.

*Get operator by work center
  SELECT n_func arbpl
    FROM zabsf_pprhfncwrk
    INTO CORRESPONDING FIELDS OF TABLE it_func
    WHERE arbpl EQ arbpl
      AND begda LE refdt
      AND endda GE refdt.

  IF it_func[] IS NOT INITIAL.
    LOOP AT it_func INTO wa_func.
*    Get name of operator
      READ TABLE it_ZABSF_PPRHFNC INTO wa_ZABSF_PPRHFNC WITH KEY n_func = wa_func-n_func.
      wa_oprid-nome = wa_ZABSF_PPRHFNC-nome.

*    Number of operator
      wa_oprid-oprid = wa_func-n_func.

      APPEND wa_oprid TO oper_wrkctr_tab.
    ENDLOOP.
  ELSE.
*  No operator for the input (Work center)
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'I'
        msgno      = '008'
      CHANGING
        return_tab = return_tab.
  ENDIF.
ENDMETHOD.


method zif_absf_pp_operator~set_operator.
*Structures
  data: ls_return type bapireturn,
        lv_pernr  type pernr_d.

  data: lv_first_user type flag,
        lv_error      type flag.

*>>BMR INSERT 11.06.2018 - Check if user is working on another workcenter/order/operation.
*  CALL METHOD me->check_if_operator_is_assgined
*    EXPORTING
*      arbpl        = arbpl
*      aufnr        = aufnr
*      vornr        = vornr
*      operator_tab = operator_tab
*    IMPORTING
*      e_error      = lv_error
*    CHANGING
*      return_tab   = return_tab.
*
*  CHECK lv_error IS INITIAL.
*<<BMR INSERT 11.06.2018 - Check if user is working on another workcenter/order/operation.

*Get all data.
  "Get all active Operators in this order type
  select *
    from zabsf_pp014
    into table @data(lt_zabsf_pp014)
    where arbpl  eq @arbpl
      and aufnr  eq @aufnr
      and vornr  eq @vornr
      and status eq 'A'
      and tipord eq @tipord.

  if lt_zabsf_pp014 is initial.
    lv_first_user = abap_true.
  endif.

  "Table of type operator_tab
  " Loop in table operator type that´s contains: OPRID (ID of the operator), NOME (Nome do operador) and STATUS (Ativo ou Inativo) and put in ls_operator
  loop at operator_tab into data(ls_operator).
*  Check if personnal number exist, if the operator, person exist.
*>>EDIT BMR 27.04.2018 - check  if the operator, person exist,
*    CALL FUNCTION 'BAPI_EMPLOYEE_CHECKEXISTENCE'
*      EXPORTING
*        number = inputobj-pernr
*      IMPORTING
*        return = ls_return.

    translate ls_operator-oprid to upper case.

    "move ls_operator-oprid to lv_pernr.

*    CALL FUNCTION 'BAPI_EMPLOYEE_CHECKEXISTENCE'
*      EXPORTING
*        number = lv_pernr
*      IMPORTING
*        return = ls_return.
*<<BMR END EDIT.

    if ls_return is initial.
*    Read information from database, that we put above and the id of operator be the same that return in the Loop.
      read table lt_zabsf_pp014 into data(ls_zabsf_pp014) with key oprid = ls_operator-oprid.

      "sy-subr is component of the system, if everything ok so return 0 in sy-subrc. Then see  if the status of the operator is equal to inactive
      if sy-subrc eq 0 and ls_operator-status eq oprid_status_inactive.

*      Get number operators assigned to Production Order
        describe table lt_zabsf_pp014 lines data(l_nr_operator).

*      Get first operator assigned to Production Order
        select oprid up to 1 rows
          from zabsf_pp014
          into (@data(l_first_operator))
         where arbpl  eq @arbpl
           and aufnr  eq @aufnr
           and vornr  eq @vornr
           and status eq 'A'
           and tipord eq @tipord
         order by udate ascending, utime ascending.
        endselect.

*  Nao existe conceito de operador principal
*        IF l_first_operator EQ ls_operator-oprid AND l_nr_operator GT 1.
*
*          CALL METHOD zabsf_pp_cl_log=>add_message
*            EXPORTING
*              msgty      = 'E'
*              msgno      = '084'
*            CHANGING
*              return_tab = return_tab.
*          EXIT.
*       ELSE.
*        If exist delete entrie in database
*        delete zabsf_pp014 from @( value #( aufnr = ls_zabsf_pp014-aufnr
*                                             vornr = ls_zabsf_pp014-vornr
*                                             arbpl = ls_zabsf_pp014-arbpl
*                                             oprid = ls_zabsf_pp014-oprid ) ).

        delete zabsf_pp014 from ls_zabsf_pp014.
        if sy-subrc eq 0.
*          Save changes
          commit work and wait.

*          Operation completes successfully
          call method zabsf_pp_cl_log=>add_message
            exporting
              msgty      = 'S'
              msgno      = '013'
            changing
              return_tab = return_tab.
        else.
*          Operation not completed
          call method zabsf_pp_cl_log=>add_message
            exporting
              msgty      = 'E'
              msgno      = '012'
            changing
              return_tab = return_tab.
          exit.
        endif.
*        ENDIF.
      elseif ls_operator-status eq oprid_status_active.
        translate ls_operator-oprid to upper case.
*      If not exist insert line in database
*        insert into zabsf_pp014 values @( value #( arbpl  = arbpl
*                                                   aufnr  = aufnr
*                                                   vornr  = vornr
*                                                   oprid  = ls_operator-oprid
*                                                   status = ls_operator-status
*                                                   tipord = tipord
*                                                   udate  = sy-datum
*                                                   utime  = sy-uzeit
*                                                   kapid  = kapid  ) ).
        ls_zabsf_pp014-arbpl  = arbpl.
        ls_zabsf_pp014-aufnr  = aufnr.
        ls_zabsf_pp014-vornr  = vornr.
        ls_zabsf_pp014-oprid  = ls_operator-oprid.
        ls_zabsf_pp014-status = ls_operator-status.
        ls_zabsf_pp014-tipord = tipord.
        ls_zabsf_pp014-udate  = sy-datum.
        ls_zabsf_pp014-utime  = sy-uzeit.
        ls_zabsf_pp014-kapid  = kapid.

        insert into zabsf_pp014 values ls_zabsf_pp014.


        if sy-subrc eq 0.
*        Save changes
          commit work and wait.

*        Operation completes successfully
          call method zabsf_pp_cl_log=>add_message
            exporting
              msgty      = 'S'
              msgno      = '013'
            changing
              return_tab = return_tab.
        else.
*          Operation not completed
          call method zabsf_pp_cl_log=>add_message
            exporting
              msgty      = 'E'
              msgno      = '012'
            changing
              return_tab = return_tab.
          exit.
        endif.
      endif.
    else.
*    Operation not completed
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgty      = 'E'
          msgno      = '024'
          msgv1      = ls_operator-oprid
        changing
          return_tab = return_tab.
      exit.
    endif.
  endloop.

  " Start production on first user assgniment.
*  CHECK lv_first_user EQ abap_true.
*
*  "Re-Start production
*  actv_id = 'INIT_PRO'.
*  actionid = 'PROD'.
*  "ZABSF_PP_CL_EVENT_ACT=>SET_CONF_EVENT_TIME
*  CALL METHOD lref_sf_event_act->(l_method)
*    EXPORTING
*      arbpl       = arbpl
*      werks       = inputobj-werks
*      aufnr       = aufnr
*      vornr       = vornr
*      date        = sy-datum
*      time        = sy-uzeit
*      oprid       = oprid
*      rueck       = rueck
*      aufpl       = aufpl
*      aplzl       = aplzl
*      actv_id     = actv_id
*      stprsnid    = stprsnid
*      schedule_id = schedule_id
*      regime_id   = regime_id
*      count_ini   = count_ini
*      count_fin   = count_fin
*      backoffice  = backoffice
*      shiftid     = shiftid
*    CHANGING
*      actionid    = actionid
*      return_tab  = return_tab.
*
*  DELETE ADJACENT DUPLICATES FROM return_tab.
endmethod.


METHOD zif_absf_pp_operator~set_operator_rpoint.
  DATA: it_zabsf_pp045 TYPE TABLE OF zabsf_pp045,
        it_zabsf_pp046 TYPE TABLE OF zabsf_pp046.

  DATA: wa_zabsf_pp045 TYPE zabsf_pp045,
        wa_zabsf_pp046 TYPE zabsf_pp046,
        ls_zabsf_pp045 TYPE zabsf_pp045,
        ls_ZABSF_PPRHFNC    TYPE ZABSF_PPRHFNC,
        wa_operator    TYPE zabsf_pp_s_operador,
        ld_arbpl_id    TYPE cr_objid,
        ld_hname_ty    TYPE cr_objty,
        ld_hname_id    TYPE cr_objid,
        ld_hname       TYPE cr_hname,
        ld_shiftid     TYPE zabsf_pp_e_shiftid.

  DATA: lref_sf_time TYPE REF TO zabsf_pp_cl_event_act.

  REFRESH: it_zabsf_pp045,
           it_zabsf_pp046.

  CLEAR wa_operator.

*Create object of class time
  CREATE OBJECT lref_sf_time
    EXPORTING
      initial_refdt = refdt
      input_object  = inputobj.

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

*Get id of workcenter
  SELECT SINGLE objid
    FROM crhd
    INTO ld_arbpl_id
    WHERE arbpl EQ rpoint.

*Get hierarchy of workcenter
  SELECT SINGLE objty_hy objid_hy
    FROM crhs
    INTO (ld_hname_ty, ld_hname_id)
   WHERE objty_ho EQ 'A'         "Workcenter
     AND objid_ho EQ ld_arbpl_id.

*Get name of hierarchy
  SELECT SINGLE name
    FROM crhh
    INTO ld_hname
   WHERE objty EQ ld_hname_ty
     AND objid EQ ld_hname_id.

*Get all data
  SELECT *
    FROM zabsf_pp045
    INTO CORRESPONDING FIELDS OF TABLE it_zabsf_pp045
   WHERE "rpoint EQ rpoint AND
      status EQ 'A'.

*Get all worktime for selected operators
  SELECT *
    FROM zabsf_pp046
    INTO CORRESPONDING FIELDS OF TABLE it_zabsf_pp046
     FOR ALL ENTRIES IN operator_tab
   WHERE areaid   EQ inputobj-areaid
*     AND hname    EQ ld_hname
     AND werks    EQ inputobj-werks
     AND oprid    EQ operator_tab-oprid
     AND datesr   EQ refdt
     AND shiftid  EQ ld_shiftid
     AND endtime  EQ '000000'
     AND worktime EQ space.

  LOOP AT operator_tab INTO wa_operator.
    CLEAR: ls_ZABSF_PPRHFNC,
           wa_zabsf_pp045,
           wa_zabsf_pp046.

*  Check if operator exist in system
    SELECT SINGLE *
      FROM ZABSF_PPRHFNC
      INTO CORRESPONDING FIELDS OF ls_ZABSF_PPRHFNC
     WHERE n_func EQ wa_operator-oprid.

    IF sy-subrc EQ 0.
*    Read information from database
      READ TABLE it_zabsf_pp045 INTO wa_zabsf_pp045 WITH KEY oprid = wa_operator-oprid.

      IF sy-subrc EQ 0 AND wa_operator-status EQ oprid_status_inactive.
*      If exist delete entrie in database
        DELETE zabsf_pp045 FROM wa_zabsf_pp045.

        IF sy-subrc EQ 0.
*        Record end worktime
          READ TABLE it_zabsf_pp046 INTO wa_zabsf_pp046 WITH KEY oprid  = wa_operator-oprid
                                                                   datesr = refdt.

          IF sy-subrc EQ 0.
*          End time
            wa_zabsf_pp046-endtime = time.

*          Get work time for opertor in reporting point
            CALL METHOD lref_sf_time->calc_minutes
              EXPORTING
                date       = wa_zabsf_pp046-datesr
                time       = wa_zabsf_pp046-begtime
                proc_date  = wa_zabsf_pp046-datesr
                proc_time  = wa_zabsf_pp046-endtime
              CHANGING
                activity   = wa_zabsf_pp046-worktime
                return_tab = return_tab.

*          Time unit
            wa_zabsf_pp046-workunit = c_unit.

            UPDATE zabsf_pp046 FROM wa_zabsf_pp046.

            IF sy-subrc NE 0.
*            Operation not completed
              CALL METHOD zabsf_pp_cl_log=>add_message
                EXPORTING
                  msgty      = 'E'
                  msgno      = '012'
                CHANGING
                  return_tab = return_tab.
            ENDIF.
          ENDIF.

*        Operation completes successfully
          CALL METHOD zabsf_pp_cl_log=>add_message
            EXPORTING
              msgty      = 'S'
              msgno      = '013'
            CHANGING
              return_tab = return_tab.
        ELSE.
*        Operation not completed
          CALL METHOD zabsf_pp_cl_log=>add_message
            EXPORTING
              msgty      = 'E'
              msgno      = '012'
            CHANGING
              return_tab = return_tab.
        ENDIF.
      ELSEIF wa_operator-status EQ oprid_status_active.

*      If not exist insert line in database
*       Reporting point
        ls_zabsf_pp045-rpoint = rpoint.
*      Operator
        ls_zabsf_pp045-oprid = wa_operator-oprid.
*      Operator Status
        ls_zabsf_pp045-status = wa_operator-status.

        INSERT INTO zabsf_pp045 VALUES ls_zabsf_pp045.

        IF sy-subrc EQ 0.
*        Record start worktime
*        Area
          wa_zabsf_pp046-areaid = inputobj-areaid.
*        Hierarchy
          wa_zabsf_pp046-hname = ld_hname.
*        Plant
          wa_zabsf_pp046-werks = inputobj-werks.
*        Reporting point
          wa_zabsf_pp046-rpoint = rpoint.
*        Operator
          wa_zabsf_pp046-oprid = wa_operator-oprid.
*        Date
          wa_zabsf_pp046-datesr = refdt.
*        Star time
          wa_zabsf_pp046-begtime = time.
*        Shift
          wa_zabsf_pp046-shiftid = ld_shiftid.

          INSERT INTO zabsf_pp046 VALUES wa_zabsf_pp046.

          IF sy-subrc NE 0.
*          Operation not completed
            CALL METHOD zabsf_pp_cl_log=>add_message
              EXPORTING
                msgty      = 'E'
                msgno      = '012'
              CHANGING
                return_tab = return_tab.
          ELSE.
*          Operation completes successfully
            CALL METHOD zabsf_pp_cl_log=>add_message
              EXPORTING
                msgty      = 'S'
                msgno      = '013'
              CHANGING
                return_tab = return_tab.

            IF wa_zabsf_pp045 IS NOT INITIAL.
*            Dessociate operator
              DELETE zabsf_pp045 FROM wa_zabsf_pp045.

              IF sy-subrc EQ 0.
*              Record end worktime
                READ TABLE it_zabsf_pp046 INTO wa_zabsf_pp046 WITH KEY oprid  = wa_operator-oprid
                                                                         datesr = refdt.

                IF sy-subrc EQ 0.
*                End time
                  wa_zabsf_pp046-endtime = time.

                  IF wa_zabsf_pp046-begtime GT wa_zabsf_pp046-endtime.
                    wa_zabsf_pp046-begtime+4(2) = '00'.
                  ENDIF.

*                Get work time for opertor in reporting point
                  CALL METHOD lref_sf_time->calc_minutes
                    EXPORTING
                      date       = wa_zabsf_pp046-datesr
                      time       = wa_zabsf_pp046-begtime
                      proc_date  = refdt
                      proc_time  = wa_zabsf_pp046-endtime
                    CHANGING
                      activity   = wa_zabsf_pp046-worktime
                      return_tab = return_tab.

*                Time unit
                  wa_zabsf_pp046-workunit = c_unit.

                  UPDATE zabsf_pp046 FROM wa_zabsf_pp046.

                  IF sy-subrc NE 0.
*                  Operation not completed
                    CALL METHOD zabsf_pp_cl_log=>add_message
                      EXPORTING
                        msgty      = 'E'
                        msgno      = '012'
                      CHANGING
                        return_tab = return_tab.

                    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
                  ELSE.
*                  Operation completes successfully
                    CALL METHOD zabsf_pp_cl_log=>add_message
                      EXPORTING
                        msgty      = 'I'
                        msgno      = '060'
                        msgv1      = wa_operator-oprid
                        msgv2      = wa_zabsf_pp045-rpoint
                      CHANGING
                        return_tab = return_tab.
                  ENDIF.
                ENDIF.
              ELSE.
*            Operation not completed
                CALL METHOD zabsf_pp_cl_log=>add_message
                  EXPORTING
                    msgty      = 'E'
                    msgno      = '012'
                  CHANGING
                    return_tab = return_tab.
              ENDIF.
            ENDIF.
          ENDIF.
        ELSE.
*        Operation not completed
          CALL METHOD zabsf_pp_cl_log=>add_message
            EXPORTING
              msgty      = 'E'
              msgno      = '012'
            CHANGING
              return_tab = return_tab.
        ENDIF.
*        ENDIF.
      ENDIF.
    ELSE.
*    Operation not completed
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'E'
          msgno      = '024'
          msgv1      = wa_operator-oprid
        CHANGING
          return_tab = return_tab.
    ENDIF.
  ENDLOOP.
ENDMETHOD.


METHOD ZIF_ABSF_PP_OPERATOR~SET_REFDT.
*Set new reference date
  refdt = new_refdt.
ENDMETHOD.
ENDCLASS.
