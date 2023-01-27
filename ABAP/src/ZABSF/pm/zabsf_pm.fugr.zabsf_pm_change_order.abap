FUNCTION zabsf_pm_change_order.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(REFDT) TYPE  VVDATUM OPTIONAL
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"     VALUE(I_AUFNR) TYPE  AUFNR
*"     VALUE(I_PERNR) TYPE  CO_PERNR OPTIONAL
*"     VALUE(I_RSP_USER) TYPE  CO_PERNR OPTIONAL
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
*  Variables
  DATA: l_langu TYPE spras.

*  Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.

  CALL METHOD zcl_absf_pm=>change_order
    EXPORTING
      i_inputobj   = inputobj
      i_aufnr      = i_aufnr
      i_pernr      = i_pernr
      i_rsp_user   = i_rsp_user
    IMPORTING
      et_returntab = return_tab.

ENDFUNCTION.
