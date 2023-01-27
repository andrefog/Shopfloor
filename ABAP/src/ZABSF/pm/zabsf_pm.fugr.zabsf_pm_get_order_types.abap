FUNCTION ZABSF_PM_GET_ORDER_TYPES .
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"     VALUE(I_FOR_CREATION) TYPE  BOOLE_D OPTIONAL
*"     VALUE(I_SERV_TYPE) TYPE  ZABSF_PM_SERV_TYPE OPTIONAL
*"  EXPORTING
*"     VALUE(ET_ORDER_TYPE) TYPE  ZABSF_PM_T_ORDER_TYPES_LIST
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
*  Variables
  DATA: l_langu TYPE spras.

*  Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.

  CALL METHOD ZCL_ABSF_PM=>get_order_types
    EXPORTING
      i_werks        = inputobj-werks
      i_for_creation = i_for_creation
      i_serv_type    = i_serv_type
    IMPORTING
      et_order_type  = et_order_type.

ENDFUNCTION.
