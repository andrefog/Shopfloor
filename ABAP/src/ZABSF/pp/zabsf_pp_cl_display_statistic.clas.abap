class ZABSF_PP_CL_DISPLAY_STATISTIC definition
  public
  final
  create public .

public section.

  types:
    ty_r_hname TYPE RANGE OF cr_hname .
  types:
    ty_r_area  TYPE RANGE OF zabsf_pp_e_areaid .
  types:
    ty_r_shift TYPE RANGE OF zabsf_pp_e_shiftid .
  types:
    ty_r_arbpl TYPE RANGE OF arbpl .
  types TY_T_DATES type RSIS_T_RANGE .

  methods CONSTRUCTOR
    importing
      !INITIAL_REFDT type VVDATUM
      !INPUT_OBJECT type ZABSF_PP_S_INPUTOBJECT .
  methods SET_REFDT
    importing
      !NEW_REFDT type VVDATUM .
  methods DISPLAY_LCD
    importing
      !HNAME type CR_HNAME
      !SHIFTID type ZABSF_PP_E_SHIFTID
    changing
      !STAT_OEE_TAB type ZABSF_PP_T_STAT_OEE
      !RETURN_TAB type BAPIRET2_T .
  methods GET_FILTER
    changing
      !FILTER_TAB type ZABSF_PP_T_FILTER
      !RETURN_TAB type BAPIRET2_T .
  methods DISPLAY_REPORTS
    importing
      !HNAME type CR_HNAME optional
      !AREAID type ZABSF_PP_E_AREAID optional
      !SHIFTID type ZABSF_PP_E_SHIFTID optional
      !ARBPL type ARBPL optional
      !BEGDA type BEGDA optional
      !ENDDA type ENDDA optional
    changing
      !REPORTS_DETAIL_ST type ZABSF_PP_S_REPORTS_DETAIL
      !RETURN_TAB type BAPIRET2_T .
  methods GET_STOPS .
  methods GET_CAPACITY_TIME
    importing
      !R_HNAME type TY_R_HNAME optional
      !R_AREA type TY_R_AREA optional
      !R_SHIFT type TY_R_SHIFT optional
      !R_ARBPL type TY_R_ARBPL optional
      !R_DATES type TY_T_DATES optional
    exporting
      !CAPACITY type MENGV13 .
  methods AJUST_TIME_INTERVAL
    importing
      !IS_KAKO type KAKO
      !IS_SHIFT type ZABSF_PP001
    changing
      !E_SHIFT_WKTIME type MENGV13 .
protected section.
private section.

  data REFDT type VVDATUM .
  data INPUTOBJ type ZABSF_PP_S_INPUTOBJECT .
ENDCLASS.



CLASS ZABSF_PP_CL_DISPLAY_STATISTIC IMPLEMENTATION.


METHOD AJUST_TIME_INTERVAL.


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

    SELECT SINGLE parva INTO lv_parva FROM ZABSF_PP032
      WHERE werks = inputobj-werks
      AND parid = 'SHIFT_PAUSE'.

    MOVE lv_parva TO lv_pause.

    lv_wc_begzt  = is_kako-begzt.
    IF is_kako-endzt = c_sec_day.
      lv_wc_endzt = c_day.
    ELSE.
      lv_wc_endzt = is_kako-endzt.
    ENDIF.

* Adjust e_shift_wktime according to shift time and workcenter schedule.
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

ENDMETHOD.


METHOD CONSTRUCTOR.

*Ref. Date
  refdt    = initial_refdt.

*App input data
  inputobj = input_object.

ENDMETHOD.


METHOD display_lcd.
  DATA: lt_zabsf_pp051 TYPE TABLE OF zabsf_pp051,
        lt_arbpl_desc  TYPE TABLE OF ty_arbpl_desc,
        lt_oee_desc    TYPE TABLE OF zabsf_pp050_t.

  DATA: ls_zabsf_pp051 TYPE zabsf_pp051,
        ls_arbpl_desc  TYPE ty_arbpl_desc,
        ls_stat_oee    TYPE zabsf_pp_s_stat_oee,
        ls_oee_desc    TYPE zabsf_pp050_t,
        ls_data_oee    TYPE zabsf_pp_s_oee,
        ld_data        TYPE datum,
        ld_arbpl_ant   TYPE arbpl.

  DATA lref_sf_status TYPE REF TO zabsf_pp_cl_status.

*Get date more recently
  SELECT MAX( data )
    FROM zabsf_pp051
    INTO ld_data
   WHERE areaid  EQ inputobj-areaid
     AND hname   EQ hname
     AND werks   EQ inputobj-werks
     AND shiftid EQ shiftid.

*Get all information for indicators
  SELECT *
    FROM zabsf_pp051
    INTO CORRESPONDING FIELDS OF TABLE lt_zabsf_pp051
   WHERE areaid  EQ inputobj-areaid
     AND hname   EQ hname
     AND werks   EQ inputobj-werks
     AND shiftid EQ shiftid
     AND data    EQ ld_data.

  IF lt_zabsf_pp051[] IS NOT INITIAL.
