FUNCTION ZABSF_PP_SETUSER.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(SHIFTID) TYPE  ZABSF_PP_E_SHIFTID
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"--------------------------------------------------------------------
DATA lref_sf_user TYPE REF TO zabsf_pp_cl_user.

  CREATE OBJECT lref_sf_user
    EXPORTING
      initial_refdt = refdt
      input_object  = inputobj.

  CALL METHOD lref_sf_user->set_user_shift
    EXPORTING
      shiftid    = shiftid
    CHANGING
      return_tab = return_tab.

  DELETE ADJACENT DUPLICATES FROM return_tab.





ENDFUNCTION.
