FUNCTION zabsf_pp_gethrchy_detail.
*"--------------------------------------------------------------------
*"*"Local Interface:
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
*"--------------------------------------------------------------------
  DATA lref_sf_hrchy TYPE REF TO zabsf_pp_cl_hrchy.
  DATA ls_return TYPE bapiret2.

  CREATE OBJECT lref_sf_hrchy
    EXPORTING
      initial_refdt = refdt
      input_object  = inputobj.

*Get hierarchy detail
  CALL METHOD lref_sf_hrchy->get_hierarchy_detail
    EXPORTING
      areaid         = inputobj-areaid    "Areaid
      werks          = inputobj-werks     "Werks
      shiftid        = shiftid
      hname          = hname
      oprid          = inputobj-oprid
      no_shift_check = no_shift_check
    CHANGING
      hrchy_detail   = hrchy_detail
      return_tab     = return_tab.

  DELETE ADJACENT DUPLICATES FROM return_tab.





ENDFUNCTION.
