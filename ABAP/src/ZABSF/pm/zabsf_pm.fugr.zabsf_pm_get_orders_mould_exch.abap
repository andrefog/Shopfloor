FUNCTION ZABSF_PM_GET_ORDERS_MOULD_EXCH .
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"     VALUE(I_DATE_START) TYPE  DATS OPTIONAL
*"     VALUE(I_DATE_END) TYPE  DATS OPTIONAL
*"  EXPORTING
*"     VALUE(ET_ORDERS_LIST) TYPE  ZABSF_PM_T_ORDER_LIST
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

*  Variables
  DATA: l_langu TYPE spras.

*  Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.

  CALL METHOD ZCL_ABSF_PM=>get_pm_orders_mould_exchange
    EXPORTING
      i_inputobj     = inputobj
      i_date_start   = i_date_start
      i_date_end     = i_date_end
    CHANGING
      et_orders_list = et_orders_list.


ENDFUNCTION.
