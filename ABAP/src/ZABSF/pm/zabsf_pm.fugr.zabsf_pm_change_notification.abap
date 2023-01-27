FUNCTION zabsf_pm_change_notification.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(REFDT) TYPE  VVDATUM OPTIONAL
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PM_S_INPUTOBJECT
*"     VALUE(I_NOTIF_ID) TYPE  QMNUM
*"     VALUE(I_CAUSE) TYPE  URGRP OPTIONAL
*"     VALUE(I_SUBCAUSE) TYPE  URCOD OPTIONAL
*"     VALUE(IT_LONGTEXTS) TYPE  ZABSF_PM_T_NOTE_TEXT_LONG OPTIONAL
*"     VALUE(I_CAUSE_TEXT) TYPE  URSTX OPTIONAL
*"     VALUE(I_CLOSE_NOTIF) TYPE  BOOLE_D OPTIONAL
*"     VALUE(I_SERV_TYPE) TYPE  ZABSF_PM_SERV_TYPE OPTIONAL
*"     VALUE(I_CODING_GRP) TYPE  QMGRP OPTIONAL
*"     VALUE(I_CODING_COD) TYPE  QMCOD OPTIONAL
*"     VALUE(I_CLIENT_ID) TYPE  QKUNUM OPTIONAL
*"     VALUE(I_SALESDOC_ID) TYPE  KDAUF OPTIONAL
*"     VALUE(I_SALESDOC_ITEM) TYPE  POSNR OPTIONAL
*"     VALUE(I_EQUIPMENT) TYPE  EQUNR OPTIONAL
*"     VALUE(I_FUNC_LOC) TYPE  TPLNR OPTIONAL
*"     VALUE(I_PLAN_GRP) TYPE  INGRP OPTIONAL
*"     VALUE(I_PLAN_DIV) TYPE  IWERK OPTIONAL
*"     VALUE(I_MAIN_WKCTR) TYPE  GEWRK OPTIONAL
*"     VALUE(I_RESP_DIV) TYPE  WERKS_D OPTIONAL
*"     VALUE(I_USER_RESP) TYPE  I_PARNR OPTIONAL
*"     VALUE(I_REQDATE_START) TYPE  STRMN OPTIONAL
*"     VALUE(I_REQTIME_START) TYPE  ZABSF_PM_TIME_CHAR OPTIONAL
*"     VALUE(I_REQDATE_END) TYPE  LTRMN OPTIONAL
*"     VALUE(I_REQTIME_END) TYPE  ZABSF_PM_TIME_CHAR OPTIONAL
*"     VALUE(I_PRIOK) TYPE  PRIOK OPTIONAL
*"     VALUE(I_DESCRIP) TYPE  QMTXT OPTIONAL
*"     VALUE(I_BREAKDOWN) TYPE  MSAUS OPTIONAL
*"     VALUE(I_CLEAR_FIELDS) TYPE  ZABSF_PM_NOTIF_CLEAR_FIELDS OPTIONAL
*"     VALUE(I_MALF_END_DATE) TYPE  AUSBS OPTIONAL
*"     VALUE(I_MALF_END_TIME) TYPE  ZABSF_PM_TIME_CHAR OPTIONAL
*"     VALUE(I_MALF_START_DATE) TYPE  AUSBS OPTIONAL
*"     VALUE(I_MALF_START_TIME) TYPE  ZABSF_PM_TIME_CHAR OPTIONAL
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
*  Variables
  DATA: l_langu  TYPE spras,
        lv_strur TYPE strur,
        lv_ltrur TYPE ltrur,
        lv_auztb TYPE auztb,

        lv_auztv TYPE auztv.


*  Set local language for user
  l_langu = inputobj-language.

  SET LOCALE LANGUAGE l_langu.

  IF i_reqtime_start IS NOT INITIAL.
    MOVE i_reqtime_start TO lv_strur.
  ENDIF.
  IF i_reqtime_end IS NOT INITIAL.
    MOVE i_reqtime_end  TO lv_ltrur.
  ENDIF.

  IF i_malf_end_time IS NOT INITIAL.
    MOVE i_malf_end_time  TO lv_auztb.
  ENDIF.


  IF i_malf_start_time IS NOT INITIAL.
    MOVE i_malf_start_time  TO lv_auztv.
  ENDIF.


  CALL METHOD zcl_absf_pm=>change_notif
    EXPORTING
      i_inputobj        = inputobj
      i_notif_id        = i_notif_id
      i_descrip         = i_descrip
      i_cause           = i_cause
      i_subcause        = i_subcause
      it_longtexts      = it_longtexts
      i_cause_text      = i_cause_text
      i_close_notif     = i_close_notif
      i_serv_type       = i_serv_type
      i_coding_grp      = i_coding_grp
      i_coding_cod      = i_coding_cod
      i_equipment       = i_equipment
      i_func_loc        = i_func_loc
      i_plan_grp        = i_plan_grp
      i_plan_div        = i_plan_div
      i_main_wkctr      = i_main_wkctr
      i_resp_div        = i_resp_div
      i_user_resp       = i_user_resp
      i_reqdate_start   = i_reqdate_start
      i_reqtime_start   = lv_strur
      i_reqdate_end     = i_reqdate_end
      i_reqtime_end     = lv_ltrur
      i_priok           = i_priok
      i_client_id       = i_client_id
      i_salesdoc_id     = i_salesdoc_id
      i_salesdoc_item   = i_salesdoc_item
      i_clear_fields    = i_clear_fields
      i_malf_end_date   = i_malf_end_date
      i_malf_end_time   = lv_auztb
      i_breakdown       = i_breakdown
      i_malf_start_date = i_malf_start_date
      i_malf_start_time = lv_auztv
    IMPORTING
      et_returntab      = return_tab.


ENDFUNCTION.
