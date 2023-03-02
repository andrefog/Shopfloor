"Name: \PR:SAPLSUID_MAINTENANCE\TY:LCL_MAINT_TAB\IN:LIF_MAINT_TAB\ME:C_USER_COMMAND\SE:END\EI
ENHANCEMENT 0 ZABSF_ENHC_SET_SHOPFLOOR_PSW.
* Save password value
  CALL FUNCTION 'ZABSF_PP_SET_PASSWORD'
    EXPORTING
      iv_username = suid_st_bname-bname
      iv_password = suid_st_node_password_ext-password.
ENDENHANCEMENT.
