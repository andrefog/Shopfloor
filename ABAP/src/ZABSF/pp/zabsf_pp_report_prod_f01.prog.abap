*----------------------------------------------------------------------*
***INCLUDE Z_LP_PP_SF_REPORT_PROD_F01.
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
           gt_prod,
           gt_prod_alv,
           gt_error.

  CLEAR: gs_prod,
         gs_prod_alv.

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
        ls_shift       LIKE LINE OF so_shift.

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
         ls_shift.

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
       AND werks  EQ p_werks
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
FORM get_prod_time USING p_areaid p_hname p_werks
                         p_arbpl p_shiftid p_data
                   CHANGING p_prodtime p_produnit.

  DATA: lt_zabsf_pp016 TYPE TABLE OF zabsf_pp016,
        lt_afru        TYPE TABLE OF afru.

  DATA: ls_zabsf_pp016 TYPE zabsf_pp016,
        ls_afru        TYPE afru.

  DATA: ld_objid TYPE cr_objid,
        ld_ism02 TYPE ru_ismng,
        ld_ism03 TYPE ru_ismng.

  REFRESH: lt_zabsf_pp016,
           lt_afru.

  CLEAR: ls_zabsf_pp016,
         ls_afru,
         ld_objid,
         ld_ism02,
         ld_ism03.

  CASE p_areaid.
    WHEN  c_mec or c_prd .
*    Get work time of day for workcenter
*      SELECT SUM( ism02 ) SUM( ism03 )
*        FROM ZABSF_PP016
*        INTO (ld_ism02, ld_ism03)
*       WHERE areaid  EQ p_areaid
*         AND hname   EQ p_hname
*         AND werks   EQ p_werks
*         AND arbpl   EQ p_arbpl
*         AND iebd   EQ sy-datum
*         AND shiftid EQ p_shiftid.

*      p_prodtime = ld_ism02 + ld_ism03.

**    Get unit time
*      SELECT SINGLE ile03
*        FROM ZABSF_PP016
*        INTO p_produnit
*       WHERE areaid  EQ p_areaid
*         AND hname   EQ p_hname
*         AND werks   EQ p_werks
*         AND arbpl   EQ p_arbpl
*         AND iebd   EQ sy-datum
*         AND shiftid EQ p_shiftid.

*    Get work time of day for workcenter
      SELECT *
        FROM zabsf_pp016
        INTO CORRESPONDING FIELDS OF TABLE lt_zabsf_pp016
       WHERE areaid  EQ p_areaid
         AND hname   EQ p_hname
         AND werks   EQ p_werks
         AND arbpl   EQ p_arbpl
         AND iebd    EQ p_data
         AND shiftid EQ p_shiftid.

      LOOP AT lt_zabsf_pp016 INTO ls_zabsf_pp016.
        IF ls_zabsf_pp016-ism02 IS NOT INITIAL AND ls_zabsf_pp016-ism03 IS INITIAL.
          ADD ls_zabsf_pp016-ism02 TO p_prodtime.
        ELSEIF ls_zabsf_pp016-ism02 IS NOT INITIAL AND ls_zabsf_pp016-ism03 IS NOT INITIAL.
          ADD ls_zabsf_pp016-ism02 TO p_prodtime.
        ELSE.
          ADD ls_zabsf_pp016-ism03 TO p_prodtime.
        ENDIF.
      ENDLOOP.

*    Get unit time
      SELECT SINGLE ile03
        FROM zabsf_pp016
        INTO p_produnit
       WHERE areaid  EQ p_areaid
         AND hname   EQ p_hname
         AND werks   EQ p_werks
         AND arbpl   EQ p_arbpl
         AND iebd    EQ p_data
         AND shiftid EQ p_shiftid
         AND ile03   NE space.

    WHEN c_opt.
*    Get workcenter id
      SELECT SINGLE objid
        FROM crhd
        INTO ld_objid
        WHERE arbpl EQ p_arbpl
        AND werks EQ p_werks
        AND objty EQ 'A'.

