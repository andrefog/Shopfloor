FUNCTION ZABSF_PM_SET_ORDER_IN_NOTIF.
*"----------------------------------------------------------------------
*"*"Interface global:
*"  IMPORTING
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"     VALUE(I_AUFNR) TYPE  AUFNR
*"     VALUE(I_QMNUM) TYPE  QMNUM
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

*  Variables
  DATA: l_langu TYPE spras.

*  Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.

  CALL METHOD ZCL_ABSF_PM=>set_order_in_notification
    EXPORTING
      i_refdt       = refdt
      i_inputobj    = inputobj
      i_aufnr       = i_aufnr
      i_qmnum       = i_qmnum
    IMPORTING
      et_return_tab = return_tab.



ENDFUNCTION.
