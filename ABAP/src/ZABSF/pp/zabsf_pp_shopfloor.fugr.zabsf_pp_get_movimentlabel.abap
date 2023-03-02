FUNCTION zabsf_pp_get_movimentlabel.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_MATNR) TYPE  MATNR
*"     VALUE(IV_MAKTX) TYPE  MAKTX
*"     VALUE(IV_CHARG) TYPE  CHARG_D
*"     VALUE(IV_VORNRORI) TYPE  VORNR
*"     VALUE(IV_VORNRDEST) TYPE  VORNR
*"     VALUE(IV_REFDT) TYPE  DATUM DEFAULT SY-DATUM
*"     VALUE(IS_INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(EV_PDF) TYPE  STRING
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  DATA(lv_printer) =
    zabsf_pp_cl_utils=>get_printer(
      iv_areaid   = is_inputobj-areaid  " Shopfloor - Area
      iv_werks    = is_inputobj-werks   " Plant
      iv_sform    = 'ZSHOPFLOOR_LB'  " PDF/Smart Form: Form Name
  ).

  SUBMIT zabsf_pp_lb
    WITH p_matnr = iv_matnr
    WITH p_charg = iv_charg
    WITH p_vornro = iv_vornrori
    WITH p_vornrd = iv_vornrdest
    WITH p_prntr = lv_printer
    AND RETURN.

  ev_pdf = gv_pdf.
ENDFUNCTION.
