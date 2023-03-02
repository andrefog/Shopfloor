*----------------------------------------------------------------------*
***INCLUDE ZABSF_DASHBOARD_JOB_F01.
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  CREATE_DATA_RANGE
*&---------------------------------------------------------------------*
FORM create_data_range .
  IF p_date IS INITIAL.
    p_date = sy-datum.
  ENDIF.

  IF p_30day EQ abap_true.
    CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
      EXPORTING
        date      = p_date
        days      = 0
        months    = 1
        signum    = '-'
        years     = 0
      IMPORTING
        calc_date = gv_date_past.
  ELSE.
    CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
      EXPORTING
        date      = p_date
        days      = 1
        months    = 0
        signum    = '-'
        years     = 0
      IMPORTING
        calc_date = gv_date_past.
  ENDIF.

  CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
    EXPORTING
      date      = p_date
      days      = 1
      months    = 0
      signum    = '+'
      years     = 0
    IMPORTING
      calc_date = gv_date_future.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  SELECT_DATA
*&---------------------------------------------------------------------*
FORM select_data .
  PERFORM:
    select_areas,
    select_hierarchies,
    select_workcenters,
    select_shifts,
    select_confirmations,
    select_stops,
    select_time,
    select_operations,
    select_tasks,
    select_rework_repetitive.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  SELECT_AREAS
*&---------------------------------------------------------------------*
FORM select_areas .
  SELECT areaid
    FROM zabsf_pp008
    INTO TABLE gt_areas
    WHERE werks EQ p_werks
      AND begda LE p_date
      AND endda GE p_date.

  IF gt_areas[] IS INITIAL.
    MESSAGE e167(zabsf_pp) WITH p_werks.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  SELECT_HIERARCHIES
*&---------------------------------------------------------------------*
FORM select_hierarchies .
  CHECK gt_areas[] IS NOT INITIAL.

  " Get all hierarchies for area
  SELECT areaid hname
    FROM zabsf_pp002
    INTO TABLE gt_hierarchies
    FOR ALL ENTRIES IN gt_areas
   WHERE areaid EQ gt_areas-areaid
     AND werks  EQ p_werks
     AND hname  IN s_hname
     AND begda  LE p_date
     AND endda  GE p_date.

  SORT gt_hierarchies BY areaid hname.
  DELETE ADJACENT DUPLICATES FROM gt_hierarchies COMPARING areaid hname.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  SELECT_WORKCENTERS
*&---------------------------------------------------------------------*
FORM select_workcenters.
  CHECK gt_hierarchies[] IS NOT INITIAL.

  SELECT objty, objid, name
    FROM crhh
    INTO TABLE @DATA(lt_crhh)
    FOR ALL ENTRIES IN @gt_hierarchies
    WHERE name  EQ @gt_hierarchies-hname
      AND werks EQ @p_werks.
  CHECK lt_crhh[] IS NOT INITIAL.

  SELECT objty_hy, objid_hy, objty_ho, objid_ho
    FROM crhs
    INTO TABLE @DATA(lt_crhs)
    FOR ALL ENTRIES IN @lt_crhh
    WHERE objty_hy EQ @lt_crhh-objty
      AND objid_hy EQ @lt_crhh-objid.
  CHECK lt_crhs[] IS NOT INITIAL.

  " Get workcenter ID and description
  SELECT objty, objid, arbpl, werks, kapid
    FROM crhd
    INTO TABLE @DATA(lt_crhd)
    FOR ALL ENTRIES IN @lt_crhs
    WHERE objty EQ @lt_crhs-objty_ho
      AND objid EQ @lt_crhs-objid_ho
      AND arbpl IN @s_arbpl.
  CHECK lt_crhd[] IS NOT INITIAL.

  SELECT arbpl
    FROM zabsf_pp013
    INTO TABLE @DATA(lt_pp013)
    FOR ALL ENTRIES IN @gt_hierarchies
    WHERE areaid EQ @gt_hierarchies-areaid
      AND werks  EQ @p_werks
      AND arbpl  IN @s_arbpl
      AND endda  GE @p_date
      AND begda  LE @p_date.

  SELECT kapid aznor begzt endzt ngrad pause kapter
    FROM kako
    INTO TABLE gt_kako
    FOR ALL ENTRIES IN lt_crhd
    WHERE kapid  EQ lt_crhd-kapid.

  LOOP AT lt_crhd ASSIGNING FIELD-SYMBOL(<ls_crhd>).
    CHECK line_exists( gt_kako[ kapid = <ls_crhd>-kapid kapter = abap_true ] )
      AND line_exists( lt_pp013[ arbpl = <ls_crhd>-arbpl ] ).

    DATA(ls_crhs)  = VALUE #( lt_crhs[ objty_ho = <ls_crhd>-objty objid_ho = <ls_crhd>-objid ] OPTIONAL ).
    DATA(ls_crhh)  = VALUE #( lt_crhh[ objty = ls_crhs-objty_hy objid = ls_crhs-objid_hy ] OPTIONAL ).
    DATA(ls_pp002) = VALUE #( gt_hierarchies[ hname = ls_crhh-name ] OPTIONAL ).

    APPEND
      VALUE #(
        areaid = ls_pp002-areaid
        hname  = ls_pp002-hname
        arbpl = <ls_crhd>-arbpl
        objid = <ls_crhd>-objid
        kapid = <ls_crhd>-kapid
      ) TO gt_workcenters.

  ENDLOOP.
