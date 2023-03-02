FUNCTION ZABSF_PP_GETSHIFTS.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(AREAID) TYPE  ZABSF_PP_E_AREAID OPTIONAL
*"     VALUE(WERKS) TYPE  WERKS_D OPTIONAL
*"     VALUE(ALL_SHIFT) TYPE  FLAG OPTIONAL
*"     VALUE(TIME) TYPE  ATIME OPTIONAL
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(REFHR) TYPE  ADUHR DEFAULT SY-UZEIT
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(SHIFT_TAB) TYPE  ZABSF_PP_T_SHIFT
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"--------------------------------------------------------------------
DATA lref_sf_shifts TYPE REF TO zabsf_pp_cl_shift.
  DATA ls_return TYPE bapiret2.

  CREATE OBJECT lref_sf_shifts
    EXPORTING
      initial_refdt = refdt
      initial_refhr = refhr
      input_object  = inputobj.


  CALL METHOD lref_sf_shifts->get_shifts
    EXPORTING
      areaid     = inputobj-areaid "Areaid
      werks      = inputobj-werks  "Werks
      all_shift  = all_shift
      time       = time
    CHANGING
      shift_tab  = shift_tab
      return_tab = return_tab.

  DELETE ADJACENT DUPLICATES FROM return_tab.





ENDFUNCTION.
