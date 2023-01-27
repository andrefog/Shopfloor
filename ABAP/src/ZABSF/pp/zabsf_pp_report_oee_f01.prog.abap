*----------------------------------------------------------------------*
***INCLUDE Z_LP_PP_SF_REPORT_OEE_F01.
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
           it_oee,
           it_shift,
           gt_oee,
           gt_oee_alv,
           gt_afru,
           gt_error.

  CLEAR: gv_plan_prod,
         gv_oper_time,
         gv_tot_pieces,
         gv_run_rate,
         gv_good_pieces,
         gv_real_time,
         gv_avaibility,
         gv_performance,
         gv_quality,
         gv_oee,
         gv_productivit,
         gs_oee,
         flag_error.
ENDFORM.                    " INIT_VARIABLES
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
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_workcenters TABLES p_hname STRUCTURE so_hname
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
*      <--P_IT_AUX  text
*----------------------------------------------------------------------*
FORM get_workcenters_table  USING    p_wa_hname p_werks
                            CHANGING p_it_aux TYPE STANDARD TABLE.

  DATA: lt_crhs       TYPE TABLE OF crhs,
        l_hrchy_objid TYPE cr_objid,
        ls_p_it_aux   TYPE ty_arbpl,
        lv_index      TYPE sy-index.


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
      SELECT crhd~arbpl crhd~kapid crtx~ktext
        INTO CORRESPONDING FIELDS OF TABLE p_it_aux
        FROM crhd INNER JOIN crtx
          ON crtx~objty EQ crhd~objty
         AND crtx~objid EQ crhd~objid
         FOR ALL ENTRIES IN lt_crhs
       WHERE crhd~objty EQ lt_crhs-objty_ho
         AND crhd~objid EQ lt_crhs-objid_ho
         AND crtx~spras EQ sy-langu.

      LOOP AT p_it_aux INTO ls_p_it_aux.

        SELECT SINGLE kapter
           INTO @DATA(lv_kapter)
           FROM kako
          WHERE kapid = @ls_p_it_aux-kapid
            AND kapter = 'X'.
        IF sy-subrc IS NOT INITIAL.
          DELETE p_it_aux INDEX sy-tabix.
        ENDIF.
        CLEAR lv_index.

      ENDLOOP.
    ENDIF.
  ENDIF.
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
  DATA: lt_zabsf_pp001 TYPE TABLE OF zabsf_pp001,
        lt_zabsf_pp002 TYPE TABLE OF zabsf_pp002,
        lt_zabsf_pp050 TYPE TABLE OF zabsf_pp050,
        lt_arbpl       TYPE TABLE OF ty_arbpl.

  DATA: wa_zabsf_pp001 TYPE zabsf_pp001,
        wa_zabsf_pp002 TYPE zabsf_pp002,
        wa_zabsf_pp050 TYPE zabsf_pp050,
        wa_arbpl       TYPE ty_arbpl,
        ls_hname       LIKE LINE OF so_hname,
        ls_arbpl       LIKE LINE OF so_arbpl,
        ls_shift       LIKE LINE OF so_shift,
        ls_oeeid       LIKE LINE OF so_oeeid.

  REFRESH: lt_zabsf_pp001,
           lt_zabsf_pp002,
           lt_zabsf_pp050,
           lt_arbpl.

  CLEAR: wa_zabsf_pp001,
         wa_zabsf_pp002,
         wa_zabsf_pp050,
         wa_arbpl,
         ls_hname,
         ls_arbpl,
         ls_shift,
         ls_oeeid.

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

*Check if parameter OEE is not initial
  IF so_oeeid[] IS INITIAL.
*  Get all indicators OEE
    SELECT *
      FROM zabsf_pp050
      INTO CORRESPONDING FIELDS OF TABLE lt_zabsf_pp050.

    LOOP AT lt_zabsf_pp050 INTO wa_zabsf_pp050.
      ls_oeeid-sign = 'I'.
      ls_oeeid-option = 'EQ'.
      ls_oeeid-low = wa_zabsf_pp050-oeeid.

      APPEND ls_oeeid TO so_oeeid.
    ENDLOOP.

    SORT so_oeeid.

    DELETE ADJACENT DUPLICATES FROM so_oeeid.
  ENDIF.
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
  DATA: lt_zabsf_pp051 TYPE TABLE OF zabsf_pp051.

  DATA: ls_zabsf_pp051 TYPE zabsf_pp051,
        flag_error     TYPE c.

  REFRESH lt_zabsf_pp051.

*Get all data saved in database
  SELECT *
    FROM zabsf_pp051
    INTO CORRESPONDING FIELDS OF TABLE lt_zabsf_pp051
    WHERE areaid  EQ pa_area
      AND hname   IN so_hname
      AND werks   EQ pa_werks
      AND arbpl   IN so_arbpl
      AND oeeid   IN so_oeeid
      AND shiftid IN so_shift
      AND data    EQ pa_date.

  CLEAR: gs_oee,
         flag_error.

  LOOP AT gt_oee INTO gs_oee.
    CLEAR ls_zabsf_pp051.
*  Check if exist data saved in database
    READ TABLE lt_zabsf_pp051 INTO ls_zabsf_pp051 WITH KEY areaid  = gs_oee-areaid
                                                             hname   = gs_oee-hname
                                                             werks   = gs_oee-werks
                                                             arbpl   = gs_oee-arbpl
                                                             oeeid   = gs_oee-oeeid
                                                             shiftid = gs_oee-shiftid
                                                             data    = gs_oee-data.

    IF sy-subrc EQ 0.
*    Update value OEE with new value
      ls_zabsf_pp051-qtdoee = gs_oee-qtdoee.

      UPDATE zabsf_pp051 FROM ls_zabsf_pp051.

      IF sy-subrc NE 0.
        flag_error = 'X'.
*      Data not saved successfully in database
        MESSAGE e058(zabsf_pp).
        EXIT.
      ENDIF.
    ELSE.
*    Insert new line in database
      INSERT INTO zabsf_pp051 VALUES gs_oee.

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
*&      Form  CALC_AVAILABILY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_<FS_OEE>_DATA  text
*      -->P_<FS_OEE>_SHIFTID  text
*      <--P_GV_AVAIBILITY  text
*----------------------------------------------------------------------*
FORM calc_availabily USING p_areaid p_hname p_werks p_arbpl p_shiftid p_oeeid p_data.

  DATA: p_plan_prod    TYPE mengv13,
        p_oper_time    TYPE mengv13,
        p_tot_pieces   TYPE mengv13,
        p_run_rate     TYPE mengv13,
        p_run_rate_prd TYPE mengv13,
        p_good_pieces  TYPE mengv13,
        p_real_time    TYPE mengv13,
        p_avaibility   TYPE mengv13,
        p_performance  TYPE mengv13,
        p_quality      TYPE mengv13,
        p_oee          TYPE mengv13,
        p_productivit  TYPE mengv13.

  CLEAR: p_plan_prod,
         p_oper_time,
         p_tot_pieces,
         p_run_rate,
         p_good_pieces,
         p_real_time,
         p_avaibility,
         p_performance,
         p_quality,
         p_oee,
         p_productivit.

*Get data for availabily
  PERFORM get_data_availabily USING p_hname p_werks p_arbpl p_areaid p_data p_shiftid
                              CHANGING p_plan_prod p_oper_time.

*Calculate value of indicator OEE
  IF p_plan_prod NE 0.
    p_avaibility = ( p_oper_time / p_plan_prod ) * 100.
  ENDIF.

*Save value calculated
  PERFORM save_value_calc USING p_areaid p_hname p_werks p_arbpl p_oeeid p_shiftid p_data
                                p_plan_prod p_oper_time p_tot_pieces p_run_rate p_run_rate_prd p_good_pieces
                                p_real_time p_avaibility p_performance p_quality p_oee p_productivit.
ENDFORM.                    " CALC_AVAILABILY
*&---------------------------------------------------------------------*
*&      Form  GET_DATA_AVAILABILY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data_availabily USING    p_hname p_werks p_arbpl p_areaid p_data p_shiftid
                         CHANGING p_plan_prod p_oper_time.
  TYPES: BEGIN OF ty_times_shift,
           areaid   TYPE zabsf_pp_e_areaid,
           werks    TYPE werks_d,
           shiftid  TYPE zabsf_pp_e_shiftid,
           worktime TYPE mengv13,
           stoptime TYPE mengv13,
           unit     TYPE meins,
         END OF ty_times_shift.

  DATA: lt_time        TYPE TABLE OF ty_times_shift,
        lt_zabsf_pp006 TYPE TABLE OF zabsf_pp006.

  DATA: ls_zabsf_pp001 TYPE zabsf_pp001,
        wa_zabsf_pp006 TYPE zabsf_pp006,
        ls_time        TYPE ty_times_shift,
        ls_kako        TYPE kako,
        ld_hours       TYPE i,
        ld_stop_time   TYPE i,
        ld_stop_area   TYPE zabsf_pp_e_stoptime,
        ld_kapid       TYPE kapid,
        ld_capacity    TYPE kapazitaet,
        ld_einzt       TYPE kapeinzt,
        ld_kapaz       TYPE kapazitaet,
        ld_worktime    TYPE mengv13.

  CONSTANTS c_sec_day TYPE kapbegzt VALUE '86400'.

  REFRESH lt_zabsf_pp006.

  CLEAR: ls_zabsf_pp001,
         wa_zabsf_pp006,
         ls_time,
         ld_hours,
         ld_stop_time,
         ld_stop_area,
         ld_kapid,
         ld_capacity,
         ld_einzt,
         ld_kapaz,
         ld_worktime.

