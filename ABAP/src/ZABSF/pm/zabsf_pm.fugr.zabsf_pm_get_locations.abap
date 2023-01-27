FUNCTION ZABSF_PM_GET_LOCATIONS.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(REFDT) TYPE  VVDATUM OPTIONAL
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(ET_LOCATIONS) TYPE  ZABSF_PM_T_LOCATIONS
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
*{   INSERT         S4HK900197                                        1

*  Variables
  DATA: l_langu TYPE spras.

*  Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.

  CALL METHOD ZCL_ABSF_PM=>get_locations
    EXPORTING
      i_inputobj   = inputobj
    IMPORTING
      et_locations = et_locations.



*}   INSERT
ENDFUNCTION.
