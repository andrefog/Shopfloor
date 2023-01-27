FUNCTION zabsf_pp_getdefects_ware .
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(WAREID) TYPE  ZABSF_PP_E_WAREID
*"     VALUE(REASONTYP) TYPE  ZABSF_PP_E_REASONTYP
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(DEFECT_WARE_TAB) TYPE  ZABSF_PP_T_DEFECT_WARE
*"     VALUE(REASON_TAB) TYPE  ZABSF_PP_T_REASON
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
  DATA lref_sf_warehouse TYPE REF TO zabsf_pp_cl_warehouse.

  CREATE OBJECT lref_sf_warehouse
    EXPORTING
      initial_refdt = refdt
      input_object  = inputobj.

  CALL METHOD lref_sf_warehouse->get_defects_ware
    EXPORTING
      wareid          = wareid
      reasontyp       = reasontyp
    CHANGING
      defect_ware_tab = defect_ware_tab
      reason_tab      = reason_tab
      return_tab      = return_tab.
ENDFUNCTION.
