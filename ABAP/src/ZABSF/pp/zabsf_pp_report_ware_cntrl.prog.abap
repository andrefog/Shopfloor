*&---------------------------------------------------------------------*
*& Report  Z_LP_PP_SF_REPORT_WARE_CNTRL
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT zabsf_pp_report_ware_cntrl.

INCLUDE zabsf_pp_report_cntrl_top.

INITIALIZATION.
  DATA: lt_zabsf_pp037_t TYPE TABLE OF zabsf_pp037_t,
        lt_zabsf_pp057   TYPE TABLE OF zabsf_pp057,
        lt_zabsf_pp038   TYPE TABLE OF zabsf_pp038,
        lt_zabsf_pp036   TYPE TABLE OF zabsf_pp036.

  DATA: ls_zabsf_pp057   TYPE zabsf_pp057,
        ls_zabsf_pp036   TYPE zabsf_pp036,
        ls_zabsf_pp037_t TYPE zabsf_pp037_t,
        ls_qtd_prod      TYPE ty_qtd_prod,
        ls_prod          TYPE ty_qtd_prod,
        lv_first_day     TYPE scal-date,
        lv_week          TYPE scal-week,
        lv_first         TYPE sy-datum,
        lv_last          TYPE sy-datum.

  PERFORM init_variable.

START-OF-SELECTION.

*Check if all optional parameter are filled
  PERFORM check_so USING pa_area pa_werks.

* Get first day of week
  CALL FUNCTION 'WEEK_GET_FIRST_DAY'
    EXPORTING
      week         = pa_week
    IMPORTING
      date         = lv_first_day
    EXCEPTIONS
      week_invalid = 1
      OTHERS       = 2.

  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

*Get first and last day of week
  CALL FUNCTION 'GET_WEEK_INFO_BASED_ON_DATE'
    EXPORTING
      date   = lv_first_day
    IMPORTING
      week   = lv_week
      monday = lv_first
      sunday = lv_last.

*Get material with warehouse
  SELECT matnr
    FROM zabsf_pp038
    INTO CORRESPONDING FIELDS OF TABLE lt_zabsf_pp038
   WHERE areaid EQ pa_area
     AND werks  EQ pa_werks
     AND wareid EQ 'PROD'.
*     AND wareid IN so_ware.

  SORT lt_zabsf_pp038 BY matnr DESCENDING.

  DELETE ADJACENT DUPLICATES FROM lt_zabsf_pp038.

  IF lt_zabsf_pp038[] IS NOT INITIAL.
*  Get all good quantity
    SELECT *
      FROM zabsf_pp057
      INTO CORRESPONDING FIELDS OF TABLE lt_zabsf_pp057
       FOR ALL ENTRIES IN lt_zabsf_pp038
     WHERE areaid EQ pa_area
       AND wareid IN so_ware
       AND matnr  EQ lt_zabsf_pp038-matnr
       AND data   GE lv_first
       AND data   LE lv_last.

*  Get all defects saved
    SELECT *
      FROM zabsf_pp036
      INTO CORRESPONDING FIELDS OF TABLE lt_zabsf_pp036
       FOR ALL ENTRIES IN lt_zabsf_pp038
     WHERE areaid EQ pa_area
       AND wareid IN so_ware
       AND matnr  EQ lt_zabsf_pp038-matnr
       AND data   GE lv_first
       AND data   LE lv_last.

*  Get all defects for warehouse
    SELECT *
      FROM zabsf_pp037_t
      INTO CORRESPONDING FIELDS OF TABLE lt_zabsf_pp037_t
      FOR ALL ENTRIES IN lt_zabsf_pp036
     WHERE areaid   EQ lt_zabsf_pp036-areaid
       AND werks    EQ pa_werks
       AND wareid   EQ lt_zabsf_pp036-wareid
       AND defectid EQ lt_zabsf_pp036-defectid.

    LOOP AT lt_zabsf_pp057 INTO ls_zabsf_pp057.
      CLEAR ls_qtd_prod.

      READ TABLE gt_qtd_prod INTO ls_qtd_prod WITH KEY wareid = ls_zabsf_pp057-wareid
                                                       zcntrl = ls_zabsf_pp057-zcntrl
                                                       matnr  = ls_zabsf_pp057-matnr
                                                       week   = pa_week.
