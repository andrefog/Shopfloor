*----------------------------------------------------------------------*
***INCLUDE ZABSF_DASHBOARD_JOB_F01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  INIT_VARIABLES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM init_variables .
  REFRESH: it_area,
           it_hname,
           it_arbpl,
           it_shift,
           it_qtd_desc,
           gt_qtd,
           "gt_qtd_alv,
           gt_afru,
         "  gt_total,
           gt_error,
           gt_qtt_schedule,
           gt_workcenters,
           gt_times,
           gt_stops,
           gt_util_time,
           gt_sf010.

  CLEAR: gs_qtd.
  "  gs_qtd_alv.

  CLEAR: gv_datum,
         gv_uzeit.
ENDFORM.                    " INIT_VARIABLES
*&---------------------------------------------------------------------*
*&      Form  CREATE_DESC_QUANTITY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM create_desc_quantity .
*  DATA: ls_qtd_desc TYPE ty_qtd_desc,
*        count       TYPE i.
*
*  CLEAR count.
*
*  DO 6 TIMES.
*    CLEAR ls_qtd_desc.
*
*    ADD 1 TO count.
*    ls_qtd_desc-seqid = count.
*
*    CASE count.
*      WHEN 1.
**      Quantity expected
*        ls_qtd_desc-qtd_desc = TEXT-010.
*      WHEN 2.
**      Quantity produced
*        ls_qtd_desc-qtd_desc = TEXT-011.
*      WHEN 3.
**      Good Quantity
*        ls_qtd_desc-qtd_desc = TEXT-012.
*      WHEN 4.
**      Quantity scrap
*        ls_qtd_desc-qtd_desc = TEXT-013.
*      WHEN 5.
**      Quantity rework
*        ls_qtd_desc-qtd_desc = TEXT-014.
*      WHEN 6.
**      Percentage of produced quntities completed
*        ls_qtd_desc-qtd_desc = TEXT-015.
*    ENDCASE.
*
*    APPEND ls_qtd_desc TO it_qtd_desc.
*  ENDDO.
ENDFORM.                    " CREATE_DESC_QUANTITY
*&---------------------------------------------------------------------*
*&      Form  CREATE_F4_FIELD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_C  text
*      -->P_C  text
*      <--P_IT_AREA  text
*      <--P_IT_RETURN  text
*----------------------------------------------------------------------*
FORM create_f4_field  USING p_retfield p_val_org p_dyn_field so_option p_it TYPE STANDARD TABLE.


*  DATA: it_return TYPE TABLE OF ddshretval,
*        wa_return TYPE ddshretval.
*
*  REFRESH it_return.
*  CLEAR wa_return.
*
*  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
*    EXPORTING
*      retfield        = p_retfield
*      value_org       = p_val_org
*      dynpprog        = sy-cprog
*      dynpnr          = sy-dynnr
*      dynprofield     = p_dyn_field
*    TABLES
*      value_tab       = p_it
*      return_tab      = it_return
*    EXCEPTIONS
*      parameter_error = 1
*      no_values_found = 2
*      OTHERS          = 3.

*  IF sy-subrc <> 0.
**    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
**          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*
*    CALL METHOD zcl_lp_pp_sf_log=>add_message
*      EXPORTING
*        msgid      = sy-msgid
*        msgty      = sy-msgty
*        msgno      = sy-msgno
*        msgv1      = sy-msgv1
*        msgv2      = sy-msgv2
*        msgv3      = sy-msgv3
*        msgv4      = sy-msgv4
*      CHANGING
*        return_tab = gt_error.
*  ENDIF.
*
*  IF it_return IS NOT INITIAL.
*    LOOP AT it_return INTO wa_return.
*      so_option = wa_return-fieldval.
*    ENDLOOP.
*  ENDIF.

ENDFORM.                    " CREATE_F4_FIELD
*&---------------------------------------------------------------------*
*&      Form  GET_WORKCENTERS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*FORM get_workcenters TABLES p_hname STRUCTURE so_hname
*                      USING p_area p_werks
*                   CHANGING p_it TYPE STANDARD TABLE.
*
*  DATA: lt_crhs         TYPE TABLE OF crhs,
*        it_aux          TYPE TABLE OF ty_arbpl,
*        lt_zlp_pp_sf002 TYPE TABLE OF zlp_pp_sf002,
*        ls_zlp_pp_sf002 TYPE zlp_pp_sf002,
*        wa_hname        TYPE cr_hname,
*        l_hrchy_objid   TYPE cr_objid.
*
*  IF p_hname[] IS NOT INITIAL.
*    LOOP AT p_hname INTO wa_hname.
**    Get workcenter for Hierarchy
*      PERFORM get_workcenters_table USING wa_hname p_werks CHANGING it_aux.
*
*      IF it_aux[] IS NOT INITIAL.
*        APPEND LINES OF it_aux TO p_it.
*      ENDIF.
*    ENDLOOP.
*  ELSE.
**  Get all hierarchies for area
*    SELECT hname
*      FROM zlp_pp_sf002
*      INTO CORRESPONDING FIELDS OF TABLE lt_zlp_pp_sf002
*     WHERE areaid EQ p_area
*       AND werks  EQ p_werks.
*
*    SORT lt_zlp_pp_sf002 BY hname.
*
*    DELETE ADJACENT DUPLICATES FROM lt_zlp_pp_sf002.
*
*    LOOP AT lt_zlp_pp_sf002 INTO ls_zlp_pp_sf002.
**    Get workcenter for Hierarchy
*      PERFORM get_workcenters_table USING ls_zlp_pp_sf002-hname p_werks CHANGING it_aux.
*
*      IF it_aux[] IS NOT INITIAL.
*        APPEND LINES OF it_aux TO p_it.
*      ENDIF.
*    ENDLOOP.
*
*
*  ENDIF.
*ENDFORM.                    " GET_WORKCENTERS
*&---------------------------------------------------------------------*
*&      Form  GET_WORKCENTERS_TABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_WA_HNAME  text
*      <--P_IT_AUX  text
*----------------------------------------------------------------------*
FORM get_workcenters_table.

  DATA: lt_crhs         TYPE TABLE OF crhs,
        ls_hrchy_objid  TYPE cr_objid,
        it_aux          TYPE TABLE OF ty_arbpl,
        ls_aux          LIKE LINE OF it_aux,
        ls_qtd_aux      LIKE LINE OF gt_qtd,
        lt_qtd_aux      TYPE TABLE OF zabsf_pp056,
        ls_qtd          LIKE LINE OF gt_qtd,
        lt_sf013        TYPE TABLE OF zabsf_pp013,
        ls_workcenters  LIKE LINE OF gt_workcenters,
        ls_workcenter_r TYPE rsis_s_range.


*Get all workcenters from ZTable

  SELECT * FROM zabsf_pp013 INTO TABLE lt_sf013
    WHERE werks = gs_qtd-werks.

  LOOP AT gt_qtd INTO ls_qtd. "werks, hname"
*Get Hierarchy Object ID
    CALL FUNCTION 'CR_HIERARCHY_READ_NAME'
      EXPORTING
        name                = ls_qtd-hname
        werks               = ls_qtd-werks
      IMPORTING
        objid               = ls_hrchy_objid
      EXCEPTIONS
        hierarchy_not_found = 1
        OTHERS              = 2.

    IF sy-subrc = 0.
*  Get hierarchy object relations
      CALL FUNCTION 'CR_HIERARCHY_OBJECTS'
        EXPORTING
          objid               = ls_hrchy_objid
        TABLES
          t_crhs              = lt_crhs
        EXCEPTIONS
          hierarchy_not_found = 1
          OTHERS              = 2.

      IF sy-subrc = 0.
*    Get workcenter ID and description
        SELECT objid arbpl kapid
          INTO CORRESPONDING FIELDS OF TABLE it_aux
          FROM crhd
           FOR ALL ENTRIES IN lt_crhs
         WHERE objty EQ lt_crhs-objty_ho
           AND objid EQ lt_crhs-objid_ho.

*        APPEND LINES OF it_aux TO gt_workcenters.

        LOOP AT it_aux INTO ls_aux.

*I - Selecinar apenas CT relevante para planeamento de capacidade
          SELECT SINGLE kapter
               INTO @DATA(lv_kapter)
               FROM kako
              WHERE kapid = @ls_aux-kapid
                AND kapter = 'X'.

          IF sy-subrc = 0.
            APPEND ls_aux TO gt_workcenters.


            MOVE-CORRESPONDING ls_qtd TO ls_qtd_aux.
            ls_qtd_aux-arbpl = ls_aux-arbpl.

            "check if WC is relevant for processing.
            READ TABLE lt_sf013 TRANSPORTING NO FIELDS WITH KEY werks = ls_qtd-werks
                                                                arbpl = ls_aux-arbpl.
            IF sy-subrc EQ 0.
              APPEND ls_qtd_aux TO lt_qtd_aux.
            ELSE.
              CLEAR ls_aux.
            ENDIF.
            CLEAR ls_aux.

          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.
    REFRESH: lt_crhs, it_aux.
    CLEAR: ls_hrchy_objid, ls_qtd.

  ENDLOOP.

* create workcenters range.
  SORT gt_workcenters BY objid.
  DELETE ADJACENT DUPLICATES FROM gt_workcenters COMPARING objid.

  LOOP AT gt_workcenters INTO ls_workcenters.

    ls_workcenter_r-sign = 'I'.
    ls_workcenter_r-option = 'EQ'.
    ls_workcenter_r-low = ls_workcenters-objid.

    APPEND ls_workcenter_r TO gr_arbid.

  ENDLOOP.

  REFRESH gt_qtd.
  gt_qtd[] = lt_qtd_aux[].

ENDFORM.                    " GET_WORKCENTERS_TABLE
*&---------------------------------------------------------------------*
*&      Form  CHECK_SO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM check_so USING p_areaid p_werks p_data.
*  DATA: lt_zlp_pp_sf001 TYPE TABLE OF zlp_pp_sf001,
*        lt_zlp_pp_sf002 TYPE TABLE OF zlp_pp_sf002,
*        lt_zlp_pp_sf050 TYPE TABLE OF zlp_pp_sf050,
*        lt_arbpl        TYPE TABLE OF ty_arbpl.
*
*  DATA: wa_zlp_pp_sf001 TYPE zlp_pp_sf001,
*        wa_zlp_pp_sf002 TYPE zlp_pp_sf002,
*        wa_zlp_pp_sf050 TYPE zlp_pp_sf050,
*        wa_arbpl        TYPE ty_arbpl,
*        ls_hname        LIKE LINE OF so_hname,
*        ls_arbpl        LIKE LINE OF so_arbpl,
*        ls_shift        LIKE LINE OF so_shift.
*
*  REFRESH: lt_zlp_pp_sf001,
*           lt_zlp_pp_sf002,
*           lt_zlp_pp_sf050,
*           lt_arbpl.
*
*  CLEAR: wa_zlp_pp_sf001,
*         wa_zlp_pp_sf002,
*         wa_zlp_pp_sf050,
*         wa_arbpl,
*         ls_hname,
*         ls_arbpl,
*         ls_shift.
*
**Send error message
*  IF so_hname[] IS INITIAL AND so_arbpl[] IS NOT INITIAL.
**  Fill missing parameter
**    MESSAGE i053(zlp_pp_shopfloor).
*    CALL METHOD zcl_lp_pp_sf_log=>add_message
*      EXPORTING
*        msgty      = 'I'
*        msgno      = '053'
*      CHANGING
*        return_tab = gt_error.
*    EXIT.
*  ENDIF.
*
**Check if parameter Hierarchy is not initial
*  IF so_hname[] IS INITIAL.
**  Get all hierarchies for area
*    SELECT *
*      FROM zlp_pp_sf002
*      INTO CORRESPONDING FIELDS OF TABLE lt_zlp_pp_sf002
*     WHERE areaid EQ p_areaid
*       AND werks EQ p_werks
*       AND begda  LE p_data
*       AND endda  GE p_data.
*
*    LOOP AT lt_zlp_pp_sf002 INTO wa_zlp_pp_sf002.
*      ls_hname-sign = 'I'.
*      ls_hname-option = 'EQ'.
*      ls_hname-low = wa_zlp_pp_sf002-hname.
*
*      APPEND ls_hname TO so_hname.
*    ENDLOOP.
*
*    SORT so_hname.
*
*    DELETE ADJACENT DUPLICATES FROM so_hname.
*  ENDIF.
*
**Check if parameter Workcenter is not initial
*  IF so_arbpl[] IS INITIAL.
*    LOOP AT so_hname INTO ls_hname.
**    Get workcenter for hierarchy
*      PERFORM get_workcenters_table USING ls_hname-low p_werks
*                                    CHANGING lt_arbpl.
*
*      LOOP AT lt_arbpl INTO wa_arbpl.
*        ls_arbpl-sign = 'I'.
*        ls_arbpl-option = 'EQ'.
*        ls_arbpl-low = wa_arbpl-arbpl.
*
*        APPEND ls_arbpl TO so_arbpl.
*      ENDLOOP.
*    ENDLOOP.
*
*    SORT so_arbpl.
*
*    DELETE ADJACENT DUPLICATES FROM so_arbpl.
*  ENDIF.
*
**Check if parameter Shift is not initial
*  IF so_shift[] IS INITIAL.
**  Get shifts for area
*    SELECT *
*      FROM zlp_pp_sf001
*      INTO CORRESPONDING FIELDS OF TABLE lt_zlp_pp_sf001
*     WHERE areaid EQ p_areaid
*       AND werks EQ p_werks
*       AND begda  LE p_data
*       AND endda  GE p_data.
*
*    LOOP AT lt_zlp_pp_sf001 INTO wa_zlp_pp_sf001.
*      ls_shift-sign = 'I'.
*      ls_shift-option = 'EQ'.
*      ls_shift-low = wa_zlp_pp_sf001-shiftid.
*
*      APPEND ls_shift TO so_shift.
*    ENDLOOP.
*
*    SORT so_shift.
*
*    DELETE ADJACENT DUPLICATES FROM so_shift.
*  ENDIF.
ENDFORM.                    " CHECK_SO
*&---------------------------------------------------------------------*
*&      Form  SAVE_DB
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM save_db .
  DATA: lt_zlp_pp_sf056 TYPE TABLE OF zabsf_pp056,
        lt_zlp_pp_sf055 TYPE TABLE OF zabsf_pp055,
        lt_zlp_pp_sf053 TYPE TABLE OF zabsf_pp053,
        lt_zlp_pp_sf073 TYPE TABLE OF zabsf_pp073,
        lt_zlp_pp_sf074 TYPE TABLE OF zabsf_pp074.

  DATA: ls_zlp_pp_sf056 TYPE zabsf_pp056,
        ls_zlp_pp_sf055 TYPE zabsf_pp055,
        ls_zlp_pp_sf053 TYPE zabsf_pp053,
        ls_zlp_pp_sf073 LIKE LINE OF lt_zlp_pp_sf073,
        ls_zlp_pp_sf074 TYPE zabsf_pp074,
        flag_error      TYPE c,
        ls_times        LIKE LINE OF gt_times,
        ls_stops        LIKE LINE OF gt_stops,
        ls_schedule     LIKE LINE OF gt_qtt_schedule,
        ls_util_time    LIKE LINE OF gt_util_time.

