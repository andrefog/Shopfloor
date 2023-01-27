FUNCTION ZABSF_PM_GET_NOTIFICATION.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"     VALUE(I_QMNUM) TYPE  QMNUM
*"  EXPORTING
*"     VALUE(ES_NOTIFICATION) TYPE  ZABSF_PM_S_NOTIFICATIONS
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

*  Variables
  DATA: l_langu TYPE spras.

*  Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.

  CALL METHOD ZCL_ABSF_PM=>get_notification
    EXPORTING
      i_werks        = inputobj-werks
      i_qmnum        = i_qmnum
      i_inputobj = inputobj
    IMPORTING
      e_notification = es_notification.


ENDFUNCTION.