*  Get description of workcenter
    SELECT crhd~objid crhd~arbpl crtx~ktext
      INTO CORRESPONDING FIELDS OF TABLE lt_arbpl_desc
      FROM crtx AS crtx
     INNER JOIN crhd AS crhd
        ON crhd~objty EQ crtx~objty
       AND crhd~objid EQ crtx~objid
       FOR ALL ENTRIES IN lt_zabsf_pp051
     WHERE crhd~arbpl EQ lt_zabsf_pp051-arbpl
       AND crhd~objty EQ 'A'
       AND crhd~werks EQ lt_zabsf_pp051-werks
       AND crtx~spras EQ sy-langu.

*  Get description for Indicators OEE
    SELECT *
      FROM zabsf_pp050_t
      INTO CORRESPONDING FIELDS OF TABLE lt_oee_desc
       FOR ALL ENTRIES IN lt_zabsf_pp051
     WHERE oeeid EQ lt_zabsf_pp051-oeeid
       AND spras EQ sy-langu.

*  Create object of class status
    CREATE OBJECT lref_sf_status
      EXPORTING
        initial_refdt = refdt
        input_object  = inputobj.

    CLEAR ld_arbpl_ant.

    LOOP AT lt_zabsf_pp051 INTO ls_zabsf_pp051.
      CLEAR ls_data_oee.

      IF ld_arbpl_ant NE ls_zabsf_pp051-arbpl.
*      Workcenter
        ls_stat_oee-arbpl = ls_zabsf_pp051-arbpl.
*      Read description for Workcenter
        READ TABLE lt_arbpl_desc INTO ls_arbpl_desc WITH KEY arbpl = ls_zabsf_pp051-arbpl.

        IF sy-subrc EQ 0.
*        Workcenter description
          ls_stat_oee-ktext = ls_arbpl_desc-ktext.
        ENDIF.

*      Get current status of Workcenter
        CALL METHOD lref_sf_status->status_object
          EXPORTING
            arbpl       = ls_zabsf_pp051-arbpl
            werks       = ls_zabsf_pp051-werks
            objty       = 'CA'
            method      = 'G'
          CHANGING
            status_out  = ls_stat_oee-status
            status_desc = ls_stat_oee-status_desc
            return_tab  = return_tab.

*      Indicator OEE
        ls_data_oee-oeeid = ls_zabsf_pp051-oeeid.

*      Read description for Indicator OEE
        READ TABLE lt_oee_desc INTO ls_oee_desc WITH KEY oeeid = ls_zabsf_pp051-oeeid.

        IF sy-subrc EQ 0.
*        Indicator OEE description
          ls_data_oee-oeeid_desc = ls_oee_desc-oeeid_desc.
        ENDIF.

*      Value of Indicator OEE
        ls_data_oee-qtdoee = ls_zabsf_pp051-qtdoee.

*      Add information for Indicator OEE
        APPEND ls_data_oee TO ls_stat_oee-oee_tab.

        APPEND ls_stat_oee TO stat_oee_tab.

*      Last workcenter
        ld_arbpl_ant = ls_zabsf_pp051-arbpl.
      ELSE.

        CLEAR ls_data_oee.

        READ TABLE stat_oee_tab INTO ls_stat_oee WITH KEY arbpl = ls_zabsf_pp051-arbpl.

        IF sy-subrc EQ 0.
*        Indicator OEE
          ls_data_oee-oeeid = ls_zabsf_pp051-oeeid.

*        Read description for Indicator OEE
          READ TABLE lt_oee_desc INTO ls_oee_desc WITH KEY oeeid = ls_zabsf_pp051-oeeid.

          IF sy-subrc EQ 0.
*          Indicator OEE description
            ls_data_oee-oeeid_desc = ls_oee_desc-oeeid_desc.
          ENDIF.

*        Value of Indicator OEE
          ls_data_oee-qtdoee = ls_zabsf_pp051-qtdoee.

*        Add information for Indicator OEE
          APPEND ls_data_oee TO ls_stat_oee-oee_tab.

          MODIFY TABLE stat_oee_tab FROM ls_stat_oee.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ELSE.
*  No data found for inputs
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'I'
        msgno      = '018'
      CHANGING
        return_tab = return_tab.
  ENDIF.
ENDMETHOD.


METHOD display_reports.
  DATA: lt_zabsf_pp053 TYPE TABLE OF zabsf_pp053,
        lt_stprsn_desc TYPE TABLE OF zabsf_pp011_t.

  DATA: ls_zabsf_pp053 TYPE zabsf_pp053,
        ls_stprsn_desc TYPE zabsf_pp011_t,
        ls_time        TYPE zabsf_pp_s_time_stopreason.

  DATA: r_hname           TYPE RANGE OF cr_hname,
        r_area            TYPE RANGE OF zabsf_pp_e_areaid,
        r_shift           TYPE RANGE OF zabsf_pp_e_shiftid,
        r_arbpl           TYPE RANGE OF arbpl,
        lr_dates          TYPE rsis_t_range,
        ls_dates          TYPE rsis_s_range,
        lv_stop_initial   TYPE zabsf_pp_e_stoptime,
        lv_percentage_cmp TYPE f,
        lv_capacity       TYPE mengv13.

  DATA: wa_hname LIKE LINE OF r_hname,
        wa_area  LIKE LINE OF r_area,
        wa_shift LIKE LINE OF r_shift,
        wa_arbpl LIKE LINE OF r_arbpl.