*Get all data saved in database
  SELECT *
    FROM zabsf_pp056
    INTO CORRESPONDING FIELDS OF TABLE lt_zlp_pp_sf056
      WHERE werks   EQ pa_werks
      AND data    IN gr_dates.

  SELECT *
    FROM zabsf_pp055
    INTO CORRESPONDING FIELDS OF TABLE lt_zlp_pp_sf055
      WHERE werks   EQ pa_werks
      AND data    IN gr_dates.

  SELECT *
    FROM zabsf_pp053
    INTO CORRESPONDING FIELDS OF TABLE lt_zlp_pp_sf053
      WHERE werks   EQ pa_werks
      AND data    IN gr_dates.

  SELECT *
    FROM zabsf_pp073
    INTO CORRESPONDING FIELDS OF TABLE lt_zlp_pp_sf073
      WHERE werks   EQ pa_werks
      AND data    IN gr_dates.


  SELECT *
    FROM zabsf_pp074
    INTO CORRESPONDING FIELDS OF TABLE lt_zlp_pp_sf074
      WHERE werks   EQ pa_werks
      AND data    IN gr_dates.


  LOOP AT gt_qtd INTO gs_qtd.

*  Check if exist data saved in database
    READ TABLE lt_zlp_pp_sf056 INTO ls_zlp_pp_sf056 WITH KEY areaid  = gs_qtd-areaid
                                                             hname   = gs_qtd-hname
                                                             werks   = gs_qtd-werks
                                                             arbpl   = gs_qtd-arbpl
                                                             shiftid = gs_qtd-shiftid
                                                             data    = gs_qtd-data
                                                             week    = gs_qtd-week.

    IF sy-subrc EQ 0.
*    Update values
      ls_zlp_pp_sf056-gamng = gs_qtd-gamng.
      ls_zlp_pp_sf056-lmnga = gs_qtd-lmnga.
      ls_zlp_pp_sf056-xmnga = gs_qtd-xmnga.
      ls_zlp_pp_sf056-rmnga = gs_qtd-rmnga.
      ls_zlp_pp_sf056-qtdprod = gs_qtd-qtdprod.
      ls_zlp_pp_sf056-pctprod = gs_qtd-pctprod.

      UPDATE zabsf_pp056 FROM ls_zlp_pp_sf056.

      IF sy-subrc NE 0.
        flag_error = 'X'.
*      Data not saved successfully in database
        MESSAGE e058(zabsf_pp).
        EXIT.
      ENDIF.
    ELSE.
*    Insert new line in database
      INSERT INTO zabsf_pp056 VALUES gs_qtd.

      IF sy-subrc NE 0.
        flag_error = 'X'.
*      Data not saved successfully in database
        MESSAGE e058(zabsf_pp).
        EXIT.
      ENDIF.
    ENDIF.

    CLEAR: ls_zlp_pp_sf056, gs_qtd.
  ENDLOOP.

  LOOP AT gt_times INTO ls_times.

*  Check if exist data saved in database
    READ TABLE lt_zlp_pp_sf055 INTO ls_zlp_pp_sf055 WITH KEY areaid  = ls_times-areaid
                                                             hname   = ls_times-hname
                                                             werks   = ls_times-werks
                                                             arbpl   = ls_times-arbpl
                                                             shiftid = ls_times-shiftid
                                                             data    = ls_times-data
                                                             week    = ls_times-week.

    IF sy-subrc EQ 0.
*    Update values
      ls_zlp_pp_sf055-produnit = ls_times-produnit.
      ls_zlp_pp_sf055-prodtime = ls_times-prodtime.

      UPDATE zabsf_pp055 FROM ls_zlp_pp_sf055.

      IF sy-subrc NE 0.
        flag_error = 'X'.
*      Data not saved successfully in database
        MESSAGE e058(zlp_pp_shopfloor).
        EXIT.
      ENDIF.
    ELSE.
*    Insert new line in database
      INSERT INTO zabsf_pp055 VALUES ls_times.

      IF sy-subrc NE 0.
        flag_error = 'X'.
*      Data not saved successfully in database
        MESSAGE e058(zabsf_pp).
        EXIT.
      ENDIF.
    ENDIF.

    CLEAR: ls_times, ls_zlp_pp_sf055.
  ENDLOOP.


  LOOP AT gt_stops INTO ls_stops.

*  Check if exist data saved in database
    READ TABLE lt_zlp_pp_sf053 INTO ls_zlp_pp_sf053 WITH KEY areaid  = ls_stops-areaid
                                                             hname   = ls_stops-hname
                                                             werks   = ls_stops-werks
                                                             arbpl   = ls_stops-arbpl
                                                             shiftid = ls_stops-shiftid
                                                             data    = ls_stops-data
                                                             week    = ls_stops-week
                                                             stprsnid = ls_stops-stprsnid.
    IF sy-subrc EQ 0.
*    Update values
      ls_zlp_pp_sf053-stoptime = ls_stops-stoptime.
      ls_zlp_pp_sf053-stopunit = 'MIN'.

      UPDATE zabsf_pp053 FROM ls_zlp_pp_sf053.

      IF sy-subrc NE 0.
        flag_error = 'X'.
*      Data not saved successfully in database
        MESSAGE e058(zabsf_pp).
        EXIT.
      ENDIF.
    ELSE.
*    Insert new line in database
      INSERT INTO zabsf_pp053 VALUES ls_stops.

      IF sy-subrc NE 0.
        flag_error = 'X'.
*      Data not saved successfully in database
        MESSAGE e058(zabsf_pp).
        EXIT.
      ENDIF.
    ENDIF.

    CLEAR: ls_stops, ls_zlp_pp_sf053.

  ENDLOOP.


  LOOP AT gt_qtt_schedule INTO ls_schedule.

*  Check if exist data saved in database
    READ TABLE lt_zlp_pp_sf073 INTO ls_zlp_pp_sf073 WITH KEY areaid  = ls_schedule-areaid
                                                             hname   = ls_schedule-hname
                                                             werks   = ls_schedule-werks
                                                             arbpl   = ls_schedule-arbpl
                                                             shiftid = ls_schedule-shiftid
                                                             data    = ls_schedule-data
                                                             week    = ls_schedule-week.
    IF sy-subrc EQ 0.
*    Update values
      ls_zlp_pp_sf073-qtt_schedule = ls_schedule-qtt_schedule.
      UPDATE zabsf_pp073 FROM ls_zlp_pp_sf073.

      IF sy-subrc NE 0.
        flag_error = 'X'.
*      Data not saved successfully in database
        MESSAGE e058(zabsf_pp).
        EXIT.
      ENDIF.
    ELSE.
*    Insert new line in database
      INSERT INTO zabsf_pp073 VALUES ls_schedule.

      IF sy-subrc NE 0.
        flag_error = 'X'.
*      Data not saved successfully in database
        MESSAGE e058(zabsf_pp).
        EXIT.
      ENDIF.
    ENDIF.

    CLEAR: ls_schedule, ls_zlp_pp_sf073.

  ENDLOOP.


  LOOP AT gt_util_time INTO ls_util_time.

*  Check if exist data saved in database
    READ TABLE lt_zlp_pp_sf074 INTO ls_zlp_pp_sf074 WITH KEY areaid  = ls_util_time-areaid
                                                             hname   = ls_util_time-hname
                                                             werks   = ls_util_time-werks
                                                             arbpl   = ls_util_time-arbpl
                                                             shiftid = ls_util_time-shiftid
                                                             data    = ls_util_time-data
                                                             week    = ls_util_time-week.

    IF sy-subrc EQ 0.
*    Update values
      ls_zlp_pp_sf074-prodtime = ls_util_time-prodtime.
      UPDATE zabsf_pp074 FROM ls_zlp_pp_sf074.

      IF sy-subrc NE 0.
        flag_error = 'X'.
*      Data not saved successfully in database
        MESSAGE e058(zabsf_pp).
        EXIT.
      ENDIF.
    ELSE.
*    Insert new line in database
      INSERT INTO zabsf_pp074 VALUES ls_util_time.

      IF sy-subrc NE 0.
        flag_error = 'X'.
*      Data not saved successfully in database
        MESSAGE e058(zabsf_pp).
        EXIT.
      ENDIF.
    ENDIF.

    CLEAR: ls_util_time, ls_zlp_pp_sf074.
  ENDLOOP.


  IF flag_error IS INITIAL.
*  Data saved successfully in database
    MESSAGE s057(zabsf_pp).
  ENDIF.
