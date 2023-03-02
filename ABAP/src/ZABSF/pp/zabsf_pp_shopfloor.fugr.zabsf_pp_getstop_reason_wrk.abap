FUNCTION zabsf_pp_getstop_reason_wrk .
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(ARBPL) TYPE  ARBPL
*"     VALUE(WERKS) TYPE  WERKS_D OPTIONAL
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(STOP_REASON_TAB) TYPE  ZABSF_PP_T_STOP_REASON
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
  DATA lref_sf_stop TYPE REF TO zabsf_pp_cl_stop_reason.
  DATA ls_return TYPE bapiret2.

  CREATE OBJECT lref_sf_stop
    EXPORTING
      initial_refdt = refdt
      input_object  = inputobj.

  CALL METHOD lref_sf_stop->get_stop_reason_wrk
    EXPORTING
      iv_arbpl           = arbpl
      iv_werks           = inputobj-werks
      iv_spras           = sy-langu
      iv_areaid          = inputobj-areaid
    CHANGING
      stop_reason_tab = stop_reason_tab
      return_tab      = return_tab.

  DELETE ADJACENT DUPLICATES FROM return_tab.
ENDFUNCTION.
