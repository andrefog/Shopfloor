FUNCTION ZABSF_PM_GET_CHECKLIST.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(REFDT) TYPE  VVDATUM OPTIONAL
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"     VALUE(I_CHECKLIST_STEP) TYPE  VORNR OPTIONAL
*"     VALUE(I_AUFNR) TYPE  AUFNR
*"  EXPORTING
*"     VALUE(ET_CHECKLIST) TYPE  ZABSF_PM_T_CHECKLIST
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
*  Variables
  DATA: l_langu TYPE spras.

*  Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.

  CALL METHOD ZCL_ABSF_PM=>get_checklist
    EXPORTING
      i_inputobj     = inputobj
      pm_order       = i_aufnr
      checklist_step = i_checklist_step
    CHANGING
      checklist      = et_checklist
      return_tab     = return_tab.


ENDFUNCTION.
