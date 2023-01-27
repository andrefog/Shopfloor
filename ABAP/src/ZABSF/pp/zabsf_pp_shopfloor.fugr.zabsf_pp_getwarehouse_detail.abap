FUNCTION zabsf_pp_getwarehouse_detail.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(WAREID) TYPE  ZABSF_PP_E_WAREID
*"     VALUE(MATNR) TYPE  MATNR OPTIONAL
*"     VALUE(HNAME) TYPE  CR_HNAME OPTIONAL
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(WAREHOUSE_TAB) TYPE  ZABSF_PP_T_WAREHOUSE
*"     VALUE(WAREH_DETAIL_TAB) TYPE  ZABSF_PP_T_WAREH_DETAIL
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
  DATA lref_sf_warehouse TYPE REF TO zabsf_pp_cl_warehouse.

  CREATE OBJECT lref_sf_warehouse
    EXPORTING
      initial_refdt = refdt
      input_object  = inputobj.

  CALL METHOD lref_sf_warehouse->get_warehouses_detail
    EXPORTING
      wareid           = wareid
      matnr            = matnr
      hname            = hname
    CHANGING
      warehouse_tab    = warehouse_tab
      wareh_detail_tab = wareh_detail_tab
      return_tab       = return_tab.

  DELETE ADJACENT DUPLICATES FROM return_tab.
ENDFUNCTION.