**Get time of shift
*  SELECT SINGLE *
*    FROM ZABSF_PP001
*    INTO CORRESPONDING FIELDS OF ls_ZABSF_PP001
*   WHERE areaid  EQ p_areaid
*     AND werks   EQ p_werks
*     AND shiftid EQ p_shiftid
*     AND endda   GE p_data
*     AND begda   LE p_data.
*
*  IF ls_ZABSF_PP001 IS NOT INITIAL.
**  Calculate time of worktime
*    CLEAR ld_hours.
*
**  Area
*    ls_time-areaid = ls_ZABSF_PP001-areaid.
**  Plant
*    ls_time-werks = ls_ZABSF_PP001-werks.
**  Shift
*    ls_time-shiftid = ls_ZABSF_PP001-shiftid.
**  Working time
*    IF ls_ZABSF_PP001-shift_end GE ls_ZABSF_PP001-shift_start.
*      ld_hours = ls_ZABSF_PP001-shift_end - ls_ZABSF_PP001-shift_start.
*    ELSE.
*      ld_hours = ( ls_ZABSF_PP001-shift_end - ls_ZABSF_PP001-shift_start ) + 86400.
*    ENDIF.
*
**  Working time - Minutes
*    ls_time-worktime = ( ld_hours / 60 ).
**  Unit
*    ls_time-unit = c_unit.
*
*    APPEND ls_time TO lt_time.
*  ENDIF.

**Get time of breaks
*  SELECT *
*    FROM ZABSF_PP006
*    INTO CORRESPONDING FIELDS OF TABLE lt_ZABSF_PP006
*   WHERE areaid  EQ p_areaid
*     AND werks   EQ p_werks
*     AND shiftid EQ p_shiftid
*     AND endda   GE p_data
*     AND begda   LE p_data.
*
*  LOOP AT lt_ZABSF_PP006 INTO wa_ZABSF_PP006.
*    CLEAR ld_stop_time.
*
**  Read time for area, shift and plant
*    READ TABLE lt_time INTO ls_time WITH KEY areaid  = wa_ZABSF_PP006-areaid
*                                             werks   = wa_ZABSF_PP006-werks
*                                             shiftid = wa_ZABSF_PP006-shiftid.
*
*    IF sy-subrc EQ 0.
**    Calculate pause time
*      IF wa_ZABSF_PP006-paubeg NE space AND wa_ZABSF_PP006-pauend NE space.
**      Pause time
*        ld_stop_time = wa_ZABSF_PP006-pauend - wa_ZABSF_PP006-paubeg.
*
*        ld_stop_time = ld_stop_time / 60.
*
*        ADD ld_stop_time TO ls_time-stoptime.
*      ELSEIF wa_ZABSF_PP006-padauer IS NOT INITIAL.
**      Pause time
*        ADD wa_ZABSF_PP006-padauer TO ls_time-stoptime.
*      ENDIF.
*      MODIFY TABLE lt_time FROM ls_time TRANSPORTING stoptime.
*    ENDIF.
*  ENDLOOP.

**Calculate Planned Production Time and Operating Time
*  READ TABLE lt_time INTO ls_time WITH KEY areaid  = p_areaid
*                                           werks   = p_werks
*                                           shiftid = p_shiftid.
*
*  IF sy-subrc EQ 0.
**  Planned Production Time
*    p_plan_prod = ls_time-worktime - ls_time-stoptime.
**  Operating Time
*    p_oper_time = p_plan_prod - ld_stop_area.
*  ENDIF.

*Get ID capacity
  SELECT SINGLE kapid
    FROM crhd
    INTO ld_kapid
   WHERE arbpl EQ p_arbpl
     AND werks EQ p_werks.

*Get capacity detail
  SELECT SINGLE *
    FROM kako
    INTO CORRESPONDING FIELDS OF ls_kako
   WHERE kapid EQ ld_kapid.

  IF ls_kako-begzt GT 0 OR ls_kako-endzt GT 0.
*  Capacity - Time
    IF ls_kako-endzt GE ls_kako-begzt.
      ld_capacity = ls_kako-endzt - ls_kako-begzt.

      IF ld_capacity = 0.
        ld_capacity = c_sec_day.
      ENDIF.
    ELSE.
      ld_capacity = c_sec_day - ls_kako-begzt + ls_kako-endzt.
    ENDIF.

    IF ld_capacity GT ls_kako-pause.
*    Worktime
      ld_einzt = ( ld_capacity - ls_kako-pause ) * ls_kako-ngrad / 100.

      ld_einzt = ld_einzt * ls_kako-aznor.

      ld_worktime = ld_einzt / 60.
    ELSE.
      ld_worktime = 0.
    ENDIF.
  ENDIF.

*Get all stops of the day for Area
  SELECT SUM( stoptime )
    FROM zabsf_pp010
    INTO ld_stop_area
   WHERE areaid  EQ p_areaid
     AND hname   EQ p_hname
     AND werks   EQ p_werks
     AND datesr  EQ p_data
     AND shiftid EQ p_shiftid.


*Planned Production Time
  p_plan_prod = ld_worktime.
*Operating Time
  p_oper_time = p_plan_prod - ld_stop_area.

ENDFORM.                    " GET_DATA_AVAILABILY
*&---------------------------------------------------------------------*
*&      Form  CALC_PERFORMANCE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_<FS_OEE>_DATA  text
*      -->P_<FS_OEE>_SHIFTID  text
*      -->P_<FS_OEE>_ARBPL  text
*      <--P_GV_PERFORMANCE  text
*----------------------------------------------------------------------*
FORM calc_performance USING p_areaid p_hname p_werks p_arbpl p_shiftid p_oeeid p_data.

  DATA: p_plan_prod    TYPE mengv13,
        p_oper_time    TYPE mengv13,
        p_tot_pieces   TYPE mengv13,
        p_run_rate     TYPE mengv13,
        p_run_rate_prd TYPE mengv13,
        p_good_pieces  TYPE mengv13,
        p_real_time    TYPE mengv13,
        p_avaibility   TYPE mengv13,
        p_performance  TYPE mengv13,
        p_quality      TYPE mengv13,
        p_oee          TYPE mengv13,
        p_productivit  TYPE mengv13.

  CLEAR: p_plan_prod,
         p_oper_time,
         p_tot_pieces,
         p_run_rate,
         p_good_pieces,
         p_real_time,
         p_avaibility,
         p_performance,
         p_quality,
         p_oee,
         p_productivit.

*Read value calculated
  PERFORM read_value_calc USING p_areaid p_hname p_werks p_arbpl p_oeeid p_shiftid p_data
                          CHANGING p_plan_prod p_oper_time p_tot_pieces p_run_rate p_run_rate_prd p_good_pieces
                                   p_real_time p_avaibility p_performance p_quality p_oee p_productivit.

*Get data for performance
  PERFORM get_data_performance USING p_areaid p_hname p_werks p_arbpl p_shiftid p_oeeid p_data
                               CHANGING p_tot_pieces p_run_rate.

  IF p_oper_time IS NOT INITIAL.
    IF p_run_rate NE 0.
      p_performance = ( ( p_tot_pieces / p_oper_time ) / p_run_rate ) * 100.
    ENDIF.
  ELSE.
    CLEAR: p_plan_prod,
           p_oper_time.

*  Get data for operating time
    PERFORM get_data_availabily USING p_hname p_werks p_arbpl p_areaid p_data p_shiftid
                                CHANGING p_plan_prod p_oper_time.

    IF p_run_rate NE 0.
      p_performance = ( ( p_tot_pieces / p_oper_time ) / p_run_rate ) * 100.
    ENDIF.
  ENDIF.

*Save value calculated
  PERFORM save_value_calc USING p_areaid p_hname p_werks p_arbpl p_oeeid p_shiftid p_data
                                p_plan_prod p_oper_time p_tot_pieces p_run_rate p_run_rate_prd p_good_pieces
                                p_real_time p_avaibility p_performance p_quality p_oee p_productivit.
ENDFORM.                    " CALC_PERFORMANCE
*&---------------------------------------------------------------------*
*&      Form  GET_DATA_PERFORMANCE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data_performance USING    p_areaid p_hname p_werks p_arbpl p_shiftid p_oeeid p_data
                          CHANGING p_tot_pieces p_run_rate.

  DATA: lt_afru TYPE TABLE OF afru.

  DATA: ld_arbid     TYPE cr_objid,
        ld_bmsch_tot TYPE bmsch,
        ld_vgw03_tot TYPE vgwrt.

  DATA: p_plan_prod    TYPE mengv13,
        p_oper_time    TYPE mengv13,
        p_real_time    TYPE mengv13,
        p_run_rate_prd TYPE mengv13,
        p_avaibility   TYPE mengv13,
        p_performance  TYPE mengv13,
        p_good_pieces  TYPE mengv13,
        p_quality      TYPE mengv13,
        p_oee          TYPE mengv13,
        p_productivit  TYPE mengv13.

  CLEAR: p_plan_prod,
         p_oper_time,
         p_tot_pieces,
         p_run_rate,
         p_real_time,
         p_avaibility,
         p_performance,
         p_quality,
         p_oee,
         p_productivit.

  REFRESH lt_afru.

  CLEAR: ld_arbid,
         ld_bmsch_tot,
         ld_vgw03_tot.

