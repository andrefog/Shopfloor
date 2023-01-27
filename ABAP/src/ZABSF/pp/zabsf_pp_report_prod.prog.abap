*&---------------------------------------------------------------------*
*& Report  Z_LP_PP_SF_REPORT_PROD
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT zabsf_pp_report_prod.

INCLUDE zabsf_pp_report_prod_top.

INITIALIZATION.
  DATA: lt_arbpl TYPE TABLE OF ty_arbpl.

  DATA: wa_arbpl TYPE ty_arbpl,
        ls_hname LIKE so_hname, "Name of hierarchy
        ls_arbpl LIKE so_arbpl, "Workcenter
        ls_shift LIKE so_shift. "Shift


*Initialize global variables
  PERFORM init_variables.

START-OF-SELECTION.
  IF pa_regt IS NOT INITIAL.
*  Fill internal table with all information necessary for calculate production
*  Area
    gs_prod-areaid = pa_area.
*  Plant
    gs_prod-werks = pa_werks.

*  Date
    IF pa_date IS INITIAL.
      pa_date = sy-datum.
      gs_prod-data = pa_date.
    ELSE.
      gs_prod-data = pa_date.
    ENDIF.

*  Week
    CALL FUNCTION 'DATE_GET_WEEK'
      EXPORTING
        date         = pa_date
      IMPORTING
        week         = gs_prod-week
      EXCEPTIONS
        date_invalid = 1
        OTHERS       = 2.

    IF sy-subrc <> 0.
*    Message error standard
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
      gs_prod-hname = ls_hname-low.

*    Get workcenter for hierarchy
      PERFORM get_workcenters_table USING gs_prod-hname gs_prod-werks
                                    CHANGING lt_arbpl.

      LOOP AT so_arbpl INTO ls_arbpl.
        READ TABLE lt_arbpl INTO wa_arbpl WITH KEY arbpl = ls_arbpl-low.

        IF sy-subrc EQ 0.
*        Workcenter
          gs_prod-arbpl = wa_arbpl-arbpl.

*        Fill shift
          LOOP AT so_shift INTO ls_shift.
*          Shift
            gs_prod-shiftid = ls_shift-low.
            APPEND gs_prod TO gt_prod.
          ENDLOOP.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

    SORT gt_prod BY areaid hname werks arbpl ASCENDING shiftid ASCENDING.

    CLEAR gs_prod.

    LOOP AT gt_prod ASSIGNING <fs_prod>.
*    Get stop time
      PERFORM get_prod_time USING <fs_prod>-areaid <fs_prod>-hname <fs_prod>-werks <fs_prod>-arbpl
                                  <fs_prod>-shiftid <fs_prod>-data
                            CHANGING <fs_prod>-prodtime <fs_prod>-produnit.
    ENDLOOP.

  ENDIF.

END-OF-SELECTION.

  IF gt_error[] IS INITIAL.
    IF pa_simul IS NOT INITIAL OR pa_hist IS NOT INITIAL.
      IF pa_hist IS NOT INITIAL.
        PERFORM get_data_db.
      ENDIF.

      IF gt_prod[] IS NOT INITIAL.
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

  INCLUDE zabsf_pp_report_prod_f01.
  INCLUDE zabsf_pp_report_prod_o01.
  INCLUDE zabsf_pp_report_prod_i01.