*Hierarchy
  IF hname IS NOT INITIAL.
    wa_hname-option = 'EQ'.
    wa_hname-sign = 'I'.
    wa_hname-low = hname.
    APPEND wa_hname TO r_hname.
  ENDIF.

*Area
  IF areaid IS NOT INITIAL.
    wa_area-option = 'EQ'.
    wa_area-sign = 'I'.
    wa_area-low = areaid.
    APPEND wa_area TO r_area.
  ENDIF.

*Shift
  IF shiftid IS NOT INITIAL.
    wa_shift-option = 'EQ'.
    wa_shift-sign = 'I'.
    wa_shift-low = shiftid.
    APPEND wa_shift TO r_shift.
  ENDIF.

*Workcenter
  IF arbpl IS NOT INITIAL.
    wa_arbpl-option = 'EQ'.
    wa_arbpl-sign = 'I'.
    wa_arbpl-low = arbpl.
    APPEND wa_arbpl TO r_arbpl.
  ENDIF.

*Dates
  IF begda IS NOT INITIAL AND endda IS NOT INITIAL.

    ls_dates-sign = 'I'.
    ls_dates-option = 'BT'.
    ls_dates-low = begda.
    ls_dates-high = endda.
    APPEND ls_dates TO lr_dates.
  ELSE.

    ls_dates-sign = 'I'.
    ls_dates-option = 'EQ'.
    ls_dates-low = begda.
    APPEND ls_dates TO lr_dates.
  ENDIF.


* GET stop reason descriptions.
  SELECT * FROM zabsf_pp011_t
    INTO CORRESPONDING FIELDS OF TABLE lt_stprsn_desc
    WHERE werks = inputobj-werks
    AND spras = sy-langu.

  IF sy-subrc NE 0.

    SELECT SINGLE spras
       FROM zabsf_pp061
       INTO (@DATA(l_alt_spras))
       WHERE werks      EQ @inputobj-werks
       AND is_default EQ @abap_true.

* GET stop reason descriptions.
    IF l_alt_spras IS NOT INITIAL.
      SELECT * FROM zabsf_pp011_t
        INTO CORRESPONDING FIELDS OF TABLE lt_stprsn_desc
        WHERE werks = inputobj-werks
        AND spras = l_alt_spras.

    ENDIF.
  ENDIF.



*Get quantity
  SELECT SUM( gamng ) SUM( lmnga ) SUM( xmnga ) SUM( rmnga ) SUM( qtdprod )
    FROM zabsf_pp056
    INTO (reports_detail_st-gamng,reports_detail_st-lmnga,reports_detail_st-xmnga,
          reports_detail_st-rmnga,reports_detail_st-qtdprod)
    WHERE areaid  IN r_area
      AND hname   IN r_hname
      AND werks   EQ inputobj-werks
      AND arbpl   IN r_arbpl
      AND shiftid IN r_shift
      AND data    IN lr_dates.

*   SELECT SUM( gamng ) SUM( lmnga ) SUM( xmnga ) SUM( rmnga ) SUM( qtdprod ) SUM( pctprod )
*    FROM ZABSF_PP056
*    INTO (reports_detail_st-gamng,reports_detail_st-lmnga,reports_detail_st-xmnga,
*          reports_detail_st-rmnga,reports_detail_st-qtdprod,reports_detail_st-pctprod)
*    WHERE areaid  IN r_area
*      AND hname   IN r_hname
*      AND werks   EQ inputobj-werks
*      AND arbpl   IN r_arbpl
*      AND shiftid IN r_shift
*      AND data    EQ refdt.

  IF sy-subrc NE 0.
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'I'
        msgno      = '054'
      CHANGING
        return_tab = return_tab.
  ENDIF.

*  IF reports_detail_st-gamng NE 0.
*    reports_detail_st-pctprod = ( reports_detail_st-lmnga / reports_detail_st-gamng ) * 100.
*  ENDIF.

*Get time total of production
  SELECT SUM( prodtime )
    FROM zabsf_pp055
    INTO reports_detail_st-t_prodtime
    WHERE areaid  IN r_area
      AND hname   IN r_hname
      AND werks   EQ inputobj-werks
      AND arbpl   IN r_arbpl
      AND shiftid IN r_shift
      AND data    IN lr_dates.

  IF sy-subrc NE 0.
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'I'
        msgno      = '056'
      CHANGING
        return_tab = return_tab.
  ENDIF.

*Get time total of stops
  SELECT SUM( stoptime )
    FROM zabsf_pp053
    INTO reports_detail_st-t_stoptime
    WHERE areaid  IN r_area
      AND hname   IN r_hname
      AND werks   EQ inputobj-werks
      AND arbpl   IN r_arbpl
      AND shiftid IN r_shift
      AND data    IN lr_dates.

  IF sy-subrc NE 0.
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'I'
        msgno      = '055'
      CHANGING
        return_tab = return_tab.
  ENDIF.

