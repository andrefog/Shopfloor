class ZABSF_PP_CL_EVENT_ACT definition
  public
  final
  create public .

public section.

  interfaces ZIF_ABSF_PP_EVENT_ACT .

  methods CONSTRUCTOR
    importing
      !INITIAL_REFDT type VVDATUM
      !INPUT_OBJECT type ZABSF_PP_S_INPUTOBJECT optional .
  methods CALC_MINUTES
    importing
      !DATE type DATUM
      !TIME type PR_TIME
      !PROC_DATE type DATUM
      !PROC_TIME type PR_TIME
    changing
      !ACTIVITY type RU_ISMNG
      !RETURN_TAB type BAPIRET2_T .
  methods GET_ACT_TO_CONF
    importing
      !ARBPL type ARBPL optional
      !AUFPL type CO_AUFPL
      !APLZL type CO_APLZL
      !ACTV_VALUE type RU_ISMNG
      !AFVV type AFVV
      !NR_OPERATOR type I optional
    exporting
      !ILE01 type CO_ISMNGEH
      !ISM01 type RU_ISMNG
      !ILE02 type CO_ISMNGEH
      !ISM02 type RU_ISMNG
      !ILE03 type CO_ISMNGEH
      !ISM03 type RU_ISMNG
      !ILE04 type CO_ISMNGEH
      !ISM04 type RU_ISMNG
      !ILE05 type CO_ISMNGEH
      !ISM05 type RU_ISMNG
      !ILE06 type CO_ISMNGEH
      !ISM06 type RU_ISMNG
    changing
      !RETURN_TAB type BAPIRET2_T .
  methods CHECK_USER
    importing
      !AUFNR type AUFNR
      !VORNR type VORNR
      !ARBPL type ARBPL
    exporting
      !OPRID type ZABSF_PP_E_OPRID .
protected section.
private section.

  constants END_PROD type ZABSF_PP_E_ACTV value 'END_PROD' ##NO_TEXT.
  constants INIT_PRE type ZABSF_PP_E_ACTV value 'INIT_PRE' ##NO_TEXT.
  constants INIT_PRO type ZABSF_PP_E_ACTV value 'INIT_PRO' ##NO_TEXT.
  constants END_PARC type ZABSF_PP_E_ACTV value 'END_PARC' ##NO_TEXT.
  constants STOP_PRO type ZABSF_PP_E_ACTV value 'STOP_PRO' ##NO_TEXT.
  constants CONF_REAL type ZABSF_PP_E_CONFTYPE value 'R' ##NO_TEXT.
  constants CONF_STAND type ZABSF_PP_E_CONFTYPE value 'S' ##NO_TEXT.
  data REFDT type VVDATUM .
  data INPUTOBJ type ZABSF_PP_S_INPUTOBJECT .
ENDCLASS.



CLASS ZABSF_PP_CL_EVENT_ACT IMPLEMENTATION.


METHOD calc_minutes.
*Variables
  DATA: l_date1      TYPE cva_date,
        l_date2      TYPE cva_date,
        l_time1      TYPE cva_time,
        l_time2      TYPE cva_time,
        l_days       TYPE i,
        l_time       TYPE cva_time,
        l_time_c(10).

*Dates and time to calculate
  l_date1 = date.
  l_date2 = proc_date.
  l_time1 = time.
  l_time2 = proc_time.

*Validar se a hora indicada não é anterior ao último registo, apenas no caso
*da hora estar a ser introduzida pelo utilizador
  IF l_date1 EQ l_date2 AND l_time2+4(2) EQ '00'.
    IF l_time1 > l_time2.

      CONCATENATE l_time1(2) l_time1+2(2) l_time1+4(2) INTO l_time_c SEPARATED BY ':'.

      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgid      = 'ZLP_PP_SHOPFLOOR'
          msgty      = 'E'
          msgno      = 063
          msgv1      = l_time_c
        CHANGING
          return_tab = return_tab.

      EXIT.
    ENDIF.
  ENDIF.

*Calculated time difference
  CALL FUNCTION 'SCOV_TIME_DIFF'
    EXPORTING
      im_date1              = l_date1
      im_date2              = l_date2
      im_time1              = l_time1
      im_time2              = l_time2
    IMPORTING
      ex_days               = l_days
      ex_time               = l_time
    EXCEPTIONS
      start_larger_than_end = 1
      OTHERS                = 2.

  IF sy-subrc <> 0.
* Implement suitable error handling here
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
  ELSE.
*  Calculated time of activity in minutes ( 1440 min for day, 60 sec for minute)
    activity = ( l_days * 1440 ) + ( l_time / 60 ).
  ENDIF.
ENDMETHOD.


METHOD check_user.
*  Get all operator in Production Order
  SELECT *
    FROM zabsf_pp014
    INTO TABLE @DATA(lt_pp_sf014)
   WHERE aufnr EQ @aufnr
     AND vornr EQ @vornr
     AND arbpl EQ @arbpl.

  IF lt_pp_sf014[] IS NOT INITIAL.
*    Check if user exist
    TRY.
        DATA(ls_pp_sf014) = lt_pp_sf014[ oprid = inputobj-oprid ].
      CATCH cx_sy_itab_line_not_found.
    ENDTRY.

*    If not exist user add first operator
    IF ls_pp_sf014 IS NOT INITIAL.
*        Operator ID
        oprid = ls_pp_sf014-oprid.
    ELSE.
      SORT lt_pp_sf014 BY udate ASCENDING utime ASCENDING.
*      Get first operator associated
      READ TABLE lt_pp_sf014 INTO ls_pp_sf014 INDEX 1.

      IF sy-subrc EQ 0.
*        Operator ID
        oprid = ls_pp_sf014-oprid.
      ENDIF.
    ENDIF.
  ENDIF.
ENDMETHOD.


METHOD CONSTRUCTOR.
*Ref. Date
  refdt = initial_refdt.

*App input data
  inputobj = input_object.
ENDMETHOD.


METHOD get_act_to_conf.
**  Internal tables
*    DATA: lt_crco TYPE zlp_sf_t_crco.
*
**  Structure
*    DATA: ls_crco TYPE crco.
*
**  Variables
*    DATA: l_time_in  TYPE qmih-auszt,
*          l_time_out TYPE qmih-auszt.
*
**  Constants
*    CONSTANTS c_meins TYPE meins VALUE 'MIN'.
*
**  Get activities types
*    CALL METHOD me->zif_lp_pp_sf_event_act~get_activity_type
*      EXPORTING
*        aufpl      = aufpl
*        aplzl      = aplzl
*      CHANGING
*        crco_tab   = lt_crco
*        return_tab = return_tab.
*
*    IF lt_crco[] IS NOT INITIAL.
*      LOOP AT lt_crco INTO ls_crco.
*        IF ls_crco-lstar IS NOT INITIAL.
*          CASE ls_crco-lanum.
*            WHEN 1.
*              IF afvv-vge01 NE c_meins.
*                l_time_in = actv_value.
*
**              Convert value to unit measurement intended
*                CALL FUNCTION 'PM_TIME_CONVERSION'
*                  EXPORTING
*                    time_in           = l_time_in
*                    unit_in_int       = 'MIN'
*                    unit_out_int      = afvv-vge01
*                  IMPORTING
*                    time_out          = l_time_out
*                  EXCEPTIONS
*                    invalid_time_unit = 1.
*
**              Converted value
*                ism01 = l_time_out.
*              ELSE.
*                ism01 = actv_value.
*              ENDIF.
*
**            Unit measurement
*              ile01 = afvv-vge01.
*            WHEN 2.
*              IF afvv-vge02 NE c_meins.
*                l_time_in = actv_value.
*
**              Convert value to unit measurement intended
*                CALL FUNCTION 'PM_TIME_CONVERSION'
*                  EXPORTING
*                    time_in           = l_time_in
*                    unit_in_int       = 'MIN'
*                    unit_out_int      = afvv-vge02
*                  IMPORTING
*                    time_out          = l_time_out
*                  EXCEPTIONS
*                    invalid_time_unit = 1.
*
**              Converted value
*                ism02 = l_time_out.
*              ELSE.
*                ism02 = actv_value.
*              ENDIF.
*
**            Unit measurement
*              ile02 = afvv-vge02.
*            WHEN 3.
*              IF afvv-vge03 NE c_meins.
*                l_time_in = actv_value.
*
**              Convert value to unit measurement final
*                CALL FUNCTION 'PM_TIME_CONVERSION'
*                  EXPORTING
*                    time_in           = l_time_in
*                    unit_in_int       = 'MIN'
*                    unit_out_int      = afvv-vge03
*                  IMPORTING
*                    time_out          = l_time_out
*                  EXCEPTIONS
*                    invalid_time_unit = 1.
*
**              Converted value
*                ism03 = l_time_out.
*              ELSE.
*                ism03 = actv_value.
*              ENDIF.
*
**            Unit measurement
*              ile03 = afvv-vge03.
*            WHEN 4.
*              IF afvv-vge04 NE c_meins.
*                l_time_in = actv_value.
*
**              Convert value to unit measurement final
*                CALL FUNCTION 'PM_TIME_CONVERSION'
*                  EXPORTING
*                    time_in           = l_time_in
*                    unit_in_int       = 'MIN'
*                    unit_out_int      = afvv-vge04
*                  IMPORTING
*                    time_out          = l_time_out
*                  EXCEPTIONS
*                    invalid_time_unit = 1.
*
**              Converted value
*                ism04 = l_time_out.
*              ELSE.
*                ism04 = actv_value.
*              ENDIF.
*
**            Unit measurement
*              ile04 = afvv-vge04.
*            WHEN 5.
*              IF afvv-vge05 NE c_meins.
*                l_time_in = actv_value.
*
**              Convert value to unit measurement final
*                CALL FUNCTION 'PM_TIME_CONVERSION'
*                  EXPORTING
*                    time_in           = l_time_in
*                    unit_in_int       = 'MIN'
*                    unit_out_int      = afvv-vge05
*                  IMPORTING
*                    time_out          = l_time_out
*                  EXCEPTIONS
*                    invalid_time_unit = 1.
*
**              Converted value
*                ism05 = l_time_out.
*              ELSE.
*                ism05 = actv_value.
*              ENDIF.
*
**            Unit measurement
*              ile05 = afvv-vge05.
*            WHEN 6.
*              IF afvv-vge06 NE c_meins.
*                l_time_in = actv_value.
*
**              Convert value to unit measurement final
*                CALL FUNCTION 'PM_TIME_CONVERSION'
*                  EXPORTING
*                    time_in           = l_time_in
*                    unit_in_int       = 'MIN'
*                    unit_out_int      = afvv-vge06
*                  IMPORTING
*                    time_out          = l_time_out
*                  EXCEPTIONS
*                    invalid_time_unit = 1.
*
**              Value converted
*                ism06 = l_time_out.
*              ELSE.
*                ism06 = actv_value.
*              ENDIF.
*
**            Unit measurement
*              ile06 = afvv-vge06.
*          ENDCASE.
*        ENDIF.
*      ENDLOOP.
*    ENDIF.

*  Internal table
    DATA: lt_plpo TYPE plpo_tab.

*  Variables
    DATA: l_time_in  TYPE qmih-auszt,
          l_time_out TYPE qmih-auszt.

*  Constants
    CONSTANTS c_meins TYPE meins VALUE 'MIN'.

*  Get multiplication factor
    SELECT SINGLE usr02, usr03
      FROM afvu
      INTO (@DATA(l_factor_multi),@DATA(l_actv_number))
     WHERE aufpl EQ @aufpl
       AND aplzl EQ @aplzl.

*  Check number has a comma
    FIND ',' IN l_factor_multi.

    IF sy-subrc EQ 0.
*    Replace comma by dot
      REPLACE ALL OCCURRENCES OF ',' IN l_factor_multi WITH '.'.
    ENDIF.

*  Get activities types
    CALL METHOD me->zif_absf_pp_event_act~get_activity_type
      EXPORTING
        aufpl      = aufpl
        aplzl      = aplzl
      CHANGING
        plpo_tab   = lt_plpo
        return_tab = return_tab.

    IF lt_plpo[] IS NOT INITIAL.
      LOOP AT lt_plpo INTO DATA(ls_plpo).
*      Activity 1
        IF ls_plpo-lar01 IS NOT INITIAL.
          IF afvv-vge01 NE c_meins.
            CLEAR: l_time_in,
                   l_time_out.

            l_time_in = actv_value.

*          Convert value to unit measurement intended
            CALL FUNCTION 'PM_TIME_CONVERSION'
              EXPORTING
                time_in           = l_time_in
                unit_in_int       = 'MIN'
                unit_out_int      = afvv-vge01
              IMPORTING
                time_out          = l_time_out
              EXCEPTIONS
                invalid_time_unit = 1.

*          Converted value
            ism01 = l_time_out.
          ELSE.
            ism01 = actv_value.
          ENDIF.

*        Multiplication factor
          IF l_factor_multi IS NOT INITIAL AND l_actv_number EQ '1'.
            ism01 = ism01 * l_factor_multi.
          ENDIF.

*        Multiple number operator
          IF nr_operator IS NOT INITIAL.
            ism01 = ism01. "* nr_operator. "BMR 29.10.2020 - Tempo de máquina
          ENDIF.

*        Unit measurement
          ile01 = afvv-vge01.
        ENDIF.

*      Activity 2
        IF ls_plpo-lar02 IS NOT INITIAL.
          IF afvv-vge02 NE c_meins.
            CLEAR: l_time_in,
                   l_time_out.

            l_time_in = actv_value.

*          Convert value to unit measurement intended
            CALL FUNCTION 'PM_TIME_CONVERSION'
              EXPORTING
                time_in           = l_time_in
                unit_in_int       = 'MIN'
                unit_out_int      = afvv-vge02
              IMPORTING
                time_out          = l_time_out
              EXCEPTIONS
                invalid_time_unit = 1.

*          Converted value
            ism02 = l_time_out.
          ELSE.
            ism02 = actv_value.
          ENDIF.

*        Multiplication factor
          IF l_factor_multi IS NOT INITIAL AND l_actv_number EQ '2'.
            ism02 = ism02 * l_factor_multi.
          ENDIF.

*        Multiple number operator
          IF nr_operator IS NOT INITIAL.
            ism02 = ism02 * nr_operator. "tempo de mão de obra
          ENDIF.

*        Unit measurement
          ile02 = afvv-vge02.
        ENDIF.

*      Activity 3
        IF ls_plpo-lar03 IS NOT INITIAL.
          IF afvv-vge03 NE c_meins.
            CLEAR: l_time_in,
                   l_time_out.

            l_time_in = actv_value.

*          Convert value to unit measurement intended
            CALL FUNCTION 'PM_TIME_CONVERSION'
              EXPORTING
                time_in           = l_time_in
                unit_in_int       = 'MIN'
                unit_out_int      = afvv-vge03
              IMPORTING
                time_out          = l_time_out
              EXCEPTIONS
                invalid_time_unit = 1.

*          Converted value
            ism03 = l_time_out.
          ELSE.
            ism03 = actv_value.
          ENDIF.

*        Multiplication factor
          IF l_factor_multi IS NOT INITIAL AND l_actv_number EQ '3'.
            ism03 = ism03 * l_factor_multi.
          ENDIF.

*        Multiple number operator
          IF nr_operator IS NOT INITIAL.
         "   ism03 = ism03 * nr_operator.  BMR COMMENT 08.06.2018 - não multiplicar as "horas de máquina" pelo nº de operadores
          ENDIF.