*Get id of workcenter
  SELECT SINGLE objid
    FROM crhd
    INTO ld_arbid
    WHERE arbpl EQ p_arbpl
    AND werks EQ p_werks.

  IF ld_arbid IS NOT INITIAL.
*  Get total pieces
    PERFORM get_tot_pieces USING ld_arbid p_werks p_data p_shiftid p_areaid
                           CHANGING p_tot_pieces lt_afru.
  ENDIF.

  IF lt_afru[] IS NOT INITIAL.
*  Get labor time and routing basic quantity
    PERFORM calc_bmsch_vgw03_tot TABLES lt_afru
                                 USING ld_arbid p_werks p_areaid
                                 CHANGING ld_bmsch_tot ld_vgw03_tot.

    IF ld_bmsch_tot IS NOT INITIAL AND ld_vgw03_tot IS NOT INITIAL.
*    Ideal Run Rate
      IF ld_vgw03_tot NE 0.
        p_run_rate = ld_bmsch_tot / ld_vgw03_tot.

*      Rounding number
        CALL FUNCTION 'ROUND'
          EXPORTING
            decimals      = 2
            input         = p_run_rate
            sign          = '+'
          IMPORTING
            output        = p_run_rate
          EXCEPTIONS
            input_invalid = 1
            overflow      = 2
            type_invalid  = 3
            OTHERS        = 4.

        IF sy-subrc <> 0.
*        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.

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
      ELSE.
*      Save value calculated
        PERFORM save_value_calc USING p_areaid p_hname p_werks p_arbpl p_oeeid p_shiftid p_data
                                      p_plan_prod p_oper_time p_tot_pieces p_run_rate p_run_rate_prd p_good_pieces
                                      p_real_time p_avaibility p_performance p_quality p_oee p_productivit.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.                    " GET_DATA_PERFORMANCE
*&---------------------------------------------------------------------*
*&      Form  GET_TOT_PIECES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LD_ARBID  text
*      -->P_PA_WERKS  text
*      -->P_P_DATA  text
*      -->P_P_SHIFT  text
*      <--P_P_TOT_PIECE  text
*----------------------------------------------------------------------*
FORM get_tot_pieces USING p_arbid p_werks p_data p_shift p_areaid
                    CHANGING p_tot_pieces p_it_afru TYPE STANDARD TABLE.

  DATA: ls_afru  TYPE afru,
        ls_afvc  TYPE afvc,
        ld_lmnga TYPE ru_lmnga,
        ld_rmnga TYPE ru_rmnga,
        ld_xmnga TYPE ru_xmnga,
        wa_afru  TYPE afru,
        ld_arbpl TYPE arbpl,
        lv_lmnga TYPE bstmg.

  REFRESH p_it_afru.

  CLEAR: wa_afru,
         p_tot_pieces,
         ls_afru,
         ld_lmnga,
         ld_rmnga,
         ld_xmnga,
         ld_arbpl.

*Get id of workcenter
  SELECT SINGLE arbpl
    FROM crhd
    INTO ld_arbpl
    WHERE objid EQ p_arbid.

**Get confirmation for day, shift and workcenter
*  SELECT *
*    FROM afru
*    INTO CORRESPONDING FIELDS OF TABLE p_it_afru
*    WHERE budat    EQ p_data
*      AND arbid    EQ p_arbid
*      AND werks    EQ p_werks
*      AND isdd     EQ p_data
*      AND kaptprog EQ p_shift
*      AND stokz    EQ space
*      AND stzhl    EQ space.

  IF gt_afru[] IS NOT INITIAL.
*  Get confirmation for day, shift and workcenter
    LOOP AT gt_afru INTO wa_afru WHERE budat    EQ p_data
                                   AND arbid    EQ p_arbid
                                   AND werks    EQ p_werks
                                   AND kaptprog EQ p_shift
                                   AND stokz    EQ space
                                   AND stzhl    EQ space.

      APPEND wa_afru TO p_it_afru.
    ENDLOOP.
  ENDIF.

  IF p_it_afru[] IS NOT INITIAL.
    LOOP AT p_it_afru INTO ls_afru.
*    Confirmed yield
      IF ls_afru-lmnga IS NOT INITIAL.
*        ADD ls_afru-lmnga TO ld_lmnga.
        IF ls_afru-meinh = 'KG'.
          ADD ls_afru-lmnga TO ld_lmnga.
        ELSE.
          SELECT SINGLE plnbez
                 FROM afko
                 INTO @DATA(lv_matnr)
                 WHERE aufnr = @ls_afru-aufnr.

          CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
            EXPORTING
              i_matnr              = lv_matnr
              i_in_me              = ls_afru-meinh
              i_out_me             = 'KG'
              i_menge              = ls_afru-lmnga
            IMPORTING
              e_menge              = lv_lmnga
            EXCEPTIONS
              error_in_application = 1
              error                = 2
              OTHERS               = 3.

          IF sy-subrc <> 0.
* Implement suitable error handling here
          ELSE.
            ADD lv_lmnga TO ld_lmnga.
          ENDIF.

        ENDIF.
      ENDIF.

      IF p_areaid EQ c_mec OR p_areaid EQ c_opt OR p_areaid EQ c_prd.
*    Rework Quantity
        IF ls_afru-rmnga IS NOT INITIAL.
          ADD ls_afru-rmnga TO ld_rmnga.
        ENDIF.

*    Scrap quantity
        IF ls_afru-xmnga IS NOT INITIAL AND ls_afru-grund = '0005'.
          ADD ls_afru-xmnga TO ld_xmnga.
        ENDIF.
      ELSE.
        SELECT SUM( rework )
          FROM zabsf_pp049
          INTO ld_rmnga
         WHERE areaid  EQ p_areaid
           AND rpoint  EQ ld_arbpl
           AND data    EQ p_data
           AND shiftid EQ p_shift.
      ENDIF.
    ENDLOOP.

*  Total pieces
    p_tot_pieces = ld_lmnga + ld_rmnga + ld_xmnga.
  ENDIF.
ENDFORM.                    " GET_TOT_PIECES
*&---------------------------------------------------------------------*
*&      Form  CALC_BMSCH_VGW03_TOT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LD_ARBID  text
*      -->P_PA_WERKS  text
*      -->P_LT_AFRU  text
*----------------------------------------------------------------------*
FORM calc_bmsch_vgw03_tot TABLES p_it_afru STRUCTURE afru
                          USING p_arbid p_werks p_areaid
                          CHANGING p_bmsch_tot p_vgw03_tot.

  DATA: lt_afvc     TYPE TABLE OF afvc,
        lt_afvc_aux TYPE TABLE OF afvc,
        lt_plpo     TYPE TABLE OF plpo.

  DATA: ls_afvc      TYPE afvc,
        ls_afvc_aux  TYPE afvc,
        ld_bmsch     TYPE bmsch,
        ld_vgw03     TYPE vgwrt,
        ld_vgw03_aux TYPE vgwrt,
        lv_meinh     TYPE vorme,
        lv_bmsch     TYPE bstmg.

  REFRESH lt_afvc.

  CLEAR: p_bmsch_tot,
         p_vgw03_tot.

  IF p_areaid EQ c_mec OR p_areaid EQ c_opt OR p_areaid EQ c_prd.
*  Get Key for Task List Group
    SELECT *
      FROM afvc
      INTO CORRESPONDING FIELDS OF TABLE lt_afvc
      FOR ALL ENTRIES IN p_it_afru
      WHERE aufpl EQ p_it_afru-aufpl
        AND aplzl EQ p_it_afru-aplzl
        AND vornr EQ p_it_afru-vornr
        AND arbid EQ p_arbid
        AND werks EQ p_werks
        AND rueck EQ p_it_afru-rueck.
*      AND rmzhl EQ p_it_afru-rmzhl.
  ELSE.
*  Get Key for Task List Group
    SELECT *
      FROM afvc
      INTO CORRESPONDING FIELDS OF TABLE lt_afvc_aux
      FOR ALL ENTRIES IN p_it_afru
      WHERE aufpl EQ p_it_afru-aufpl
        AND vornr LT p_it_afru-vornr
        AND werks EQ p_werks.

    SORT lt_afvc_aux BY vornr DESCENDING.

    LOOP AT lt_afvc_aux INTO ls_afvc_aux.
      IF ls_afvc_aux-arbid NE '00000000'.
        MOVE-CORRESPONDING ls_afvc_aux TO ls_afvc.
        APPEND ls_afvc TO lt_afvc.
      ELSE.
        EXIT.
      ENDIF.
    ENDLOOP.
  ENDIF.

  IF lt_afvc[] IS NOT INITIAL.
    LOOP AT lt_afvc INTO ls_afvc.
      CLEAR: ld_bmsch,
             ld_vgw03,
             ld_vgw03_aux.

**    Get routing basic quantity and labor time
*      SELECT SUM( bmsch ) SUM( vgw03 )
*        FROM plpo
*        INTO (ld_bmsch, ld_vgw03)
*       WHERE plnty EQ ls_afvc-plnty
*         AND plnnr EQ ls_afvc-plnnr
*         AND plnkn EQ ls_afvc-plnkn
*         AND zaehl EQ ls_afvc-zaehl
*         AND vornr EQ ls_afvc-vornr.

