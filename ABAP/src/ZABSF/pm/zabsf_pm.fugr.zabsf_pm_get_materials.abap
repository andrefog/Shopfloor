FUNCTION ZABSF_PM_GET_MATERIALS.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(REFDT) TYPE  VVDATUM OPTIONAL
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"     VALUE(I_MATNR) TYPE  MATNR OPTIONAL
*"     VALUE(I_MAKTX) TYPE  MAKTX OPTIONAL
*"  EXPORTING
*"     VALUE(ET_MATERIALS) TYPE  ZABSF_PM_T_MATERIALS_LIST
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
*  Variables
  DATA: l_langu TYPE spras.

*  Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.

  CALL METHOD ZCL_ABSF_PM=>get_materials
    EXPORTING
      i_werks      = inputobj-werks
      i_matnr      = i_matnr
      i_maktx      = i_maktx
    IMPORTING
      et_materials = et_materials.

ENDFUNCTION.
