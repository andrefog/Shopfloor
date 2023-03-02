FUNCTION zabsf_pp_upd_password.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_USERNAME) TYPE  XUBNAME
*"     VALUE(IV_PWD_HASH) TYPE  PWD_HASH_STRING
*"----------------------------------------------------------------------

  CHECK iv_username EQ gv_username.

  " Check and remove ssha signature
  REPLACE FIRST OCCURRENCE OF '{x-issha, 1024}'
    IN iv_pwd_hash WITH '' IN CHARACTER MODE.

  IF sy-subrc IS NOT INITIAL.
    " if not find the signature, use password in plain text
    iv_pwd_hash = gv_password.
  ENDIF.

  " Update passwords
  zabsf_pp_cl_authentication=>new_update_sap_user_pwd(
    iv_username        = CONV #( iv_username )
    iv_password        = CONV #( gv_password )
    iv_hashed_password = CONV #( iv_pwd_hash ) ).
ENDFUNCTION.