*Get time for stop reaon
  SELECT *
    FROM zabsf_pp053
    INTO CORRESPONDING FIELDS OF TABLE lt_zabsf_pp053
    WHERE areaid  IN r_area
      AND hname   IN r_hname
      AND werks   EQ inputobj-werks
      AND arbpl   IN r_arbpl
      AND shiftid IN r_shift
      AND data    IN lr_dates
      AND stoptime NE lv_stop_initial. "exclude zeros


  LOOP AT lt_zabsf_pp053 INTO ls_zabsf_pp053.
    READ TABLE reports_detail_st-time_tab INTO ls_time WITH KEY stprsnid = ls_zabsf_pp053-stprsnid.

    IF sy-subrc EQ 0.
*    Update value of stop time
      ADD ls_zabsf_pp053-stoptime TO ls_time-stoptime.

      MODIFY TABLE reports_detail_st-time_tab FROM ls_time.
    ELSE.
*    Stop reason ID
      ls_time-stprsnid = ls_zabsf_pp053-stprsnid.

*    Stop reason description
*      IF ls_ZABSF_PP053-stprsn_desc IS NOT INITIAL.
*        ls_time-stprsn_desc = ls_ZABSF_PP053-stprsn_desc.
*      ELSE.
*        CLEAR ls_stprsn_desc.

*      Read reason description
      READ TABLE lt_stprsn_desc INTO ls_stprsn_desc WITH KEY stprsnid = ls_zabsf_pp053-stprsnid.

      IF sy-subrc EQ 0.
        ls_time-stprsn_desc = ls_stprsn_desc-stprsn_desc.
      ENDIF.
*    Stop time
      ls_time-stoptime = ls_zabsf_pp053-stoptime.
*    Stop time unit
      ls_time-stopunit = ls_zabsf_pp053-stopunit.

      INSERT ls_time INTO TABLE reports_detail_st-time_tab.
    ENDIF.

  ENDLOOP.


* Scheduled quantity
  SELECT SUM( qtt_schedule )
    FROM zabsf_pp073
    INTO reports_detail_st-gamng
    WHERE areaid  IN r_area
      AND hname   IN r_hname
      AND werks   EQ inputobj-werks
      AND arbpl   IN r_arbpl
      AND shiftid IN r_shift
      AND data    IN lr_dates.

* Percentage Completed
  IF reports_detail_st-gamng IS NOT INITIAL.
    lv_percentage_cmp = reports_detail_st-lmnga / reports_detail_st-gamng.
    reports_detail_st-pctprod = lv_percentage_cmp * 100.
  ENDIF.

* Total Productive Time
*  CALL METHOD me->get_capacity_time
*    EXPORTING
*      r_hname  = r_hname
*      r_area   = r_area
*      r_shift  = r_shift
*      r_arbpl  = r_arbpl
*      r_dates  = lr_dates
*    IMPORTING
*      capacity = lv_capacity.

*Total Productive Time
  SELECT SUM( prodtime )
    FROM zabsf_pp074
    INTO lv_capacity
    WHERE areaid  IN r_area
      AND hname   IN r_hname
      AND werks   EQ inputobj-werks
      AND arbpl   IN r_arbpl
      AND shiftid IN r_shift
      AND data    IN lr_dates.


*  IF lv_capacity IS NOT INITIAL.
*    reports_detail_st-rmnga = lv_capacity - reports_detail_st-t_stoptime.
*  ENDIF.

  reports_detail_st-rmnga = lv_capacity.



  IF reports_detail_st-time_tab[] IS NOT INITIAL.
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'I'
        msgno      = '018'
      CHANGING
        return_tab = return_tab.
  ENDIF.
ENDMETHOD.


METHOD get_capacity_time.


    TYPES: BEGIN OF ty_arbpl,
             arbpl TYPE arbpl,
             objid TYPE cr_objid,
             kapid TYPE kapid,
           END OF ty_arbpl.

    CONSTANTS: c_sec_day TYPE kapbegzt VALUE '86400',
               c_day     TYPE t VALUE '240000'.

    DATA: ld_worktime TYPE mengv13,
          ld_capacity TYPE kapazitaet,
          ld_einzt    TYPE kapeinzt.

    DATA: lv_wc_begzt     TYPE kapbegzeit,
