class ZABSF_PP_CL_OPTION_REG definition
  public
  final
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !INITIAL_REFDT type VVDATUM
      !INPUT_OBJECT type ZABSF_PP_S_INPUTOBJECT .
  methods SET_REFDT
    importing
      !NEW_REFDT type VVDATUM .
  methods GET_OPTION_REG
    importing
      !ARBPL type ARBPL
      !WERKS type WERKS_D
      !AUFNR type AUFNR
      !VORNR type VORNR
      !MATNR type MATNR
      !DATA_CHRONO type VVDATUM optional
      !CHRONO_REG type INT4 optional
      !DATA_MEASURE type VVDATUM optional
      !MEASURE_REG type INT4 optional
      !DATA_ALERT type VVDATUM optional
      !ALERT_REG type INT4 optional
    changing
      !LOWER_LIMIT type ZABSF_PP_E_LOWER_LIMIT
      !UPPER_LIMIT type ZABSF_PP_E_UPPER_LIMIT
      !MEASURE_OPT_TAB type ZABSF_PP_T_MEASURE_OPT
      !CHRONO_TAB type ZABSF_PP_T_CHRONOMETER
      !MEASURE_TAB type ZABSF_PP_T_MEASURE
      !ALERT_TAB type ZABSF_PP_T_ALERT
      !RETURN_TAB type BAPIRET2_T .
  methods SET_OPTION_REG
    importing
      !ARBPL type ARBPL
      !AUFNR type AUFNR
      !VORNR type VORNR
      !MATNR type MATNR
      !DATE type DATUM
      !TIME type ATIME
      !CRON_VALUE type ZABSF_PP_E_CRON_VALUE optional
      !MEASUREID_TAB type ZABSF_PP_T_MEASURE_ID optional
      !ALERT_DESC type ZABSF_PP_E_ALERT_DESC optional
      !ACTION_PLANE type ZABSF_PP_E_ACTION_PLANE optional
      !OLD_VALUE type ZABSF_PP_E_OLD_VALUE optional
      !ACTUAL_VALUE type ZABSF_PP_E_ACTUAL_VALUE optional
      !RESPONSABLE_USER type ZABSF_PP_E_RESP_USER optional
    changing
      !RETURN_TAB type BAPIRET2_T .
  methods GET_OPTION_TURN
    importing
      !TURNID type ZABSF_PP_E_TURNID
    changing
      !TURN_DETAIL_TAB type ZABSF_PP_T_TURN_DETAIL
      !RETURN_TAB type BAPIRET2_T .
  methods SET_OPTION_TURN
    importing
      !TURN_DETAIL_ST type ZABSF_PP_S_TURN_DETAIL
    changing
      !RETURN_TAB type BAPIRET2_T .
protected section.
private section.

  data REFDT type VVDATUM .
  data INPUTOBJ type ZABSF_PP_S_INPUTOBJECT .
ENDCLASS.



CLASS ZABSF_PP_CL_OPTION_REG IMPLEMENTATION.


METHOD CONSTRUCTOR.
*Ref. Date
  refdt    = initial_refdt.

*App input data
  inputobj = input_object.
ENDMETHOD.


METHOD get_option_reg.
  DATA: it_zabsf_pp028 TYPE TABLE OF zabsf_pp028,
        it_zabsf_pp030 TYPE TABLE OF zabsf_pp030,
        it_zabsf_pp031 TYPE TABLE OF zabsf_pp031.

  DATA: ls_zabsf_pp027 TYPE zabsf_pp027,
        wa_zabsf_pp028 TYPE zabsf_pp028,
        wa_zabsf_pp030 TYPE zabsf_pp030,
        wa_zabsf_pp031 TYPE zabsf_pp031,
        wa_measure_opt TYPE zabsf_pp_s_measure_opt,
        wa_chrono      TYPE zabsf_pp_s_chronometer,
        wa_measure     TYPE zabsf_pp_s_measure,
        wa_alert       TYPE zabsf_pp_s_alert,
        ld_data(10)    TYPE c,
        ld_time(8)     TYPE c.

  REFRESH: it_zabsf_pp028,
           it_zabsf_pp031.

  CLEAR: wa_zabsf_pp028,
         wa_zabsf_pp031.

