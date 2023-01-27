*----------------------------------------------------------------------*
***INCLUDE Z_LP_PP_SF_REPORT_STOP_F01.
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
           it_stprs,
           it_shift,
           gt_stop,
           gt_stop_alv,
           gt_error.

  CLEAR: gv_stoptime,
         gv_stopunit,
         gs_stop,
         gs_stop_alv.

ENDFORM.                    " INIT_VARIABLES
*&---------------------------------------------------------------------*
*&      Form  CREATE_F4_FIELD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_C_AREA  text
*      -->P_C_VORG  text
*      -->P_PA_AREA  text
*      -->P_IT_AREA  text
*----------------------------------------------------------------------*
FORM create_f4_field USING p_retfield p_val_org p_dyn_field so_option p_it TYPE STANDARD TABLE.

  DATA: it_return TYPE TABLE OF ddshretval,
        wa_return TYPE ddshretval.

  REFRESH it_return.
  CLEAR wa_return.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = p_retfield
      value_org       = p_val_org
      dynpprog        = sy-cprog
      dynpnr          = sy-dynnr
      dynprofield     = p_dyn_field
    TABLES
      value_tab       = p_it
      return_tab      = it_return
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.

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
*      -->P_SO_HNAME  text
*      -->P_PA_WERKS  text
*      <--P_IT_ARBPL  text
*----------------------------------------------------------------------*
FORM get_workcenters  TABLES p_hname STRUCTURE so_hname
                       USING p_area p_werks
                    CHANGING p_it TYPE STANDARD TABLE.

  DATA: lt_crhs        TYPE TABLE OF crhs,
        it_aux         TYPE TABLE OF ty_arbpl,
        lt_zabsf_pp002 TYPE TABLE OF zabsf_pp002,
        ls_zabsf_pp002 TYPE zabsf_pp002,
        wa_hname       TYPE cr_hname,
        l_hrchy_objid  TYPE cr_objid.

  IF p_hname[] IS NOT INITIAL.
    LOOP AT p_hname INTO wa_hname.
*    Get workcenter for Hierarchy
      PERFORM get_workcenters_table USING wa_hname p_werks CHANGING it_aux.

      IF it_aux[] IS NOT INITIAL.
        APPEND LINES OF it_aux TO p_it.
      ENDIF.
    ENDLOOP.
  ELSE.
*  Get all hierarchies for area
    SELECT hname
      FROM zabsf_pp002
      INTO CORRESPONDING FIELDS OF TABLE lt_zabsf_pp002
     WHERE areaid EQ p_area
       AND werks  EQ p_werks.

    SORT lt_zabsf_pp002 BY hname.

    DELETE ADJACENT DUPLICATES FROM lt_zabsf_pp002.

    LOOP AT lt_zabsf_pp002 INTO ls_zabsf_pp002.
*    Get workcenter for Hierarchy
      PERFORM get_workcenters_table USING ls_zabsf_pp002-hname p_werks CHANGING it_aux.

      IF it_aux[] IS NOT INITIAL.
        APPEND LINES OF it_aux TO p_it.
      ENDIF.
    ENDLOOP.

**  Get workcenter ID and description
*    SELECT crhd~arbpl crtx~ktext
*      INTO CORRESPONDING FIELDS OF TABLE p_it
*      FROM crhd INNER JOIN crtx
*        ON crtx~objty EQ crhd~objty
*       AND crtx~objid EQ crhd~objid
*      FOR ALL ENTRIES IN lt_ZABSF_PP002
*     WHERE crhd~werks EQ p_werks
*       AND crhd~objty EQ 'A'
*       AND crtx~spras EQ sy-langu.
  ENDIF.
ENDFORM.                    " GET_WORKCENTERS
*&---------------------------------------------------------------------*
*&      Form  GET_WORKCENTERS_TABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_WA_HNAME  text
*      -->P_P_WERKS  text
*      <--P_IT_AUX  text
*----------------------------------------------------------------------*
FORM get_workcenters_table USING    p_wa_hname p_werks
                           CHANGING p_it_aux TYPE STANDARD TABLE.

  DATA: lt_crhs       TYPE TABLE OF crhs,
        l_hrchy_objid TYPE cr_objid.

  REFRESH lt_crhs.

  CLEAR l_hrchy_objid.