ENDFORM.                    " SAVE_DB
*&---------------------------------------------------------------------*
*&      Form  SHOW_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM show_data.
*Get data to alv
*  PERFORM fill_data_alv.
*
*  IF gt_qtd_alv[] IS NOT INITIAL.
**  Show data
*    CALL SCREEN 100.
*  ENDIF.
ENDFORM.                    " SHOW_DATA
*&---------------------------------------------------------------------*
*&      Form  FILL_DATA_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fill_data_alv.
*Types for Hierarchy
*  TYPES: BEGIN OF ty_hname_desc,
*           objid TYPE cr_objid,
*           name  TYPE cr_hname,
*           ktext TYPE cr_ktext,
*         END OF ty_hname_desc.
*
**Types for Workcenter
*  TYPES: BEGIN OF ty_arbpl_desc,
*           objid TYPE cr_objid,
*           arbpl TYPE arbpl,
*           ktext TYPE cr_ktext,
*         END OF ty_arbpl_desc.
*
*  DATA: lt_qtd_alv    TYPE TABLE OF zlp_sf_s_data_alv,
*        lt_area_desc  TYPE TABLE OF zlp_pp_sf000_t,
*        lt_hname_desc TYPE TABLE OF ty_hname_desc,
*        lt_werks_desc TYPE TABLE OF t001w,
*        lt_arbpl_desc TYPE TABLE OF ty_arbpl_desc,
*        lt_shift_desc TYPE TABLE OF zlp_pp_sf001_t.
*
*  DATA: ls_qtd_alv    TYPE zlp_sf_s_data_alv,
*        ls_area_desc  TYPE zlp_pp_sf000_t,
*        ls_hname_desc TYPE ty_hname_desc,
*        ls_werks_desc TYPE t001w,
*        ls_arbpl_desc TYPE ty_arbpl_desc,
*        ls_shift_desc TYPE zlp_pp_sf001_t,
*        ls_total      TYPE ty_total,
*        ls_qtd_desc   TYPE ty_qtd_desc,
*        ld_day        TYPE scal-indicator,
*        ld_value      TYPE mengv13.
*
*  REFRESH: lt_area_desc,
*           lt_hname_desc,
*           lt_werks_desc,
*           lt_arbpl_desc,
*           lt_shift_desc,
*           gt_total.
*
*  CLEAR: ls_qtd_alv,
*         gs_qtd.
*
**Get data to get description
*  LOOP AT gt_qtd INTO gs_qtd.
*    CLEAR ls_qtd_alv.
*    MOVE-CORRESPONDING gs_qtd TO ls_qtd_alv.
*
*    APPEND ls_qtd_alv TO lt_qtd_alv.
*  ENDLOOP.
*
*  DELETE ADJACENT DUPLICATES FROM lt_qtd_alv.
*
**Get description for Area
*  SELECT *
*    FROM zlp_pp_sf000_t
*    INTO CORRESPONDING FIELDS OF TABLE lt_area_desc
*     FOR ALL ENTRIES IN lt_qtd_alv
*   WHERE areaid EQ lt_qtd_alv-areaid
*     AND spras EQ sy-langu.
*
**Get description for Hierarchy
*  SELECT crhh~objid crhh~name crtx~ktext
*    INTO CORRESPONDING FIELDS OF TABLE lt_hname_desc
*    FROM crtx AS crtx
*   INNER JOIN crhh AS crhh
*      ON crhh~objty EQ crtx~objty
*     AND crhh~objid EQ crtx~objid
*     FOR ALL ENTRIES IN lt_qtd_alv
*   WHERE crhh~name  EQ lt_qtd_alv-hname
*     AND crhh~objty EQ 'H'
*     AND crhh~werks EQ lt_qtd_alv-werks
*     AND crtx~spras EQ sy-langu.
*
**Get description for Plant
*  SELECT *
*    FROM t001w
*    INTO CORRESPONDING FIELDS OF TABLE lt_werks_desc
*     FOR ALL ENTRIES IN lt_qtd_alv
*   WHERE werks EQ lt_qtd_alv-werks
*     AND spras EQ sy-langu.
*
**Get description for Workcenter
*  SELECT crhd~objid crhd~arbpl crtx~ktext
*    INTO CORRESPONDING FIELDS OF TABLE lt_arbpl_desc
*    FROM crtx AS crtx
*   INNER JOIN crhd AS crhd
*      ON crhd~objty EQ crtx~objty
*     AND crhd~objid EQ crtx~objid
*     FOR ALL ENTRIES IN lt_qtd_alv
*   WHERE crhd~arbpl EQ lt_qtd_alv-arbpl
*     AND crhd~objty EQ 'A'
*     AND crhd~werks EQ lt_qtd_alv-werks
*     AND crtx~spras EQ sy-langu.
*
**Get description for Shift
*  SELECT *
*    FROM zlp_pp_sf001_t
*    INTO CORRESPONDING FIELDS OF TABLE lt_shift_desc
*     FOR ALL ENTRIES IN lt_qtd_alv
*   WHERE areaid  EQ lt_qtd_alv-areaid
*     AND werks   EQ lt_qtd_alv-werks
*     AND shiftid EQ lt_qtd_alv-shiftid
*     AND spras   EQ sy-langu.
*
**Get total week for Quantity
*  LOOP AT gt_qtd INTO gs_qtd.
**  Total quantity
*    READ TABLE gt_total INTO ls_total WITH KEY areaid  = gs_qtd-areaid
*                                               hname   = gs_qtd-hname
*                                               werks   = gs_qtd-werks
*                                               arbpl   = gs_qtd-arbpl
*                                               shiftid = gs_qtd-shiftid
*                                               week    = gs_qtd-week.
*
*    IF sy-subrc EQ 0.
**    Add value quantity to total
*      ADD gs_qtd-gamng TO ls_total-tot_gamng.
*      ADD gs_qtd-lmnga TO ls_total-tot_lmnga.
*      ADD gs_qtd-xmnga TO ls_total-tot_xmnga.
*      ADD gs_qtd-rmnga TO ls_total-tot_rmnga.
*      ADD gs_qtd-qtdprod TO ls_total-tot_qtdprod.
*      ADD gs_qtd-pctprod TO ls_total-tot_pctprod.
*
*      MODIFY TABLE gt_total FROM ls_total.
*    ELSE.
**    Insert new line in internal table total
*      MOVE-CORRESPONDING gs_qtd TO ls_total.
*
*      ls_total-tot_gamng = gs_qtd-gamng.
*      ls_total-tot_lmnga = gs_qtd-lmnga.
*      ls_total-tot_xmnga = gs_qtd-xmnga.
*      ls_total-tot_rmnga = gs_qtd-rmnga.
*      ls_total-tot_qtdprod = gs_qtd-qtdprod.
*      ls_total-tot_pctprod = gs_qtd-pctprod.
*
*      INSERT ls_total INTO TABLE gt_total.
*    ENDIF.
*  ENDLOOP.
*
**Fill glbal internal table to show data in alv
*  CLEAR gs_qtd.
*
*  LOOP AT gt_qtd INTO gs_qtd.
*    CLEAR: gs_qtd_alv,
*           ls_area_desc,
*           ls_hname_desc,
*           ls_werks_desc,
*           ls_arbpl_desc,
*           ls_shift_desc,
*           ld_day.
*
**>>>PAP - Correcção - 20.05.2015
*    READ TABLE gt_qtd_alv INTO gs_qtd_alv WITH KEY areaid  = gs_qtd-areaid
*                                                   hname   = gs_qtd-hname
*                                                   werks   = gs_qtd-werks
*                                                   arbpl   = gs_qtd-arbpl
*                                                   shiftid = gs_qtd-shiftid
*                                                   week    = gs_qtd-week.
*
*    IF sy-subrc EQ 0.
**    Get number day in week
*      CALL FUNCTION 'DATE_COMPUTE_DAY'
*        EXPORTING
*          date = gs_qtd-data
*        IMPORTING
*          day  = ld_day.
*
**    Type quantities calculated
*      LOOP AT it_qtd_desc INTO ls_qtd_desc.
*        CLEAR: gs_qtd_alv-qtd_desc,
*               gs_qtd_alv-vdata1,
*               gs_qtd_alv-vdata2,
*               gs_qtd_alv-vdata3,
*               gs_qtd_alv-vdata4,
*               gs_qtd_alv-vdata5,
*               gs_qtd_alv-vdata6,
*               gs_qtd_alv-vdata7,
*               gs_qtd_alv-tshift,
*               gs_qtd_alv-tweek,
*               ld_value.
*
*        CASE ls_qtd_desc-seqid.
*          WHEN 1.
*            gs_qtd_alv-qtd_desc = ls_qtd_desc-qtd_desc.
*            ld_value = gs_qtd-gamng.
*          WHEN 2.
*            gs_qtd_alv-qtd_desc = ls_qtd_desc-qtd_desc.
*            ld_value = gs_qtd-qtdprod.
*          WHEN 3.
*            gs_qtd_alv-qtd_desc = ls_qtd_desc-qtd_desc.
*            ld_value = gs_qtd-lmnga.
*          WHEN 4.
*            gs_qtd_alv-qtd_desc = ls_qtd_desc-qtd_desc.
*            ld_value = gs_qtd-xmnga.
*          WHEN 5.
*            gs_qtd_alv-qtd_desc = ls_qtd_desc-qtd_desc.
*            ld_value = gs_qtd-rmnga.
*          WHEN 6.
*            gs_qtd_alv-qtd_desc = ls_qtd_desc-qtd_desc.
*            ld_value = gs_qtd-pctprod.
*        ENDCASE.
*
**      Add differente quantities
*        PERFORM add_data_quantity TABLES gt_total
*                                  USING ld_day ld_value gs_qtd-areaid gs_qtd-hname gs_qtd-werks
*                                        gs_qtd-arbpl gs_qtd-shiftid gs_qtd-week ls_qtd_desc-seqid
*                                  CHANGING gs_qtd_alv-vdata1 gs_qtd_alv-vdata2 gs_qtd_alv-vdata3 gs_qtd_alv-vdata4 gs_qtd_alv-vdata5
*                                           gs_qtd_alv-vdata6 gs_qtd_alv-vdata7 gs_qtd_alv-tshift gs_qtd_alv-tweek.
*
*        MODIFY TABLE gt_qtd_alv FROM gs_qtd_alv TRANSPORTING vdata1 vdata2 vdata3 vdata4 vdata5
*                                                             vdata6 vdata7 tshift tweek.
*      ENDLOOP.
*    ELSE.
**<<<PAP - Correcção
*      MOVE-CORRESPONDING gs_qtd TO gs_qtd_alv.
*
**    Read description for Area
*      READ TABLE lt_area_desc INTO ls_area_desc WITH KEY areaid = gs_qtd-areaid.
*
*      IF sy-subrc EQ 0.
**      Area description
*        gs_qtd_alv-area_desc = ls_area_desc-area_desc.
*      ENDIF.
*
**    Read description for Hierarchy
*      READ TABLE lt_hname_desc INTO ls_hname_desc WITH KEY name = gs_qtd-hname.
*
*      IF sy-subrc EQ 0.
**      Hierarchy description
*        gs_qtd_alv-hktext = ls_hname_desc-ktext.
*      ENDIF.
*
**    Read description for Plant
*      READ TABLE lt_werks_desc INTO ls_werks_desc WITH KEY werks = gs_qtd-werks.
*
*      IF sy-subrc EQ 0.
**      Plant description
*        gs_qtd_alv-name1 = ls_werks_desc-name1.
*      ENDIF.
*
**    Read description for Workcenter
*      READ TABLE lt_arbpl_desc INTO ls_arbpl_desc WITH KEY arbpl = gs_qtd-arbpl.
*
*      IF sy-subrc EQ 0.
**      Workcenter description
*        gs_qtd_alv-ktext = ls_arbpl_desc-ktext.
*      ENDIF.
*
**    Read description for Shift
*      READ TABLE lt_shift_desc INTO ls_shift_desc WITH KEY areaid  = gs_qtd-areaid
*                                                           werks   = gs_qtd-werks
*                                                           shiftid = gs_qtd-shiftid.
*
*      IF sy-subrc EQ 0.
**      Shift description
*        gs_qtd_alv-shift_desc = ls_shift_desc-shift_desc.
*      ENDIF.
*
**    Get number day in week
*      CALL FUNCTION 'DATE_COMPUTE_DAY'
*        EXPORTING
*          date = gs_qtd-data
*        IMPORTING
*          day  = ld_day.
*
**    Type quantities calculated
*      LOOP AT it_qtd_desc INTO ls_qtd_desc.
*        CLEAR: gs_qtd_alv-qtd_desc,
*               gs_qtd_alv-vdata1,
*               gs_qtd_alv-vdata2,
*               gs_qtd_alv-vdata3,
*               gs_qtd_alv-vdata4,
*               gs_qtd_alv-vdata5,
*               gs_qtd_alv-vdata6,
*               gs_qtd_alv-vdata7,
*               gs_qtd_alv-tshift,
*               gs_qtd_alv-tweek,
*               ld_value.
*
*        CASE ls_qtd_desc-seqid.
*          WHEN 1.
*            gs_qtd_alv-qtd_desc = ls_qtd_desc-qtd_desc.
*            ld_value = gs_qtd-gamng.
*          WHEN 2.
*            gs_qtd_alv-qtd_desc = ls_qtd_desc-qtd_desc.
*            ld_value = gs_qtd-qtdprod.
*          WHEN 3.
*            gs_qtd_alv-qtd_desc = ls_qtd_desc-qtd_desc.
*            ld_value = gs_qtd-lmnga.
*          WHEN 4.
*            gs_qtd_alv-qtd_desc = ls_qtd_desc-qtd_desc.
*            ld_value = gs_qtd-xmnga.
*          WHEN 5.
*            gs_qtd_alv-qtd_desc = ls_qtd_desc-qtd_desc.
*            ld_value = gs_qtd-rmnga.
*          WHEN 6.
*            gs_qtd_alv-qtd_desc = ls_qtd_desc-qtd_desc.
*            ld_value = gs_qtd-pctprod.
*        ENDCASE.
*
**      Add differente quantities
*        PERFORM add_data_quantity TABLES gt_total
*                                  USING ld_day ld_value gs_qtd-areaid gs_qtd-hname gs_qtd-werks
*                                        gs_qtd-arbpl gs_qtd-shiftid gs_qtd-week ls_qtd_desc-seqid
*                                  CHANGING gs_qtd_alv-vdata1 gs_qtd_alv-vdata2 gs_qtd_alv-vdata3 gs_qtd_alv-vdata4 gs_qtd_alv-vdata5
*                                           gs_qtd_alv-vdata6 gs_qtd_alv-vdata7 gs_qtd_alv-tshift gs_qtd_alv-tweek.
*
**      Data for ALV
*        APPEND gs_qtd_alv TO gt_qtd_alv.
*      ENDLOOP.
*    ENDIF.
*  ENDLOOP.
*
**>>>PAP - Correcção - 20.05.2015
*  DATA: ld_days TYPE pea_scrdd.
*
*  FIELD-SYMBOLS: <fs_qtd_alv> TYPE zlp_sf_s_data_alv.
*
*  IF so_date[] IS NOT INITIAL.
*
*    CLEAR ld_days.
*
*    CALL FUNCTION 'HR_HK_DIFF_BT_2_DATES'
*      EXPORTING
*        date1                       = so_date-high
*        date2                       = so_date-low
*        output_format               = '03'
*      IMPORTING
*        days                        = ld_days
*      EXCEPTIONS
*        overflow_long_years_between = 1
*        invalid_dates_specified     = 2
*        OTHERS                      = 3.
*
*    IF sy-subrc <> 0.
** Implement suitable error handling here
*    ENDIF.
*
*
*    LOOP AT gt_qtd_alv ASSIGNING <fs_qtd_alv> WHERE qtd_desc EQ TEXT-015.
*
*      IF ld_days IS NOT INITIAL.
*        <fs_qtd_alv>-tshift = <fs_qtd_alv>-tshift / ld_days.
*        <fs_qtd_alv>-tweek = <fs_qtd_alv>-tweek / ld_days.
*      ENDIF.
*    ENDLOOP.
*
*  ENDIF.
*<<<PAP - Correcção - 20.05.2015
ENDFORM.                    " FILL_DATA_ALV
*&---------------------------------------------------------------------*
*&      Form  ADD_DATA_QUANTITY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_DAY  text
*      -->P_AREAID  text
*      -->P_HNAME  text
*      -->P_WERKS  text
*      -->P_ARBPL  text
*      -->P_SHIFTID  text
*      -->P_WEEK  text
*      -->P_IT_TOTAL  text
*      <--P_TSHIFT  text
*      <--P_TWEEK  text
*----------------------------------------------------------------------*
*FORM add_data_quantity TABLES p_it_total LIKE gt_total
*                       USING p_day p_value p_areaid p_hname p_werks p_arbpl
*                             p_shiftid p_week p_seqid
*                       CHANGING p_vdata1 p_vdata2 p_vdata3 p_vdata4 p_vdata5
*                                 p_vdata6 p_vdata7 p_tshift p_tweek.
*
**  DATA ls_total TYPE ty_total.
**
***Put value quantity in corresponding day in week
**  CASE p_day.
**    WHEN 1.
**      p_vdata1 = p_value.
**    WHEN 2.
**      p_vdata2 = p_value.
**    WHEN 3.
**      p_vdata3 = p_value.
**    WHEN 4.
**      p_vdata4 = p_value.
**    WHEN 5.
**      p_vdata5 = p_value.
**    WHEN 6.
**      p_vdata6 = p_value.
**    WHEN 7.
**      p_vdata7 = p_value.
**  ENDCASE.
**
***Total value quantity for shift
**  CLEAR ls_total.
**  LOOP AT p_it_total INTO ls_total WHERE areaid  EQ p_areaid
**                                     AND hname   EQ p_hname
**                                     AND werks   EQ p_werks
**                                     AND arbpl   EQ p_arbpl
**                                     AND shiftid EQ p_shiftid
**                                     AND week    EQ p_week.
**
***  Total for shift
**    CASE p_seqid.
**      WHEN 1.
**        ADD ls_total-tot_gamng TO p_tshift.
**      WHEN 2.
**        ADD ls_total-tot_qtdprod TO p_tshift.
**      WHEN 3.
**        ADD ls_total-tot_lmnga TO p_tshift.
**      WHEN 4.
**        ADD ls_total-tot_xmnga TO p_tshift.
**      WHEN 5.
**        ADD ls_total-tot_rmnga TO p_tshift.
**      WHEN 6.
**        ADD ls_total-tot_pctprod TO p_tshift.
**    ENDCASE.
**  ENDLOOP.
**
***Total value quantity in week
**  CLEAR ls_total.
**  LOOP AT p_it_total INTO ls_total WHERE areaid EQ p_areaid
**                                     AND hname  EQ p_hname
**                                     AND werks  EQ p_werks
**                                     AND arbpl  EQ p_arbpl
**                                     AND week   EQ p_week.
**
***  Total for shift
**    CASE p_seqid.
**      WHEN 1.
**        ADD ls_total-tot_gamng TO p_tweek.
**      WHEN 2.
**        ADD ls_total-tot_qtdprod TO p_tweek.
**      WHEN 3.
**        ADD ls_total-tot_lmnga TO p_tweek.
**      WHEN 4.
**        ADD ls_total-tot_xmnga TO p_tweek.
**      WHEN 5.
**        ADD ls_total-tot_rmnga TO p_tweek.
**      WHEN 6.
**        ADD ls_total-tot_pctprod TO p_tweek.
**    ENDCASE.
**  ENDLOOP.
*ENDFORM.                    " ADD_DATA_QUANTITY
*&---------------------------------------------------------------------*
*&      Form  GET_DATA_DB
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data_db .
*  DATA: lt_zlp_pp_sf056 TYPE TABLE OF zlp_pp_sf056.
*
*  DATA: ls_zlp_pp_sf056 TYPE zlp_pp_sf056.
*
*  REFRESH lt_zlp_pp_sf056.
*
**Get all data saved in database
*  SELECT *
*    FROM zlp_pp_sf056
*    INTO CORRESPONDING FIELDS OF TABLE lt_zlp_pp_sf056
*    WHERE areaid  EQ pa_area
*      AND hname   IN so_hname
*      AND werks   EQ pa_werks
*      AND arbpl   IN so_arbpl
*      AND shiftid IN so_shift
*      AND data    IN so_date.
*
*  IF lt_zlp_pp_sf056[] IS NOT INITIAL.
**  Pass data to global internal table
*    gt_qtd[] = lt_zlp_pp_sf056[].
*  ELSE.
**    MESSAGE i018(zlp_pp_shopfloor).
*
*    CALL METHOD zcl_lp_pp_sf_log=>add_message
*      EXPORTING
**       msgid      = sy-msgid
*        msgty      = 'I'
*        msgno      = '018'
*      CHANGING
*        return_tab = gt_error.
*    EXIT.
*  ENDIF.
ENDFORM.                    " GET_DATA_DB
*&---------------------------------------------------------------------*
*&      Form  GET_DATA_AFRU
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data_afru .


