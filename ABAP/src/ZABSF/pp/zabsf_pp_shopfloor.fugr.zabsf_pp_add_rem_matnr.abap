FUNCTION ZABSF_PP_ADD_REM_MATNR.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(HNAME) TYPE  CR_HNAME
*"     VALUE(RPOINT) TYPE  ZABSF_PP_E_RPOINT
*"     VALUE(MATNR) TYPE  MATNR
*"     VALUE(ADD_REM) TYPE  ZABSF_PP_E_ADD_REM
*"     VALUE(VORNR) TYPE  VORNR
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

  CALL METHOD lref_sf_rpoint->add_rem_matnr
    EXPORTING
      hname      = hname
      rpoint     = rpoint
      matnr      = matnr
      add_rem    = add_rem
      vornr      = vornr
    CHANGING
      return_tab = return_tab.

  DELETE ADJACENT DUPLICATES FROM return_tab.





ENDFUNCTION.
