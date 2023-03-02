"Name: \TY:CL_IDENTITY_DB_PERSISTENCE\IN:IF_SUID_PERSISTENCE_MODIFY\ME:MODIFY\SE:END\EI
ENHANCEMENT 0 ZABSF_ENHC_SHOPFLOOR_PASSWORDS.
* Update Shopfloor Password.
  LOOP AT lt_usr02_upd_pwd ASSIGNING FIELD-SYMBOL(<ls_upd_pwd>).
    CALL FUNCTION 'ZABSF_PP_UPD_PASSWORD'
      EXPORTING
        iv_username = <ls_upd_pwd>-bname
        iv_pwd_hash = <ls_upd_pwd>-pwdsaltedhash.
  ENDLOOP.
ENDENHANCEMENT.
