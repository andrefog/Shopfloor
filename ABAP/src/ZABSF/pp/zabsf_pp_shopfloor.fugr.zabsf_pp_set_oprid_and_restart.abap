FUNCTION zabsf_pp_set_oprid_and_restart.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(ARBPL) TYPE  ARBPL
*"     VALUE(AUFNR) TYPE  AUFNR
*"     VALUE(VORNR) TYPE  VORNR
*"     VALUE(OPERATOR_TAB) TYPE  ZABSF_PP_T_OPERADOR
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"     VALUE(TIPO) TYPE  I
*"     VALUE(AREAID) TYPE  ZABSF_PP_E_AREAID OPTIONAL
*"     VALUE(DATE) TYPE  DATUM
*"     VALUE(TIME) TYPE  ATIME
*"     VALUE(RUECK) TYPE  CO_RUECK
*"     VALUE(AUFPL) TYPE  CO_AUFPL
*"     VALUE(APLZL) TYPE  CO_APLZL
*"     VALUE(ACTV_ID) TYPE  ZABSF_PP_E_ACTV OPTIONAL
*"     VALUE(STPRSNID) TYPE  ZABSF_PP_E_STPRSNID OPTIONAL
*"     VALUE(STPTY) TYPE  ZABSF_PP_E_STPTY OPTIONAL
*"     VALUE(ACTIONID) TYPE  ZABSF_PP_E_ACTION OPTIONAL
*"     VALUE(SCHEDULE_ID) TYPE  ZABSF_PP_E_SCHEDULE_ID OPTIONAL
*"     VALUE(REGIME_ID) TYPE  ZABSF_PP_E_REGIME_ID OPTIONAL
*"     VALUE(COUNT_INI) TYPE  ZABSF_PP_E_COUNT_INI OPTIONAL
*"     VALUE(COUNT_FIN) TYPE  ZABSF_PP_E_COUNT_FIN OPTIONAL
*"     VALUE(BACKOFFICE) TYPE  FLAG OPTIONAL
*"     VALUE(SHIFTID) TYPE  ZABSF_PP_E_SHIFTID OPTIONAL
*"     VALUE(OPRID) TYPE  ZABSF_PP_E_OPRID OPTIONAL
*"     VALUE(KAPID) TYPE  KAPID OPTIONAL
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
*>> Modo de Funcionamento -
  "- Validações inciais
  "- Pára a ordem de produção ("END_PARC")
  "- adiciona ou remove o utilizador da ordem de produção
  "- Arranca a produção.

*References
  DATA: lref_sf_event_act TYPE REF TO zif_absf_pp_event_act,
        lref_sf_operator  TYPE REF TO zif_absf_pp_operator.

  DATA: ld_class  TYPE recaimplclname,
        ld_method TYPE seocmpname.

*Variables
  DATA: l_gname       TYPE seqg3-gname,
        l_garg        TYPE seqg3-garg,
        l_guname      TYPE seqg3-guname,
        l_subrc       TYPE sy-subrc,
        l_wait        TYPE i,
        lf_error      TYPE flag,
        lv_pernr      TYPE pernr_d,
        lv_no_restart TYPE flag,
        lv_error      TYPE flag.

*Structures
  DATA: ls_return TYPE bapireturn.

*Constants
  CONSTANTS: c_wait TYPE zabsf_pp_e_parid VALUE 'WAIT'.

*Get time wait
  SELECT SINGLE parva
    FROM zabsf_pp032
    INTO (@DATA(l_wait_param))
   WHERE parid EQ @c_wait.

  IF l_wait_param IS NOT INITIAL.
    l_wait = l_wait_param.
  ENDIF.

*Get class of interface
  SELECT SINGLE imp_clname, methodname
      FROM zabsf_pp003
      INTO (@DATA(l_class),@DATA(l_method) )
     WHERE werks    EQ @inputobj-werks
       AND id_class EQ '2'
       AND endda    GE @refdt
       AND begda    LE @refdt.

  TRY .
      CREATE OBJECT lref_sf_event_act TYPE (l_class)
        EXPORTING
          initial_refdt = refdt
          input_object  = inputobj.

    CATCH cx_sy_create_object_error.
*
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'E'
          msgno      = '019'
          msgv1      = l_class
        CHANGING
          return_tab = return_tab.
      EXIT.
  ENDTRY.

*Get class of interface
  SELECT SINGLE imp_clname methodname
      FROM zabsf_pp003
      INTO (ld_class, ld_method)
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

