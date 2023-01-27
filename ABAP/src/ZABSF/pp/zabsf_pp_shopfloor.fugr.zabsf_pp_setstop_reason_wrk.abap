FUNCTION zabsf_pp_setstop_reason_wrk .
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(ARBPL) TYPE  ARBPL
*"     VALUE(WERKS) TYPE  WERKS_D OPTIONAL
*"     VALUE(DATESR) TYPE  ZABSF_PP_E_DATE
*"     VALUE(TIME) TYPE  ATIME
*"     VALUE(STPRSNID) TYPE  ZABSF_PP_E_STPRSNID
*"     VALUE(ACTIONID) TYPE  ZABSF_PP_E_ACTION OPTIONAL
*"     VALUE(COUNT_FIN_TAB) TYPE  ZABSF_PP_T_COUNTERS OPTIONAL
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
*References
  DATA lref_sf_stop TYPE REF TO zabsf_pp_cl_stop_reason.

*Create obect
  CREATE OBJECT lref_sf_stop
    EXPORTING
      initial_refdt = refdt
      input_object  = inputobj.

*Save time stop confirmation
  CALL METHOD lref_sf_stop->set_stop_reason_wrk
    EXPORTING
      arbpl         = arbpl
      werks         = inputobj-werks  "Werks
      datesr        = datesr
      time          = time
      stprsnid      = stprsnid
      count_fin_tab = count_fin_tab
    CHANGING
      actionid      = actionid
      return_tab    = return_tab.

  DELETE ADJACENT DUPLICATES FROM return_tab.

ENDFUNCTION.
