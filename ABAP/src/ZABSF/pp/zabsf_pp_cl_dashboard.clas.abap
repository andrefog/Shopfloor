class ZABSF_PP_CL_DASHBOARD definition
  public
  final
  create public .

public section.

  constants GC_MTYPE_PLANNED type ZABSF_PP_E_MOTIVETYPE value 'P' ##NO_TEXT.
  constants GC_MTYPE_NOT_PLANNED type ZABSF_PP_E_MOTIVETYPE value 'NP' ##NO_TEXT.
  constants GC_OEEID_AVAILABILY type ZABSF_PP_E_OEEID value 1 ##NO_TEXT.
  constants GC_OEEID_OEE type ZABSF_PP_E_OEEID value 4 ##NO_TEXT.
  constants GC_OEEID_PERFORMANCE type ZABSF_PP_E_OEEID value 2 ##NO_TEXT.
  constants GC_OEEID_PLANNED_TIME type ZABSF_PP_E_OEEID value 6 ##NO_TEXT.
  constants GC_OEEID_PRODUCTION_TIME type ZABSF_PP_E_OEEID value 7 ##NO_TEXT.
  constants GC_OEEID_PRODUCTIVITY type ZABSF_PP_E_OEEID value 5 ##NO_TEXT.
  constants GC_OEEID_QUALITY type ZABSF_PP_E_OEEID value 3 ##NO_TEXT.
  constants GC_START_TIME type UZEIT value '060000' ##NO_TEXT.

  methods GET_REVIEW
    returning
      value(RT_REVIEW) type ZABSF_PP_T_DASHB_REVIEW .
  methods GET_PERFORMANCE
    returning
      value(RT_PERFORMANCE) type ZABSF_PP_T_DASHB_PERFORMANCE .
  methods GET_AVAILABILITY
    returning
      value(RT_AVAILABILITY) type ZABSF_PP_T_DASHB_AVAILABILITY .
  methods GET_LOSTS
    returning
      value(RT_LOSTS) type ZABSF_PP_T_DASHB_LOSTS .
  methods GET_QUALITY
    returning
      value(RT_QUALITY) type ZABSF_PP_T_DASHB_QUALITIES .
  methods GET_STOPS
    returning
      value(RT_STOPS) type ZABSF_PP_T_DASHB_STOPS .
  methods CALCULATE_OEE_AVAILABILITY
    importing
      value(WORKCENTER_DETAIL) type ZABSF_PP_S_WRKCTR_DETAIL
    exporting
      value(OEE_AVAILABILITY) type ZABSF_PP_E_QTDOEE
      value(TOTAL_RUN_TIME) type MENGV13 .
  methods CALCULATE_OEE_INDICATORS
    importing
      value(WORKCENTER_DETAIL) type ZABSF_PP_S_WRKCTR_DETAIL
    changing
      value(WORKCENTER_DASHBOARD) type ZABSF_PP_S_WORKCENTER_DASHBOAR .
  methods CALCULATE_OEE_PERFORMANCE
    importing
      value(WORKCENTER_DETAIL) type ZABSF_PP_S_WRKCTR_DETAIL
      value(TOTAL_RUN_TIME) type MENGV13
    exporting
      value(OEE_PERFORMANCE) type ZABSF_PP_E_QTDOEE
      value(OEE_QUALITY) type ZABSF_PP_E_QTDOEE .
  methods CALCULATE_OEE_PRODUCTIVITY
    importing
      value(WORKCENTER_DETAIL) type ZABSF_PP_S_WRKCTR_DETAIL
    exporting
      value(OEE_PRODUCTIVITY) type ZABSF_PP_E_QTDOEE .
  methods CALCULATE_OEE_QUALITY
    importing
      value(WORKCENTER_DETAIL) type ZABSF_PP_S_WRKCTR_DETAIL
    exporting
      value(OEE_QUALITY) type ZABSF_PP_E_QTDOEE .
  methods COMPARE_STATUS
    exporting
      value(DASHBOARD_STATUS) type ZABSF_PP_E_DASH_COLOURS
      value(STOP_REASON_DESC) type ZABSF_PP_E_STPRSNDESC
    changing
      value(I_WORKCENTER_DETAIL) type ZABSF_PP_S_WRKCTR_DETAIL .
  methods CONSTRUCTOR
    importing
      value(INPUT_INPUTOBJ) type ZABSF_PP_S_INPUTOBJECT
      value(INPUT_REFDT) type VVDATUM optional
      !IR_HNAME type /GIB/DCP_CR_HNAME_TR optional
      !IR_ARBPL type /GIB/DCP_ARBPL_TR optional .
  methods GET_DASHBOARD_DETAIL
    importing
      value(ARBPL) type ARBPL optional
      value(AUFNR) type AUFNR optional
      value(VORNR) type VORNR optional
      value(HNAME) type CR_HNAME optional
      value(HIERARCHIES) type ZABSF_PP_T_HRCHY optional
      value(REFDT) type VVDATUM optional
      value(INPUTOBJ) type ZABSF_PP_S_INPUTOBJECT
    exporting
      value(WORKCENTER_DASHBOARD) type ZABSF_PP_T_WORKCENTER_DASHBOAR
      value(RETURN_TAB) type BAPIRET2_T .
  methods GET_HIERARCHIES
    changing
      value(HIERARCHIES) type ZABSF_PP_T_HRCHY optional .
  methods GET_OPERATORS
    changing
      value(PRODORD) type ZABSF_PP_S_PRDORD_DETAIL .
  methods GET_OPERATOR_MONTHLY_LOG
    importing
      value(OPRID) type ZABSF_PP_E_OPRID optional
    changing
      value(KPI_TAB) type ZABSF_PP_T_CALC_WORKERS_KPI optional
      value(OPERATOR_LOG_TAB) type ZABSF_PP_T_OPERATOR_LOG optional .
  methods GET_WORKCENTERS_LIST
    importing
      !HNAME type CR_HNAME
      !WERKS type WERKS_D
    changing
      !WRKCTR_TAB type ZABSF_PP_T_WRKCTR
      !RETURN_TAB type BAPIRET2_T .
  methods GET_WORKCENTER_DASHBOARD
    exporting
      !EV_OEE type ZABSF_PP_E_QTDOEE
      !EV_AVAILABILITY type ZABSF_PP_E_QTDOEE
      !EV_PERFORMANCE type ZABSF_PP_E_QTDOEE
      !EV_QUALITY type ZABSF_PP_E_QTDOEE
      !ET_EVOLUTION type ZABSF_PP_T_DASHB_EVOLUTION .
  methods GET_WORKCENTER_FULL_DETAIL
    importing
      value(AUFNR) type AUFNR optional
      value(VORNR) type VORNR optional
      value(WRKCTR_DETAIL) type ZABSF_PP_S_WRKCTR_DETAIL
    changing
      value(RETURN_TAB) type BAPIRET2_T
      value(WORKCENTER_DASHBOARD) type ZABSF_PP_S_WORKCENTER_DASHBOAR .
  methods GET_WORKCENTER_SHORT_DETAIL
    importing
      value(AREAID) type ZABSF_PP_E_AREAID
      value(WERKS) type WERKS_D
      value(HNAME) type CR_HNAME
      value(ARBPL) type ARBPL
      !ACTIONID type ZABSF_PP_E_ACTION optional
    changing
      value(WRKCTR_DETAIL) type ZABSF_PP_S_WRKCTR_DETAIL
      value(RETURN_TAB) type BAPIRET2_T optional .
  methods MAP_VALUES
    importing
      value(WORKCENTER_DETAIL) type ZABSF_PP_S_WRKCTR_DETAIL
    changing
      value(WORKCENTER_DASHBOARD) type ZABSF_PP_S_WORKCENTER_DASHBOAR .
protected section.
private section.

  data INPUTOBJ type ZABSF_PP_S_INPUTOBJECT .
  data REFDT type VVDATUM .
  data GR_ARBPL type /GIB/DCP_ARBPL_TR .
  data GR_HNAME type /GIB/DCP_CR_HNAME_TR .
ENDCLASS.



CLASS ZABSF_PP_CL_DASHBOARD IMPLEMENTATION.


METHOD calculate_oee_availability.

    DATA: lt_zabsf_pp006 TYPE TABLE OF zabsf_pp006.

    DATA: ls_zabsf_pp001 TYPE zabsf_pp001,
          wa_zabsf_pp006 TYPE zabsf_pp006,
          ls_kako        TYPE kako,
          ld_hours       TYPE i,
          ld_stop_time   TYPE i,
          ld_stop_area   TYPE zabsf_pp_e_stoptime,
          ld_kapid       TYPE kapid,
          ld_capacity    TYPE kapazitaet,
          ld_einzt       TYPE kapeinzt,
          ld_kapaz       TYPE kapazitaet,
          ld_worktime    TYPE mengv13,
          p_plan_prod    TYPE mengv13,
          p_run_time     TYPE mengv13,
          p_avaibility   TYPE mengv13,
          lv_stop_area   TYPE zabsf_pp_e_stoptime.

    DATA: lt_stops_str_previously_open  TYPE TABLE OF zabsf_pp010,
          ls_stops_str_previously_open  LIKE LINE OF lt_stops_str_previously_open,
          lt_stops_str_previously_close TYPE TABLE OF zabsf_pp010,
          ls_stops_str_previously_close LIKE LINE OF lt_stops_str_previously_close,
          lt_stops_str_today_open       TYPE TABLE OF zabsf_pp010,
          ls_stops_str_today_open       LIKE LINE OF lt_stops_str_today_open,
          lv_today_stops                TYPE zabsf_pp_e_stoptime,
          lv_total_stopped_time         TYPE zabsf_pp_e_stoptime.

    "D2>D1 !
    DATA: t1         TYPE cva_time,
          t2         TYPE cva_time,
          d1         TYPE cva_date,
          d2         TYPE cva_date,
          lv_minutes TYPE i,
          lv_days    TYPE i,
          lv_time    TYPE cva_time,
          lv_endda   TYPE ledatum.

    CONSTANTS c_sec_day TYPE kapbegzt VALUE '86400'.

*Get ID capacity
    SELECT SINGLE kapid
      FROM crhd
      INTO ld_kapid
     WHERE arbpl EQ workcenter_detail-arbpl
       AND werks EQ workcenter_detail-werks.

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

* started previously and finished
    SELECT *
      FROM zabsf_pp010
      INTO TABLE lt_stops_str_previously_close
     WHERE "areaid  EQ workcenter_detail-areadid AND
           hname   EQ workcenter_detail-hname
       AND arbpl   EQ workcenter_detail-arbpl
       AND werks   EQ workcenter_detail-werks
       AND datesr  NE sy-datlo
       AND endda   EQ sy-datlo.

    LOOP AT lt_stops_str_previously_close INTO ls_stops_str_previously_close.

      "lower date
      "t1 - midnight
      d1 = sy-datlo.
      "higher date
      t2 = ls_stops_str_previously_close-timeend.
      d2 = ls_stops_str_previously_close-endda.

      CALL FUNCTION 'SCOV_TIME_DIFF'
        EXPORTING
          im_date1              = d1
          im_date2              = d2
          im_time1              = t1 "midnight
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

      lv_total_stopped_time = lv_total_stopped_time + ( lv_days * 1440 ) + ( lv_time / 60 ). ">>minutes

      CLEAR: d1, d2, t1, t2, ls_stops_str_previously_close.
    ENDLOOP.