ENDFORM.                    " GET_WORKCENTERS_TABLE

*&---------------------------------------------------------------------*
*&      Form  SELECT_SHIFTS
*&---------------------------------------------------------------------*
FORM select_shifts .
  CHECK gt_areas[] IS NOT INITIAL.

  " Get shifts for area
  SELECT areaid shiftid
    FROM zabsf_pp001
    INTO TABLE gt_shifts
    FOR ALL ENTRIES IN gt_areas
   WHERE areaid  EQ gt_areas-areaid
     AND werks   EQ p_werks
     AND shiftid IN s_shift
     AND begda   LE gv_date_future
     AND endda   GE gv_date_past.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  SELECT_CONFIRMATIONS
*&---------------------------------------------------------------------*
FORM select_confirmations .
  CHECK gt_workcenters[] IS NOT INITIAL.

  " Get confirmations
  SELECT rueck arbid lmnga xmnga rmnga erzet isdd aufpl aplzl vornr kaptprog
    FROM afru
    INTO TABLE gt_afru
    FOR ALL ENTRIES IN gt_workcenters
    WHERE arbid    EQ gt_workcenters-objid
      AND werks    EQ p_werks
      AND stokz    EQ space
      AND stzhl    EQ space
      AND isdd     BETWEEN gv_date_past AND gv_date_future
      AND kaptprog NE space
      AND kaptprog IN s_shift.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  SELECT_STOPS
