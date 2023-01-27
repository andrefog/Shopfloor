*&---------------------------------------------------------------------*
*& Report ZABSF_CALC_WORKERS_KPI
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zabsf_calc_workers_kpi.

*Includes Declarations
INCLUDE zabsf_calc_workers_kpi_top.    "Top
INCLUDE zabsf_calc_workers_kpi_screen. "Screen
INCLUDE zabsf_calc_workers_kpi_class.  "Class

INITIALIZATION.
*Initialize global vaiables
  PERFORM init_variables.

START-OF-SELECTION.

  IF p_simul = 'X' AND p_notprc = 'X' AND p_lim_dt IS INITIAL.
    MESSAGE s001(00) WITH 'Campo Data limite p/ reg. produção é obrigatório!'(e01) DISPLAY LIKE 'E'.
    EXIT.
  ENDIF.

*  Get data to calculate
    PERFORM get_data.

END-OF-SELECTION.

  IF p_backsf IS INITIAL.
*  Call screen
    CALL SCREEN 100.
*    PERFORM show_data.
  ENDIF.

*To return table filled to Shopfloor Dashboard
  IF p_backsf IS NOT INITIAL.
    EXPORT gt_output TO MEMORY ID 'GT_OUTPUT'.
  ENDIF.

*Includes ALV
  INCLUDE zabsf_calc_workers_kpi_f01. "Forms
  INCLUDE zabsf_calc_workers_kpi_o01. "PBO
  INCLUDE zabsf_calc_workers_kpi_i01. "PAI