**    Get work time of day for workcenter
*      SELECT SUM( ism02 ) SUM( ism03 )
*        FROM afru
*        INTO (ld_ism02, ld_ism03)
*       WHERE budat    EQ sy-datum
*         AND arbid    EQ ld_objid
*         AND werks    EQ p_werks
*         AND iebd     EQ sy-datum
*         AND kaptprog EQ p_shiftid
*         AND stokz    EQ space
*         AND stzhl    EQ space.
*
*      p_prodtime = ld_ism02 + ld_ism03.
*
**    Get unit time
*      SELECT SINGLE ile03
*        FROM afru
*        INTO p_produnit
*       WHERE budat    EQ sy-datum
*         AND arbid    EQ ld_objid
*         AND werks    EQ p_werks
*         AND iebd     EQ sy-datum
*         AND kaptprog EQ p_shiftid
*         AND stokz    EQ space
*         AND stzhl    EQ space.

*    Get work time of day for workcenter
      SELECT *
        FROM afru
        INTO CORRESPONDING FIELDS OF TABLE lt_afru
       WHERE budat    EQ p_data
         AND arbid    EQ ld_objid
         AND werks    EQ p_werks
         AND kaptprog EQ p_shiftid
         AND stokz    EQ space
         AND stzhl    EQ space.

      LOOP AT lt_afru INTO ls_afru.
        IF ls_afru-ism02 GE ls_afru-ism03.
          ADD ls_afru-ism02 TO p_prodtime.
        ELSE.
          ADD ls_afru-ism03 TO p_prodtime.
        ENDIF.

*        AT LAST.
*          p_produnit = ls_afru-ile02.
*        ENDAT.
      ENDLOOP.

*    Get unit
      SELECT SINGLE ile03
        FROM afru
        INTO p_produnit
       WHERE budat    EQ p_data
         AND arbid    EQ ld_objid
         AND werks    EQ p_werks
         AND kaptprog EQ p_shiftid
         AND stokz    EQ space
         AND stzhl    EQ space
         AND ile03    NE space.

    WHEN c_mont.
*    Get work time of day for workcenter
      SELECT SUM( worktime )
        FROM zabsf_pp046
        INTO p_prodtime
       WHERE areaid   EQ p_areaid
         AND hname    EQ p_hname
         AND werks    EQ p_werks
         AND rpoint   EQ p_arbpl
         AND datesr   EQ p_data
         AND shiftid  EQ p_shiftid.

*    Get work unit
      SELECT SINGLE workunit
        FROM zabsf_pp046
        INTO p_produnit
       WHERE areaid   EQ p_areaid
         AND hname    EQ p_hname
         AND werks    EQ p_werks
         AND rpoint   EQ p_arbpl
         AND datesr   EQ p_data
         AND shiftid  EQ p_shiftid.
  ENDCASE.
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
  DATA: lt_zabsf_pp055 TYPE TABLE OF zabsf_pp055.

  DATA: ls_zabsf_pp055 TYPE zabsf_pp055.

  REFRESH lt_zabsf_pp055.

*Get all data saved in database
  SELECT *
    FROM zabsf_pp055
    INTO CORRESPONDING FIELDS OF TABLE lt_zabsf_pp055
    WHERE areaid   EQ pa_area
      AND hname    IN so_hname
      AND werks    EQ pa_werks
      AND arbpl    IN so_arbpl
      AND shiftid  IN so_shift
      AND data     IN so_date.

  IF lt_zabsf_pp055[] IS NOT INITIAL.
*  Pass data to global internal table
    gt_prod[] = lt_zabsf_pp055[].
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

  IF gt_prod_alv[] IS NOT INITIAL.
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
  DATA: lt_zabsf_pp055 TYPE TABLE OF zabsf_pp055.

  DATA: ls_zabsf_pp055 TYPE zabsf_pp055,
        flag_error     TYPE c.

  REFRESH lt_zabsf_pp055.

*Get all data saved in database
  SELECT *
    FROM zabsf_pp055
    INTO CORRESPONDING FIELDS OF TABLE lt_zabsf_pp055
    WHERE areaid   EQ pa_area
      AND hname    IN so_hname
      AND werks    EQ pa_werks
      AND arbpl    IN so_arbpl
      AND shiftid  IN so_shift
      AND data     EQ pa_date.

  CLEAR: gs_prod,
         flag_error.

  LOOP AT gt_prod INTO gs_prod.
    CLEAR ls_zabsf_pp055.