* started previously and not finished
    SELECT *
      FROM zabsf_pp010
      INTO TABLE lt_stops_str_previously_open
     WHERE "areaid  EQ workcenter_detail-areadid AND
           hname   EQ workcenter_detail-hname
       AND arbpl   EQ workcenter_detail-arbpl
       AND werks   EQ workcenter_detail-werks
       AND datesr  NE sy-datlo
       AND endda   EQ lv_endda. ">>inital

    LOOP AT lt_stops_str_previously_open INTO ls_stops_str_previously_open.

      "D2>D1
      d1 = sy-datlo.
      t2 = sy-timlo.
      d2 = sy-datlo.

      CALL FUNCTION 'SCOV_TIME_DIFF'
        EXPORTING
          im_date1              = sy-datlo
          im_date2              = sy-datlo
          im_time1              = t1 "midnight 000000
          im_time2              = sy-timlo
        IMPORTING
          ex_days               = lv_days
          ex_time               = lv_time
        EXCEPTIONS
          start_larger_than_end = 1
          OTHERS                = 2.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.

      lv_total_stopped_time = lv_total_stopped_time + ( lv_days * 1440 ) + ( lv_time / 60 ). ">>minutes

      CLEAR: d1, d2, t1, t2, ls_stops_str_previously_open.
    ENDLOOP.


* Started and finished today
    SELECT SUM( stoptime )
        FROM zabsf_pp010
        INTO lv_today_stops
       WHERE "areaid  EQ workcenter_detail-areadid AND
             hname   EQ workcenter_detail-hname
         AND arbpl   EQ workcenter_detail-arbpl
         AND werks   EQ workcenter_detail-werks
         AND datesr  EQ sy-datlo
         AND endda   EQ sy-datlo.

    lv_total_stopped_time = lv_total_stopped_time + lv_today_stops.

* Started today but not finished.
    SELECT *
        FROM zabsf_pp010
        INTO TABLE lt_stops_str_today_open
       WHERE "areaid  EQ workcenter_detail-areadid AND
             hname   EQ workcenter_detail-hname
         AND arbpl EQ workcenter_detail-arbpl
         AND werks   EQ workcenter_detail-werks
         AND datesr  EQ sy-datlo
         AND endda   EQ lv_endda. "inital<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

    LOOP AT lt_stops_str_today_open  INTO ls_stops_str_today_open.

      t1 = ls_stops_str_today_open-time.
      d1 = ls_stops_str_today_open-datesr.

      t2 = sy-timlo.
      d2 = sy-datlo.

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

      lv_total_stopped_time = lv_total_stopped_time + ( lv_days * 1440 ) + ( lv_time / 60 ). ">>minutes

      CLEAR: d1, d2, t1, t2, ls_stops_str_today_open.
    ENDLOOP.

*Planned Production Time
    p_plan_prod = ld_worktime.
*Operating Time
    p_run_time = p_plan_prod - lv_total_stopped_time.


*Calculate value of indicator OEE
    IF p_plan_prod NE 0.
      oee_availability = ( p_run_time / p_plan_prod ) * 100.
    ENDIF.

    total_run_time = p_run_time.


  ENDMETHOD.


METHOD calculate_oee_indicators.

    DATA: lv_total_run_time TYPE mengv13.

*AVAILABILITY
    CALL METHOD me->calculate_oee_availability
      EXPORTING
        workcenter_detail = workcenter_detail
      IMPORTING
        oee_availability  = workcenter_dashboard-availability
        total_run_time    = lv_total_run_time.

*PERFORMANCE AND QUALITY.
    CALL METHOD me->calculate_oee_performance
      EXPORTING
        workcenter_detail = workcenter_detail
        total_run_time    = lv_total_run_time
      IMPORTING
        oee_performance   = workcenter_dashboard-performance
        oee_quality       = workcenter_dashboard-quality.

*QUALITY
*    CALL METHOD me->calculate_oee_quality
*      EXPORTING
*        workcenter_detail = workcenter_detail
*      IMPORTING
*        oee_quality  = workcenter_dashboard-quality.

*Calculate OEE.
    workcenter_dashboard-oee = ( workcenter_dashboard-availability / 100 ) * ( workcenter_dashboard-performance / 100 ) * ( workcenter_dashboard-quality / 100 ).
    workcenter_dashboard-oee = workcenter_dashboard-oee * 100.
  ENDMETHOD.


method calculate_oee_performance.

    constants: gc_type_area type zabsf_pp_e_tarea_id value 'AT01'.

    types: begin of ty_afru_afvv,
*afru
             rueck            type  co_rueck,
             rmzhl            type  co_rmzhl,
             aufnr            type  aufnr,
             vornr            type  vornr,
             lmnga            type  ru_lmnga,
             xmnga            type  ru_xmnga,
             rmnga            type  ru_rmnga,
             ile01            type  co_ismngeh,
             ism01            type  ru_ismng,
             ile02            type  co_ismngeh,
             ism02            type  ru_ismng,
             ile03            type  co_ismngeh,
             ism03            type  ru_ismng,

*afvv
             aufpl            type co_aufpl,
             aplzl            type co_aplzl,
             vgw02            type vgwrt,
             bmsch            type bmsch,
*aufk
             auart            type aufart,
*custom
*             ideal_cycle_time TYPE /plmb/rca_decimal,
             ideal_cycle_time type dec10,
           end of ty_afru_afvv.

    types:rng_auart type range of auart.


    data: lt_afru_afvv     type table of ty_afru_afvv,
          lt_afru_afvv_aux type table of ty_afru_afvv,
          lr_auart         type rng_auart,
          ls_auart         like line of lr_auart.

    data: lv_arbid             type cr_objid,
          lv_confirmation_qtt  type ru_lmnga,
          lv_total_pieces      type ru_lmnga,
          lv_confirmation_time type ru_ismng,
          lv_total_time        type ru_ismng,
          lv_worked_time       type ru_ismng,
          lv_lmnga             type ru_lmnga.

    field-symbols: <fs_afru_afvv>     type ty_afru_afvv,
                   <fs_afru_afvv_aux> type ty_afru_afvv.

*Get id of workcenter
    select single objid
      from crhd
      into lv_arbid
      where arbpl eq workcenter_detail-arbpl
      and werks eq workcenter_detail-werks.

* Get order types relevants for shopfloor.
    "1 _get areas
    select * from zabsf_pp008 into table @data(lt_sf008)
      where tarea_id = @gc_type_area
      and werks = @workcenter_detail-werks
      and begda le @sy-datlo
      and endda ge @sy-datlo.


    "2 _get

    sort lt_sf008 by areaid ascending.
    delete adjacent duplicates from lt_sf008 comparing areaid.
    "TODO - send error message - missing parametrizatiom

    check lt_sf008 is not initial.


    select * from zabsf_pp019 into table @data(lt_sf019)
      for all entries in @lt_sf008
      where areaid = @lt_sf008-areaid.

    "TODO - send error message - missing parametrizatiom
    check lt_sf019 is not initial.
    sort lt_sf019 by auart.
    delete adjacent duplicates from lt_sf019 comparing auart.

    loop at lt_sf019 into data(ls_sf019).

      ls_auart-sign = 'I'.
      ls_auart-option = 'EQ'.
      ls_auart-low = ls_sf019-auart.

      append ls_auart to lr_auart.

      clear: ls_sf019, ls_auart.
    endloop.


* Get confirmations and quantities
    select a~rueck a~rmzhl a~aufnr a~vornr a~lmnga a~xmnga a~rmnga
          a~ile01 a~ism01 a~ile02 a~ism02 a~ile03 a~ism03
          b~aufpl b~aplzl b~vgw02 b~bmsch
          c~auart
   into corresponding fields of table lt_afru_afvv
      from afru as a
      inner join afvv  as b
      on a~aufpl = b~aufpl
      and a~aplzl = b~aplzl
      inner join aufk as c
      on a~aufnr = c~aufnr
      where budat    eq sy-datlo
        and arbid    eq lv_arbid
        and a~werks    eq workcenter_detail-werks
        and stokz    eq space
        and stzhl    eq space
        and c~auart in lr_auart.

*>>>NEM METHOD
* for each confirmation, calculate total duration.
* compare duration of each confirmation with total afru duration.
*<<<< NEW METHOD.


    lt_afru_afvv_aux[] = lt_afru_afvv[].
* get unique confirmations
    sort lt_afru_afvv_aux by rueck rmzhl ascending.
    delete adjacent duplicates from lt_afru_afvv_aux comparing rueck.

* get values for each confirmation number
    loop at lt_afru_afvv_aux assigning <fs_afru_afvv_aux>.

      loop at lt_afru_afvv assigning <fs_afru_afvv>
        where rueck = <fs_afru_afvv_aux>-rueck.

* Good confirmations.
* Scrap rework.
* Scrap quantity.
        lv_lmnga = lv_lmnga + <fs_afru_afvv>-lmnga.
        lv_confirmation_qtt = lv_confirmation_qtt + <fs_afru_afvv>-lmnga + <fs_afru_afvv>-rmnga + <fs_afru_afvv>-xmnga.

* Times
*        CALL FUNCTION 'UNIT_CONVERSION_SIMPLE'
*          EXPORTING
*            input    = <fs_afru_afvv>-ism01
*            unit_in  = <fs_afru_afvv>-ile01
*            unit_out = 'MIN'
*          IMPORTING
*            output   = <fs_afru_afvv>-ism01.
*        IF sy-subrc <> 0.
*        ENDIF.

        call function 'UNIT_CONVERSION_SIMPLE'
          exporting
            input    = <fs_afru_afvv>-ism02
            unit_in  = <fs_afru_afvv>-ile02
            unit_out = 'MIN'
          importing
            output   = <fs_afru_afvv>-ism02.
        if sy-subrc <> 0.
        endif.

*        CALL FUNCTION 'UNIT_CONVERSION_SIMPLE'
*          EXPORTING
*            input    = <fs_afru_afvv>-ism03
*            unit_in  = <fs_afru_afvv>-ile03
*            unit_out = 'MIN'
*          IMPORTING
*            output   = <fs_afru_afvv>-ism03.
*        IF sy-subrc <> 0.
*        ENDIF.

        lv_confirmation_time = lv_confirmation_time + <fs_afru_afvv>-ism02. "+ <fs_afru_afvv>-ism03 + <fs_afru_afvv>-ism01.

      endloop.

      if <fs_afru_afvv_aux>-bmsch is not initial.
        <fs_afru_afvv_aux>-ideal_cycle_time = ( <fs_afru_afvv_aux>-vgw02 / <fs_afru_afvv_aux>-bmsch ) * lv_confirmation_qtt * lv_confirmation_time.
      endif.

      lv_total_pieces = lv_total_pieces + lv_confirmation_qtt.
      lv_total_time = lv_total_time + lv_confirmation_time.

      clear: lv_confirmation_time, lv_confirmation_qtt.
    endloop.

