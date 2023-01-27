FUNCTION zabsf_pp_getoption.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(ARBPL) TYPE  ARBPL
*"     VALUE(AUFNR) TYPE  AUFNR
*"     VALUE(VORNR) TYPE  VORNR
*"     VALUE(MATNR) TYPE  MATNR
*"     VALUE(DATA_CHRONO) TYPE  VVDATUM OPTIONAL
*"     VALUE(CHRONO_REG) TYPE  INT4 OPTIONAL
*"     VALUE(DATA_MEASURE) TYPE  VVDATUM OPTIONAL
*"     VALUE(MEASURE_REG) TYPE  INT4 OPTIONAL
*"     VALUE(DATA_ALERT) TYPE  VVDATUM OPTIONAL
*"     VALUE(ALERT_REG) TYPE  INT4 OPTIONAL
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(LOWER_LIMIT) TYPE  ZABSF_PP_E_LOWER_LIMIT
*"     VALUE(UPPER_LIMIT) TYPE  ZABSF_PP_E_UPPER_LIMIT
*"     VALUE(MEASURE_OPT_TAB) TYPE  ZABSF_PP_T_MEASURE_OPT
*"     VALUE(CHRONO_TAB) TYPE  ZABSF_PP_T_CHRONOMETER
*"     VALUE(MEASURE_TAB) TYPE  ZABSF_PP_T_MEASURE
*"     VALUE(ALERT_TAB) TYPE  ZABSF_PP_T_ALERT
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  DATA lref_sf_option TYPE REF TO zabsf_pp_cl_option_reg.

  CREATE OBJECT lref_sf_option
    EXPORTING
      initial_refdt = refdt
      input_object  = inputobj.

  CALL METHOD lref_sf_option->get_option_reg
    EXPORTING
      arbpl           = arbpl
      werks           = inputobj-werks
      aufnr           = aufnr
      vornr           = vornr
      matnr           = matnr
      data_chrono     = data_chrono
      chrono_reg      = chrono_reg
      data_measure    = data_measure
      measure_reg     = measure_reg
      data_alert      = data_alert
      alert_reg       = alert_reg
    CHANGING
      lower_limit     = lower_limit
      upper_limit     = upper_limit
      measure_opt_tab = measure_opt_tab
      chrono_tab      = chrono_tab
      measure_tab     = measure_tab
      alert_tab       = alert_tab
      return_tab      = return_tab.

  DELETE ADJACENT DUPLICATES FROM return_tab.
ENDFUNCTION.