*  Check if exist data saved in database
    READ TABLE lt_zabsf_pp055 INTO ls_zabsf_pp055 WITH KEY areaid   = gs_prod-areaid
                                                             hname    = gs_prod-hname
                                                             werks    = gs_prod-werks
                                                             arbpl    = gs_prod-arbpl
                                                             shiftid  = gs_prod-shiftid
                                                             data     = gs_prod-data.

    IF sy-subrc EQ 0.
*    Update value OEE with new value
      ls_zabsf_pp055-prodtime = gs_prod-prodtime.

      UPDATE zabsf_pp055 FROM ls_zabsf_pp055.

      IF sy-subrc NE 0.
        flag_error = 'X'.
*      Data not saved successfully in database
        MESSAGE e058(zabsf_pp).
        EXIT.
      ENDIF.
    ELSE.
*    Insert new line in database
      INSERT INTO zabsf_pp055 VALUES gs_prod.

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
           areaid  TYPE zabsf_pp_e_areaid,
           hname   TYPE cr_hname,
           werks   TYPE werks_d,
           arbpl   TYPE arbpl,
           shiftid TYPE zabsf_pp_e_shiftid,
           week    TYPE kweek,
           total   TYPE zabsf_pp_e_tweek,
         END OF ty_total.

  DATA: lt_prod_alv   TYPE TABLE OF zabsf_pp_s_data_alv,
        lt_area_desc  TYPE TABLE OF zabsf_pp000_t,
        lt_hname_desc TYPE TABLE OF ty_hname_desc,
        lt_werks_desc TYPE TABLE OF t001w,
        lt_arbpl_desc TYPE TABLE OF ty_arbpl_desc,
        lt_shift_desc TYPE TABLE OF zabsf_pp001_t,
        lt_total      TYPE TABLE OF ty_total.

  DATA: ls_prod_alv   TYPE zabsf_pp_s_data_alv,
        ls_area_desc  TYPE zabsf_pp000_t,
        ls_hname_desc TYPE ty_hname_desc,
        ls_werks_desc TYPE t001w,
        ls_arbpl_desc TYPE ty_arbpl_desc,
        ls_shift_desc TYPE zabsf_pp001_t,
        ls_total      TYPE ty_total,
        ld_day        TYPE scal-indicator.

  REFRESH: lt_area_desc,
           lt_hname_desc,
           lt_werks_desc,
           lt_arbpl_desc,
           lt_shift_desc,
           lt_total.
*
  CLEAR: ls_prod_alv,
         gs_prod.

*Get data to get description
  LOOP AT gt_prod INTO gs_prod.
    CLEAR ls_prod_alv.
    MOVE-CORRESPONDING gs_prod TO ls_prod_alv.

    APPEND ls_prod_alv TO lt_prod_alv.
  ENDLOOP.

  DELETE ADJACENT DUPLICATES FROM lt_prod_alv.

*Get description for Area
  SELECT *
    FROM zabsf_pp000_t
    INTO CORRESPONDING FIELDS OF TABLE lt_area_desc
     FOR ALL ENTRIES IN lt_prod_alv
   WHERE areaid EQ lt_prod_alv-areaid
     AND spras EQ sy-langu.

*Get description for Hierarchy
  SELECT crhh~objid crhh~name crtx~ktext
    INTO CORRESPONDING FIELDS OF TABLE lt_hname_desc
    FROM crtx AS crtx
   INNER JOIN crhh AS crhh
      ON crhh~objty EQ crtx~objty
     AND crhh~objid EQ crtx~objid
     FOR ALL ENTRIES IN lt_prod_alv
   WHERE crhh~name  EQ lt_prod_alv-hname
     AND crhh~objty EQ 'H'
     AND crhh~werks EQ lt_prod_alv-werks
     AND crtx~spras EQ sy-langu.

*Get description for Plant
  SELECT *
    FROM t001w
    INTO CORRESPONDING FIELDS OF TABLE lt_werks_desc
     FOR ALL ENTRIES IN lt_prod_alv
   WHERE werks EQ lt_prod_alv-werks
     AND spras EQ sy-langu.

