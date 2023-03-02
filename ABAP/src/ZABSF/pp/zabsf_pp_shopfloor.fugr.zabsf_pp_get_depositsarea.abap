FUNCTION zabsf_pp_get_depositsarea.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(IV_AREA) TYPE  ZABSF_PP_E_AREAID
*"     REFERENCE(IS_INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     REFERENCE(ET_DEPOSITSAREA) TYPE  ZABSF_PP_T_DEPOSITSAREA
*"     REFERENCE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  SELECT area, werks
    FROM zsf_depositsarea
    INTO TABLE @et_depositsarea
    WHERE area EQ @iv_area.

ENDFUNCTION.
