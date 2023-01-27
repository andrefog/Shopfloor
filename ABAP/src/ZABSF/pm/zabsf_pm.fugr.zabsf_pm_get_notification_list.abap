FUNCTION ZABSF_PM_GET_NOTIFICATION_LIST.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"     VALUE(IS_FILTERS) TYPE  ZABSF_PM_S_NOTIFFILTER_OPTIONS
*"     VALUE(VARIANT) TYPE  VARIANT OPTIONAL
*"  EXPORTING
*"     VALUE(ET_NOTIFICATIONS) TYPE  ZABSF_PM_T_NOTIF_LIST
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
*  Variables
  DATA: l_langu TYPE spras.

*  Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.

  CALL METHOD ZCL_ABSF_PM=>get_notifications_list
    EXPORTING
      i_inputobj       = inputobj
      is_filters       = is_filters
      i_variant        = variant
    CHANGING
      et_notifications = et_notifications
      et_returntab     = return_tab.

ENDFUNCTION.
