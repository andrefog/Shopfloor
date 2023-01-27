*&---------------------------------------------------------------------*
*& report  z_lp_pp_sf_passage_cockpit
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT zabsf_pp_passage_cockpit.


INCLUDE zabsf_pp_passage_top.
INCLUDE zabsf_pp_passage_screen.

INITIALIZATION.
  PERFORM init_variables.

START-OF-SELECTION.

  PERFORM get_passage.

  CALL SCREEN 100.

  INCLUDE zabsf_pp_passage_cockpit_o01. "pbo
  INCLUDE zabsf_pp_passage_cockpit_i01. "pai
  INCLUDE zabsf_pp_passage_cockpit_f01. "forms
