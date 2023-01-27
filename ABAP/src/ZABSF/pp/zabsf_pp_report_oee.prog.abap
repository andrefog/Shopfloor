*&---------------------------------------------------------------------*
*& Report  Z_LP_PP_SF_REPORT_OEE
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT zabsf_pp_report_oee.

INCLUDE zabsf_pp_report_oee_top.

INITIALIZATION.
  DATA: lt_arbpl     TYPE TABLE OF ty_arbpl,
        lt_afru      TYPE TABLE OF afru,
        lt_indicator TYPE TABLE OF zabsf_pp050_t,
        lt_sequence  TYPE TABLE OF zabsf_pp050.

  DATA: wa_arbpl     TYPE ty_arbpl,
        wa_indicator TYPE zabsf_pp050_t,
        wa_sequence  TYPE zabsf_pp050,
        ls_hname     LIKE so_hname, "Name of hierarchy
        ls_arbpl     LIKE so_arbpl, "Workcenter
        ls_oeeid     LIKE so_oeeid, "Indicator OEE
        ls_shift     LIKE so_shift, "Shift
        ld_arbid     TYPE cr_objid,
        ld_seq       TYPE zabsf_pp_e_recid,
        ld_text      TYPE string,
        ld_text_ind  TYPE string,
        ld_lines     TYPE i,
        count        TYPE i.

*Initialize global variables
  PERFORM init_variables.

START-OF-SELECTION.

  IF pa_regt IS NOT INITIAL.
*  Fill internal table with all information necessary for calculate OEE
*  Area
    gs_oee-areaid = pa_area.
*  Plant
    gs_oee-werks = pa_werks.
*  Date
    IF pa_date IS INITIAL.
      pa_date = sy-datum.
      gs_oee-data = pa_date.
    ELSE.
      gs_oee-data = pa_date.
    ENDIF.

*  Week
    CALL FUNCTION 'DATE_GET_WEEK'
      EXPORTING
        date         = pa_date
      IMPORTING
        week         = gs_oee-week
      EXCEPTIONS
        date_invalid = 1
        OTHERS       = 2.

    IF sy-subrc <> 0.
*    Message error standard
*      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.

      CALL METHOD ZABSF_PP_CL_LOG=>add_message
        EXPORTING
          msgid      = sy-msgid
          msgty      = sy-msgty
          msgno      = sy-msgno
          msgv1      = sy-msgv1
          msgv2      = sy-msgv2
          msgv3      = sy-msgv3
          msgv4      = sy-msgv4
        CHANGING
          return_tab = gt_error.
    ENDIF.

*  Check if all optional parameter are filled
    PERFORM check_so USING pa_area pa_werks pa_date.

*  Get sequence of indicator OEE
    SELECT *
      FROM zabsf_pp050
      INTO CORRESPONDING FIELDS OF TABLE lt_sequence
     WHERE oeeid IN so_oeeid.

*  Fill hierarchy, workcenter and indicators OEE
    LOOP AT so_hname INTO ls_hname.
*    Hierarchy
      gs_oee-hname = ls_hname-low.

*    Get workcenter for hierarchy
      PERFORM get_workcenters_table USING gs_oee-hname gs_oee-werks
                                    CHANGING lt_arbpl.

      LOOP AT so_arbpl INTO ls_arbpl.
        READ TABLE lt_arbpl INTO wa_arbpl WITH KEY arbpl = ls_arbpl-low.

        IF sy-subrc EQ 0.
*        Workcenter
          gs_oee-arbpl = wa_arbpl-arbpl.

*        Indicators OEE
          LOOP AT so_oeeid INTO ls_oeeid.
            gs_oee-oeeid = ls_oeeid-low.

*          Sequence of OEE
            READ TABLE lt_sequence INTO wa_sequence WITH KEY oeeid = gs_oee-oeeid.

            IF sy-subrc EQ 0.
*            Sequence
              gs_oee-seqid = wa_sequence-recordid.
            ENDIF.

*          Fill shift
            LOOP AT so_shift INTO ls_shift.
