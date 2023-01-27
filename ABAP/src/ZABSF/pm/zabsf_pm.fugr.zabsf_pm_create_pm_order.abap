FUNCTION zabsf_pm_create_pm_order.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(AUART) TYPE  AUFART
*"     VALUE(ILART) TYPE  ILA OPTIONAL
*"     VALUE(QMNUM) TYPE  QMNUM
*"     VALUE(ARBPL) TYPE  ARBPL
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"     VALUE(ARBPL_PLANT) TYPE  WERKS_D
*"     VALUE(GSBER) TYPE  GSBER OPTIONAL
*"     VALUE(RSP_USER_RESP) TYPE  I_PARNR OPTIONAL
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
*Variables
  DATA: l_langu TYPE spras.

*Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.

*Create Maintenance order from notification
  CALL METHOD zcl_absf_pm=>create_pm_order
    EXPORTING
      i_auart       = auart
      i_ilart       = ilart
      i_qmnum       = qmnum
      i_arbpl       = arbpl
      i_inputobj    = inputobj
      i_gsber       = gsber
      i_arbpl_plant = arbpl_plant
      i_rsp_user_resp = rsp_user_resp
    IMPORTING
      et_return_tab = return_tab.

ENDFUNCTION.
