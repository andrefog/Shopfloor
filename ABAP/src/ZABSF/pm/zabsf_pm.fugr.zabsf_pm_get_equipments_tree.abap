FUNCTION zabsf_pm_get_equipments_tree.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(I_TPLNR) TYPE  TPLNR OPTIONAL
*"     VALUE(I_EQUNR) TYPE  EQUNR OPTIONAL
*"  EXPORTING
*"     VALUE(ET_EQUIPMENTS_TREE) TYPE  ZABSF_PM_T_FUN_LOC_EQU_LIST
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  DATA: l_langu TYPE spras.

*  Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.


  CALL METHOD zcl_absf_pm=>get_equipment_tree
    EXPORTING
      i_inputobj         = inputobj
      i_tplnr            = i_tplnr
      i_equnr            = i_equnr
      i_refdt            = refdt
    IMPORTING
      et_equipments_tree = et_equipments_tree.

ENDFUNCTION.
