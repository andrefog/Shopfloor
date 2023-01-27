*&---------------------------------------------------------------------*
*& Report  Z_LP_PP_SF_REPORT_STOP
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT zabsf_pp_report_stop.

INCLUDE zabsf_pp_report_stop_top.

INITIALIZATION.
  DATA: lt_arbpl TYPE TABLE OF ty_arbpl.

  DATA: wa_arbpl TYPE ty_arbpl,
        ls_hname LIKE so_hname, "Name of hierarchy
        ls_arbpl LIKE so_arbpl, "Workcenter
        ls_stprs LIKE so_stprs, "Stop Reason
        ls_shift LIKE so_shift. "Shift

*Initialize global variables
  PERFORM init_variables.

START-OF-SELECTION.
  IF pa_regt IS NOT INITIAL.
*  Fill internal table with all information necessary for calculate stop reason
*  Area
    gs_stop-areaid = pa_area.
*  Plant
    gs_stop-werks = pa_werks.

*  Date
    IF pa_date IS INITIAL.
      pa_date = sy-datum.
      gs_stop-data = pa_date.
    ELSE.
      gs_stop-data = pa_date.
    ENDIF.

*  Week
    CALL FUNCTION 'DATE_GET_WEEK'
      EXPORTING
        date         = pa_date
      IMPORTING
        week         = gs_stop-week
      EXCEPTIONS
        date_invalid = 1
        OTHERS       = 2.

    IF sy-subrc <> 0.
*    Message error standard
*      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.

      CALL METHOD zabsf_pp_cl_log=>add_message
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

*  Fill hierarchy, workcenter and indicators OEE
    LOOP AT so_hname INTO ls_hname.
*    Hierarchy
      gs_stop-hname = ls_hname-low.

*    Get workcenter for hierarchy
      PERFORM get_workcenters_table USING gs_stop-hname gs_stop-werks
                                    CHANGING lt_arbpl.

      LOOP AT so_arbpl INTO ls_arbpl.
        READ TABLE lt_arbpl INTO wa_arbpl WITH KEY arbpl = ls_arbpl-low.

        IF sy-subrc EQ 0.
*        Workcenter
          gs_stop-arbpl = wa_arbpl-arbpl.

*        Stop Reason
          LOOP AT so_stprs INTO ls_stprs.
            gs_stop-stprsnid = ls_stprs-low.

*          Fill shift
            LOOP AT so_shift INTO ls_shift.
*            Shift
              gs_stop-shiftid = ls_shift-low.
              APPEND gs_stop TO gt_stop.
            ENDLOOP.
          ENDLOOP.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

    SORT gt_stop BY areaid hname werks arbpl stprsnid ASCENDING shiftid ASCENDING.

    CLEAR gs_stop.

    LOOP AT gt_stop ASSIGNING <fs_stop>.
*    Get stop time
      PERFORM get_stop_time USING <fs_stop>-areaid <fs_stop>-hname <fs_stop>-werks <fs_stop>-arbpl
                                  <fs_stop>-stprsnid <fs_stop>-shiftid <fs_stop>-data
                            CHANGING <fs_stop>-stoptime <fs_stop>-stopunit.
    ENDLOOP.

  ENDIF.

END-OF-SELECTION.

  IF gt_error[] IS INITIAL.
    IF pa_simul IS NOT INITIAL OR pa_hist IS NOT INITIAL.
      IF pa_hist IS NOT INITIAL.
        PERFORM get_data_db.
      ENDIF.

      IF gt_stop[] IS NOT INITIAL.
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

  INCLUDE zabsf_pp_report_stop_f01.
  INCLUDE zabsf_pp_report_stop_o01.
  INCLUDE zabsf_pp_report_stop_i01.