* Calculate Quality
    if lv_total_pieces is not initial.
      oee_quality = ( lv_lmnga / lv_total_pieces ) * 100.
    endif.


* Calculate Performance.
    loop at lt_afru_afvv_aux assigning <fs_afru_afvv_aux>.

      lv_worked_time = lv_worked_time + <fs_afru_afvv_aux>-ideal_cycle_time.
    endloop.

    if lv_total_time is not initial and total_run_time is not initial.
      oee_performance =  ( lv_worked_time / lv_total_time ) / total_run_time.
      oee_performance = oee_performance * 100.
    endif.


  endmethod.


METHOD CALCULATE_OEE_PRODUCTIVITY.

*       DATA: p_run_rate     TYPE mengv13,
*        p_run_rate_prd TYPE mengv13,
*        p_good_pieces  TYPE mengv13,
*        p_real_time    TYPE mengv13.
*
* PERFORM get_data_productivity IN PROGRAM Z_LP_PP_SF_REPORT_OEE
*    USING workcenter_detail-hname workcenter_detail-areadid workcenter_detail-arbpl sy-datum ''
*    CHANGING p_good_pieces p_run_rate_prd p_real_time.





  ENDMETHOD.


METHOD CALCULATE_OEE_QUALITY.

    DATA: lv_arbid      TYPE cr_objid,
          lv_lmnga      TYPE ru_lmnga,
          lv_xmnga      TYPE ru_xmnga,
          lv_rmnga      TYPE ru_rmnga,
          lv_tot_pieces TYPE ru_lmnga,
          local_date    TYPE dats.

    DATA: ls_afru TYPE afru.

*Get id of workcenter
    SELECT SINGLE objid
      FROM crhd
      INTO lv_arbid
      WHERE arbpl EQ workcenter_detail-arbpl
      AND werks EQ workcenter_detail-werks.

* Get confirmations
    SELECT *
      FROM afru
    INTO TABLE @DATA(lt_afru)
      WHERE budat    EQ @sy-datlo
        AND arbid    EQ @lv_arbid
        AND werks    EQ @workcenter_detail-werks
        AND stokz    EQ @space
        AND stzhl    EQ @space.

    LOOP AT lt_afru INTO ls_afru.
* Confirmed yield and scrap.
      ADD ls_afru-lmnga TO lv_lmnga.
* Scrap rework
      ADD ls_afru-rmnga TO lv_rmnga.
* Scrap quantity
      ADD ls_afru-xmnga TO lv_xmnga.

    ENDLOOP.

    lv_tot_pieces = lv_lmnga + lv_rmnga + lv_xmnga.

    IF lv_tot_pieces IS NOT INITIAL.
      oee_quality = ( lv_lmnga / lv_tot_pieces ) * 100.

    ENDIF.

  ENDMETHOD.


METHOD compare_status.

  CONSTANTS: g_active(4) VALUE '0002',
             g_stoped(4) VALUE '0003',
             c_proc(4)   VALUE 'PROC',
             c_stop(4)   VALUE 'STOP',
             c_prep(4)   VALUE 'PREP'.

  DATA:  lref_sf_status   TYPE REF TO zabsf_pp_cl_status.

  DATA: lv_workcenter_status TYPE j_status,
        lv_wrkctr_desc       TYPE j_txt30,
        lv_veran             TYPE ap_veran,
        lv_alt_spras         TYPE spras.

  DATA: ld_date TYPE zabsf_pp010-endda.
  DATA: ls_sf010 TYPE  zabsf_pp010,
        ls_sf011 TYPE  zabsf_pp011.

  DATA: return_tab TYPE bapiret2_t.

* get default language
  SELECT SINGLE spras FROM zabsf_pp061 INTO lv_alt_spras
      WHERE werks = inputobj-werks
      AND is_default EQ abap_true.


*  Create object of class status
  CREATE OBJECT lref_sf_status
    EXPORTING
      initial_refdt = refdt
      input_object  = inputobj.

*  Get current status of Workcenter
  CALL METHOD lref_sf_status->status_object
    EXPORTING
      arbpl       = i_workcenter_detail-arbpl
      werks       = i_workcenter_detail-werks
      objty       = 'CA'
      method      = 'G'
    CHANGING
      status_out  = lv_workcenter_status
      status_desc = lv_wrkctr_desc
      return_tab  = return_tab.

*   Get WC responsability
  SELECT SINGLE veran FROM crhd INTO lv_veran
    WHERE arbpl = i_workcenter_detail-arbpl
    AND objty = 'A'
    AND werks = inputobj-werks.

*  Logic for colours on dashboard screen.
  CASE lv_workcenter_status.

    WHEN g_active. "Active

      CASE i_workcenter_detail-status.

        WHEN c_prep OR c_proc.

          SELECT SINGLE * FROM zabsf_pp068 INTO @DATA(ls_sf068)
            WHERE stprsnid = @lv_veran
            AND wc_status = @g_active.

          IF sy-subrc NE 0.
            " Get default value -->White
            SELECT SINGLE * FROM zabsf_pp068 INTO ls_sf068
               WHERE stprsnid = ''
               AND wc_status = g_active.
          ENDIF.

          dashboard_status = ls_sf068-color.

        WHEN c_stop.
          dashboard_status = 'YELLOW'.

        WHEN ''.
          dashboard_status = 'WHITE'.

      ENDCASE.

    WHEN g_stoped. "Stoped
      CLEAR ld_date.

      SELECT SINGLE * FROM zabsf_pp010 INTO ls_sf010
        WHERE areaid = i_workcenter_detail-areadid
        AND hname =  i_workcenter_detail-hname
        AND werks = i_workcenter_detail-werks
        AND arbpl = i_workcenter_detail-arbpl
        AND endda = ld_date
        AND stoptime = 0.

      IF sy-subrc EQ 0.

        SELECT SINGLE * FROM zabsf_pp068 INTO ls_sf068
          WHERE stprsnid = ls_sf010-stprsnid
          AND wc_status = g_stoped.

        IF sy-subrc NE 0.
          " get default value
          SELECT SINGLE * FROM zabsf_pp068 INTO ls_sf068
            WHERE stprsnid = ''
            AND wc_status = g_stoped.

        ENDIF.
* get reason description
        SELECT SINGLE stprsn_desc FROM zabsf_pp011_t INTO stop_reason_desc
          WHERE "areaid = i_workcenter_detail-areadid AND
              werks = i_workcenter_detail-werks
*              AND arbpl = i_workcenter_detail-arbpl
          AND stprsnid = ls_sf010-stprsnid "ls_sf068-stprsnid
          AND spras = sy-langu.

        IF sy-subrc NE 0.
* get reason description default language
          SELECT SINGLE stprsn_desc FROM zabsf_pp011_t INTO stop_reason_desc
            WHERE "areaid = i_workcenter_detail-areadid AND
            werks = i_workcenter_detail-werks
*                AND arbpl = i_workcenter_detail-arbpl
            AND stprsnid = ls_sf010-stprsnid "ls_sf068-stprsnid
            AND spras = lv_alt_spras.

        ENDIF.

* no orders on workcenter. set status hour and date of workcenter stopage.
        IF i_workcenter_detail-status_date IS INITIAL.
          i_workcenter_detail-status_date = ls_sf010-datesr.
          i_workcenter_detail-status_hour = ls_sf010-time.

        ENDIF.

        dashboard_status = ls_sf068-color.

      ELSE.
        dashboard_status = 'WHITE'.
      ENDIF.

    WHEN OTHERS.
      dashboard_status = 'WHITE'.
  ENDCASE.

ENDMETHOD.


METHOD CONSTRUCTOR.

*Ref. Date
    refdt    = input_refdt.

*App input data
    inputobj = input_inputobj.

    gr_hname = ir_hname.
    gr_arbpl = ir_arbpl.
  ENDMETHOD.


  METHOD get_availability.

    " Get Availability
    SELECT *
      FROM zabsf_pp051
      INTO TABLE @DATA(lt_pp051)
      WHERE oeeid IN (@gc_oeeid_availabily, @gc_oeeid_planned_time, @gc_oeeid_production_time)
        AND hname IN @gr_hname
        AND arbpl IN @gr_Arbpl
        AND data  EQ @refdt.
    CHECK lt_pp051[] IS NOT INITIAL.
    SORT lt_pp051 BY arbpl oeeid.

    " Get Goals
    DATA(lt_fae) = lt_pp051[].
    DELETE ADJACENT DUPLICATES FROM lt_fae COMPARING arbpl.

    SELECT *
      FROM zabsf_pp090
      INTO TABLE @DATA(lt_goals)
      FOR ALL ENTRIES IN @lt_fae
      WHERE arbpl EQ @lt_fae-arbpl
        AND endda GE @refdt
        AND begda LE @refdt.

    DATA:
      lt_availability TYPE STANDARD TABLE OF zabsf_pp051,
      lt_minutes      TYPE STANDARD TABLE OF zabsf_pp051,
      lt_total        TYPE STANDARD TABLE OF zabsf_pp051.

    " Sumarize values on tables
    LOOP AT lt_pp051 ASSIGNING FIELD-SYMBOL(<ls_pp051>).
      CASE <ls_pp051>-oeeid.
        WHEN gc_oeeid_availabily.
          COLLECT
            VALUE zabsf_pp051(
              arbpl  = <ls_pp051>-arbpl
              qtdoee = <ls_pp051>-qtdoee
            ) INTO lt_availability.

          COLLECT
            VALUE zabsf_pp051(
              arbpl  = <ls_pp051>-arbpl
              qtdoee = 1
            ) INTO lt_total.
        WHEN gc_oeeid_planned_time OR gc_oeeid_production_time.
          COLLECT
            VALUE zabsf_pp051(
              arbpl  = <ls_pp051>-arbpl
              qtdoee = COND #( WHEN <ls_pp051>-oeeid EQ gc_oeeid_planned_time THEN <ls_pp051>-qtdoee ELSE <ls_pp051>-qtdoee * -1 )
            ) INTO lt_minutes.
      ENDCASE.
    ENDLOOP.

    " Calculate values
    LOOP AT lt_availability ASSIGNING FIELD-SYMBOL(<ls_availability>).
      DATA(lv_total)        = lt_total[ arbpl = <ls_availability>-arbpl ]-qtdoee.
      DATA(lv_minutes)      = lt_minutes[ arbpl = <ls_availability>-arbpl ]-qtdoee.
      DATA(lv_availability) = <ls_availability>-qtdoee / lv_total. " Get the Average
      DATA(lv_goal)         = VALUE #( lt_goals[ arbpl = <ls_availability>-arbpl ]-goal OPTIONAL ).

      APPEND
        VALUE #(
          workcenterid = <ls_availability>-arbpl
          availability = lv_availability
          minutes      = lv_minutes
          goal         = lv_goal
          delta        = lv_goal - lv_availability
        ) TO rt_availability.
    ENDLOOP.

    SORT rt_availability BY delta DESCENDING.
  ENDMETHOD.


METHOD get_dashboard_detail.