*    Get routing basic quantity and labor time
      SELECT  *
        FROM plpo
        INTO CORRESPONDING FIELDS OF TABLE lt_plpo
       WHERE plnty EQ ls_afvc-plnty
         AND plnnr EQ ls_afvc-plnnr
         AND plnkn EQ ls_afvc-plnkn
         AND zaehl EQ ls_afvc-zaehl
         AND vornr EQ ls_afvc-vornr.

      LOOP AT lt_plpo INTO DATA(ls_plpo).
        IF ls_plpo-meinh = 'KG'.
          ADD: ls_plpo-bmsch TO p_bmsch_tot.
*               ls_plpo-vgw03 TO p_vgw03_tot.
        ELSE.
          SELECT SINGLE plnbez
                 FROM afko
                 INTO @DATA(lv_matnr)
                 WHERE aufpl = @ls_afvc-aufpl.

          CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
            EXPORTING
              i_matnr              = lv_matnr
              i_in_me              = ls_plpo-meinh
              i_out_me             = 'KG'
              i_menge              = ls_plpo-bmsch
            IMPORTING
              e_menge              = lv_bmsch
            EXCEPTIONS
              error_in_application = 1
              error                = 2
              OTHERS               = 3.
          IF sy-subrc <> 0.
* Implement suitable error handling here
          ELSE.
            ADD: lv_bmsch      TO p_bmsch_tot.
*                 ls_plpo-vgw03 TO p_vgw03_tot.
          ENDIF.
*            ADD: ld_bmsch TO p_bmsch_tot.
*                 ld_vgw03 TO p_vgw03_tot.
        ENDIF.

        IF ls_plpo-vgw02 IS NOT INITIAL.
          ADD ls_plpo-vgw02 TO p_vgw03_tot.

        ELSEIF ls_plpo-vgw03 IS NOT INITIAL.
          ADD ls_plpo-vgw03 TO p_vgw03_tot.

        ELSEIF ls_plpo-vgw01 IS NOT INITIAL.
          ADD ls_plpo-vgw01 TO p_vgw03_tot.
        ENDIF.

        CLEAR: ls_plpo,
               lv_bmsch.

      ENDLOOP.
    ENDLOOP.
  ENDIF.
ENDFORM.                    " CALC_BMSCH_VGW03_TOT
*&---------------------------------------------------------------------*
*&      Form  CALC_QUALITY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_<FS_OEE>_ARBPL  text
*      -->P_<FS_OEE>_DATA  text
*      -->P_<FS_OEE>_SHIFTID  text
*      <--P_GV_QUALITY  text
*----------------------------------------------------------------------*
FORM calc_quality USING p_areaid p_hname p_werks p_arbpl p_shiftid p_oeeid p_data.
  DATA: p_plan_prod    TYPE mengv13,
        p_oper_time    TYPE mengv13,
        p_tot_pieces   TYPE mengv13,
        p_run_rate     TYPE mengv13,
        p_run_rate_prd TYPE mengv13,
        p_good_pieces  TYPE mengv13,
        p_real_time    TYPE mengv13,
        p_avaibility   TYPE mengv13,
        p_performance  TYPE mengv13,
        p_quality      TYPE mengv13,
        p_oee          TYPE mengv13,
        p_productivit  TYPE mengv13.

  DATA ld_arbid TYPE cr_objid.

  CLEAR: p_plan_prod,
         p_oper_time,
         p_tot_pieces,
         p_run_rate,
         p_good_pieces,
         p_real_time,
         p_avaibility,
         p_performance,
         p_quality,
         p_oee,
         p_productivit.

*Read value calculated
  PERFORM read_value_calc USING p_areaid p_hname p_werks p_arbpl p_oeeid p_shiftid p_data
                          CHANGING p_plan_prod p_oper_time p_tot_pieces p_run_rate p_run_rate_prd p_good_pieces
                                   p_real_time p_avaibility p_performance p_quality p_oee p_productivit.

*Get data for quality
  PERFORM get_data_quality USING p_werks p_arbpl p_data p_shiftid
                           CHANGING p_good_pieces.

  IF p_tot_pieces IS NOT INITIAL.
    IF p_tot_pieces NE 0.
      p_quality = ( p_good_pieces / p_tot_pieces ) * 100.
    ENDIF.
  ELSE.
    CLEAR ld_arbid.

*  Get id of workcenter
    SELECT SINGLE objid
      FROM crhd
      INTO ld_arbid
      WHERE arbpl EQ p_arbpl
      AND werks EQ p_werks.

*  Get total pieces
    PERFORM get_tot_pieces USING ld_arbid p_werks p_data p_shiftid p_areaid
                           CHANGING p_tot_pieces lt_afru.

    IF p_tot_pieces NE 0.
      p_quality = ( p_good_pieces / p_tot_pieces ) * 100.
    ENDIF.
  ENDIF.

*Save value calculated
  PERFORM save_value_calc USING p_areaid p_hname p_werks p_arbpl p_oeeid p_shiftid p_data
                                p_plan_prod p_oper_time p_tot_pieces p_run_rate p_run_rate_prd p_good_pieces
                                p_real_time p_avaibility p_performance p_quality p_oee p_productivit.
ENDFORM.                    " CALC_QUALITY
*&---------------------------------------------------------------------*
*&      Form  GET_DATA_QUALITY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data_quality USING p_werks p_arbpl p_data p_shift
                      CHANGING p_good_pieces.

*Get good pieces
  PERFORM get_good_pieces USING p_werks p_arbpl p_data p_shift
                          CHANGING p_good_pieces.

ENDFORM.                    " GET_DATA_QUALITY
*&---------------------------------------------------------------------*
*&      Form  GET_GOOD_PIECES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_ARBPL  text
*      -->P_P_DATA  text
*      -->P_P_SHIFTID  text
*      <--P_GV_GOOD_PIECES  text
*----------------------------------------------------------------------*
FORM get_good_pieces USING p_werks p_arbpl p_data p_shiftid
                     CHANGING p_good_pieces.

  DATA: lt_afru  TYPE TABLE OF afru,
        lv_lmnga TYPE bstmg.

  DATA: ls_afru  TYPE afru,
        ld_lmnga TYPE ru_lmnga,
        ld_arbid TYPE cr_objid,
        wa_afru  TYPE afru.

  REFRESH lt_afru.

  CLEAR: p_good_pieces,
         ls_afru,
         ld_lmnga,
         ld_arbid,
         wa_afru.

*Get id of workcenter
  SELECT SINGLE objid
    FROM crhd
    INTO ld_arbid
    WHERE arbpl EQ p_arbpl
    AND werks EQ p_werks.


**Get confirmation for day, shift and workcenter
*  SELECT *
*    FROM afru
*    INTO CORRESPONDING FIELDS OF TABLE lt_afru
*    WHERE budat    EQ p_data
*      AND arbid    EQ ld_arbid
*      AND werks    EQ p_werks
*      AND isdd     EQ p_data
*      AND kaptprog EQ p_shiftid
*      AND stokz    EQ space
*      AND stzhl    EQ space.

*Get confirmation for day, shift and workcenter
  LOOP AT gt_afru INTO wa_afru WHERE budat    EQ p_data
                                 AND arbid    EQ ld_arbid
                                 AND werks    EQ p_werks
                                 AND kaptprog EQ p_shiftid
                                 AND stokz    EQ space
                                 AND stzhl    EQ space.

    APPEND wa_afru TO lt_afru.
  ENDLOOP.

  LOOP AT lt_afru INTO ls_afru.
*  confirmed yield
    IF ls_afru-lmnga IS NOT INITIAL.
      IF ls_afru-meinh = 'KG'.
        ADD ls_afru-lmnga TO ld_lmnga.
      ELSE.
        SELECT SINGLE plnbez
               FROM afko
               INTO @DATA(lv_matnr)
               WHERE aufnr = @ls_afru-aufnr.

        CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
          EXPORTING
            i_matnr              = lv_matnr
            i_in_me              = ls_afru-meinh
            i_out_me             = 'KG'
            i_menge              = ls_afru-lmnga
          IMPORTING
            e_menge              = lv_lmnga
          EXCEPTIONS
            error_in_application = 1
            error                = 2
            OTHERS               = 3.

        IF sy-subrc <> 0.
* Implement suitable error handling here
        ELSE.
          ADD lv_lmnga TO ld_lmnga.
        ENDIF.

      ENDIF.
    ENDIF.
  ENDLOOP.

*Total pieces
  p_good_pieces = ld_lmnga.