*  Get confirmations
  SELECT *
    FROM afru
    INTO CORRESPONDING FIELDS OF TABLE gt_afru
    WHERE budat    IN gr_dates
      AND arbid    IN gr_arbid
      AND werks    EQ pa_werks
      AND stokz    EQ space
      AND stzhl    EQ space.

  IF gt_afru[] IS NOT INITIAL.

    gt_afru_aux = gt_afru[].
    DELETE gt_afru_aux WHERE meilr = space OR lmnga = '0'.

  ENDIF.
ENDFORM.                    " GET_DATA_AFRU
*&---------------------------------------------------------------------*
*&      Form  GET_QUANTITY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_<FS_QTD>_AREAID  text
*      -->P_<FS_QTD>_HNAME  text
*      -->P_<FS_QTD>_WERKS  text
*      -->P_<FS_QTD>_ARBPL  text
*      -->P_<FS_QTD>_SHIFTID  text
*      -->P_<FS_QTD>_DATA  text
*      <--P_<FS_QTD>_GAMNG  text
*      <--P_<FS_QTD>_LMNGA  text
*      <--P_<FS_QTD>_XMNGA  text
*      <--P_<FS_QTD>_RMNGA  text
*      <--P_<FS_QTD>_QTDPROD  text
*      <--P_<FS_QTD>_PCTPROD  text
*----------------------------------------------------------------------*
FORM get_quantity USING p_areaid p_hname p_werks
                        p_arbpl p_shiftid p_data
                  CHANGING p_gamng p_lmnga p_xmnga
                           p_rmnga p_qtdprod p_pctprod.

  TYPES: BEGIN OF ty_afko,
           aufnr TYPE aufnr,
           rueck TYPE co_rueck,
           gamng TYPE gamng,
         END OF ty_afko.

  CONSTANTS: c_sec_day TYPE kapbegzt VALUE '86400',
             c_day     TYPE t VALUE '240000'.

  DATA: lv_kapid    TYPE kapid,
        ld_worktime TYPE mengv13,
        ld_capacity TYPE kapazitaet,
        ld_einzt    TYPE kapeinzt.

  DATA: ls_afru        TYPE afru,
        ls_kako        TYPE kako,
        ls_workcenters LIKE LINE OF gt_workcenters,
        lt_prdord      TYPE TABLE OF ty_prdord.


  DATA: lv_prod_time TYPE zabsf_pp_e_prodtime,
        lv_days      TYPE i,
        lv_time      TYPE cva_time.

  DATA: lv_wc_begzt  TYPE kapbegzeit,
        lv_wc_endzt  TYPE kapendzeit,
        lv_ini_time  TYPE kapbegzeit,
        lv_fini_time TYPE kapendzeit,
        lv_ini_date  TYPE datum,
        lv_fini_date TYPE datum.

  DATA: lt_afko     TYPE TABLE OF ty_afko,
        ls_afko     TYPE ty_afko,
        lt_afko_all TYPE TABLE OF afko,
        ls_afko_all TYPE afko,
        lv_matnr    TYPE matnr,
        lv_menge    TYPE bstmg.


  FIELD-SYMBOLS:<fs_prdord> TYPE ty_prdord.

  IF gt_afru_aux[] IS NOT INITIAL.

*  Get workcenter id

    READ TABLE gt_workcenters INTO ls_workcenters WITH KEY arbpl = p_arbpl.
    IF sy-subrc EQ 0.

      LOOP AT gt_afru_aux INTO ls_afru WHERE budat  EQ p_data
                                       AND arbid    EQ ls_workcenters-objid
                                       AND werks    EQ p_werks
                                       AND kaptprog EQ p_shiftid.

*IF  ls_afru-lmnga = '30.00'.
*BREAK ABACO_ABAP.
*BREAK abacoadmin.
*                PERFORM convert_un USING ls_afru-WABLNR ls_afru-gmein ls_afru-lmnga CHANGING ls_afru.
*ENDIF.

**Conversão para KG
        IF ls_afru-meinh NE 'KG' AND ls_afru-lmnga GT 0.

          SELECT SINGLE plnbez INTO lv_matnr
                 FROM afko
                 WHERE aufnr = ls_afru-aufnr.

          CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
            EXPORTING
              i_matnr              = lv_matnr
              i_in_me              = ls_afru-meinh
              i_out_me             = 'KG'
              i_menge              = ls_afru-lmnga
            IMPORTING
              e_menge              = ls_afru-lmnga
            EXCEPTIONS
              error_in_application = 1
              error                = 2
              OTHERS               = 3.
          IF sy-subrc <> 0.
* Implement suitable error handling here
          ENDIF.
        ENDIF.
*    Good Quantity
        ADD ls_afru-lmnga TO p_lmnga.
*    Quantity scrap
        ADD ls_afru-xmnga TO p_xmnga.
*    Quantity rework
        ADD ls_afru-rmnga TO p_rmnga.

        IF ls_afru-lmnga IS NOT INITIAL.
          MOVE: ls_afru-aufnr TO ls_afko-aufnr,
                ls_afru-rueck TO ls_afko-rueck.

          APPEND ls_afko TO lt_afko.
        ENDIF.

        CLEAR ls_afru.
      ENDLOOP.

*  Quantity produced
      p_qtdprod = p_lmnga + p_xmnga + p_rmnga.


**MJP:INI:ABACO_ABAP: 04.06.2019 11:23:47
      SORT lt_afko.
      DELETE ADJACENT DUPLICATES FROM lt_afko.

      IF lt_afko IS NOT INITIAL.
        SELECT * FROM afko
          INTO CORRESPONDING FIELDS OF TABLE lt_afko_all
          FOR ALL ENTRIES IN lt_afko
          WHERE aufnr = lt_afko-aufnr.
      ENDIF.

      LOOP AT lt_afko INTO ls_afko.
        READ TABLE lt_afko_all INTO ls_afko_all
        WITH KEY aufnr = ls_afko-aufnr.

        ADD ls_afko_all-gamng TO p_gamng.
      ENDLOOP.
**MJP:FIM:ABACO_ABAP: 04.06.2019 11:23:53

