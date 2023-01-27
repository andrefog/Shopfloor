FUNCTION ZABSF_PM_GET_SALES_DOCS_LIST.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(VBELN) TYPE  VBELN_VA
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"     VALUE(ET_SALESDOC) TYPE  ZABSF_PM_T_SALESDOC_LIST
*"----------------------------------------------------------------------

  DATA: l_langu TYPE spras.

*  Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.

  CALL METHOD ZCL_ABSF_PM=>get_sales_docs_list
    EXPORTING
      i_inputobj  = inputobj
      i_refdt     = refdt
      i_vbeln     = vbeln
    IMPORTING
      et_salesdoc = et_salesdoc.


ENDFUNCTION.