ENDFORM.                    " GET_GOOD_PIECES
*&---------------------------------------------------------------------*
*&      Form  CALC_OEE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_<FS_OEE>_AREAID  text
*      -->P_<FS_OEE>_HNAME  text
*      -->P_<FS_OEE>_WERKS  text
*      -->P_<FS_OEE>_ARBPL  text
*      -->P_<FS_OEE>_OEEID  text
*      -->P_<FS_OEE>_SHIFTID  text
*      -->P_<FS_OEE>_DATA  text
*----------------------------------------------------------------------*
FORM calc_oee  USING p_areaid p_hname p_werks p_arbpl p_shiftid p_oeeid p_data.
  DATA: p_plan_prod    TYPE mengv13,
        p_oper_time    TYPE mengv13,
        p_tot_pieces   TYPE mengv13,
        p_run_rate     TYPE mengv13,
        p_run_rate_prd TYPE mengv13,
        p_good_pieces  TYPE mengv13,
        p_real_time    TYPE mengv13,
        p_avaibility   TYPE mengv13,
        p_performance  TYPE mengv13,
        p_quality      TYPE mengv13,
        p_oee          TYPE mengv13,
        p_productivit  TYPE mengv13.

  CLEAR: p_plan_prod,
         p_oper_time,
         p_tot_pieces,
         p_run_rate,
         p_good_pieces,
         p_real_time,
         p_avaibility,
         p_performance,
         p_quality,
         p_oee,
         p_productivit.

*Read value calculated
  PERFORM read_value_calc USING p_areaid p_hname p_werks p_arbpl p_oeeid p_shiftid p_data
                          CHANGING p_plan_prod p_oper_time p_tot_pieces p_run_rate p_run_rate_prd p_good_pieces
                                   p_real_time p_avaibility p_performance p_quality p_oee p_productivit.

*Calculate OEE
  IF p_avaibility IS NOT INITIAL AND p_performance IS NOT INITIAL AND p_quality IS NOT INITIAL.
    p_oee = ( p_avaibility / 100 ) * ( p_performance / 100 ) * ( p_quality / 100 ) * 100.
  ENDIF.

  IF p_oee IS NOT INITIAL.
*  Save value calculated
    PERFORM save_value_calc USING p_areaid p_hname p_werks p_arbpl p_oeeid p_shiftid p_data
                                  p_plan_prod p_oper_time p_tot_pieces p_run_rate p_run_rate_prd p_good_pieces
                                  p_real_time p_avaibility p_performance p_quality p_oee p_productivit.
  ENDIF.
ENDFORM.                    " CALC_OEE
*&---------------------------------------------------------------------*
*&      Form  CALC_PRODUCTIVITY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM calc_productivity USING p_areaid p_hname p_werks p_arbpl p_shiftid p_oeeid p_data.

  DATA: p_plan_prod    TYPE mengv13,
        p_oper_time    TYPE mengv13,
        p_tot_pieces   TYPE mengv13,
        p_run_rate     TYPE mengv13,
        p_run_rate_prd TYPE mengv13,
        p_good_pieces  TYPE mengv13,
        p_real_time    TYPE mengv13,
        p_avaibility   TYPE mengv13,
        p_performance  TYPE mengv13,
        p_quality      TYPE mengv13,
        p_oee          TYPE mengv13,
        p_productivit  TYPE mengv13.

  CLEAR: p_plan_prod,
         p_oper_time,
         p_tot_pieces,
         p_run_rate,
         p_good_pieces,
         p_real_time,
         p_avaibility,
         p_performance,
         p_quality,
         p_oee,
         p_productivit.

*Get data for productivity
  PERFORM get_data_productivity USING p_hname p_werks p_areaid p_arbpl p_data p_shiftid
                                CHANGING p_good_pieces p_run_rate_prd p_real_time.

  IF p_real_time NE 0.
    p_productivit = ( ( p_good_pieces * p_run_rate_prd ) / p_real_time ) * 100.
  ENDIF.

*Save value calculated
  PERFORM save_value_calc USING p_areaid p_hname p_werks p_arbpl p_oeeid p_shiftid p_data
                                p_plan_prod p_oper_time p_tot_pieces p_run_rate p_run_rate_prd p_good_pieces
                                p_real_time p_avaibility p_performance p_quality p_oee p_productivit.
ENDFORM.                    " CALC_PRODUCTIVITY
*&---------------------------------------------------------------------*
*&      Form  GET_DATA_PRODUCTIVITY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data_productivity USING p_hname p_werks p_areaid p_arbpl p_data p_shift
                           CHANGING p_good_pieces p_run_rate p_real_time.

  DATA: lt_afru TYPE TABLE OF afru.

  DATA: ld_tot_pieces TYPE mengv13,
        ld_arbid      TYPE cr_objid,
        ld_bmsch_tot  TYPE bmsch,
        ld_vgw03_tot  TYPE vgwrt.

  REFRESH lt_afru.
  CLEAR ld_arbid.

  IF gv_good_pieces IS INITIAL.
*  Get good pieces
    PERFORM get_good_pieces USING p_werks p_arbpl p_data p_shift
                            CHANGING p_good_pieces.
  ELSE.
    p_good_pieces = gv_good_pieces.
  ENDIF.

*Get id of workcenter
  SELECT SINGLE objid
    FROM crhd
    INTO ld_arbid
    WHERE arbpl EQ p_arbpl
    AND werks EQ p_werks.

*Get data from afru
  PERFORM get_tot_pieces USING ld_arbid p_werks p_data p_shift p_areaid
                         CHANGING ld_tot_pieces lt_afru.

  IF lt_afru[] IS NOT INITIAL.
*  Get labor time and routing basic quantity
    PERFORM calc_bmsch_vgw03_tot TABLES lt_afru
                                 USING ld_arbid p_werks p_areaid
                                 CHANGING ld_bmsch_tot ld_vgw03_tot.


    IF ld_bmsch_tot IS NOT INITIAL AND ld_vgw03_tot IS NOT INITIAL.
*    Ideal Run Rate - Productivity
      IF ld_bmsch_tot NE 0.
        p_run_rate = ld_vgw03_tot / ld_bmsch_tot.

*      Rounding number
        CALL FUNCTION 'ROUND'
          EXPORTING
            decimals      = 2
            input         = p_run_rate
            sign          = '+'
          IMPORTING
            output        = p_run_rate
          EXCEPTIONS
            input_invalid = 1
            overflow      = 2
            type_invalid  = 3
            OTHERS        = 4.

        IF sy-subrc <> 0.
*        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.

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
      ENDIF.
    ENDIF.
  ENDIF.

*Get real production time
  PERFORM get_real_time USING p_hname p_arbpl p_werks p_areaid p_data p_shift
                        CHANGING p_real_time.
ENDFORM.                    " GET_DATA_PRODUCTIVITY
*&---------------------------------------------------------------------*
*&      Form  GET_REAL_TIME
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_real_time USING p_hname p_arbpl p_werks p_areaid p_data p_shift
                   CHANGING p_real_time.

  DATA: ld_ism03    TYPE mengv13,
        ld_worktime TYPE zabsf_pp_e_worktime.

  CLEAR: ld_worktime,
         ld_ism03.

  IF p_areaid EQ c_mec OR  p_areaid EQ c_opt OR p_areaid EQ c_prd.
*  Get sum of real time
    SELECT SUM( ism03 )
      FROM zabsf_pp016
      INTO ld_ism03
     WHERE areaid  EQ p_areaid
       AND hname   EQ p_hname
       AND werks   EQ p_werks
       AND arbpl   EQ p_arbpl
       AND iebd    EQ p_data
       AND shiftid EQ p_shift.

*  Real production time
    p_real_time = ld_ism03.
  ELSE.
*  Get sum of real time
    SELECT SUM( worktime )
      FROM zabsf_pp046
      INTO ld_worktime
     WHERE areaid  EQ p_areaid
       AND hname   EQ p_hname
       AND werks   EQ p_werks
       AND rpoint  EQ p_arbpl
       AND datesr  EQ p_data
       AND shiftid EQ p_shift.

*  Real production time
    p_real_time = ld_worktime.
  ENDIF.


ENDFORM.                    " GET_REAL_TIME
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
  PERFORM fill_data_alv.

  IF gt_oee_alv[] IS NOT INITIAL.
*  Show data
    CALL SCREEN 100.
  ENDIF.
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
           oeeid   TYPE zabsf_pp_e_oeeid,
           shiftid TYPE zabsf_pp_e_shiftid,
           week    TYPE kweek,
           total   TYPE zabsf_pp_e_tweek,
         END OF ty_total.

  DATA: lt_oee_alv    TYPE TABLE OF zabsf_pp_s_data_alv,
        lt_area_desc  TYPE TABLE OF zabsf_pp000_t,
        lt_hname_desc TYPE TABLE OF ty_hname_desc,
        lt_werks_desc TYPE TABLE OF t001w,
        lt_arbpl_desc TYPE TABLE OF ty_arbpl_desc,
        lt_shift_desc TYPE TABLE OF zabsf_pp001_t,
        lt_oee_desc   TYPE TABLE OF zabsf_pp050_t,
        lt_total      TYPE TABLE OF ty_total.

  DATA: ls_oee_alv    TYPE zabsf_pp_s_data_alv,
        ls_area_desc  TYPE zabsf_pp000_t,
        ls_hname_desc TYPE ty_hname_desc,
        ls_werks_desc TYPE t001w,
        ls_arbpl_desc TYPE ty_arbpl_desc,
        ls_shift_desc TYPE zabsf_pp001_t,
        ls_oee_desc   TYPE zabsf_pp050_t,
        ls_total      TYPE ty_total,
        ld_day        TYPE scal-indicator.

  REFRESH: lt_area_desc,
           lt_hname_desc,
           lt_werks_desc,
           lt_arbpl_desc,
           lt_shift_desc,
           lt_oee_desc,
           lt_total.

  CLEAR: ls_oee_alv,
         gs_oee.