*          lv_shift_beg    TYPE kapbegzeit,
*          lv_shift_end    TYPE kapendzeit,
*          lv_wc_endzt     TYPE kapendzeit,
          lv_shift_wktime TYPE mengv13.

    DATA: "lv_date_past   TYPE begda,
      "lv_date_future TYPE endda,
      lr_dates   TYPE rsis_s_range,
      lt_qtd_aux TYPE TABLE OF zabsf_pp056,
      lt_days    TYPE TABLE OF casdayattr,
      ls_days    LIKE LINE OF lt_days,
      ls_dates   LIKE LINE OF r_dates,
      ls_arbpl   LIKE LINE OF r_arbpl,
      lt_crhd    TYPE TABLE OF crhd,
      ls_crhd    LIKE LINE OF lt_crhd,
      ls_kako    TYPE kako,
      ls_hname   LIKE LINE OF r_hname,
      ls_area    LIKE LINE OF r_area,
      lt_aux     TYPE TABLE OF ty_arbpl,
      ls_aux     LIKE LINE OF lt_aux,
      ls_shift   LIKE LINE OF r_shift.

    DATA: lt_sf013 TYPE TABLE OF zabsf_pp013,
          lt_sf002 TYPE TABLE OF zabsf_pp002,
          ls_sf002 LIKE LINE OF lt_sf002,
          lt_sf001 TYPE TABLE OF zabsf_pp001,
          ls_sf001 TYPE zabsf_pp001.

    DATA: lv_date_low  TYPE begda,
          lv_date_high TYPE endda.

    READ TABLE r_shift INTO ls_shift INDEX 1.

    READ TABLE r_dates INTO ls_dates INDEX 1.
    CHECK sy-subrc EQ 0.

    READ TABLE r_area INTO ls_area INDEX 1.
    CHECK sy-subrc EQ 0.

    lv_date_low = ls_dates-low.
    lv_date_high = ls_dates-high.
    IF lv_date_high IS INITIAL.
      lv_date_high = lv_date_low.
    ENDIF.

    CALL FUNCTION 'DAY_ATTRIBUTES_GET'
      EXPORTING
        date_from                  = lv_date_low
        date_to                    = lv_date_high
      TABLES
        day_attributes             = lt_days
      EXCEPTIONS
        factory_calendar_not_found = 1
        holiday_calendar_not_found = 2
        date_has_invalid_format    = 3
        date_inconsistency         = 4
        OTHERS                     = 5.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

* For workcenters
    IF r_arbpl IS NOT INITIAL.
*get workcenters objid
      SELECT * FROM crhd
        INTO TABLE lt_crhd
        WHERE arbpl IN r_arbpl
        AND werks EQ inputobj-werks
        AND objty EQ 'A'.

      READ TABLE r_arbpl INDEX 1 INTO ls_arbpl.

      READ TABLE lt_crhd INTO ls_crhd WITH KEY werks = inputobj-werks
                                               arbpl = ls_arbpl-low.
*Get capacity detail
      SELECT SINGLE *
        FROM kako
        INTO CORRESPONDING FIELDS OF ls_kako
       WHERE kapid EQ ls_crhd-kapid
        AND kapar EQ '001'.

      LOOP AT lt_days INTO ls_days.

        SELECT * FROM zabsf_pp013 INTO TABLE lt_sf013
          WHERE werks = inputobj-werks
          AND arbpl EQ ls_arbpl-low
          AND begda LE ls_days-date
          AND endda GE ls_days-date.
        IF sy-subrc EQ 0.

          SELECT SINGLE * FROM zabsf_pp001 INTO ls_sf001
            WHERE areaid EQ ls_area-low
            AND werks EQ inputobj-werks
            AND shiftid EQ ls_shift-low
            AND begda  LE ls_days-date
            AND endda  GE ls_days-date.

* one workcenter
          CALL METHOD me->ajust_time_interval
            EXPORTING
              is_kako        = ls_kako
              is_shift       = ls_sf001
            CHANGING
              e_shift_wktime = lv_shift_wktime.

          capacity = capacity + lv_shift_wktime.
        ENDIF.

        CLEAR ls_days.
      ENDLOOP.
    ELSE.

      IF r_area IS NOT INITIAL AND r_shift IS NOT INITIAL AND r_hname IS NOT INITIAL.
* get workcenters for hierarchy.

        READ TABLE r_hname INTO ls_hname INDEX 1.

        DATA: ls_hrchy_objid TYPE cr_objid,
              lt_crhs        TYPE TABLE OF crhs.

