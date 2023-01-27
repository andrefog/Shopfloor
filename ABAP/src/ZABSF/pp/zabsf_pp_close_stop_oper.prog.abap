*&---------------------------------------------------------------------*
*& Report ZPP_CLOSE_STOP_OPERATIONS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zabsf_pp_close_stop_oper.

*Includes Declarations
INCLUDE zabsf_pp_close_stop_oper_top.
INCLUDE zabsf_pp_close_stop_oper_scr.
INCLUDE zabsf_pp_close_stop_oper_forms.

START-OF-SELECTION.
*Process data
  PERFORM process_data.