*            Shift
              gs_oee-shiftid = ls_shift-low.
              APPEND gs_oee TO gt_oee.
            ENDLOOP.
          ENDLOOP.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

    SORT gt_oee BY areaid hname	werks	arbpl seqid ASCENDING shiftid ASCENDING.

*  Get data from afru
    PERFORM get_data_afru.

*  Calculate indicators OEE
    LOOP AT gt_oee ASSIGNING <fs_oee>.
      CLEAR: gv_plan_prod,
             gv_oper_time,
             gv_tot_pieces,
             gv_run_rate,
             gv_run_rate_prd,
             gv_good_pieces,
             gv_real_time,
             gv_avaibility,
             gv_performance,
             gv_quality,
             gv_oee,
             gv_productivit.

      CASE <fs_oee>-seqid.
        WHEN 1. "DISP - Availabily
*        Calculate availabily
          PERFORM calc_availabily USING <fs_oee>-areaid <fs_oee>-hname <fs_oee>-werks <fs_oee>-arbpl <fs_oee>-shiftid <fs_oee>-oeeid <fs_oee>-data.

        WHEN 2. "PERF - Performance
*        Calculate performance
          PERFORM calc_performance USING <fs_oee>-areaid <fs_oee>-hname <fs_oee>-werks <fs_oee>-arbpl <fs_oee>-shiftid <fs_oee>-oeeid <fs_oee>-data.

        WHEN 3. "QUAL - Quality
*        Calculate quality
          PERFORM calc_quality USING <fs_oee>-areaid <fs_oee>-hname <fs_oee>-werks <fs_oee>-arbpl <fs_oee>-shiftid <fs_oee>-oeeid <fs_oee>-data.

        WHEN 4. "OEE
*        Calculate quality
          PERFORM calc_oee USING <fs_oee>-areaid <fs_oee>-hname <fs_oee>-werks <fs_oee>-arbpl <fs_oee>-shiftid <fs_oee>-oeeid <fs_oee>-data.

        WHEN 5. "PROD - Productivity
*        Calculate productivity
          PERFORM calc_productivity USING <fs_oee>-areaid <fs_oee>-hname <fs_oee>-werks <fs_oee>-arbpl <fs_oee>-shiftid <fs_oee>-oeeid <fs_oee>-data.

      ENDCASE.
    ENDLOOP.

    CLEAR gs_oee.

*  Calculate incators OEE
    LOOP AT gt_oee ASSIGNING <fs_oee>.
      CLEAR: gv_plan_prod,
             gv_oper_time,
             gv_tot_pieces,
             gv_run_rate,
             gv_run_rate_prd,
             gv_good_pieces,
             gv_real_time,
             gv_avaibility,
             gv_performance,
             gv_quality,
             gv_oee,
             gv_productivit.

      CASE <fs_oee>-seqid.
        WHEN 1. "DISP - Availabily
*        Read value calculated
          PERFORM read_value_calc USING <fs_oee>-areaid <fs_oee>-hname <fs_oee>-werks <fs_oee>-arbpl <fs_oee>-oeeid <fs_oee>-shiftid <fs_oee>-data
                                  CHANGING gv_plan_prod gv_oper_time gv_tot_pieces gv_run_rate gv_run_rate_prd gv_good_pieces gv_real_time
                                           gv_avaibility gv_performance gv_quality gv_oee gv_productivit.

          <fs_oee>-qtdoee = gv_avaibility.

        WHEN 2. "PERF - Performance
*        Read value calculated
          PERFORM read_value_calc USING <fs_oee>-areaid <fs_oee>-hname <fs_oee>-werks <fs_oee>-arbpl <fs_oee>-oeeid <fs_oee>-shiftid <fs_oee>-data
                                  CHANGING gv_plan_prod gv_oper_time gv_tot_pieces gv_run_rate gv_run_rate_prd gv_good_pieces gv_real_time
                                           gv_avaibility gv_performance gv_quality gv_oee gv_productivit.

          <fs_oee>-qtdoee = gv_performance.

        WHEN 3. "QUAL - Quality