*>>>>COMMMENT
*
*
**Get all orders in workcenter with sechedule operations
*      SELECT aufk~aufnr aufk~objnr aufk~auart afko~gstrp afko~gltrp afko~gstrs afko~gsuzs afko~gltrs
*             afko~ftrmi afko~gmein afko~plnbez afko~plnty afko~plnnr afko~stlbez
*             afko~aufpl afko~trmdt afvc~aplzl afvc~vornr afvc~ltxa1 afvc~steus afvc~rueck
*             afvc~rmzhl afvc~zerma afvv~fsavd afvv~fsavz afvv~sssld afvv~ssslz afvv~mgvrg
*             afvv~vgw02 afvv~vge02 afvv~bmsch t430~autwe
*        INTO CORRESPONDING FIELDS OF TABLE lt_prdord
*        FROM afvc AS afvc
*        INNER JOIN afvv AS afvv
*          ON afvv~aufpl EQ afvc~aufpl
*         AND afvv~aplzl EQ afvc~aplzl
*       INNER JOIN t430 AS t430
*          ON t430~steus EQ afvc~steus
*         AND t430~ruek EQ '1'
*       INNER JOIN afko AS afko
*          ON afko~aufpl EQ afvc~aufpl
*       INNER JOIN aufk AS aufk
*          ON afko~aufnr EQ aufk~aufnr
*       INNER JOIN jest AS jest
*          ON jest~objnr EQ aufk~objnr
*         AND jest~stat  EQ 'I0002'
*         AND jest~inact EQ space
*       WHERE afvc~arbid EQ ls_workcenters-objid
*        AND t430~term EQ abap_true "programadas
*         AND ( afvv~fsavd LE p_data AND
*               afvv~sssld GE p_data ).
*
*      IF lt_prdord IS NOT INITIAL.
*
**Get ID capacity
*        SELECT SINGLE kapid
*          FROM crhd
*          INTO lv_kapid
*         WHERE arbpl EQ p_arbpl
*           AND werks EQ p_werks.
*
**Get capacity detail
*        SELECT SINGLE *
*          FROM kako
*          INTO CORRESPONDING FIELDS OF ls_kako
*         WHERE kapid EQ lv_kapid
*          AND kapar EQ '001'.
*
*        CHECK sy-subrc EQ 0.
*
*        IF ls_kako-begzt GT 0 OR ls_kako-endzt GT 0.
**  Capacity - Time
*          IF ls_kako-endzt GE ls_kako-begzt.
*            ld_capacity = ls_kako-endzt - ls_kako-begzt.
*
*            IF ld_capacity = 0.
*              ld_capacity = c_sec_day.
*            ENDIF.
*          ELSE.
*            ld_capacity = c_sec_day - ls_kako-begzt + ls_kako-endzt.
*          ENDIF.
*
*          IF ld_capacity GT ls_kako-pause.
**    Worktime
*            ld_einzt = ( ld_capacity - ls_kako-pause ) * ls_kako-ngrad / 100.
*
*            ld_einzt = ld_einzt * ls_kako-aznor.
*
*            ld_worktime = ld_einzt / 60.
*          ELSE.
*            ld_worktime = 0.
*          ENDIF.
*        ENDIF.
*
** copy from standard program  SAPLCRK0
*        lv_wc_begzt = ls_kako-begzt.
*        IF ls_kako-endzt = c_sec_day.
*          lv_wc_endzt = c_day.
*        ELSE.
*          lv_wc_endzt = ls_kako-endzt.
*        ENDIF.
*      ENDIF.
*
**  Calculate qtty for each row.
*      LOOP AT lt_prdord ASSIGNING <fs_prdord>.
*
** convert to minutes.
*        CALL FUNCTION 'UNIT_CONVERSION_SIMPLE'
*          EXPORTING
*            input    = <fs_prdord>-vgw02
*            unit_in  = <fs_prdord>-vge02
*            unit_out = 'MIN'
*          IMPORTING
*            output   = <fs_prdord>-vgw02.
*        IF sy-subrc <> 0.
*        ENDIF.
*
*        "All day working - DONE
*        IF <fs_prdord>-fsavd LT p_data AND <fs_prdord>-sssld GT p_data.
*
*          IF <fs_prdord>-vgw02 IS NOT INITIAL.
*            <fs_prdord>-gamng = ( ld_worktime / <fs_prdord>-vgw02 ) * <fs_prdord>-bmsch.
*          ENDIF.
*
*        ENDIF.
*
*        "started and finished on p_data !DONE
*        IF <fs_prdord>-fsavd EQ p_data AND <fs_prdord>-sssld EQ p_data.
*
*          CHECK <fs_prdord>-fsavz LT lv_wc_endzt.
*
*          IF <fs_prdord>-fsavz GE lv_wc_begzt.
*            lv_ini_time = <fs_prdord>-fsavz.
*          ELSE.
*            lv_ini_time = lv_wc_begzt.
*          ENDIF.
*
*          IF <fs_prdord>-ssslz LE lv_wc_endzt.
*            lv_fini_time = <fs_prdord>-ssslz.
*          ELSE.
*            lv_fini_time = lv_wc_endzt.
*          ENDIF.
*
*          lv_ini_date = <fs_prdord>-fsavd.
*          lv_fini_date = <fs_prdord>-sssld.
*
*        ENDIF.
*
*        " started yesterday and finished on p_data
*        IF <fs_prdord>-fsavd LT p_data AND <fs_prdord>-sssld EQ p_data.
*
*          CHECK <fs_prdord>-ssslz GT lv_wc_begzt.
*
*          lv_fini_date = <fs_prdord>-sssld.
*          lv_ini_date = <fs_prdord>-sssld.
*          lv_ini_time = lv_wc_begzt.
*
*          IF <fs_prdord>-ssslz GE lv_wc_endzt.
*            lv_fini_time = lv_wc_endzt.
*          ELSE.
*            lv_fini_time = <fs_prdord>-ssslz.
*          ENDIF.
*
*        ENDIF.
*
** started today but not finished today
*        IF <fs_prdord>-fsavd EQ p_data AND <fs_prdord>-sssld GT p_data.
*
*          CHECK <fs_prdord>-fsavz LT lv_wc_endzt.
*
*          lv_fini_date = <fs_prdord>-fsavd.
*          lv_ini_date = <fs_prdord>-fsavd.
*          lv_fini_time = lv_wc_endzt.
*
*          IF <fs_prdord>-fsavz GE lv_wc_begzt.
*            lv_ini_time = <fs_prdord>-fsavz.
*          ELSE.
*            lv_ini_time = lv_wc_begzt.
*          ENDIF.
*
*        ENDIF.
*
** calculate duration.
*        CALL FUNCTION 'SCOV_TIME_DIFF'
*          EXPORTING
*            im_date1              = lv_ini_date
*            im_date2              = lv_fini_date
*            im_time1              = lv_ini_time
*            im_time2              = lv_fini_time
*          IMPORTING
*            ex_days               = lv_days
*            ex_time               = lv_time
*          EXCEPTIONS
*            start_larger_than_end = 1
*            OTHERS                = 2.
*
*        IF sy-subrc <> 0.
** Implement suitable error handling here
*        ENDIF.
*
*        lv_prod_time = ( lv_days * 1440 ) + ( lv_time / 60 ). ">>minutes
*
*        IF lv_prod_time GT ld_worktime AND <fs_prdord>-vgw02 IS NOT INITIAL.
*          <fs_prdord>-gamng = ( ld_worktime / <fs_prdord>-vgw02 ) * <fs_prdord>-bmsch.
*        ELSE.
*          <fs_prdord>-gamng = ( lv_prod_time / <fs_prdord>-vgw02 ) * <fs_prdord>-bmsch.
*        ENDIF.
*
*
*        CLEAR: lv_prod_time, lv_prod_time, lv_days, lv_time.
*      ENDLOOP.
*<<<END COMMENT

    ENDIF.




  ENDIF.
ENDFORM.                    " GET_QUANTITY
*&---------------------------------------------------------------------*
*&      Form  GET_AFRU_MONT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_R_ARBPL  text
*----------------------------------------------------------------------*
FORM get_afru_mont  TABLES p_arbpl TYPE STANDARD TABLE.

*  DATA: lt_mkpf       TYPE TABLE OF mkpf,
*        lt_mkpf_aux   TYPE TABLE OF mkpf,
*        lt_blpp_mblnr TYPE TABLE OF blpp,
*        lt_blpp_afru  TYPE TABLE OF blpp,
*        lt_blpk       TYPE TABLE OF blpk.
*
*  DATA: ls_mkpf       TYPE mkpf,
*        ls_blpp_mblnr TYPE blpp,
*        ls_blpp_afru  TYPE blpp,
*        ls_shift      LIKE so_shift.
*
*  FIELD-SYMBOLS: <fs_afru> TYPE afru.
*
*
*  REFRESH: lt_mkpf,
*           lt_mkpf_aux,
*           lt_blpp_mblnr,
*           lt_blpp_afru,
*           lt_blpk.
*
*  CLEAR: ls_mkpf,
*         ls_blpp_mblnr,
*         ls_blpp_afru,
*         ls_shift.
*
**Get all material document created in day
*  LOOP AT so_shift INTO ls_shift.
*    SELECT *
*      FROM mkpf
*      INTO CORRESPONDING FIELDS OF TABLE lt_mkpf_aux
*     WHERE mjahr EQ pa_date(4)
*       AND bldat EQ pa_date
*       AND bktxt EQ ls_shift-low
*       AND vgart EQ c_vgart
*       AND blart EQ c_blart
*       AND blaum EQ c_blaum.
*
*    INSERT LINES OF lt_mkpf_aux INTO TABLE lt_mkpf.
*  ENDLOOP.
*
*  SORT lt_mkpf BY mblnr bktxt.
*
*  DELETE ADJACENT DUPLICATES FROM lt_mkpf.
*
*  IF lt_mkpf[] IS NOT INITIAL.
**  Get Confirmation number of material document
*    SELECT *
*      FROM blpp
*      INTO CORRESPONDING FIELDS OF TABLE lt_blpp_mblnr
*       FOR ALL ENTRIES IN lt_mkpf
*     WHERE belnr EQ lt_mkpf-mblnr.
*
*    IF lt_blpp_mblnr[] IS NOT INITIAL.
**    Get confirmation number of material document valid for day
*      SELECT *
*        FROM blpk
*        INTO CORRESPONDING FIELDS OF TABLE lt_blpk
*         FOR ALL ENTRIES IN lt_blpp_mblnr
*       WHERE prtnr EQ lt_blpp_mblnr-prtnr
*         AND datum EQ pa_date.
*
*      IF lt_blpk[] IS NOT INITIAL.
**      Get confirmation number for afru
*        SELECT *
*          FROM blpp
*          INTO CORRESPONDING FIELDS OF TABLE lt_blpp_afru
*          FOR ALL ENTRIES IN lt_blpk
*          WHERE prtnr EQ lt_blpk-prtnr
*           AND belnr EQ space
*           AND rueck NE '0000000000'
*           AND rmzhl NE '00000000'.
*
*        IF lt_blpp_afru[] IS NOT INITIAL.
**        Get confirmation
*          SELECT  afru~rueck afru~rmzhl afru~budat plpo~arbid afru~werks afru~isdd
*                  afru~stokz afru~stzhl afru~lmnga afru~rmnga afru~xmnga afru~aufpl
*                  afru~aplzl afru~vornr afru~aufnr
*            INTO CORRESPONDING FIELDS OF TABLE gt_afru
*            FROM afru AS afru
*           INNER JOIN afvc AS afvc
*              ON afvc~aufpl EQ afru~aufpl
*             AND afvc~aplzl EQ afru~aplzl
*           INNER JOIN plpo AS plpo
*              ON plpo~plnnr EQ afvc~plnnr
*             AND plpo~plnkn EQ afvc~plnkn
*             AND plpo~zaehl EQ afvc~zaehl
*             AND plpo~plnty EQ afvc~plnty
*             AND plpo~vornr EQ afvc~vornr
*             FOR ALL ENTRIES IN lt_blpp_afru
*           WHERE afru~rueck EQ lt_blpp_afru-rueck
*             AND afru~budat EQ pa_date
*             AND afru~werks EQ pa_werks
*             AND afru~stokz EQ space
*             AND afru~stzhl EQ space
*             AND plpo~arbid IN p_arbpl.
*        ENDIF.
*      ENDIF.
*    ENDIF.
*  ENDIF.
*
*  IF gt_afru[] IS NOT INITIAL.
*    LOOP AT gt_afru ASSIGNING <fs_afru>.
*      CLEAR: ls_mkpf,
*             ls_blpp_mblnr,
*             ls_blpp_afru.
*
*      READ TABLE lt_blpp_afru INTO ls_blpp_afru WITH KEY rueck = <fs_afru>-rueck
*                                                         rmzhl = <fs_afru>-rmzhl.
*
*      IF sy-subrc EQ 0.
*        READ TABLE lt_blpp_mblnr INTO ls_blpp_mblnr WITH KEY prtnr = ls_blpp_afru-prtnr.
*
*        IF sy-subrc EQ 0.
*          READ TABLE lt_mkpf INTO ls_mkpf WITH KEY mblnr = ls_blpp_mblnr-belnr.
*
*          IF sy-subrc EQ 0.
*            <fs_afru>-kaptprog = ls_mkpf-bktxt.
*          ENDIF.
*        ENDIF.
*      ENDIF.
*    ENDLOOP.
*  ENDIF.
ENDFORM.                    " GET_AFRU_MONT
*&---------------------------------------------------------------------*
*&      Form  GET_AREAS_FOR_PLANT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_areas_for_plant .

  DATA: lt_sf008    TYPE TABLE OF zabsf_pp008,
        ls_sf008    TYPE zabsf_pp008,
        lr_tarea_id TYPE rsis_t_range,
        ls_tarea_id TYPE rsis_s_range.

*create areas type range.
  ls_tarea_id-sign = 'I'.
  ls_tarea_id-option = 'EQ'.
  ls_tarea_id-low = 'AT01'.
  APPEND ls_tarea_id TO lr_tarea_id.

  ls_tarea_id-sign = 'I'.
  ls_tarea_id-option = 'EQ'.
  ls_tarea_id-low = 'AT02'.
  APPEND ls_tarea_id TO lr_tarea_id.


  ls_tarea_id-sign = 'I'.
  ls_tarea_id-option = 'EQ'.
  ls_tarea_id-low = 'AT03'.
  APPEND ls_tarea_id TO lr_tarea_id.



  SELECT * FROM zabsf_pp008 INTO TABLE lt_sf008
      WHERE werks = pa_werks
      AND tarea_id IN lr_tarea_id
      AND begda LE gv_datum
      AND endda GE gv_datum.


  LOOP AT lt_sf008 INTO ls_sf008.

    gs_qtd-areaid = ls_sf008-areaid.
    APPEND gs_qtd TO gt_qtd.
    CLEAR ls_sf008.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_HIERARCHIES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_hierarchies .

  DATA: lt_zlp_pp_sf002 TYPE TABLE OF zabsf_pp002,
        ls_sf002        LIKE LINE OF lt_zlp_pp_sf002,
        ls_qtd          LIKE LINE OF gt_qtd,
        lt_qtd_aux      TYPE TABLE OF zabsf_pp056,
        ls_qtd_aux      LIKE LINE OF lt_qtd_aux.

  LOOP AT gt_qtd INTO ls_qtd.

*  Get all hierarchies for area
    SELECT DISTINCT werks areaid hname
      FROM zabsf_pp002
      INTO CORRESPONDING FIELDS OF TABLE lt_zlp_pp_sf002
     WHERE areaid EQ ls_qtd-areaid
       AND werks EQ ls_qtd-werks
       AND begda  LE ls_qtd-data
       AND endda  GE ls_qtd-data.

    IF sy-subrc EQ 0.

      LOOP AT lt_zlp_pp_sf002 INTO ls_sf002.

        MOVE-CORRESPONDING ls_qtd TO ls_qtd_aux.
        ls_qtd_aux-hname = ls_sf002-hname.
        APPEND ls_qtd_aux TO lt_qtd_aux.

        CLEAR ls_sf002.
      ENDLOOP.
    ENDIF.

    REFRESH lt_zlp_pp_sf002.
    CLEAR ls_qtd.

  ENDLOOP.

  REFRESH gt_qtd.

  gt_qtd[] = lt_qtd_aux[].


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CREATE_DATA_RANGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM create_data_range .

  DATA: lv_date_past   TYPE begda,
        lv_date_future TYPE endda,
        lr_dates       TYPE rsis_s_range,
        ls_qtd         LIKE LINE OF gt_qtd,
        ls_qtd_aux     LIKE LINE OF gt_qtd,
        lt_qtd_aux     TYPE TABLE OF zabsf_pp056,
        ls_days        LIKE LINE OF gt_days.

  IF pa_30day EQ abap_true.

    CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
      EXPORTING
        date      = sy-datum
        days      = 0
        months    = 1
        signum    = '-'
        years     = 0
      IMPORTING
        calc_date = lv_date_past.

  ELSE.

    CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
      EXPORTING
        date      = sy-datum
        days      = 1
        months    = 0
        signum    = '-'
        years     = 0
      IMPORTING
        calc_date = lv_date_past.

  ENDIF.

  CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
    EXPORTING
      date      = sy-datum
      days      = 1
      months    = 0
      signum    = '+'
      years     = 0
    IMPORTING
      calc_date = lv_date_future.

  lr_dates-sign = 'I'.
  lr_dates-option = 'BT'.
  lr_dates-low = lv_date_past.
  lr_dates-high = lv_date_future.

  APPEND lr_dates TO gr_dates.

  CALL FUNCTION 'DAY_ATTRIBUTES_GET'
    EXPORTING
      date_from                  = lv_date_past
      date_to                    = lv_date_future
    TABLES
      day_attributes             = gt_days
    EXCEPTIONS
      factory_calendar_not_found = 1
      holiday_calendar_not_found = 2
      date_has_invalid_format    = 3
      date_inconsistency         = 4
      OTHERS                     = 5.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  LOOP AT gt_qtd INTO ls_qtd. "werks and Area id.

    LOOP AT gt_days INTO ls_days.


      ls_qtd_aux-werks = ls_qtd-werks.
      ls_qtd_aux-areaid = ls_qtd-areaid.
      ls_qtd_aux-data = ls_days-date.

