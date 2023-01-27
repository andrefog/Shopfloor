FUNCTION zabsf_pp_get_checklist .
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(REFDT) TYPE  VVDATUM OPTIONAL
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"     VALUE(PM_ORDER) TYPE  AUFNR OPTIONAL
*"     VALUE(CHECKLIST_STEP) TYPE  VORNR OPTIONAL
*"  EXPORTING
*"     VALUE(CHECKLIST) TYPE  ZABSF_PP_T_CHECKLIST
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------


  DATA: lref_checklist TYPE REF TO zabsf_pp_cl_checklist.

  DATA: l_langu TYPE sy-langu.

*Set local language for user
  l_langu = inputobj-language.
  SET LOCALE LANGUAGE l_langu.

  CREATE OBJECT lref_checklist
    EXPORTING
      initial_refdt = refdt
      input_object  = inputobj.

  CALL METHOD lref_checklist->get_checklist
    EXPORTING
      pm_order       = pm_order
      checklist_step = checklist_step
    CHANGING
      checklist      = checklist
      return_tab     = return_tab.


ENDFUNCTION.