*Get Hierarchy Object ID
  CALL FUNCTION 'CR_HIERARCHY_READ_NAME'
    EXPORTING
      name                = p_wa_hname
      werks               = p_werks
    IMPORTING
      objid               = l_hrchy_objid
    EXCEPTIONS
      hierarchy_not_found = 1
      OTHERS              = 2.

  IF sy-subrc = 0.
*  Get hierarchy object relations
    CALL FUNCTION 'CR_HIERARCHY_OBJECTS'
      EXPORTING
        objid               = l_hrchy_objid
      TABLES
        t_crhs              = lt_crhs
      EXCEPTIONS
        hierarchy_not_found = 1
        OTHERS              = 2.

    IF sy-subrc = 0.
*    Get workcenter ID and description
      SELECT crhd~arbpl crtx~ktext
        INTO CORRESPONDING FIELDS OF TABLE p_it_aux
        FROM crhd INNER JOIN crtx
          ON crtx~objty EQ crhd~objty
         AND crtx~objid EQ crhd~objid
         FOR ALL ENTRIES IN lt_crhs
       WHERE crhd~objty EQ lt_crhs-objty_ho
         AND crhd~objid EQ lt_crhs-objid_ho
         AND crtx~spras EQ sy-langu.
    ENDIF.
  ENDIF.
ENDFORM.                    " GET_WORKCENTERS_TABLE
*&---------------------------------------------------------------------*
*&      Form  GET_STOP_REASON
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_SO_HNAME  text
*      -->P_SO_ARBPL  text
*      -->P_PA_AREA  text
*      -->P_PA_WERKS  text
*      <--P_IT_STPRS  text
*----------------------------------------------------------------------*
FORM get_stop_reason  TABLES   p_hname STRUCTURE so_hname
                               p_arbpl STRUCTURE so_arbpl
                      USING    p_area
                               p_werks
                      CHANGING p_it_aux TYPE STANDARD TABLE.

  DATA: lt_arbpl TYPE TABLE OF ty_arbpl.

  IF p_arbpl IS INITIAL.
*  Get workceter
    PERFORM get_workcenters TABLES p_hname USING p_area p_werks CHANGING lt_arbpl.

    SORT lt_arbpl BY arbpl.

    DELETE ADJACENT DUPLICATES FROM lt_arbpl.

*  Get stop reason id and description
    SELECT *
      INTO CORRESPONDING FIELDS OF TABLE p_it_aux
      FROM zabsf_pp011 AS zabsf_pp011
     INNER JOIN zabsf_pp011_t AS zabsf_pp011_t
        ON zabsf_pp011_t~areaid   EQ zabsf_pp011~areaid
       AND zabsf_pp011_t~werks    EQ zabsf_pp011~werks
       AND zabsf_pp011_t~arbpl    EQ zabsf_pp011~arbpl
       AND zabsf_pp011_t~stprsnid EQ zabsf_pp011~stprsnid
       FOR ALL ENTRIES IN lt_arbpl
     WHERE zabsf_pp011~areaid EQ p_area
       AND zabsf_pp011~werks  EQ p_werks
       AND zabsf_pp011~arbpl  EQ lt_arbpl-arbpl.
  ELSE.
*  Get stop reason id and description
    SELECT *
      INTO CORRESPONDING FIELDS OF TABLE p_it_aux
      FROM zabsf_pp011 AS zabsf_pp011
     INNER JOIN zabsf_pp011_t AS zabsf_pp011_t
        ON zabsf_pp011_t~areaid   EQ zabsf_pp011~areaid
       AND zabsf_pp011_t~werks    EQ zabsf_pp011~werks
       AND zabsf_pp011_t~arbpl    EQ zabsf_pp011~arbpl
       AND zabsf_pp011_t~stprsnid EQ zabsf_pp011~stprsnid
     WHERE zabsf_pp011~areaid EQ p_area
       AND zabsf_pp011~werks  EQ p_werks
       AND zabsf_pp011~arbpl  IN p_arbpl.
  ENDIF.
