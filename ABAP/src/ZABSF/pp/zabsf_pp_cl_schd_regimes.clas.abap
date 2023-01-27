class ZABSF_PP_CL_SCHD_REGIMES definition
  public
  final
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !INITIAL_REFDT type VVDATUM
      !INPUT_OBJECT type ZABSF_PP_S_INPUTOBJECT .
  methods GET_SCHEDULES
    exporting
      !SCHEDULES type ZABSF_PP_T_SCHED_REGIME .
  methods GET_REGIMES
    importing
      value(SCHEDULE_ID) type ZABSF_PP_E_SCHEDULE_ID
    exporting
      value(REGIMES) type ZABSF_PP_T_REGIMES .
  methods SAVE_SCHEDULES_AND_REGIMES
    importing
      value(IS_CONFIRMATION) type ZABSF_PP065
    exporting
      value(E_ERROR) type BOOLE_D
    changing
      value(RETURN_TAB) type BAPIRET2_T optional .
  methods GET_INFO_FOR_PRODORDER
    importing
      value(CONFIRMATION) type CO_RUECK
    exporting
      value(SCHEDULE_ID) type ZABSF_PP_E_SCHEDULE_ID
      value(SCHEDULE_DESC) type ZABSF_PP_E_SCHEDULE_DESC
      value(REGIME_ID) type ZABSF_PP_E_REGIME_ID
      value(REGIME_DESC) type ZABSF_PP_E_REGIME_DESC
      value(COUNT_INI) type ZABSF_PP_E_COUNT_INI .
protected section.
private section.

  data REFDT type VVDATUM .
  data INPUTOBJ type ZABSF_PP_S_INPUTOBJECT .
ENDCLASS.



CLASS ZABSF_PP_CL_SCHD_REGIMES IMPLEMENTATION.


  method CONSTRUCTOR.

*Ref. Date
  refdt    = initial_refdt.

*App input data
  inputobj = input_object.


  endmethod.


  METHOD get_info_for_prodorder.
*  Get default language
    SELECT SINGLE spras
      FROM zabsf_pp061
      INTO (@DATA(l_alt_spras))
     WHERE werks      EQ @inputobj-werks
       AND is_default EQ @abap_true.

*  Get last confirmation
    SELECT MAX( conf_cnt )
      FROM zabsf_pp065
      INTO (@DATA(l_conf_cnt))
     WHERE conf_no EQ @confirmation.
*       AND oprid   EQ @inputobj-oprid.

    IF sy-subrc EQ 0.
*    Get last confirmation row
      SELECT SINGLE *
        FROM zabsf_pp065
        INTO @DATA(ls_pp_sf065)
       WHERE conf_no   EQ @confirmation
*         AND oprid     EQ @inputobj-oprid
         AND conf_cnt  EQ @l_conf_cnt
*         AND ( count_fin NE 0 OR count_fin EQ @space ).
         AND count_fin EQ @space.

      IF sy-subrc EQ 0.
*      Schedule ID
        schedule_id = ls_pp_sf065-schedule_id.
*      Regime ID
        regime_id = ls_pp_sf065-regime_id.

*      Get schedule description
        SELECT SINGLE schedule_desc
          FROM zabsf_pp060_t
          INTO schedule_desc
         WHERE werks       EQ inputobj-werks
           AND schedule_id EQ ls_pp_sf065-schedule_id
           AND spras       EQ inputobj-language.

        IF sy-subrc NE 0.
*        Get schedule description for default language
          SELECT SINGLE schedule_desc
            FROM zabsf_pp060_t
            INTO schedule_desc
           WHERE werks       EQ inputobj-werks
             AND schedule_id EQ ls_pp_sf065-schedule_id
             AND spras       EQ l_alt_spras.
        ENDIF.

*      Get regime description
        SELECT SINGLE regime_desc
          FROM zabsf_pp062_t
          INTO regime_desc
         WHERE werks     EQ inputobj-werks
           AND regime_id EQ ls_pp_sf065-regime_id
           AND spras     EQ inputobj-language.

        IF sy-subrc NE 0.
*        Get regime description for default language
          SELECT SINGLE regime_desc
            FROM zabsf_pp062_t
            INTO regime_desc
           WHERE werks     EQ inputobj-werks
             AND regime_id EQ ls_pp_sf065-regime_id
             AND spras     EQ l_alt_spras.
        ENDIF.

*      Counter initial
        count_ini = ls_pp_sf065-count_ini.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD get_regimes.

    DATA: lt_associations TYPE TABLE OF zabsf_pp063,
          lt_regimes_txt  TYPE TABLE OF zabsf_pp062_t,
          ls_regimes_txt  LIKE LINE OF lt_regimes_txt.

    DATA: lv_alt_spras TYPE spras.

    FIELD-SYMBOLS: <fs_regimes> TYPE zabsf_pp_s_regimes.

* Get associations
    SELECT * FROM zabsf_pp063 INTO CORRESPONDING FIELDS OF TABLE lt_associations
      WHERE schedule_id = schedule_id
      AND werks = me->inputobj-werks.

    CHECK lt_associations IS NOT INITIAL.