*Get information of time chronometer
  SELECT SINGLE lower_limit upper_limit
    FROM zabsf_pp027
    INTO (lower_limit,upper_limit)
   WHERE arbpl EQ arbpl
     AND werks EQ werks
     AND matnr EQ matnr
     AND begda LE refdt
     AND endda GE refdt.

  IF sy-subrc NE 0.
*  No data in customizing table
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'I'
        msgno      = '020'
        msgv1      = matnr
      CHANGING
        return_tab = return_tab.
  ENDIF.

*Get information of measurements
  SELECT zabsf_pp029~measeureid zabsf_pp029_t~measeure_desc
    INTO CORRESPONDING FIELDS OF TABLE measure_opt_tab
    FROM zabsf_pp029 AS zabsf_pp029
   INNER JOIN zabsf_pp029_t AS zabsf_pp029_t
      ON zabsf_pp029~arbpl      EQ zabsf_pp029_t~arbpl
     AND zabsf_pp029~werks      EQ zabsf_pp029_t~werks
     AND zabsf_pp029~matnr      EQ zabsf_pp029_t~matnr
     AND zabsf_pp029~measeureid EQ zabsf_pp029_t~measeureid
   WHERE zabsf_pp029~arbpl EQ arbpl
     AND zabsf_pp029~werks EQ werks
     AND zabsf_pp029~matnr EQ matnr
     AND zabsf_pp029~begda LE refdt
     AND zabsf_pp029~endda GE refdt.

  IF sy-subrc NE 0.
*  No data in customizing table
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'I'
        msgno      = '020'
        msgv1      = matnr
      CHANGING
        return_tab = return_tab.
  ENDIF.

*Get information stored in the Chronograph
  IF data_chrono IS NOT INITIAL AND chrono_reg IS INITIAL.
    SELECT *
      FROM zabsf_pp028
      INTO CORRESPONDING FIELDS OF TABLE it_zabsf_pp028
      WHERE arbpl  EQ arbpl
        AND werks  EQ werks
*        AND aufnr  EQ aufnr
*        AND vornr  EQ vornr
        AND matnr  EQ matnr
        AND datasr GE data_chrono.

    IF it_zabsf_pp028[] IS INITIAL.
*    No data in registration table
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'I'
          msgno      = '021'
        CHANGING
          return_tab = return_tab.
    ENDIF.
  ELSEIF data_chrono IS INITIAL AND chrono_reg IS NOT INITIAL.
    SELECT * UP TO chrono_reg ROWS
      FROM zabsf_pp028
      INTO CORRESPONDING FIELDS OF TABLE it_zabsf_pp028
      WHERE arbpl  EQ arbpl
        AND werks  EQ werks
*        AND aufnr  EQ aufnr
*        AND vornr  EQ vornr
        AND matnr  EQ matnr
      ORDER BY datasr DESCENDING.

    IF it_zabsf_pp028[] IS INITIAL.
*    No data in registration table
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'I'
          msgno      = '021'
        CHANGING
          return_tab = return_tab.
    ENDIF.
  ELSEIF data_chrono IS NOT INITIAL AND chrono_reg IS NOT INITIAL.
    SELECT * UP TO chrono_reg ROWS
      FROM zabsf_pp028
      INTO CORRESPONDING FIELDS OF TABLE it_zabsf_pp028
      WHERE arbpl  EQ arbpl
        AND werks  EQ werks
*        AND aufnr  EQ aufnr
*        AND vornr  EQ vornr
        AND matnr  EQ matnr
        AND datasr GE data_chrono.

    IF it_zabsf_pp028[] IS INITIAL.
*    No data in registration table
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'I'
          msgno      = '021'
        CHANGING
          return_tab = return_tab.
    ENDIF.
  ENDIF.

*Fill type table to export data to shopfloor
  LOOP AT it_zabsf_pp028 INTO wa_zabsf_pp028.
    CLEAR: ld_data,
           ld_time,
           wa_chrono.

    CALL FUNCTION 'CONVERSION_EXIT_BCVTM_OUTPUT'
      EXPORTING
        input  = wa_zabsf_pp028-time
      IMPORTING
        output = ld_time.

    CALL FUNCTION 'CONVERSION_EXIT_BCVDT_OUTPUT'
      EXPORTING
        input    = wa_zabsf_pp028-datasr
        iv_datfm = '1' "IV_DATFM
      IMPORTING
        output   = ld_data.