ENDFORM.                    " GET_STOP_REASON
*&---------------------------------------------------------------------*
*&      Form  CHECK_SO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_PA_AREA  text
*      -->P_PA_WERKS  text
*----------------------------------------------------------------------*
FORM check_so USING p_areaid p_werks p_data.

  DATA: lt_zabsf_pp001 TYPE TABLE OF zabsf_pp001,
        lt_zabsf_pp002 TYPE TABLE OF zabsf_pp002,
        lt_zabsf_pp011 TYPE TABLE OF zabsf_pp011,
        lt_arbpl       TYPE TABLE OF ty_arbpl.

  DATA: wa_zabsf_pp001 TYPE zabsf_pp001,
        wa_zabsf_pp002 TYPE zabsf_pp002,
        wa_zabsf_pp011 TYPE zabsf_pp011,
        wa_arbpl       TYPE ty_arbpl,
        ls_hname       LIKE LINE OF so_hname,
        ls_arbpl       LIKE LINE OF so_arbpl,
        ls_shift       LIKE LINE OF so_shift,
        ls_stprs       LIKE LINE OF so_stprs.

  REFRESH: lt_zabsf_pp001,
           lt_zabsf_pp002,
           lt_zabsf_pp011,
           lt_arbpl.

  CLEAR: wa_zabsf_pp001,
         wa_zabsf_pp002,
         wa_zabsf_pp011,
         wa_arbpl,
         ls_hname,
         ls_arbpl,
         ls_shift,
         ls_stprs.

*Send error message
  IF so_hname[] IS INITIAL AND so_arbpl[] IS NOT INITIAL.
*  Fill missing parameter
*    MESSAGE i053(zabsf_pp).
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'I'
        msgno      = '053'
      CHANGING
        return_tab = gt_error.
    EXIT.
  ENDIF.

*Check if parameter Hierarchy is not initial
  IF so_hname[] IS INITIAL.
*  Get all hierarchies for area
    SELECT *
      FROM zabsf_pp002
      INTO CORRESPONDING FIELDS OF TABLE lt_zabsf_pp002
     WHERE areaid EQ p_areaid
       AND werks  EQ p_werks
       AND begda  LE p_data
       AND endda  GE p_data.

    LOOP AT lt_zabsf_pp002 INTO wa_zabsf_pp002.
      ls_hname-sign = 'I'.
      ls_hname-option = 'EQ'.
      ls_hname-low = wa_zabsf_pp002-hname.

      APPEND ls_hname TO so_hname.
    ENDLOOP.

    SORT so_hname.

    DELETE ADJACENT DUPLICATES FROM so_hname.
  ENDIF.

*Check if parameter Workcenter is not initial
  IF so_arbpl[] IS INITIAL.
    LOOP AT so_hname INTO ls_hname.
*    Get workcenter for hierarchy
      PERFORM get_workcenters_table USING ls_hname-low p_werks
                                    CHANGING lt_arbpl.

      LOOP AT lt_arbpl INTO wa_arbpl.
        ls_arbpl-sign = 'I'.
        ls_arbpl-option = 'EQ'.
        ls_arbpl-low = wa_arbpl-arbpl.

        APPEND ls_arbpl TO so_arbpl.
      ENDLOOP.
    ENDLOOP.

    SORT so_arbpl.

    DELETE ADJACENT DUPLICATES FROM so_arbpl.
  ENDIF.

*Check if parameter Shift is not initial
  IF so_shift[] IS INITIAL.
*  Get shifts for area
    SELECT *
      FROM zabsf_pp001
      INTO CORRESPONDING FIELDS OF TABLE lt_zabsf_pp001
     WHERE areaid EQ p_areaid
       AND werks EQ p_werks
       AND begda  LE p_data
       AND endda  GE p_data.

    LOOP AT lt_zabsf_pp001 INTO wa_zabsf_pp001.
      ls_shift-sign = 'I'.
      ls_shift-option = 'EQ'.
      ls_shift-low = wa_zabsf_pp001-shiftid.

      APPEND ls_shift TO so_shift.
    ENDLOOP.

    SORT so_shift.

    DELETE ADJACENT DUPLICATES FROM so_shift.
  ENDIF.

