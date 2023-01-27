FUNCTION zabsf_pp_setquality_rpoint.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(RPOINT) TYPE  ZABSF_PP_E_RPOINT
*"     VALUE(MATNR) TYPE  MATNR
*"     VALUE(REWORK_TAB) TYPE  ZABSF_PP_T_REWORK OPTIONAL
*"     VALUE(SCRAP_QTY) TYPE  RU_XMNGA OPTIONAL
*"     VALUE(GRUND) TYPE  CO_AGRND OPTIONAL
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
  DATA lref_sf_rpoint TYPE REF TO zabsf_pp_cl_rpoint.

  CREATE OBJECT lref_sf_rpoint
    EXPORTING
      initial_refdt = refdt
      input_object  = inputobj.

  CALL METHOD lref_sf_rpoint->set_quality_rpoint
    EXPORTING
      rpoint     = rpoint
      matnr      = matnr
      rework_tab = rework_tab
      scrap_qty  = scrap_qty
      grund      = grund
    CHANGING
      return_tab = return_tab.

  DELETE ADJACENT DUPLICATES FROM return_tab.
ENDFUNCTION.