*    ld_data = wa_ZABSF_PP028-datasr.
*    ld_time = wa_ZABSF_PP028-time.

    CONCATENATE ld_data ld_time INTO wa_chrono-data_time SEPARATED BY space.

    wa_chrono-cron_value = wa_zabsf_pp028-cron_value.
    wa_chrono-cron_unit = wa_zabsf_pp028-cron_unit.

    APPEND wa_chrono TO chrono_tab.
  ENDLOOP.

*Get information stored in the Measurements
  IF data_measure IS NOT INITIAL AND measure_reg IS INITIAL.
    SELECT *
      FROM zabsf_pp031
      INTO CORRESPONDING FIELDS OF TABLE it_zabsf_pp031
      WHERE arbpl  EQ arbpl
        AND werks  EQ werks
*        AND aufnr  EQ aufnr
*        AND vornr  EQ vornr
        AND matnr  EQ matnr
        AND datasr GE data_measure.

    IF it_zabsf_pp031[] IS INITIAL.
*    No data in registration table
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'I'
          msgno      = '021'
        CHANGING
          return_tab = return_tab.
    ENDIF.
  ELSEIF data_measure IS INITIAL AND measure_reg IS NOT INITIAL.
    SELECT * UP TO measure_reg ROWS
      FROM zabsf_pp031
      INTO CORRESPONDING FIELDS OF TABLE it_zabsf_pp031
      WHERE arbpl  EQ arbpl
        AND werks  EQ werks
*        AND aufnr  EQ aufnr
*        AND vornr  EQ vornr
        AND matnr  EQ matnr
      ORDER BY datasr DESCENDING.

    IF it_zabsf_pp031[] IS INITIAL.
*    No data in registration table
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'I'
          msgno      = '021'
        CHANGING
          return_tab = return_tab.
    ENDIF.
  ELSEIF data_measure IS NOT INITIAL AND measure_reg IS NOT INITIAL.
    SELECT * UP TO measure_reg ROWS
      FROM zabsf_pp031
      INTO CORRESPONDING FIELDS OF TABLE it_zabsf_pp031
      WHERE arbpl  EQ arbpl
        AND werks  EQ werks
*        AND aufnr  EQ aufnr
*        AND vornr  EQ vornr
        AND matnr  EQ matnr
        AND datasr GE data_measure.

    IF it_zabsf_pp031[] IS INITIAL.
*    No data in registration table
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'I'
          msgno      = '021'
        CHANGING
          return_tab = return_tab.
    ENDIF.
  ENDIF.

*Fill type table to export data to shopfloor
  LOOP AT it_zabsf_pp031 INTO wa_zabsf_pp031.
    CLEAR: wa_measure_opt,
           wa_measure,
           ld_data,
           ld_time.

    CALL FUNCTION 'CONVERSION_EXIT_BCVTM_OUTPUT'
      EXPORTING
        input  = wa_zabsf_pp031-time
      IMPORTING
        output = ld_time.

    CALL FUNCTION 'CONVERSION_EXIT_BCVDT_OUTPUT'
      EXPORTING
        input    = wa_zabsf_pp031-datasr
        iv_datfm = '1' "IV_DATFM
      IMPORTING
        output   = ld_data.

*    ld_data = wa_ZABSF_PP031-datasr.
*    ld_time = wa_ZABSF_PP031-time.

    CONCATENATE ld_data ld_time INTO wa_measure-data_time SEPARATED BY space.

    READ TABLE measure_opt_tab INTO wa_measure_opt WITH KEY measeureid = wa_zabsf_pp031-measeureid.

    wa_measure-measeure_desc = wa_measure_opt-measeure_desc.

    APPEND wa_measure TO measure_tab.
  ENDLOOP.

*Get information stored in the Alerts
  IF data_alert IS NOT INITIAL AND alert_reg IS INITIAL.
    SELECT *
      FROM zabsf_pp030
      INTO CORRESPONDING FIELDS OF TABLE it_zabsf_pp030
      WHERE arbpl  EQ arbpl
        AND werks  EQ werks
