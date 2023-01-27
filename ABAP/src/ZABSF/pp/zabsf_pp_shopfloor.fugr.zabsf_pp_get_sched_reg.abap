FUNCTION zabsf_pp_get_sched_reg.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(SCHEDULE_TAB) TYPE  ZABSF_PP_T_SCHED_REGIME
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------


  DATA: lc_sf_schedules TYPE REF TO zabsf_pp_cl_schd_regimes.

  DATA: lt_schedules       TYPE zabsf_pp_t_sched_regime,
        ls_schedules       TYPE zabsf_pp_s_sched_regime,
        lt_regimes         TYPE zabsf_pp_t_regimes,
        ls_output          TYPE zabsf_pp_s_sched_regime.

  DATA: lv_get_schedule TYPE flag.

  DATA: l_langu TYPE sy-langu.

*Set local language for user
  l_langu = inputobj-language.
  SET LOCALE LANGUAGE l_langu.


    CREATE OBJECT lc_sf_schedules
      EXPORTING
        initial_refdt = refdt
        input_object  = inputobj.

    CALL METHOD lc_sf_schedules->get_schedules
      IMPORTING
        schedules = lt_schedules.


  IF lt_schedules IS NOT INITIAL.

    LOOP AT lt_schedules INTO ls_schedules.

      CALL METHOD lc_sf_schedules->get_regimes
        EXPORTING
          schedule_id = ls_schedules-schedule_id
        IMPORTING
          regimes     = lt_regimes.

      MOVE-CORRESPONDING ls_schedules TO ls_output.
      APPEND LINES OF lt_regimes TO ls_output-regime_tab.

      APPEND ls_output TO schedule_tab.


      REFRESH lt_regimes.
      CLEAR ls_schedules.
    ENDLOOP.

  ELSE.
* add message if no data found
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'E'
        msgno      = '065'
      CHANGING
        return_tab = return_tab.
  ENDIF.


ENDFUNCTION.
