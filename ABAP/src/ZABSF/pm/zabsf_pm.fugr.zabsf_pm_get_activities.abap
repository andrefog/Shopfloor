FUNCTION ZABSF_PM_GET_ACTIVITIES.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(REFDT) TYPE  VVDATUM OPTIONAL
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(ET_ACTIVITIES) TYPE  ZABSF_PM_T_PM_ACTIVITIES
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

*  Variables
  DATA: l_langu TYPE spras.

*  Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.

  CALL METHOD ZCL_ABSF_PM=>get_pm_activities
    EXPORTING
      i_inputobj    = inputobj
    IMPORTING
      et_activities = et_activities.



ENDFUNCTION.