*        Unit measurement
          ile03 = afvv-vge03.
        ENDIF.

*      Activity 4
        IF ls_plpo-lar04 IS NOT INITIAL.
          IF afvv-vge04 NE c_meins.
            CLEAR: l_time_in,
                   l_time_out.

            l_time_in = actv_value.

*          Convert value to unit measurement intended
            CALL FUNCTION 'PM_TIME_CONVERSION'
              EXPORTING
                time_in           = l_time_in
                unit_in_int       = 'MIN'
                unit_out_int      = afvv-vge04
              IMPORTING
                time_out          = l_time_out
              EXCEPTIONS
                invalid_time_unit = 1.

*          Converted value
            ism04 = l_time_out.
          ELSE.
            ism04 = actv_value.
          ENDIF.

*        Multiplication factor
          IF l_factor_multi IS NOT INITIAL AND l_actv_number EQ '4'.
            ism04 = ism04 * l_factor_multi.
          ENDIF.

*        Multiple number operator
          IF nr_operator IS NOT INITIAL.
        "    ism04 = ism04 * nr_operator.  BMR COMMENT 08.06.2018 - não multiplicar as "horas de máquina" pelo nº de operadores
          ENDIF.

*        Unit measurement
          ile04 = afvv-vge04.
        ENDIF.

*      Activity 5
        IF ls_plpo-lar05 IS NOT INITIAL.
          IF afvv-vge05 NE c_meins.
            CLEAR: l_time_in,
                   l_time_out.

            l_time_in = actv_value.

*          Convert value to unit measurement intended
            CALL FUNCTION 'PM_TIME_CONVERSION'
              EXPORTING
                time_in           = l_time_in
                unit_in_int       = 'MIN'
                unit_out_int      = afvv-vge05
              IMPORTING
                time_out          = l_time_out
              EXCEPTIONS
                invalid_time_unit = 1.

*          Converted value
            ism05 = l_time_out.
          ELSE.
            ism05 = actv_value.
          ENDIF.

*        Multiplication factor
          IF l_factor_multi IS NOT INITIAL AND l_actv_number EQ '5'.
            ism05 = ism05 * l_factor_multi.
          ENDIF.

*        Multiple number operator
          IF nr_operator IS NOT INITIAL.
  "          ism05 = ism05 * nr_operator.  BMR COMMENT 08.06.2018 - não multiplicar as "horas de máquina" pelo nº de operadores
          ENDIF.

*        Unit measurement
          ile05 = afvv-vge05.
        ENDIF.

*      Activity 6
        IF ls_plpo-lar06 IS NOT INITIAL.
          IF afvv-vge06 NE c_meins.
            CLEAR: l_time_in,
                   l_time_out.

            l_time_in = actv_value.

*          Convert value to unit measurement intended
            CALL FUNCTION 'PM_TIME_CONVERSION'
              EXPORTING
                time_in           = l_time_in
                unit_in_int       = 'MIN'
                unit_out_int      = afvv-vge06
              IMPORTING
                time_out          = l_time_out
              EXCEPTIONS
                invalid_time_unit = 1.

*          Converted value
            ism06 = l_time_out.
          ELSE.
            ism06 = actv_value.
          ENDIF.

*        Multiplication factor
          IF l_factor_multi IS NOT INITIAL AND l_actv_number EQ '6'.
            ism06 = ism06 * l_factor_multi.
          ENDIF.

*        Multiple number operator
          IF nr_operator IS NOT INITIAL.
  "          ism06 = ism06 * nr_operator.  BMR COMMENT 08.06.2018 - não multiplicar as "horas de máquina" pelo nº de operadores
          ENDIF.

*        Unit measurement
          ile06 = afvv-vge06.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


METHOD ZIF_ABSF_PP_EVENT_ACT~GET_ACTIVITY.

** Get activity
*  SELECT SINGLE *
*    FROM ZABSF_PP018
*    INTO CORRESPONDING FIELDS OF activity_str
*    WHERE status_actv EQ status_actv.
*
*  IF sy-subrc NE 0.
**  No data found
*    CALL METHOD zcl_lp_pp_sf_log=>add_message
*      EXPORTING
*        msgty      = 'E'
*        msgno      = '017'
*      CHANGING
*        return_tab = return_tab.
*  ENDIF.
ENDMETHOD.


METHOD zif_absf_pp_event_act~get_activity_type.
*  DATA: ls_crhd TYPE crhd.
*
**Get object
*  SELECT SINGLE *
*    INTO CORRESPONDING FIELDS OF ls_crhd
*    FROM afvc AS afvc
*    INNER JOIN crhd AS crhd
*    ON crhd~objid EQ afvc~arbid
*    AND crhd~objty EQ 'A'
*    WHERE afvc~aufpl EQ aufpl
*      AND afvc~aplzl EQ aplzl.
*
*  IF sy-subrc NE 0.
*    CALL METHOD zcl_lp_pp_sf_log=>add_message
*      EXPORTING
*        msgty      = 'I'
*        msgno      = '018'
*      CHANGING
*        return_tab = return_tab.
*  ENDIF.
*
**Assignment of Work Center to Cost Center
*  SELECT *
*    FROM crco
*    INTO CORRESPONDING FIELDS OF TABLE crco_tab
*    WHERE objty EQ ls_crhd-objty
*      AND objid EQ ls_crhd-objid.
*
*    IF sy-subrc NE 0.
*      CALL METHOD zcl_lp_pp_sf_log=>add_message
*        EXPORTING
*          msgty      = 'I'
*          msgno      = '018'
*        CHANGING
*          return_tab = return_tab.
*    ENDIF.

* Get detail of Task List
  SELECT SINGLE plnty, plnnr, plnkn, zaehl
    FROM afvc
    INTO @DATA(ls_afvc)
   WHERE aufpl EQ @aufpl
     AND aplzl EQ @aplzl.

  IF sy-subrc NE 0.
*  Send information message
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'I'
        msgno      = '018'
      CHANGING
        return_tab = return_tab.
  ENDIF.

  IF ls_afvc IS NOT INITIAL.
*  Get activity of Task list
    SELECT SINGLE *
      FROM plpo
      INTO @DATA(ls_plpo)
     WHERE plnty EQ @ls_afvc-plnty
       AND plnnr EQ @ls_afvc-plnnr
       AND plnkn EQ @ls_afvc-plnkn
       AND zaehl EQ @ls_afvc-zaehl.

    IF sy-subrc EQ 0.
      APPEND ls_plpo TO plpo_tab.
    ELSE.
*    Send information message
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'I'
          msgno      = '018'
        CHANGING
          return_tab = return_tab.
    ENDIF.
  ENDIF.
ENDMETHOD.


METHOD zif_absf_pp_event_act~set_confirm_time.
  DATA: it_timeticket  TYPE TABLE OF bapi_pp_timeticket,
        it_zabsf_pp016 TYPE TABLE OF zabsf_pp016,
        it_crco        TYPE zabsf_pp_t_crco,
        lt_zabsf_pp021 TYPE TABLE OF zabsf_pp021,
        lt_opr_aux     TYPE TABLE OF zabsf_pp021,
        lt_jest        TYPE TABLE OF jest,
        detail_return  TYPE TABLE OF bapi_coru_return.

  DATA: ls_zabsf_pp018     TYPE zabsf_pp018,
        ls_zabsf_pp016     TYPE zabsf_pp016,
        ls_zabsf_pp010     TYPE zabsf_pp010,
        ls_return          TYPE bapiret2,
        ls_afru            TYPE afru,
        ls_afvv            TYPE afvv,
        wa_timeticket      TYPE bapi_pp_timeticket,
        wa_zabsf_pp016     TYPE zabsf_pp016,
        wa_zabsf_pp021     TYPE zabsf_pp021,
        wa_zabsf_pp010     TYPE zabsf_pp010,
        wa_detail_return   TYPE bapi_coru_return,
        wa_crco            TYPE crco,
        ls_activity        TYPE ru_ismng,
        post_wrong_entries TYPE bapi_coru_param-ins_err VALUE '2',
        return             TYPE bapiret1,
        ls_conftype        TYPE zabsf_pp_e_conftype,
        ld_shiftid         TYPE zabsf_pp_e_shiftid,
        ld_status_next     TYPE j_status,
        ld_status_stop     TYPE j_status VALUE 'STOP',
        status_out         TYPE j_status,
        status_desc        TYPE j_txt30,
        stsma_out          TYPE jsto-stsma,
        ld_time            TYPE pr_time,
        ld_date            TYPE datum,
        ld_lines           TYPE i,
        ld_hname_ty        TYPE cr_objty,
        ld_hname_id        TYPE cr_objid,
        ld_hname           TYPE cr_hname,
        ld_arbpl_id        TYPE cr_objid,
        count              TYPE i,
        lv_time            TYPE atime,
        ld_lengh           TYPE i,
        lv_objnr           TYPE j_objnr,
        lv_offset          TYPE xuvalue,
        lv_off             TYPE num02,
        lv_time_act        TYPE atime,
        lv_time_off        TYPE t,
        lv_time_c(10),
        lv_sub(1).

  CONSTANTS: c_min(3) VALUE 'MIN'.

  DATA: lref_sf_status   TYPE REF TO zabsf_pp_cl_status,
        lref_sf_calc_min TYPE REF TO zabsf_pp_cl_event_act.

  FIELD-SYMBOLS <fs_sf021> TYPE zabsf_pp021.

  REFRESH: it_timeticket,
           detail_return,
           it_zabsf_pp016.

  CLEAR: ls_zabsf_pp018,
         wa_zabsf_pp016,
         wa_timeticket,
         ls_afru,
         ld_shiftid,
         ld_hname_ty,
         ld_hname_id,
         ld_arbpl_id,
         ld_hname,
         return,
         lv_time.

*CLS 16062015
*Check time introduced to unable to introduce time in future
  SELECT SINGLE parva FROM zabsf_pp032
    INTO lv_offset
    WHERE werks = werks
    AND parid = 'TIME_OFFSET'.

  CLEAR lv_sub.
  IF lv_offset(1) = '-'.
    lv_sub = 'X'.
    lv_offset = lv_offset+1(2).
  ENDIF.

  lv_off = lv_offset.
  CONCATENATE lv_off '0000' INTO lv_time_off.

  IF lv_sub IS NOT INITIAL.
*    lv_time_act = sy-uzeit - lv_time_off.

    lv_time_act = time - lv_time_off.
  ELSE.
*    lv_time_act = sy-uzeit + lv_time_off.
    lv_time_act = time + lv_time_off.
  ENDIF.

  IF time > lv_time_act.
    CONCATENATE lv_time_act(2) lv_time_act+2(2) lv_time_act+4(2) INTO lv_time_c SEPARATED BY ':'.
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'E'
        msgno      = '062'
        msgv1      = lv_time_c
      CHANGING
        return_tab = return_tab.

    EXIT.
  ENDIF.

  TRANSLATE inputobj-oprid TO UPPER CASE. "CLS 16.06.2015
*Get shift witch operator is associated
  SELECT SINGLE shiftid
    FROM zabsf_pp052
    INTO ld_shiftid
   WHERE areaid EQ inputobj-areaid
     AND oprid EQ inputobj-oprid.

  IF sy-subrc NE 0.
*  Operator is not associated with shift
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'E'
        msgno      = '061'
        msgv1      = inputobj-oprid
      CHANGING
        return_tab = return_tab.

    EXIT.
  ENDIF.

*Get id of workcenter
  SELECT SINGLE objid
    FROM crhd
    INTO ld_arbpl_id
    WHERE arbpl EQ arbpl
    AND werks EQ werks. "CLS 12.06.2015

*Get hierarchy of workcenter
  SELECT SINGLE objty_hy objid_hy
    FROM crhs
    INTO (ld_hname_ty, ld_hname_id)
   WHERE objty_ho EQ 'A'         "Workcenter
     AND objid_ho EQ ld_arbpl_id.

*Get name of hierarchy
  SELECT SINGLE name
    FROM crhh
    INTO ld_hname
   WHERE objty EQ ld_hname_ty
     AND objid EQ ld_hname_id.

*Create object of class status
  CREATE OBJECT lref_sf_status
    EXPORTING
      initial_refdt = refdt
      input_object  = inputobj.

*Get last confirmation
  SELECT * UP TO 1 ROWS
    FROM zabsf_pp016
    INTO ls_zabsf_pp016
    WHERE areaid EQ inputobj-areaid
      AND hname EQ ld_hname
      AND werks EQ inputobj-werks
      AND arbpl EQ arbpl
      AND aufnr EQ aufnr
      AND vornr EQ vornr
      AND rueck EQ rueck
*      AND oprid EQ inputobj-oprid
*      AND shiftid EQ ld_shiftid
    ORDER BY rmzhl DESCENDING.
  ENDSELECT.

*Fill data for save in database
  wa_zabsf_pp016-areaid = inputobj-areaid.
  wa_zabsf_pp016-hname = ld_hname.
  wa_zabsf_pp016-werks = inputobj-werks.
  wa_zabsf_pp016-arbpl = arbpl.
  wa_zabsf_pp016-aufnr = aufnr.
  wa_zabsf_pp016-vornr = vornr.
  wa_zabsf_pp016-rueck = rueck.
  wa_zabsf_pp016-rmzhl = ls_zabsf_pp016-rmzhl + 1.
  wa_zabsf_pp016-aufpl = aufpl.
  wa_zabsf_pp016-aplzl = aplzl.
  wa_zabsf_pp016-oprid = inputobj-oprid.
  wa_zabsf_pp016-shiftid = ld_shiftid.

*Fill timeticket for confirmation
  wa_timeticket-orderid = aufnr.
  wa_timeticket-operation = vornr.
  wa_timeticket-conf_no = rueck.
  wa_timeticket-postg_date = date.
  wa_timeticket-ex_created_by = inputobj-oprid.
  wa_timeticket-kaptprog = ld_shiftid.

**Get Unit of measure
*  SELECT SINGLE *
*    FROM afvv
*    INTO CORRESPONDING FIELDS OF ls_afvv
*    WHERE aufpl EQ aufpl
*      AND aplzl EQ aplzl.

*>>> PAP - Correcções - 03.06.2015
  ld_lengh = strlen( time ).

  IF ld_lengh LT 6.
    CONCATENATE '0' time INTO lv_time.
  ELSE.
    lv_time = time.
  ENDIF.
*<<< PAP - Correcções - 03.06.2015

*Activities Type in Shopfloor
  CASE actv_id.
    WHEN init_pre. " Start Preparation
*    Check Confirmed date for 'Processing start' is inital - Restart production
*      IF ls_ZABSF_PP016-stprsnid IS NOT INITIAL AND ls_ZABSF_PP016-isdd IS NOT INITIAL.
      "CLS 11.06.2015
      IF ls_zabsf_pp016-stprsnid IS NOT INITIAL AND ls_zabsf_pp016-isbd IS NOT INITIAL.
        wa_zabsf_pp016-stprsnid = ls_zabsf_pp016-stprsnid.
        "CLS 11.06.2015
        wa_zabsf_pp016-iebd = date.
        wa_zabsf_pp016-iebz = lv_time.

*      Calculated activities time
        CALL METHOD me->calc_minutes
          EXPORTING
            date       = ls_zabsf_pp016-isbd
            time       = ls_zabsf_pp016-isbz
            proc_date  = wa_zabsf_pp016-iebd
            proc_time  = wa_zabsf_pp016-iebz
          CHANGING
            activity   = ls_activity
            return_tab = return_tab.

        READ TABLE return_tab INTO ls_return WITH KEY type = 'E'. "CLS 16.06.2015
        IF sy-subrc = 0.
          EXIT.
        ENDIF.