*&---------------------------------------------------------------------*
FORM select_stops .
  CHECK gt_workcenters[] IS NOT INITIAL.

  " Get stop time of day for workcenter
  SELECT o~areaid o~hname o~arbpl o~datesr o~shiftid o~time
         o~endda o~timeend o~stoptime l~motivetype
    FROM zabsf_pp010 AS o
      INNER JOIN zabsf_pp011 AS l
      ON l~areaid   EQ o~areaid AND
         l~werks    EQ o~werks AND
         l~arbpl    EQ o~arbpl AND
         l~stprsnid EQ o~stprsnid AND
         l~endda    GE o~datesr AND
         l~begda    LE o~datesr
    INTO TABLE gt_stops
    FOR ALL ENTRIES IN gt_workcenters
    WHERE o~areaid  EQ gt_workcenters-areaid
      AND o~hname   EQ gt_workcenters-hname
      AND o~shiftid IN s_shift
      AND o~werks   EQ p_werks
      AND o~arbpl   EQ gt_workcenters-arbpl
      AND o~datesr  LE gv_date_future
      AND ( o~endda GE gv_date_past OR
            o~endda EQ space ).
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  SELECT_TIME
*&---------------------------------------------------------------------*
FORM select_time.
  CHECK gt_workcenters[] IS NOT INITIAL.

  DATA(lt_fae) = gt_workcenters[].
  SORT lt_fae BY areaid hname arbpl.
  DELETE ADJACENT DUPLICATES FROM lt_fae COMPARING areaid hname arbpl.

  DATA(lt_pp016_fae) = lt_fae.
  DELETE lt_pp016_fae
    WHERE areaid NE gc_mec
      AND areaid NE gc_opt.

  IF lt_pp016_fae[] IS NOT INITIAL.
    " Get sum of real time
    SELECT areaid hname arbpl isdd AS datesr isdz AS time shiftid ism03 AS worktime
      FROM zabsf_pp016
      INTO TABLE gt_times
      FOR ALL ENTRIES IN lt_pp016_fae
      WHERE areaid  EQ lt_pp016_fae-areaid
        AND hname   EQ lt_pp016_fae-hname
        AND werks   EQ p_werks
        AND arbpl   EQ lt_pp016_fae-arbpl
        AND shiftid IN s_shift
        AND iebd    BETWEEN gv_date_past AND gv_date_future.

    DATA(lv_begts) = zabsf_pp_cl_utils=>convert_date_to_timestamp( gv_date_past ).
    DATA(lv_endts) = zabsf_pp_cl_utils=>convert_date_to_timestamp( iv_date = gv_date_future iv_time = '235959' ).

    SELECT arbpl, shiftid, begts, endts
      FROM zabsf_pp116
      INTO TABLE @DATA(lt_extra_times)
      FOR ALL ENTRIES IN @lt_pp016_fae
      WHERE arbpl   EQ @lt_pp016_fae-arbpl
        AND shiftid IN @s_shift
        AND begts   LE @lv_endts
        AND endts   GE @lv_begts.

    LOOP AT lt_extra_times ASSIGNING FIELD-SYMBOL(<ls_extra_time>).
      DATA(ls_workcenter) = gt_workcenters[ arbpl = <ls_extra_time>-arbpl ].
      DATA(lv_worktime) =
        cl_abap_tstmp=>subtract(
          tstmp1 = <ls_extra_time>-endts
          tstmp2 = <ls_extra_time>-begts ) / gc_minute.

      zabsf_pp_cl_utils=>convert_timestamp_to_date(
        EXPORTING iv_timestamp = <ls_extra_time>-begts
        IMPORTING ev_time = DATA(lv_time)
        RECEIVING rv_date = DATA(lv_date) ).

      APPEND
        VALUE #(
          areaid   = ls_workcenter-areaid
          hname    = ls_workcenter-hname
          arbpl    = ls_workcenter-arbpl
          date     = lv_date
          time     = lv_time
          shiftid  = <ls_extra_time>-shiftid
          worktime = lv_worktime
        ) TO gt_times.
    ENDLOOP.
  ENDIF.

  DATA(lt_pp046_fae) = lt_fae.
  DELETE lt_pp046_fae
    WHERE areaid EQ gc_mec
      OR  areaid EQ gc_opt.

  IF lt_pp046_fae[] IS NOT INITIAL.
    " Get sum of real time
    SELECT areaid hname rpoint AS arbpl datesr AS date begtime AS time shiftid worktime
      FROM zabsf_pp046
      INTO TABLE gt_times
      FOR ALL ENTRIES IN lt_pp046_fae
     WHERE areaid  EQ lt_pp046_fae-areaid
       AND hname   EQ lt_pp046_fae-hname
       AND werks   EQ p_werks
       AND rpoint  EQ lt_pp046_fae-arbpl
       AND shiftid IN s_shift
       AND datesr  BETWEEN gv_date_past AND gv_date_future.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  SELECT_OPERATIONS
*&---------------------------------------------------------------------*
FORM select_operations .
  CHECK gt_afru[] IS NOT INITIAL.

  DATA(lt_fae) = gt_afru.
  SORT lt_fae BY aufpl vornr.
  DELETE ADJACENT DUPLICATES FROM lt_fae COMPARING aufpl vornr.

  SELECT aufpl aplzl plnkn plnty plnnr zaehl vornr arbid rueck
    FROM afvc
    INTO TABLE gt_afvc
    FOR ALL ENTRIES IN lt_fae
    WHERE aufpl EQ lt_fae-aufpl
      AND vornr LE lt_fae-vornr
      AND werks EQ p_werks.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  SELECT_TASKS
*&---------------------------------------------------------------------*
FORM select_tasks .
  CHECK gt_afvc[] IS NOT INITIAL.

  SELECT plnty plnnr plnkn zaehl vornr bmsch vgw03
    FROM plpo
    INTO TABLE gt_plpo
    FOR ALL ENTRIES IN gt_afvc
    WHERE plnty EQ gt_afvc-plnty
      AND plnnr EQ gt_afvc-plnnr
      AND plnkn EQ gt_afvc-plnkn
      AND zaehl EQ gt_afvc-zaehl
      AND vornr EQ gt_afvc-vornr.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  SELECT_REWORK_REPETITIVE
*&---------------------------------------------------------------------*
FORM select_rework_repetitive .
  CHECK gt_workcenters[] IS NOT INITIAL.

  DATA(lt_pp049_fae) = gt_workcenters[].
  SORT lt_pp049_fae BY areaid arbpl.
  DELETE ADJACENT DUPLICATES FROM lt_pp049_fae COMPARING areaid arbpl.

  SELECT areaid rpoint data time shiftid rework
    FROM zabsf_pp049
    INTO TABLE gt_rework
    FOR ALL ENTRIES IN lt_pp049_fae
   WHERE areaid  EQ lt_pp049_fae-areaid
     AND rpoint  EQ lt_pp049_fae-arbpl
     AND shiftid IN s_shift
     AND data    BETWEEN gv_date_past AND gv_date_future.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  GET_WEEK_DAY