*  Week
      CALL FUNCTION 'DATE_GET_WEEK'
        EXPORTING
          date         = ls_qtd_aux-data
        IMPORTING
          week         = ls_qtd_aux-week
        EXCEPTIONS
          date_invalid = 1
          OTHERS       = 2.

      APPEND ls_qtd_aux TO lt_qtd_aux.

      CLEAR ls_days.
    ENDLOOP.

    CLEAR ls_qtd.
  ENDLOOP.

  REFRESH gt_qtd.

  gt_qtd[] = lt_qtd_aux[].

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_SHIFTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_shifts .

  DATA: ls_qtd          LIKE LINE OF gt_qtd,
        lt_qtd_aux      TYPE TABLE OF zabsf_pp056,
        ls_qtd_aux      TYPE zabsf_pp056,
        ls_sf001        TYPE zabsf_pp001,
        lt_zlp_pp_sf001 TYPE TABLE OF zabsf_pp001.


  LOOP AT gt_qtd INTO ls_qtd.
*  Get shifts for area
    SELECT *
      FROM zabsf_pp001
      INTO CORRESPONDING FIELDS OF TABLE lt_zlp_pp_sf001
     WHERE areaid EQ ls_qtd-areaid
       AND werks EQ ls_qtd-werks
       AND begda  LE ls_qtd-data
       AND endda  GE ls_qtd-data.

    IF sy-subrc EQ 0.

      LOOP AT lt_zlp_pp_sf001 INTO ls_sf001.

        MOVE-CORRESPONDING ls_qtd TO ls_qtd_aux. "werks, data, week, area
        ls_qtd_aux-shiftid = ls_sf001-shiftid.

        APPEND ls_qtd_aux TO lt_qtd_aux.
        CLEAR ls_sf001.
      ENDLOOP.
    ENDIF.
    CLEAR ls_qtd.
  ENDLOOP.

  REFRESH gt_qtd.

  gt_qtd[] = lt_qtd_aux[].


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_PRODUCTION_TIME
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_<FS_QTD>_AREAID  text
*      -->P_<FS_QTD>_HNAME  text
*      -->P_<FS_QTD>_WERKS  text
*      -->P_<FS_QTD>_ARBPL  text
*      -->P_<FS_QTD>_SHIFTID  text
*      -->P_<FS_QTD>_DATA  text
*----------------------------------------------------------------------*
FORM get_production_time  USING    p_areaid
                                   p_hname
                                   p_werks
                                   p_arbpl
                                   p_shiftid
                                   p_data
                                   p_week.


  DATA:ls_sf055             TYPE zabsf_pp055,
       ls_afru              TYPE afru,
       ls_workcenters       LIKE LINE OF gt_workcenters,
       lv_confirmation_time TYPE ru_ismng,
       lv_ism               TYPE ru_ismng,
       lv_ile               TYPE co_ismngeh.

  ls_sf055-areaid = p_areaid.
  ls_sf055-hname = p_hname.
  ls_sf055-werks = p_werks.
  ls_sf055-arbpl = p_arbpl.
  ls_sf055-shiftid = p_shiftid.
  ls_sf055-data = p_data.
  ls_sf055-week = p_week.

  READ TABLE gt_workcenters INTO ls_workcenters WITH KEY arbpl = p_arbpl.
  IF sy-subrc EQ 0.


    LOOP AT gt_afru INTO ls_afru WHERE budat  EQ p_data
                                 AND arbid    EQ ls_workcenters-objid
                                 AND werks    EQ p_werks
                                 AND kaptprog EQ p_shiftid.

      IF ls_afru-ism02 IS NOT INITIAL.
        MOVE ls_afru-ism02 TO lv_ism.
        MOVE ls_afru-ile02 TO lv_ile.

      ELSEIF ls_afru-ism03 IS NOT INITIAL.
        MOVE ls_afru-ism03 TO lv_ism.
        MOVE ls_afru-ile03 TO lv_ile.

      ELSEIF ls_afru-ism01 IS NOT INITIAL.
        MOVE ls_afru-ism01 TO lv_ism.
        MOVE ls_afru-ile01 TO lv_ile.
      ENDIF.

      IF lv_ism IS NOT INITIAL.
        ls_afru-ism02 = lv_ism.
        ls_afru-ile02 = lv_ile.

        CALL FUNCTION 'UNIT_CONVERSION_SIMPLE'
          EXPORTING
            input    = ls_afru-ism02
            unit_in  = ls_afru-ile02
            unit_out = 'MIN'
          IMPORTING
            output   = ls_afru-ism02.
        IF sy-subrc <> 0.
        ENDIF.

      lv_confirmation_time = lv_confirmation_time + ls_afru-ism02.

      ENDIF.
      CLEAR: ls_afru, lv_ism, lv_ile.
    ENDLOOP.

  ENDIF.

  ls_sf055-prodtime = lv_confirmation_time.
  ls_sf055-produnit = 'MIN'.

  APPEND ls_sf055 TO gt_times.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_STOPS_TIME
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_<FS_QTD>_AREAID  text
*      -->P_<FS_QTD>_HNAME  text
*      -->P_<FS_QTD>_WERKS  text
*      -->P_<FS_QTD>_ARBPL  text
*      -->P_<FS_QTD>_SHIFTID  text
*      -->P_<FS_QTD>_DATA  text
*      -->P_<FS_QTD>_WEEK  text
*----------------------------------------------------------------------*
FORM get_stops_time  USING    p_areaid
                              p_hname
                              p_werks
                              p_arbpl
                              p_shiftid
                              p_data
                              p_week.

  CONSTANTS c_minutes_day TYPE i VALUE 1440.

  DATA: lt_sf011     TYPE TABLE OF zabsf_pp011,
        ls_sf011     LIKE LINE OF lt_sf011,
        ls_sf010_aux TYPE zabsf_pp010,
        ls_sf010     LIKE LINE OF gt_sf010,
        ls_sf053     TYPE zabsf_pp053.

  DATA: lt_stops_str_today_open TYPE TABLE OF zabsf_pp010,
        ls_stops_str_today_open LIKE LINE OF lt_stops_str_today_open,
        ls_shift                TYPE zabsf_pp001,
        lv_endda                TYPE ledatum.

  DATA: lt_stops_str_previously_open TYPE TABLE OF zabsf_pp010,
        ls_stops_str_previously_open LIKE LINE OF lt_stops_str_previously_open,
        lt_stops_finished_pdata      TYPE TABLE OF zabsf_pp010,
        ls_finished_pdata            TYPE zabsf_pp010.

  "D2>D1 !
  DATA: t1               TYPE cva_time,
        t2               TYPE cva_time,
        d1               TYPE cva_date,
        d2               TYPE cva_date,
        lv_minutes       TYPE i,
        lv_days          TYPE i,
        lv_time          TYPE cva_time,
        lv_ini_stop_time TYPE zabsf_pp_e_stoptime,
        lv_ini_end_time  TYPE endzt.

  DATA: lv_stop_time TYPE zabsf_pp_e_stoptime.

  ls_sf053-areaid = p_areaid.
  ls_sf053-hname = p_hname.
  ls_sf053-werks = p_werks.
  ls_sf053-arbpl = p_arbpl.
  ls_sf053-shiftid = p_shiftid.
  ls_sf053-data = p_data.
  ls_sf053-week = p_week.
  ls_sf053-shiftid = p_shiftid.

* get all causes
  SELECT * FROM zabsf_pp011 INTO TABLE lt_sf011
    WHERE areaid = p_areaid
    AND werks = pa_werks
    AND endda GE p_data
    AND begda LE p_data
    AND inact EQ space.

* get shift information
  SELECT SINGLE * FROM zabsf_pp001 INTO ls_shift
    WHERE areaid EQ p_areaid
    AND shiftid EQ p_shiftid
    AND werks EQ p_werks
    AND begda  LE p_data
    AND endda  GE p_data.

  CHECK sy-subrc EQ 0.

  LOOP AT lt_sf011 INTO ls_sf011.


*1) started and ended on p_data.
    LOOP AT gt_sf010 INTO ls_sf010
      WHERE areaid = p_areaid
      AND hname = p_hname
      AND werks = p_werks
      AND arbpl = p_arbpl
      AND datesr = p_data
      AND stprsnid = ls_sf011-stprsnid
      AND endda = p_data.

*1.1) started and ended on p_shift
      IF ls_sf010-shiftid EQ p_shiftid AND ls_sf010-timeend LE ls_shift-shift_end.
        lv_stop_time = lv_stop_time + ls_sf010-stoptime.

      ELSE.
*1.2) started on p_shift and ended after p_shift.
        IF ls_sf010-shiftid EQ p_shiftid AND ls_sf010-timeend GT ls_shift-shift_end.

          t1 = ls_sf010-time.
          t2 = ls_shift-shift_end.
        ENDIF.

        IF ls_sf010-shiftid NE p_shiftid.

*1.3) started before p_shift and ended on p_shift.
          IF ls_sf010-time LE ls_shift-shift_start AND ls_sf010-timeend LE ls_shift-shift_end
            AND ls_sf010-timeend GE ls_shift-shift_start.

            t1 = ls_shift-shift_start.
            t2 = ls_sf010-timeend.
          ENDIF.

*  1.4) started before p_shift and ended after p_shift.
          IF ls_sf010-time LT ls_shift-shift_start AND ls_sf010-timeend GT ls_shift-shift_end.

            t1 = ls_shift-shift_start.
            t2 = ls_shift-shift_end.
          ENDIF.
        ENDIF.

        CALL FUNCTION 'SCOV_TIME_DIFF'
          EXPORTING
            im_date1              = gv_datum
            im_date2              = gv_datum
            im_time1              = t1
            im_time2              = t2
          IMPORTING
            ex_days               = lv_days
            ex_time               = lv_time
          EXCEPTIONS
            start_larger_than_end = 1
            OTHERS                = 2.
        IF sy-subrc <> 0.
        ENDIF.

        lv_stop_time = lv_stop_time + ( lv_days * 1440 ) + ( lv_time / 60 ). ">>minutes
      ENDIF.

      CLEAR: lv_days, lv_time, t1, t2.
    ENDLOOP.

*2) Started on p_data but not finished.
    SELECT *
        FROM zabsf_pp010
        INTO TABLE lt_stops_str_today_open
       WHERE areaid  EQ p_areaid
         AND hname   EQ p_hname
         AND arbpl   EQ p_arbpl
         AND werks   EQ p_werks
         AND stprsnid EQ ls_sf011-stprsnid
         AND datesr  EQ p_data
         AND endda   EQ lv_endda "inital<<<<<<<<<<
         AND stoptime EQ lv_ini_stop_time "inital<<<<<<<<<<
         AND timeend EQ lv_ini_end_time. "inital<<<<<<<<<<

    LOOP AT lt_stops_str_today_open INTO ls_stops_str_today_open.

      IF p_data EQ gv_datum.

        IF gv_uzeit GE ls_shift-shift_start AND gv_uzeit LE ls_shift-shift_end.

          t2 = gv_uzeit.
        ENDIF.

        IF gv_uzeit GT ls_shift-shift_end.

          t2 = ls_shift-shift_end.
        ENDIF.
      ELSE.

        t2 = ls_shift-shift_end.
      ENDIF.

*2.1) started on p_shift.
      IF ls_stops_str_today_open-time GE ls_shift-shift_start AND ls_stops_str_today_open-time LE ls_shift-shift_end.

        t1 = ls_stops_str_today_open-time.

        IF p_data EQ gv_datum AND gv_uzeit LT ls_shift-shift_start.
* shift not passed yet. Skip!
          t1 = 0.
          t2 = 0.
        ENDIF.

        CALL FUNCTION 'SCOV_TIME_DIFF'
          EXPORTING
            im_date1              = gv_datum
            im_date2              = gv_datum
            im_time1              = t1
            im_time2              = t2
          IMPORTING
            ex_days               = lv_days
            ex_time               = lv_time
          EXCEPTIONS
            start_larger_than_end = 1
            OTHERS                = 2.
        IF sy-subrc <> 0.
* Implement suitable error handling here
        ENDIF.
      ELSE.

*2.2) started on previous shift.
        IF ls_stops_str_today_open-time LT ls_shift-shift_start.

          t1 = ls_shift-shift_start.

          IF p_data EQ gv_datum AND gv_uzeit LT ls_shift-shift_start.
* shift not passed yet. Skip!
            t1 = 0.
            t2 = 0.
          ENDIF.

          CALL FUNCTION 'SCOV_TIME_DIFF'
            EXPORTING
              im_date1              = gv_datum
              im_date2              = gv_datum
              im_time1              = t1
              im_time2              = t2
            IMPORTING
              ex_days               = lv_days
              ex_time               = lv_time
            EXCEPTIONS
              start_larger_than_end = 1
              OTHERS                = 2.
          IF sy-subrc <> 0.
