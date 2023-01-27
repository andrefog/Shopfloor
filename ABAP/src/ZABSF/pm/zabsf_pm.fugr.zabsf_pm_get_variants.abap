FUNCTION ZABSF_PM_GET_VARIANTS .
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"     VALUE(I_PROG) TYPE  RSVAR-REPORT
*"  EXPORTING
*"     VALUE(ET_VARIANTS) TYPE  ZABSF_PM_T_VARIANT
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
*&---------------------------------------------------------------------*
*  CREATION:     23.06.2017 by Cidália Correia (CBC) - Abaco Consultores
*  DESCRIPTION:  Get the variants list for a given progran and user
*&--------------------------------------------------------------------*

*  Variables
  DATA: lv_langu TYPE spras.


*  Set local language for user
  lv_langu = inputobj-language.

  SET LOCALE LANGUAGE lv_langu.


  CALL METHOD ZCL_ABSF_PM=>get_variants
    EXPORTING
      i_werks    = inputobj-werks
      i_pernr    = inputobj-pernr
      i_langu    = lv_langu
      i_prog     = i_prog
    IMPORTING
      e_var_info = et_variants
      et_return  = return_tab.

ENDFUNCTION.
