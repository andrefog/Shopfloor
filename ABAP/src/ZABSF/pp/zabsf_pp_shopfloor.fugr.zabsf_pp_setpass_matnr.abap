FUNCTION zabsf_pp_setpass_matnr .
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(HNAME) TYPE  CR_HNAME
*"     VALUE(RPOINT) TYPE  ZABSF_PP_E_RPOINT
*"     VALUE(MATNR) TYPE  MATNR
*"     VALUE(GERNR) TYPE  GERNR
*"     VALUE(PASSNUMBER) TYPE  ZABSF_PP_E_PASSNUMBER
*"     VALUE(FLAG_DEF) TYPE  ZABSF_PP_E_FLAG_DEF
*"     VALUE(DEFECTID) TYPE  ZABSF_PP_E_DEFECTID OPTIONAL
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

  CALL METHOD lref_sf_rpoint->set_pass_material
    EXPORTING
      hname      = hname
      rpoint     = rpoint
      matnr      = matnr
      gernr      = gernr
      passnumber = passnumber
      flag_def   = flag_def
      defectid   = defectid
    CHANGING
      return_tab = return_tab.

  DELETE ADJACENT DUPLICATES FROM return_tab.
ENDFUNCTION.