*Get description for Workcenter
  SELECT crhd~objid crhd~arbpl crtx~ktext
    INTO CORRESPONDING FIELDS OF TABLE lt_arbpl_desc
    FROM crtx AS crtx
   INNER JOIN crhd AS crhd
      ON crhd~objty EQ crtx~objty
     AND crhd~objid EQ crtx~objid
     FOR ALL ENTRIES IN lt_prod_alv
   WHERE crhd~arbpl EQ lt_prod_alv-arbpl
     AND crhd~objty EQ 'A'
     AND crhd~werks EQ lt_prod_alv-werks
     AND crtx~spras EQ sy-langu.

*Get description for Shift
  SELECT *
    FROM zabsf_pp001_t
    INTO CORRESPONDING FIELDS OF TABLE lt_shift_desc
     FOR ALL ENTRIES IN lt_prod_alv
   WHERE areaid  EQ lt_prod_alv-areaid
     AND werks   EQ lt_prod_alv-werks
     AND shiftid EQ lt_prod_alv-shiftid
     AND spras   EQ sy-langu.

*Get total week for Stop Reason
  LOOP AT gt_prod INTO gs_prod.
*  Total indicators OEE
    READ TABLE lt_total INTO ls_total WITH KEY areaid   = gs_prod-areaid
                                               hname    = gs_prod-hname
                                               werks    = gs_prod-werks
                                               arbpl    = gs_prod-arbpl
                                               shiftid  = gs_prod-shiftid
                                               week     = gs_prod-week.

    IF sy-subrc EQ 0.
*    Add value OEE to total
      ADD gs_prod-prodtime TO ls_total-total.
      MODIFY TABLE lt_total FROM ls_total.
    ELSE.
*    Insert new line in internal table total
      MOVE-CORRESPONDING gs_prod TO ls_total.
      ls_total-total = gs_prod-prodtime.

      INSERT ls_total INTO TABLE lt_total.
    ENDIF.
  ENDLOOP.

*Fill glbal internal table to show data in alv
  CLEAR gs_prod.

  LOOP AT gt_prod INTO gs_prod.
    CLEAR: gs_prod_alv,
           ls_area_desc,
           ls_hname_desc,
           ls_werks_desc,
           ls_arbpl_desc,
           ls_shift_desc,
           ld_day.

*>>>PAP - Correcção - 20.05.2015
    READ TABLE gt_prod_alv INTO gs_prod_alv WITH KEY areaid   = gs_prod-areaid
                                                     hname    = gs_prod-hname
                                                     werks    = gs_prod-werks
                                                     arbpl    = gs_prod-arbpl
                                                     shiftid  = gs_prod-shiftid
                                                     week     = gs_prod-week.

    IF sy-subrc EQ 0.
*    Get number day in week
      CALL FUNCTION 'DATE_COMPUTE_DAY'
        EXPORTING
          date = gs_prod-data
        IMPORTING
          day  = ld_day.

*    Put value indicator OEE in corresponding day in week
      CASE ld_day.
        WHEN 1.
          gs_prod_alv-vdata1 = gs_prod-prodtime.

          MODIFY TABLE gt_prod_alv FROM gs_prod_alv TRANSPORTING vdata1.
        WHEN 2.
          gs_prod_alv-vdata2 = gs_prod-prodtime.

          MODIFY TABLE gt_prod_alv FROM gs_prod_alv TRANSPORTING vdata2.
        WHEN 3.
          gs_prod_alv-vdata3 = gs_prod-prodtime.

          MODIFY TABLE gt_prod_alv FROM gs_prod_alv TRANSPORTING vdata3.
        WHEN 4.
          gs_prod_alv-vdata4 = gs_prod-prodtime.

          MODIFY TABLE gt_prod_alv FROM gs_prod_alv TRANSPORTING vdata4.
        WHEN 5.
          gs_prod_alv-vdata5 = gs_prod-prodtime.

          MODIFY TABLE gt_prod_alv FROM gs_prod_alv TRANSPORTING vdata5.
        WHEN 6.
          gs_prod_alv-vdata6 = gs_prod-prodtime.

          MODIFY TABLE gt_prod_alv FROM gs_prod_alv TRANSPORTING vdata6.
        WHEN 7.
          gs_prod_alv-vdata7 = gs_prod-prodtime.

          MODIFY TABLE gt_prod_alv FROM gs_prod_alv TRANSPORTING vdata7.
      ENDCASE.
    ELSE.
