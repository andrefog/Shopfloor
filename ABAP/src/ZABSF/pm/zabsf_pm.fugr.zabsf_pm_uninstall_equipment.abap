FUNCTION zabsf_pm_uninstall_equipment.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(REFDT) TYPE  VVDATUM OPTIONAL
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"     VALUE(I_EQUIPMENT) TYPE  EQUNR
*"     VALUE(I_MACHINE) TYPE  EQUNR OPTIONAL
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

*Variables
  DATA: l_langu TYPE spras.

*Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.

  CALL METHOD zcl_absf_pm=>uninstall_eqpmt_from_machine
    EXPORTING
      i_inputobj  = inputobj
      i_equipment = i_equipment
      i_machine   = i_machine
    IMPORTING
      et_return   = return_tab.


ENDFUNCTION.
