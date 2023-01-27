FUNCTION zabsf_pp_getord_to_conf .
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(MATNR) TYPE  MATNR
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(STOCK) TYPE  ZABSF_PP_E_STOCK
*"     VALUE(GOODMVT_TAB) TYPE  ZABSF_PP_T_GOODMVT
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
  DATA lref_sf_warehouse TYPE REF TO zabsf_pp_cl_warehouse.

  CREATE OBJECT lref_sf_warehouse
    EXPORTING
      initial_refdt = refdt
      input_object  = inputobj.

  CALL METHOD lref_sf_warehouse->get_order_to_conf
    EXPORTING
      matnr       = matnr
    CHANGING
      stock       = stock
      goodmvt_tab = goodmvt_tab
      return_tab  = return_tab.

  DELETE ADJACENT DUPLICATES FROM return_tab.
ENDFUNCTION.
