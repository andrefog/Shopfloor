*&---------------------------------------------------------------------*
*& Report      : ZABSF_PP_REPORT1
*& Author      : André Fogagnoli
*& Date        : 20.12.2022
*& Functional  : José Barbosa
*& Description : !?
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zabsf_pp_report2.

************************************************************************
* INCLUDES
************************************************************************
INCLUDE ZABSF_PP_REPORT2_TOP.
INCLUDE ZABSF_PP_REPORT2_SRC.
INCLUDE ZABSF_PP_REPORT2_F01.

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