*Check if parameter OEE is not initial
  IF so_stprs[] IS INITIAL.
*  Get stop reasons
    SELECT *
      FROM zabsf_pp011
      INTO CORRESPONDING FIELDS OF TABLE lt_zabsf_pp011
     WHERE areaid EQ p_areaid
       AND werks  EQ p_werks
       AND arbpl  IN so_arbpl
       AND begda  LE p_data
       AND endda  GE p_data.

    LOOP AT lt_zabsf_pp011 INTO wa_zabsf_pp011.
      ls_stprs-sign = 'I'.
      ls_stprs-option = 'EQ'.
      ls_stprs-low = wa_zabsf_pp011-stprsnid.

      APPEND ls_stprs TO so_stprs.
    ENDLOOP.

    SORT so_stprs.

    DELETE ADJACENT DUPLICATES FROM so_stprs.
  ENDIF.
ENDFORM.                    " CHECK_SO
*&---------------------------------------------------------------------*
*&      Form  GET_STOP_TIME
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_<FS_STOP>_AREAID  text
*      -->P_<FS_STOP>_HNAME  text
*      -->P_<FS_STOP>_WERKS  text
*      -->P_<FS_STOP>_ARBPL  text
*      -->P_<FS_STOP>_STPRSNID  text
*      -->P_<FS_STOP>_SHIFTID  text
*      -->P_<FS_STOP>_DATA  text
*----------------------------------------------------------------------*
FORM get_stop_time USING p_areaid p_hname p_werks p_arbpl
                         p_stprsnid p_shiftid p_data
                   CHANGING p_stoptime p_stopunit.

*Get stop time of day for workcenter
  SELECT SUM( stoptime )
    FROM zabsf_pp010
    INTO p_stoptime
   WHERE areaid   EQ p_areaid
     AND hname    EQ p_hname
     AND werks    EQ p_werks
     AND arbpl    EQ p_arbpl
     AND stprsnid EQ p_stprsnid
     AND datesr   EQ p_data
     AND shiftid  EQ p_shiftid.

*Get unit time
  SELECT SINGLE stopunit
    FROM zabsf_pp010
    INTO p_stopunit
   WHERE areaid   EQ p_areaid
     AND hname    EQ p_hname
     AND werks    EQ p_werks
     AND arbpl    EQ p_arbpl
     AND stprsnid EQ p_stprsnid
     AND datesr   EQ p_data
     AND shiftid  EQ p_shiftid.
ENDFORM.                    " GET_STOP_TIME
*&---------------------------------------------------------------------*
*&      Form  GET_DATA_DB
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data_db .
  DATA: lt_zabsf_pp053 TYPE TABLE OF zabsf_pp053.

  DATA: ls_zabsf_pp053 TYPE zabsf_pp053.

  REFRESH lt_zabsf_pp053.

*Get all data saved in database
  SELECT *
    FROM zabsf_pp053
    INTO CORRESPONDING FIELDS OF TABLE lt_zabsf_pp053
    WHERE areaid   EQ pa_area
      AND hname    IN so_hname
      AND werks    EQ pa_werks
      AND arbpl    IN so_arbpl
      AND stprsnid IN so_stprs
      AND shiftid  IN so_shift
      AND data     IN so_date.

  IF lt_zabsf_pp053[] IS NOT INITIAL.
*  Pass data to global internal table
    gt_stop[] = lt_zabsf_pp053[].
  ELSE.
*    MESSAGE i018(zabsf_pp).

    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
*       msgid      = sy-msgid
        msgty      = 'I'
        msgno      = '018'
      CHANGING
        return_tab = gt_error.
    EXIT.
  ENDIF.
ENDFORM.                    " GET_DATA_DB
*&---------------------------------------------------------------------*
*&      Form  SHOW_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM show_data .
*Get data to alv
  PERFORM fill_data_alv.

  IF gt_stop_alv[] IS NOT INITIAL.
*  Show data
    CALL SCREEN 100.
  ENDIF.
