FUNCTION zabsf_pp_getwarehouse.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(WAREHOUSE_TAB) TYPE  ZABSF_PP_T_WAREHOUSE
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
  DATA lref_sf_warehouse TYPE REF TO zabsf_pp_cl_warehouse.

  CREATE OBJECT lref_sf_warehouse
    EXPORTING
      initial_refdt = refdt
      input_object  = inputobj.

  CALL METHOD lref_sf_warehouse->get_warehouses
    CHANGING
      warehouse_tab = warehouse_tab
      return_tab    = return_tab.

  DELETE ADJACENT DUPLICATES FROM return_tab.
ENDFUNCTION.