*      Add time to internal table
        wa_zabsf_pp016-stoptime = ls_activity.
*        wa_ZABSF_PP016-stopunit = ls_afvv-vge01.
        wa_zabsf_pp016-stopunit = c_min. "CLS 16.06.2015
*        wa_ZABSF_PP016-rmzhl = wa_ZABSF_PP016-rmzhl + 1.

        APPEND wa_zabsf_pp016 TO it_zabsf_pp016.

        wa_zabsf_pp016-rmzhl = wa_zabsf_pp016-rmzhl + 1.
      ENDIF.

      CLEAR: wa_zabsf_pp016-iebd,
             wa_zabsf_pp016-iebz,
             wa_zabsf_pp016-stoptime,
             wa_zabsf_pp016-stopunit,
             wa_zabsf_pp016-stprsnid.


*    Fill Confirmed date for start of execution
      wa_zabsf_pp016-isdd = date.
      wa_zabsf_pp016-isdz = lv_time.

*    Time to save
      APPEND wa_zabsf_pp016 TO it_zabsf_pp016.

      IF ls_zabsf_pp016-isdd IS INITIAL.
*      Fill Confirmed date for start of execution
        wa_timeticket-exec_start_date = date.
        wa_timeticket-exec_start_time = lv_time.

*      Times to confirm
        APPEND wa_timeticket TO it_timeticket.
      ENDIF.
    WHEN init_pro. " Start Production and Restart Production
*    Check Confirmed date for start of execution is not initial
      IF ls_zabsf_pp016-isdd IS NOT INITIAL AND ls_zabsf_pp016-isbd IS INITIAL.
        wa_zabsf_pp016-ierd = date.
        wa_zabsf_pp016-ierz = lv_time.

*      Calculated activities time
        CALL METHOD me->calc_minutes
          EXPORTING
            date       = ls_zabsf_pp016-isdd
            time       = ls_zabsf_pp016-isdz
            proc_date  = wa_zabsf_pp016-ierd
            proc_time  = wa_zabsf_pp016-ierz
          CHANGING
            activity   = ls_activity
            return_tab = return_tab.

        READ TABLE return_tab INTO ls_return WITH KEY type = 'E'. "CLS 16.06.2015
        IF sy-subrc = 0.
          EXIT.
        ENDIF.

*      Get activities types
        CALL METHOD me->zif_absf_pp_event_act~get_activity_type
          EXPORTING
            aufpl      = aufpl
            aplzl      = aplzl
          CHANGING
            crco_tab   = it_crco
            return_tab = return_tab.

        LOOP AT it_crco INTO wa_crco WHERE lanum EQ '001'.
          IF wa_crco-lstar IS NOT INITIAL.
            CASE wa_crco-lanum.
              WHEN 1.
                wa_zabsf_pp016-ism01 = ls_activity.
*                wa_ZABSF_PP016-ile01 = ls_afvv-vge01.
                wa_zabsf_pp016-ile01 = c_min. "CLS 16.06.2015
            ENDCASE.
          ENDIF.
        ENDLOOP.

*      Time to save
        APPEND wa_zabsf_pp016 TO it_zabsf_pp016.

        wa_zabsf_pp016-rmzhl = wa_zabsf_pp016-rmzhl + 1.
      ENDIF.

*    Check Confirmed date for 'Processing start' is inital - Restart production
      IF ls_zabsf_pp016-stprsnid IS NOT INITIAL AND ls_zabsf_pp016-isbd IS NOT INITIAL.
        wa_zabsf_pp016-stprsnid = ls_zabsf_pp016-stprsnid.
        wa_zabsf_pp016-iebd = date.
        wa_zabsf_pp016-iebz = lv_time.

*      Calculated activities time
        CALL METHOD me->calc_minutes
          EXPORTING
            date       = ls_zabsf_pp016-isbd
            time       = ls_zabsf_pp016-isbz
            proc_date  = wa_zabsf_pp016-iebd
            proc_time  = wa_zabsf_pp016-iebz
          CHANGING
            activity   = ls_activity
            return_tab = return_tab.

        READ TABLE return_tab INTO ls_return WITH KEY type = 'E'. "CLS 16.06.2015
        IF sy-subrc = 0.
          EXIT.
        ENDIF.

*      Add time to internal table
        wa_zabsf_pp016-stoptime = ls_activity.
*        wa_ZABSF_PP016-stopunit = ls_afvv-vge01.
        wa_zabsf_pp016-stopunit = c_min. "CLS 16.06.2015

        APPEND wa_zabsf_pp016 TO it_zabsf_pp016.

        wa_zabsf_pp016-rmzhl = wa_zabsf_pp016-rmzhl + 1.
      ENDIF.

      CLEAR: wa_zabsf_pp016-ierd,
             wa_zabsf_pp016-ierz,
             wa_zabsf_pp016-iebd,
             wa_zabsf_pp016-iebz,
             wa_zabsf_pp016-ism01,
             wa_zabsf_pp016-ile01,
             wa_zabsf_pp016-stoptime,
             wa_zabsf_pp016-stopunit,
             wa_zabsf_pp016-stprsnid.

*    Fill data to start production
      wa_zabsf_pp016-isbd = date.
      wa_zabsf_pp016-isbz = lv_time.

*      Time to save
      APPEND wa_zabsf_pp016 TO it_zabsf_pp016.

    WHEN stop_pro. " Stop Production\Preparation
*      actionid = 'STOP'.

*    Check Confirmed date for 'start of execution' is initial
      IF ls_zabsf_pp016-ierd IS INITIAL AND ls_zabsf_pp016-isdd IS NOT INITIAL.
        wa_zabsf_pp016-ierd = date.
        wa_zabsf_pp016-ierz = lv_time.

*      Calculated activities time
        CALL METHOD me->calc_minutes
          EXPORTING
            date       = ls_zabsf_pp016-isdd
            time       = ls_zabsf_pp016-isdz
            proc_date  = wa_zabsf_pp016-ierd
            proc_time  = wa_zabsf_pp016-ierz
          CHANGING
            activity   = ls_activity
            return_tab = return_tab.

        READ TABLE return_tab INTO ls_return WITH KEY type = 'E'. "CLS 16.06.2015
        IF sy-subrc = 0.
          EXIT.
        ENDIF.

*      Get activities types
        CALL METHOD me->zif_absf_pp_event_act~get_activity_type
          EXPORTING
            aufpl      = aufpl
            aplzl      = aplzl
          CHANGING
            crco_tab   = it_crco
            return_tab = return_tab.

        LOOP AT it_crco INTO wa_crco WHERE lanum EQ '001'.
          IF wa_crco-lstar IS NOT INITIAL.
            CASE wa_crco-lanum.
              WHEN 1.
                wa_zabsf_pp016-ism01 = ls_activity.
*                wa_ZABSF_PP016-ile01 = ls_afvv-vge01.
                wa_zabsf_pp016-ile01 = c_min. "CLS 16.06.2015
            ENDCASE.
          ENDIF.
        ENDLOOP.

*      Time to save
        APPEND wa_zabsf_pp016 TO it_zabsf_pp016.

        wa_zabsf_pp016-rmzhl = wa_zabsf_pp016-rmzhl + 1.

        CLEAR: wa_zabsf_pp016-ierd,
               wa_zabsf_pp016-ierz,
               wa_zabsf_pp016-ism01,
               wa_zabsf_pp016-ile01.

*      Fill data to stop reason
*        wa_ZABSF_PP016-rmzhl = wa_ZABSF_PP016-rmzhl + 1.
        wa_zabsf_pp016-stprsnid = stprsnid.
        "CLS 11.06.2015
        wa_zabsf_pp016-isbd = date.
        wa_zabsf_pp016-isbz = lv_time.

*      Time to save
        APPEND wa_zabsf_pp016 TO it_zabsf_pp016.

        wa_zabsf_pp016-rmzhl = wa_zabsf_pp016-rmzhl + 1.
      ENDIF.

*    Check Confirmed date for 'processing finish' is inital
      IF ls_zabsf_pp016-iebd IS INITIAL AND ls_zabsf_pp016-isbd IS NOT INITIAL.
        wa_zabsf_pp016-iebd = date.
        wa_zabsf_pp016-iebz = lv_time.
*        wa_ZABSF_PP016-rmzhl = wa_ZABSF_PP016-rmzhl + 1.

*      Calculated activities time
        CALL METHOD me->calc_minutes
          EXPORTING
            date       = ls_zabsf_pp016-isbd
            time       = ls_zabsf_pp016-isbz
            proc_date  = wa_zabsf_pp016-iebd
            proc_time  = wa_zabsf_pp016-iebz
          CHANGING
            activity   = ls_activity
            return_tab = return_tab.

        READ TABLE return_tab INTO ls_return WITH KEY type = 'E'. "CLS 16.06.2015
        IF sy-subrc = 0.
          EXIT.
        ENDIF.

*      Get activities types
        CALL METHOD me->zif_absf_pp_event_act~get_activity_type
          EXPORTING
            aufpl      = aufpl
            aplzl      = aplzl
          CHANGING
            crco_tab   = it_crco
            return_tab = return_tab.

        LOOP AT it_crco INTO wa_crco WHERE lanum NE '001'.
          IF wa_crco-lstar IS NOT INITIAL.
            CASE wa_crco-lanum.
              WHEN 2.
                wa_zabsf_pp016-ism02 = ls_activity.
*                wa_ZABSF_PP016-ile02 = ls_afvv-vge02.
                wa_zabsf_pp016-ile02 = c_min. "CLS 16.06.2015
              WHEN 3.
                wa_zabsf_pp016-ism03 = ls_activity.
*                wa_ZABSF_PP016-ile03 = ls_afvv-vge03.
                wa_zabsf_pp016-ile03 = c_min. "CLS 16.06.2015
              WHEN 4.
                wa_zabsf_pp016-ism04 = ls_activity.
*                wa_ZABSF_PP016-ile04 = ls_afvv-vge04.
                wa_zabsf_pp016-ile04 = c_min. "CLS 16.06.2015
              WHEN 5.
                wa_zabsf_pp016-ism05 = ls_activity.
*                wa_ZABSF_PP016-ile05 = ls_afvv-vge05.
                wa_zabsf_pp016-ile05 = c_min. "CLS 16.06.2015
              WHEN 6.
                wa_zabsf_pp016-ism06 = ls_activity.
*                wa_ZABSF_PP016-ile06 = ls_afvv-vge06.
                wa_zabsf_pp016-ile06 = c_min. "CLS 16.06.2015
            ENDCASE.
          ENDIF.
        ENDLOOP.

*      Time to save
        APPEND wa_zabsf_pp016 TO it_zabsf_pp016.

        wa_zabsf_pp016-rmzhl = wa_zabsf_pp016-rmzhl + 1.

        CLEAR: wa_zabsf_pp016-iebd,
               wa_zabsf_pp016-iebz,
               wa_zabsf_pp016-ism02,
               wa_zabsf_pp016-ile02,
               wa_zabsf_pp016-ism03,
               wa_zabsf_pp016-ile03,
               wa_zabsf_pp016-ism04,
               wa_zabsf_pp016-ile04,
               wa_zabsf_pp016-ism05,
               wa_zabsf_pp016-ile05,
               wa_zabsf_pp016-ism06,
               wa_zabsf_pp016-ile06.

*      Fill data to stop reason
        wa_zabsf_pp016-stprsnid = stprsnid.
        wa_zabsf_pp016-isbd = date.
        wa_zabsf_pp016-isbz = lv_time.

*      Time to save
        APPEND wa_zabsf_pp016 TO it_zabsf_pp016.
      ENDIF.
    WHEN end_parc. " Fim parcial
**    Check stop reason is not inital
*      IF ls_ZABSF_PP016-stprsnid IS NOT INITIAL.
*        wa_ZABSF_PP016-stprsnid = ls_ZABSF_PP016-stprsnid.
*
**      Add time to internal table
*        wa_ZABSF_PP016-stoptime = ls_activity.
*        wa_ZABSF_PP016-stopunit = ls_afvv-vge01.
*      ENDIF.


      "CLS 11.06.2015
      IF ls_zabsf_pp016-isdd IS NOT INITIAL.

        wa_zabsf_pp016-ierd = date.
        wa_zabsf_pp016-ierz = lv_time.
*    Calculated activities time
        CALL METHOD me->calc_minutes
          EXPORTING
            date       = ls_zabsf_pp016-isdd
            time       = ls_zabsf_pp016-isdz
            proc_date  = wa_zabsf_pp016-ierd
            proc_time  = wa_zabsf_pp016-ierz
          CHANGING
            activity   = ls_activity
            return_tab = return_tab.

        READ TABLE return_tab INTO ls_return WITH KEY type = 'E'. "CLS 16.06.2015
        IF sy-subrc = 0.
          EXIT.
        ENDIF.

      ELSEIF ls_zabsf_pp016-isbd IS NOT INITIAL.

        wa_zabsf_pp016-iebd = date.
        wa_zabsf_pp016-iebz = lv_time.

        CALL METHOD me->calc_minutes
          EXPORTING
            date       = ls_zabsf_pp016-isbd
            time       = ls_zabsf_pp016-isbz
            proc_date  = wa_zabsf_pp016-iebd
            proc_time  = wa_zabsf_pp016-iebz
          CHANGING
            activity   = ls_activity
            return_tab = return_tab.

        READ TABLE return_tab INTO ls_return WITH KEY type = 'E'. "CLS 16.06.2015
        IF sy-subrc = 0.
          EXIT.
        ENDIF.
      ENDIF.

*    Check stop reason is not inital
      IF ls_zabsf_pp016-stprsnid IS NOT INITIAL.
        wa_zabsf_pp016-stprsnid = ls_zabsf_pp016-stprsnid.

*      Add time to internal table
        wa_zabsf_pp016-stoptime = ls_activity.
*        wa_ZABSF_PP016-stopunit = ls_afvv-vge01.
        wa_zabsf_pp016-stopunit = c_min. "CLS 16.06.2015
      ELSE.
*      Get activities types
        CALL METHOD me->zif_absf_pp_event_act~get_activity_type
          EXPORTING
            aufpl      = aufpl
            aplzl      = aplzl
          CHANGING
            crco_tab   = it_crco
            return_tab = return_tab.


        IF ls_zabsf_pp016-isdd IS NOT INITIAL.
          LOOP AT it_crco INTO wa_crco WHERE lanum EQ '001'.
            IF wa_crco-lstar IS NOT INITIAL.
              CASE wa_crco-lanum.
                WHEN 1.
                  wa_zabsf_pp016-ism01 = ls_activity.
*                  wa_ZABSF_PP016-ile01 = ls_afvv-vge01.
                  wa_zabsf_pp016-ile01 = c_min. "CLS 16.06.2015
              ENDCASE.
            ENDIF.
          ENDLOOP.

        ELSEIF ls_zabsf_pp016-isbd IS NOT INITIAL.
          LOOP AT it_crco INTO wa_crco WHERE lanum NE '001'.
            IF wa_crco-lstar IS NOT INITIAL.
              CASE wa_crco-lanum.
                WHEN 2.
                  wa_zabsf_pp016-ism02 = ls_activity.