*Local references
  DATA: lref_sf_wrkctr    TYPE REF TO zabsf_pp_cl_wrkctr,
        lref_sf_dashboard TYPE REF TO zabsf_pp_cl_dashboard.

*Internal tables and structures
  DATA: ls_return               TYPE bapiret2,
        lt_workcenter           TYPE zabsf_pp_t_wrkctr,
        ls_workcenter           LIKE LINE OF lt_workcenter,
        ls_workcenter_detail    TYPE zabsf_pp_s_wrkctr_detail,
        ls_workcenter_dashboard TYPE zabsf_pp_s_workcenter_dashboar,
        ls_hierarchies          TYPE zabsf_pp_s_hrchy.

  DATA: "ls_prodord LIKE LINE OF wrkctr_detail-prord_tab,
    ls_afko  TYPE afko,
    ls_afvc  TYPE afvc,
    ls_afvv  TYPE afvv,
    lv_vgw02 TYPE vgwrt,
    lv_bmsch TYPE bmsch.

  DATA: lv_qty_out TYPE bstmg,
        lv_un_out  TYPE lrmei,
        lv_matnr   TYPE matnr,
        lt_afru    TYPE STANDARD TABLE OF afru,
        l_lmnga    TYPE ru_lmnga,
        l_xmnga    TYPE ru_xmnga,
        l_rmnga    TYPE ru_rmnga.

  CONSTANTS ct_kg(2) VALUE 'KG'.



*Create objects of references
  CREATE OBJECT lref_sf_wrkctr
    EXPORTING
      initial_refdt = refdt
      input_object  = inputobj.

  CREATE OBJECT lref_sf_dashboard
    EXPORTING
      input_refdt    = refdt
      input_inputobj = inputobj.

  IF arbpl IS INITIAL.
*  Fetch all workcenters
    LOOP AT hierarchies INTO ls_hierarchies.

      CALL METHOD lref_sf_dashboard->get_workcenters_list
        EXPORTING
          hname      = ls_hierarchies-hname
          werks      = inputobj-werks
        CHANGING
          wrkctr_tab = lt_workcenter
          return_tab = return_tab.

* BEG - João Lopes - 24.02.2023
* Areas: OPT e MTG - sort hierarchies and work centers by "KTEXT" field
*        MEC - sort hierarchies and work centers by "ARBPL" field
    IF inputobj-areaid <> 'MEC'.
      SORT lt_workcenter BY ktext.
    ELSE.
      SORT lt_workcenter BY arbpl.
    ENDIF.
* END - João Lopes

      LOOP AT lt_workcenter INTO ls_workcenter.
*      For each workcenter, get details
        CALL METHOD lref_sf_dashboard->get_workcenter_short_detail
          EXPORTING
            areaid        = inputobj-areaid
            werks         = inputobj-werks
            hname         = ls_hierarchies-hname
            arbpl         = CONV #( ls_workcenter-arbpl )
          CHANGING
            wrkctr_detail = ls_workcenter_detail
            return_tab    = return_tab.

**MJP:FIM:ABACO_ABAP: 06.06.2019 14:15:55
*  Get all orders from Z table
        SELECT *
          FROM zabsf_pp021
          INTO TABLE @DATA(lt_zlp_pp_sf021)
         WHERE arbpl EQ @ls_workcenter-arbpl
          AND status_oper NE 'CONC'
          AND status_oper NE 'AGU'
          AND status_oper NE 'INI'.


        LOOP AT lt_zlp_pp_sf021 INTO DATA(ls_sf021).

          SELECT SINGLE * FROM afko INTO ls_afko
            WHERE aufnr = ls_sf021-aufnr.

* get routing anf counter
          SELECT SINGLE * FROM afvc INTO ls_afvc
            WHERE aufpl EQ ls_afko-aufpl
              AND vornr EQ ls_sf021-vornr.

* get quantity of operation
          SELECT SINGLE * FROM afvv INTO ls_afvv
            WHERE aufpl = ls_afvc-aufpl
            AND aplzl = ls_afvc-aplzl.

          SELECT * FROM afru INTO CORRESPONDING FIELDS OF TABLE lt_afru
                 WHERE rueck EQ ls_afvc-rueck
                   AND aufnr EQ ls_sf021-aufnr
                   AND vornr EQ ls_sf021-vornr
                   AND stokz EQ space
                   AND stzhl EQ space.

          LOOP AT lt_afru INTO DATA(ls_afru).

            IF ls_afru-meinh NE 'KG'.

              IF ls_afko-plnbez IS INITIAL.
                lv_matnr = ls_afko-stlbez.
              ELSE.
                lv_matnr = ls_afko-plnbez.
              ENDIF.

* SEMPRE NA GELPEIXE
              lv_un_out = ct_kg.

*xmnga - Refugo a ser confirmado neste momento
              CLEAR lv_qty_out.
              CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
                EXPORTING
                  i_matnr              = lv_matnr
                  i_in_me              = ls_afru-meinh
                  i_out_me             = lv_un_out
                  i_menge              = ls_afru-xmnga
                IMPORTING
                  e_menge              = lv_qty_out
                EXCEPTIONS
                  error_in_application = 1
                  error                = 2
                  OTHERS               = 3.

              l_xmnga = l_xmnga + lv_qty_out.

            ELSE.
              l_xmnga = l_xmnga + ls_afru-xmnga.
            ENDIF.

          ENDLOOP.
        ENDLOOP.

**MJP:FIM:ABACO_ABAP: 06.06.2019 14:15:55
        ls_workcenter_detail-prd_sheet_defects = l_xmnga.

*      Assign values to export table
        CALL METHOD lref_sf_dashboard->map_values
          EXPORTING
            workcenter_detail    = ls_workcenter_detail
          CHANGING
            workcenter_dashboard = ls_workcenter_dashboard.

        APPEND ls_workcenter_dashboard TO workcenter_dashboard.

        CLEAR: ls_workcenter_detail, ls_workcenter_dashboard.
      ENDLOOP.

      CLEAR ls_hierarchies.
      REFRESH lt_workcenter.
    ENDLOOP.
  ELSE.
*  For each workcenter, get details
    CALL METHOD lref_sf_dashboard->get_workcenter_short_detail
      EXPORTING
        areaid        = inputobj-areaid
        werks         = inputobj-werks
        hname         = hname
        arbpl         = arbpl
      CHANGING
        wrkctr_detail = ls_workcenter_detail
        return_tab    = return_tab.

    IF aufnr IS NOT INITIAL AND vornr IS NOT INITIAL.
*    Get information for a specific workcenter/production order/operation
      CALL METHOD lref_sf_dashboard->get_workcenter_full_detail
        EXPORTING
          aufnr                = aufnr
          vornr                = vornr
          wrkctr_detail        = ls_workcenter_detail
        CHANGING
          workcenter_dashboard = ls_workcenter_dashboard
          return_tab           = return_tab.

    ENDIF.
*  Calculate oee indicators for only 1 workcenter.
    CALL METHOD lref_sf_dashboard->calculate_oee_indicators
      EXPORTING
        workcenter_detail    = ls_workcenter_detail
      CHANGING
        workcenter_dashboard = ls_workcenter_dashboard.

    APPEND ls_workcenter_dashboard TO workcenter_dashboard.
  ENDIF.
ENDMETHOD.


METHOD get_hierarchies.
*Types
  TYPES: BEGIN OF ty_crtx,
           name  TYPE cr_hname,
           ktext TYPE cr_ktext,
         END OF ty_crtx.

*Internl tables
  DATA: lt_crtx TYPE TABLE OF ty_crtx.

  "  IF inputobj-areaid IS INITIAL.

  SELECT DISTINCT werks areaid hname
     FROM zabsf_pp002
     INTO CORRESPONDING FIELDS OF TABLE hierarchies
    WHERE werks EQ inputobj-werks
      AND begda LE sy-datum
      AND endda GE sy-datum.

  " ELSE.
*      SELECT * FROM zlp_pp_sf002 INTO CORRESPONDING FIELDS OF TABLE hierarchies
*        WHERE werks = inputobj-werks
*        AND areaid = inputobj-areaid
*        AND begda LE sy-datum
*        AND endda GE sy-datum.

  "  ENDIF.

  CHECK hierarchies IS NOT INITIAL.

*    SORT hierarchies BY hname.
*    DELETE ADJACENT DUPLICATES FROM hierarchies COMPARING hname.

*  Get hierarchy description
  SELECT crhh~name crtx~ktext
    INTO CORRESPONDING FIELDS OF TABLE lt_crtx
    FROM crtx AS crtx
   INNER JOIN crhh AS crhh
      ON crhh~objty EQ crtx~objty
     AND crhh~objid EQ crtx~objid
     FOR ALL ENTRIES IN hierarchies
   WHERE crhh~name  EQ hierarchies-hname
     AND crhh~werks EQ hierarchies-werks
     AND crhh~objty EQ 'H'
     AND crtx~spras EQ inputobj-language.

  IF lt_crtx[] IS INITIAL.
*    Get alternative language
    SELECT SINGLE spras
      FROM zabsf_pp061
      INTO (@DATA(l_langu))
     WHERE werks      EQ @inputobj-werks
       AND is_default NE @space.
    IF  sy-subrc IS INITIAL.
*    Get hierarchy description
      SELECT crhh~name crtx~ktext
        INTO CORRESPONDING FIELDS OF TABLE lt_crtx
        FROM crtx AS crtx
       INNER JOIN crhh AS crhh
          ON crhh~objty EQ crtx~objty
         AND crhh~objid EQ crtx~objid
         FOR ALL ENTRIES IN hierarchies
       WHERE crhh~name  EQ hierarchies-hname
         AND crhh~werks EQ hierarchies-werks
         AND crhh~objty EQ 'H'
         AND crtx~spras EQ l_langu.
    ENDIF.
  ENDIF.

  LOOP AT hierarchies ASSIGNING FIELD-SYMBOL(<fs_hierarchies>).
*    Read hierarchy description
    READ TABLE lt_crtx INTO DATA(ls_crtx) WITH KEY name = <fs_hierarchies>-hname.

    IF sy-subrc EQ 0.
*      Hierarchy description
      <fs_hierarchies>-ktext = ls_crtx-ktext.
    ENDIF.
  ENDLOOP.