* Implement suitable error handling here
          ENDIF.
        ENDIF.
      ENDIF.

      lv_stop_time = lv_stop_time + ( lv_days * 1440 ) + ( lv_time / 60 ). ">>minutes

      CLEAR: d1, d2, t1, t2, ls_stops_str_today_open.
    ENDLOOP.

*3) started previously then p_data and not finished
    SELECT *
      FROM zabsf_pp010
      INTO TABLE lt_stops_str_previously_open
     WHERE areaid  EQ p_areaid
       AND hname   EQ p_hname
       AND arbpl   EQ p_arbpl
       AND werks   EQ p_werks
       AND stprsnid EQ ls_sf011-stprsnid
       AND datesr  LT p_data
       AND endda   EQ lv_endda ">>inital
       AND stoptime EQ lv_ini_stop_time ">> initial
       AND timeend EQ lv_ini_end_time. ">> initial

    IF sy-subrc EQ 0.
      IF p_data EQ gv_datum.

        LOOP AT lt_stops_str_previously_open INTO ls_stops_str_previously_open.

          t1 = ls_shift-shift_start.

          IF gv_uzeit GE ls_shift-shift_start AND gv_uzeit LE ls_shift-shift_end.

            t2 = gv_uzeit.
          ENDIF.

          IF gv_uzeit GT ls_shift-shift_end.

            t2 = ls_shift-shift_end.
          ENDIF.

          IF gv_uzeit LT ls_shift-shift_start.
            t1 = 0.
            t2 = 0.
          ENDIF.

          d1 = p_data.
          d2 = p_data.

          CALL FUNCTION 'SCOV_TIME_DIFF'
            EXPORTING
              im_date1              = d1
              im_date2              = d2
              im_time1              = t1
              im_time2              = t2
            IMPORTING
              ex_days               = lv_days
              ex_time               = lv_time
            EXCEPTIONS
              start_larger_than_end = 1
              OTHERS                = 2.
          IF sy-subrc <> 0.
* Implement suitable error handling here
          ENDIF.

          lv_stop_time = lv_stop_time + ( lv_days * 1440 ) + ( lv_time / 60 ). ">>minutes

          CLEAR: d1, d2, t1, t2, ls_stops_str_previously_open.
        ENDLOOP.

      ELSE.

        CALL FUNCTION 'SCOV_TIME_DIFF'
          EXPORTING
            im_date1              = gv_datum
            im_date2              = gv_datum
            im_time1              = ls_shift-shift_start
            im_time2              = ls_shift-shift_end
          IMPORTING
            ex_days               = lv_days
            ex_time               = lv_time
          EXCEPTIONS
            start_larger_than_end = 1
            OTHERS                = 2.
        IF sy-subrc <> 0.
* Implement suitable error handling here
        ENDIF.

        lv_stop_time = lv_stop_time + ( lv_days * 1440 ) + ( lv_time / 60 ). ">>minutes
      ENDIF.
    ENDIF.

*4) started previously and finished after p_data.
    DATA: lv_count       TYPE i,
          lv_minutes_off TYPE i.

    SELECT SINGLE * INTO ls_sf010_aux
      FROM zabsf_pp010
     WHERE areaid  EQ p_areaid
       AND hname   EQ p_hname
       AND arbpl   EQ p_arbpl
       AND werks   EQ p_werks
       AND stprsnid EQ ls_sf011-stprsnid
       AND datesr  LT p_data
       AND endda   GT p_data.

    IF sy-subrc EQ 0.
      CALL FUNCTION 'SCOV_TIME_DIFF'
        EXPORTING
          im_date1              = gv_datum
          im_date2              = gv_datum
          im_time1              = ls_shift-shift_start
          im_time2              = ls_shift-shift_end
        IMPORTING
          ex_days               = lv_days
          ex_time               = lv_time
        EXCEPTIONS
          start_larger_than_end = 1
          OTHERS                = 2.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.

      lv_stop_time = lv_stop_time + ( lv_days * 1440 ) + ( lv_time / 60 ). ">>minutes
    ENDIF.

*5) finished on p_data
    SELECT *
         FROM zabsf_pp010
         INTO TABLE lt_stops_finished_pdata
        WHERE areaid  EQ p_areaid
          AND hname   EQ p_hname
          AND arbpl   EQ p_arbpl
          AND werks   EQ p_werks
          AND stprsnid EQ ls_sf011-stprsnid
          AND datesr  LT p_data
          AND endda   EQ p_data ">>inital
          AND stoptime NE lv_ini_stop_time. ">> initial

    LOOP AT lt_stops_finished_pdata INTO ls_finished_pdata.

      IF ls_finished_pdata-timeend GE ls_shift-shift_start AND ls_finished_pdata-timeend LE ls_shift-shift_end.
        t1 = ls_shift-shift_start.
        t2 = ls_finished_pdata-timeend.
      ENDIF.

      IF ls_finished_pdata-timeend GT ls_shift-shift_end.
        t1 = ls_shift-shift_start.
        t2 = ls_shift-shift_end.
      ENDIF.

      CALL FUNCTION 'SCOV_TIME_DIFF'
        EXPORTING
          im_date1              = gv_datum
          im_date2              = gv_datum
          im_time1              = t1
          im_time2              = t2
        IMPORTING
          ex_days               = lv_days
          ex_time               = lv_time
        EXCEPTIONS
          start_larger_than_end = 1
          OTHERS                = 2.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.

      lv_stop_time = lv_stop_time + ( lv_days * 1440 ) + ( lv_time / 60 ). ">>minutes
      CLEAR: t1, t2, ls_finished_pdata.

    ENDLOOP.

    ls_sf053-stoptime = lv_stop_time.
    ls_sf053-stopunit = 'MIN'.
    ls_sf053-stprsnid = ls_sf011-stprsnid.

    IF ls_sf053-stoptime IS NOT INITIAL.
      APPEND ls_sf053 TO gt_stops.
    ENDIF.

    CLEAR: ls_sf011, lv_stop_time.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA_STOPS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data_stops .


*Get stop time of day for workcenter
  SELECT *
    FROM zabsf_pp010
    INTO TABLE gt_sf010
     WHERE werks  EQ pa_werks
     AND datesr   IN gr_dates.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_QTT_BY_SCHEDULE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LS_AUX_AREAID  text
*      -->P_LS_AUX_HNAME  text
*      -->P_LS_AUX_WERKS  text
*      -->P_LS_AUX_ARBPL  text
*      -->P_LS_AUX_SHIFTID  text
*      -->P_LS_AUX_DATA  text
*      -->P_LS_AUX_WEEK  text
*----------------------------------------------------------------------*
FORM get_qtt_by_schedule  USING    p_areaid
                                   p_hname
                                   p_werks
                                   p_arbpl
                                   p_shiftid
                                   p_data
                                   p_week.

  CONSTANTS: c_sec_day TYPE kapbegzt VALUE '86400',
             c_day     TYPE t VALUE '240000'.

  DATA: lv_kapid        TYPE kapid,
        ld_worktime     TYPE mengv13,
        ld_capacity     TYPE kapazitaet,
        ld_einzt        TYPE kapeinzt,
        ls_sf073        TYPE zabsf_pp073,
        ls_shift        TYPE zabsf_pp001,
        ld_shift_wktime TYPE mengv13,
        lv_shift_pause  TYPE mengv13,
        lv_parva        TYPE xuvalue.

  DATA: ls_afru        TYPE afru,
        ls_kako        TYPE kako,
        ls_workcenters LIKE LINE OF gt_workcenters,
        lt_prdord      TYPE TABLE OF ty_prdord.


  DATA: lv_prod_time TYPE zabsf_pp_e_prodtime,
        lv_days      TYPE i,
        lv_time      TYPE cva_time.

  DATA: lv_wc_begzt  TYPE kapbegzeit,
        lv_shift_beg TYPE kapbegzeit,
        lv_shift_end TYPE kapendzeit,
        lv_wc_endzt  TYPE kapendzeit,
        lv_ini_time  TYPE kapbegzeit,
        lv_fini_time TYPE kapendzeit,
        lv_ini_date  TYPE datum,
        lv_fini_date TYPE datum.

  DATA: lv_schedule_qt TYPE gamng,
        lv_menge       TYPE bstmg.

  FIELD-SYMBOLS:<fs_prdord> TYPE ty_prdord,
                <fs_sf073>  TYPE zabsf_pp073.

  ls_sf073-areaid = p_areaid.
  ls_sf073-hname = p_hname.
  ls_sf073-werks = p_werks.
  ls_sf073-arbpl = p_arbpl.
  ls_sf073-shiftid = p_shiftid.
  ls_sf073-data = p_data.
  ls_sf073-week = p_week.

  APPEND ls_sf073 TO gt_qtt_schedule.

* get shift information
  SELECT SINGLE * FROM zabsf_pp001 INTO ls_shift
    WHERE areaid EQ p_areaid
    AND shiftid EQ p_shiftid
    AND werks EQ p_werks
    AND begda  LE p_data
    AND endda  GE p_data.

  IF sy-subrc EQ 0.

    SELECT SINGLE parva FROM zabsf_pp032 INTO lv_parva
      WHERE werks = p_werks
      AND parid = 'SHIFT_PAUSE'.

    MOVE lv_parva TO lv_shift_pause.

    READ TABLE gt_workcenters INTO ls_workcenters WITH KEY arbpl = p_arbpl.
    IF sy-subrc EQ 0.

*Get all orders in workcenter with sechedule operations
      SELECT aufk~aufnr aufk~objnr aufk~auart afko~gstrp afko~gltrp afko~gstrs afko~gsuzs afko~gltrs
             afko~ftrmi afko~gmein afko~plnbez afko~plnty afko~plnnr afko~stlbez
             afko~aufpl afko~trmdt afvc~aplzl afvc~vornr afvc~ltxa1 afvc~steus afvc~rueck
             afvc~rmzhl afvc~zerma afvv~fsavd afvv~fsavz afvv~sssld afvv~ssslz afvv~mgvrg afvv~meinh
             afvv~vgw01 afvv~vge01 afvv~vgw02 afvv~vge02 afvv~vgw03 afvv~vge03 afvv~bmsch t430~autwe
        INTO CORRESPONDING FIELDS OF TABLE lt_prdord
        FROM afvc AS afvc
        INNER JOIN afvv AS afvv
          ON afvv~aufpl EQ afvc~aufpl
         AND afvv~aplzl EQ afvc~aplzl
       INNER JOIN t430 AS t430
          ON t430~steus EQ afvc~steus
         AND t430~ruek EQ '1'
       INNER JOIN afko AS afko
          ON afko~aufpl EQ afvc~aufpl
       INNER JOIN aufk AS aufk
          ON afko~aufnr EQ aufk~aufnr
       INNER JOIN jest AS jest
          ON jest~objnr EQ aufk~objnr
         AND jest~stat  EQ 'I0002'
         AND jest~inact EQ space
       WHERE afvc~arbid EQ ls_workcenters-objid
        AND t430~term EQ abap_true "programadas
         AND ( afvv~fsavd LE p_data AND
               afvv~sssld GE p_data ).

      IF lt_prdord IS NOT INITIAL.

*Get ID capacity
        SELECT SINGLE kapid
          FROM crhd
          INTO lv_kapid
         WHERE arbpl EQ p_arbpl
           AND werks EQ p_werks.

*Get capacity detail
        SELECT SINGLE *
          FROM kako
          INTO CORRESPONDING FIELDS OF ls_kako
         WHERE kapid EQ lv_kapid
          AND kapar EQ '001'.

        CHECK sy-subrc EQ 0.

*      IF ls_kako-begzt GT 0 OR ls_kako-endzt GT 0.
**  Capacity - Time
*        IF ls_kako-endzt GE ls_kako-begzt.
*          ld_capacity = ls_kako-endzt - ls_kako-begzt.
*
*          IF ld_capacity = 0.
*            ld_capacity = c_sec_day.
*          ENDIF.
*        ELSE.
*          ld_capacity = c_sec_day - ls_kako-begzt + ls_kako-endzt.
*        ENDIF.
*
*        IF ld_capacity GT ls_kako-pause.
**    Worktime
*          ld_einzt = ( ld_capacity - ls_kako-pause ) * ls_kako-ngrad / 100.
*
*          ld_einzt = ld_einzt * 1. "* ls_kako-aznor.
*
*          ld_worktime = ld_einzt / 60.
*        ELSE.
*          ld_worktime = 0.
*        ENDIF.
*      ENDIF.
*
* copy from standard program  SAPLCRK0
        lv_wc_begzt = ls_kako-begzt.
        IF ls_kako-endzt = c_sec_day.
          lv_wc_endzt = c_day.
        ELSE.
          lv_wc_endzt = ls_kako-endzt.
        ENDIF.


* Adjust ld_worktime according to shift time and workcenter schedule.
*    IF ls_shift-shift_start GE lv_wc_begzt.
*
*      lv_shift_beg = ls_shift-shift_start.
*    ENDIF.
*
*    IF ls_shift-shift_end LE lv_wc_endzt.
*
*      lv_shift_end = ls_shift-shift_end.
*    ENDIF.
*
*    IF ls_shift-shift_start LT lv_wc_begzt AND ls_shift-shift_end GE lv_wc_endzt.
*
*      lv_shift_beg = lv_wc_begzt.
*      lv_shift_end = lv_wc_endzt.
*    ENDIF.
*
*    IF ls_shift-shift_start LE lv_wc_endzt AND ls_shift-shift_end GT lv_wc_endzt.
*
*      lv_shift_beg = ls_shift-shift_start.
*      lv_shift_end = lv_wc_endzt.
*    ENDIF.