ENDFORM.                    " SHOW_DATA
*&---------------------------------------------------------------------*
*&      Form  SAVE_DB
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM save_db .
  DATA: lt_zabsf_pp053 TYPE TABLE OF zabsf_pp053,
        lt_stprsn_desc TYPE TABLE OF zabsf_pp011_t.

  DATA: ls_zabsf_pp053 TYPE zabsf_pp053,
        ls_stprsn_desc TYPE zabsf_pp011_t,
        flag_error     TYPE c.

  REFRESH lt_zabsf_pp053.

*Get all data saved in database
  SELECT *
    FROM zabsf_pp053
    INTO CORRESPONDING FIELDS OF TABLE lt_zabsf_pp053
    WHERE areaid   EQ pa_area
      AND hname    IN so_hname
      AND werks    EQ pa_werks
      AND arbpl    IN so_arbpl
      AND stprsnid IN so_stprs
      AND shiftid  IN so_shift
      AND data     EQ pa_date.

*Get description for Stop Reason
  SELECT *
    FROM zabsf_pp011_t
    INTO CORRESPONDING FIELDS OF TABLE lt_stprsn_desc
     FOR ALL ENTRIES IN gt_stop
   WHERE stprsnid EQ gt_stop-stprsnid
     AND spras    EQ sy-langu.

  SORT lt_stprsn_desc BY stprsnid DESCENDING.

  DELETE ADJACENT DUPLICATES FROM lt_stprsn_desc.

  CLEAR: gs_stop,
         flag_error.

  LOOP AT gt_stop INTO gs_stop.
    CLEAR ls_zabsf_pp053.
*  Check if exist data saved in database
    READ TABLE lt_zabsf_pp053 INTO ls_zabsf_pp053 WITH KEY areaid   = gs_stop-areaid
                                                             hname    = gs_stop-hname
                                                             werks    = gs_stop-werks
                                                             arbpl    = gs_stop-arbpl
                                                             stprsnid = gs_stop-stprsnid
                                                             shiftid  = gs_stop-shiftid
                                                             data     = gs_stop-data.

    IF sy-subrc EQ 0.
*    Update value OEE with new value
      ls_zabsf_pp053-stoptime = gs_stop-stoptime.

      UPDATE zabsf_pp053 FROM ls_zabsf_pp053.

      IF sy-subrc NE 0.
        flag_error = 'X'.
*      Data not saved successfully in database
        MESSAGE e058(zabsf_pp).
        EXIT.
      ENDIF.
    ELSE.
      READ TABLE lt_stprsn_desc INTO ls_stprsn_desc WITH KEY stprsnid = gs_stop-stprsnid.

      IF sy-subrc EQ 0.
        " gs_stop-stprsn_desc = ls_stprsn_desc-stprsn_desc.
      ENDIF.

*    Insert new line in database
      INSERT INTO zabsf_pp053 VALUES gs_stop.

      IF sy-subrc NE 0.
        flag_error = 'X'.
*      Data not saved successfully in database
        MESSAGE e058(zabsf_pp).
        EXIT.
      ENDIF.
    ENDIF.
  ENDLOOP.

  IF flag_error IS INITIAL.
*  Data saved successfully in database
    MESSAGE s057(zabsf_pp).
  ENDIF.
ENDFORM.                    " SAVE_DB
*&---------------------------------------------------------------------*
*&      Form  FILL_DATA_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fill_data_alv .
*Types for Hierarchy
  TYPES: BEGIN OF ty_hname_desc,
           objid TYPE cr_objid,
           name  TYPE cr_hname,
           ktext TYPE cr_ktext,
         END OF ty_hname_desc.

*Types for Workcenter
  TYPES: BEGIN OF ty_arbpl_desc,
           objid TYPE cr_objid,
           arbpl TYPE arbpl,
           ktext TYPE cr_ktext,
         END OF ty_arbpl_desc.

