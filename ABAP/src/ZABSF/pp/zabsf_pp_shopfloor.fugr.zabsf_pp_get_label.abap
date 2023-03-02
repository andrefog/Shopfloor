FUNCTION zabsf_pp_get_label.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_MATNR) TYPE  MATNR
*"     VALUE(IV_AUFNR) TYPE  AUFNR
*"     VALUE(IV_VORNR) TYPE  VORNR
*"     VALUE(IV_ARBPL) TYPE  ARBPL OPTIONAL
*"     VALUE(IV_WORKCENTERDESCRIPTION) TYPE  CR_KTEXT OPTIONAL
*"     VALUE(IV_TYPE) TYPE  CHAR1 OPTIONAL
*"     VALUE(IV_QTYPARC) TYPE  STRING OPTIONAL
*"     VALUE(IV_REFDT) TYPE  DATUM DEFAULT SY-DATUM
*"     VALUE(IS_INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(EV_PDF) TYPE  STRING
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  IF iv_arbpl IS NOT INITIAL.
    DATA(lv_printer) =
      zabsf_pp_cl_utils=>get_printer(
        iv_areaid   = is_inputobj-areaid  " Shopfloor - Area
        iv_werks    = is_inputobj-werks   " Plant
        iv_arbpl    = iv_arbpl            " Work Center
        iv_sform    = 'ZSHOPFLOORLABELS'  " PDF/Smart Form: Form Name
    ).
  ENDIF.

  SUBMIT zabsf_pp_labels
    WITH pa_matnr = iv_matnr
    WITH pa_aufnr = iv_aufnr
    WITH pa_vornr = iv_vornr
    WITH pa_workc = iv_arbpl
    WITH pa_workd = iv_workcenterdescription
    WITH pa_type  = iv_type
    WITH pa_qtyp  = iv_qtyparc
    WITH pa_prntr = lv_printer
    WITH pa_werks = is_inputobj-werks
    AND RETURN.

  ev_pdf = gv_pdf.
ENDFUNCTION.
