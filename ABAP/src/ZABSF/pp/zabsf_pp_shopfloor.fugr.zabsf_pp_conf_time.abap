FUNCTION zabsf_pp_conf_time .
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(AREAID) TYPE  ZABSF_PP_E_AREAID OPTIONAL
*"     VALUE(ARBPL) TYPE  ARBPL
*"     VALUE(AUFNR) TYPE  AUFNR
*"     VALUE(VORNR) TYPE  VORNR
*"     VALUE(DATE) TYPE  DATUM
*"     VALUE(TIME) TYPE  ATIME
*"     VALUE(OPRID) TYPE  ZABSF_PP_E_OPRID OPTIONAL
*"     VALUE(RUECK) TYPE  CO_RUECK
*"     VALUE(AUFPL) TYPE  CO_AUFPL
*"     VALUE(APLZL) TYPE  CO_APLZL
*"     VALUE(ACTV_ID) TYPE  ZABSF_PP_E_ACTV
*"     VALUE(STPRSNID) TYPE  ZABSF_PP_E_STPRSNID OPTIONAL
*"     VALUE(STPTY) TYPE  ZABSF_PP_E_STPTY OPTIONAL
*"     VALUE(ACTIONID) TYPE  ZABSF_PP_E_ACTION
*"     VALUE(SCHEDULE_ID) TYPE  ZABSF_PP_E_SCHEDULE_ID OPTIONAL
*"     VALUE(REGIME_ID) TYPE  ZABSF_PP_E_REGIME_ID OPTIONAL
*"     VALUE(COUNT_INI) TYPE  ZABSF_PP_E_COUNT_INI OPTIONAL
*"     VALUE(COUNT_FIN) TYPE  ZABSF_PP_E_COUNT_FIN OPTIONAL
*"     VALUE(BACKOFFICE) TYPE  FLAG OPTIONAL
*"     VALUE(SHIFTID) TYPE  ZABSF_PP_E_SHIFTID OPTIONAL
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"     VALUE(CONF) TYPE  FLAG OPTIONAL
*"     VALUE(KAPID) TYPE  KAPID OPTIONAL
*"     VALUE(EQUIPMENT) TYPE  CHAR100 OPTIONAL
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
*References
  DATA lref_sf_event_act TYPE REF TO zif_absf_pp_event_act.

*Variables
  DATA: l_gname  TYPE seqg3-gname,
        l_garg   TYPE seqg3-garg,
        l_guname TYPE seqg3-guname,
        l_subrc  TYPE sy-subrc,
        l_wait   TYPE i.
  FIELD-SYMBOLS: <ls_oper_str> TYPE zabsf_pp014.

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

  time = time - l_wait_param.

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

*Save confirmation time
  CALL METHOD lref_sf_event_act->(l_method)
    EXPORTING
      arbpl        = arbpl
      werks        = inputobj-werks
      aufnr        = aufnr
      vornr        = vornr
      date         = date
      time         = time
      oprid        = oprid
      rueck        = rueck
      aufpl        = aufpl
      aplzl        = aplzl
      actv_id      = actv_id
      stprsnid     = stprsnid
      schedule_id  = schedule_id
      regime_id    = regime_id
      count_ini    = count_ini
      count_fin    = count_fin
      backoffice   = backoffice
      shiftid      = shiftid
      kapid        = kapid
     iv_equipment = CONV char100( equipment )
    CHANGING
      actionid     = actionid
      return_tab   = return_tab.

  DELETE ADJACENT DUPLICATES FROM return_tab.

  LOOP AT return_tab TRANSPORTING NO FIELDS
    WHERE type CA 'AEX'.
    "sair do processamento
    RETURN.
  ENDLOOP.

  "actualizar tabela de utilizadores com postos de trabalho
  IF kapid IS NOT INITIAL.
    SELECT *
      FROM zabsf_pp014
      INTO TABLE @DATA(lt_operas_tab)
        WHERE aufnr EQ @aufnr
          AND vornr EQ @vornr
          AND arbpl EQ @arbpl.
    IF sy-subrc EQ 0.

*      update zabsf_pp014 from table @( VALUE #(
*     for <ls_oper_str> in lt_operas_tab
*      ( value #(
*               base <ls_oper_str>
*               kapid =  kapid ) ) ) ).

      LOOP AT lt_operas_tab ASSIGNING <ls_oper_str>.
        <ls_oper_str>-kapid = kapid.
      ENDLOOP.
    ENDIF.
    UPDATE zabsf_pp014 FROM TABLE @lt_operas_tab.
  ENDIF.

  IF actv_id EQ 'END_PROD'
    AND actionid EQ 'CONC'.
    "verificar se é para fazer TECO - última operção
    SELECT MAX( aplzl )
      INTO @DATA(lv_finalste_var)
      FROM afvc
        WHERE aufpl EQ @aufpl
          AND loekz EQ @abap_false.

    "contador da operação actual
    SELECT SINGLE aplzl
      FROM afvc
      INTO @DATA(lv_operatio_var)
      WHERE aufpl EQ @aufpl
        AND vornr EQ @vornr
        AND loekz EQ @abap_false.
    IF lv_finalste_var EQ lv_operatio_var
      AND conf EQ abap_true.
      "activar flag de confirmação final
      DATA(lv_teco_var) = abap_true.
    ENDIF.
    "alterar status da operação/ordem
    CALL FUNCTION 'ZABSF_PP_ORDER_STATUS'
      EXPORTING
        aufnr      = aufnr
        inputobj   = inputobj
        aufpl      = aufpl
        vornr      = vornr
        conf       = COND #( WHEN conf EQ abap_true
                             THEN abap_true
                             ELSE abap_false )
        no_conf    = COND #( WHEN conf EQ abap_false
                            THEN abap_true
                            ELSE abap_false )
        teco       = COND #( WHEN lv_teco_var EQ abap_true
                             THEN abap_true
                             ELSE abap_false )
      IMPORTING
        return_tab = return_tab.
  ENDIF.

  CHECK actv_id = 'END_PARC'.
  DELETE FROM zabsf_pp069 WHERE werks = inputobj-werks
                             AND aufnr = aufnr
                             AND vornr = vornr
                             AND flag_shift = abap_true.
  IF sy-subrc = 0.
    COMMIT WORK AND WAIT.
  ENDIF.

*  wait up to l_wait_param seconds.

ENDFUNCTION.
