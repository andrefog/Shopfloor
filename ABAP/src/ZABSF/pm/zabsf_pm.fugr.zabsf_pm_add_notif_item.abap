FUNCTION ZABSF_PM_ADD_NOTIF_ITEM.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(I_NOT_ITEM) TYPE  ZABSF_PM_S_NOT_ITEM
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

DATA: l_langu TYPE spras.

*  Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.

  CALL METHOD zcl_absf_pm=>add_notif_item
    EXPORTING
      i_inputobj    = inputobj

      i_not_item = i_not_item

*      i_notif_id    = i_notif_id
*      i_cause       = i_cause
*      i_subcause    = i_subcause
*      it_longtexts  = it_longtexts
*      i_cause_text  = i_cause_text
*      i_close_notif = i_close_notif

    IMPORTING
      et_returntab  = return_tab.





ENDFUNCTION.
