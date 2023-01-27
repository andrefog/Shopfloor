*&---------------------------------------------------------------------*
*& Report  Z_LP_PP_SF_SCRAP_COCKPIT
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT zabsf_pp_scrap_cockpit.

INCLUDE zabsf_pp_scrap_top.
INCLUDE zabsf_pp_scrap_screen.

INITIALIZATION.
  PERFORM init_variables.

START-OF-SELECTION.

  PERFORM get_scrap.

  CALL SCREEN 100.

  INCLUDE zabsf_pp_scrap_cockpit_o01. "pbo
  INCLUDE zabsf_pp_scrap_cockpit_i01. "pai
  INCLUDE zabsf_pp_scrap_cockpit_f01. "forms
