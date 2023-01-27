function zabsf_pp_gethrchy_detail .
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(AREAID) TYPE  ZABSF_PP_E_AREAID OPTIONAL
*"     VALUE(WERKS) TYPE  WERKS_D OPTIONAL
*"     VALUE(SHIFTID) TYPE  ZABSF_PP_E_SHIFTID OPTIONAL
*"     VALUE(HNAME) TYPE  CR_HNAME
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"     VALUE(NO_SHIFT_CHECK) TYPE  BOOLE_D OPTIONAL
*"  EXPORTING
*"     VALUE(HRCHY_DETAIL) TYPE  ZABSF_PP_S_HRCHY_DETAIL
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  data lref_sf_hrchy type ref to zabsf_pp_cl_hrchy.
  data ls_return type bapiret2.

  create object lref_sf_hrchy
    exporting
      initial_refdt = refdt
      input_object  = inputobj.

*Get hierarchy detail
  call method lref_sf_hrchy->get_hierarchy_detail
    exporting
      areaid         = inputobj-areaid    "Areaid
      werks          = inputobj-werks     "Werks
      shiftid        = shiftid
      hname          = hname
      no_shift_check = no_shift_check
    changing
      hrchy_detail   = hrchy_detail
      return_tab     = return_tab.

  delete adjacent duplicates from return_tab.
endfunction.
