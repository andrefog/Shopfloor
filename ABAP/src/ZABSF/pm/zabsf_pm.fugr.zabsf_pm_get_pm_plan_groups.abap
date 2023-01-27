FUNCTION ZABSF_PM_GET_PM_PLAN_GROUPS .
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"     VALUE(IWERK) TYPE  IWERK OPTIONAL
*"     VALUE(INGRP) TYPE  INGRP OPTIONAL
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"     VALUE(ET_PLANNER_GROUPS) TYPE  ZABSF_PM_T_PM_PLANNER_GROUPS
*"----------------------------------------------------------------------

*  Variables
  DATA: l_langu TYPE spras.

*  Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.

  CALL METHOD ZCL_ABSF_PM=>get_pm_planner_groups
    EXPORTING
      i_refdt           = refdt
      i_inputobj        = inputobj
      i_iwerk           = iwerk
      i_ingrp           = ingrp
    IMPORTING
      et_return_tab     = return_tab
      et_planner_groups = et_planner_groups.




ENDFUNCTION.
