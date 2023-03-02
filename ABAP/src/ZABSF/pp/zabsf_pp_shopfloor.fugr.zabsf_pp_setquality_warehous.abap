FUNCTION ZABSF_PP_SETQUALITY_WAREHOUS.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(WAREID) TYPE  ZABSF_PP_E_WAREID
*"     VALUE(MATNR) TYPE  MATNR
*"     VALUE(REWORK_TAB) TYPE  ZABSF_PP_T_REWORK OPTIONAL
*"     VALUE(SCRAP_QTY) TYPE  RU_XMNGA OPTIONAL
*"     VALUE(GRUND) TYPE  CO_AGRND OPTIONAL
*"     VALUE(LMNGA) TYPE  LMNGA OPTIONAL
*"     VALUE(GMEIN) TYPE  MEINS OPTIONAL
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"--------------------------------------------------------------------
DATA lref_sf_warehouse TYPE REF TO zabsf_pp_cl_warehouse.

  CREATE OBJECT lref_sf_warehouse
    EXPORTING
      initial_refdt = refdt
      input_object  = inputobj.

  CALL METHOD lref_sf_warehouse->set_quality_ware
    EXPORTING
      wareid     = wareid
      matnr      = matnr
      rework_tab = rework_tab
      scrap_qty  = scrap_qty
      grund      = grund
      lmnga      = lmnga
      gmein      = gmein
    CHANGING
      return_tab = return_tab.

  DELETE ADJACENT DUPLICATES FROM return_tab.





ENDFUNCTION.