*        AND aufnr  EQ aufnr
*        AND vornr  EQ vornr
        AND matnr  EQ matnr
        AND datasr GE data_alert.

    IF it_zabsf_pp030[] IS INITIAL.
*    No data in registration table
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'I'
          msgno      = '021'
        CHANGING
          return_tab = return_tab.
    ENDIF.
  ELSEIF data_alert IS INITIAL AND alert_reg IS NOT INITIAL.
    SELECT * UP TO alert_reg ROWS
      FROM zabsf_pp030
      INTO CORRESPONDING FIELDS OF TABLE it_zabsf_pp030
      WHERE arbpl  EQ arbpl
        AND werks  EQ werks
*        AND aufnr  EQ aufnr
*        AND vornr  EQ vornr
        AND matnr  EQ matnr
      ORDER BY datasr DESCENDING.

    IF it_zabsf_pp030[] IS INITIAL.
*    No data in registration table
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'I'
          msgno      = '021'
        CHANGING
          return_tab = return_tab.
    ENDIF.
  ELSEIF data_alert IS NOT INITIAL AND alert_reg IS NOT INITIAL.
    SELECT * UP TO alert_reg ROWS
      FROM zabsf_pp030
      INTO CORRESPONDING FIELDS OF TABLE it_zabsf_pp030
      WHERE arbpl  EQ arbpl
        AND werks  EQ werks
*        AND aufnr  EQ aufnr
*        AND vornr  EQ vornr
        AND matnr  EQ matnr
        AND datasr GE data_alert.

    IF it_zabsf_pp030[] IS INITIAL.
*  No data in registration table
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'I'
          msgno      = '021'
        CHANGING
          return_tab = return_tab.
    ENDIF.
  ENDIF.

*Fill type table to export data to shopfloor
  LOOP AT it_zabsf_pp030 INTO wa_zabsf_pp030.
    CLEAR: wa_alert,
           ld_data,
           ld_time.

    CALL FUNCTION 'CONVERSION_EXIT_BCVTM_OUTPUT'
      EXPORTING
        input  = wa_zabsf_pp030-time
      IMPORTING
        output = ld_time.

    CALL FUNCTION 'CONVERSION_EXIT_BCVDT_OUTPUT'
      EXPORTING
        input    = wa_zabsf_pp030-datasr
        iv_datfm = '1' "IV_DATFM
      IMPORTING
        output   = ld_data.
*
*    ld_data = wa_ZABSF_PP030-datasr.
*    ld_time = wa_ZABSF_PP030-time.

    CONCATENATE ld_data ld_time INTO wa_alert-data_time SEPARATED BY space.

    wa_alert-alert_desc = wa_zabsf_pp030-alert_desc.
    wa_alert-action_plane = wa_zabsf_pp030-action_plane.

    wa_alert-old_value = wa_zabsf_pp030-old_value.
    wa_alert-actual_value = wa_zabsf_pp030-actual_value.
    wa_alert-responsable_user = wa_zabsf_pp030-responsable_user.

    APPEND wa_alert TO alert_tab.
  ENDLOOP.
ENDMETHOD.


method GET_OPTION_TURN.
endmethod.


method set_option_reg.

  data: wa_zabsf_pp028 type zabsf_pp028,    "Chronometer
        wa_zabsf_pp030 type zabsf_pp030,    "Alert and Action Plane
        wa_zabsf_pp031 type zabsf_pp031,    "Measurements
        ls_zabsf_pp030 type zabsf_pp030,
        wa_measureid   type zabsf_pp_e_measeureid,
        ld_unit        type zabsf_pp_e_unit_limit.


  clear: wa_zabsf_pp028,
         wa_zabsf_pp030,
         wa_zabsf_pp031,
         ls_zabsf_pp030.

*Save information for Chronometer
  if cron_value is not initial.
*  Save data of chronometer in database
    wa_zabsf_pp028-arbpl = arbpl.
    wa_zabsf_pp028-werks = inputobj-werks.
    wa_zabsf_pp028-aufnr = aufnr.
    wa_zabsf_pp028-vornr = vornr.
    wa_zabsf_pp028-matnr = matnr.
    wa_zabsf_pp028-datasr = date.
    wa_zabsf_pp028-time = time.
    wa_zabsf_pp028-cron_value = cron_value.

    select single unit_limit
      from zabsf_pp027
      into ld_unit
      where werks eq inputobj-werks
        and arbpl eq arbpl
        and matnr eq matnr
        and endda ge refdt
        and begda le refdt.

    wa_zabsf_pp028-cron_unit = ld_unit.

    insert into zabsf_pp028 values wa_zabsf_pp028.

    if sy-subrc eq 0.
