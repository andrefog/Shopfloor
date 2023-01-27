FUNCTION ZABSF_PM_GET_ORDERS .
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"     VALUE(FILTER_OPTIONS) TYPE  ZABSF_PM_S_ORDERFILTER_OPTIONS
*"       OPTIONAL
*"     VALUE(VARIANT) TYPE  VARIANT OPTIONAL
*"  EXPORTING
*"     VALUE(ET_ORDERS_LIST) TYPE  ZABSF_PM_T_ORDER_LIST
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

*  Variables
  DATA: l_langu TYPE spras.

*  Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.

  CALL METHOD ZCL_ABSF_PM=>get_pm_orders
    EXPORTING
      i_filters      = filter_options
      i_inputobj     = inputobj
      i_variant      = variant
    CHANGING
      et_orders_list = et_orders_list
      et_returntab   = return_tab.

ENDFUNCTION.
