FUNCTION zabsf_pp_set_password.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_USERNAME) TYPE  XUBNAME
*"     REFERENCE(IV_PASSWORD) TYPE  XUNCODE
*"----------------------------------------------------------------------

*  CHECK zabsf_pp_cl_authentication=>is_shopfloor_user( iv_username ).

  gv_username = iv_username.
  gv_password = iv_password.
ENDFUNCTION.