*&---------------------------------------------------------------------*
FORM get_week_day  CHANGING cs_date TYPE scal.
  CALL FUNCTION 'DATE_GET_WEEK'
    EXPORTING
      date         = cs_date-date
    IMPORTING
      week         = cs_date-week
    EXCEPTIONS
      date_invalid = 1
      OTHERS       = 2.

  IF sy-subrc IS NOT INITIAL.
    CALL METHOD zcl_lp_pp_sf_log=>add_message
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
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  CALC_AVAILABILY
*&---------------------------------------------------------------------*
FORM calc_availabily CHANGING cs_calc_val TYPE ty_calc_value.
  " Get data for availabily
  PERFORM get_data_availabily CHANGING cs_calc_val.

  " Calculate value of indicator OEE
  IF cs_calc_val-plan_prod NE 0.
    cs_calc_val-availability = ( cs_calc_val-oper_time / cs_calc_val-plan_prod ) * 100.
  ENDIF.
ENDFORM.                    " CALC_AVAILABILY

*&---------------------------------------------------------------------*
*&      Form  GET_DATA_AVAILABILY
*&---------------------------------------------------------------------*
FORM get_data_availabily CHANGING cs_calc_val TYPE ty_calc_value.
  DATA:
    lv_capacity  TYPE kapazitaet,
    lv_einzt     TYPE kapeinzt,
    lv_stop_area TYPE zlp_sf_e_stoptime,
    lv_worktime  TYPE mengv13.

  CONSTANTS lc_sec_day TYPE kapbegzt VALUE 86400.

  DATA(ls_kako) = VALUE #( gt_kako[ kapid = cs_calc_val-kapid ] OPTIONAL ).

  IF ls_kako-begzt GT 0 OR ls_kako-endzt GT 0.
    " Capacity - Time
    IF ls_kako-endzt GE ls_kako-begzt.
      lv_capacity = ls_kako-endzt - ls_kako-begzt.

      IF lv_capacity = 0.
        lv_capacity = lc_sec_day.
      ENDIF.
    ELSE.
      lv_capacity = lc_sec_day - ls_kako-begzt + ls_kako-endzt.
    ENDIF.

    IF lv_capacity GT ls_kako-pause.
      " Worktime
      lv_einzt = ( lv_capacity - ls_kako-pause ) * ls_kako-ngrad / 100.

      lv_einzt = lv_einzt * ls_kako-aznor.

      lv_worktime = lv_einzt / gc_minute.
    ELSE.
      lv_worktime = 0.
    ENDIF.
  ENDIF.

  " Get all stops of the day for Area
  DATA(lv_prev_day) = CONV dats( cs_calc_val-date - 1 ).

  LOOP AT gt_stops ASSIGNING FIELD-SYMBOL(<ls_stop>)
    WHERE ( areaid  EQ cs_calc_val-areaid
      AND hname   EQ cs_calc_val-hname
      AND arbpl   EQ cs_calc_val-arbpl
      AND shiftid EQ cs_calc_val-shiftid
      AND datesr  LT cs_calc_val-date
      AND ( endda GT lv_prev_day OR endda IS NOT INITIAL ) ).

    " Stop start on/before previous date
    IF <ls_stop>-datesr LE lv_prev_day.
      IF <ls_stop>-datesr LT lv_prev_day OR
         <ls_stop>-time   LT zabsf_pp_cl_dashboard=>gc_start_time.
        DATA(lv_begzt) = zabsf_pp_cl_dashboard=>gc_start_time.
      ELSE.
        lv_begzt = <ls_stop>-time.
      ENDIF.

      IF <ls_stop>-endda GT cs_calc_val-date.
        DATA(lv_endzt) = CONV endzt( '240000' ).
      ELSE.
        lv_endzt = <ls_stop>-timeend.
      ENDIF.

      PERFORM add_stop_time
        USING ls_kako lv_begzt lv_endzt
        CHANGING lv_stop_area.
    ENDIF.

    " Stop finish on/after actual date
    IF <ls_stop>-endda GE cs_calc_val-date.
      IF <ls_stop>-endda GT cs_calc_val-date OR
         <ls_stop>-timeend GT zabsf_pp_cl_dashboard=>gc_start_time.
        lv_endzt = zabsf_pp_cl_dashboard=>gc_start_time.
      ELSE.
        lv_endzt = <ls_stop>-timeend.
      ENDIF.

      IF <ls_stop>-datesr LT lv_prev_day.
        lv_begzt = '000000'.
      ELSE.
        lv_begzt = <ls_stop>-time.
      ENDIF.

      PERFORM add_stop_time
        USING ls_kako lv_begzt lv_endzt
        CHANGING lv_stop_area.
    ENDIF.
  ENDLOOP.

  " Planned Production Time
  cs_calc_val-plan_prod = lv_worktime.
  " Operating Time
  cs_calc_val-oper_time = cs_calc_val-plan_prod - lv_stop_area.

  IF cs_calc_val-oper_time LT 0.
    cs_calc_val-oper_time = 0.
  ENDIF.