*>>>PAP - Correcção

      MOVE-CORRESPONDING gs_prod TO gs_prod_alv.

*    Read description for Area
      READ TABLE lt_area_desc INTO ls_area_desc WITH KEY areaid = gs_prod-areaid.

      IF sy-subrc EQ 0.
*      Area description
        gs_prod_alv-area_desc = ls_area_desc-area_desc.
      ENDIF.

*    Read description for Hierarchy
      READ TABLE lt_hname_desc INTO ls_hname_desc WITH KEY name = gs_prod-hname.

      IF sy-subrc EQ 0.
*      Hierarchy description
        gs_prod_alv-hktext = ls_hname_desc-ktext.
      ENDIF.

*    Read description for Plant
      READ TABLE lt_werks_desc INTO ls_werks_desc WITH KEY werks = gs_prod-werks.

      IF sy-subrc EQ 0.
*      Plant description
        gs_prod_alv-name1 = ls_werks_desc-name1.
      ENDIF.

*    Read description for Workcenter
      READ TABLE lt_arbpl_desc INTO ls_arbpl_desc WITH KEY arbpl = gs_prod-arbpl.

      IF sy-subrc EQ 0.
*      Workcenter description
        gs_prod_alv-ktext = ls_arbpl_desc-ktext.
      ENDIF.

*    Read description for Shift
      READ TABLE lt_shift_desc INTO ls_shift_desc WITH KEY areaid  = gs_prod-areaid
                                                           werks   = gs_prod-werks
                                                           shiftid = gs_prod-shiftid.

      IF sy-subrc EQ 0.
*      Shift description
        gs_prod_alv-shift_desc = ls_shift_desc-shift_desc.
      ENDIF.

*    Get number day in week
      CALL FUNCTION 'DATE_COMPUTE_DAY'
        EXPORTING
          date = gs_prod-data
        IMPORTING
          day  = ld_day.

*    Put value indicator OEE in corresponding day in week
      CASE ld_day.
        WHEN 1.
          gs_prod_alv-vdata1 = gs_prod-prodtime.
        WHEN 2.
          gs_prod_alv-vdata2 = gs_prod-prodtime.
        WHEN 3.
          gs_prod_alv-vdata3 = gs_prod-prodtime.
        WHEN 4.
          gs_prod_alv-vdata4 = gs_prod-prodtime.
        WHEN 5.
          gs_prod_alv-vdata5 = gs_prod-prodtime.
        WHEN 6.
          gs_prod_alv-vdata6 = gs_prod-prodtime.
        WHEN 7.
          gs_prod_alv-vdata7 = gs_prod-prodtime.
      ENDCASE.

*    Total value OEE for shift
      CLEAR ls_total.
      LOOP AT lt_total INTO ls_total WHERE areaid   EQ gs_prod-areaid
                                       AND hname    EQ gs_prod-hname
                                       AND werks    EQ gs_prod-werks
                                       AND arbpl    EQ gs_prod-arbpl
                                       AND shiftid  EQ gs_prod-shiftid
                                       AND week     EQ gs_prod-week.

*      Total for shift
        ADD ls_total-total TO gs_prod_alv-tshift.
      ENDLOOP.

*    Total value OEE in week
      CLEAR ls_total.
      LOOP AT lt_total INTO ls_total WHERE areaid   EQ gs_prod-areaid
                                       AND hname    EQ gs_prod-hname
                                       AND werks    EQ gs_prod-werks
                                       AND arbpl    EQ gs_prod-arbpl
                                       AND week     EQ gs_prod-week.

*      Total for shift
        ADD ls_total-total TO gs_prod_alv-tweek.
      ENDLOOP.

*    Data for ALV
      APPEND gs_prod_alv TO gt_prod_alv.
    ENDIF.
  ENDLOOP.
ENDFORM.                    " FILL_DATA_ALV
