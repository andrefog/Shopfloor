FUNCTION ZABSF_PM_GET_FUNC_LOCATIONS .
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(ET_FUNC_LOC) TYPE  ZABSF_PM_T_WCT_FUNC_LOC
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

*  Variables
  DATA: l_langu TYPE spras.

*  Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.

CALL METHOD ZCL_ABSF_PM=>get_func_locations
  EXPORTING
    i_werks           = inputobj-werks
  IMPORTING
    et_func_location  = et_func_loc.


ENDFUNCTION.
