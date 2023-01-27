FUNCTION ZABSF_PM_GET_STOCK_DATA.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(REFDT) TYPE  VVDATUM OPTIONAL
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"     VALUE(I_MATNR) TYPE  MATNR OPTIONAL
*"     VALUE(I_MAKTX) TYPE  MAKTX OPTIONAL
*"  EXPORTING
*"     VALUE(ET_STOCK_LIST) TYPE  ZABSF_PM_T_MATERIALS_STCK
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
*  Variables
  DATA: l_langu TYPE spras.

*  Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.

  CALL METHOD ZCL_ABSF_PM=>get_materials_stock
    EXPORTING
      i_werks           = inputobj-werks
      i_matnr           = i_matnr
      i_maktx           = i_maktx
    IMPORTING
      et_material_stock = et_stock_list.

ENDFUNCTION.
