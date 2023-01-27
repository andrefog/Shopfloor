FUNCTION ZABSF_PM_CHANGE_NOTIF_ITEM.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(I_NOT_ITEM) TYPE  ZABSF_PM_S_NOT_ITEM
*"     VALUE(I_CLEAR_FIELDS) TYPE  ZABSF_PM_S_NOITEM_CLEAR_FIELDS
*"       OPTIONAL
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

DATA: l_langu TYPE spras.

*  Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.

  CALL METHOD ZCL_ABSF_PM=>change_notif_item
    EXPORTING
      i_inputobj    = inputobj

      i_not_item = i_not_item
      i_clear_fields = i_clear_fields

    IMPORTING
      et_returntab  = return_tab.

ENDFUNCTION.