ENDFORM.                    " GET_DATA_AVAILABILY

*&---------------------------------------------------------------------*
*&      Form  ADD_STOP_TIME
*&---------------------------------------------------------------------*
FORM add_stop_time  USING    is_kako  TYPE ty_kako
                             VALUE(iv_begzt) TYPE begzt
                             VALUE(iv_endzt) TYPE endzt
                    CHANGING cv_stopt TYPE zlp_sf_e_stoptime.
  DATA(lv_kbegzt) = CONV begzt( is_kako-begzt ).
  DATA(lv_kendzt) = COND endzt( WHEN is_kako-endzt EQ 86400 THEN '240000' ELSE is_kako-endzt ).

  " Checks if the work center starts/end after the analysis starts/end
  IF iv_begzt LT lv_kbegzt.
    iv_begzt = lv_kbegzt.
  ENDIF.

  IF iv_endzt GT lv_kendzt.
    iv_endzt = lv_kendzt.
  ENDIF.

  DATA lv_duration TYPE sytabix.
  CALL FUNCTION 'SWI_DURATION_DETERMINE'
    EXPORTING
      start_date = sy-datum
      end_date   = sy-datum
      start_time = iv_begzt
      end_time   = iv_endzt
    IMPORTING
      duration   = lv_duration.

  cv_stopt = cv_stopt + ( lv_duration / 60 ).
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CALC_PERFORMANCE
*&---------------------------------------------------------------------*
FORM calc_performance CHANGING cs_calc_val TYPE ty_calc_value.
  " Get data for performance
  PERFORM get_data_performance CHANGING cs_calc_val.

  IF cs_calc_val-oper_time IS NOT INITIAL AND cs_calc_val-run_rate NE 0.
    cs_calc_val-performance = ( cs_calc_val-tot_pieces / ( cs_calc_val-oper_time / cs_calc_val-run_rate ) ) * 100.
  ENDIF.
ENDFORM.                    " CALC_PERFORMANCE

*&---------------------------------------------------------------------*
*&      Form  GET_DATA_PERFORMANCE
*&---------------------------------------------------------------------*
FORM get_data_performance CHANGING cs_calc_val TYPE ty_calc_value.
  DATA: lt_afru TYPE tt_afru.

  " Get total pieces
  PERFORM get_tot_pieces
    CHANGING cs_calc_val lt_afru.

  IF lt_afru[] IS NOT INITIAL.
    " Get labor time and routing basic quantity
    PERFORM calc_bmsch_vgw03_tot
      USING lt_afru
      CHANGING cs_calc_val.

    IF  cs_calc_val-run_rate IS NOT INITIAL.
      " Rounding number
      CALL FUNCTION 'ROUND'
        EXPORTING
          decimals      = 2
          input         = cs_calc_val-run_rate
          sign          = '+'
        IMPORTING
          output        = cs_calc_val-run_rate
        EXCEPTIONS
          input_invalid = 1
          overflow      = 2
          type_invalid  = 3
          OTHERS        = 4.

      IF sy-subrc IS NOT INITIAL.
        CALL METHOD zcl_lp_pp_sf_log=>add_message
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
ENDFORM.                    " GET_DATA_PERFORMANCE

