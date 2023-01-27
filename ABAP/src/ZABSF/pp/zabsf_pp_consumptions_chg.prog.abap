*&---------------------------------------------------------------------*
*& Report Z_LP_PP_SF_CONSUMPTIONS_CHG
*&
*&---------------------------------------------------------------------*
*& Author: Ábaco
*& Date: 31.03.2017
*& Title:	Consumptions corrections concerning leftovers  CR12.5
*&---------------------------------------------------------------------*

REPORT zabsf_pp_consumptions_chg.

INCLUDE zabsf_pp_consumptions_chgtop.
INCLUDE zabsf_pp_consumptions_screen.

INITIALIZATION.
  PERFORM init_variables.


START-OF-SELECTION.

  PERFORM get_consumptions.

  CALL SCREEN 100.

  INCLUDE zabsf_pp_consumptions_chgo01.
  INCLUDE zabsf_pp_consumptions_chgi01.
  INCLUDE zabsf_pp_consumptions_chgf01.

END-OF-SELECTION.