*Types for totals
  TYPES: BEGIN OF ty_total,
           areaid   TYPE zabsf_pp_e_areaid,
           hname    TYPE cr_hname,
           werks    TYPE werks_d,
           arbpl    TYPE arbpl,
           stprsnid TYPE zabsf_pp_e_stprsnid,
           shiftid  TYPE zabsf_pp_e_shiftid,
           week     TYPE kweek,
           total    TYPE zabsf_pp_e_tweek,
         END OF ty_total.

  DATA: lt_stop_alv    TYPE TABLE OF zabsf_pp_s_data_alv,
        lt_area_desc   TYPE TABLE OF zabsf_pp000_t,
        lt_hname_desc  TYPE TABLE OF ty_hname_desc,
        lt_werks_desc  TYPE TABLE OF t001w,
        lt_arbpl_desc  TYPE TABLE OF ty_arbpl_desc,
        lt_shift_desc  TYPE TABLE OF zabsf_pp001_t,
        lt_stprsn_desc TYPE TABLE OF zabsf_pp011_t,
        lt_total       TYPE TABLE OF ty_total.

  DATA: ls_stop_alv    TYPE zabsf_pp_s_data_alv,
        ls_area_desc   TYPE zabsf_pp000_t,
        ls_hname_desc  TYPE ty_hname_desc,
        ls_werks_desc  TYPE t001w,
        ls_arbpl_desc  TYPE ty_arbpl_desc,
        ls_shift_desc  TYPE zabsf_pp001_t,
        ls_stprsn_desc TYPE zabsf_pp011_t,
        ls_total       TYPE ty_total,
        ld_day         TYPE scal-indicator.

  REFRESH: lt_area_desc,
           lt_hname_desc,
           lt_werks_desc,
           lt_arbpl_desc,
           lt_shift_desc,
           lt_stprsn_desc,
           lt_total.
*
  CLEAR: ls_stop_alv,
         gs_stop.

*Get data to get description
  LOOP AT gt_stop INTO gs_stop.
    CLEAR ls_stop_alv.
    MOVE-CORRESPONDING gs_stop TO ls_stop_alv.

    APPEND ls_stop_alv TO lt_stop_alv.
  ENDLOOP.

  DELETE ADJACENT DUPLICATES FROM lt_stop_alv.

*Get description for Area
  SELECT *
    FROM zabsf_pp000_t
    INTO CORRESPONDING FIELDS OF TABLE lt_area_desc
     FOR ALL ENTRIES IN lt_stop_alv
   WHERE areaid EQ lt_stop_alv-areaid
     AND spras EQ sy-langu.

*Get description for Hierarchy
  SELECT crhh~objid crhh~name crtx~ktext
    INTO CORRESPONDING FIELDS OF TABLE lt_hname_desc
    FROM crtx AS crtx
   INNER JOIN crhh AS crhh
      ON crhh~objty EQ crtx~objty
     AND crhh~objid EQ crtx~objid
     FOR ALL ENTRIES IN lt_stop_alv
   WHERE crhh~name  EQ lt_stop_alv-hname
     AND crhh~objty EQ 'H'
     AND crhh~werks EQ lt_stop_alv-werks
     AND crtx~spras EQ sy-langu.

*Get description for Plant
  SELECT *
    FROM t001w
    INTO CORRESPONDING FIELDS OF TABLE lt_werks_desc
     FOR ALL ENTRIES IN lt_stop_alv
   WHERE werks EQ lt_stop_alv-werks
     AND spras EQ sy-langu.

*Get description for Workcenter
  SELECT crhd~objid crhd~arbpl crtx~ktext
    INTO CORRESPONDING FIELDS OF TABLE lt_arbpl_desc
    FROM crtx AS crtx
   INNER JOIN crhd AS crhd
      ON crhd~objty EQ crtx~objty
     AND crhd~objid EQ crtx~objid
     FOR ALL ENTRIES IN lt_stop_alv
   WHERE crhd~arbpl EQ lt_stop_alv-arbpl
     AND crhd~objty EQ 'A'
     AND crhd~werks EQ lt_stop_alv-werks
     AND crtx~spras EQ sy-langu.

*Get description for Stop Reason
  SELECT *
    FROM zabsf_pp011_t
    INTO CORRESPONDING FIELDS OF TABLE lt_stprsn_desc
     FOR ALL ENTRIES IN lt_stop_alv
   WHERE stprsnid EQ lt_stop_alv-stprsnid
     AND spras    EQ sy-langu.