*                  wa_ZABSF_PP016-ile02 = ls_afvv-vge02.
                  wa_zabsf_pp016-ile02 = c_min. "CLS 16.06.2015
                WHEN 3.
                  wa_zabsf_pp016-ism03 = ls_activity.
*                  wa_ZABSF_PP016-ile03 = ls_afvv-vge03.
                  wa_zabsf_pp016-ile03 = c_min. "CLS 16.06.2015
                WHEN 4.
                  wa_zabsf_pp016-ism04 = ls_activity.
*                  wa_ZABSF_PP016-ile04 = ls_afvv-vge04.
                  wa_zabsf_pp016-ile04 = c_min. "CLS 16.06.2015
                WHEN 5.
                  wa_zabsf_pp016-ism05 = ls_activity.
*                  wa_ZABSF_PP016-ile05 = ls_afvv-vge05.
                  wa_zabsf_pp016-ile05 = c_min. "CLS 16.06.2015
                WHEN 6.
                  wa_zabsf_pp016-ism06 = ls_activity.
*                  wa_ZABSF_PP016-ile06 = ls_afvv-vge06.
                  wa_zabsf_pp016-ile06 = c_min. "CLS 16.06.2015
              ENDCASE.
            ENDIF.
          ENDLOOP.
        ENDIF.

      ENDIF.

*      Time to save
      APPEND wa_zabsf_pp016 TO it_zabsf_pp016.
    WHEN end_prod. "End Production
*    Fill data to finish production
      wa_zabsf_pp016-iebd = date.
      wa_zabsf_pp016-iebz = lv_time.
      wa_zabsf_pp016-fin_conf = 'X'.

      IF ls_zabsf_pp016-isbd IS NOT INITIAL AND ls_zabsf_pp016-isbz IS NOT INITIAL.
*      Calculated activities time
        CALL METHOD me->calc_minutes
          EXPORTING
            date       = ls_zabsf_pp016-isbd
            time       = ls_zabsf_pp016-isbz
            proc_date  = wa_zabsf_pp016-iebd
            proc_time  = wa_zabsf_pp016-iebz
          CHANGING
            activity   = ls_activity
            return_tab = return_tab.

        READ TABLE return_tab INTO ls_return WITH KEY type = 'E'. "CLS 16.06.2015
        IF sy-subrc = 0.
          EXIT.
        ENDIF.

*      Get activities types
        CALL METHOD me->zif_absf_pp_event_act~get_activity_type
          EXPORTING
            aufpl      = aufpl
            aplzl      = aplzl
          CHANGING
            crco_tab   = it_crco
            return_tab = return_tab.

        LOOP AT it_crco INTO wa_crco WHERE lanum NE '001'.
          IF wa_crco-lstar IS NOT INITIAL.
            CASE wa_crco-lanum.
              WHEN 2.
                wa_zabsf_pp016-ism02 = ls_activity.
*                wa_ZABSF_PP016-ile02 = ls_afvv-vge02.
                wa_zabsf_pp016-ile02 = c_min. "CLS 16.06.2015
              WHEN 3.
                wa_zabsf_pp016-ism03 = ls_activity.
*                wa_ZABSF_PP016-ile03 = ls_afvv-vge03.
                wa_zabsf_pp016-ile03 = c_min. "CLS 16.06.2015
              WHEN 4.
                wa_zabsf_pp016-ism04 = ls_activity.
*                wa_ZABSF_PP016-ile04 = ls_afvv-vge04.
                wa_zabsf_pp016-ile04 = c_min. "CLS 16.06.2015
              WHEN 5.
                wa_zabsf_pp016-ism05 = ls_activity.
*                wa_ZABSF_PP016-ile05 = ls_afvv-vge05.
                wa_zabsf_pp016-ile05 = c_min. "CLS 16.06.2015
              WHEN 6.
                wa_zabsf_pp016-ism06 = ls_activity.
*                wa_ZABSF_PP016-ile06 = ls_afvv-vge06.
                wa_zabsf_pp016-ile06 = c_min. "CLS 16.06.2015
            ENDCASE.
          ENDIF.
        ENDLOOP.
      ENDIF.

*    Time to save
      APPEND wa_zabsf_pp016 TO it_zabsf_pp016.

*    Fill data to finish production
      wa_timeticket-proc_fin_date = date.
      wa_timeticket-proc_fin_time = lv_time.
      wa_timeticket-fin_conf = 'X'.

*    Times to confirm
      APPEND wa_timeticket TO it_timeticket.
  ENDCASE.

  IF it_timeticket[] IS NOT INITIAL.
*  Create confirmation
    CALL FUNCTION 'BAPI_PRODORDCONF_CREATE_TT'
      EXPORTING
        post_wrong_entries = post_wrong_entries
      IMPORTING
        return             = return
      TABLES
        timetickets        = it_timeticket
        detail_return      = detail_return.

    IF return IS INITIAL.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = 'X'.

      IF it_zabsf_pp016[] IS NOT INITIAL.
        INSERT zabsf_pp016 FROM TABLE it_zabsf_pp016.
      ENDIF.

*    Save status of operation in database
      CALL METHOD lref_sf_status->status_object
        EXPORTING
          arbpl      = arbpl
          aufnr      = aufnr
          vornr      = vornr
          objty      = 'OV'
          method     = 'S'
*         status_oper = status_actv
          actionid   = actionid
        CHANGING
          return_tab = return_tab.
    ENDIF.

    LOOP AT detail_return INTO wa_detail_return.
      CLEAR return.

      return-type = wa_detail_return-type.
      return-id = wa_detail_return-id.
      return-number = wa_detail_return-number.
      return-message = wa_detail_return-message.
      return-message_v1 = wa_detail_return-message_v1.
      return-message_v2 = wa_detail_return-message_v2.
      return-message_v3 = wa_detail_return-message_v3.
      return-message_v4 = wa_detail_return-message_v4.

      APPEND return TO return_tab.
    ENDLOOP.
  ELSE.
    IF it_zabsf_pp016[] IS NOT INITIAL.
      INSERT zabsf_pp016 FROM TABLE it_zabsf_pp016.

      IF sy-subrc EQ 0.
*      Save status of operation in database
        CALL METHOD lref_sf_status->status_object
          EXPORTING
            arbpl      = arbpl
            aufnr      = aufnr
            vornr      = vornr
            objty      = 'OV'
            method     = 'S'
*           status_oper = status_actv
            actionid   = actionid
          CHANGING
            return_tab = return_tab.

*      Insert data successfully
        CALL METHOD zabsf_pp_cl_log=>add_message
          EXPORTING
            msgty      = 'S'
            msgno      = '013'
          CHANGING
            return_tab = return_tab.
      ELSE.
        CALL METHOD zabsf_pp_cl_log=>add_message
          EXPORTING
            msgty      = 'E'
            msgno      = '012'
          CHANGING
            return_tab = return_tab.
      ENDIF.
    ENDIF.
  ENDIF.

  CLEAR: wa_zabsf_pp021,
         ld_status_next,
         ld_lines,
         count.

*Check if all operation had status different of STOP_PROD
  SELECT SINGLE status_next
    FROM zabsf_pp022
    INTO ld_status_next
   WHERE objty       EQ 'OV'
     AND status_last EQ space
     AND status_next NE space.

  REFRESH lt_opr_aux.

  SELECT *
    FROM zabsf_pp021
    INTO CORRESPONDING FIELDS OF TABLE lt_zabsf_pp021
   WHERE arbpl EQ arbpl
     AND status_oper NE ld_status_next
     AND status_oper NE 'CONC'
     AND status_oper NE 'AGU'.

  lt_opr_aux[] = lt_zabsf_pp021[].

  LOOP AT lt_opr_aux ASSIGNING <fs_sf021>.
    CLEAR lv_objnr.

*  Get object
    SELECT SINGLE afvc~objnr
      INTO lv_objnr
      FROM afvc AS afvc
     INNER JOIN afko AS afko
        ON afko~aufpl EQ afvc~aufpl
     WHERE afko~aufnr EQ <fs_sf021>-aufnr
       AND afvc~vornr EQ <fs_sf021>-vornr.

    IF lv_objnr IS NOT INITIAL.
      REFRESH lt_jest.

*    Check status
      SELECT *
        FROM jest
        INTO CORRESPONDING FIELDS OF TABLE lt_jest
       WHERE objnr EQ lv_objnr
         AND ( stat  EQ 'I0045'  "ENTE
            OR stat  EQ 'I0009' )"CONF
         AND inact EQ space.

      IF lt_jest[] IS NOT INITIAL.
        UPDATE zabsf_pp021 SET status_oper = 'CONC'
                          WHERE arbpl EQ arbpl
                            AND aufnr EQ <fs_sf021>-aufnr
                            AND vornr EQ <fs_sf021>-vornr.

        DELETE lt_zabsf_pp021 WHERE arbpl EQ arbpl
                                 AND aufnr EQ <fs_sf021>-aufnr
                                 AND vornr EQ <fs_sf021>-vornr.
      ENDIF.

    ENDIF.
  ENDLOOP.

  DESCRIBE TABLE lt_zabsf_pp021 LINES ld_lines.

  LOOP AT lt_zabsf_pp021 INTO wa_zabsf_pp021.
    IF wa_zabsf_pp021-status_oper EQ ld_status_stop .
      ADD 1 TO count.
    ENDIF.
  ENDLOOP.

* Get current status of Workcenter
  CALL METHOD lref_sf_status->status_object
    EXPORTING
      arbpl       = arbpl
      werks       = inputobj-werks
      objty       = 'CA'
      method      = 'G'
*     actionid    = actionid
    CHANGING
      status_out  = status_out
      status_desc = status_desc
      stsma_out   = stsma_out
      return_tab  = return_tab.

  CLEAR ld_status_next.

  SELECT SINGLE status_next
    FROM zabsf_pp022
    INTO ld_status_next
   WHERE objty EQ 'CA'
     AND status_last EQ status_out
     AND stsma EQ stsma_out
     AND actionid EQ actionid.

*Check if all operation had different status and change status of workcenter
  IF ld_lines EQ count AND actionid NE 'CONC'.
*  Set status for Stop
    CALL METHOD lref_sf_status->status_object
      EXPORTING
        arbpl      = arbpl
        werks      = inputobj-werks
        objty      = 'CA'
        status     = ld_status_next
        stsma      = stsma_out
        method     = 'S'
        actionid   = actionid
      CHANGING
        return_tab = return_tab.

    "CLS 12.06.2015
    IF ld_status_next = '0003'. "Parado
      "Verificar se paragem já foi registada
      SELECT SINGLE *
      FROM zabsf_pp010
      INTO CORRESPONDING FIELDS OF wa_zabsf_pp010
      WHERE areaid   EQ inputobj-areaid
        AND hname    EQ ld_hname
        AND werks    EQ inputobj-werks
        AND arbpl    EQ arbpl
        AND timeend  EQ '000000'.

      IF sy-subrc NE 0.
        "Criar registo de paragem
        wa_zabsf_pp010-areaid = inputobj-areaid.
        wa_zabsf_pp010-hname = ld_hname.
        wa_zabsf_pp010-werks = inputobj-werks.
        wa_zabsf_pp010-arbpl = arbpl.
        wa_zabsf_pp010-datesr = date.
        wa_zabsf_pp010-time = time.
        wa_zabsf_pp010-operador = inputobj-oprid.
        wa_zabsf_pp010-shiftid = ld_shiftid.
        wa_zabsf_pp010-stprsnid = 'P.OP'.
        wa_zabsf_pp010-stopunit = c_min.
        INSERT INTO zabsf_pp010 VALUES wa_zabsf_pp010.
      ENDIF.

    ELSEIF ld_status_next = '0002'. "Ativo
      "Encerrar registo de paragem
      SELECT SINGLE *
      FROM zabsf_pp010
      INTO CORRESPONDING FIELDS OF wa_zabsf_pp010
      WHERE areaid   EQ inputobj-areaid
        AND hname    EQ ld_hname
        AND werks    EQ inputobj-werks
        AND arbpl    EQ arbpl
        AND timeend  EQ '000000'.

      IF sy-subrc EQ 0.
        ld_time = time.
        ld_date = date.

        CALL METHOD me->calc_minutes
          EXPORTING
            date       = wa_zabsf_pp010-datesr
            time       = wa_zabsf_pp010-time
            proc_date  = ld_date
            proc_time  = ld_time
          CHANGING
            activity   = ls_activity
            return_tab = return_tab.

        wa_zabsf_pp010-stoptime  = ls_activity.
        wa_zabsf_pp010-stopunit = c_min.
        wa_zabsf_pp010-timeend = lv_time.
        wa_zabsf_pp010-endda = ld_date."BMR INSERT.
        UPDATE zabsf_pp010 FROM wa_zabsf_pp010.
      ENDIF.
    ENDIF.


  ELSEIF ( status_out EQ '0001' OR status_out EQ '0003' OR status_out EQ '0004' ) AND actionid NE 'CONC' .  "Initial, Parado, Reparação
*  Set status for Active
    CALL METHOD lref_sf_status->status_object
      EXPORTING
        arbpl      = arbpl
        werks      = inputobj-werks
        objty      = 'CA'
        status     = ld_status_next
        stsma      = stsma_out
        method     = 'S'
        actionid   = actionid
      CHANGING
        return_tab = return_tab.

    IF status_out EQ '0003' OR status_out EQ '0004'.
      CLEAR ls_zabsf_pp010.

      SELECT SINGLE *
        FROM zabsf_pp010
        INTO CORRESPONDING FIELDS OF ls_zabsf_pp010
       WHERE areaid   EQ inputobj-areaid
         AND hname    EQ ld_hname
         AND werks    EQ inputobj-werks
         AND arbpl    EQ arbpl
*         AND operador EQ inputobj-oprid
*         AND shiftid  EQ ld_shiftid
         AND timeend  EQ '000000'.
*         AND datesr   EQ date.

      IF sy-subrc EQ 0.
        ld_time = lv_time.

        CALL METHOD me->calc_minutes
          EXPORTING
            date       = ls_zabsf_pp010-datesr "date
            time       = ls_zabsf_pp010-time   "ld_time
            proc_date  = date                   "ls_ZABSF_PP010-datesr
            proc_time  = ld_time                "ls_ZABSF_PP010-time
          CHANGING
            activity   = ls_activity
            return_tab = return_tab.

        ls_zabsf_pp010-stoptime  = ls_activity.
*        ls_ZABSF_PP010-stopunit = ls_afvv-vge01.
        ls_zabsf_pp010-stopunit = c_min. "CLS 16.06.2015
        ls_zabsf_pp010-timeend = ld_time.
        ls_zabsf_pp010-endda = date. "BMR INSERT.
        UPDATE zabsf_pp010 FROM ls_zabsf_pp010.
      ENDIF.
    ENDIF.
  ENDIF.
ENDMETHOD.


METHOD zif_absf_pp_event_act~set_conf_event_time.
*  Internal tables
  DATA: lt_zabsf_pp016   TYPE TABLE OF zabsf_pp016,
        lt_timeticket    TYPE TABLE OF bapi_pp_timeticket,
        lt_detail_return TYPE TABLE OF bapi_coru_return,
        lt_reg_oper      TYPE TABLE OF zabsf_pp021,
        lt_operator_tab  TYPE zabsf_pp_t_operador,
        lt_return_tab    TYPE bapiret2_t.