*----------------------------------------------------------------------*
*&      Form  CALC_BMSCH_VGW03_TOT
*&---------------------------------------------------------------------*
FORM calc_bmsch_vgw03_tot USING    it_afru TYPE tt_afru
                          CHANGING cs_calc_val TYPE ty_calc_value.
  DATA lt_afvc TYPE tt_afvc.

  IF cs_calc_val-areaid EQ gc_mec OR cs_calc_val-areaid EQ gc_opt.
    " Get Key for Task List Group
    LOOP AT it_afru ASSIGNING FIELD-SYMBOL(<ls_afru>).
      APPEND LINES OF
        VALUE tt_afvc(
          FOR c IN gt_afvc
            WHERE ( aufpl EQ <ls_afru>-aufpl
                AND aplzl EQ <ls_afru>-aplzl
                AND vornr EQ <ls_afru>-vornr
                AND arbid EQ cs_calc_val-objid
                AND rueck EQ <ls_afru>-rueck )
          ( c ) ) TO lt_afvc.
    ENDLOOP.

  ELSE.
    DATA lt_afvc_aux TYPE tt_afvc.
    LOOP AT it_afru ASSIGNING <ls_afru>.
      APPEND LINES OF
        VALUE tt_afvc(
          FOR c IN gt_afvc
            WHERE ( aufpl EQ <ls_afru>-aufpl
                AND vornr LT <ls_afru>-vornr )
          ( c ) ) TO lt_afvc_aux.
    ENDLOOP.

    SORT lt_afvc_aux BY vornr DESCENDING.

    LOOP AT lt_afvc_aux ASSIGNING FIELD-SYMBOL(<ls_afvc>).
      IF <ls_afvc>-arbid NE '00000000'.
        APPEND <ls_afvc> TO lt_afvc.
      ELSE.
        EXIT.
      ENDIF.
    ENDLOOP.
  ENDIF.

  CHECK lt_afvc[] IS NOT INITIAL.
  SORT lt_afvc BY plnty plnnr plnkn zaehl vornr.
  DELETE ADJACENT DUPLICATES FROM lt_afvc COMPARING plnty plnnr plnkn zaehl vornr.

  DATA:
    lv_bmsch TYPE plpo-bmsch,
    lv_vgw03 TYPE plpo-vgw03.

  LOOP AT lt_afvc ASSIGNING <ls_afvc>.
    LOOP AT gt_plpo ASSIGNING FIELD-SYMBOL(<ls_plpo>)
      WHERE plnty EQ <ls_afvc>-plnty
        AND plnnr EQ <ls_afvc>-plnnr
        AND plnkn EQ <ls_afvc>-plnkn
        AND zaehl EQ <ls_afvc>-zaehl
        AND vornr EQ <ls_afvc>-vornr.

      ADD <ls_plpo>-bmsch TO lv_bmsch.
      ADD <ls_plpo>-vgw03 TO lv_vgw03.
    ENDLOOP.
  ENDLOOP.

  CHECK lv_bmsch NE 0 AND lv_vgw03 NE 0.

  cs_calc_val-run_rate = lv_vgw03 / lv_bmsch.
ENDFORM.                    " CALC_BMSCH_VGW03_TOT

*&---------------------------------------------------------------------*
*&      Form  CALC_QUALITY
*&---------------------------------------------------------------------*
FORM calc_quality CHANGING cs_calc_val TYPE ty_calc_value.
  " Get data for quality
  PERFORM get_good_pieces CHANGING cs_calc_val.

  IF cs_calc_val-tot_pieces IS NOT INITIAL AND cs_calc_val-tot_pieces NE 0.
    cs_calc_val-quality = ( cs_calc_val-good_pieces / cs_calc_val-tot_pieces ) * 100.
  ENDIF.
ENDFORM.                    " CALC_QUALITY

*&---------------------------------------------------------------------*
*&      Form  GET_GOOD_PIECES
*&---------------------------------------------------------------------*
FORM get_good_pieces CHANGING cs_calc_val TYPE ty_calc_value.
  DATA(lv_prev_day) = CONV dats( cs_calc_val-date - 1 ).

  cs_calc_val-good_pieces =
    REDUCE #(
      INIT pieces = '0.000'
      FOR a IN gt_afru
        WHERE ( ( isdd EQ lv_prev_day AND
                ( erzet GE zabsf_pp_cl_dashboard=>gc_start_time )
             OR ( isdd EQ cs_calc_val-date AND
                  erzet LE zabsf_pp_cl_dashboard=>gc_start_time ) )
            AND arbid    EQ cs_calc_val-objid
            AND kaptprog EQ cs_calc_val-shiftid )
      NEXT pieces = pieces + a-lmnga ).
ENDFORM.                    " GET_GOOD_PIECES

