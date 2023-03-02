FUNCTION zabsf_pp_pwd_change.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"----------------------------------------------------------------------
  CLEAR gv_passwd_input.

  SELECT SINGLE *
    FROM usr02
    INTO @DATA(ls_usr02)
    WHERE bname EQ @sy-uname.

  CHECK ls_usr02-pwdchgdate EQ sy-datum.

  SELECT SINGLE lastpwd
    FROM zsf_userssap
    INTO @DATA(lv_lastpwd)
    WHERE usersap EQ @sy-uname.

  CHECK lv_lastpwd NE ls_usr02-pwdsaltedhash.

  IF sy-subrc IS INITIAL OR zabsf_pp_cl_authentication=>check_sicf_user( sy-uname ).
    CALL SCREEN 2000 STARTING AT 3 10.
  ENDIF.

  CHECK gv_passwd_input IS NOT INITIAL.

  " Update passwords
  zabsf_pp_cl_authentication=>new_update_sap_user_pwd(
    iv_username = CONV #( sy-uname )
    iv_password = CONV #( gv_passwd_input ) ).

  UPDATE zsf_userssap
    SET lastpwd = ls_usr02-pwdsaltedhash
    WHERE usersap EQ sy-uname.
ENDFUNCTION.