*  Structures
  DATA: ls_zabsf_pp016    TYPE zabsf_pp016,
        ls_pp_sf016_ini   TYPE zabsf_pp016,
        ls_timeticket     TYPE bapi_pp_timeticket,
        ls_timeticket_ini TYPE bapi_pp_timeticket,
        ls_return_tab     TYPE bapiret2,
        ls_return         TYPE bapiret1,
        ls_detail_return  TYPE bapi_coru_return,
        ls_zabsf_pp021    TYPE zabsf_pp021,
        ls_conf_data      TYPE zabsf_pp_s_conf_adit_data,
        ls_operator_tab   TYPE zabsf_pp_s_operador,
        ls_zabsf_pp066    TYPE zabsf_pp066.

*  References
  DATA: lref_sf_status   TYPE REF TO zabsf_pp_cl_status,
        lref_sf_calc_min TYPE REF TO zabsf_pp_cl_event_act,
        lref_sf_prdord   TYPE REF TO zabsf_pp_cl_prdord.

*  Variables
  DATA: l_activity         TYPE ru_ismng,
        l_time             TYPE atime,
        l_off_nr           TYPE num02,
        l_time_act         TYPE atime,
        l_time_off         TYPE atime,
        l_time_c(10),
        l_sub(1),
        l_count            TYPE i,
        l_status_out       TYPE j_status,
        l_status_desc      TYPE j_txt30,
        l_stsma_out        TYPE jsto-stsma,
        l_date_calc        TYPE datum,
        l_time_calc        TYPE pr_time,
        l_ile01            TYPE co_ismngeh,
        l_ism01            TYPE ru_ismng,
        l_ile02            TYPE co_ismngeh,
        l_ism02            TYPE ru_ismng,
        l_ile03            TYPE co_ismngeh,
        l_ism03            TYPE ru_ismng,
        l_ile04            TYPE co_ismngeh,
        l_ism04            TYPE ru_ismng,
        l_ile05            TYPE co_ismngeh,
        l_ism05            TYPE ru_ismng,
        l_ile06            TYPE co_ismngeh,
        l_ism06            TYPE ru_ismng,
        l_conf_no          TYPE co_rueck,
        l_conf_cnt         TYPE co_rmzhl,
        l_nr_operator_calc TYPE i,
        l_oprid            TYPE zabsf_pp_e_oprid.

*  Constants
  CONSTANTS: c_min(3)             TYPE c                       VALUE 'MIN',
             c_time_offset        TYPE zabsf_pp_e_parid        VALUE 'TIME_OFFSET',
             c_objty_ho           TYPE cr_objty                VALUE 'A',            "Workcenter
             c_status_stop        TYPE j_status                VALUE 'STOP',
             c_post_wrong_entries TYPE bapi_coru_param-ins_err VALUE '2'.


  REFRESH: lt_zabsf_pp016,
           lt_timeticket,
           lt_detail_return.

  CLEAR: ls_zabsf_pp016,
         ls_timeticket,
         ls_return,
         l_time,
         l_sub,
         l_off_nr,
         l_time_off,
         l_time_act,
         l_oprid.

*  Check lenght of time
  DATA(l_lengh) = strlen( time ).

  IF l_lengh LT 6.
    CONCATENATE '0' time INTO l_time.
  ELSE.
    l_time = time.
  ENDIF.

*  Upper case operator
  TRANSLATE inputobj-oprid TO UPPER CASE.

*  Check user in operation
  CALL METHOD me->check_user
    EXPORTING
      aufnr = aufnr
      vornr = vornr
      arbpl = arbpl
    IMPORTING
      oprid = l_oprid.

  IF l_oprid IS NOT INITIAL.
    inputobj-oprid = l_oprid.
* ADR -  Validar se pernr é utilizado
    inputobj-pernr = ''.
  ENDIF.

  IF l_oprid IS INITIAL.
    IF backoffice IS INITIAL.
*      Get shift witch operator is associated
      SELECT SINGLE shiftid
        FROM zabsf_pp052
        INTO (@DATA(l_shiftid))
       WHERE areaid EQ @inputobj-areaid
         AND oprid  EQ @inputobj-oprid.

      IF sy-subrc NE 0.
*        Operator is not associated with shift
        CALL METHOD zabsf_pp_cl_log=>add_message
          EXPORTING
            msgty      = 'E'
            msgno      = '061'
            msgv1      = inputobj-oprid
          CHANGING
            return_tab = return_tab.

        EXIT.
      ENDIF.
    ELSE.
*      Shift ID
      l_shiftid = shiftid.
    ENDIF.
  ELSE.
    l_shiftid = shiftid.
  ENDIF.

  "post de trabalho
  IF kapid IS NOT INITIAL.
    SELECT SINGLE name
      FROM kako
      INTO @DATA(lv_workstation_var)
        WHERE kapid EQ @kapid.
  ELSE.
    "obter posto de trabalho
    SELECT SINGLE kapid
      FROM zabsf_pp014
      INTO @DATA(lv_workstation_id_var)
        WHERE aufnr EQ @aufnr
          AND vornr EQ @vornr
          AND arbpl EQ @arbpl
          AND oprid EQ @inputobj-oprid
          AND kapid NE @space
          AND status EQ 'A'.
    IF sy-subrc EQ 0.
      SELECT SINGLE name
        FROM kako
        INTO @lv_workstation_var
          WHERE kapid EQ @lv_workstation_id_var.
    ENDIF.
  ENDIF.


*  Get id of workcenter
  SELECT SINGLE objid
    FROM crhd
    INTO (@DATA(l_arbpl_id))
   WHERE arbpl EQ @arbpl
     AND werks EQ @werks.

*  Get hierarchy of Work center
  SELECT SINGLE objty_hy, objid_hy
    FROM crhs
    INTO (@DATA(l_hname_ty), @DATA(l_hname_id))
   WHERE objty_ho EQ @c_objty_ho "Workcenter
     AND objid_ho EQ @l_arbpl_id.

*  Get name of hierarchy
  SELECT SINGLE name
    FROM crhh
    INTO (@DATA(l_hname))
   WHERE objty EQ @l_hname_ty
     AND objid EQ @l_hname_id.

*  Create object of class status
  CREATE OBJECT lref_sf_status
    EXPORTING
      initial_refdt = refdt
      input_object  = inputobj.


*  Get last confirmation
  SELECT * UP TO 1 ROWS
    FROM zabsf_pp016
    INTO @DATA(ls_afru_sf016)
   WHERE areaid EQ @inputobj-areaid
     AND hname  EQ @l_hname
     AND werks  EQ @inputobj-werks
     AND arbpl  EQ @arbpl
     AND aufnr  EQ @aufnr
     AND vornr  EQ @vornr
     AND rueck  EQ @rueck
   ORDER BY rmzhl DESCENDING.
  ENDSELECT.

*  Counter Number of employees in Production Order
  SELECT COUNT( * )
    FROM zabsf_pp014
    INTO (@DATA(l_nr_operator))
   WHERE arbpl  EQ @arbpl
     AND aufnr  EQ @aufnr
     AND vornr  EQ @vornr
     AND tipord EQ 'N'
     AND status EQ 'A'.

  IF l_nr_operator IS NOT INITIAL.
    CLEAR l_nr_operator_calc.

    l_nr_operator_calc = l_nr_operator.
  ENDIF.

*  Fill data for save in database
  ls_pp_sf016_ini-areaid = inputobj-areaid.
  ls_pp_sf016_ini-hname = l_hname.
  ls_pp_sf016_ini-werks = inputobj-werks.
  ls_pp_sf016_ini-arbpl = arbpl.
  ls_pp_sf016_ini-aufnr = aufnr.
  ls_pp_sf016_ini-vornr = vornr.
  ls_pp_sf016_ini-rueck = rueck.
*    ls_pp_sf016_ini-rmzhl = ls_afru_sf016-rmzhl + 1.
  DATA(l_rmzhl) = ls_afru_sf016-rmzhl + 1.
  ls_pp_sf016_ini-aufpl = aufpl.
  ls_pp_sf016_ini-aplzl = aplzl.
  ls_pp_sf016_ini-oprid = inputobj-oprid.
  ls_pp_sf016_ini-shiftid = l_shiftid.

  IF l_nr_operator IS NOT INITIAL.
*    Number of employees
    ls_pp_sf016_ini-no_of_employee = l_nr_operator.
  ENDIF.

*  Fill timeticket for confirmation
  ls_timeticket_ini-orderid = aufnr.
  ls_timeticket_ini-operation = vornr.
  ls_timeticket_ini-conf_no = rueck.
  ls_timeticket_ini-postg_date = date.
  ls_timeticket_ini-ex_created_by = inputobj-oprid.
  ls_timeticket_ini-kaptprog = l_shiftid.

  IF l_nr_operator IS NOT INITIAL.
*    Number of employees
    ls_timeticket_ini-no_of_employee = l_nr_operator.
  ENDIF.

*  Get Unit of measure
  SELECT SINGLE *
    FROM afvv
    INTO @DATA(ls_afvv)
   WHERE aufpl EQ @aufpl
     AND aplzl EQ @aplzl.

*  Activities Type in Shopfloor
  CASE actv_id.
    WHEN init_pre. "Start Preparation
*      Check Confirmed date for 'Processing start' is inital - Restart production
      IF ls_afru_sf016-stprsnid IS NOT INITIAL AND ls_afru_sf016-isbd IS NOT INITIAL.
*        Move initial data
        MOVE-CORRESPONDING ls_pp_sf016_ini TO ls_zabsf_pp016.

        ls_zabsf_pp016-stprsnid = ls_afru_sf016-stprsnid.
        ls_zabsf_pp016-iebd = date.
        ls_zabsf_pp016-iebz = l_time.
        ls_zabsf_pp016-shiftid = ls_afru_sf016-shiftid.

*        Calculated activities time
        CALL METHOD me->calc_minutes
          EXPORTING
            date       = ls_afru_sf016-isbd
            time       = ls_afru_sf016-isbz
            proc_date  = ls_zabsf_pp016-iebd
            proc_time  = ls_zabsf_pp016-iebz
          CHANGING
            activity   = l_activity
            return_tab = return_tab.

*        Check if exist erro in calcutation
        READ TABLE return_tab INTO ls_return_tab WITH KEY type = 'E'.

        IF sy-subrc = 0.
          EXIT.
        ENDIF.

*        Add time to internal table
        ls_zabsf_pp016-stoptime = l_activity.
*          ls_ZABSF_PP016-stopunit = ls_afvv-vge01.
        ls_zabsf_pp016-stopunit = c_min.

*        Confirmation counter
        ls_zabsf_pp016-rmzhl = l_rmzhl.

        APPEND ls_zabsf_pp016 TO lt_zabsf_pp016.

*        Create new counter
        ADD 1 TO l_rmzhl.

        CLEAR ls_timeticket.

*        Move initial data
        MOVE-CORRESPONDING ls_timeticket_ini TO ls_timeticket.

        ls_timeticket-exec_start_date = ls_afru_sf016-isbd.
        ls_timeticket-exec_start_time = ls_afru_sf016-isbz.
        ls_timeticket-proc_start_date = ls_afru_sf016-isbd.
        ls_timeticket-proc_start_time = ls_afru_sf016-isbz.
        ls_timeticket-proc_fin_date = ls_zabsf_pp016-iebd.
        ls_timeticket-proc_fin_time = ls_zabsf_pp016-iebz.
        ls_timeticket-break_unit = c_min.
        ls_timeticket-break_time = l_activity.
        ls_timeticket-kaptprog = ls_afru_sf016-shiftid.
        "BMR INSERT 16.06.2020
        ls_timeticket-conf_text = lv_workstation_var.
*        Times to confirm

        IF ls_timeticket-conf_no NE '0000000000'.
          APPEND ls_timeticket TO lt_timeticket.
        ENDIF.
*        Confirmation to create break
        DESCRIBE TABLE lt_timeticket LINES DATA(l_conf_break).
      ENDIF.

      CLEAR: ls_zabsf_pp016.

*      Move initial data
      MOVE-CORRESPONDING ls_pp_sf016_ini TO ls_zabsf_pp016.

*      Fill Confirmed date for start of execution
      ls_zabsf_pp016-isdd = date.
      ls_zabsf_pp016-isdz = l_time.
*      Confirmation counter
      ls_zabsf_pp016-rmzhl = l_rmzhl.

*      Time to save
      IF ls_zabsf_pp016-conf_no NE '0000000000'.
        APPEND ls_zabsf_pp016 TO lt_zabsf_pp016.
      ENDIF.

*        IF ls_afru_sf016-isdd IS INITIAL.
      CLEAR: ls_timeticket.

*      Move initial data
      MOVE-CORRESPONDING ls_timeticket_ini TO ls_timeticket.

*      Fill Confirmed date for start of execution
      ls_timeticket-exec_start_date = date.
      ls_timeticket-exec_start_time = l_time.

*      Times to confirm
      APPEND ls_timeticket TO lt_timeticket.

*      To create card number
      DATA(l_card_create) = abap_true.

*      Confirmation to create card
      DESCRIBE TABLE lt_timeticket LINES DATA(l_conf_create).

*        ENDIF.
    WHEN init_pro. " Start Production and Restart Production
*      Check Confirmed date for start of execution is not initial
      IF ls_afru_sf016-isdd IS NOT INITIAL AND ls_afru_sf016-isbd IS INITIAL.
        CLEAR ls_zabsf_pp016.

*        Move initial data
        MOVE-CORRESPONDING ls_pp_sf016_ini TO ls_zabsf_pp016.

        ls_zabsf_pp016-ierd = date.
        ls_zabsf_pp016-ierz = l_time.
        ls_zabsf_pp016-shiftid = ls_afru_sf016-shiftid.

*        Calculated activities time
        CALL METHOD me->calc_minutes
          EXPORTING
            date       = ls_afru_sf016-isdd
            time       = ls_afru_sf016-isdz
            proc_date  = ls_zabsf_pp016-ierd
            proc_time  = ls_zabsf_pp016-ierz
          CHANGING
            activity   = l_activity
            return_tab = return_tab.

*        Check if exist erro in calcutation
        READ TABLE return_tab INTO ls_return_tab WITH KEY type = 'E'.
        IF sy-subrc = 0.
          EXIT.
        ENDIF.

*        Get activities types
        CALL METHOD me->get_act_to_conf
          EXPORTING
            aufpl       = aufpl
            aplzl       = aplzl
            actv_value  = l_activity
            afvv        = ls_afvv
            nr_operator = l_nr_operator_calc
          IMPORTING
            ile01       = l_ile01
            ism01       = l_ism01
            ile02       = l_ile02
            ism02       = l_ism02
            ile03       = l_ile03
            ism03       = l_ism03
            ile04       = l_ile04
            ism04       = l_ism04
            ile05       = l_ile05
            ism05       = l_ism05
            ile06       = l_ile06
            ism06       = l_ism06
          CHANGING
            return_tab  = return_tab.

*        Fill values calculated
        ls_zabsf_pp016-ile01 = ls_timeticket-conf_acti_unit1 = l_ile01.
        ls_zabsf_pp016-ism01 = ls_timeticket-conf_activity1 = l_ism01.
        ls_zabsf_pp016-ile02 = ls_timeticket-conf_acti_unit2 = l_ile02.
        ls_zabsf_pp016-ism02 = ls_timeticket-conf_activity2 = l_ism02.
        ls_zabsf_pp016-ile03 = ls_timeticket-conf_acti_unit3 = l_ile03.
        ls_zabsf_pp016-ism03 = ls_timeticket-conf_activity3 = l_ism03. "* l_nr_operator.
        ls_zabsf_pp016-ile04 = ls_timeticket-conf_acti_unit4 = l_ile04.
        ls_zabsf_pp016-ism04 = ls_timeticket-conf_activity4 = l_ism04.
        ls_zabsf_pp016-ile05 = ls_timeticket-conf_acti_unit5 = l_ile05.
        ls_zabsf_pp016-ism05 = ls_timeticket-conf_activity5 = l_ism05.
        ls_zabsf_pp016-ile06 = ls_timeticket-conf_acti_unit6 = l_ile06.
        ls_zabsf_pp016-ism06 = ls_timeticket-conf_activity6 = l_ism06.

