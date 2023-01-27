*&---------------------------------------------------------------------*
*& Report  Z_LP_PP_SF_MATNR_COCKPIT
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT zabsf_pp_matnr_cockpit.

INCLUDE zabsf_pp_matnr_top.
INCLUDE zabsf_pp_matnr_screen.

INITIALIZATION.
  PERFORM init_variables.

START-OF-SELECTION.

*Production Time
  IF pa_prod IS NOT INITIAL.
    PERFORM get_time_prod.
    CALL SCREEN 100.
*Stop Time
  ELSEIF pa_stop IS NOT INITIAL.
    PERFORM get_time_stop.
    CALL SCREEN 200.
*Scrap quantity
  ELSEIF pa_scrap IS NOT INITIAL.
    PERFORM get_qtd_scrap.
    CALL SCREEN 300.
*Rework quantity
  ELSEIF pa_rewrk IS NOT INITIAL.
    PERFORM get_qtd_rewrk.
    CALL SCREEN 400.
  ENDIF.

  INCLUDE zabsf_pp_matnr_cockpit_o01. "PBO
  INCLUDE zabsf_pp_matnr_cockpit_i01. "PAI
  INCLUDE zabsf_pp_matnr_cockpit_f01. "Forms
