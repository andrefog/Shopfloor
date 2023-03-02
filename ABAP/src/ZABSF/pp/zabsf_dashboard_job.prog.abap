*&---------------------------------------------------------------------*
*& Report  ZABSF_DASHBOARD_JOB
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT zabsf_dashboard_job.

INCLUDE zabsf_dashboard_job_top.
INCLUDE zabsf_dashboard_job_f01.

START-OF-SELECTION.

  PERFORM create_data_range.
  PERFORM select_data.

  DATA(ls_date) = VALUE scal( date = gv_date_past ).
  WHILE ( ls_date-date LT gv_date_future ).
    PERFORM get_week_day CHANGING ls_date.

    LOOP AT gt_workcenters ASSIGNING FIELD-SYMBOL(<ls_workcenters>).
      LOOP AT gt_shifts ASSIGNING FIELD-SYMBOL(<ls_shift>)
        WHERE areaid EQ <ls_workcenters>-areaid.

        DATA(ls_calc_val) =
          VALUE ty_calc_value(
            areaid       = <ls_workcenters>-areaid
            hname        = <ls_workcenters>-hname
            werks        = p_werks
            arbpl        = <ls_workcenters>-arbpl
            objid        = <ls_workcenters>-objid
            kapid        = <ls_workcenters>-kapid
            shiftid      = <ls_shift>-shiftid
            date         = ls_date-date
            week         = ls_date-week ).

        " Calculate Availabily
        PERFORM calc_availabily CHANGING ls_calc_val.

        " Calculate Performance
        PERFORM calc_performance CHANGING ls_calc_val.

        " Calculate Quality
        PERFORM calc_quality CHANGING ls_calc_val.

        " Calculate OEE
        PERFORM calc_oee CHANGING ls_calc_val.

        " Calculate Productivity
        PERFORM calc_productivity CHANGING ls_calc_val.

        " Save Values Calculated
        APPEND ls_calc_val TO gt_calc_val.
      ENDLOOP.
    ENDLOOP.

    ADD 1 TO ls_date-date.
  ENDWHILE.


END-OF-SELECTION.

  IF gt_error[] IS INITIAL.
    PERFORM save_db.
  ELSE.
    PERFORM show_erros.
  ENDIF.