*        Confirmation counter
        ls_zabsf_pp016-rmzhl = l_rmzhl.

*        Time to save
        APPEND ls_zabsf_pp016 TO lt_zabsf_pp016.

*        Move initial data
        MOVE-CORRESPONDING ls_timeticket_ini TO ls_timeticket.

*        Fill Confirmed date for End of Execution
        ls_timeticket-exec_start_date = date.
        ls_timeticket-exec_start_time = l_time.
        ls_timeticket-setup_fin_date = date.
        ls_timeticket-setup_fin_time = l_time.
        ls_timeticket-kaptprog = ls_afru_sf016-shiftid.

*        Times to confirm
        IF ls_timeticket-conf_no NE '0000000000'.
          APPEND ls_timeticket TO lt_timeticket.
        ENDIF.
*        Create new counter
        ADD 1 TO l_rmzhl.
      ENDIF.

*      Check Confirmed date for 'Processing start' is inital - Restart production
      IF ls_afru_sf016-stprsnid IS NOT INITIAL AND ls_afru_sf016-isbd IS NOT INITIAL.
        CLEAR ls_zabsf_pp016.

*        Move initial data
        MOVE-CORRESPONDING ls_pp_sf016_ini TO ls_zabsf_pp016.

        ls_zabsf_pp016-stprsnid = ls_afru_sf016-stprsnid.
        ls_zabsf_pp016-iebd = date.
        ls_zabsf_pp016-iebz = l_time.
        ls_zabsf_pp016-shiftid = ls_afru_sf016-shiftid.

*        Calculated activities time
        CALL METHOD me->calc_minutes
          EXPORTING
            date       = ls_afru_sf016-isbd
            time       = ls_afru_sf016-isbz
            proc_date  = ls_zabsf_pp016-iebd
            proc_time  = ls_zabsf_pp016-iebz
          CHANGING
            activity   = l_activity
            return_tab = return_tab.

*        Check if exist erro in calcutation
        READ TABLE return_tab INTO ls_return_tab WITH KEY type = 'E'.
        IF sy-subrc = 0.
          EXIT.
        ENDIF.

*        Add time to internal table
        ls_zabsf_pp016-stoptime = l_activity.
*          ls_ZABSF_PP016-stopunit = ls_afvv-vge01.
        ls_zabsf_pp016-stopunit = c_min.

*        Confirmation counter
        ls_zabsf_pp016-rmzhl = l_rmzhl.

*        Time to save
        IF ls_zabsf_pp016-conf_no NE '0000000000'.
          APPEND ls_zabsf_pp016 TO lt_zabsf_pp016.
        ENDIF.

*        Create new counter
        ADD 1 TO l_rmzhl.

        CLEAR ls_timeticket.

*        Move initial data
        MOVE-CORRESPONDING ls_timeticket_ini TO ls_timeticket.

        ls_timeticket-exec_start_date = ls_afru_sf016-isbd.
        ls_timeticket-exec_start_time = ls_afru_sf016-isbz.
        ls_timeticket-proc_start_date = ls_afru_sf016-isbd.
        ls_timeticket-proc_start_time = ls_afru_sf016-isbz.
        ls_timeticket-proc_fin_date = ls_zabsf_pp016-iebd.
        ls_timeticket-proc_fin_time = ls_zabsf_pp016-iebz.
        ls_timeticket-break_unit = c_min.
        ls_timeticket-break_time = l_activity.
        ls_timeticket-kaptprog = ls_afru_sf016-shiftid.
        ls_timeticket-conf_text = lv_workstation_var.

*        Times to confirm
        APPEND ls_timeticket TO lt_timeticket.

*        Confirmation to create break
        DESCRIBE TABLE lt_timeticket LINES l_conf_break.
      ENDIF.

      CLEAR: ls_zabsf_pp016.

*      Move initial data
      MOVE-CORRESPONDING ls_pp_sf016_ini TO ls_zabsf_pp016.

*      Fill data to start production
      ls_zabsf_pp016-isbd = date.
      ls_zabsf_pp016-isbz = l_time.

*      Confirmation counter
      ls_zabsf_pp016-rmzhl = l_rmzhl.

*      Time to save
      APPEND ls_zabsf_pp016 TO lt_zabsf_pp016.

      CLEAR: ls_timeticket,
             l_conf_create.

*      Move initial data
      MOVE-CORRESPONDING ls_timeticket_ini TO ls_timeticket.

*      Fill Confirmed date for Start Production
      ls_timeticket-exec_start_date = date.
      ls_timeticket-exec_start_time = l_time.
      ls_timeticket-proc_start_date = date.
      ls_timeticket-proc_start_time = l_time.
      ls_timeticket-conf_text = lv_workstation_var.
*      Times to confirm
      APPEND ls_timeticket TO lt_timeticket.

*      To create card number
      l_card_create = abap_true.

*      Confirmation to create card
      DESCRIBE TABLE lt_timeticket LINES l_conf_create.
    WHEN stop_pro. " Stop Production\Preparation
*      Check Confirmed date for 'start of execution' is initial
      IF ls_afru_sf016-ierd IS INITIAL AND ls_afru_sf016-isdd IS NOT INITIAL.
        CLEAR ls_zabsf_pp016.

*        Move initial data
        MOVE-CORRESPONDING ls_pp_sf016_ini TO ls_zabsf_pp016.

        ls_zabsf_pp016-ierd = date.
        ls_zabsf_pp016-ierz = l_time.
        ls_zabsf_pp016-shiftid = ls_afru_sf016-shiftid.

*        Calculated activities time
        CALL METHOD me->calc_minutes
          EXPORTING
            date       = ls_afru_sf016-isdd
            time       = ls_afru_sf016-isdz
            proc_date  = ls_zabsf_pp016-ierd
            proc_time  = ls_zabsf_pp016-ierz
          CHANGING
            activity   = l_activity
            return_tab = return_tab.

*        Check if exist erro in calcutation
        READ TABLE return_tab INTO ls_return_tab WITH KEY type = 'E'.
        IF sy-subrc = 0.
          EXIT.
        ENDIF.

        CLEAR ls_timeticket.

*        Move initial data
        MOVE-CORRESPONDING ls_timeticket_ini TO ls_timeticket.

*        Get activities types
        CALL METHOD me->get_act_to_conf
          EXPORTING
            aufpl       = aufpl
            aplzl       = aplzl
            actv_value  = l_activity
            afvv        = ls_afvv
            nr_operator = l_nr_operator_calc
          IMPORTING
            ile01       = l_ile01
            ism01       = l_ism01
            ile02       = l_ile02
            ism02       = l_ism02
            ile03       = l_ile03
            ism03       = l_ism03
            ile04       = l_ile04
            ism04       = l_ism04
            ile05       = l_ile05
            ism05       = l_ism05
            ile06       = l_ile06
            ism06       = l_ism06
          CHANGING
            return_tab  = return_tab.

*        Fill values calculated
        ls_zabsf_pp016-ile01 = ls_timeticket-conf_acti_unit1 = l_ile01.
        ls_zabsf_pp016-ism01 = ls_timeticket-conf_activity1 = l_ism01.
        ls_zabsf_pp016-ile02 = ls_timeticket-conf_acti_unit2 = l_ile02.
        ls_zabsf_pp016-ism02 = ls_timeticket-conf_activity2 = l_ism02.
        ls_zabsf_pp016-ile03 = ls_timeticket-conf_acti_unit3 = l_ile03.
        ls_zabsf_pp016-ism03 = ls_timeticket-conf_activity3 = l_ism03. "* l_nr_operator.
        ls_zabsf_pp016-ile04 = ls_timeticket-conf_acti_unit4 = l_ile04.
        ls_zabsf_pp016-ism04 = ls_timeticket-conf_activity4 = l_ism04.
        ls_zabsf_pp016-ile05 = ls_timeticket-conf_acti_unit5 = l_ile05.
        ls_zabsf_pp016-ism05 = ls_timeticket-conf_activity5 = l_ism05.
        ls_zabsf_pp016-ile06 = ls_timeticket-conf_acti_unit6 = l_ile06.
        ls_zabsf_pp016-ism06 = ls_timeticket-conf_activity6 = l_ism06.

*        Confirmation counter
        ls_zabsf_pp016-rmzhl = l_rmzhl.

*        Time to save
        APPEND ls_zabsf_pp016 TO lt_zabsf_pp016.

*          CLEAR ls_timeticket.
*
**        Move initial data
*          MOVE-CORRESPONDING ls_timeticket_ini TO ls_timeticket.

*        Fill Confirmed date for End of Execution
        ls_timeticket-exec_start_date = date.
        ls_timeticket-exec_start_time = l_time.
        ls_timeticket-setup_fin_date = date.
        ls_timeticket-setup_fin_time = l_time.
        ls_timeticket-kaptprog = ls_afru_sf016-shiftid.
        ls_timeticket-conf_text = lv_workstation_var.

*        Times to confirm
        IF ls_timeticket-conf_no NE '0000000000'.
          APPEND ls_timeticket TO lt_timeticket.
        ENDIF.

*        Create new counter
        ADD 1 TO l_rmzhl.

        CLEAR ls_zabsf_pp016.

*        Move initial data
        MOVE-CORRESPONDING ls_pp_sf016_ini TO ls_zabsf_pp016.

*        Fill data to stop reason
        ls_zabsf_pp016-stprsnid = stprsnid.
        ls_zabsf_pp016-isbd = date.
        ls_zabsf_pp016-isbz = l_time.

        IF ls_zabsf_pp016-shiftid IS INITIAL.
*          Get shift witch operator is associated
          SELECT SINGLE shiftid
            FROM zabsf_pp052
            INTO (@DATA(l_shiftid_alt))
           WHERE areaid EQ @inputobj-areaid
             AND oprid  EQ @inputobj-oprid.

          ls_zabsf_pp016-shiftid = l_shiftid_alt.
        ENDIF.

*        Confirmation counter
        ls_zabsf_pp016-rmzhl = l_rmzhl.

*        Time to save
        IF ls_zabsf_pp016-conf_no NE '0000000000'.
          APPEND ls_zabsf_pp016 TO lt_zabsf_pp016.
        ENDIF.

*        Create new counter
        ADD 1 TO l_rmzhl.
      ENDIF.

*      Check Confirmed date for 'Processing Finish' is inital
      IF ls_afru_sf016-iebd IS INITIAL AND ls_afru_sf016-isbd IS NOT INITIAL.
        CLEAR: ls_zabsf_pp016,
               ls_timeticket.

*        Move initial data
        MOVE-CORRESPONDING ls_pp_sf016_ini TO ls_zabsf_pp016.

        ls_zabsf_pp016-iebd = date.
        ls_zabsf_pp016-iebz = l_time.
        ls_zabsf_pp016-shiftid = ls_afru_sf016-shiftid.

*        Calculated activities time
        CALL METHOD me->calc_minutes
          EXPORTING
            date       = ls_afru_sf016-isbd
            time       = ls_afru_sf016-isbz
            proc_date  = ls_zabsf_pp016-iebd
            proc_time  = ls_zabsf_pp016-iebz
          CHANGING
            activity   = l_activity
            return_tab = return_tab.

*        Check if exist erro in calcutation
        READ TABLE return_tab INTO ls_return_tab WITH KEY type = 'E'.
        IF sy-subrc = 0.
          EXIT.
        ENDIF.

        CLEAR: ls_timeticket.

*        Move initial data
        MOVE-CORRESPONDING ls_timeticket_ini TO ls_timeticket.

*        Get activities types
        CALL METHOD me->get_act_to_conf
          EXPORTING
            aufpl       = aufpl
            aplzl       = aplzl
            actv_value  = l_activity
            afvv        = ls_afvv
            nr_operator = l_nr_operator_calc
          IMPORTING
            ile01       = l_ile01
            ism01       = l_ism01
            ile02       = l_ile02
            ism02       = l_ism02
            ile03       = l_ile03
            ism03       = l_ism03
            ile04       = l_ile04
            ism04       = l_ism04
            ile05       = l_ile05
            ism05       = l_ism05
            ile06       = l_ile06
            ism06       = l_ism06
          CHANGING
            return_tab  = return_tab.

*        Fill values calculated
        ls_zabsf_pp016-ile01 = ls_timeticket-conf_acti_unit1 = l_ile01.
        ls_zabsf_pp016-ism01 = ls_timeticket-conf_activity1 = l_ism01.
        ls_zabsf_pp016-ile02 = ls_timeticket-conf_acti_unit2 = l_ile02.
        ls_zabsf_pp016-ism02 = ls_timeticket-conf_activity2 = l_ism02.
        ls_zabsf_pp016-ile03 = ls_timeticket-conf_acti_unit3 = l_ile03.
        ls_zabsf_pp016-ism03 = ls_timeticket-conf_activity3 = l_ism03. "* l_nr_operator.
        ls_zabsf_pp016-ile04 = ls_timeticket-conf_acti_unit4 = l_ile04.
        ls_zabsf_pp016-ism04 = ls_timeticket-conf_activity4 = l_ism04.
        ls_zabsf_pp016-ile05 = ls_timeticket-conf_acti_unit5 = l_ile05.
        ls_zabsf_pp016-ism05 = ls_timeticket-conf_activity5 = l_ism05.
        ls_zabsf_pp016-ile06 = ls_timeticket-conf_acti_unit6 = l_ile06.
        ls_zabsf_pp016-ism06 = ls_timeticket-conf_activity6 = l_ism06.
*        ls_zabsf_pp016-stoptime = l_activity.

*        Confirmation counter
        ls_zabsf_pp016-rmzhl = l_rmzhl.

*        Time to save
        APPEND ls_zabsf_pp016 TO lt_zabsf_pp016.

**        Move initial data
*          MOVE-CORRESPONDING ls_timeticket_ini TO ls_timeticket.

*        Fill Confirmed date for End Production
        ls_timeticket-exec_start_date = date.
        ls_timeticket-exec_start_time = l_time.
        ls_timeticket-proc_fin_date = date.
        ls_timeticket-proc_fin_time = l_time.
        ls_timeticket-kaptprog = ls_afru_sf016-shiftid.
        ls_timeticket-conf_text = lv_workstation_var.
*        Times to confirm
        IF ls_timeticket-conf_no NE '0000000000'.
          APPEND ls_timeticket TO lt_timeticket.
        ENDIF.

*        Create new counter
        ADD 1 TO l_rmzhl.

        CLEAR ls_zabsf_pp016.

*        Move initial data
        MOVE-CORRESPONDING ls_pp_sf016_ini TO ls_zabsf_pp016.

*        Fill data to stop reason
        ls_zabsf_pp016-stprsnid = stprsnid.
        ls_zabsf_pp016-isbd = date.
        ls_zabsf_pp016-isbz = l_time.

*        Confirmation counter
        ls_zabsf_pp016-rmzhl = l_rmzhl.