*Get data to get description
  LOOP AT gt_oee INTO gs_oee.
    CLEAR ls_oee_alv.
    MOVE-CORRESPONDING gs_oee TO ls_oee_alv.

    APPEND ls_oee_alv TO lt_oee_alv.
  ENDLOOP.

  DELETE ADJACENT DUPLICATES FROM lt_oee_alv.

*Get description for Area
  SELECT *
    FROM zabsf_pp000_t
    INTO CORRESPONDING FIELDS OF TABLE lt_area_desc
     FOR ALL ENTRIES IN lt_oee_alv
   WHERE areaid EQ lt_oee_alv-areaid
     AND spras EQ sy-langu.

*Get description for Hierarchy
  SELECT crhh~objid crhh~name crtx~ktext
    INTO CORRESPONDING FIELDS OF TABLE lt_hname_desc
    FROM crtx AS crtx
   INNER JOIN crhh AS crhh
      ON crhh~objty EQ crtx~objty
     AND crhh~objid EQ crtx~objid
     FOR ALL ENTRIES IN lt_oee_alv
   WHERE crhh~name  EQ lt_oee_alv-hname
     AND crhh~objty EQ 'H'
     AND crhh~werks EQ lt_oee_alv-werks
     AND crtx~spras EQ sy-langu.

*Get description for Plant
  SELECT *
    FROM t001w
    INTO CORRESPONDING FIELDS OF TABLE lt_werks_desc
     FOR ALL ENTRIES IN lt_oee_alv
   WHERE werks EQ lt_oee_alv-werks
     AND spras EQ sy-langu.

*Get description for Workcenter
  SELECT crhd~objid crhd~arbpl crtx~ktext
    INTO CORRESPONDING FIELDS OF TABLE lt_arbpl_desc
    FROM crtx AS crtx
   INNER JOIN crhd AS crhd
      ON crhd~objty EQ crtx~objty
     AND crhd~objid EQ crtx~objid
     FOR ALL ENTRIES IN lt_oee_alv
   WHERE crhd~arbpl EQ lt_oee_alv-arbpl
     AND crhd~objty EQ 'A'
     AND crhd~werks EQ lt_oee_alv-werks
     AND crtx~spras EQ sy-langu.

*Get description for Indicators OEE
  SELECT *
    FROM zabsf_pp050_t
    INTO CORRESPONDING FIELDS OF TABLE lt_oee_desc
     FOR ALL ENTRIES IN lt_oee_alv
   WHERE oeeid EQ lt_oee_alv-oeeid
     AND spras EQ sy-langu.

*Get description for Shift
  SELECT *
    FROM zabsf_pp001_t
    INTO CORRESPONDING FIELDS OF TABLE lt_shift_desc
     FOR ALL ENTRIES IN lt_oee_alv
   WHERE areaid  EQ lt_oee_alv-areaid
     AND werks   EQ lt_oee_alv-werks
     AND shiftid EQ lt_oee_alv-shiftid
     AND spras   EQ sy-langu.

*Get total week for Indicator OEE
  LOOP AT gt_oee INTO gs_oee.
*  Total indicators OEE
    READ TABLE lt_total INTO ls_total WITH KEY areaid  = gs_oee-areaid
                                               hname   = gs_oee-hname
                                               werks   = gs_oee-werks
                                               arbpl   = gs_oee-arbpl
                                               oeeid   = gs_oee-oeeid
                                               shiftid = gs_oee-shiftid
                                               week    = gs_oee-week.

    IF sy-subrc EQ 0.
*    Add value OEE to total
      ADD gs_oee-qtdoee TO ls_total-total.
      MODIFY TABLE lt_total FROM ls_total TRANSPORTING total.
    ELSE.
*    Insert new line in internal table total
      MOVE-CORRESPONDING gs_oee TO ls_total.
      ls_total-total = gs_oee-qtdoee.

      INSERT ls_total INTO TABLE lt_total.
    ENDIF.
  ENDLOOP.

*Fill glbal internal table to show data in alv
  CLEAR gs_oee.

  LOOP AT gt_oee INTO gs_oee.
    CLEAR: gs_oee_alv,
           ls_area_desc,
           ls_hname_desc,
           ls_werks_desc,
           ls_arbpl_desc,
           ls_shift_desc,
           ls_oee_desc,
           ld_day.


*>>>PAP - Correcção - 20.05.2015
    READ TABLE gt_oee_alv INTO gs_oee_alv WITH KEY areaid  = gs_oee-areaid
                                                   hname   = gs_oee-hname
                                                   werks   = gs_oee-werks
                                                   arbpl   = gs_oee-arbpl
                                                   oeeid   = gs_oee-oeeid
                                                   shiftid = gs_oee-shiftid
                                                   week    = gs_oee-week.

    IF sy-subrc EQ 0.
*    Get number day in week
      CALL FUNCTION 'DATE_COMPUTE_DAY'
        EXPORTING
          date = gs_oee-data
        IMPORTING
          day  = ld_day.

*    Put value indicator OEE in corresponding day in week
      CASE ld_day.
        WHEN 1.
          gs_oee_alv-vdata1 = gs_oee-qtdoee.

          MODIFY TABLE gt_oee_alv FROM gs_oee_alv TRANSPORTING vdata1.
        WHEN 2.
          gs_oee_alv-vdata2 = gs_oee-qtdoee.

          MODIFY TABLE gt_oee_alv FROM gs_oee_alv TRANSPORTING vdata2.
        WHEN 3.
          gs_oee_alv-vdata3 = gs_oee-qtdoee.

          MODIFY TABLE gt_oee_alv FROM gs_oee_alv TRANSPORTING vdata3.
        WHEN 4.
          gs_oee_alv-vdata4 = gs_oee-qtdoee.

          MODIFY TABLE gt_oee_alv FROM gs_oee_alv TRANSPORTING vdata4.
        WHEN 5.
          gs_oee_alv-vdata5 = gs_oee-qtdoee.

          MODIFY TABLE gt_oee_alv FROM gs_oee_alv TRANSPORTING vdata5.
        WHEN 6.
          gs_oee_alv-vdata6 = gs_oee-qtdoee.

          MODIFY TABLE gt_oee_alv FROM gs_oee_alv TRANSPORTING vdata6.
        WHEN 7.
          gs_oee_alv-vdata7 = gs_oee-qtdoee.

          MODIFY TABLE gt_oee_alv FROM gs_oee_alv TRANSPORTING vdata7.
      ENDCASE.
    ELSE.
*<<<PAP - Correcção
      MOVE-CORRESPONDING gs_oee TO gs_oee_alv.

*    Read description for Area
      READ TABLE lt_area_desc INTO ls_area_desc WITH KEY areaid = gs_oee-areaid.

      IF sy-subrc EQ 0.
*      Area description
        gs_oee_alv-area_desc = ls_area_desc-area_desc.
      ENDIF.

*    Read description for Hierarchy
      READ TABLE lt_hname_desc INTO ls_hname_desc WITH KEY name = gs_oee-hname.

      IF sy-subrc EQ 0.
*      Hierarchy description
        gs_oee_alv-hktext = ls_hname_desc-ktext.
      ENDIF.

*    Read description for Plant
      READ TABLE lt_werks_desc INTO ls_werks_desc WITH KEY werks = gs_oee-werks.

      IF sy-subrc EQ 0.
*     Plant description
        gs_oee_alv-name1 = ls_werks_desc-name1.
      ENDIF.

*    Read description for Workcenter
      READ TABLE lt_arbpl_desc INTO ls_arbpl_desc WITH KEY arbpl = gs_oee-arbpl.

      IF sy-subrc EQ 0.
*      Workcenter description
        gs_oee_alv-ktext = ls_arbpl_desc-ktext.
      ENDIF.

*    Read description for Indicator OEE
      READ TABLE lt_oee_desc INTO ls_oee_desc WITH KEY oeeid = gs_oee-oeeid.

      IF sy-subrc EQ 0.
*      Indicator OEE description
        gs_oee_alv-oeeid_desc = ls_oee_desc-oeeid_desc.
      ENDIF.

*    Read description for Shift
      READ TABLE lt_shift_desc INTO ls_shift_desc WITH KEY areaid  = gs_oee-areaid
                                                           werks   = gs_oee-werks
                                                           shiftid = gs_oee-shiftid.

      IF sy-subrc EQ 0.
*      Shift description
        gs_oee_alv-shift_desc = ls_shift_desc-shift_desc.
      ENDIF.

*    Get number day in week
      CALL FUNCTION 'DATE_COMPUTE_DAY'
        EXPORTING
          date = gs_oee-data
        IMPORTING
          day  = ld_day.

*    Put value indicator OEE in corresponding day in week
      CASE ld_day.
        WHEN 1.
          gs_oee_alv-vdata1 = gs_oee-qtdoee.
        WHEN 2.
          gs_oee_alv-vdata2 = gs_oee-qtdoee.
        WHEN 3.
          gs_oee_alv-vdata3 = gs_oee-qtdoee.
        WHEN 4.
          gs_oee_alv-vdata4 = gs_oee-qtdoee.
        WHEN 5.
          gs_oee_alv-vdata5 = gs_oee-qtdoee.
        WHEN 6.
          gs_oee_alv-vdata6 = gs_oee-qtdoee.
        WHEN 7.
          gs_oee_alv-vdata7 = gs_oee-qtdoee.
      ENDCASE.