ENDMETHOD.


  METHOD get_losts.
    DATA(lv_spras) = CONV spras( inputobj-language ).
    DATA(lv_prev_day) = CONV datum( refdt - 1 ).

    " Get All Scraps
    SELECT grund, scrap_qty
      FROM zabsf_pp034
      INTO TABLE @DATA(lt_pp034)
      WHERE hname IN @gr_hname
        AND arbpl IN @gr_arbpl
        AND ( ( data EQ @lv_prev_day AND
                time GE @gc_start_time ) OR
              ( data EQ @refdt AND
                time LE @gc_start_time ) ).
    CHECK sy-subrc IS INITIAL.

    " Sumarize by reason
    DATA lt_losts TYPE STANDARD TABLE OF zabsf_pp034.
    LOOP AT lt_pp034 ASSIGNING FIELD-SYMBOL(<ls_pp034>).
      COLLECT
        VALUE zabsf_pp034(
          grund     = <ls_pp034>-grund
          scrap_qty = <ls_pp034>-scrap_qty
        ) INTO lt_losts.
    ENDLOOP.

    SELECT grund, grdtx
      FROM trugt
      INTO TABLE @DATA(lt_trugt)
      FOR ALL ENTRIES IN @lt_losts
      WHERE spras EQ @lv_spras
        AND grund EQ @lt_losts-grund.

    " Sumarize Total
    DATA(lv_total) =
      REDUCE #(
        INIT t = '0.0'
        FOR l IN lt_losts
        NEXT t = t + l-scrap_qty ).

    " Fill result table
    LOOP AT lt_losts ASSIGNING FIELD-SYMBOL(<ls_losts>).
      APPEND
        VALUE #(
          defect     = |{ <ls_losts>-grund } - { VALUE #( lt_trugt[ grund = <ls_losts>-grund ]-grdtx OPTIONAL ) }|
          percentage = <ls_losts>-scrap_qty / lv_total * 100
        ) TO rt_losts.
    ENDLOOP.
  ENDMETHOD.


METHOD get_operators.

    DATA: ls_oprid        TYPE zabsf_pp_s_operador,
          ls_zlp_pp_sf014 TYPE zabsf_pp014.

*  Get operator associated to Production Order
    SELECT *
      FROM zabsf_pp014
      INTO TABLE @DATA(lt_zlp_pp_sf014)
     WHERE arbpl  EQ @prodord-arbpl
       AND aufnr  EQ @prodord-aufnr
       AND vornr  EQ @prodord-vornr
       AND status EQ 'A'.

    SORT lt_zlp_pp_sf014 BY udate utime ASCENDING.

    IF lt_zlp_pp_sf014[] IS NOT INITIAL.
      LOOP AT lt_zlp_pp_sf014 INTO ls_zlp_pp_sf014.
        CLEAR ls_oprid.

*      Operator
        ls_oprid-oprid = ls_zlp_pp_sf014-oprid.

*      Operator name
*        SELECT SINGLE vorna, nachn
*          FROM pa0002
*          INTO (@DATA(l_vorna), @DATA(l_nachn))
*         WHERE pernr EQ @ls_zlp_pp_sf014-oprid.
*
*        IF l_vorna IS NOT INITIAL OR l_nachn IS NOT INITIAL.
**        First and last name
*          CONCATENATE l_vorna l_nachn INTO ls_oprid-nome SEPARATED BY space.
*        ENDIF.

*      Status
        ls_oprid-status = ls_zlp_pp_sf014-status.

        APPEND ls_oprid TO prodord-oprid_tab.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


METHOD get_operator_monthly_log.
*  Internal tables
    DATA: lt_selection     TYPE TABLE OF rsparams,
          lt_output_report TYPE TABLE OF zabsf_pp_s_calc_workers_kpi,
          lt_values_domain TYPE TABLE OF dd07v.

*  Structures
    DATA: ls_selection    TYPE rsparams,
          ls_kpi          TYPE zabsf_pp_s_calc_workers_kpi,
          ls_operator_log TYPE zabsf_pp_s_operator_log.
*  Variables
    DATA l_langu TYPE dd07t-ddlanguage.

*  Constants
    CONSTANTS: c_domname TYPE dd07l-domname VALUE 'ZABSF_PP_E_SITESPECIAL'.

*  Language
    l_langu = inputobj-language.

*  Get description for domain Special Situations
    CALL FUNCTION 'DD_DOMVALUES_GET'
      EXPORTING
        domname        = c_domname
        text           = abap_true
        langu          = l_langu
      TABLES
        dd07v_tab      = lt_values_domain
      EXCEPTIONS
        wrong_textflag = 1
        OTHERS         = 2.

    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

*  Create ranges - Operator
    IF inputobj-pernr IS NOT INITIAL.
      CLEAR ls_selection.
      ls_selection-sign = 'I'.
      ls_selection-option = 'EQ'.
      ls_selection-low = inputobj-pernr.
      ls_selection-kind = 'S'.
      ls_selection-selname = 'SO_PERNR'.
      APPEND ls_selection TO lt_selection.
    ENDIF.

*  Date limit for processing
    CLEAR ls_selection.
    ls_selection-low = sy-datlo.
    ls_selection-kind = 'P'.
    ls_selection-selname = 'P_LIM_DT'.
    APPEND ls_selection TO lt_selection.

*  Submit program
    SUBMIT zpp02_calc_workers_kpi WITH SELECTION-TABLE lt_selection
                                  WITH p_backsf EQ abap_true AND
                                  RETURN.

*  Get internal tables with detail information
    IMPORT gt_output TO lt_output_report FROM MEMORY ID 'GT_OUTPUT'.

    IF lt_output_report[] IS NOT INITIAL.
      LOOP AT lt_output_report INTO DATA(ls_output_report).
        CLEAR ls_kpi.

*      Move same fields to output table
        MOVE-CORRESPONDING ls_output_report TO ls_kpi.

        APPEND ls_kpi TO kpi_tab.
      ENDLOOP.

      SORT kpi_tab BY tmp_data DESCENDING tmp_turno DESCENDING.

      CLEAR ls_kpi.

      LOOP AT kpi_tab INTO ls_kpi.
        CLEAR ls_operator_log.

*      Date
        ls_operator_log-date = ls_kpi-tmp_data.
*      Shift ID
        ls_operator_log-shfif = ls_kpi-tmp_turno.
*      Material description
        ls_operator_log-description = ls_kpi-tmp_dscmolde.
*      Work time
        ls_operator_log-work_time = ls_kpi-tmp_ttrab.
*      Stop time
        ls_operator_log-stop_time = ls_kpi-tmp_tpara1.
*      Quantity produced
        ls_operator_log-qty_prod = ls_kpi-tmp_producao.
*      Box quantity
        ls_operator_log-qty_box = ls_kpi-tmp_embalado.
*      Quantity planned
        ls_operator_log-qty_plan = ls_kpi-tmp_planeado.
*      Bonus
        IF ls_operator_log-qty_plan IS NOT INITIAL.
          ls_operator_log-bonus = ( ls_operator_log-qty_box / ls_operator_log-qty_plan ) * 100.
        ENDIF.

*      Get description for Specila Situation
        READ TABLE lt_values_domain INTO DATA(ls_values_domain) WITH KEY domvalue_l = ls_kpi-tmp_sitespecial.

        IF sy-subrc EQ 0.
*        Special situations
          ls_operator_log-spec_situation = ls_values_domain-ddtext.
        ENDIF.

        APPEND ls_operator_log TO operator_log_tab.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


  METHOD get_performance.
    " Get Performance
    SELECT *
      FROM zabsf_pp051
      INTO TABLE @DATA(lt_pp051)
      WHERE hname IN @gr_hname
        AND arbpl IN @gr_arbpl
        AND oeeid EQ @gc_oeeid_performance
        AND data  EQ @refdt.
    CHECK lt_pp051[] IS NOT INITIAL.
    SORT lt_pp051 BY arbpl oeeid.

    " Get Goals
    DATA(lt_fae) = lt_pp051[].
    DELETE ADJACENT DUPLICATES FROM lt_fae COMPARING arbpl.

    SELECT *
      FROM zabsf_pp092
      INTO TABLE @DATA(lt_goals)
      FOR ALL ENTRIES IN @lt_fae
      WHERE arbpl EQ @lt_fae-arbpl
        AND endda GE @refdt
        AND begda LE @refdt.

    DATA:
      lt_performance TYPE STANDARD TABLE OF zabsf_pp051,
      lt_total       TYPE STANDARD TABLE OF zabsf_pp051.

    " Sumarize values on tables
    LOOP AT lt_pp051 ASSIGNING FIELD-SYMBOL(<ls_pp051>).
      COLLECT
        VALUE zabsf_pp051(
          arbpl  = <ls_pp051>-arbpl
          qtdoee = <ls_pp051>-qtdoee
        ) INTO lt_performance.

      COLLECT
        VALUE zabsf_pp051(
          arbpl  = <ls_pp051>-arbpl
          qtdoee = 1
        ) INTO lt_total.
    ENDLOOP.

    " Calculate values
    LOOP AT lt_performance ASSIGNING FIELD-SYMBOL(<ls_performance>).
      DATA(lv_total)       = lt_total[ arbpl = <ls_performance>-arbpl ]-qtdoee.
      DATA(lv_goal)        = VALUE #( lt_goals[ arbpl = <ls_performance>-arbpl ]-goal OPTIONAL ).
      DATA(lv_performance) = <ls_performance>-qtdoee / lv_total. " Get the Average

      APPEND
        VALUE #(
          workcenterid = <ls_performance>-arbpl
          performance  = <ls_performance>-qtdoee / lv_total
          goal         = lv_goal
          delta        = lv_goal - lv_performance
        ) TO rt_performance.
    ENDLOOP.

    SORT rt_performance BY delta DESCENDING.
  ENDMETHOD.


  METHOD get_quality.
    " Get Availability
    SELECT *
      FROM zabsf_pp051
      INTO TABLE @DATA(lt_pp051)
      WHERE hname IN @gr_hname
        AND arbpl IN @gr_arbpl
        AND oeeid EQ @gc_oeeid_quality
        AND data  EQ @refdt.
    CHECK lt_pp051[] IS NOT INITIAL.
    SORT lt_pp051 BY arbpl oeeid.

    " Get Goals
    DATA(lt_fae) = lt_pp051[].
    DELETE ADJACENT DUPLICATES FROM lt_fae COMPARING arbpl.

    SELECT *
      FROM zabsf_pp091
      INTO TABLE @DATA(lt_goals)
      FOR ALL ENTRIES IN @lt_fae
      WHERE arbpl EQ @lt_fae-arbpl
        AND endda GE @refdt
        AND begda LE @refdt.

    DATA:
      lt_quality TYPE STANDARD TABLE OF zabsf_pp051,
      lt_total   TYPE STANDARD TABLE OF zabsf_pp051.

    " Sumarize values on tables
    LOOP AT lt_pp051 ASSIGNING FIELD-SYMBOL(<ls_pp051>).
      COLLECT
        VALUE zabsf_pp051(
          arbpl  = <ls_pp051>-arbpl
          qtdoee = <ls_pp051>-qtdoee
        ) INTO lt_quality.

      COLLECT
        VALUE zabsf_pp051(
          arbpl  = <ls_pp051>-arbpl
          qtdoee = 1
        ) INTO lt_total.
    ENDLOOP.

    " Calculate values
    LOOP AT lt_quality ASSIGNING FIELD-SYMBOL(<ls_quality>).
      DATA(lv_total)   = lt_total[ arbpl = <ls_quality>-arbpl ]-qtdoee.
      DATA(lv_goal)    = VALUE #( lt_goals[ arbpl = <ls_quality>-arbpl ]-goal OPTIONAL ).
      DATA(lv_quality) = <ls_quality>-qtdoee / lv_total. " Get the Average

      APPEND
        VALUE #(
          workcenterid = <ls_quality>-arbpl
          quality      = <ls_quality>-qtdoee / lv_total
          goal         = lv_goal
          delta        = lv_goal - lv_quality
        ) TO rt_quality.
    ENDLOOP.

    SORT rt_quality BY delta DESCENDING.
  ENDMETHOD.


  METHOD get_review.
    " Get review
    SELECT *
      FROM zabsf_pp051
      INTO TABLE @DATA(lt_pp051)
      WHERE hname IN @gr_hname
        AND arbpl IN @gr_arbpl
        AND oeeid EQ @gc_oeeid_oee
        AND data  EQ @refdt.
    CHECK lt_pp051[] IS NOT INITIAL.
    SORT lt_pp051 BY arbpl oeeid.

    DATA:
      lt_review TYPE STANDARD TABLE OF zabsf_pp051,
      lt_total  TYPE STANDARD TABLE OF zabsf_pp051.

    " Sumarize values on tables
    LOOP AT lt_pp051 ASSIGNING FIELD-SYMBOL(<ls_pp051>).
      COLLECT
        VALUE zabsf_pp051(
          arbpl   = <ls_pp051>-arbpl
          shiftid = <ls_pp051>-shiftid
          qtdoee  = <ls_pp051>-qtdoee
        ) INTO lt_review.

      COLLECT
        VALUE zabsf_pp051(
          arbpl   = <ls_pp051>-arbpl
          shiftid = <ls_pp051>-shiftid
          qtdoee  = 1
        ) INTO lt_total.
    ENDLOOP.

    " Calculate values
    LOOP AT lt_review ASSIGNING FIELD-SYMBOL(<ls_review>).
      DATA(lv_total)  = lt_total[ arbpl = <ls_review>-arbpl shiftid = <ls_review>-shiftid ]-qtdoee.
      DATA(lv_review) = <ls_review>-qtdoee / lv_total. " Get the Average

      APPEND
        VALUE #(
          workcenterid = <ls_review>-arbpl
          shiftid      = <ls_review>-shiftid
          percentage   = <ls_review>-qtdoee / lv_total
        ) TO rt_review.
    ENDLOOP.

    SORT rt_review BY workcenterid shiftid.
  ENDMETHOD.


  METHOD get_stops.
    DATA(lv_prev_day) = refdt - 1.

    " Get Stops time
    SELECT s~*
      FROM zabsf_pp010 AS s
        INNER JOIN zabsf_pp011 AS r
          ON r~areaid   EQ s~areaid   AND
             r~werks    EQ s~werks    AND
             r~arbpl    EQ s~arbpl    AND
             r~stprsnid EQ s~stprsnid AND
             r~endda    GE s~datesr   AND
             r~begda    LE s~datesr
      INTO TABLE @DATA(lt_pp010)
      WHERE s~hname      IN @gr_hname
        and s~arbpl      IN @gr_arbpl
        AND ( ( s~datesr EQ @lv_prev_day AND
                s~time   GE @gc_start_time ) OR
              ( s~datesr EQ @refdt AND
                s~time   LE @gc_start_time ) )
        AND s~stoptime   NE 0
        AND r~motivetype EQ @gc_mtype_not_planned.

    SORT lt_pp010 BY arbpl stprsnid.

    " Sumarize by reason
    DATA lt_stops TYPE STANDARD TABLE OF zabsf_pp010.
    LOOP AT lt_pp010 ASSIGNING FIELD-SYMBOL(<ls_pp010>).
      COLLECT
        VALUE zabsf_pp010(
          stprsnid = <ls_pp010>-stprsnid
          stoptime = <ls_pp010>-stoptime
        ) INTO lt_stops.
    ENDLOOP.

    " Sumarize Total
    DATA(lv_total) =
      REDUCE #(
        INIT t = '00000.0000'
        FOR s IN lt_stops
        NEXT t = t + s-stoptime ).

    " Fill result table
    LOOP AT lt_stops ASSIGNING FIELD-SYMBOL(<ls_stop>).
      APPEND
        VALUE #(
          reason     = <ls_stop>-stprsnid
          percentage = <ls_stop>-stoptime / lv_total * 100
        ) TO rt_stops.
    ENDLOOP.
  ENDMETHOD.


