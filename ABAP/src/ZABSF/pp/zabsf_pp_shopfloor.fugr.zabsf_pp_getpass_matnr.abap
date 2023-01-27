FUNCTION zabsf_pp_getpass_matnr .
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(HNAME) TYPE  CR_HNAME
*"     VALUE(RPOINT) TYPE  ZABSF_PP_E_RPOINT
*"     VALUE(MATNR) TYPE  MATNR
*"     VALUE(GERNR) TYPE  GERNR
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(PASSNUMBER) TYPE  ZABSF_PP_E_PASSNUMBER
*"     VALUE(DEFECTS_TAB) TYPE  ZABSF_PP_T_DEFECTS
*"     VALUE(PASSAGE_TAB) TYPE  ZABSF_PP_T_PASSAGE
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
  DATA lref_sf_rpoint TYPE REF TO zabsf_pp_cl_rpoint.

  CREATE OBJECT lref_sf_rpoint
    EXPORTING
      initial_refdt = refdt
      input_object  = inputobj.

  CALL METHOD lref_sf_rpoint->get_pass_material
    EXPORTING
      hname       = hname
      rpoint      = rpoint
      matnr       = matnr
      gernr       = gernr
    CHANGING
      passnumber  = passnumber
      defects_tab = defects_tab
      passage_tab = passage_tab
      return_tab  = return_tab.

  DELETE ADJACENT DUPLICATES FROM return_tab.
ENDFUNCTION.
