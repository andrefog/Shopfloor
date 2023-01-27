FUNCTION zabsf_pm_print_order.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(I_AUFNR) TYPE  AUFNR
*"     VALUE(I_INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  DATA: l_langu TYPE spras.

*  Set local language for user
*  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.

  CALL METHOD zcl_absf_pm=>print_pm_order
    EXPORTING
      i_aufnr       = i_aufnr
      i_inputobj    = i_inputobj
    IMPORTING
      et_return_tab = return_tab.

ENDFUNCTION.
