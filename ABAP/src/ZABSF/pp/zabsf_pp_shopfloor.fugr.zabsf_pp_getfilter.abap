FUNCTION zabsf_pp_getfilter.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(FILTER_TAB) TYPE  ZABSF_PP_T_FILTER
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
  DATA lref_sf_display TYPE REF TO zabsf_pp_cl_display_statistic.

  CREATE OBJECT lref_sf_display
    EXPORTING
      initial_refdt = refdt
      input_object  = inputobj.

  CALL METHOD lref_sf_display->get_filter
    CHANGING
      filter_tab = filter_tab
      return_tab = return_tab.

  DELETE ADJACENT DUPLICATES FROM return_tab.
ENDFUNCTION.
