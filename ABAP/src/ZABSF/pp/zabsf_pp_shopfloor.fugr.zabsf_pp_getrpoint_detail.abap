FUNCTION ZABSF_PP_GETRPOINT_DETAIL.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(HNAME) TYPE  CR_HNAME
*"     VALUE(RPOINT) TYPE  ZABSF_PP_E_RPOINT
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(RPOINT_DETAIL_TAB) TYPE  ZABSF_PP_S_RPOINT_DETAIL
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"--------------------------------------------------------------------
DATA lref_sf_rpoint TYPE REF TO zabsf_pp_cl_rpoint.

  CREATE OBJECT lref_sf_rpoint
    EXPORTING
      initial_refdt = refdt
      input_object  = inputobj.

  CALL METHOD lref_sf_rpoint->get_rpoint_detail
    EXPORTING
      hname         = hname
      rpoint        = rpoint
    CHANGING
      rpoint_detail = rpoint_detail_tab
      return_tab    = return_tab.

  DELETE ADJACENT DUPLICATES FROM return_tab.





ENDFUNCTION.
