FUNCTION zabsf_pp_getoee.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(HNAME) TYPE  CR_HNAME
*"     VALUE(SHIFTID) TYPE  ZABSF_PP_E_SHIFTID
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(STAT_OEE_TAB) TYPE  ZABSF_PP_T_STAT_OEE
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
  DATA lref_sf_display TYPE REF TO zabsf_pp_cl_display_statistic.

  CREATE OBJECT lref_sf_display
    EXPORTING
      initial_refdt = refdt
      input_object  = inputobj.

  CALL METHOD lref_sf_display->display_lcd
    EXPORTING
      hname        = hname
      shiftid      = shiftid
    CHANGING
      stat_oee_tab = stat_oee_tab
      return_tab   = return_tab.

  DELETE ADJACENT DUPLICATES FROM return_tab.
ENDFUNCTION.
