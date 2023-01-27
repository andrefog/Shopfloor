FUNCTION ZABSF_PM_GET_FUNC_LOC_TREE.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"     VALUE(I_STEXT) TYPE  CHAR30 OPTIONAL
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"  EXPORTING
*"     VALUE(ET_FUNC_LOC_TREE) TYPE  ZABSF_PM_T_FUN_LOC_EQU_LIST
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------


  DATA: l_langu TYPE spras.

*  Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.


  CALL METHOD ZCL_ABSF_PM=>get_func_locations_tree
    EXPORTING
      i_inputobj       = inputobj
      i_stext          = i_stext
      i_refdt          = refdt
    IMPORTING
      et_func_loc_tree = et_func_loc_tree.



ENDFUNCTION.
