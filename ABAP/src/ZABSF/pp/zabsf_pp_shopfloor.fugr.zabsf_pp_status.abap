FUNCTION zabsf_pp_status .
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(ARBPL) TYPE  ARBPL OPTIONAL
*"     VALUE(AUFNR) TYPE  AUFNR OPTIONAL
*"     VALUE(VORNR) TYPE  VORNR OPTIONAL
*"     VALUE(WERKS) TYPE  WERKS_D OPTIONAL
*"     VALUE(OBJTY) TYPE  J_OBART
*"     VALUE(STATUS) TYPE  J_STATUS OPTIONAL
*"     VALUE(STSMA) TYPE  J_STSMA OPTIONAL
*"     VALUE(METHOD) TYPE  ZABSF_PP_E_METHOD OPTIONAL
*"     VALUE(STATUS_OPER) TYPE  J_STATUS OPTIONAL
*"     VALUE(STATUS_INPUT_TAB) TYPE  ZABSF_PP_T_STATUS_ORD OPTIONAL
*"     VALUE(ACTIONID) TYPE  ZABSF_PP_E_ACTION OPTIONAL
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(STATUS_OUT) TYPE  J_STATUS
*"     VALUE(STATUS_DESC) TYPE  J_TXT30
*"     VALUE(STSMA_OUT) TYPE  JSTO-STSMA
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"     VALUE(STATUS_INPUT_TAB) TYPE  ZABSF_PP_T_STATUS_ORD
*"----------------------------------------------------------------------

  DATA lref_sf_status TYPE REF TO zabsf_pp_cl_status.
  DATA ls_return TYPE bapiret2.

*Object for class status
  CREATE OBJECT lref_sf_status
    EXPORTING
      initial_refdt = refdt
      input_object  = inputobj.

  CALL METHOD lref_sf_status->status_object
    EXPORTING
      arbpl            = arbpl
      aufnr            = aufnr
      vornr            = vornr
      werks            = inputobj-werks
      objty            = objty
      status           = status
      stsma            = stsma
      method           = method
      status_oper      = status_oper
      actionid         = actionid
    CHANGING
      status_input_tab = status_input_tab
      status_out       = status_out
      status_desc      = status_desc
      stsma_out        = stsma_out
      return_tab       = return_tab.

  DELETE ADJACENT DUPLICATES FROM return_tab.
ENDFUNCTION.