METHOD get_workcenters_list.

*Internal tables
    DATA: lt_crhs TYPE TABLE OF crhs,
          lt_crhd TYPE TABLE OF crhd,
          lt_crtx TYPE TABLE OF crtx.

*Structures
    DATA: ls_crhd   TYPE crhd,
          ls_crtx   TYPE crtx,
          ls_wrkctr TYPE zabsf_pp_s_wrkctr,
          ls_sf013  TYPE zabsf_pp013.
*Variables
    DATA: l_hrchy_objid TYPE cr_objid,
          l_shiftid     TYPE zabsf_pp_e_shiftid,
          l_langu       TYPE sy-langu.

    CLEAR: l_langu,
           l_shiftid.

*Set local language for user
    l_langu = inputobj-language.

    SET LOCALE LANGUAGE l_langu.

*Translate to upper case
    TRANSLATE inputobj-oprid TO UPPER CASE.

*Get Hierarchy Object ID
    CALL FUNCTION 'CR_HIERARCHY_READ_NAME'
      EXPORTING
        name                = hname
        werks               = werks
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

        CHECK lt_crhs IS NOT INITIAL.

        SELECT objty objid arbpl
          FROM crhd
          INTO CORRESPONDING FIELDS OF TABLE lt_crhd
           FOR ALL ENTRIES IN lt_crhs
         WHERE objty EQ lt_crhs-objty_ho
           AND objid EQ lt_crhs-objid_ho.

        IF lt_crhd[] IS NOT INITIAL.
*>> BMR 17.11.2016 - remove WC that represents hierarchy
          LOOP AT lt_crhd INTO ls_crhd.

            SELECT SINGLE * FROM zabsf_pp013 INTO ls_sf013
              WHERE werks = werks
              AND arbpl = ls_crhd-arbpl
              AND begda LE sy-datlo
              AND endda GE sy-datlo.
            IF sy-subrc NE 0.

              DELETE lt_crhd.
            ENDIF.
            CLEAR ls_crhd.
          ENDLOOP.

          CHECK lt_crhd IS NOT INITIAL.
*<< END BMR 17.11.2016 - remove WC that represents hierarchy


*      Get Workcenter description
          SELECT *
            FROM crtx
            INTO CORRESPONDING FIELDS OF TABLE lt_crtx
             FOR ALL ENTRIES IN lt_crhd
           WHERE objty EQ lt_crhd-objty
             AND objid EQ lt_crhd-objid
             AND spras EQ sy-langu.

          IF lt_crtx[] IS INITIAL.
            CLEAR l_langu.

*        Get alternative language
            SELECT SINGLE spras
              FROM zabsf_pp061
              INTO l_langu
             WHERE werks      EQ werks
               AND is_default NE space.

            IF sy-subrc EQ 0.
*          Get Workcenter description in alternative language
              SELECT *
                FROM crtx
                INTO CORRESPONDING FIELDS OF TABLE lt_crtx
                 FOR ALL ENTRIES IN lt_crhd
               WHERE objty EQ lt_crhd-objty
                 AND objid EQ lt_crhd-objid
                 AND spras EQ sy-langu.
            ENDIF.
          ENDIF.

          LOOP AT lt_crhd INTO ls_crhd.
            CLEAR ls_wrkctr.

*        Workcenter
            ls_wrkctr-arbpl = ls_crhd-arbpl.

*        Read work center description
            READ TABLE lt_crtx INTO ls_crtx WITH KEY objty = ls_crhd-objty
                                                     objid = ls_crhd-objid.

            IF sy-subrc EQ 0.
*          Work center description
              ls_wrkctr-ktext = ls_crtx-ktext.
            ENDIF.

            APPEND ls_wrkctr TO wrkctr_tab.
          ENDLOOP.
        ENDIF.

        IF wrkctr_tab[] IS INITIAL.
*     No workcenters found
          CALL METHOD zabsf_pp_cl_log=>add_message
            EXPORTING
              msgty      = 'E'
              msgno      = '006'
            CHANGING
              return_tab = return_tab.
        ENDIF.
      ELSE.
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
            return_tab = return_tab.
      ENDIF.
    ELSE.
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
          return_tab = return_tab.
    ENDIF.
  ENDMETHOD.


  METHOD get_workcenter_dashboard.
    " Get Eleven months before to get Evolution Data
    DATA(lv_evolution_date) = CONV datum( refdt(6) && '01' ).

    CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
      EXPORTING
        date      = lv_evolution_date
        days      = 0
        months    = 11
        signum    = '-'
        years     = 0
      IMPORTING
        calc_date = lv_evolution_date.

    " Select Data
    SELECT *
      FROM zabsf_pp051
      INTO TABLE @DATA(lt_pp051)
      WHERE ( hname IN @gr_hname AND
              arbpl IN @gr_arbpl AND
              data  EQ @refdt )
        OR  ( hname IN @gr_hname AND
              oeeid EQ @gc_oeeid_oee AND
              data  GE @lv_evolution_date ).
    SORT lt_pp051 BY shiftid data.

    DATA:
      lv_ac        TYPE i,
      lv_pc        TYPE i,
      lv_qc        TYPE i,
      lv_oc        TYPE i,
      lt_evolution TYPE STANDARD TABLE OF zabsf_pp051,
      lt_total     TYPE STANDARD TABLE OF zabsf_pp051.

    LOOP AT lt_pp051 ASSIGNING FIELD-SYMBOL(<ls_pp051>).
      CASE <ls_pp051>-oeeid.
        WHEN 1. "DISP - Availabily
          ADD <ls_pp051>-qtdoee TO ev_availability.
          ADD 1 TO lv_ac.

        WHEN 2. "PERF - Performance
          ADD <ls_pp051>-qtdoee TO ev_performance.
          ADD 1 TO lv_pc.

        WHEN 3. "QUAL - Quality
          ADD <ls_pp051>-qtdoee TO ev_quality.
          ADD 1 TO lv_qc.

        WHEN 4. "OEE
          IF <ls_pp051>-data EQ refdt.
            ADD <ls_pp051>-qtdoee TO ev_oee.
            ADD 1 TO lv_oc.
          ENDIF.

          COLLECT
            VALUE zabsf_pp051(
              data    = <ls_pp051>-data(6) && '01'
              shiftid = <ls_pp051>-shiftid
              qtdoee  = <ls_pp051>-qtdoee
            ) INTO lt_evolution.

          COLLECT
            VALUE zabsf_pp051(
              data    = <ls_pp051>-data(6) && '01'
              shiftid = <ls_pp051>-shiftid
              qtdoee  = 1
            ) INTO lt_total.
      ENDCASE.
    ENDLOOP.

    " Calculate Average
    ev_availability = COND #( WHEN lv_ac NE 0 THEN ev_availability / lv_ac ).
    ev_performance = COND #( WHEN lv_pc NE 0 THEN ev_performance / lv_pc ).
    ev_quality = COND #( WHEN lv_qc NE 0 THEN ev_quality / lv_qc ).
    ev_oee = COND #( WHEN lv_oc NE 0 THEN ev_oee / lv_oc ).

    DATA(lv_spras) = CONV spras( inputobj-language ).

    IF lv_spras IS INITIAL.
      lv_spras = sy-langu.
    ENDIF.

    SELECT *
      FROM t247
      INTO TABLE @DATA(lt_t247)
      WHERE spras EQ @lv_spras.

    LOOP AT lt_evolution ASSIGNING FIELD-SYMBOL(<ls_evolution>).
      DATA(ls_total) = lt_total[ data = <ls_evolution>-data shiftid = <ls_evolution>-shiftid ].

      APPEND
        VALUE #(
          period     = <ls_evolution>-data(6)
          month      = VALUE #( lt_t247[ mnr = <ls_evolution>-data+4(2) ]-ltx OPTIONAL )
          shiftid    = <ls_evolution>-shiftid
          percentage = <ls_evolution>-qtdoee / ls_total-qtdoee
        ) TO et_evolution.
    ENDLOOP.
  ENDMETHOD.