*        Time to save
        IF ls_zabsf_pp016-conf_no NE '0000000000'.
          APPEND ls_zabsf_pp016 TO lt_zabsf_pp016.
        ENDIF.
      ENDIF.
    WHEN end_parc. " Fim parcial
*      Check if Start Preparation is initialized
      IF ls_afru_sf016-isdd IS NOT INITIAL.
        CLEAR ls_zabsf_pp016.

*        Move initial data
        MOVE-CORRESPONDING ls_pp_sf016_ini TO ls_zabsf_pp016.

        ls_zabsf_pp016-ierd = date.
        ls_zabsf_pp016-ierz = l_time.
        ls_zabsf_pp016-shiftid = ls_afru_sf016-shiftid.

*        Calculated activities time
        CALL METHOD me->calc_minutes
          EXPORTING
            date       = ls_afru_sf016-isdd
            time       = ls_afru_sf016-isdz
            proc_date  = ls_zabsf_pp016-ierd
            proc_time  = ls_zabsf_pp016-ierz
          CHANGING
            activity   = l_activity
            return_tab = return_tab.

*        Check if exist erro in calcutation
        READ TABLE return_tab INTO ls_return_tab WITH KEY type = 'E'.
        IF sy-subrc = 0.
          EXIT.
        ENDIF.

*        Confirmation counter
        ls_zabsf_pp016-rmzhl = l_rmzhl.

        CLEAR ls_timeticket.

*        Move initial data
        MOVE-CORRESPONDING ls_timeticket_ini TO ls_timeticket.

*        Fill Confirmed date for End of Execution
        ls_timeticket-exec_start_date = date.
        ls_timeticket-exec_start_time = l_time.
        ls_timeticket-setup_fin_date = date.
        ls_timeticket-setup_fin_time = l_time.
        ls_timeticket-kaptprog = ls_afru_sf016-shiftid.
        ls_timeticket-conf_text = lv_workstation_var.

*      Check if Start Production is initialized
      ELSEIF ls_afru_sf016-isbd IS NOT INITIAL.
        CLEAR ls_zabsf_pp016.

*        Move initial data
        MOVE-CORRESPONDING ls_pp_sf016_ini TO ls_zabsf_pp016.

        ls_zabsf_pp016-iebd = date.
        ls_zabsf_pp016-iebz = l_time.
        ls_zabsf_pp016-shiftid = ls_afru_sf016-shiftid.

        CALL METHOD me->calc_minutes
          EXPORTING
            date       = ls_afru_sf016-isbd
            time       = ls_afru_sf016-isbz
            proc_date  = ls_zabsf_pp016-iebd
            proc_time  = ls_zabsf_pp016-iebz
          CHANGING
            activity   = l_activity
            return_tab = return_tab.

*        Check if exist erro in calcutation
        READ TABLE return_tab INTO ls_return_tab WITH KEY type = 'E'.
        IF sy-subrc = 0.
          EXIT.
        ENDIF.

*        Confirmation counter
        ls_zabsf_pp016-rmzhl = l_rmzhl.

        CLEAR ls_timeticket.

*        Move initial data
        MOVE-CORRESPONDING ls_timeticket_ini TO ls_timeticket.

*        Fill Confirmed date for End Production
        ls_timeticket-exec_start_date = date.
        ls_timeticket-exec_start_time = l_time.
        ls_timeticket-proc_fin_date = date.
        ls_timeticket-proc_fin_time = l_time.
        ls_timeticket-kaptprog = ls_afru_sf016-shiftid.
        ls_timeticket-conf_text = lv_workstation_var.
      ENDIF.

*      Check stop reason is not inital
      IF ls_afru_sf016-stprsnid IS NOT INITIAL.
        CLEAR ls_zabsf_pp016.

*        Move initial data
        MOVE-CORRESPONDING ls_pp_sf016_ini TO ls_zabsf_pp016.

*        Shift ID
        ls_zabsf_pp016-shiftid = ls_afru_sf016-shiftid.
*        Cause ID
        ls_zabsf_pp016-stprsnid = ls_afru_sf016-stprsnid.

*        Add time to internal table
        ls_zabsf_pp016-stoptime = l_activity.
*          ls_ZABSF_PP016-stopunit = ls_afvv-vge01.
        ls_zabsf_pp016-stopunit = c_min.

*        Confirmation counter
        ls_zabsf_pp016-rmzhl = l_rmzhl.

        CLEAR ls_timeticket.

*        Move initial data
        MOVE-CORRESPONDING ls_timeticket_ini TO ls_timeticket.

        IF ls_zabsf_pp016-iebd IS INITIAL.
          ls_zabsf_pp016-iebd = date.
        ENDIF.

        IF ls_zabsf_pp016-iebz IS INITIAL.
          ls_zabsf_pp016-iebz = l_time.
        ENDIF.

        ls_timeticket-exec_start_date = ls_afru_sf016-isbd.
        ls_timeticket-exec_start_time = ls_afru_sf016-isbz.
        ls_timeticket-proc_start_date = ls_afru_sf016-isbd.
        ls_timeticket-proc_start_time = ls_afru_sf016-isbz.
        ls_timeticket-proc_fin_date = ls_zabsf_pp016-iebd.
        ls_timeticket-proc_fin_time = ls_zabsf_pp016-iebz.
        ls_timeticket-break_unit = c_min.
        ls_timeticket-break_time = l_activity.
        ls_timeticket-kaptprog = ls_afru_sf016-shiftid.
        ls_timeticket-conf_text = lv_workstation_var.

*        Times to confirm
        IF ls_timeticket-conf_no NE '0000000000'.
          APPEND ls_timeticket TO lt_timeticket.
        ENDIF.

*        Confirmation to create break
        DESCRIBE TABLE lt_timeticket LINES l_conf_break.

      ELSE.
*        Get activities types
        CALL METHOD me->get_act_to_conf
          EXPORTING
            aufpl       = aufpl
            aplzl       = aplzl
            actv_value  = l_activity
            afvv        = ls_afvv
            nr_operator = l_nr_operator_calc
          IMPORTING
            ile01       = l_ile01
            ism01       = l_ism01
            ile02       = l_ile02
            ism02       = l_ism02
            ile03       = l_ile03
            ism03       = l_ism03
            ile04       = l_ile04
            ism04       = l_ism04
            ile05       = l_ile05
            ism05       = l_ism05
            ile06       = l_ile06
            ism06       = l_ism06
          CHANGING
            return_tab  = return_tab.

*        Fill values calculated
        ls_zabsf_pp016-ile01 = ls_timeticket-conf_acti_unit1 = l_ile01.
        ls_zabsf_pp016-ism01 = ls_timeticket-conf_activity1 = l_ism01.
        ls_zabsf_pp016-ile02 = ls_timeticket-conf_acti_unit2 = l_ile02.
        ls_zabsf_pp016-ism02 = ls_timeticket-conf_activity2 = l_ism02.
        ls_zabsf_pp016-ile03 = ls_timeticket-conf_acti_unit3 = l_ile03.
        ls_zabsf_pp016-ism03 = ls_timeticket-conf_activity3 = l_ism03. "* l_nr_operator.
        ls_zabsf_pp016-ile04 = ls_timeticket-conf_acti_unit4 = l_ile04.
        ls_zabsf_pp016-ism04 = ls_timeticket-conf_activity4 = l_ism04.
        ls_zabsf_pp016-ile05 = ls_timeticket-conf_acti_unit5 = l_ile05.
        ls_zabsf_pp016-ism05 = ls_timeticket-conf_activity5 = l_ism05.
        ls_zabsf_pp016-ile06 = ls_timeticket-conf_acti_unit6 = l_ile06.
        ls_zabsf_pp016-ism06 = ls_timeticket-conf_activity6 = l_ism06.

*        Confirmation counter
        ls_zabsf_pp016-rmzhl = l_rmzhl.

*        Times to confirm
        IF ls_timeticket-conf_no NE '0000000000'.
          APPEND ls_timeticket TO lt_timeticket.
        ENDIF.
      ENDIF.

*      Time to save
      IF ls_zabsf_pp016-conf_no NE '0000000000'.
        APPEND ls_zabsf_pp016 TO lt_zabsf_pp016.
      ENDIF.

*      Clear card active
      DATA(l_clear_card) = abap_true.

*      Confirmation to create card
      DESCRIBE TABLE lt_timeticket LINES l_conf_create.
    WHEN end_prod. "End Production
      CLEAR ls_zabsf_pp016.

*     Move initial data
      MOVE-CORRESPONDING ls_pp_sf016_ini TO ls_zabsf_pp016.

*     Fill data to finish production
      ls_zabsf_pp016-iebd = date.
      ls_zabsf_pp016-iebz = l_time.
      ls_zabsf_pp016-fin_conf = 'X'.
      ls_zabsf_pp016-shiftid = ls_afru_sf016-shiftid.

      IF ls_afru_sf016-isbd IS NOT INITIAL AND ls_afru_sf016-isbz IS NOT INITIAL.
*       Calculated activities time
        CALL METHOD me->calc_minutes
          EXPORTING
            date       = ls_afru_sf016-isbd
            time       = ls_afru_sf016-isbz
            proc_date  = ls_zabsf_pp016-iebd
            proc_time  = ls_zabsf_pp016-iebz
          CHANGING
            activity   = l_activity
            return_tab = return_tab.

*        Check if exist erro in calcutation
        READ TABLE return_tab INTO ls_return_tab WITH KEY type = 'E'.
        IF sy-subrc = 0.
          EXIT.
        ENDIF.

*        Get activities types
        CALL METHOD me->get_act_to_conf
          EXPORTING
            aufpl       = aufpl
            aplzl       = aplzl
            actv_value  = l_activity
            afvv        = ls_afvv
            nr_operator = l_nr_operator_calc
          IMPORTING
            ile01       = l_ile01
            ism01       = l_ism01
            ile02       = l_ile02
            ism02       = l_ism02
            ile03       = l_ile03
            ism03       = l_ism03
            ile04       = l_ile04
            ism04       = l_ism04
            ile05       = l_ile05
            ism05       = l_ism05
            ile06       = l_ile06
            ism06       = l_ism06
          CHANGING
            return_tab  = return_tab.

*        Fill values calculated
        ls_zabsf_pp016-ile01 = ls_timeticket-conf_acti_unit1 = l_ile01.
        ls_zabsf_pp016-ism01 = ls_timeticket-conf_activity1 = l_ism01.
        ls_zabsf_pp016-ile02 = ls_timeticket-conf_acti_unit2 = l_ile02.
        ls_zabsf_pp016-ism02 = ls_timeticket-conf_activity2 = l_ism02.
        ls_zabsf_pp016-ile03 = ls_timeticket-conf_acti_unit3 = l_ile03.
        ls_zabsf_pp016-ism03 = ls_timeticket-conf_activity3 = l_ism03. "* l_nr_operator.
        ls_zabsf_pp016-ile04 = ls_timeticket-conf_acti_unit4 = l_ile04.
        ls_zabsf_pp016-ism04 = ls_timeticket-conf_activity4 = l_ism04.
        ls_zabsf_pp016-ile05 = ls_timeticket-conf_acti_unit5 = l_ile05.
        ls_zabsf_pp016-ism05 = ls_timeticket-conf_activity5 = l_ism05.
        ls_zabsf_pp016-ile06 = ls_timeticket-conf_acti_unit6 = l_ile06.
        ls_zabsf_pp016-ism06 = ls_timeticket-conf_activity6 = l_ism06.
      ENDIF.

*      Confirmation counter
      ls_zabsf_pp016-rmzhl = l_rmzhl.

*      Time to save
      APPEND ls_zabsf_pp016 TO lt_zabsf_pp016.

      CLEAR ls_timeticket.

*      Move initial data
      MOVE-CORRESPONDING ls_timeticket_ini TO ls_timeticket.

*      Fill data to finish production
*      ls_timeticket-proc_fin_date = date.
*      ls_timeticket-proc_fin_time = l_time.
      ls_timeticket-fin_conf = 'X'.
      ls_timeticket-kaptprog = ls_afru_sf016-shiftid.
      ls_timeticket-conf_text = lv_workstation_var.

*     Times to confirm
      APPEND ls_timeticket TO lt_timeticket.

  ENDCASE.


  IF lt_timeticket[] IS NOT INITIAL.

" No inicio de produção não fazer movimentação de quantidades - nãoi fazer confirmações de quantidades a 0.
" Fazer confirmação de quantidade quando o status igual a "END_PROD" - fecho final
    IF actv_id EQ end_prod.
*    Create confirmation
      CALL FUNCTION 'BAPI_PRODORDCONF_CREATE_TT'
        EXPORTING
          post_wrong_entries = c_post_wrong_entries
        IMPORTING
          return             = ls_return
        TABLES
          timetickets        = lt_timeticket
          detail_return      = lt_detail_return.

      IF ls_return IS INITIAL.
**      Commit to save records
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = 'X'.
      ENDIF.
    ENDIF.

    IF lt_zabsf_pp016[] IS NOT INITIAL.
**    Insert new lines
      INSERT zabsf_pp016 FROM TABLE lt_zabsf_pp016.
    ENDIF.

**    Save status of operation in database
    CALL METHOD lref_sf_status->status_object
      EXPORTING
        arbpl      = arbpl
        aufnr      = aufnr
        vornr      = vornr
        objty      = 'OV'
        method     = 'S'
        actionid   = actionid
        stprsnid   = stprsnid
      CHANGING
        return_tab = return_tab.
*  ENDIF.

    LOOP AT lt_detail_return INTO ls_detail_return.
      CLEAR ls_return.

      ls_return-type = ls_detail_return-type.
      ls_return-id = ls_detail_return-id.
      ls_return-number = ls_detail_return-number.
      ls_return-message = ls_detail_return-message.
      ls_return-message_v1 = ls_detail_return-message_v1.
      ls_return-message_v2 = ls_detail_return-message_v2.
      ls_return-message_v3 = ls_detail_return-message_v3.
      ls_return-message_v4 = ls_detail_return-message_v4.

      APPEND ls_return TO return_tab.

      IF ls_detail_return-type EQ 'I' OR ls_detail_return-type EQ 'S'.
        IF ls_detail_return-conf_no IS NOT INITIAL AND ls_detail_return-conf_cnt IS NOT INITIAL.
          CLEAR ls_conf_data.

*          Work center
          ls_conf_data-arbpl = arbpl.
*          Production order
          ls_conf_data-aufnr = aufnr.
*          Production order operation
          ls_conf_data-vornr = vornr.
*          Confirmation number
          ls_conf_data-conf_no = ls_detail_return-conf_no.
*          Confirmation counter
          ls_conf_data-conf_cnt = ls_detail_return-conf_cnt.
*          Schedule
          ls_conf_data-schedule_id = schedule_id.
*          Regime
          ls_conf_data-regime_id = regime_id.
*          Initial counter
          ls_conf_data-count_ini = count_ini.
*          Final counter
          IF count_fin IS NOT INITIAL.
            ls_conf_data-count_fin = count_fin.
          ENDIF.

          IF l_card_create IS NOT INITIAL AND l_conf_create EQ ls_detail_return-row.
*            Create number card
            CONCATENATE ls_detail_return-conf_no ls_detail_return-conf_cnt INTO ls_conf_data-ficha.

            CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
              EXPORTING
                input  = ls_conf_data-ficha
              IMPORTING
                output = ls_conf_data-ficha.

*            Check if exist record save in table ZABSF_PP066 - Card
            SELECT SINGLE *
              FROM zabsf_pp066
              INTO @DATA(ls_batch_manag)
             WHERE werks EQ @inputobj-werks
               AND aufnr EQ @aufnr
               AND vornr EQ @vornr.

            IF sy-subrc EQ 0.
