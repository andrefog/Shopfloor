FUNCTION zabsf_pp_get_dashboard1 .
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(IV_HNAME) TYPE  CR_HNAME OPTIONAL
*"     VALUE(IV_ARBPL) TYPE  ARBPL OPTIONAL
*"     VALUE(IS_INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(EV_OEE) TYPE  STRING
*"     VALUE(EV_AVAILABILITY) TYPE  STRING
*"     VALUE(EV_PERFORMANCE) TYPE  STRING
*"     VALUE(EV_QUALITY) TYPE  STRING
*"     VALUE(ET_EVOLUTION) TYPE  ZABSF_PP_T_DASHB_EVOLUTION
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  DATA(lo_dashboard) =
    NEW zabsf_pp_cl_dashboard(
      input_refdt    = iv_refdt
      input_inputobj = is_inputobj
      ir_hname       = COND #( WHEN iv_hname IS NOT INITIAL THEN VALUE #( ( sign = 'I' option = 'EQ' low = iv_hname ) ) )
      ir_arbpl       = COND #( WHEN iv_arbpl IS NOT INITIAL THEN VALUE #( ( sign = 'I' option = 'EQ' low = iv_arbpl ) ) ) ).

  lo_dashboard->get_workcenter_dashboard(
    IMPORTING ev_oee          = DATA(lv_oee)
              ev_availability = DATA(lv_availability)
              ev_performance  = DATA(lv_performance)
              ev_quality      = DATA(lv_quality)
              et_evolution    = et_evolution ).

  ev_oee          = lv_oee.
  ev_availability = lv_availability.
  ev_performance  = lv_performance.
  ev_quality      = lv_quality.
ENDFUNCTION.
