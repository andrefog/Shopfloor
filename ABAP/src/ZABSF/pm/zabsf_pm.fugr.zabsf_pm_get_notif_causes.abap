FUNCTION ZABSF_PM_GET_NOTIF_CAUSES.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(REFDT) TYPE  VVDATUM OPTIONAL
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(ET_CAUSES) TYPE  ZABSF_PM_T_NOT_CAUSES_LIST
*"     VALUE(ET_SUBCAUSES) TYPE  ZABSF_PM_T_NOT_SUBCAUSES_LIST
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
*{   INSERT         X01K900207                                        1

*  Variables
  DATA: l_langu TYPE spras.

*  Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.

  CALL METHOD ZCL_ABSF_PM=>get_notif_causes
    EXPORTING
      i_werks      = inputobj-werks
    IMPORTING
      et_causes    = et_causes
      et_subcauses = et_subcauses.



*}   INSERT
ENDFUNCTION.