*&---------------------------------------------------------------------*
*&      Form  GET_TOT_PIECES
*&---------------------------------------------------------------------*
FORM get_tot_pieces CHANGING cs_calc_val TYPE ty_calc_value
                             ct_afru TYPE tt_afru.
  DATA:
    lv_lmnga TYPE ru_lmnga,
    lv_rmnga TYPE ru_rmnga,
    lv_xmnga TYPE ru_xmnga.

  DATA(lv_prev_day) = CONV dats( cs_calc_val-date - 1 ).

  ct_afru = gt_afru[].
  DELETE ct_afru
    WHERE ( isdd   EQ lv_prev_day AND
            erzet   LT zabsf_pp_cl_dashboard=>gc_start_time )
      OR  ( isdd   EQ cs_calc_val-date AND
            erzet   GT zabsf_pp_cl_dashboard=>gc_start_time )
      OR  isdd     NOT BETWEEN lv_prev_day AND cs_calc_val-date
      OR  arbid    NE cs_calc_val-objid
      OR  kaptprog NE cs_calc_val-shiftid.

  lv_lmnga = "    Confirmed yield
    REDUCE #(
      INIT lmnga = '0.000'
      FOR t IN ct_afru
      NEXT lmnga = lmnga + t-lmnga ).

  IF cs_calc_val-areaid EQ gc_mec OR cs_calc_val-areaid EQ gc_opt.
    LOOP AT ct_afru ASSIGNING FIELD-SYMBOL(<ls_afru>).
      ADD <ls_afru>-rmnga TO lv_rmnga. "    Rework Quantity

      IF <ls_afru>-xmnga IS NOT INITIAL.
        DATA(lv_valid) = abap_true.
        LOOP AT gt_stops ASSIGNING FIELD-SYMBOL(<ls_stop>)
          WHERE areaid EQ cs_calc_val-areaid
            AND arbpl  EQ cs_calc_val-arbpl
            AND ( ( datesr  LT <ls_afru>-isdd AND   " On same day of the stop start
                    endda   GT <ls_afru>-isdd )
               OR ( datesr  EQ <ls_afru>-isdd AND
                    endda   EQ <ls_afru>-isdd AND
                    time    LE <ls_afru>-erzet AND
                    timeend GE <ls_afru>-erzet )
               OR ( datesr  EQ <ls_afru>-isdd AND   " Between start and end
                    time    GE <ls_afru>-erzet )
               OR ( endda   EQ <ls_afru>-isdd AND   " On same day of the stop end
                    timeend GE <ls_afru>-erzet ) )
              AND motivetype EQ zabsf_pp_cl_dashboard=>gc_mtype_planned.
          lv_valid = abap_false.
          EXIT.
        ENDLOOP.

        IF lv_valid EQ abap_true.
          ADD <ls_afru>-xmnga TO lv_xmnga. "    Scrap quantity
        ENDIF.
      ENDIF.
    ENDLOOP.
  ELSE.
    lv_rmnga =
      REDUCE #(
        INIT rework = '0.000'
        FOR r IN gt_rework
          WHERE ( areaid  EQ cs_calc_val-areaid
              AND rpoint  EQ cs_calc_val-arbpl
              AND ( ( data EQ lv_prev_day AND
                      time GE zabsf_pp_cl_dashboard=>gc_start_time )
                 OR ( data EQ cs_calc_val-date AND
                      time LE zabsf_pp_cl_dashboard=>gc_start_time ) )
              AND shiftid EQ cs_calc_val-shiftid )
        NEXT rework = rework + r-rework ).
  ENDIF.

  " Total pieces
  cs_calc_val-tot_pieces = lv_lmnga + lv_rmnga + lv_xmnga.
ENDFORM.                    " GET_TOT_PIECES

*&---------------------------------------------------------------------*
*&      Form  CALC_OEE
*&---------------------------------------------------------------------*
FORM calc_oee  CHANGING cs_calc_val TYPE ty_calc_value.
  CHECK cs_calc_val-availability IS NOT INITIAL
    AND cs_calc_val-performance IS NOT INITIAL
    AND cs_calc_val-quality IS NOT INITIAL.

  " Calculate OEE
  cs_calc_val-oee = ( cs_calc_val-availability / 100 ) * ( cs_calc_val-performance / 100 ) * ( cs_calc_val-quality / 100 ) * 100.
ENDFORM.                    " CALC_OEE

*&---------------------------------------------------------------------*
*&      Form  CALC_PRODUCTIVITY
*&---------------------------------------------------------------------*
FORM calc_productivity CHANGING cs_calc_val TYPE ty_calc_value.
  " Get data for productivity
  PERFORM get_data_productivity CHANGING cs_calc_val.

  CHECK cs_calc_val-real_time NE 0.

  cs_calc_val-productivit = ( ( cs_calc_val-good_pieces * cs_calc_val-run_rate_prd ) / cs_calc_val-real_time ) * 100.
ENDFORM.                    " CALC_PRODUCTIVITY

