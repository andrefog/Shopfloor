FUNCTION ZABSF_PM_GET_MACHINE_EQUIPMTS .
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(REFDT) TYPE  VVDATUM OPTIONAL
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"     VALUE(I_EQUNR) TYPE  EQUNR
*"  EXPORTING
*"     VALUE(ET_EQUIPMENTS) TYPE  ZABSF_PM_T_SUB_EQUIPMENTS_LIST
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
*  Variables
  DATA: l_langu TYPE spras.

*  Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.

  CALL METHOD ZCL_ABSF_PM=>get_machine_subequip
    EXPORTING
      i_werks     = inputobj-werks
      i_equnr     = i_equnr
    IMPORTING
      et_subequip = et_equipments.


ENDFUNCTION.