METHOD get_workcenter_full_detail.

    DATA: lref_sf_prdord TYPE REF TO zabsf_pp_cl_prdord.

    DATA: lt_zlp_pp_sf017 TYPE TABLE OF zabsf_pp017.

    DATA: ls_prodord LIKE LINE OF wrkctr_detail-prord_tab,
          ls_afko    TYPE afko,
          ls_afvc    TYPE afvc,
          ls_afvv    TYPE afvv,
          lv_vgw02   TYPE vgwrt,
          lv_bmsch   TYPE bmsch.

    DATA: lv_qty_out TYPE bstmg,
          lv_un_out  TYPE lrmei,
          lv_matnr   TYPE matnr,
          lt_afru    TYPE STANDARD TABLE OF afru,
          l_gmnga    TYPE gmnga,
          l_lmnga    TYPE ru_lmnga,
          l_xmnga    TYPE ru_xmnga,
          l_rmnga    TYPE ru_rmnga.

    DATA: lv_shift_time_c TYPE xuvalue,
          lv_shift_time   TYPE int4,
          lv_aux          TYPE f,
          lv_aux2         TYPE f. " DECIMALS 2.

    CONSTANTS ct_kg(2) VALUE 'KG'.

    SELECT SINGLE parva FROM zabsf_pp032 INTO lv_shift_time_c
      WHERE werks EQ wrkctr_detail-werks
      AND parid = 'SHIFT_TIME'.

    IF sy-subrc NE 0.

      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'E'
          msgno      = '085'
        CHANGING
          return_tab = return_tab.
      EXIT.

    ENDIF.

*  Create object of class prdord
    CREATE OBJECT lref_sf_prdord
      EXPORTING
        initial_refdt = refdt
        input_object  = inputobj.

    MOVE lv_shift_time_c TO lv_shift_time.

* Quantity to Make - AFKO -> AFVC -> AFVV-MGVRG para a operação

* Quantity Produced - AFRU  (AFVV - LMNGA )   AFVV-XMNGA

* Scrap Quantity (AFRU) – Scrap Percentage of Total Quantity to Make - Se for 0
* Missing Quantity with Scrap -
* Remaining Shifts with Scrap -
* Missing Quantity without Scrap -
* Remaining Shifts without Scrap -

*AFKO- sacar o nº de roteiro.
*
*AFVC - routeiro + operaçao = nº da confirmação.


*  Get all orders from Z table
    SELECT *
      FROM zabsf_pp021
      INTO TABLE @DATA(lt_zlp_pp_sf021)
     WHERE arbpl EQ @wrkctr_detail-arbpl
      AND status_oper NE 'CONC'
      AND status_oper NE 'AGU'
      AND status_oper NE 'INI'.

    LOOP AT lt_zlp_pp_sf021 INTO DATA(ls_sf021).



* get routing number
      SELECT SINGLE * FROM afko INTO ls_afko
        WHERE aufnr = ls_sf021-aufnr.

* get routing anf counter
      SELECT SINGLE * FROM afvc INTO ls_afvc
        WHERE aufpl EQ ls_afko-aufpl
        AND vornr EQ ls_sf021-vornr.

* get quantity of operation
      SELECT SINGLE * FROM afvv INTO ls_afvv
        WHERE aufpl = ls_afvc-aufpl
        AND aplzl = ls_afvc-aplzl.

      IF sy-subrc EQ 0.

* theoretical data of operation
        CALL METHOD lref_sf_prdord->get_theorical_data
          EXPORTING
            aufpl = ls_afko-aufpl
            aplzl = ls_afvc-aplzl
            plnty = ls_afvc-plnty
            plnnr = ls_afvc-plnnr
          IMPORTING
            vgw02 = lv_vgw02 "time per cycle"
            bmsch = lv_bmsch. "quantity per cycle"

*    Confirmed yield
        "lmnga - Qtd.boa a ser confirmada atualmente
        "xmnga - Refugo a ser confirmado neste momento
        "rmnga - Quantidade de tratamento posterior real a confirmar

**MJP:INI:ABACO_ABAP: 06.06.2019 14:31:07
****      SELECT SUM( lmnga ), SUM( xmnga ), SUM( rmnga )
****        FROM afru
****        INTO (@DATA(l_lmnga), @DATA(l_xmnga), @DATA(l_rmnga))
****       WHERE rueck EQ @ls_afvc-rueck
****         AND aufnr EQ @aufnr
****         AND vornr EQ @vornr
****         AND stokz EQ @space
****         AND stzhl EQ @space.

        SELECT * FROM afru INTO CORRESPONDING FIELDS OF TABLE lt_afru
               WHERE rueck EQ ls_afvc-rueck
                 AND aufnr EQ ls_sf021-aufnr
                 AND vornr EQ ls_sf021-vornr
                 AND stokz EQ space
                 AND stzhl EQ space.

        LOOP AT lt_afru INTO DATA(ls_afru).

          IF ls_afru-meinh NE 'KG'.

            IF ls_afko-plnbez IS INITIAL.
              lv_matnr = ls_afko-stlbez.
            ELSE.
              lv_matnr = ls_afko-plnbez.
            ENDIF.

* SEMPRE NA GELPEIXE
            lv_un_out = ct_kg.

*lmnga - Qtd.boa a ser confirmada atualmente
            CLEAR lv_qty_out.
            CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
              EXPORTING
                i_matnr              = lv_matnr
                i_in_me              = ls_afru-meinh
                i_out_me             = lv_un_out
                i_menge              = ls_afru-lmnga
              IMPORTING
                e_menge              = lv_qty_out
              EXCEPTIONS
                error_in_application = 1
                error                = 2
                OTHERS               = 3.

            l_lmnga = l_lmnga + lv_qty_out.

*xmnga - Refugo a ser confirmado neste momento
            CLEAR lv_qty_out.
            CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
              EXPORTING
                i_matnr              = lv_matnr
                i_in_me              = ls_afru-meinh
                i_out_me             = lv_un_out
                i_menge              = ls_afru-xmnga
              IMPORTING
                e_menge              = lv_qty_out
              EXCEPTIONS
                error_in_application = 1
                error                = 2
                OTHERS               = 3.

            l_xmnga = l_xmnga + ls_afru-xmnga.


          ELSE.

            l_lmnga = l_lmnga + ls_afru-lmnga.
            l_xmnga = l_xmnga + ls_afru-xmnga.
*          l_rmnga = l_rmnga + ls_afru-rmnga.

          ENDIF.

        ENDLOOP.

**MJP:FIM:ABACO_ABAP: 06.06.2019 14:15:55

*ls_afvv-gmnga


**MJP:INI:ABACO_ABAP: 06.06.2019 17:38:02
*      workcenter_dashboard-qty_plan = ls_afvv-mgvrg.

        CLEAR lv_matnr.
        IF ls_afko-gmein NE 'KG'.

          IF ls_afko-plnbez IS INITIAL.
            lv_matnr = ls_afko-stlbez.
          ELSE.
            lv_matnr = ls_afko-plnbez.
          ENDIF.

* SEMPRE NA GELPEIXE
          lv_un_out = ct_kg.

*lmnga - Qtd.boa a ser confirmada atualmente
          CLEAR lv_qty_out.
          CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
            EXPORTING
              i_matnr              = lv_matnr
              i_in_me              = ls_afko-gmein
              i_out_me             = lv_un_out
              i_menge              = ls_afko-gamng
            IMPORTING
              e_menge              = lv_qty_out
            EXCEPTIONS
              error_in_application = 1
              error                = 2
              OTHERS               = 3.

          l_gmnga = l_gmnga + lv_qty_out.

        ELSE.
          l_gmnga = l_gmnga + ls_afko-gamng.
        ENDIF.

        workcenter_dashboard-qty_plan = l_gmnga.

**MJP:FIM:ABACO_ABAP: 06.06.2019 17:38:06

        workcenter_dashboard-qty_prod = l_lmnga.
        workcenter_dashboard-scrap_qty = l_xmnga.

        READ TABLE wrkctr_detail-prord_tab INTO ls_prodord INDEX 1.
        APPEND LINES OF ls_prodord-oprid_tab TO workcenter_dashboard-logged_users.

* calculate values
        IF workcenter_dashboard-qty_prod IS NOT INITIAL OR workcenter_dashboard-scrap_qty IS NOT INITIAL.
          lv_aux2 = workcenter_dashboard-scrap_qty / ( workcenter_dashboard-qty_prod + workcenter_dashboard-scrap_qty ).
          workcenter_dashboard-scrap_perc = lv_aux2.
        ENDIF.

        workcenter_dashboard-missing_qty_without_scrap = workcenter_dashboard-qty_plan - workcenter_dashboard-qty_prod.

        IF lv_aux2 IS NOT INITIAL.
*      IF workcenter_dashboard-scrap_perc IS NOT INITIAL.
*        DATA(l_calc_with_scrap) = 1 - workcenter_dashboard-scrap_perc.
          DATA(l_calc_with_scrap) = 1 - lv_aux2.

          IF l_calc_with_scrap IS NOT INITIAL.
*          workcenter_dashboard-missing_qty_with_scrap = workcenter_dashboard-missing_qty_without_scrap / ( 1 - workcenter_dashboard-scrap_perc ).
            workcenter_dashboard-missing_qty_with_scrap = workcenter_dashboard-missing_qty_without_scrap / ( 1 - lv_aux2 ).
          ENDIF.
        ELSE."manter valores iguais ao sem scrap"
          workcenter_dashboard-missing_qty_with_scrap = workcenter_dashboard-missing_qty_without_scrap.
        ENDIF.

* shifts remaining with scrap.
        IF workcenter_dashboard-missing_qty_with_scrap IS NOT INITIAL
          AND ls_afvv-bmsch IS NOT INITIAL.

          lv_aux  =  workcenter_dashboard-missing_qty_with_scrap / lv_bmsch .
          lv_aux  = lv_aux  * lv_vgw02 .
          workcenter_dashboard-remaining_shifts_with_scrap = lv_aux  / lv_shift_time.

        ENDIF.