*                                                     data   = ls_ZABSF_PP057-data.

      IF sy-subrc EQ 0.
        ADD ls_zabsf_pp057-lmnga TO ls_qtd_prod-qtdprod.

        MODIFY TABLE gt_qtd_prod FROM ls_qtd_prod.
      ELSE.
        ls_qtd_prod-wareid = ls_zabsf_pp057-wareid.
        ls_qtd_prod-zcntrl = ls_zabsf_pp057-zcntrl.
        ls_qtd_prod-matnr = ls_zabsf_pp057-matnr.
        ls_qtd_prod-qtdprod = ls_zabsf_pp057-lmnga.
        ls_qtd_prod-week = pa_week.
*      ls_qtd_prod-data = ls_ZABSF_PP057-data.

        APPEND ls_qtd_prod TO gt_qtd_prod.
      ENDIF.
    ENDLOOP.


    LOOP AT gt_qtd_prod ASSIGNING <fs_prod>.
      IF <fs_prod>-wareid EQ c_prod AND <fs_prod>-zcntrl EQ c_cntrl_g.
        <fs_prod>-warecrp = c_prod.
      ELSEIF <fs_prod>-wareid EQ c_revs AND <fs_prod>-zcntrl EQ c_cntrl_e.
        <fs_prod>-warecrp = c_revs.
      ELSEIF <fs_prod>-wareid EQ c_supr AND <fs_prod>-zcntrl EQ space.
        <fs_prod>-warecrp = c_supr.
      ENDIF.
    ENDLOOP.

    LOOP AT lt_zabsf_pp036 INTO ls_zabsf_pp036.
      READ TABLE gt_cntrl INTO gs_cntrl WITH KEY wareid   = ls_zabsf_pp036-wareid
                                                 matnr    = ls_zabsf_pp036-matnr
                                                 defectid = ls_zabsf_pp036-defectid
                                                 week     = pa_week
                                                 data     = ls_zabsf_pp036-data.
      IF sy-subrc EQ 0.
        IF gs_cntrl-zcntrl NE space.
          ADD ls_zabsf_pp036-rework TO gs_cntrl-qtdtot.
          MODIFY TABLE gt_cntrl FROM gs_cntrl.
        ENDIF.
      ELSE.
        READ TABLE gt_qtd_prod INTO ls_qtd_prod WITH KEY warecrp = ls_zabsf_pp036-wareid
                                                         matnr   = ls_zabsf_pp036-matnr
                                                         week    = pa_week.
*                                                       data   = ls_ZABSF_PP036-data.
        IF sy-subrc EQ 0.
*        Workcenter
          gs_cntrl-wareid = ls_qtd_prod-wareid.
*        Control
          gs_cntrl-zcntrl = ls_qtd_prod-zcntrl.
*        Material
          gs_cntrl-matnr = ls_qtd_prod-matnr.

*        Quantity
          IF ls_qtd_prod-zcntrl EQ c_cntrl_g.
            CLEAR ls_prod.

            READ TABLE gt_qtd_prod INTO ls_prod WITH KEY warecrp = space.
            IF sy-subrc EQ 0.
              gs_cntrl-qtdprod = ls_prod-qtdprod.
            ENDIF.
          ELSE.
            gs_cntrl-qtdprod = ls_qtd_prod-qtdprod.
          ENDIF.

*        Week
          gs_cntrl-week = ls_qtd_prod-week.
*        Data
          gs_cntrl-data = ls_zabsf_pp036-data.
*        Defectid
          gs_cntrl-defectid = ls_zabsf_pp036-defectid.

*        Description defect
          READ TABLE lt_zabsf_pp037_t INTO ls_zabsf_pp037_t WITH KEY defectid = ls_zabsf_pp036-defectid.

          IF sy-subrc EQ 0.
            gs_cntrl-defect_desc = ls_zabsf_pp037_t-defect_desc.
          ENDIF.

*        Total quantity
          gs_cntrl-qtdtot = ls_zabsf_pp036-rework.

          APPEND gs_cntrl TO gt_cntrl.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDIF.

END-OF-SELECTION.

  IF gt_cntrl[] IS NOT INITIAL.
*  Show data in ALV
    PERFORM show_data.
  ELSE.
    SET SCREEN 0.

*  No data found
    MESSAGE i018(zabsf_pp).
  ENDIF.

  INCLUDE zabsf_pp_report_cntrl_f01.
  INCLUDE zabsf_pp_report_cntrl_o01.
  INCLUDE zabsf_pp_report_cntrl_i01.
