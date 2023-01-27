*&---------------------------------------------------------------------*
*& Report  Z_LP_PP_SF_OPTION_COCKPIT
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT zabsf_pp_option_cockpit.

INCLUDE zabsf_pp_option_top.
INCLUDE zabsf_pp_option_screen.

INITIALIZATION.

  PERFORM init_variables.

START-OF-SELECTION.

*Chronograph
  IF pa_cron IS NOT INITIAL.
    PERFORM get_cronograph.
    CALL SCREEN 100.
*Measurements
  ELSEIF pa_med IS NOT INITIAL.
    PERFORM get_measurements.
    CALL SCREEN 200.
*Alerts
  ELSEIF pa_alrt IS NOT INITIAL.
    PERFORM get_alerts.
    CALL SCREEN 300.
  ENDIF.


  INCLUDE zabsf_pp_option_cockpit_o01.  "PBO
  INCLUDE zabsf_pp_option_cockpit_i01.  "PAI
  INCLUDE zabsf_pp_option_cockpit_f01.  "Forms
