FUNCTION zabsf_pm_get_hr_userlist.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(I_PERNR) TYPE  PERSNO OPTIONAL
*"     VALUE(I_ARBPL) TYPE  ARBPL OPTIONAL
*"  EXPORTING
*"     VALUE(ET_HR_USERSLIST) TYPE  ZABSF_PM_T_HR_USER_LIST
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  DATA: l_langu TYPE spras.

*  Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.


  CALL METHOD zcl_absf_pm=>get_hr_userlist
    EXPORTING
      i_inputobj   = inputobj
      i_refdt      = refdt
      i_pernr      = i_pernr
      i_arbpl      = i_arbpl
    IMPORTING
      et_userslist = et_hr_userslist.





ENDFUNCTION.