*    Operation completed successfully
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgty      = 'S'
          msgno      = '013'
        changing
          return_tab = return_tab.
    else.
*    Operation not completed successfully
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgty      = 'E'
          msgno      = '012'
        changing
          return_tab = return_tab.
    endif.
  endif.

*Save information for Measurements
  if measureid_tab[] is not initial.
    loop at measureid_tab into wa_measureid.
*    Save data of measurements in database
      wa_zabsf_pp031-arbpl = arbpl.
      wa_zabsf_pp031-werks = inputobj-werks.
      wa_zabsf_pp031-aufnr = aufnr.
      wa_zabsf_pp031-vornr = vornr.
      wa_zabsf_pp031-matnr = matnr.
      wa_zabsf_pp031-datasr = date.
      wa_zabsf_pp031-time = time.
      wa_zabsf_pp031-measeureid = wa_measureid.

      insert into zabsf_pp031 values wa_zabsf_pp031.

      if sy-subrc eq 0.
*      Operation completed successfully
        call method zabsf_pp_cl_log=>add_message
          exporting
            msgty      = 'S'
            msgno      = '013'
          changing
            return_tab = return_tab.
      else.
*      Operation not completed successfully
        call method zabsf_pp_cl_log=>add_message
          exporting
            msgty      = 'E'
            msgno      = '012'
          changing
            return_tab = return_tab.
      endif.
    endloop.
  endif.

*Save information for action plane and alert
  if alert_desc is not initial and action_plane is not initial.
**  Save data of action plane and alert in database
*    wa_ZABSF_PP030-arbpl = arbpl.
*    wa_ZABSF_PP030-werks = inputobj-werks.
*    wa_ZABSF_PP030-aufnr = aufnr.
*    wa_ZABSF_PP030-vornr = vornr.
*    wa_ZABSF_PP030-matnr = matnr.
*    wa_ZABSF_PP030-datasr = date.
*    wa_ZABSF_PP030-time = time.
*    wa_ZABSF_PP030-alert_desc = alert_desc.
*    wa_ZABSF_PP030-action_plane = action_plane.
*
*    INSERT INTO ZABSF_PP030 VALUES wa_ZABSF_PP030.

*  Save data of action plane and alert in database
*    insert zabsf_pp030 from table @( value #( ( arbpl = arbpl
*                                                 werks = inputobj-werks
*                                                 aufnr = aufnr
*                                                 vornr = vornr
*                                                 matnr = matnr
*                                                 datasr = date
*                                                 time = time
*                                                 alert_desc = alert_desc
*                                                 action_plane = action_plane
*                                                 old_value = old_value
*                                                 actual_value = actual_value
*                                                 responsable_user = responsable_user ) ) ).
    ls_zabsf_pp030-arbpl = arbpl.
    ls_zabsf_pp030-werks = inputobj-werks.
    ls_zabsf_pp030-aufnr = aufnr.
    ls_zabsf_pp030-vornr = vornr.
    ls_zabsf_pp030-matnr = matnr.
    ls_zabsf_pp030-datasr = date.
    ls_zabsf_pp030-time = time.
    ls_zabsf_pp030-alert_desc = alert_desc.
    ls_zabsf_pp030-action_plane = action_plane.
    ls_zabsf_pp030-old_value = old_value.
    ls_zabsf_pp030-responsable_user = responsable_user.
    insert into zabsf_pp030 values ls_zabsf_pp030.
    if sy-subrc eq 0.
*    Save data
      commit work and wait.

*    Operation completed successfully
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgty      = 'S'
          msgno      = '013'
        changing
          return_tab = return_tab.
    else.
*    Operation not completed successfully
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgty      = 'E'
          msgno      = '012'
        changing
          return_tab = return_tab.
    endif.
  endif.
endmethod.


method SET_OPTION_TURN.
endmethod.


METHOD SET_REFDT.
*Set new reference date
  refdt = new_refdt.
ENDMETHOD.
ENDCLASS.
