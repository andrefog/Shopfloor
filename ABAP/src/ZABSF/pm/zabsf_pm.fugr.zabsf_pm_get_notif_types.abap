FUNCTION ZABSF_PM_GET_NOTIF_TYPES.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"     VALUE(SERV_TYPE) TYPE  ZABSF_PM_E_SERV_TYPE OPTIONAL
*"  EXPORTING
*"     VALUE(ET_NOTIF_TYPES) TYPE  ZABSF_PM_T_NOTIF_TYPES
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

*  Variables
  DATA: l_langu TYPE spras.

*  Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.

  CALL METHOD ZCL_ABSF_PM=>get_notif_types
    EXPORTING
      i_werks        = inputobj-werks
      i_serv_type    = serv_type
    IMPORTING
      et_notif_types = et_notif_types.



ENDFUNCTION.
