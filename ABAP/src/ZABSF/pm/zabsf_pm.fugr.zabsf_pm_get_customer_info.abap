FUNCTION ZABSF_PM_GET_CUSTOMER_INFO .
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(EQUNR) TYPE  EQUNR OPTIONAL
*"     VALUE(TPLNR) TYPE  TPLNR OPTIONAL
*"     VALUE(QMART) TYPE  QMART OPTIONAL
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"     VALUE(ET_CUSTOMER_INFO) TYPE  ZABSF_PM_T_CUSTOMER_INFO
*"----------------------------------------------------------------------

  DATA: l_langu TYPE spras.

*  Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.

  CALL METHOD ZCL_ABSF_PM=>get_contracts
    EXPORTING
      i_inputobj       = inputobj
      i_refdt          = refdt
      i_equnr          = equnr
      i_tplnr          = tplnr
      i_qmart          = qmart
    IMPORTING
      et_customer_info = et_customer_info.




ENDFUNCTION.