*&---------------------------------------------------------------------*
*&      Form  GET_DATA_PRODUCTIVITY
*&---------------------------------------------------------------------*
FORM get_data_productivity CHANGING cs_calc_val TYPE ty_calc_value.
  DATA(lv_prev_day) = CONV dats( cs_calc_val-date - 1 ).
  cs_calc_val-real_time =
    REDUCE #(
      INIT r = '0.000'
      FOR p IN gt_times
        WHERE ( areaid  EQ cs_calc_val-areaid
            AND hname   EQ cs_calc_val-hname
            AND arbpl   EQ cs_calc_val-arbpl
            AND ( ( date EQ lv_prev_day AND
                    time GE zabsf_pp_cl_dashboard=>gc_start_time )
               OR ( date EQ cs_calc_val-date AND
                    time LE zabsf_pp_cl_dashboard=>gc_start_time ) )
            AND shiftid EQ cs_calc_val-shiftid )
      NEXT r = r + p-worktime ).
ENDFORM.                    " GET_DATA_PRODUCTIVITY

*&---------------------------------------------------------------------*
*&      Form  SAVE_DB
*&---------------------------------------------------------------------*
FORM save_db .
  CHECK gt_calc_val[] IS NOT INITIAL.

  DATA(lt_fae) = gt_calc_val[].
  SORT lt_fae BY areaid hname werks arbpl shiftid date.
  DELETE ADJACENT DUPLICATES FROM lt_fae COMPARING areaid hname werks arbpl shiftid date.

  SELECT *
    FROM zabsf_pp051
    INTO TABLE @DATA(lt_oee)
    FOR ALL ENTRIES IN @lt_fae
    WHERE areaid  EQ @lt_fae-areaid
      AND hname   EQ @lt_fae-hname
      AND werks   EQ @lt_fae-werks
      AND arbpl   EQ @lt_fae-arbpl
      AND shiftid EQ @lt_fae-shiftid
      AND data    EQ @lt_fae-date.

  DATA(lv_modified) = sy-dbcnt.

  SORT lt_oee BY areaid hname werks arbpl oeeid shiftid data.

  LOOP AT gt_calc_val ASSIGNING FIELD-SYMBOL(<ls_calc>).
    DO 7 TIMES.
      DATA(lv_oeeid) = CONV zabsf_pp_e_oeeid( sy-index ).

      READ TABLE lt_oee
        ASSIGNING FIELD-SYMBOL(<ls_oee>)
        WITH KEY areaid  = <ls_calc>-areaid
                 hname   = <ls_calc>-hname
                 werks   = <ls_calc>-werks
                 arbpl   = <ls_calc>-arbpl
                 oeeid   = lv_oeeid
                 shiftid = <ls_calc>-shiftid
                 data    = <ls_calc>-date
        BINARY SEARCH.

      IF sy-subrc IS NOT INITIAL.
        APPEND INITIAL LINE TO lt_oee ASSIGNING <ls_oee>.
        <ls_oee>-areaid  = <ls_calc>-areaid.
        <ls_oee>-hname   = <ls_calc>-hname.
        <ls_oee>-werks   = <ls_calc>-werks.
        <ls_oee>-arbpl   = <ls_calc>-arbpl.
        <ls_oee>-oeeid   = lv_oeeid.
        <ls_oee>-shiftid = <ls_calc>-shiftid.
        <ls_oee>-data    = <ls_calc>-date.
        <ls_oee>-week    = <ls_calc>-week.
      ENDIF.

      CASE lv_oeeid.
        WHEN 1. "DISP - Availability
          <ls_oee>-qtdoee = <ls_calc>-availability.

        WHEN 2. "PERF - Performance
          <ls_oee>-qtdoee = <ls_calc>-performance.

        WHEN 3. "QUAL - Quality
          <ls_oee>-qtdoee = <ls_calc>-quality.

        WHEN 4. "OEE
          " Calculate OEE
          IF <ls_calc>-availability IS NOT INITIAL AND <ls_calc>-performance IS NOT INITIAL AND <ls_calc>-quality IS NOT INITIAL.
            <ls_oee>-qtdoee = <ls_calc>-oee.
          ENDIF.

        WHEN 5. "PROD - Productivity
          <ls_oee>-qtdoee = <ls_calc>-productivit.

        WHEN 6. "Planed Production Time
          <ls_oee>-qtdoee = <ls_calc>-plan_prod.

        WHEN 7. "Operation Production Time
          <ls_oee>-qtdoee = <ls_calc>-oper_time.

      ENDCASE.
    ENDDO.
  ENDLOOP.

  MODIFY zabsf_pp051 FROM TABLE lt_oee.

  DATA(lv_inserted) = lines( lt_oee ) - lv_modified.
  MESSAGE s168(zabsf_pp) WITH lv_inserted lv_modified.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  SHOW_ERROS
*&---------------------------------------------------------------------*
FORM show_erros .
  cl_demo_output=>new( )->display( gt_error ).
ENDFORM.
