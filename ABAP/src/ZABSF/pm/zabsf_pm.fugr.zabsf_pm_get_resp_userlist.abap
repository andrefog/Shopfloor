FUNCTION zabsf_pm_get_resp_userlist.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(I_USERN) TYPE  XUBNAME OPTIONAL
*"     VALUE(I_ARBPL) TYPE  ARBPL OPTIONAL
*"  EXPORTING
*"     VALUE(ET_RESP_USERLIST) TYPE  ZABSF_PM_T_RESP_USER_LIST
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  DATA: l_langu TYPE spras.

*  Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.


  CALL METHOD zcl_absf_pm=>get_resp_userlist
    EXPORTING
      i_inputobj   = inputobj
      i_refdt      = refdt
      i_usern      = i_usern
      i_arbpl      = i_arbpl
    IMPORTING
      et_userslist = et_resp_userlist.



ENDFUNCTION.