* Get Hierarchy Object ID
        CALL FUNCTION 'CR_HIERARCHY_READ_NAME'
          EXPORTING
            name                = ls_hname-low
            werks               = inputobj-werks
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

          IF lt_crhs IS NOT INITIAL.

            SELECT objid arbpl kapid
              INTO CORRESPONDING FIELDS OF TABLE lt_aux
              FROM crhd
              FOR ALL ENTRIES IN lt_crhs
            WHERE objty EQ lt_crhs-objty_ho
              AND objid EQ lt_crhs-objid_ho.

          ENDIF.
        ENDIF.

        LOOP AT lt_days INTO ls_days.

          SELECT SINGLE * FROM zabsf_pp001 INTO ls_sf001
            WHERE areaid EQ ls_area-low
            AND werks EQ inputobj-werks
            AND shiftid EQ ls_shift-low
            AND begda  LE ls_days-date
            AND endda  GE ls_days-date.

          CHECK sy-subrc EQ 0.

          SELECT DISTINCT werks areaid hname
            FROM zabsf_pp002
            INTO CORRESPONDING FIELDS OF TABLE lt_sf002
           WHERE areaid EQ ls_area-low
             AND werks EQ inputobj-werks
             AND hname EQ ls_hname-low
             AND begda  LE ls_days-date
             AND endda  GE ls_days-date.

          IF sy-subrc EQ 0.

            SELECT * FROM zabsf_pp013 INTO TABLE lt_sf013
                WHERE werks EQ inputobj-werks
                AND areaid EQ ls_area-low
                AND begda  LE ls_days-date
                AND endda  GE ls_days-date.

            LOOP AT lt_aux INTO ls_aux.

              READ TABLE lt_sf013 TRANSPORTING NO FIELDS WITH KEY werks = inputobj-werks
                                                                  arbpl = ls_aux-arbpl.
              IF sy-subrc EQ 0.
                SELECT SINGLE * FROM kako
                   INTO CORRESPONDING FIELDS OF ls_kako
                   WHERE kapid EQ ls_aux-kapid
                   AND kapar EQ '001'.

                IF sy-subrc EQ 0.
                  CALL METHOD me->ajust_time_interval
                    EXPORTING
                      is_kako        = ls_kako
                      is_shift       = ls_sf001
                    CHANGING
                      e_shift_wktime = lv_shift_wktime.

                  capacity = capacity +  lv_shift_wktime.
                ENDIF.
              ENDIF.
              CLEAR: ls_kako, ld_capacity, lv_shift_wktime, ld_einzt, ls_aux.
            ENDLOOP.
          ENDIF.

          CLEAR: ls_days, ls_hrchy_objid, ls_sf001.
          REFRESH: lt_sf013, lt_crhs, lt_sf002, lt_aux.
        ENDLOOP.
      ENDIF.

      IF r_area IS NOT INITIAL AND r_shift IS NOT INITIAL AND r_hname IS INITIAL.

        LOOP AT lt_days INTO ls_days.

          SELECT SINGLE * FROM zabsf_pp001 INTO ls_sf001
            WHERE areaid EQ ls_area-low
            AND werks EQ inputobj-werks
            AND shiftid EQ ls_shift-low
            AND begda  LE ls_days-date
            AND endda  GE ls_days-date.

          CHECK sy-subrc EQ 0.

*  Get all hierarchies for area
          SELECT DISTINCT werks areaid hname
            FROM zabsf_pp002
            INTO CORRESPONDING FIELDS OF TABLE lt_sf002
           WHERE areaid EQ ls_area-low
             AND werks EQ inputobj-werks
             AND begda  LE ls_days-date
             AND endda  GE ls_days-date.

          LOOP AT lt_sf002 INTO ls_sf002. ">>hierachies table

            CALL FUNCTION 'CR_HIERARCHY_READ_NAME'
              EXPORTING
                name                = ls_sf002-hname
                werks               = inputobj-werks
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

              IF lt_crhs IS NOT INITIAL.

                SELECT objid arbpl kapid
                  INTO CORRESPONDING FIELDS OF TABLE lt_aux
                  FROM crhd
                  FOR ALL ENTRIES IN lt_crhs
                WHERE objty EQ lt_crhs-objty_ho
                  AND objid EQ lt_crhs-objid_ho.

                SELECT * FROM zabsf_pp013 INTO TABLE lt_sf013
                  WHERE werks EQ inputobj-werks
                  AND areaid EQ ls_area-low
                  AND begda  LE ls_days-date
                  AND endda  GE ls_days-date.

                LOOP AT lt_aux INTO ls_aux.
                  READ TABLE lt_sf013 TRANSPORTING NO FIELDS WITH KEY werks = inputobj-werks
                                                                      arbpl = ls_aux-arbpl.
                  IF sy-subrc EQ 0.
                    SELECT SINGLE * FROM kako
                       INTO CORRESPONDING FIELDS OF ls_kako
                       WHERE kapid EQ ls_aux-kapid
                       AND kapar EQ '001'.

                    IF sy-subrc EQ 0.
                      CALL METHOD me->ajust_time_interval
                        EXPORTING
                          is_kako        = ls_kako
                          is_shift       = ls_sf001
                        CHANGING
                          e_shift_wktime = lv_shift_wktime.

                      capacity = capacity +  lv_shift_wktime.
                    ENDIF.
                  ENDIF.
                  CLEAR: ls_kako, ld_capacity, lv_shift_wktime, ld_einzt, ls_aux.
                ENDLOOP.
              ENDIF.
            ENDIF.

            REFRESH: lt_aux, lt_crhs, lt_sf013.
            CLEAR: ls_sf002, ls_hrchy_objid.
          ENDLOOP.

          REFRESH: lt_sf002.
          CLEAR: ls_days, ls_sf001.
        ENDLOOP.
      ENDIF.

* calculate for entire AREA
      IF r_area IS NOT INITIAL AND r_shift IS INITIAL.

        LOOP AT lt_days INTO ls_days.
*  Get shifts of Area
          SELECT *
            FROM zabsf_pp001
            INTO CORRESPONDING FIELDS OF TABLE lt_sf001
           WHERE areaid EQ ls_area-low
             AND werks EQ inputobj-werks
             AND begda  LE ls_days-date
             AND endda  GE ls_days-date.

          LOOP AT lt_sf001 INTO ls_sf001.