*Check blocks
  CALL METHOD zabsf_pp_cl_wait_enqueue=>wait_for_dequeue_res
    EXPORTING
      i_aufnr    = aufnr
      i_max_time = l_wait
    IMPORTING
      e_gname    = l_gname
      e_garg     = l_garg
      e_guname   = l_guname
      e_return   = l_subrc.

  IF l_subrc NE 0.
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'E'
        msgno      = '093'
        msgv1      = l_guname
        msgv2      = l_gname
        msgv3      = l_guname
      CHANGING
        return_tab = return_tab.
    EXIT.
  ENDIF.
*>> Validar se o utilizador existe
  READ TABLE operator_tab INTO DATA(ls_operator) INDEX 1.

  MOVE ls_operator-oprid TO lv_pernr.
  TRANSLATE ls_operator-oprid TO UPPER CASE.
*  CALL FUNCTION 'BAPI_EMPLOYEE_CHECKEXISTENCE'
*    EXPORTING
*      number = lv_pernr
*    IMPORTING
*      return = ls_return.

  IF ls_return IS INITIAL.
* Check if user is allready on the selected state.
    SELECT SINGLE * FROM zabsf_pp014 INTO @DATA(ls_pp014)
        WHERE arbpl  EQ @arbpl
          AND aufnr  EQ @aufnr
          AND vornr  EQ @vornr
          AND status EQ @ls_operator-status
          AND tipord EQ 'N' "@tipord.
          AND oprid  EQ @ls_operator-oprid
          AND kapid  EQ @kapid.

    IF sy-subrc EQ 0.
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'E'
          msgno      = '113'
          msgv1      = ls_operator-oprid
        CHANGING
          return_tab = return_tab.
      EXIT.
    ENDIF.

*>>BMR INSERT 11.06.2018 - Check if user is working on another workcenter/order/operation.
*    CALL METHOD zabsf_pp_cl_operator=>check_if_operator_is_assgined
*      EXPORTING
*        arbpl        = arbpl
*        aufnr        = aufnr
*        vornr        = vornr
*        operator_tab = operator_tab
*      IMPORTING
*        e_error      = lv_error
*      CHANGING
*        return_tab   = return_tab.
*
*    CHECK lv_error IS INITIAL.
*<<BMR INSERT 11.06.2018 - Check if user is working on another workcenter/order/operation.


    "Get all active Operators in this order type
    SELECT *
      FROM zabsf_pp014
      INTO TABLE @DATA(lt_zabsf_pp014)
      WHERE arbpl  EQ @arbpl
        AND aufnr  EQ @aufnr
        AND vornr  EQ @vornr
        AND status EQ 'A'
        AND tipord EQ 'N'. "@tipord.
*    Read information from database, that we put above and the id of operator be the same that return in the Loop.
    READ TABLE lt_zabsf_pp014 INTO DATA(ls_zabsf_pp014) WITH KEY oprid = ls_operator-oprid.

    IF sy-subrc NE 0.
      IF ( ls_operator-oprid NE '' AND ls_operator-status EQ 'A' ).

        ls_zabsf_pp014-arbpl  = arbpl.
        ls_zabsf_pp014-aufnr  = aufnr.
        ls_zabsf_pp014-vornr  = vornr.
        ls_zabsf_pp014-oprid  = ls_operator-oprid.
        ls_zabsf_pp014-status = ls_operator-status.
        ls_zabsf_pp014-tipord = 'N'.
        ls_zabsf_pp014-udate  = sy-datum.
        ls_zabsf_pp014-utime  = sy-uzeit.
        ls_zabsf_pp014-kapid  = kapid.

        INSERT INTO zabsf_pp014 VALUES ls_zabsf_pp014.

      ENDIF.
    ENDIF.
    "sy-subrc is component of the system, if everything ok so return 0 in sy-subrc. Then see  if the status of the operator is equal to inactive
    IF sy-subrc EQ 0 AND ls_operator-status EQ 'I'."Inactive

*      Get number operators assigned to Production Order
      DESCRIBE TABLE lt_zabsf_pp014 LINES DATA(l_nr_operator).

*      Get first operator assigned to Production Order
      SELECT oprid UP TO 1 ROWS
        FROM zabsf_pp014
        INTO (@DATA(l_first_operator))
       WHERE arbpl  EQ @arbpl
         AND aufnr  EQ @aufnr
         AND vornr  EQ @vornr
         AND status EQ 'A'
         AND tipord EQ 'N' "@tipord
       ORDER BY udate ASCENDING, utime ASCENDING.
      ENDSELECT.

      IF l_first_operator EQ ls_operator-oprid AND l_nr_operator GT 1.
