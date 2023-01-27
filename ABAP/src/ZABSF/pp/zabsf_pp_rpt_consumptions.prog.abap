*&---------------------------------------------------------------------*
*& Report Z_LP_PP_SF_CONSUMPTIONS_CHG
*&
*&---------------------------------------------------------------------*
*& Author: Ábaco
*& Date: 31.03.2017
*& Title:	Consumptions corrections concerning leftovers  CR12.5
*&---------------------------------------------------------------------*

REPORT zabsf_pp_rpt_consumptions.

INCLUDE zabsf_pp_rpt_consumptionstop.
INCLUDE zabsf_pp_rpt_consumptscreen.

INITIALIZATION.
  PERFORM init_variables.


START-OF-SELECTION.

  PERFORM get_consumptions.

  CALL SCREEN 100.

  INCLUDE zabsf_pp_rpt_consumptionso01.
  INCLUDE zabsf_pp_rpt_consumptionsi01.
  INCLUDE zabsf_pp_rpt_consumptionsf01.

END-OF-SELECTION.