*  Get all hierarchies for area
            SELECT DISTINCT werks areaid hname
              FROM zabsf_pp002
              INTO CORRESPONDING FIELDS OF TABLE lt_sf002
             WHERE areaid EQ ls_area-low
               AND werks EQ inputobj-werks
               AND begda  LE ls_days-date
               AND endda  GE ls_days-date.

            LOOP AT lt_sf002 INTO ls_sf002. ">>hierachies table

              CALL FUNCTION 'CR_HIERARCHY_READ_NAME'
                EXPORTING
                  name                = ls_sf002-hname
                  werks               = inputobj-werks
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

                IF lt_crhs IS NOT INITIAL.

                  SELECT objid arbpl kapid
                    INTO CORRESPONDING FIELDS OF TABLE lt_aux
                    FROM crhd
                    FOR ALL ENTRIES IN lt_crhs
                  WHERE objty EQ lt_crhs-objty_ho
                    AND objid EQ lt_crhs-objid_ho.

                  SELECT * FROM zabsf_pp013 INTO TABLE lt_sf013
                    WHERE werks EQ inputobj-werks
                    AND areaid EQ ls_area-low
                    AND begda  LE ls_days-date
                    AND endda  GE ls_days-date.

                  LOOP AT lt_aux INTO ls_aux.
                    READ TABLE lt_sf013 TRANSPORTING NO FIELDS WITH KEY werks = inputobj-werks
                                                                        arbpl = ls_aux-arbpl.
                    IF sy-subrc EQ 0.
                      SELECT SINGLE * FROM kako
                         INTO CORRESPONDING FIELDS OF ls_kako
                         WHERE kapid EQ ls_aux-kapid
                         AND kapar EQ '001'.

                      IF sy-subrc EQ 0.
                        CALL METHOD me->ajust_time_interval
                          EXPORTING
                            is_kako        = ls_kako
                            is_shift       = ls_sf001
                          CHANGING
                            e_shift_wktime = lv_shift_wktime.

                        capacity = capacity +  lv_shift_wktime.

                      ENDIF.
                    ENDIF.
                    CLEAR: ls_kako, ld_capacity, lv_shift_wktime, ls_aux.
                  ENDLOOP.

                ENDIF.
              ENDIF.

              REFRESH: lt_aux, lt_crhs, lt_sf013.
              CLEAR: ls_sf002, ls_hrchy_objid.
            ENDLOOP.

            CLEAR: ls_sf001.
            REFRESH: lt_sf002.
          ENDLOOP.
          REFRESH:  lt_sf001.
          CLEAR: ls_days, ls_sf001.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDMETHOD.


METHOD get_filter.
  DATA: lt_area   TYPE TABLE OF zabsf_pp_s_areaid,
        lt_shift  TYPE TABLE OF zabsf_pp_s_shift,
        lt_hrchy  TYPE TABLE OF zabsf_pp_s_hrchy,
*        lt_workcenter TYPE TABLE OF ZABSF_PP_s_workcenters,
        lt_wrkctr TYPE TABLE OF zabsf_pp_s_wrkctr.

  DATA: wa_filter     TYPE zabsf_pp_s_filter,
        wa_area       TYPE zabsf_pp_s_areaid,
        wa_shift      TYPE zabsf_pp_s_shift,
        wa_shift_aux  TYPE zabsf_pp_s_shift,
        wa_hrchy      TYPE zabsf_pp_s_hrchy,
        wa_hrchy_aux  TYPE zabsf_pp_s_hrchy,
        wa_wrkctr     TYPE zabsf_pp_s_wrkctr,
        wa_wrkctr_aux TYPE zabsf_pp_s_workcenters.

  DATA: lv_alt_langu TYPE sy-langu,
        lv_langu     TYPE sy-langu.

  DATA lref_sf_wrkctr TYPE REF TO zabsf_pp_cl_wrkctr.

*Create object
  CREATE OBJECT lref_sf_wrkctr
    EXPORTING
      initial_refdt = refdt
      input_object  = inputobj.

*Set local language for user
  lv_langu = sy-langu.

  SET LOCALE LANGUAGE lv_langu.

*>>BMR Comment 05.12.2016 - get Areas from ZABSF_PP008 instead.
*Get areas
*  SELECT sf000t~areaid sf000t~area_desc
*    INTO CORRESPONDING FIELDS OF TABLE lt_area
*    FROM ZABSF_PP000 AS sf000
*   INNER JOIN ZABSF_PP000_t AS sf000t
*      ON sf000t~areaid EQ sf000~areaid
*   WHERE sf000t~spras  EQ sy-langu.

*<<BMR End comment.

*>BMR 05.12.2016 - exclude areas that has type AT04.
  SELECT a~areaid b~area_desc INTO TABLE lt_area
    FROM zabsf_pp008 AS a
    INNER JOIN zabsf_pp008_t AS b
    ON a~areaid EQ b~areaid
    WHERE a~werks EQ inputobj-werks
    AND a~tarea_id NE 'AT04'
    AND b~spras = sy-langu.

  IF sy-subrc NE 0.
*  Get alternative language
    SELECT SINGLE spras
      FROM zabsf_pp061
      INTO lv_alt_langu
     WHERE werks      EQ inputobj-werks
       AND is_default NE space.

    IF sy-subrc EQ 0.
      SELECT a~areaid b~area_desc INTO TABLE lt_area
         FROM zabsf_pp008 AS a
         INNER JOIN zabsf_pp008_t AS b
         ON a~areaid EQ b~areaid
         WHERE a~werks EQ inputobj-werks
         AND a~tarea_id NE 'AT04'
         AND b~spras = lv_alt_langu.

    ENDIF.
  ENDIF.

