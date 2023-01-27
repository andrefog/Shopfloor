*&---------------------------------------------------------------------*
*& Report  ZABSF_DASHBOARD_JOB
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT zabsf_dashboard_job.

INCLUDE zabsf_dashboard_job_top.

INITIALIZATION.
  DATA: lt_arbpl TYPE TABLE OF ty_arbpl,
        lt_afru  TYPE TABLE OF afru,
        lt_aux   TYPE TABLE OF zabsf_pp056,
        ls_aux   LIKE LINE OF lt_aux.

*Initialize global variables
  PERFORM init_variables.
*  PERFORM create_desc_quantity.

START-OF-SELECTION.

*  Fill internal table with all information necessary for calculate OEE
*  Plant
  IF pa_werks IS INITIAL.

    MESSAGE e092(zabsf_pp).
    EXIT.
  ENDIF.

*save DATE of processing
  gv_uzeit = sy-timlo.
  gv_datum = sy-datlo.

  gs_qtd-werks = pa_werks.

  PERFORM get_areas_for_plant.

*  Date and weeks
  PERFORM create_data_range.

* Hierachy.
  PERFORM get_hierarchies.

* Shifts
  PERFORM get_shifts.

* Workcenters.
  PERFORM get_workcenters_table.

  SORT gt_qtd BY areaid hname	werks	arbpl week data shiftid ASCENDING.

*  Get data from afru
  PERFORM get_data_afru.

* Get stops
  PERFORM get_data_stops.

  IF gt_qtd[] IS NOT INITIAL.

*    Calculate quantities
    LOOP AT gt_qtd ASSIGNING <fs_qtd>.
*      Get quantities
      PERFORM get_quantity USING <fs_qtd>-areaid <fs_qtd>-hname <fs_qtd>-werks <fs_qtd>-arbpl
                                 <fs_qtd>-shiftid <fs_qtd>-data
                           CHANGING <fs_qtd>-gamng <fs_qtd>-lmnga <fs_qtd>-xmnga
                                    <fs_qtd>-rmnga <fs_qtd>-qtdprod <fs_qtd>-pctprod.

*     Get Times
      PERFORM get_production_time USING <fs_qtd>-areaid <fs_qtd>-hname <fs_qtd>-werks <fs_qtd>-arbpl
                                        <fs_qtd>-shiftid <fs_qtd>-data <fs_qtd>-week.


*    Get schdule qtt
      PERFORM get_qtt_by_schedule  USING <fs_qtd>-areaid <fs_qtd>-hname <fs_qtd>-werks <fs_qtd>-arbpl
                                       <fs_qtd>-shiftid <fs_qtd>-data <fs_qtd>-week.


      PERFORM get_total_productive_time USING <fs_qtd>-areaid <fs_qtd>-hname <fs_qtd>-werks <fs_qtd>-arbpl
                                       <fs_qtd>-shiftid <fs_qtd>-data <fs_qtd>-week.

*     Get Stops
      CHECK <fs_qtd>-data LE gv_datum.
      PERFORM get_stops_time USING <fs_qtd>-areaid <fs_qtd>-hname <fs_qtd>-werks <fs_qtd>-arbpl
                                   <fs_qtd>-shiftid <fs_qtd>-data <fs_qtd>-week.

    ENDLOOP.
  ENDIF.

*  lt_aux[] = gt_qtd[].
*  DELETE ADJACENT DUPLICATES FROM lt_aux COMPARING areaid hname werks arbpl week data.
*
** Calculate by day
*  LOOP AT lt_aux INTO ls_aux.
*
**     Get Stops
*
*
*    CLEAR ls_aux.
*  ENDLOOP.

END-OF-SELECTION.

  IF gt_error[] IS INITIAL.

*    Save data in database
    PERFORM save_db.
  ENDIF.

  INCLUDE zabsf_dashboard_job_f01.
