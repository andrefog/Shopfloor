FUNCTION ZABSF_PM_GET_MAINT_HISTORY.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"     VALUE(I_EQUNR) TYPE  EQUNR OPTIONAL
*"     VALUE(I_TPLNR) TYPE  TPLNR OPTIONAL
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"  EXPORTING
*"     VALUE(ET_MAINT_HISTORY) TYPE  ZABSF_PM_T_MAINT_HISTORY_LIST
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

DATA: l_langu TYPE spras.

*  Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.

  CALL METHOD ZCL_ABSF_PM=>get_maintenance_history
    EXPORTING
      i_inputobj = inputobj
      i_equnr    = i_equnr
      i_tplnr    = i_tplnr
    IMPORTING
      et_maint_history = et_maint_history.



ENDFUNCTION.
