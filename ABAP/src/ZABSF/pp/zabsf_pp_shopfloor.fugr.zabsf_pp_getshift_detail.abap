FUNCTION zabsf_pp_getshift_detail .
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(AREAID) TYPE  ZABSF_PP_E_AREAID OPTIONAL
*"     VALUE(WERKS) TYPE  WERKS_D OPTIONAL
*"     VALUE(SHIFTID) TYPE  ZABSF_PP_E_SHIFTID
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(REFHR) TYPE  ADUHR DEFAULT SY-UZEIT
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(SHIFT_DETAIL) TYPE  ZABSF_PP_S_SHIFT_DETAIL
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  DATA lref_sf_shifts TYPE REF TO zabsf_pp_cl_shift.
  DATA ls_return TYPE bapiret2.

  CREATE OBJECT lref_sf_shifts
    EXPORTING
      initial_refdt = refdt
      initial_refhr = refhr
      input_object  = inputobj.

  CALL METHOD lref_sf_shifts->get_shift_detail
    EXPORTING
      areaid       = inputobj-areaid "Areaid
      werks        = inputobj-werks  "Areaid
      shiftid      = shiftid
    CHANGING
      shift_detail = shift_detail
      return_tab   = return_tab
    EXCEPTIONS
      not_found    = 1
      OTHERS       = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  DELETE ADJACENT DUPLICATES FROM return_tab.
ENDFUNCTION.