*Get description for Shift
  SELECT *
    FROM zabsf_pp001_t
    INTO CORRESPONDING FIELDS OF TABLE lt_shift_desc
     FOR ALL ENTRIES IN lt_stop_alv
   WHERE areaid  EQ lt_stop_alv-areaid
     AND werks   EQ lt_stop_alv-werks
     AND shiftid EQ lt_stop_alv-shiftid
     AND spras   EQ sy-langu.

*Get total week for Stop Reason
  LOOP AT gt_stop INTO gs_stop.
*  Total indicators OEE
    READ TABLE lt_total INTO ls_total WITH KEY areaid   = gs_stop-areaid
                                               hname    = gs_stop-hname
                                               werks    = gs_stop-werks
                                               arbpl    = gs_stop-arbpl
                                               stprsnid = gs_stop-stprsnid
                                               shiftid  = gs_stop-shiftid
                                               week     = gs_stop-week.

    IF sy-subrc EQ 0.
*    Add value OEE to total
      ADD gs_stop-stoptime TO ls_total-total.
      MODIFY TABLE lt_total FROM ls_total.
    ELSE.
*    Insert new line in internal table total
      MOVE-CORRESPONDING gs_stop TO ls_total.
      ls_total-total = gs_stop-stoptime.

      INSERT ls_total INTO TABLE lt_total.
    ENDIF.
  ENDLOOP.

*Fill glbal internal table to show data in alv
  CLEAR gs_stop.

  LOOP AT gt_stop INTO gs_stop.
    CLEAR: gs_stop_alv,
           ls_area_desc,
           ls_hname_desc,
           ls_werks_desc,
           ls_arbpl_desc,
           ls_shift_desc,
           ls_stprsn_desc,
           ld_day.

*>>>PAP - Correcção - 20.05.2015
    READ TABLE gt_stop_alv INTO gs_stop_alv WITH KEY areaid   = gs_stop-areaid
                                                     hname    = gs_stop-hname
                                                     werks    = gs_stop-werks
                                                     arbpl    = gs_stop-arbpl
                                                     stprsnid = gs_stop-stprsnid
                                                     shiftid  = gs_stop-shiftid
                                                     week     = gs_stop-week.

    IF sy-subrc EQ 0.

*    Get number day in week
      CALL FUNCTION 'DATE_COMPUTE_DAY'
        EXPORTING
          date = gs_stop-data
        IMPORTING
          day  = ld_day.

*    Put value indicator OEE in corresponding day in week
      CASE ld_day.
        WHEN 1.
          gs_stop_alv-vdata1 = gs_stop-stoptime.

          MODIFY TABLE gt_stop_alv FROM gs_stop_alv TRANSPORTING vdata1.
        WHEN 2.
          gs_stop_alv-vdata2 = gs_stop-stoptime.

          MODIFY TABLE gt_stop_alv FROM gs_stop_alv TRANSPORTING vdata2.
        WHEN 3.
          gs_stop_alv-vdata3 = gs_stop-stoptime.

          MODIFY TABLE gt_stop_alv FROM gs_stop_alv TRANSPORTING vdata3.
        WHEN 4.
          gs_stop_alv-vdata4 = gs_stop-stoptime.

          MODIFY TABLE gt_stop_alv FROM gs_stop_alv TRANSPORTING vdata4.
        WHEN 5.
          gs_stop_alv-vdata5 = gs_stop-stoptime.

          MODIFY TABLE gt_stop_alv FROM gs_stop_alv TRANSPORTING vdata5.
        WHEN 6.
          gs_stop_alv-vdata6 = gs_stop-stoptime.

          MODIFY TABLE gt_stop_alv FROM gs_stop_alv TRANSPORTING vdata6.
        WHEN 7.
          gs_stop_alv-vdata7 = gs_stop-stoptime.

          MODIFY TABLE gt_stop_alv FROM gs_stop_alv TRANSPORTING vdata7.
      ENDCASE.

    ELSE.
*>>>PAP - Correcção

      MOVE-CORRESPONDING gs_stop TO gs_stop_alv.