* shifts remaing without scrap.
        IF workcenter_dashboard-missing_qty_without_scrap IS NOT INITIAL
          AND ls_afvv-bmsch IS NOT INITIAL.

          CLEAR lv_aux.
          lv_aux = workcenter_dashboard-missing_qty_without_scrap / lv_bmsch.
          lv_aux = lv_aux  * lv_vgw02.
          workcenter_dashboard-remaining_shifts_without_scrap = lv_aux  / lv_shift_time.

        ENDIF.
      ENDIF.
    ENDLOOP.

* convert to percentage.
    workcenter_dashboard-scrap_perc = lv_aux2 * 100.

  ENDMETHOD.


METHOD get_workcenter_short_detail.

*Contants:
    CONSTANTS: c_proc(4) VALUE 'PROC',
               c_stop(4) VALUE 'STOP',
               c_prep(4) VALUE 'PREP'.


*References
    DATA: lref_sf_prdord   TYPE REF TO zabsf_pp_cl_prdord,
          lref_sf_status   TYPE REF TO zabsf_pp_cl_status,
          lref_sf_calc_min TYPE REF TO zabsf_pp_cl_event_act.

*Internal Tables
    DATA: lt_afru TYPE TABLE OF afru,
          ls_afru LIKE LINE OF lt_afru.

*Structures
    DATA: ls_zlp_pp_sf058 TYPE zabsf_pp058,
          ls_sf021        TYPE zabsf_pp021,
          ls_prdord       TYPE zabsf_pp_s_prdord_detail.

*Variables
    DATA: l_objid         TYPE cr_objid,
          l_shiftid       TYPE zabsf_pp_e_shiftid,
          l_langu         TYPE sy-langu,
          lv_counter      TYPE co_rmzhl,
          lv_aufnr_status TYPE j_status,
          lv_color_status TYPE zabsf_pp_e_dash_colours,
          lv_minutes      TYPE i,
          lv_status_min   TYPE mengv13.

*Variables get hours ago
    DATA: t1     TYPE t,
          t2     TYPE t,
          d1     TYPE d,
          d2     TYPE d,
          l_days TYPE i,
          l_time TYPE cva_time.

*Translate to upper case
    TRANSLATE inputobj-oprid TO UPPER CASE.

*Set local language for user
    l_langu = inputobj-language.

    SET LOCALE LANGUAGE l_langu.

*Create object of class - Calculate time in minutes
    CREATE OBJECT lref_sf_calc_min
      EXPORTING
        initial_refdt = sy-datum
        input_object  = inputobj.

*Get expiration date of workcenter
    SELECT SINGLE endda objid
      FROM crhd
      INTO (wrkctr_detail-endda, l_objid)
      WHERE arbpl EQ arbpl
        AND werks EQ werks.

*Get description of workcenter
    SELECT SINGLE ktext
      FROM crtx
      INTO wrkctr_detail-ktext
     WHERE objty EQ 'A'
       AND objid EQ l_objid
       AND spras EQ sy-langu.

    IF wrkctr_detail-ktext IS INITIAL.
      CLEAR l_langu.

*  Get alternative language
      SELECT SINGLE spras
        FROM zabsf_pp061
        INTO l_langu
       WHERE werks      EQ inputobj-werks
         AND is_default NE space.

      IF sy-subrc EQ 0.
*    Get description of workcenter with alternative language
        SELECT SINGLE ktext
          FROM crtx
          INTO wrkctr_detail-ktext
         WHERE objty EQ 'A'
           AND objid EQ l_objid
           AND spras EQ l_langu.
      ENDIF.
    ENDIF.

    wrkctr_detail-areadid = areaid.
    wrkctr_detail-werks = werks.
    wrkctr_detail-hname = hname.
    wrkctr_detail-arbpl = arbpl.

    IF wrkctr_detail IS NOT INITIAL.

*  Get all orders from Z table
      SELECT *
        FROM zabsf_pp021
        INTO TABLE @DATA(lt_zlp_pp_sf021)
       WHERE arbpl EQ @arbpl
        AND status_oper NE 'CONC'
        AND status_oper NE 'AGU'
        AND status_oper NE 'INI'.

      IF sy-subrc EQ 0.

        SORT lt_zlp_pp_sf021 BY aufnr ASCENDING.

        READ TABLE lt_zlp_pp_sf021 INTO ls_sf021 INDEX 1.
        wrkctr_detail-status = ls_sf021-status_oper. "status of procution order/operation.
        ls_prdord-aufnr = ls_sf021-aufnr.
        ls_prdord-vornr = ls_sf021-vornr.
        ls_prdord-arbpl = arbpl.
        ls_prdord-werks = werks.

* Get Start Hour of current status
*get from afru?
        SELECT MAX( rmzhl ) FROM zabsf_pp016 INTO lv_counter
          WHERE "areaid = areaid AND
              hname = hname
          AND werks = werks
          AND arbpl = arbpl
          AND aufnr = ls_sf021-aufnr
          AND vornr = ls_sf021-vornr.

        SELECT SINGLE * FROM zabsf_pp016 INTO @DATA(ls_sf016)
          WHERE "areaid = @areaid AND
              hname = @hname
          AND werks = @werks
          AND arbpl = @arbpl
          AND aufnr = @ls_sf021-aufnr
          AND vornr = @ls_sf021-vornr
          AND rmzhl = @lv_counter.

        CASE wrkctr_detail-status.

          WHEN c_proc.
            wrkctr_detail-status_hour = ls_sf016-isbz.
            wrkctr_detail-status_date = ls_sf016-isbd.

          WHEN c_prep.
            wrkctr_detail-status_hour = ls_sf016-isdz.
            wrkctr_detail-status_date = ls_sf016-isdd.

          WHEN c_stop.

            IF ls_sf016-ierd IS NOT INITIAL. "end of preparation
              wrkctr_detail-status_hour = ls_sf016-ierz.
              wrkctr_detail-status_date = ls_sf016-ierd.
            ELSE. "end of processment
              wrkctr_detail-status_hour = ls_sf016-iebz.
              wrkctr_detail-status_date = ls_sf016-iebd.

            ENDIF.

        ENDCASE.


*   Material
        SELECT SINGLE * FROM afko INTO @DATA(ls_afko)
          WHERE aufnr   = @ls_sf021-aufnr.

        IF ls_afko-plnbez IS NOT INITIAL.
          ls_prdord-matnr = ls_afko-plnbez.
        ELSE.
          ls_prdord-matnr = ls_afko-stlbez.
        ENDIF.

*    Material Description
        SELECT SINGLE maktx
          FROM makt
          INTO @ls_prdord-maktx
         WHERE matnr EQ @ls_prdord-matnr
           AND spras EQ @sy-langu.

*   Get operators
        CALL METHOD me->get_operators
          CHANGING
            prodord = ls_prdord.

        APPEND ls_prdord TO wrkctr_detail-prord_tab.

      ENDIF.
* compare status of workcenter with production order
      CALL METHOD me->compare_status
        IMPORTING
          dashboard_status    = wrkctr_detail-status_color
          stop_reason_desc    = wrkctr_detail-stop_reason_desc
        CHANGING
          i_workcenter_detail = wrkctr_detail.

* Calculate duration of current status.

      IF wrkctr_detail-status_date IS NOT INITIAL.

        t1 = wrkctr_detail-status_hour.

        CALL FUNCTION 'SCOV_TIME_DIFF'
          EXPORTING
            im_date1              = wrkctr_detail-status_date "start date
            im_date2              = sy-datlo "end date
            im_time1              = t1 "start time
            im_time2              = sy-timlo "end time
          IMPORTING
            ex_days               = l_days
            ex_time               = l_time
          EXCEPTIONS
            start_larger_than_end = 1
            OTHERS                = 2.


        lv_status_min = ( l_days * 1440 ) + ( l_time / 60 ).
        wrkctr_detail-status_hours_ago =  ( lv_status_min / 60 ).
*       wrkctr_detail-status_hours_ago = ( l_days * 1440 ) + ( l_time / 60 ).
*       wrkctr_detail-status_hours_ago = wrkctr_detail-status_hours_ago / 60 . "convert to hours.

        CLEAR lv_status_min.
      ENDIF.

*   Get total defects of chip
      IF wrkctr_detail-status = c_prep OR wrkctr_detail-status = c_proc.

        SELECT SINGLE * FROM zabsf_pp066 INTO @DATA(ls_sf066)
          WHERE werks = @ls_prdord-werks
          AND aufnr = @ls_prdord-aufnr
          AND vornr = @ls_prdord-vornr.

        IF sy-subrc EQ 0.

          SELECT * FROM zabsf_pp065 INTO TABLE @DATA(lt_ZABSF_PP065)
            WHERE ficha EQ @ls_sf066-ficha.

          IF lt_ZABSF_PP065 IS NOT INITIAL.

**Get all scrap
            SELECT * FROM afru
              INTO TABLE lt_afru
              FOR ALL ENTRIES IN lt_ZABSF_PP065
               WHERE rueck EQ lt_ZABSF_PP065-conf_no
                 AND rmzhl EQ lt_ZABSF_PP065-conf_cnt
                 AND stokz EQ space
                 AND stzhl EQ space.

            DELETE ADJACENT DUPLICATES FROM lt_afru COMPARING rueck rmzhl.
* Sum all scrap
            LOOP AT lt_afru INTO ls_afru.
              wrkctr_detail-prd_sheet_defects = wrkctr_detail-prd_sheet_defects + ls_afru-xmnga + ls_afru-rmnga.

              CLEAR ls_afru.
            ENDLOOP.

          ENDIF.
        ENDIF.
      ENDIF.

      CLEAR  ls_prdord.
    ELSE.
*  No workcenter detail found
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'E'
          msgno      = '006'
        CHANGING
          return_tab = return_tab.
    ENDIF.
  ENDMETHOD.


METHOD map_values.

    DATA: ls_prodord LIKE LINE OF workcenter_detail-prord_tab,
          ls_oprid   TYPE zabsf_pp_s_operador.

    READ TABLE workcenter_detail-prord_tab INTO ls_prodord INDEX 1.

    workcenter_dashboard-workcenter_id = workcenter_detail-arbpl.
    workcenter_dashboard-workcenter_description = workcenter_detail-ktext.
    workcenter_dashboard-material_id = ls_prodord-matnr.
    workcenter_dashboard-material_description = ls_prodord-maktx.
    workcenter_dashboard-aufnr = ls_prodord-aufnr.
    workcenter_dashboard-vornr = ls_prodord-vornr.
    workcenter_dashboard-current_status = workcenter_detail-status_color.
    workcenter_dashboard-start_hour = workcenter_detail-status_hour.
    workcenter_dashboard-start_date = workcenter_detail-status_date.
    workcenter_dashboard-status_hours_ago = workcenter_detail-status_hours_ago.
    workcenter_dashboard-hname = workcenter_detail-hname.
    workcenter_dashboard-prd_sheet_defects = workcenter_detail-prd_sheet_defects.
    workcenter_dashboard-stop_reason_desc = workcenter_detail-stop_reason_desc.

    APPEND LINES OF ls_prodord-oprid_tab TO workcenter_dashboard-logged_users.

    READ TABLE ls_prodord-oprid_tab INTO ls_oprid INDEX 1.
    workcenter_dashboard-first_user = ls_oprid-nome.



  ENDMETHOD.
ENDCLASS.