*Get shifts
  SELECT sft001~areaid sft001~shiftid sft001t~shift_desc
    INTO CORRESPONDING FIELDS OF TABLE lt_shift
    FROM zabsf_pp001 AS sft001 INNER JOIN zabsf_pp001_t AS sft001t
      ON sft001t~areaid  EQ  sft001~areaid
     AND sft001t~werks   EQ  sft001~werks
     AND sft001t~shiftid EQ  sft001~shiftid
    FOR ALL ENTRIES IN lt_area
   WHERE sft001~areaid EQ lt_area-areaid "Areaid
     AND sft001~werks  EQ inputobj-werks  "Werks
     AND sft001~begda  LE refdt
     AND sft001~endda  GE refdt
     AND sft001t~spras EQ sy-langu.

  IF sy-subrc NE 0.
*  No shifts for the inputs
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'E'
        msgno      = '001'
      CHANGING
        return_tab = return_tab.
  ENDIF.

*Get hierarchy
  SELECT sft002~areaid sft002~shiftid sft002~werks crhh~name AS hname crtx~ktext
    INTO CORRESPONDING FIELDS OF TABLE lt_hrchy
    FROM zabsf_pp002 AS sft002
   INNER JOIN crhh AS crhh
      ON  crhh~name EQ sft002~hname
   INNER JOIN crtx AS crtx
      ON crtx~objty EQ crhh~objty
     AND crtx~objid EQ crhh~objid
    FOR ALL ENTRIES IN lt_area
   WHERE sft002~areaid EQ lt_area-areaid
     AND sft002~werks  EQ inputobj-werks
     AND sft002~begda  LE refdt
     AND sft002~endda  GE refdt
     AND crhh~objty    EQ 'H'
     AND crtx~spras    EQ sy-langu.

  IF sy-subrc <> 0.
*  No active shifts found
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'E'
        msgno      = '005'
      CHANGING
        return_tab = return_tab.
  ENDIF.

  LOOP AT lt_area INTO wa_area.
    CLEAR wa_filter.

*  Area ID
    wa_filter-areaid = wa_area-areaid.
*  Area description
    wa_filter-area_desc = wa_area-area_desc.
*  Plant
    wa_filter-werks = inputobj-werks.

    CLEAR wa_shift.

*  Shifts
    LOOP AT lt_shift INTO wa_shift WHERE areaid EQ wa_area-areaid.
*    Area ID
      wa_shift_aux-areaid = wa_shift-areaid.
*    Shift ID
      wa_shift_aux-shiftid = wa_shift-shiftid.
*    Shift description
      wa_shift_aux-shift_desc = wa_shift-shift_desc.

      APPEND wa_shift_aux TO wa_filter-shift_tab.
    ENDLOOP.

    CLEAR wa_hrchy.

    LOOP AT lt_hrchy INTO wa_hrchy WHERE areaid EQ wa_area-areaid.
*    Hierarchy
      MOVE-CORRESPONDING wa_hrchy TO wa_hrchy_aux.

      APPEND wa_hrchy_aux TO wa_filter-hname_tab.

*    Get workcenters
      CALL METHOD lref_sf_wrkctr->get_workcenters
        EXPORTING
          hname      = wa_hrchy-hname
          werks      = inputobj-werks
        CHANGING
          wrkctr_tab = lt_wrkctr
          return_tab = return_tab.

      IF lt_wrkctr[] IS NOT INITIAL.
*      Area ID
        wa_wrkctr_aux-areaid = wa_hrchy-areaid.
*      Plant
        wa_wrkctr_aux-werks = wa_hrchy-werks.
*      Hierarchy name
        wa_wrkctr_aux-hname = wa_hrchy-hname.

        CLEAR wa_wrkctr.

        LOOP AT lt_wrkctr INTO wa_wrkctr.
*        Workcenter ID
          wa_wrkctr_aux-arbpl = wa_wrkctr-arbpl.
*        Workcenter description
*          wa_wrkctr_aux-ktext = wa_wrkctr-ktext.
          CONCATENATE wa_wrkctr-arbpl '-' wa_wrkctr-ktext INTO wa_wrkctr_aux-ktext.

          APPEND wa_wrkctr_aux TO wa_filter-arbpl_tab.
        ENDLOOP.

*>> BMR 17.11.2016 - estava a acumular entradas
        REFRESH lt_wrkctr.
*<</BMR

*>>> PAP - Correcções - 03.06.2015
        SORT wa_filter-arbpl_tab BY hname ASCENDING arbpl ASCENDING.
*<<< PAP - Correcções - 03.06.2015
      ENDIF.
    ENDLOOP.

    APPEND wa_filter TO filter_tab.
  ENDLOOP.
ENDMETHOD.


method GET_STOPS.
  endmethod.


METHOD SET_REFDT.

*Set new reference date
  refdt = new_refdt.

  ENDMETHOD.
ENDCLASS.