*        Read value calculated
          PERFORM read_value_calc USING <fs_oee>-areaid <fs_oee>-hname <fs_oee>-werks <fs_oee>-arbpl <fs_oee>-oeeid <fs_oee>-shiftid <fs_oee>-data
                                  CHANGING gv_plan_prod gv_oper_time gv_tot_pieces gv_run_rate gv_run_rate_prd gv_good_pieces gv_real_time
                                           gv_avaibility gv_performance gv_quality gv_oee gv_productivit.

          <fs_oee>-qtdoee = gv_quality.

        WHEN 4. "OEE
*        Read value calculated
          PERFORM read_value_calc USING <fs_oee>-areaid <fs_oee>-hname <fs_oee>-werks <fs_oee>-arbpl <fs_oee>-oeeid <fs_oee>-shiftid <fs_oee>-data
                                  CHANGING gv_plan_prod gv_oper_time gv_tot_pieces gv_run_rate gv_run_rate_prd gv_good_pieces gv_real_time
                                           gv_avaibility gv_performance gv_quality gv_oee gv_productivit.

*        Calculate OEE
          IF gv_avaibility IS NOT INITIAL AND gv_performance IS NOT INITIAL AND gv_quality IS NOT INITIAL.
            <fs_oee>-qtdoee = gv_oee.
*          ELSE.
**          Get description of indicators missing
*            SELECT *
*              FROM ZABSF_PP050_t
*              INTO CORRESPONDING FIELDS OF TABLE lt_indicator
*              WHERE recordid LT <fs_oee>-seqid.
*
**          Sort table
*            SORT lt_indicator BY recordid ASCENDING.
*
**          Get count lines of table
*            DESCRIBE TABLE lt_indicator LINES ld_lines.
*
**          Create text of message
*            LOOP AT lt_indicator INTO wa_indicator.
*              ADD 1 TO count.
*              IF count LT ld_lines.
*                CONCATENATE wa_indicator-oeeid_desc ',' INTO ld_text_ind.
*              ELSE.
*                ld_text_ind = wa_indicator-oeeid_desc.
*              ENDIF.
*
*              CONCATENATE ld_text ld_text_ind INTO ld_text SEPARATED BY space.
*
*            ENDLOOP.
*
**          Need to perform before the fallowing indicators
*            CALL METHOD zcl_lp_pp_sf_log=>add_message
*              EXPORTING
**               msgid      = sy-msgid
*                msgty      = 'I'
*                msgno      = '052'
*                msgv1      = ld_text
*              CHANGING
*                return_tab = gt_error.
*
*            EXIT.
          ENDIF.

        WHEN 5. "PROD - Productivity
*        Read value calculated
          PERFORM read_value_calc USING <fs_oee>-areaid <fs_oee>-hname <fs_oee>-werks <fs_oee>-arbpl <fs_oee>-oeeid <fs_oee>-shiftid <fs_oee>-data
                                  CHANGING gv_plan_prod gv_oper_time gv_tot_pieces gv_run_rate gv_run_rate_prd gv_good_pieces gv_real_time
                                           gv_avaibility gv_performance gv_quality gv_oee gv_productivit.

          <fs_oee>-qtdoee = gv_productivit.
      ENDCASE.
    ENDLOOP.

  ENDIF.

END-OF-SELECTION.

  IF gt_error[] IS INITIAL.
    IF pa_simul IS NOT INITIAL OR pa_hist IS NOT INITIAL.
      IF pa_hist IS NOT INITIAL.
        PERFORM get_data_db.
      ENDIF.

      IF gt_oee[] IS NOT INITIAL.
*      Show data in ALV
        PERFORM show_data.
      ELSE.
        SET SCREEN 0.
      ENDIF.

    ENDIF.

    IF pa_creat IS NOT INITIAL.
*    Save data in database
      PERFORM save_db.
    ENDIF.
  ENDIF.

  INCLUDE zabsf_pp_report_oee_f01. "Forms
  INCLUDE zabsf_pp_report_oee_o01. "PBO
  INCLUDE zabsf_pp_report_oee_i01. "PAI
