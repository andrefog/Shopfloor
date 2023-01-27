FUNCTION ZABSF_PM_SET_CHECKLIST.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(REFDT) TYPE  VVDATUM OPTIONAL
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"     VALUE(I_AUFNR) TYPE  AUFNR
*"     VALUE(I_CHECKLIST) TYPE  ZABSF_PM_T_CHECKLIST
*"     VALUE(I_OBSERVATIONS) TYPE  STRING OPTIONAL
*"  EXPORTING
*"     VALUE(ET_CHECKLIST) TYPE  ZABSF_PM_T_CHECKLIST
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
*  Variables
  DATA: l_langu TYPE spras.

*  Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.

  CALL METHOD ZCL_ABSF_PM=>set_checklist
    EXPORTING
      i_inputobj   = inputobj
      pm_order     = i_aufnr
      observations = i_observations
    CHANGING
      checklist    = i_checklist
      return_tab   = return_tab.


ENDFUNCTION.
