FUNCTION ZABSF_PM_GET_ORDERS_ASSOCIATE .
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"     VALUE(I_AUFNR) TYPE  AUFNR OPTIONAL
*"     VALUE(I_QMNUM) TYPE  QMNUM
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"     VALUE(ET_ORDERS) TYPE  ZABSF_PM_T_ORDERS_TO_ASSOCIATE
*"----------------------------------------------------------------------

*  Variables
  DATA: l_langu TYPE spras.

*  Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.

  CALL METHOD ZCL_ABSF_PM=>get_orders_to_associate
    EXPORTING
      i_refdt       = refdt
      i_inputobj    = inputobj
      i_aufnr       = i_aufnr
      i_qmnum       = i_qmnum
    IMPORTING
      et_return_tab = return_tab
      et_orders     = et_orders.



ENDFUNCTION.