*    Total value OEE for shift
      CLEAR ls_total.
      LOOP AT lt_total INTO ls_total WHERE areaid  EQ gs_oee-areaid
                                       AND hname   EQ gs_oee-hname
                                       AND werks   EQ gs_oee-werks
                                       AND arbpl   EQ gs_oee-arbpl
                                       AND oeeid   EQ gs_oee-oeeid
                                       AND shiftid EQ gs_oee-shiftid
                                       AND week    EQ gs_oee-week.

*      Total for shift
        ADD ls_total-total TO gs_oee_alv-tshift.
      ENDLOOP.

*    Total value OEE in week
      CLEAR ls_total.
      LOOP AT lt_total INTO ls_total WHERE areaid EQ gs_oee-areaid
                                       AND hname  EQ gs_oee-hname
                                       AND werks  EQ gs_oee-werks
                                       AND arbpl  EQ gs_oee-arbpl
                                       AND oeeid  EQ gs_oee-oeeid
                                       AND week   EQ gs_oee-week.

*      Total for shift
        ADD ls_total-total TO gs_oee_alv-tweek.
      ENDLOOP.

*     Data for ALV
      APPEND gs_oee_alv TO gt_oee_alv.
    ENDIF.
  ENDLOOP.

*>>>PAP - Correcção - 20.05.2015
  CLEAR gs_oee_alv.

  DATA: ld_days TYPE pea_scrdd.

  FIELD-SYMBOLS: <fs_oee_alv> TYPE zabsf_pp_s_data_alv.

  IF so_date[] IS NOT INITIAL AND pa_hist IS NOT INITIAL.

    CLEAR ld_days.

    CALL FUNCTION 'HR_HK_DIFF_BT_2_DATES'
      EXPORTING
        date1                       = so_date-high
        date2                       = so_date-low
        output_format               = '03'
      IMPORTING
        days                        = ld_days
      EXCEPTIONS
        overflow_long_years_between = 1
        invalid_dates_specified     = 2
        OTHERS                      = 3.

    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.


    LOOP AT gt_oee_alv ASSIGNING <fs_oee_alv>.

      IF ld_days IS NOT INITIAL.
        <fs_oee_alv>-tshift = <fs_oee_alv>-tshift / ld_days.
        <fs_oee_alv>-tweek = <fs_oee_alv>-tweek / ld_days.
      ENDIF.
    ENDLOOP.

  ENDIF.
*<<<PAP - Correcção - 20.05.2015
ENDFORM.                    " FILL_DATA_ALV
*&---------------------------------------------------------------------*
*&      Form  GET_DATA_DB
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data_db .
  DATA: lt_zabsf_pp051 TYPE TABLE OF zabsf_pp051.

  DATA: ls_zabsf_pp051 TYPE zabsf_pp051.

  REFRESH lt_zabsf_pp051.

*Get all data saved in database
  SELECT *
    FROM zabsf_pp051
    INTO CORRESPONDING FIELDS OF TABLE lt_zabsf_pp051
    WHERE areaid  EQ pa_area
      AND hname   IN so_hname
      AND werks   EQ pa_werks
      AND arbpl   IN so_arbpl
      AND oeeid   IN so_oeeid
      AND shiftid IN so_shift
      AND data    IN so_date.

  IF lt_zabsf_pp051[] IS NOT INITIAL.
*  Pass data to global internal table
    gt_oee[] = lt_zabsf_pp051[].
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
*&      Form  SAVE_VALUE_CALC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_AREAID  text
*      -->P_P_HNAME  text
*      -->P_P_WERKS  text
*      -->P_P_ARBPL  text
*      -->P_P_OEEID  text
*      -->P_P_SHIFTID  text
*      -->P_P_DATA  text
*----------------------------------------------------------------------*
FORM save_value_calc  USING p_areaid p_hname p_werks p_arbpl p_oeeid p_shiftid p_data
                            p_plan_prod p_oper_time p_tot_pieces p_run_rate p_run_rate_prd p_good_pieces
                            p_real_time p_avaibility p_performance p_quality p_oee p_productivit.

  DATA ls_calc_val TYPE ty_calc_value.

  CLEAR ls_calc_val.

  READ TABLE gt_calc_val INTO ls_calc_val WITH KEY areaid  = p_areaid
                                                   hname   = p_hname
                                                   werks   = p_werks
                                                   arbpl   = p_arbpl
                                                   shiftid = p_shiftid
                                                   data    = p_data.

  IF sy-subrc EQ 0.
    IF p_plan_prod IS NOT INITIAL.
      ls_calc_val-plan_prod = p_plan_prod.
    ENDIF.
    IF p_oper_time IS NOT INITIAL.
      ls_calc_val-oper_time = p_oper_time.
    ENDIF.

    IF p_tot_pieces IS NOT INITIAL.
      ls_calc_val-tot_pieces = p_tot_pieces.
    ENDIF.

    IF p_run_rate IS NOT INITIAL.
      ls_calc_val-run_rate = p_run_rate.
    ENDIF.

    IF p_run_rate_prd IS NOT INITIAL.
      ls_calc_val-run_rate_prd = p_run_rate_prd.
    ENDIF.

    IF p_good_pieces IS NOT INITIAL.
      ls_calc_val-good_pieces = p_good_pieces.
    ENDIF.

    IF p_real_time IS NOT INITIAL.
      ls_calc_val-real_time = p_real_time.
    ENDIF.

    IF p_avaibility IS NOT INITIAL.
      ls_calc_val-avaibility = p_avaibility .
    ENDIF.

    IF p_performance IS NOT INITIAL.
      ls_calc_val-performance = p_performance.
    ENDIF.

    IF p_quality IS NOT INITIAL.
      ls_calc_val-quality = p_quality.
    ENDIF.

    IF p_oee IS NOT INITIAL.
      ls_calc_val-oee = p_oee.
    ENDIF.

    IF p_productivit IS NOT INITIAL.
      ls_calc_val-productivit = p_productivit.
    ENDIF.

    MODIFY TABLE gt_calc_val FROM ls_calc_val.
  ELSE.
    ls_calc_val-areaid = p_areaid.
    ls_calc_val-hname = p_hname.
    ls_calc_val-werks = p_werks.
    ls_calc_val-arbpl = p_arbpl.
    ls_calc_val-shiftid = p_shiftid.
    ls_calc_val-data = p_data.

    IF p_plan_prod IS NOT INITIAL.
      ls_calc_val-plan_prod = p_plan_prod.
    ENDIF.
    IF p_oper_time IS NOT INITIAL.
      ls_calc_val-oper_time = p_oper_time.
    ENDIF.

    IF p_tot_pieces IS NOT INITIAL.
      ls_calc_val-tot_pieces = p_tot_pieces.
    ENDIF.

    IF p_run_rate IS NOT INITIAL.
      ls_calc_val-run_rate = p_run_rate.
    ENDIF.

    IF p_run_rate_prd IS NOT INITIAL.
      ls_calc_val-run_rate_prd = p_run_rate_prd.
    ENDIF.

    IF p_good_pieces IS NOT INITIAL.
      ls_calc_val-good_pieces = p_good_pieces.
    ENDIF.

    IF p_real_time IS NOT INITIAL.
      ls_calc_val-real_time = p_real_time.
    ENDIF.

    IF p_avaibility IS NOT INITIAL.
      ls_calc_val-avaibility = p_avaibility .
    ENDIF.

    IF p_performance IS NOT INITIAL.
      ls_calc_val-performance = p_performance.
    ENDIF.

    IF p_quality IS NOT INITIAL.
      ls_calc_val-quality = p_quality.
    ENDIF.

    IF p_oee IS NOT INITIAL.
      ls_calc_val-oee = p_oee.
    ENDIF.

    IF p_productivit IS NOT INITIAL.
      ls_calc_val-productivit = p_productivit.
    ENDIF.

    APPEND ls_calc_val TO gt_calc_val.
  ENDIF.
ENDFORM.                    " SAVE_VALUE_CALC
*&---------------------------------------------------------------------*
*&      Form  READ_VALUE_CALC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_<FS_OEE>_AREAID  text
*      -->P_<FS_OEE>_HNAME  text
*      -->P_<FS_OEE>_WERKS  text
*      -->P_<FS_OEE>_ARBPL  text
*      -->P_<FS_OEE>_OEEID  text
*      -->P_<FS_OEE>_SHIFTID  text
*      -->P_<FS_OEE>_DATA  text
*      <--P_GV_PLAN_PROD  text
*      <--P_GV_OPER_TIME  text
*      <--P_GV_TOT_PIECES  text
*      <--P_GV_RUN_RATE  text
*      <--P_GV_GOOD_PIECES  text
*      <--P_GV_REAL_TIME  text
*      <--P_GV_AVAIBILITY  text
*----------------------------------------------------------------------*
FORM read_value_calc USING p_areaid p_hname p_werks p_arbpl p_oeeid p_shiftid p_data
                     CHANGING p_plan_prod p_oper_time p_tot_pieces p_run_rate p_run_rate_prd p_good_pieces
                              p_real_time p_avaibility p_performance p_quality p_oee p_productivit.

  DATA ls_calc_val TYPE ty_calc_value.

  CLEAR ls_calc_val.