*        Operd. principal não pode dissociar-se enquanto houver outros associados.
*        CALL METHOD zabsf_pp_cl_log=>add_message
*          EXPORTING
*            msgty      = 'E'
*            msgno      = '084'
*          CHANGING
*            return_tab = return_tab.
*        EXIT.
      ENDIF.

      IF l_nr_operator EQ 1.
        "Ultimo operador da ordem. Não reenicia!
        lv_no_restart = abap_true.
*        CALL METHOD zabsf_pp_cl_log=>add_message
*          EXPORTING
*            msgty      = 'E'
*            msgno      = '112'
*          CHANGING
*            return_tab = return_tab.
*          EXIT.
      ENDIF.

    ENDIF.
  ELSE.
*    Não foi encontrado o utilizador & no sistema
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'E'
        msgno      = '024'
        msgv1      = ls_operator-oprid
      CHANGING
        return_tab = return_tab.
    RETURN.
  ENDIF.


*Save confirmation time
  actv_id = 'END_PARC'.
  actionid = 'NEXT'.
  "ZABSF_PP_CL_EVENT_ACT=>SET_CONF_EVENT_TIME
  CALL METHOD lref_sf_event_act->(l_method)
    EXPORTING
      arbpl                         = arbpl
      werks                         = inputobj-werks
      aufnr                         = aufnr
      vornr                         = vornr
      date                          = date
      time                          = time
      oprid                         = oprid
      rueck                         = rueck
      aufpl                         = aufpl
      aplzl                         = aplzl
      actv_id                       = actv_id
      stprsnid                      = stprsnid
      schedule_id                   = schedule_id
      regime_id                     = regime_id
      count_ini                     = count_ini
      count_fin                     = count_fin
      backoffice                    = backoffice
      shiftid                       = shiftid
      no_clear_operators_from_order = abap_true "dont remove operators from order on partial close.
      kapid                         = kapid
    CHANGING
      actionid                      = actionid
      return_tab                    = return_tab.

  DELETE ADJACENT DUPLICATES FROM return_tab.

  LOOP AT return_tab TRANSPORTING NO FIELDS
    WHERE type CA 'AEX'.

    lf_error = abap_true.
    EXIT.
  ENDLOOP.

  CHECK lf_error EQ abap_false.

* Clear Batchs.
  DELETE FROM zabsf_pp069 WHERE werks = inputobj-werks
                             AND aufnr = aufnr
                             AND vornr = vornr
                             AND flag_shift = abap_true.
  IF sy-subrc = 0.
    COMMIT WORK.
  ENDIF.
* Remove / Add operator
  " ZABSF_PP_CL_OPERATOR->SET_OPERATOR
  CALL METHOD lref_sf_operator->(ld_method)
    EXPORTING
      arbpl        = arbpl
      aufnr        = aufnr
      vornr        = vornr
      operator_tab = operator_tab
      kapid        = kapid
    CHANGING
      return_tab   = return_tab.

  DELETE ADJACENT DUPLICATES FROM return_tab.

* Look for errors.
  LOOP AT return_tab TRANSPORTING NO FIELDS
  WHERE type CA 'AEX'.

    lf_error = abap_true.
    EXIT.
  ENDLOOP.

  CHECK lf_error EQ abap_false AND lv_no_restart EQ abap_false.

  "Re-Start production
  actv_id = 'INIT_PRO'.
  actionid = 'PROD'.
  "ZABSF_PP_CL_EVENT_ACT=>SET_CONF_EVENT_TIME
  CALL METHOD lref_sf_event_act->(l_method)
    EXPORTING
      arbpl       = arbpl
      werks       = inputobj-werks
      aufnr       = aufnr
      vornr       = vornr
      date        = date
      time        = time
      oprid       = oprid
      rueck       = rueck
      aufpl       = aufpl
      aplzl       = aplzl
      actv_id     = actv_id
      stprsnid    = stprsnid
      schedule_id = schedule_id
      regime_id   = regime_id
      count_ini   = count_ini
      count_fin   = count_fin
      backoffice  = backoffice
      shiftid     = shiftid
      kapid       = kapid
    CHANGING
      actionid    = actionid
      return_tab  = return_tab.

  DELETE ADJACENT DUPLICATES FROM return_tab.





ENDFUNCTION.
