FUNCTION ZABSF_PM_GET_RESPONSIBLE_WCT.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(REFDT) TYPE  VVDATUM OPTIONAL
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"     VALUE(VERWE) TYPE  AP_VERWE OPTIONAL
*"     VALUE(IWERK) TYPE  IWERK OPTIONAL
*"     VALUE(ARBPL) TYPE  ARBPL OPTIONAL
*"  EXPORTING
*"     VALUE(ET_RESP_WORKCENTERS) TYPE  ZABSF_PM_T_WRKCTR
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

*  Variables
  DATA: l_langu TYPE spras.

*  Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.

  CALL METHOD ZCL_ABSF_PM=>get_workcenters
    EXPORTING
      i_inputobj    = inputobj
      i_iwerk       = iwerk
      i_verwe       = verwe
      i_arbpl       = arbpl
    IMPORTING
      et_workcenter = et_resp_workcenters.


ENDFUNCTION.