*Read value calculated
  READ TABLE gt_calc_val INTO ls_calc_val WITH KEY areaid  = p_areaid
                                                   hname   = p_hname
                                                   werks   = p_werks
                                                   arbpl   = p_arbpl
                                                   shiftid = p_shiftid
                                                   data    = p_data.

  IF sy-subrc EQ 0.
    IF ls_calc_val-plan_prod
       IS NOT INITIAL.
      p_plan_prod = ls_calc_val-plan_prod.
    ENDIF.

    IF ls_calc_val-oper_time IS NOT INITIAL.
      p_oper_time = ls_calc_val-oper_time.
    ENDIF.

    IF ls_calc_val-tot_pieces IS NOT INITIAL.
      p_tot_pieces = ls_calc_val-tot_pieces.
    ENDIF.

    IF ls_calc_val-run_rate IS NOT INITIAL.
      p_run_rate = ls_calc_val-run_rate.
    ENDIF.

    IF ls_calc_val-run_rate_prd IS NOT INITIAL.
      p_run_rate_prd = ls_calc_val-run_rate_prd.
    ENDIF.

    IF ls_calc_val-good_pieces IS NOT INITIAL.
      p_good_pieces = ls_calc_val-good_pieces.
    ENDIF.

    IF ls_calc_val-real_time IS NOT INITIAL.
      p_real_time = ls_calc_val-real_time.
    ENDIF.

    IF ls_calc_val-avaibility IS NOT INITIAL.
      p_avaibility = ls_calc_val-avaibility.
    ENDIF.

    IF ls_calc_val-performance IS NOT INITIAL.
      p_performance = ls_calc_val-performance.
    ENDIF.

    IF ls_calc_val-quality IS NOT INITIAL.
      p_quality = ls_calc_val-quality.
    ENDIF.

    IF ls_calc_val-oee IS NOT INITIAL.
      p_oee = ls_calc_val-oee.
    ENDIF.

    IF ls_calc_val-productivit IS NOT INITIAL.
      p_productivit = ls_calc_val-productivit.
    ENDIF.
  ENDIF.
ENDFORM.                    " READ_VALUE_CALC
*&---------------------------------------------------------------------*
*&      Form  GET_DATA_AFRU
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data_afru .
  DATA: lt_crhd TYPE TABLE OF crhd,
        wa_crhd TYPE crhd.

  DATA: r_arbpl  TYPE RANGE OF objid,
        wa_arbpl LIKE LINE OF r_arbpl.

*Get workcenter id
  SELECT objid
    FROM crhd
    INTO CORRESPONDING FIELDS OF TABLE lt_crhd
    WHERE arbpl IN so_arbpl
    AND werks EQ pa_werks
    AND objty EQ 'A'.

  IF lt_crhd[] IS NOT INITIAL.
    LOOP AT lt_crhd INTO wa_crhd.
      wa_arbpl-option = 'EQ'.
      wa_arbpl-sign = 'I'.
      wa_arbpl-low = wa_crhd-objid.

      APPEND wa_arbpl TO r_arbpl.
    ENDLOOP.
  ENDIF.

  IF pa_area EQ c_mec  OR pa_area EQ c_opt OR pa_area EQ c_prd.
*  Get confirmation for day, shift and workcenter
    SELECT *
      FROM afru
      INTO CORRESPONDING FIELDS OF TABLE gt_afru
      WHERE budat    EQ pa_date
        AND arbid    IN r_arbpl
        AND werks    EQ pa_werks
        AND kaptprog IN so_shift
        AND stokz    EQ space
        AND stzhl    EQ space.
  ELSE.
    PERFORM get_afru_mont TABLES r_arbpl.
  ENDIF.
*DATA gs_afru TYPE afru.

*SELECT SINGLE budat arbid werks isdd kaptprog stokz stzhl
*         lmnga rmnga xmnga
*    FROM afru
*    INTO CORRESPONDING FIELDS OF gs_afru
*    WHERE budat    EQ sy-datum
**      AND arbid    IN r_arbpl
*      AND werks    EQ pa_werks
*      AND isdd     EQ sy-datum
**      AND kaptprog IN so_shift
*      AND stokz    EQ space
*      AND stzhl    EQ space.
ENDFORM.                    " GET_DATA_AFRU
*&---------------------------------------------------------------------*
*&      Form  GET_AFRU_MONT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_R_ARBPL  text
*----------------------------------------------------------------------*
FORM get_afru_mont  TABLES p_arbpl TYPE STANDARD TABLE.
  DATA: lt_mkpf       TYPE TABLE OF mkpf,
        lt_mkpf_aux   TYPE TABLE OF mkpf,
        lt_blpp_mblnr TYPE TABLE OF blpp,
        lt_blpp_afru  TYPE TABLE OF blpp,
        lt_blpk       TYPE TABLE OF blpk.

  DATA: ls_mkpf       TYPE mkpf,
        ls_blpp_mblnr TYPE blpp,
        ls_blpp_afru  TYPE blpp,
        ls_shift      LIKE so_shift.

  FIELD-SYMBOLS: <fs_afru> TYPE afru.


  REFRESH: lt_mkpf,
           lt_mkpf_aux,
           lt_blpp_mblnr,
           lt_blpp_afru,
           lt_blpk.

  CLEAR: ls_mkpf,
         ls_blpp_mblnr,
         ls_blpp_afru,
         ls_shift.

*Get all material document created in day
  LOOP AT so_shift INTO ls_shift.
    SELECT *
      FROM mkpf
      INTO CORRESPONDING FIELDS OF TABLE lt_mkpf_aux
     WHERE mjahr EQ pa_date(4)
       AND bldat EQ pa_date
       AND bktxt EQ ls_shift-low
       AND vgart EQ c_vgart
       AND blart EQ c_blart
       AND blaum EQ c_blaum.

    INSERT LINES OF lt_mkpf_aux INTO TABLE lt_mkpf.
  ENDLOOP.

  SORT lt_mkpf BY mblnr bktxt.

  DELETE ADJACENT DUPLICATES FROM lt_mkpf.

  IF lt_mkpf[] IS NOT INITIAL.
*  Get Confirmation number of material document
    SELECT *
      FROM blpp
      INTO CORRESPONDING FIELDS OF TABLE lt_blpp_mblnr
       FOR ALL ENTRIES IN lt_mkpf
     WHERE belnr EQ lt_mkpf-mblnr.

    IF lt_blpp_mblnr[] IS NOT INITIAL.
*    Get confirmation number of material document valid for day
      SELECT *
        FROM blpk
        INTO CORRESPONDING FIELDS OF TABLE lt_blpk
         FOR ALL ENTRIES IN lt_blpp_mblnr
       WHERE prtnr EQ lt_blpp_mblnr-prtnr
         AND datum EQ pa_date.

      IF lt_blpk[] IS NOT INITIAL.
*      Get confirmation number for afru
        SELECT *
          FROM blpp
          INTO CORRESPONDING FIELDS OF TABLE lt_blpp_afru
          FOR ALL ENTRIES IN lt_blpk
          WHERE prtnr EQ lt_blpk-prtnr
           AND belnr EQ space
           AND rueck NE '0000000000'
           AND rmzhl NE '00000000'.

        IF lt_blpp_afru[] IS NOT INITIAL.
*        Get confirmation
          SELECT  afru~rueck afru~rmzhl afru~budat plpo~arbid afru~werks afru~isdd
                  afru~stokz afru~stzhl afru~lmnga afru~rmnga afru~xmnga afru~aufpl
                  afru~aplzl afru~vornr
            INTO CORRESPONDING FIELDS OF TABLE gt_afru
            FROM afru AS afru
           INNER JOIN afvc AS afvc
              ON afvc~aufpl EQ afru~aufpl
             AND afvc~aplzl EQ afru~aplzl
           INNER JOIN plpo AS plpo
              ON plpo~plnnr EQ afvc~plnnr
             AND plpo~plnkn EQ afvc~plnkn
             AND plpo~zaehl EQ afvc~zaehl
             AND plpo~plnty EQ afvc~plnty
             AND plpo~vornr EQ afvc~vornr
             FOR ALL ENTRIES IN lt_blpp_afru
           WHERE afru~rueck EQ lt_blpp_afru-rueck
             AND afru~budat EQ pa_date
             AND afru~werks EQ pa_werks
             AND afru~stokz EQ space
             AND afru~stzhl EQ space
             AND plpo~arbid IN p_arbpl.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.

  IF gt_afru[] IS NOT INITIAL.
    LOOP AT gt_afru ASSIGNING <fs_afru>.
      CLEAR: ls_mkpf,
             ls_blpp_mblnr,
             ls_blpp_afru.

      READ TABLE lt_blpp_afru INTO ls_blpp_afru WITH KEY rueck = <fs_afru>-rueck
                                                         rmzhl = <fs_afru>-rmzhl.

      IF sy-subrc EQ 0.
        READ TABLE lt_blpp_mblnr INTO ls_blpp_mblnr WITH KEY prtnr = ls_blpp_afru-prtnr.

        IF sy-subrc EQ 0.
          READ TABLE lt_mkpf INTO ls_mkpf WITH KEY mblnr = ls_blpp_mblnr-belnr.

          IF sy-subrc EQ 0.
            <fs_afru>-kaptprog = ls_mkpf-bktxt.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDIF.
ENDFORM.                    " GET_AFRU_MONT
