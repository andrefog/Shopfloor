FUNCTION zabsf_pp_setoption.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(ARBPL) TYPE  ARBPL
*"     VALUE(AUFNR) TYPE  AUFNR
*"     VALUE(VORNR) TYPE  VORNR
*"     VALUE(MATNR) TYPE  MATNR
*"     VALUE(DATE) TYPE  DATUM
*"     VALUE(TIME) TYPE  ATIME
*"     VALUE(CRON_VALUE) TYPE  ZABSF_PP_E_CRON_VALUE OPTIONAL
*"     VALUE(MEASUREID_TAB) TYPE  ZABSF_PP_T_MEASURE_ID OPTIONAL
*"     VALUE(ALERT_DESC) TYPE  ZABSF_PP_E_ALERT_DESC OPTIONAL
*"     VALUE(ACTION_PLANE) TYPE  ZABSF_PP_E_ACTION_PLANE OPTIONAL
*"     VALUE(OLD_VALUE) TYPE  ZABSF_PP_E_OLD_VALUE OPTIONAL
*"     VALUE(ACTUAL_VALUE) TYPE  ZABSF_PP_E_ACTUAL_VALUE OPTIONAL
*"     VALUE(RESPONSABLE_USER) TYPE  ZABSF_PP_E_RESP_USER OPTIONAL
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  DATA lref_sf_option TYPE REF TO zabsf_pp_cl_option_reg.

  CREATE OBJECT lref_sf_option
    EXPORTING
      initial_refdt = refdt
      input_object  = inputobj.

  CALL METHOD lref_sf_option->set_option_reg
    EXPORTING
      arbpl            = arbpl
      aufnr            = aufnr
      vornr            = vornr
      matnr            = matnr
      date             = date
      time             = time
      cron_value       = cron_value
      measureid_tab    = measureid_tab
      alert_desc       = alert_desc
      action_plane     = action_plane
      old_value        = old_value
      actual_value     = actual_value
      responsable_user = responsable_user
    CHANGING
      return_tab       = return_tab.

  DELETE ADJACENT DUPLICATES FROM return_tab.
ENDFUNCTION.
