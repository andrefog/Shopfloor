FUNCTION zabsf_pp_get_operator_log.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"     VALUE(REFDT) TYPE  VVDATUM
*"  EXPORTING
*"     VALUE(OPERATOR_LOG) TYPE  ZABSF_PP_T_OPERATOR_LOG
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

* local tables
  DATA: lt_kpi_table TYPE zabsf_pp_t_calc_workers_kpi,
        ls_kpi_table LIKE LINE OF lt_kpi_table,
        ls_month     LIKE LINE OF operator_log.

* local references
  DATA: lref_sf_dashboard TYPE REF TO zabsf_pp_cl_dashboard.

*Create objects of references
  CREATE OBJECT lref_sf_dashboard
    EXPORTING
      input_refdt    = refdt
      input_inputobj = inputobj.

*Get operator monthly log
  CALL METHOD lref_sf_dashboard->get_operator_monthly_log
    EXPORTING
      oprid            = inputobj-oprid
    CHANGING
      kpi_tab          = lt_kpi_table
      operator_log_tab = operator_log.

*  LOOP AT lt_kpi_table INTO ls_kpi_table.
*
*
*    ls_month-date = ls_kpi_table-tmp_data.
*    ls_month-shfif = ls_kpi_table-tmp_turno.
*    ls_month-description = ls_kpi_table-tmp_dscmolde.
*    ls_month-work_time = ls_kpi_table-tmp_producao.
*    ls_month-stop_time = ls_kpi_table-tmp_tpara1.
**      ls_month-QTY_PROD = ls_kpi_table-
**      ls_month-QTY_BOX
**      ls_month-QTY_PLAN
**      ls_month-BONUS = ls_kpi_table-
*    ls_month-spec_situation = ls_kpi_table-tmp_sitespecial.
*
*    APPEND ls_month TO operator_log.
*    CLEAR: ls_month, ls_kpi_table.
*  ENDLOOP.
*
** Dummy data
*
*  IF operator_log IS INITIAL.
*    ls_month-date = sy-datum.
*    ls_month-shfif = 'T1'.
*    ls_month-description = 'Dummy Data BMR'.
*    APPEND ls_month TO operator_log.
*  ENDIF.
ENDFUNCTION.