* Get regimes
    SELECT * FROM zabsf_pp062 INTO CORRESPONDING FIELDS OF TABLE regimes
      FOR ALL ENTRIES IN lt_associations
      WHERE regime_id = lt_associations-regime_id
      AND werks = me->inputobj-werks.

    CHECK regimes IS NOT INITIAL.

* Get regimes descriptions
    SELECT * FROM zabsf_pp062_t INTO TABLE lt_regimes_txt
      FOR ALL ENTRIES IN regimes
           WHERE regime_id = regimes-regime_id
           AND spras = me->inputobj-language
           AND werks = me->inputobj-werks.

    IF lt_regimes_txt IS INITIAL.

      SELECT SINGLE spras FROM zabsf_pp061 INTO lv_alt_spras
              WHERE werks = inputobj-werks
              AND is_default EQ abap_true.


* Get regimes descriptions for default language
      SELECT * FROM zabsf_pp062_t INTO TABLE lt_regimes_txt
        FOR ALL ENTRIES IN regimes
             WHERE regime_id = regimes-regime_id
             AND spras = lv_alt_spras
             AND werks = me->inputobj-werks.


    ENDIF.

    LOOP AT regimes ASSIGNING <fs_regimes>.

      READ TABLE lt_regimes_txt INTO ls_regimes_txt WITH KEY regime_id = <fs_regimes>-regime_id.

      <fs_regimes>-regime_desc = ls_regimes_txt-regime_desc.

      CLEAR ls_regimes_txt.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_schedules.

    DATA: lt_schedules     TYPE TABLE OF zabsf_pp060,
          ls_schedules     LIKE LINE OF lt_schedules,
          ls_out_schedules TYPE zabsf_pp_s_sched_regime,
          lt_schedules_txt TYPE TABLE OF zabsf_pp060_t,
          ls_schedules_txt LIKE LINE OF lt_schedules_txt,
          lv_alt_spras     TYPE spras.

* get schedules.
    SELECT * FROM zabsf_pp060 INTO CORRESPONDING FIELDS OF TABLE lt_schedules
      WHERE werks EQ me->inputobj-werks.

    CHECK lt_schedules IS NOT INITIAL.

* get descriptions
    SELECT * FROM zabsf_pp060_t INTO TABLE lt_schedules_txt
      FOR ALL ENTRIES IN lt_schedules
        WHERE werks EQ me->inputobj-werks
        AND schedule_id EQ lt_schedules-schedule_id
        AND spras EQ  me->inputobj-language.

    IF lt_schedules_txt IS INITIAL.

* get descriptions for default language
      SELECT SINGLE spras FROM zabsf_pp061 INTO lv_alt_spras
              WHERE werks = inputobj-werks
              AND is_default EQ abap_true.

      IF lv_alt_spras IS NOT INITIAL.

        SELECT * FROM zabsf_pp060_t INTO TABLE lt_schedules_txt
          FOR ALL ENTRIES IN lt_schedules
            WHERE werks EQ me->inputobj-werks
            AND schedule_id EQ lt_schedules-schedule_id
            AND spras EQ  lv_alt_spras.
      ENDIF.
    ENDIF.


* get descriptions
    LOOP AT lt_schedules INTO ls_schedules.

      ls_out_schedules-schedule_id = ls_schedules-schedule_id.

      READ TABLE lt_schedules_txt INTO ls_schedules_txt WITH KEY schedule_id = ls_schedules-schedule_id.
      ls_out_schedules-schedule_desc = ls_schedules_txt-schedule_desc.

      APPEND ls_out_schedules TO schedules.

      CLEAR: ls_schedules, ls_out_schedules.

    ENDLOOP.



  ENDMETHOD.


  METHOD save_schedules_and_regimes.

    DATA: ls_sf065 TYPE zabsf_pp065.

* check if record exists.
    SELECT SINGLE * FROM zabsf_pp065 INTO ls_sf065
      WHERE conf_no = is_confirmation-conf_no
      AND conf_cnt = is_confirmation-conf_cnt
      AND oprid = is_confirmation-oprid.

    IF sy-subrc EQ 0.
*   update record
      ls_sf065-schedule_id = is_confirmation-schedule_id.
      ls_sf065-regime_id = is_confirmation-regime_id.

      UPDATE zabsf_pp065 FROM ls_sf065.
      IF sy-subrc NE 0.
        CALL METHOD zabsf_pp_cl_log=>add_message
          EXPORTING
            msgty      = 'E'
            msgno      = '068'
          CHANGING
            return_tab = return_tab.
        e_error = abap_true.
      ENDIF.

    ELSE.
*   insert new record
      INSERT INTO zabsf_pp065 VALUES is_confirmation.
      IF sy-subrc NE 0.
        CALL METHOD zabsf_pp_cl_log=>add_message
          EXPORTING
            msgty      = 'E'
            msgno      = '071'
          CHANGING
            return_tab = return_tab.
        e_error = abap_true.
      ENDIF.
    ENDIF.

    COMMIT WORK AND WAIT.



  ENDMETHOD.
ENDCLASS.
