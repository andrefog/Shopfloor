FUNCTION ZABSF_PP_GET_PASSWORD.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  EXPORTING
*"     REFERENCE(EV_USERNAME) TYPE  XUBNAME
*"     REFERENCE(EV_PASSWORD) TYPE  XUNCODE
*"----------------------------------------------------------------------

*  CHECK zabsf_pp_cl_authentication=>is_shopfloor_user( iv_username ).

  ev_username = gv_username.
  ev_password = gv_password.
ENDFUNCTION.
