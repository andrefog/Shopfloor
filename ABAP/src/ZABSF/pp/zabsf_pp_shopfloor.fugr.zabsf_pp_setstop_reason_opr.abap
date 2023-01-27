FUNCTION zabsf_pp_setstop_reason_opr .
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(ARBPL) TYPE  ARBPL
*"     VALUE(AUFNR) TYPE  AUFNR
*"     VALUE(VORNR) TYPE  VORNR
*"     VALUE(DATESR) TYPE  ZABSF_PP_E_DATE
*"     VALUE(TIME) TYPE  BEGZT
*"     VALUE(OPERADOR) TYPE  ZABSF_PP_E_OPRID
*"     VALUE(STPTY) TYPE  ZABSF_PP_E_STPTY
*"     VALUE(STPRSNID) TYPE  ZABSF_PP_E_STPRSNID
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
  DATA lref_sf_stop TYPE REF TO zabsf_pp_cl_stop_reason.
  DATA ls_return TYPE bapiret2.

  CREATE OBJECT lref_sf_stop
    EXPORTING
      initial_refdt = refdt
      input_object  = inputobj.

  CALL METHOD lref_sf_stop->set_stop_reason_opr
    EXPORTING
      arbpl      = arbpl
      aufnr      = aufnr
      vornr      = vornr
      datesr     = datesr
      time       = time
      oprid      = operador
      stpty      = stpty
      stprsnid   = stprsnid
    CHANGING
      return_tab = return_tab.

  DELETE ADJACENT DUPLICATES FROM return_tab.
ENDFUNCTION.
