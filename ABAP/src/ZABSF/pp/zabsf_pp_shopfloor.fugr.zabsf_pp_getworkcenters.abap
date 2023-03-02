FUNCTION ZABSF_PP_GETWORKCENTERS.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(HNAME) TYPE  CR_HNAME
*"     VALUE(WERKS) TYPE  WERKS_D OPTIONAL
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(WRKCTR_TAB) TYPE  ZABSF_PP_T_WRKCTR
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"--------------------------------------------------------------------
DATA lref_sf_wrkctr TYPE REF TO zabsf_pp_cl_wrkctr.
  DATA ls_return TYPE bapiret2.

  CREATE OBJECT lref_sf_wrkctr
    EXPORTING
      initial_refdt = refdt
      input_object  = inputobj.

  CALL METHOD lref_sf_wrkctr->get_workcenters
    EXPORTING
      hname      = hname
      werks      = werks
    CHANGING
      wrkctr_tab = wrkctr_tab
      return_tab = return_tab.

  DELETE ADJACENT DUPLICATES FROM return_tab.





ENDFUNCTION.
