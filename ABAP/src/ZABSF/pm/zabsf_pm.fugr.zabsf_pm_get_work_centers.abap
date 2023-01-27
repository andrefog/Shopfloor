FUNCTION ZABSF_PM_GET_WORK_CENTERS .
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(ET_WORKCENTERS) TYPE  ZABSF_PM_T_WRKCTR
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

*  Variables
  DATA: l_langu TYPE spras.

*  Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.

  CALL METHOD ZCL_ABSF_PM=>get_workcenters
    EXPORTING
      i_inputobj    = inputobj
      i_verwe       = '0001'
    IMPORTING
      et_workcenter = et_workcenters.


ENDFUNCTION.
