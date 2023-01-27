*&---------------------------------------------------------------------*
*&  Include           Z_LP_PP_CLOSE_STOP_OPER_FORMS
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM process_data .
*Internal tables
  DATA: lt_return     TYPE bapiret2_t,
        lt_return_tot TYPE bapiret2_t.

*Structures
  DATA: ls_inputobj       TYPE zabsf_pp_s_inputobject,
        ls_operation_proc TYPE ty_operation_proc.

*Variables
  DATA: l_time TYPE atime.

*Constants
  CONSTANTS: c_end_parc     TYPE zabsf_pp_e_actv   VALUE 'END_PARC',
             c_actionid     TYPE zabsf_pp_e_action VALUE 'NEXT',
             c_actionid_ini TYPE zabsf_pp_e_action VALUE 'INIT',
             c_status_stop  TYPE j_status          VALUE 'STOP',
             c_status_agu   TYPE j_status          VALUE 'AGU'.

*Get Production order stopped
  SELECT sf021~aufnr, sf021~vornr, sf021~status_oper, afko~aufpl,
         aufk~werks, afvc~rueck, afvc~aplzl, afvc~ltxa1, crhd~arbpl
    FROM zabsf_pp021 AS sf021
   INNER JOIN aufk AS aufk
      ON aufk~aufnr EQ sf021~aufnr
   INNER JOIN afko AS afko
      ON afko~aufnr EQ sf021~aufnr
   INNER JOIN afvc AS afvc
      ON afvc~aufpl EQ afko~aufpl
   INNER JOIN crhd
      ON crhd~objid EQ afvc~arbid
     AND crhd~objty EQ 'A'
   WHERE sf021~status_oper EQ @c_status_stop
     AND aufk~werks        IN @s_werks
    INTO TABLE @DATA(lt_data).

  IF lt_data[] IS NOT INITIAL.
    LOOP AT lt_data INTO DATA(ls_data).
*    Time
      l_time = sy-timlo.

*    Get input fields
      PERFORM prepare_input_fields USING    ls_data-arbpl ls_data-aufnr ls_data-vornr
                                            ls_data-werks ls_data-rueck
                                   CHANGING ls_inputobj.

*    Save stop time
      CALL FUNCTION 'ZABSF_PP_CONF_TIME'
        EXPORTING
          arbpl      = ls_data-arbpl
          aufnr      = ls_data-aufnr
          vornr      = ls_data-vornr
          date       = sy-datlo
          time       = l_time
          rueck      = ls_data-rueck
          aufpl      = ls_data-aufpl
          aplzl      = ls_data-aplzl
          actv_id    = c_end_parc
          actionid   = c_actionid_ini
          backoffice = abap_false
          refdt      = sy-datlo
          inputobj   = ls_inputobj
        IMPORTING
          return_tab = lt_return.

      APPEND LINES OF lt_return TO lt_return_tot.

      IF lt_return[] IS NOT INITIAL.
        CLEAR ls_operation_proc.

*      Move same fields
        MOVE-CORRESPONDING ls_data TO ls_operation_proc.

*      Old Status
        ls_operation_proc-status_old = ls_data-status_oper.

        READ TABLE lt_return INTO DATA(ls_return) WITH KEY type = 'E'.

        IF sy-subrc EQ 0.
*        Status incompleted
          ls_operation_proc-status = icon_incomplete.
*        Message ID
          ls_operation_proc-id = ls_return-id.
*        Message number
          ls_operation_proc-number = ls_return-number.
*        Message description
          ls_operation_proc-message = ls_return-message.
        ELSE.
*        New Status
          ls_operation_proc-status_new = c_status_agu.
*        Status completed
          ls_operation_proc-status = icon_checked.
        ENDIF.

*      Save data processed
        APPEND ls_operation_proc TO gt_data.
      ENDIF.
    ENDLOOP.

    IF gt_data[] IS NOT INITIAL.
      PERFORM show_log.
    ENDIF.
  ELSE.
    MESSAGE 'Não existe informação a processar.'(e01) TYPE 'E' DISPLAY LIKE 'S'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SHOW_LOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM show_log .
*Reference
  DATA: lr_functions TYPE REF TO cl_salv_functions,
        lr_columns   TYPE REF TO cl_salv_columns_table,
        lr_column    TYPE REF TO cl_salv_column,
        lr_table     TYPE REF TO cl_salv_table.

*Criar tabela ALV
  TRY.
      cl_salv_table=>factory(
      IMPORTING
        r_salv_table = lr_table
      CHANGING
        t_table      = gt_data ).
    CATCH cx_salv_msg.
      EXIT.
  ENDTRY.

*To optmize columns
  lr_columns = lr_table->get_columns( ).
  lr_columns->set_optimize( ).

*Change name columns
  lr_column = lr_columns->get_column( 'STATUS_OLD' ).
  lr_column->set_long_text( TEXT-t01 ).

  lr_column = lr_columns->get_column( 'STATUS_NEW' ).
  lr_column->set_long_text( TEXT-t02 ).

  lr_column = lr_columns->get_column( 'STATUS' ).
  lr_column->set_long_text( TEXT-t03 ).

*Adicionar funcionalidades
  lr_functions = lr_table->get_functions( ).
  lr_functions->set_all( abap_true ).

*Visualizar ALV
  lr_table->display( ).
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PREPARE_INPUT_FIELDS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LS_DATA_ARBPL  text
*      -->P_LS_DATA_AUFNR  text
*      -->P_LS_DATA_VORNR  text
*      -->P_LS_DATA_WERKS  text
*----------------------------------------------------------------------*
FORM prepare_input_fields  USING    p_arbpl
                                    p_aufnr
                                    p_vornr
                                    p_werks
                                    p_rueck
                           CHANGING ps_inputobj TYPE zabsf_pp_s_inputobject.

*Constants
  CONSTANTS: c_objty_ho TYPE cr_objty VALUE 'A'. "Workcenter

*Get id of workcenter
  SELECT SINGLE objid
    FROM crhd
    INTO (@DATA(l_arbpl_id))
   WHERE arbpl EQ @p_arbpl
     AND werks EQ @p_werks.

*Get hierarchy of Work center
  SELECT SINGLE objty_hy, objid_hy
    FROM crhs
    INTO (@DATA(l_hname_ty), @DATA(l_hname_id))
   WHERE objty_ho EQ @c_objty_ho "Workcenter
     AND objid_ho EQ @l_arbpl_id.

*Get name of hierarchy
  SELECT SINGLE name
    FROM crhh
    INTO (@DATA(l_hname))
   WHERE objty EQ @l_hname_ty
     AND objid EQ @l_hname_id.

*Get last confirmation
  SELECT * UP TO 1 ROWS
    FROM zabsf_pp016
    INTO @DATA(ls_afru_sf016)
   WHERE hname  EQ @l_hname
     AND werks  EQ @p_werks
     AND arbpl  EQ @p_arbpl
     AND aufnr  EQ @p_aufnr
     AND vornr  EQ @p_vornr
     AND rueck  EQ @p_rueck
   ORDER BY rmzhl DESCENDING.
  ENDSELECT.

*Area ID
  ps_inputobj-areaid = ls_afru_sf016-areaid.
*Plant
  ps_inputobj-werks = ls_afru_sf016-werks.
*Operator
  ps_inputobj-pernr = ps_inputobj-oprid = ls_afru_sf016-oprid.
*Language
  ps_inputobj-language = sy-langu.
*Confirmation date
  ps_inputobj-dateconf = sy-datlo.
*Confirmation time
  ps_inputobj-timeconf = sy-timlo.
ENDFORM.
