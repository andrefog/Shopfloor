FUNCTION ZABSF_PM_CONF_TIME.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(AUFNR) TYPE  AUFNR
*"     VALUE(DATE) TYPE  DATUM
*"     VALUE(TIME) TYPE  ATIME
*"     VALUE(ACTV_ID) TYPE  ZABSF_PM_E_ACTV
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
  CONSTANTS lc_stat_proc(5) VALUE 'START'.

*Variables
  DATA: l_langu  TYPE spras,
        lv_auart TYPE auart,
        lv_error TYPE boole_d.

*Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.

*If order is ZMLD, check if moulde to be installed is clean on start up.
  IF actv_id EQ lc_stat_proc.

    CALL METHOD ZCL_ABSF_PM=>check_if_moulde_is_clean
      EXPORTING
        i_aufnr = aufnr
      IMPORTING
        e_error = lv_error.

    IF lv_error EQ abap_true.
* send error message!

        CALL METHOD ZCL_ABSF_PM=>add_message
          EXPORTING
            msgty      = 'E'
            msgno      = '021'
          CHANGING
            return_tab = return_tab.
    ENDIF.

  ENDIF.

  CHECK lv_error EQ abap_false.

*Create confirmations
  CALL METHOD ZCL_ABSF_PM=>set_reg_time
    EXPORTING
      i_aufnr    = aufnr
      i_date     = date
      i_time     = time
      i_actv_id  = actv_id
      i_inputobj = inputobj
    IMPORTING
      return_tab = return_tab.
ENDFUNCTION.
