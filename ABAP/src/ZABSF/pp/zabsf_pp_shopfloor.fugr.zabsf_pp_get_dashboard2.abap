FUNCTION zabsf_pp_get_dashboard2 .
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(IV_HNAME) TYPE  CR_HNAME OPTIONAL
*"     VALUE(IV_ARBPL) TYPE  ARBPL OPTIONAL
*"     VALUE(IS_INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(ET_AVAILABILITY) TYPE  ZABSF_PP_T_DASHB_AVAILABILITY
*"     VALUE(ET_LOSTS) TYPE  ZABSF_PP_T_DASHB_LOSTS
*"     VALUE(ET_PERFORMANCE) TYPE  ZABSF_PP_T_DASHB_PERFORMANCE
*"     VALUE(ET_QUALITY) TYPE  ZABSF_PP_T_DASHB_QUALITIES
*"     VALUE(ET_STOPS) TYPE  ZABSF_PP_T_DASHB_STOPS
*"     VALUE(ET_REVIEW) TYPE  ZABSF_PP_T_DASHB_REVIEWS
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  DATA(lo_dashboard) =
    NEW zabsf_pp_cl_dashboard(
      input_refdt    = iv_refdt
      input_inputobj = is_inputobj
      ir_hname       = COND #( WHEN iv_hname IS NOT INITIAL THEN VALUE #( ( sign = 'I' option = 'EQ' low = iv_hname ) ) )
      ir_arbpl       = COND #( WHEN iv_arbpl IS NOT INITIAL THEN VALUE #( ( sign = 'I' option = 'EQ' low = iv_arbpl ) ) ) ).

  et_availability = lo_dashboard->get_availability( ).
  et_losts        = lo_dashboard->get_losts( ).
  et_performance  = lo_dashboard->get_performance( ).
  et_quality      = lo_dashboard->get_quality( ).
  et_stops        = lo_dashboard->get_stops( ).
  et_review       = lo_dashboard->get_review( ).
ENDFUNCTION.