*    Read description for Area
      READ TABLE lt_area_desc INTO ls_area_desc WITH KEY areaid = gs_stop-areaid.

      IF sy-subrc EQ 0.
*      Area description
        gs_stop_alv-area_desc = ls_area_desc-area_desc.
      ENDIF.

*    Read description for Hierarchy
      READ TABLE lt_hname_desc INTO ls_hname_desc WITH KEY name = gs_stop-hname.

      IF sy-subrc EQ 0.
*      Hierarchy description
        gs_stop_alv-hktext = ls_hname_desc-ktext.
      ENDIF.

*    Read description for Plant
      READ TABLE lt_werks_desc INTO ls_werks_desc WITH KEY werks = gs_stop-werks.

      IF sy-subrc EQ 0.
*      Plant description
        gs_stop_alv-name1 = ls_werks_desc-name1.
      ENDIF.

*    Read description for Workcenter
      READ TABLE lt_arbpl_desc INTO ls_arbpl_desc WITH KEY arbpl = gs_stop-arbpl.

      IF sy-subrc EQ 0.
*      Workcenter description
        gs_stop_alv-ktext = ls_arbpl_desc-ktext.
      ENDIF.

*    Read description for Stop Reason
      READ TABLE lt_stprsn_desc INTO ls_stprsn_desc WITH KEY stprsnid = gs_stop-stprsnid.

      IF sy-subrc EQ 0.
*      Indicator stop reason description
        gs_stop_alv-stprsn_desc = ls_stprsn_desc-stprsn_desc.
      ENDIF.

*    Read description for Shift
      READ TABLE lt_shift_desc INTO ls_shift_desc WITH KEY areaid  = gs_stop-areaid
                                                           werks   = gs_stop-werks
                                                           shiftid = gs_stop-shiftid.

      IF sy-subrc EQ 0.
*      Shift description
        gs_stop_alv-shift_desc = ls_shift_desc-shift_desc.
      ENDIF.

*    Get number day in week
      CALL FUNCTION 'DATE_COMPUTE_DAY'
        EXPORTING
          date = gs_stop-data
        IMPORTING
          day  = ld_day.

*    Put value indicator OEE in corresponding day in week
      CASE ld_day.
        WHEN 1.
          gs_stop_alv-vdata1 = gs_stop-stoptime.
        WHEN 2.
          gs_stop_alv-vdata2 = gs_stop-stoptime.
        WHEN 3.
          gs_stop_alv-vdata3 = gs_stop-stoptime.
        WHEN 4.
          gs_stop_alv-vdata4 = gs_stop-stoptime.
        WHEN 5.
          gs_stop_alv-vdata5 = gs_stop-stoptime.
        WHEN 6.
          gs_stop_alv-vdata6 = gs_stop-stoptime.
        WHEN 7.
          gs_stop_alv-vdata7 = gs_stop-stoptime.
      ENDCASE.

*    Total value OEE for shift
      CLEAR ls_total.
      LOOP AT lt_total INTO ls_total WHERE areaid   EQ gs_stop-areaid
                                       AND hname    EQ gs_stop-hname
                                       AND werks    EQ gs_stop-werks
                                       AND arbpl    EQ gs_stop-arbpl
                                       AND stprsnid EQ gs_stop-stprsnid
                                       AND shiftid  EQ gs_stop-shiftid
                                       AND week     EQ gs_stop-week.

*      Total for shift
        ADD ls_total-total TO gs_stop_alv-tshift.
      ENDLOOP.

*    Total value OEE in week
      CLEAR ls_total.
      LOOP AT lt_total INTO ls_total WHERE areaid   EQ gs_stop-areaid
                                       AND hname    EQ gs_stop-hname
                                       AND werks    EQ gs_stop-werks
                                       AND arbpl    EQ gs_stop-arbpl
                                       AND stprsnid EQ gs_stop-stprsnid
                                       AND week     EQ gs_stop-week.

*      Total for shift
        ADD ls_total-total TO gs_stop_alv-tweek.
      ENDLOOP.

*    Data for ALV
      APPEND gs_stop_alv TO gt_stop_alv.
    ENDIF.
  ENDLOOP.
ENDFORM.                    " FILL_DATA_ALV
