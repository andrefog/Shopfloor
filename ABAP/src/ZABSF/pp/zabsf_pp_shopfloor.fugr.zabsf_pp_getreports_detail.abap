FUNCTION zabsf_pp_getreports_detail.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(HNAME) TYPE  CR_HNAME OPTIONAL
*"     VALUE(AREAID) TYPE  ZABSF_PP_E_AREAID OPTIONAL
*"     VALUE(SHIFTID) TYPE  ZABSF_PP_E_SHIFTID OPTIONAL
*"     VALUE(ARBPL) TYPE  ARBPL OPTIONAL
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"     VALUE(BEGDA) TYPE  BEGDA OPTIONAL
*"     VALUE(ENDDA) TYPE  ENDDA OPTIONAL
*"  EXPORTING
*"     VALUE(REPORTS_DETAIL_ST) TYPE  ZABSF_PP_S_REPORTS_DETAIL
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
  DATA lref_sf_display TYPE REF TO zabsf_pp_cl_display_statistic.

  CREATE OBJECT lref_sf_display
    EXPORTING
      initial_refdt = refdt
      input_object  = inputobj.

  CALL METHOD lref_sf_display->display_reports
    EXPORTING
      hname             = hname
      areaid            = areaid
      shiftid           = shiftid
      arbpl             = arbpl
      begda             = begda
      endda             = endda
    CHANGING
      reports_detail_st = reports_detail_st
      return_tab        = return_tab.

  DELETE ADJACENT DUPLICATES FROM return_tab.
ENDFUNCTION.
