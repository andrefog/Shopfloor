*&---------------------------------------------------------------------*
*& Report      : ZABSF_PP_REPORT1
*& Author      : André Fogagnoli
*& Date        : 15.12.2022
*& Functional  : José Barbosa
*& Description : !?
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zabsf_pp_report1.

************************************************************************
* INCLUDES
************************************************************************
INCLUDE zabsf_pp_report1_top.
INCLUDE zabsf_pp_report1_src.
INCLUDE zabsf_pp_report1_f01.

************************************************************************
* EVENTS
************************************************************************
START-OF-SELECTION.

  PERFORM:
    adjust_range_date,
    select_data.

  IF gt_afru[] IS INITIAL.
    " No Data Found
    MESSAGE e169(zabsf_pp).
  ELSE.
    PERFORM:
      fill_alv_table,
      display_alv.
  ENDIF.