* Adjust e_shift_wktime according to shift time and workcenter schedule.
        CHECK ls_shift-shift_end GE lv_wc_begzt.

*1) "inside schedule
        IF ls_shift-shift_start GE lv_wc_begzt AND ls_shift-shift_end LE lv_wc_endzt.

          lv_shift_beg = ls_shift-shift_start.
          lv_shift_end = ls_shift-shift_end.
        ELSE.
*2) outter schedule
          IF ls_shift-shift_start LT lv_wc_begzt AND ls_shift-shift_end GE lv_wc_endzt.

            lv_shift_beg = lv_wc_begzt.
            lv_shift_end = lv_wc_endzt.
          ELSE.

*3)  starting before schedule
            IF ls_shift-shift_start LT lv_wc_begzt.

              lv_shift_beg = lv_wc_begzt.
              lv_shift_end = ls_shift-shift_end.
            ENDIF.

*4)  finishing after schedule
            IF ls_shift-shift_end GE lv_wc_endzt.

              lv_shift_beg = ls_shift-shift_start.
              lv_shift_end = lv_wc_endzt.
            ENDIF.

          ENDIF.
        ENDIF.
      ENDIF.

      CALL FUNCTION 'SCOV_TIME_DIFF'
        EXPORTING
          im_date1              = gv_datum
          im_date2              = gv_datum
          im_time1              = lv_shift_beg
          im_time2              = lv_shift_end
        IMPORTING
          ex_days               = lv_days
          ex_time               = lv_time
        EXCEPTIONS
          start_larger_than_end = 1
          OTHERS                = 2.
      IF sy-subrc <> 0.
      ENDIF.

      ld_shift_wktime = ( lv_days * 1440 ) + ( lv_time / 60 ). ">>minutes

      ld_shift_wktime = ld_shift_wktime - lv_shift_pause.

      CHECK ld_shift_wktime GT 0.

*  Calculate qtty for each row.
      LOOP AT lt_prdord ASSIGNING <fs_prdord>.

        IF <fs_prdord>-vgw02 IS INITIAL.
          IF <fs_prdord>-vgw01 IS NOT INITIAL.
            <fs_prdord>-vgw02 = <fs_prdord>-vgw01.
            <fs_prdord>-vge02 = <fs_prdord>-vge01.
          ELSEIF <fs_prdord>-vgw03 IS NOT INITIAL.
            <fs_prdord>-vgw02 = <fs_prdord>-vgw03.
            <fs_prdord>-vge02 = <fs_prdord>-vge03.
          ENDIF.
        ENDIF.
* convert to minutes.
        CALL FUNCTION 'UNIT_CONVERSION_SIMPLE'
          EXPORTING
            input    = <fs_prdord>-vgw02
            unit_in  = <fs_prdord>-vge02
            unit_out = 'MIN'
          IMPORTING
            output   = <fs_prdord>-vgw02.
        IF sy-subrc <> 0.
        ENDIF.

        "1) All shift working!
        IF <fs_prdord>-fsavd LT p_data AND <fs_prdord>-sssld GT p_data.

          IF <fs_prdord>-vgw02 IS NOT INITIAL.

            <fs_prdord>-gamng = ( ld_shift_wktime / <fs_prdord>-vgw02 ) * <fs_prdord>-bmsch.
          ENDIF.

        ENDIF.

        "2) Started and finished on p_data
        IF <fs_prdord>-fsavd EQ p_data AND <fs_prdord>-sssld EQ p_data.

          CHECK <fs_prdord>-fsavz LT lv_shift_end.

          IF <fs_prdord>-fsavz GE lv_shift_beg.
            lv_ini_time = <fs_prdord>-fsavz.
          ELSE.
            lv_ini_time = lv_shift_beg.
          ENDIF.

          IF <fs_prdord>-ssslz LE lv_shift_end.
            lv_fini_time = <fs_prdord>-ssslz.
          ELSE.
            lv_fini_time = lv_shift_end.
          ENDIF.

          lv_ini_date = <fs_prdord>-fsavd.
          lv_fini_date = <fs_prdord>-sssld.

        ENDIF.

*     3) started yesterday and finished on p_data
        IF <fs_prdord>-fsavd LT p_data AND <fs_prdord>-sssld EQ p_data.

          CHECK <fs_prdord>-ssslz GT lv_shift_beg.

          lv_fini_date = <fs_prdord>-sssld.
          lv_ini_date = <fs_prdord>-sssld.
          lv_ini_time = lv_shift_beg.

          IF <fs_prdord>-ssslz GE lv_shift_end.
            lv_fini_time = lv_shift_end.
          ELSE.
            lv_fini_time = <fs_prdord>-ssslz.
          ENDIF.
        ENDIF.

*     4) started today but not finished today
        IF <fs_prdord>-fsavd EQ p_data AND <fs_prdord>-sssld GT p_data.

          CHECK <fs_prdord>-fsavz LT lv_shift_end.

          lv_fini_date = <fs_prdord>-fsavd.
          lv_ini_date = <fs_prdord>-fsavd.
          lv_fini_time = lv_shift_end.

          IF <fs_prdord>-fsavz GE lv_shift_beg.
            lv_ini_time = <fs_prdord>-fsavz.
          ELSE.
            lv_ini_time = lv_shift_beg.
          ENDIF.

        ENDIF.

* calculate duration.
        CALL FUNCTION 'SCOV_TIME_DIFF'
          EXPORTING
            im_date1              = lv_ini_date
            im_date2              = lv_fini_date
            im_time1              = lv_ini_time
            im_time2              = lv_fini_time
          IMPORTING
            ex_days               = lv_days
            ex_time               = lv_time
          EXCEPTIONS
            start_larger_than_end = 1
            OTHERS                = 2.

        IF sy-subrc <> 0.
* Implement suitable error handling here
        ENDIF.

        lv_prod_time = ( lv_days * 1440 ) + ( lv_time / 60 ). ">>minutes

        IF <fs_prdord>-vgw02 IS NOT INITIAL.

          <fs_prdord>-gamng = ( lv_prod_time / <fs_prdord>-vgw02 ) * <fs_prdord>-bmsch.

          IF <fs_prdord>-meinh = 'KG'.
          ELSE.
            CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
              EXPORTING
                i_matnr              = <fs_prdord>-plnbez
                i_in_me              = <fs_prdord>-meinh
                i_out_me             = 'KG'
                i_menge              = <fs_prdord>-gamng
              IMPORTING
                e_menge              = lv_menge
              EXCEPTIONS
                error_in_application = 1
                error                = 2
                OTHERS               = 3.
            IF sy-subrc <> 0.
* Implement suitable error handling here
            ELSE.
              <fs_prdord>-gamng = lv_menge.
            ENDIF.

          ENDIF.
        ELSE.
          <fs_prdord>-gamng = 0.
        ENDIF.

        lv_schedule_qt = lv_schedule_qt + <fs_prdord>-gamng.

        CLEAR: lv_prod_time, lv_prod_time, lv_days, lv_time.
      ENDLOOP.

      ls_sf073-qtt_schedule = lv_schedule_qt.

      LOOP AT gt_qtt_schedule ASSIGNING <fs_sf073>
        WHERE areaid = p_areaid
        AND hname = p_hname
        AND werks = p_werks
        AND arbpl = p_arbpl
        AND shiftid = p_shiftid
        AND data = p_data
        AND week = p_week.

        <fs_sf073>-qtt_schedule = ls_sf073-qtt_schedule.
      ENDLOOP.

    ENDIF.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_TOTAL_PRODUCTIVE_TIME
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_<FS_QTD>_AREAID  text
*      -->P_<FS_QTD>_HNAME  text
*      -->P_<FS_QTD>_WERKS  text
*      -->P_<FS_QTD>_ARBPL  text
*      -->P_<FS_QTD>_SHIFTID  text
*      -->P_<FS_QTD>_DATA  text
*      -->P_<FS_QTD>_WEEK  text
*----------------------------------------------------------------------*
FORM get_total_productive_time  USING    p_areaid
                                         p_hname
                                         p_werks
                                         p_arbpl
                                         p_shiftid
                                         p_data
                                         p_week.

  DATA: ls_workcenter LIKE LINE OF gt_workcenters,
        ls_kako       TYPE kako,
        ls_sf001      TYPE zabsf_pp001,
        lv_capacity   TYPE mengv13,
        ls_sf074      TYPE zabsf_pp074.


  ls_sf074-areaid = p_areaid.
  ls_sf074-hname = p_hname.
  ls_sf074-werks = p_werks.
  ls_sf074-arbpl = p_arbpl.
  ls_sf074-shiftid = p_shiftid.
  ls_sf074-data = p_data.
  ls_sf074-week = p_week.
  ls_sf074-produnit = 'MIN'.

*get workcenters objid
  READ TABLE gt_workcenters INTO ls_workcenter WITH KEY arbpl = p_arbpl.

  IF sy-subrc EQ 0.
*Get capacity detail
    SELECT SINGLE *
      FROM kako
      INTO CORRESPONDING FIELDS OF ls_kako
     WHERE kapid EQ ls_workcenter-kapid
      AND kapar EQ '001'.

    SELECT SINGLE * FROM zabsf_pp001 INTO ls_sf001
        WHERE areaid EQ p_areaid
        AND werks EQ p_werks
        AND shiftid EQ p_shiftid
        AND begda  LE p_data
        AND endda  GE p_data.

    IF sy-subrc EQ 0.

      PERFORM adjust_time_interval USING ls_kako
                                         ls_sf001
                                CHANGING lv_capacity.

      ls_sf074-prodtime = lv_capacity.

    ENDIF.
  ENDIF.

  APPEND ls_sf074 TO gt_util_time.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ADJUST_TIME_INTERVAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LS_KAKO  text
*      -->P_LS_SF011  text
*----------------------------------------------------------------------*
FORM adjust_time_interval  USING    is_kako  TYPE kako
                                    is_shift TYPE zabsf_pp001
                           CHANGING  e_shift_wktime TYPE mengv13.


  CONSTANTS: c_sec_day TYPE kapbegzt VALUE '86400',
             c_day     TYPE t VALUE '240000'.

  DATA: lv_wc_begzt  TYPE kapbegzeit,
        lv_shift_beg TYPE kapbegzeit,
        lv_shift_end TYPE kapendzeit,
        lv_wc_endzt  TYPE kapendzeit,
        lv_days      TYPE i,
        lv_time      TYPE cva_time,
        lv_parva     TYPE xuvalue,
        lv_pause     TYPE mengv13.

  DATA: d1 TYPE cva_date.

  SELECT SINGLE parva INTO lv_parva FROM zabsf_pp032
    WHERE werks = pa_werks
    AND parid = 'SHIFT_PAUSE'.

  MOVE lv_parva TO lv_pause.

  lv_wc_begzt  = is_kako-begzt.
  IF is_kako-endzt = c_sec_day.
    lv_wc_endzt = c_day.
  ELSE.
    lv_wc_endzt = is_kako-endzt.
  ENDIF.

* Adjust e_shift_wktime according to shift time and workcenter schedule.

  IF lv_wc_endzt GT lv_wc_begzt.

    CHECK is_shift-shift_end GE lv_wc_begzt.

*1) "inside schedule
    IF is_shift-shift_start GE lv_wc_begzt AND is_shift-shift_end LE lv_wc_endzt.

      lv_shift_beg = is_shift-shift_start.
      lv_shift_end = is_shift-shift_end.
    ELSE.
*2) outter schedule
      IF is_shift-shift_start LT lv_wc_begzt AND is_shift-shift_end GE lv_wc_endzt.

        lv_shift_beg = lv_wc_begzt.
        lv_shift_end = lv_wc_endzt.
      ELSE.

*3)  starting before schedule
        IF is_shift-shift_start LT lv_wc_begzt.

          lv_shift_beg = lv_wc_begzt.
          lv_shift_end = is_shift-shift_end.
        ENDIF.

*4)  finishing after schedule
        IF is_shift-shift_end GE lv_wc_endzt.

          lv_shift_beg = is_shift-shift_start.
          lv_shift_end = lv_wc_endzt.
        ENDIF.

      ENDIF.
    ENDIF.


    CALL FUNCTION 'SCOV_TIME_DIFF'
      EXPORTING
        im_date1              = d1
        im_date2              = d1
        im_time1              = lv_shift_beg
        im_time2              = lv_shift_end
      IMPORTING
        ex_days               = lv_days
        ex_time               = lv_time
      EXCEPTIONS
        start_larger_than_end = 1
        OTHERS                = 2.
    IF sy-subrc <> 0.
    ENDIF.

    e_shift_wktime = ( lv_days * 1440 ) + ( lv_time / 60 ). ">>minutes
    e_shift_wktime = is_kako-aznor * e_shift_wktime. "multiply by capacity

    lv_pause = is_kako-aznor * lv_pause.
    e_shift_wktime = e_shift_wktime - lv_pause.

    IF e_shift_wktime LT 0.

      e_shift_wktime = 0.
    ENDIF.

  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- GS_LINES
*&---------------------------------------------------------------------*
FORM convert_un USING p_matnr p_vrkme p_lfimg CHANGING p_afru TYPE afru.
  DATA: lv_qty_out TYPE bstmg,
        lv_un_out  TYPE lrmei.

  DATA: lv_vrkme      TYPE vrkme,
        lv_/cwm/lfime TYPE /cwm/lfime.

  lv_un_out = 'KG'.

  CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
    EXPORTING
      i_matnr              = p_matnr
      i_in_me              = p_vrkme
      i_out_me             = lv_un_out
      i_menge              = p_lfimg
    IMPORTING
      e_menge              = lv_qty_out
    EXCEPTIONS
      error_in_application = 1
      error                = 2
      OTHERS               = 3.

ENDFORM.