*              Update exist record in table with card created
*                update zabsf_pp066 from @( value #( base ls_batch_manag ficha = ls_conf_data-ficha ) ).
              ls_batch_manag-ficha = ls_conf_data-ficha.
              UPDATE zabsf_pp066 FROM ls_batch_manag.

              COMMIT WORK AND WAIT.
            ELSE.
*              Insert new record with card active for production order
*                insert zabsf_pp066 from table @( value #( ( werks = inputobj-werks
*                                                             aufnr = aufnr
*                                                             vornr = vornr
*                                                             ficha = ls_conf_data-ficha ) ) ).
              ls_zabsf_pp066-werks = inputobj-werks.
              ls_zabsf_pp066-aufnr = aufnr.
              ls_zabsf_pp066-vornr = vornr.
              ls_zabsf_pp066-ficha = ls_conf_data-ficha.
              INSERT INTO zabsf_pp066 VALUES ls_zabsf_pp066.

              COMMIT WORK AND WAIT.
            ENDIF.
          ELSE.
*            Get card active
            SELECT SINGLE ficha
              FROM zabsf_pp066
              INTO @ls_conf_data-ficha
             WHERE werks EQ @inputobj-werks
               AND aufnr EQ @aufnr
               AND vornr EQ @vornr.
          ENDIF.

*          Update with confirmation number
          LOOP AT lt_zabsf_pp016 INTO DATA(ls_pp_sf016) WHERE stprsnid IS INITIAL.
*            Update exist record in table with card created
*              update zabsf_pp016 from @( value #( base ls_pp_sf016 conf_no = ls_detail_return-conf_no
*                                                                    conf_cnt = ls_detail_return-conf_cnt ) ).
            ls_pp_sf016-conf_no = ls_detail_return-conf_no.
            ls_pp_sf016-conf_cnt = ls_detail_return-conf_cnt.
            ls_pp_sf016-equipment = iv_equipment.
            UPDATE zabsf_pp016 FROM ls_pp_sf016.

            IF sy-subrc EQ 0.
              COMMIT WORK AND WAIT.
            ENDIF.
          ENDLOOP.

*          Cause ID
          IF l_conf_break IS NOT INITIAL AND l_conf_break EQ ls_detail_return-row.
            ls_conf_data-stprsnid = ls_afru_sf016-stprsnid.

*            Update exist record in table with card created
*              update zabsf_pp016 from @( value #( base ls_afru_sf016 conf_no = ls_detail_return-conf_no
*                                                                      conf_cnt = ls_detail_return-conf_cnt ) ).
            ls_afru_sf016-conf_no = ls_detail_return-conf_no.
            ls_afru_sf016-conf_cnt = ls_detail_return-conf_cnt.
*            ls_pp_sf016-equipment = iv_equipment.
            UPDATE zabsf_pp016 FROM ls_afru_sf016.
            IF sy-subrc EQ 0.
              COMMIT WORK AND WAIT.
            ENDIF.

            CLEAR ls_pp_sf016.

*            Update with confirmation number
            LOOP AT lt_zabsf_pp016 INTO ls_pp_sf016 WHERE stprsnid IS NOT INITIAL.
*              Update exist record in table with card created
*                update zabsf_pp016 from @( value #( base ls_pp_sf016 conf_no = ls_detail_return-conf_no
*                                                                      conf_cnt = ls_detail_return-conf_cnt ) ).
              ls_pp_sf016-conf_no = ls_detail_return-conf_no.
              ls_pp_sf016-conf_cnt = ls_detail_return-conf_cnt.
*              ls_pp_sf016-equipment = iv_equipment.
              UPDATE zabsf_pp016 FROM ls_pp_sf016.

              IF sy-subrc EQ 0.
                COMMIT WORK AND WAIT.
              ENDIF.
            ENDLOOP.
          ENDIF.

*          Get shift ID
          READ TABLE lt_timeticket INTO ls_timeticket INDEX ls_detail_return-row.

          IF sy-subrc EQ 0.
*            Shift ID
            ls_conf_data-shiftid = ls_timeticket-kaptprog.
          ENDIF.


          IF lref_sf_prdord IS NOT BOUND.
*            Create object
            CREATE OBJECT lref_sf_prdord
              EXPORTING
                initial_refdt = refdt
                input_object  = inputobj.

          ENDIF.

*          Save aditional data of confirmation
          CALL METHOD lref_sf_prdord->save_data_confirmation
            EXPORTING
              is_conf_data = ls_conf_data
            CHANGING
              return_tab   = return_tab.

          IF l_clear_card IS NOT INITIAL AND l_conf_create EQ ls_detail_return-row.
            CLEAR ls_batch_manag.

*            Check if exist record save in table ZABSF_PP066 - Card
            SELECT SINGLE *
              FROM zabsf_pp066
              INTO @ls_batch_manag
             WHERE werks EQ @inputobj-werks
               AND aufnr EQ @aufnr
               AND vornr EQ @vornr.

            IF sy-subrc EQ 0.
*              Clear card active
*                update zabsf_pp066 from @( value #( base ls_batch_manag ficha = space ) ).
              ls_batch_manag-ficha = space.
              UPDATE zabsf_pp066 FROM ls_batch_manag.

              COMMIT WORK AND WAIT.
            ENDIF.
          ENDIF.

          IF actv_id EQ end_parc.
*            Get first operator assigned to Production Order
            SELECT oprid, udate, utime
              FROM zabsf_pp014
              INTO TABLE @DATA(lt_pp_sf014)
             WHERE arbpl  EQ @arbpl
               AND aufnr  EQ @aufnr
               AND vornr  EQ @vornr
               AND status EQ 'A'
               AND tipord EQ 'N'.

            SORT lt_pp_sf014 BY udate DESCENDING utime DESCENDING.

            IF no_clear_operators_from_order EQ abap_false.

              LOOP AT lt_pp_sf014 INTO DATA(ls_pp_sf014).
                REFRESH: lt_operator_tab,
                         lt_return_tab.

                CLEAR ls_operator_tab.

                ls_operator_tab-oprid = ls_pp_sf014-oprid.
                ls_operator_tab-status = 'I'.

                APPEND ls_operator_tab TO lt_operator_tab.

*              Get operators
                CALL FUNCTION 'ZABSF_PP_SETOPERATORS'
                  EXPORTING
                    arbpl        = arbpl
                    aufnr        = aufnr
                    vornr        = vornr
                    operator_tab = lt_operator_tab
                    inputobj     = inputobj
                  IMPORTING
                    return_tab   = lt_return_tab.
              ENDLOOP.
            ENDIF.
          ENDIF.
        ENDIF.
      ELSE.
        CALL METHOD zabsf_pp_cl_log=>add_message
          EXPORTING
            msgty      = 'E'
            msgno      = '012'
          CHANGING
            return_tab = return_tab.

        EXIT.
      ENDIF.
    ENDLOOP.
  ELSE.
    IF lt_zabsf_pp016[] IS NOT INITIAL.
      INSERT zabsf_pp016 FROM TABLE lt_zabsf_pp016.

      IF sy-subrc EQ 0.
*        Save status of operation in database
        CALL METHOD lref_sf_status->status_object
          EXPORTING
            arbpl      = arbpl
            aufnr      = aufnr
            vornr      = vornr
            objty      = 'OV'
            method     = 'S'
            actionid   = actionid
          CHANGING
            return_tab = return_tab.

*        Insert data successfully
        CALL METHOD zabsf_pp_cl_log=>add_message
          EXPORTING
            msgty      = 'S'
            msgno      = '013'
          CHANGING
            return_tab = return_tab.
      ELSE.
        CALL METHOD zabsf_pp_cl_log=>add_message
          EXPORTING
            msgty      = 'E'
            msgno      = '012'
          CHANGING
            return_tab = return_tab.

        EXIT.
      ENDIF.
    ENDIF.
  ENDIF.

  CLEAR: ls_zabsf_pp021,
         l_count.

*  Check if all operation had status different of STOP_PROD
  SELECT SINGLE status_next
    FROM zabsf_pp022
    INTO (@DATA(l_status_next))
   WHERE objty       EQ 'OV'
     AND status_last EQ @space
     AND status_next NE @space.

  REFRESH lt_reg_oper.

*  Get status of operation
  SELECT *
    FROM zabsf_pp021
    INTO TABLE @DATA(lt_zabsf_pp021)
   WHERE arbpl       EQ @arbpl
     AND status_oper NE @l_status_next
     AND status_oper NE 'CONC'
     AND status_oper NE 'AGU'.

  lt_reg_oper[] = lt_zabsf_pp021[].

  LOOP AT lt_reg_oper ASSIGNING FIELD-SYMBOL(<fs_sf021>).
*    Get object of operation
    SELECT SINGLE afvc~objnr
      INTO @DATA(l_objnr)
      FROM afvc AS afvc
     INNER JOIN afko AS afko
        ON afko~aufpl EQ afvc~aufpl
     WHERE afko~aufnr EQ @<fs_sf021>-aufnr
       AND afvc~vornr EQ @<fs_sf021>-vornr.

    IF l_objnr IS NOT INITIAL.
*      Check status
      SELECT *
        FROM jest
        INTO TABLE @DATA(lt_jest)
       WHERE objnr EQ @l_objnr
         AND ( stat  EQ 'I0045'  "ENTE
            OR stat  EQ 'I0009' )"CONF
         AND inact EQ @space.

      IF lt_jest[] IS NOT INITIAL.
*        Update status of operation
        UPDATE zabsf_pp021 SET status_oper = 'CONC'
                          WHERE arbpl EQ @arbpl
                            AND aufnr EQ @<fs_sf021>-aufnr
                            AND vornr EQ @<fs_sf021>-vornr.

*        Remove line updated
        IF sy-subrc EQ 0.
          DELETE lt_zabsf_pp021 WHERE arbpl EQ arbpl
                                   AND aufnr EQ <fs_sf021>-aufnr
                                   AND vornr EQ <fs_sf021>-vornr.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDLOOP.

*  Get total lines
  DESCRIBE TABLE lt_zabsf_pp021 LINES DATA(l_lines).

  LOOP AT lt_zabsf_pp021 INTO ls_zabsf_pp021.
*    Get total operation stop
    IF ls_zabsf_pp021-status_oper EQ c_status_stop .
      ADD 1 TO l_count.
    ENDIF.
  ENDLOOP.

*  Get current status of Workcenter
  CALL METHOD lref_sf_status->status_object
    EXPORTING
      arbpl       = arbpl
      werks       = inputobj-werks
      objty       = 'CA'
      method      = 'G'
    CHANGING
      status_out  = l_status_out
      status_desc = l_status_desc
      stsma_out   = l_stsma_out
      return_tab  = return_tab.

  CLEAR l_status_next.

*  Get next status
  SELECT SINGLE status_next
    FROM zabsf_pp022
    INTO @l_status_next
   WHERE objty       EQ 'CA'
     AND status_last EQ @l_status_out
     AND stsma       EQ @l_stsma_out
     AND actionid    EQ @actionid.

  "BMR COMMENT 23.07.2020 - não realizar alterações de status no CT

*  Check if all operation had different status and change status of work center
*    if l_lines eq l_count and actionid ne 'CONC'.
*
**    Set status for Stop
*      call method lref_sf_status->status_object
*        exporting
*          arbpl      = arbpl
*          werks      = inputobj-werks
*          objty      = 'CA'
*          status     = l_status_next
*          stsma      = l_stsma_out
*          method     = 'S'
*          actionid   = actionid
*        changing
*          return_tab = return_tab.
*
*      if l_status_next = '0003'. "STOP(Parado)
**      Check if exist stop record saved
*        select single *
*          from zabsf_pp010
*          into @data(ls_zabsf_pp010)
*         where areaid   eq @inputobj-areaid
*           and hname    eq @l_hname
*           and werks    eq @inputobj-werks
*           and arbpl    eq @arbpl
*           and timeend  eq '000000'.
*
*        if sy-subrc ne 0.
**        Create record for stop
*          insert zabsf_pp010 from table @( value #( ( areaid = inputobj-areaid
*                                                       hname = l_hname
*                                                       werks = inputobj-werks
*                                                       arbpl = arbpl
*                                                       datesr = date
*                                                       time = l_time
*                                                       operador = inputobj-oprid
*                                                       shiftid = l_shiftid
*                                                       stprsnid = 'P.OP'
*                                                       stopunit = c_min ) ) ).
*
*          if sy-subrc eq 0.
*            commit work and wait.
*          endif.
*        endif.
*      elseif l_status_next = '0002'. "Ativo
*
*        clear ls_zabsf_pp010.
*
**      Get record of stop work center
*        select single *
*          from zabsf_pp010
*          into @ls_zabsf_pp010
*         where areaid  eq @inputobj-areaid
*           and hname   eq @l_hname
*           and werks   eq @inputobj-werks
*           and arbpl   eq @arbpl
*           and timeend eq '000000'.
*
*        if sy-subrc eq 0.
**        Close stop records
*          l_time_calc = l_time.
*          l_date_calc = date.
*
*          call method me->calc_minutes
*            exporting
*              date       = ls_zabsf_pp010-datesr
*              time       = ls_zabsf_pp010-time
*              proc_date  = l_date_calc
*              proc_time  = l_time_calc
*            changing
*              activity   = l_activity
*              return_tab = return_tab.
*
**        Update end time of stop Work center
*          update zabsf_pp010 from @( value #( base ls_zabsf_pp010 endda    = l_date_calc
*                                                                    timeend  = l_time_calc
*                                                                    stoptime = l_activity
*                                                                    stopunit = c_min ) ).
*
*          if sy-subrc eq 0.
*            commit work and wait.
*          endif.
*        endif.
*      endif.
*    elseif ( l_status_out eq '0001' or l_status_out eq '0003' or l_status_out eq '0004' ) and actionid ne 'CONC' .  "Initial, Parado, Reparação
**    Set status for Active
*
*      if l_status_out eq '0003' or l_status_out eq '0004'.
*
*        clear ls_zabsf_pp010.
*
**      Get record of stop work center
*        select single *
*          from zabsf_pp010
*          into @ls_zabsf_pp010
*         where areaid   eq @inputobj-areaid
*           and hname    eq @l_hname
*           and werks    eq @inputobj-werks
*           and arbpl    eq @arbpl
*           and timeend  eq '000000'.
*
*        if sy-subrc eq 0.
*          l_time_calc = l_time.
*
*          call method me->calc_minutes
*            exporting
*              date       = ls_zabsf_pp010-datesr "date
*              time       = ls_zabsf_pp010-time   "ld_time
*              proc_date  = date                   "ls_ZABSF_PP010-datesr
*              proc_time  = l_time_calc            "ls_ZABSF_PP010-time
*            changing
*              activity   = l_activity
*              return_tab = return_tab.
*
**        Update end time of stop Work center
*          update zabsf_pp010 from @( value #( base ls_zabsf_pp010 endda    = date
*                                                                    timeend  = l_time_calc
*                                                                    stoptime = l_activity
*                                                                    stopunit = c_min ) ).
*          if sy-subrc eq 0.
*            commit work and wait.
*          endif.
*        endif.
*      endif.
*    endif.
ENDMETHOD.


METHOD ZIF_ABSF_PP_EVENT_ACT~SET_REFDT.
*Set new reference date
  refdt = new_refdt.
ENDMETHOD.
ENDCLASS.
