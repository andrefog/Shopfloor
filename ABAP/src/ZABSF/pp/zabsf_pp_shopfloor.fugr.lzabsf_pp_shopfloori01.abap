*----------------------------------------------------------------------*
***INCLUDE LZABSF_PP_SHOPFLOORI01.
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  PBO_PWD_POPUP_EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pai_pwd_popup_exit INPUT.

*  "It is necessary to correctly inform the pass, so that the shopfloor system works
*  MESSAGE i398(00) DISPLAY LIKE 'E' WITH TEXT-e02 TEXT-e03 '' ''.
  LEAVE TO SCREEN 0.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PAI_PWD_POPUP_CMD  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pai_pwd_popup_cmd INPUT.
  CASE gv_okcode.
    WHEN 'OKAY'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_PASSWORD  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_password INPUT.
  CHECK gv_okcode EQ 'OKAY'.

  DATA(lv_userid) = CONV xubname( sy-uname ).
  DATA(lv_password) = CONV xubcode( gv_passwd_input ).

  CALL FUNCTION 'SUSR_CHECK_LOGON_DATA'
    EXPORTING
      auth_method                 = 'P'
      userid                      = lv_userid
      password                    = lv_password
    EXCEPTIONS
      user_or_password_incorrect  = 1
      user_locked                 = 2
      user_outside_validity       = 3
      user_requires_snc_logon     = 4
      password_attempts_limited   = 5
      password_logon_disabled     = 6
      user_has_no_password        = 7
      initialpassword_expired     = 8
      productive_password_expired = 9
      auth_method_requires_snc    = 10
      ticket_logon_disabled       = 11
      ticket_encoding_error       = 12
      ticket_issuer_not_verified  = 13
      ticket_issuer_not_trusted   = 14
      ticket_expired              = 15
      x509_logon_disabled         = 16
      x509_encoding_error         = 17
      no_userid_for_aliasname     = 18
      extid_logon_disabled        = 19
      no_mapping_found            = 20
      mapping_ambiguous           = 21
      internal_error              = 22
      auth_method_not_supported   = 23
      logon_data_incomplete       = 24
      OTHERS                      = 25.

  IF sy-subrc IS NOT INITIAL.
    "Entered password is not correct!
    MESSAGE e398(00) WITH TEXT-e01 '' '' ''.
  ENDIF.
ENDMODULE.
