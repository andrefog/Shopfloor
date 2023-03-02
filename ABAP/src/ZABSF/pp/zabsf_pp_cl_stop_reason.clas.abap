class ZABSF_PP_CL_STOP_REASON definition
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
      !NEW_REFDT type VVDATUM optional .
  methods GET_STOP_REASON_OPR
    importing
      !IV_ARBPL type ARBPL
      !IV_WERKS type WERKS_D
      !IV_SPRAS type SPRAS
      !IV_AREAID type ZABSF_PP_E_AREAID
    changing
      !STOP_REASON_TAB type ZABSF_PP_T_STOP_REASON
      !RETURN_TAB type BAPIRET2_T .
  methods GET_STOP_REASON_WRK
    importing
      !IV_ARBPL type ARBPL
      !IV_WERKS type WERKS_D
      !IV_SPRAS type SPRAS
      !IV_AREAID type ZABSF_PP_E_AREAID
    changing
      !STOP_REASON_TAB type ZABSF_PP_T_STOP_REASON
      !RETURN_TAB type BAPIRET2_T .
  methods SET_STOP_REASON_OPR
    importing
      !ARBPL type ARBPL
      !AUFNR type AUFNR
      !VORNR type VORNR
      !DATESR type ZABSF_PP_E_DATE
      !TIME type PR_TIME
      !OPRID type ZABSF_PP_E_OPRID
      !STPTY type ZABSF_PP_E_STPTY
      !STPRSNID type ZABSF_PP_E_STPRSNID
    changing
      !RETURN_TAB type BAPIRET2_T .
  methods SET_STOP_REASON_WRK
    importing
      !ARBPL type ARBPL
      !WERKS type WERKS_D
      !DATESR type ZABSF_PP_E_DATE
      !TIME type ATIME
      !STPRSNID type ZABSF_PP_E_STPRSNID
      !COUNT_FIN_TAB type ZABSF_PP_T_COUNTERS optional
      !SHIFTID type ZABSF_PP_E_SHIFTID optional
      !HNAME type CR_HNAME optional
    changing
      !ACTIONID type ZABSF_PP_E_ACTION optional
      !RETURN_TAB type BAPIRET2_T .
protected section.
private section.

  data REFDT type VVDATUM .
  data INPUTOBJ type ZABSF_PP_S_INPUTOBJECT .
  constants STATUS type J_STATUS value '0003' ##NO_TEXT.
  constants STSMA type J_STSMA value 'ZCT02' ##NO_TEXT.
  constants C_MIN type ZABSF_PP_E_STOPUNIT value 'MIN' ##NO_TEXT.
ENDCLASS.



CLASS ZABSF_PP_CL_STOP_REASON IMPLEMENTATION.


METHOD CONSTRUCTOR.
*Ref. Date
  refdt    = initial_refdt.

*App input data
  inputobj = input_object.
ENDMETHOD.


METHOD get_stop_reason_opr.
*Range
  DATA r_arbpl TYPE RANGE OF arbpl.
*Structure for range
  DATA ls_arbpl LIKE LINE OF r_arbpl.

*Variables
  DATA: lv_langu TYPE spras.

*Set language local for user
  lv_langu = iv_spras.

*Create ranges of workcenter
  ls_arbpl-option = 'EQ'.
  ls_arbpl-sign = 'I'.
  ls_arbpl-low = iv_arbpl.
  APPEND ls_arbpl TO r_arbpl.

***** BEGIN JOL - 07/12/2022 - get language - SPRAS field
  IF lv_langu EQ ''.
*  Get alternative language
    SELECT SINGLE spras
      FROM zabsf_pp061
      INTO lv_langu
     WHERE werks      EQ iv_werks
       AND is_default NE space.
  ENDIF.
***** BEGIN JOL - 07/12/2022

* Get stop reason
  SELECT *
    FROM zabsf_pp015_t
    INTO CORRESPONDING FIELDS OF TABLE stop_reason_tab
    WHERE areaid EQ iv_areaid
         AND arbpl  IN r_arbpl
         AND werks  EQ iv_werks
         AND spras  EQ lv_langu.

*  No stop reason found for work center and operation
    IF stop_reason_tab[] IS INITIAL.
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'E'
          msgno      = '010'
        CHANGING
          return_tab = return_tab.
    ENDIF.
ENDMETHOD.


METHOD get_stop_reason_wrk.
*Ranges
  DATA: r_arbpl  TYPE RANGE OF arbpl,
        ls_arbpl LIKE LINE OF r_arbpl.

*Variables
  DATA: lv_langu TYPE spras,
        lt_sf011 TYPE TABLE OF zabsf_pp011,
        ls_sf011 LIKE LINE OF lt_sf011,
        l_tabix  TYPE sytabix.

* Field Symbols
  FIELD-SYMBOLS: <fs_stop_reason> TYPE zabsf_pp_s_stop_reason.

*Set language local for user
  lv_langu = iv_spras.

*Create ranges of workcenter
  ls_arbpl-option = 'EQ'.
  ls_arbpl-sign = 'I'.
  ls_arbpl-low = iv_arbpl.
  APPEND ls_arbpl TO r_arbpl.

***** BEGIN JOL - 07/12/2022 - get language - SPRAS field
  IF lv_langu EQ ''.
*  Get alternative language
    SELECT SINGLE spras
      FROM zabsf_pp061
      INTO lv_langu
     WHERE werks      EQ iv_werks
       AND is_default NE space.
  ENDIF.
***** BEGIN JOL - 07/12/2022

** Get stop reasons
  SELECT *
    FROM zabsf_pp011_t
    INTO CORRESPONDING FIELDS OF TABLE stop_reason_tab
   WHERE areaid EQ iv_areaid
     AND arbpl  IN r_arbpl
     AND werks  EQ iv_werks
     AND spras  EQ lv_langu.

* No stop reason found for this work center
  IF stop_reason_tab[] IS INITIAL.

    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'E'
        msgno      = '019'
      CHANGING
        return_tab = return_tab.

  ELSE.
    SELECT * FROM zabsf_pp011 INTO CORRESPONDING FIELDS OF TABLE lt_sf011
      FOR ALL ENTRIES IN stop_reason_tab
        WHERE areaid = iv_areaid
        AND werks = iv_werks
        AND arbpl = stop_reason_tab-arbpl
        AND stprsnid  = stop_reason_tab-stprsnid
        AND inact = space.

    IF lt_sf011 IS NOT INITIAL.
      LOOP AT stop_reason_tab ASSIGNING <fs_stop_reason>.
        l_tabix = sy-tabix.
        READ TABLE lt_sf011 INTO ls_sf011 WITH KEY arbpl = <fs_stop_reason>-arbpl
                                                   stprsnid = <fs_stop_reason>-stprsnid.
        IF sy-subrc EQ 0.
          <fs_stop_reason>-notif_type = ls_sf011-notif_type.
        ELSE.
          DELETE stop_reason_tab INDEX l_tabix.
        ENDIF.

        CLEAR ls_sf011.
      ENDLOOP.
    ENDIF.
  ENDIF.
ENDMETHOD.


METHOD SET_REFDT.
*Set new reference date
  refdt = new_refdt.
ENDMETHOD.


method SET_STOP_REASON_OPR.
*  DATA wa_zlp_pp_sf016 TYPE zlp_pp_sf016.
*
*  CLEAR wa_zlp_pp_sf016.
*
**Save data of stop reason
**Work Center
*  wa_zlp_pp_sf016-arbpl = arbpl.
**Order
*  wa_zlp_pp_sf016-aufnr = aufnr.
**Operation
*  wa_zlp_pp_sf016-vornr = vornr.
**Date of stop reason
*  wa_zlp_pp_sf016-datesr = datesr.
**Start time of stop reason
*  wa_zlp_pp_sf016-time = time.
**Operator
*  wa_zlp_pp_sf016-operador = oprid.
**Type of stop - Stop or restart
*  wa_zlp_pp_sf016-stpty = stpty.
**Cause of stop
*  wa_zlp_pp_sf016-stprsnid = stprsnid.
*
**Save in Database
*  INSERT INTO zlp_pp_sf016 VALUES wa_zlp_pp_sf016.
*
*  IF sy-subrc EQ 0.
**  Operation completes successfully
*    CALL METHOD zcl_lp_pp_sf_log=>add_message
*      EXPORTING
*        msgty      = 'S'
*        msgno      = '013'
*      CHANGING
*        return_tab = return_tab.
*  ELSE.
**  Operation not completed
*    CALL METHOD zcl_lp_pp_sf_log=>add_message
*      EXPORTING
*        msgty      = 'E'
*        msgno      = '012'
*      CHANGING
*        return_tab = return_tab.
*  ENDIF.
endmethod.


METHOD set_stop_reason_wrk.
*Reference
  DATA: lref_sf_status    TYPE REF TO zabsf_pp_cl_status,
        lref_sf_event_act TYPE REF TO zif_absf_pp_event_act,
        lref_sf_calc_min  TYPE REF TO zabsf_pp_cl_event_act.

*Variables
  DATA: l_time         TYPE atime,
        l_time_off     TYPE atime,
        l_time_act     TYPE atime,
        l_time_calc    TYPE pr_time,
        l_date_calc    TYPE datum,
        l_status_out   TYPE j_status,
        l_status_desc  TYPE j_txt30,
        l_stsma_out    TYPE jsto-stsma,
        l_activity     TYPE ru_ismng,
        l_actionid     TYPE zabsf_pp_e_action VALUE 'INIT',
        l_flag_stop    TYPE c, "Operation stop
        l_gname        TYPE seqg3-gname,
        l_garg         TYPE seqg3-garg,
        l_guname       TYPE seqg3-guname,
        l_subrc        TYPE sy-subrc,
        l_wait         TYPE i,
        ls_zabsf_pp010 TYPE zabsf_pp010.

*Constants
  CONSTANTS: c_objty       TYPE cr_objty          VALUE 'A',    "Work center
             c_at03        TYPE zabsf_pp_e_tarea_id VALUE 'AT03', "Repetitive production functionalities
             c_obart_ov    TYPE j_obart           VALUE 'OV',   "Operation
             c_obart_ca    TYPE j_obart           VALUE 'CA',   "Work center
             c_time_offset TYPE zabsf_pp_e_parid    VALUE 'TIME_OFFSET',
             c_wait        TYPE zabsf_pp_e_parid VALUE 'WAIT'.

  CLEAR: l_time.

*Check lenght of time
  DATA(l_lengh) = strlen( time ).

  IF l_lengh LT 6.
    CONCATENATE '0' time INTO l_time.
  ELSE.
    l_time = time.
  ENDIF.

*Upper case operator
  TRANSLATE inputobj-oprid TO UPPER CASE.

*Update User number
*  if inputobj-pernr is initial.
*    inputobj-pernr = inputobj-oprid.
*  endif.

*Get time wait
  SELECT SINGLE parva
    FROM zabsf_pp032
    INTO @DATA(l_wait_param)
   WHERE parid EQ @c_wait.

  IF l_wait_param IS NOT INITIAL.
    l_wait = l_wait_param.
  ENDIF.

  l_time = l_time - l_wait.

  IF shiftid IS INITIAL.
*Get shift witch operator is associated
    SELECT SINGLE shiftid
      FROM zabsf_pp052
      INTO (@DATA(l_shiftid))
     WHERE areaid EQ @inputobj-areaid
       AND oprid  EQ @inputobj-oprid.

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
  ELSE.
    l_shiftid = shiftid.
  ENDIF.

  IF hname IS INITIAL.

*Get id of workcenter
    SELECT SINGLE objid
      FROM crhd
      INTO (@DATA(l_arbpl_id))
     WHERE arbpl EQ @arbpl
       AND werks EQ @inputobj-werks.

*Get hierarchy of workcenter
    SELECT SINGLE objty_hy, objid_hy
      FROM crhs
      INTO (@DATA(l_hname_ty), @DATA(l_hname_id))
     WHERE objty_ho EQ @c_objty     "Workcenter
       AND objid_ho EQ @l_arbpl_id.

*Get name of hierarchy
    SELECT SINGLE name
      FROM crhh
      INTO (@DATA(l_hname))
     WHERE objty EQ @l_hname_ty
       AND objid EQ @l_hname_id.

  ELSE.
    l_hname = hname.
  ENDIF.

*Get class of interface for Time confirmation
  SELECT SINGLE imp_clname, methodname
      FROM zabsf_pp003
      INTO (@DATA(l_class),@DATA(l_method))
     WHERE werks    EQ @inputobj-werks
       AND id_class EQ '2'
       AND endda    GE @refdt
       AND begda    LE @refdt.

  TRY.
*    Create object of class
      CREATE OBJECT lref_sf_event_act TYPE (l_class)
        EXPORTING
          initial_refdt = refdt
          input_object  = inputobj.

    CATCH cx_sy_create_object_error.
*    Send message erro
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'E'
          msgno      = '019'
          msgv1      = l_class
        CHANGING
          return_tab = return_tab.
      EXIT.
  ENDTRY.

*Create object of class - Calculate time in minutes
  CREATE OBJECT lref_sf_calc_min
    EXPORTING
      initial_refdt = sy-datum
      input_object  = inputobj.

*Create object of class - Status
  CREATE OBJECT lref_sf_status
    EXPORTING
      initial_refdt = sy-datum
      input_object  = inputobj.

  IF stprsnid IS NOT INITIAL.
*  Save data of stop reason
*    INSERT INTO zabsf_pp010 VALUES @( VALUE #( areaid   = inputobj-areaid "Area
*                                                hname    = l_hname         "Hierarchy
*                                                werks    = inputobj-werks  "Plant
*                                                arbpl    = arbpl           "Work Center
*                                                datesr   = datesr          "Date of stop reason
*                                                time     = l_time          "Start time of stop reason
*                                                operador = inputobj-oprid  "Operator
*                                                shiftid  = l_shiftid       "Shift
*                                                stprsnid = stprsnid        "Cause of stop
*                                                stopunit = c_min ) ).      "Unit

    ls_zabsf_pp010-areaid   = inputobj-areaid.
    ls_zabsf_pp010-hname    = l_hname.
    ls_zabsf_pp010-werks    = inputobj-werks.
    ls_zabsf_pp010-arbpl    = arbpl.
    ls_zabsf_pp010-datesr   = datesr.
    ls_zabsf_pp010-time     = l_time.
    ls_zabsf_pp010-operador = inputobj-oprid.
    ls_zabsf_pp010-shiftid  = l_shiftid.
    ls_zabsf_pp010-stprsnid = stprsnid.
    ls_zabsf_pp010-stopunit = c_min.
    ls_zabsf_pp010-endda =  '00000000'.


    INSERT INTO zabsf_pp010 VALUES ls_zabsf_pp010.
    IF sy-subrc EQ 0.
      COMMIT WORK AND WAIT.

*    Operation completed successfully
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'S'
          msgno      = '013'
        CHANGING
          return_tab = return_tab.

*    Get area type
      SELECT SINGLE tarea_id
        FROM zabsf_pp008
        INTO (@DATA(l_tarea_id))
       WHERE areaid EQ @inputobj-areaid
         AND werks  EQ @inputobj-werks
         AND endda  GT @sy-datum
         AND begda  LT @sy-datum.

*    Check if area isn't equal to Assembly (Montagem)
      IF l_tarea_id NE c_at03.
*      Get next status for operation
        SELECT SINGLE status_next
          FROM zabsf_pp022
          INTO (@DATA(l_status_next))
         WHERE objty       EQ @c_obart_ov
           AND status_last EQ @space
           AND status_next NE @space.

*      Change status of all operation of workcenter
        SELECT *
          FROM zabsf_pp021
          INTO TABLE @DATA(lt_pp_sf021)
         WHERE arbpl       EQ @arbpl
           AND status_oper NE @l_status_next.

*      Get confirmations
        SELECT DISTINCT arbpl, aufnr, vornr, rueck, rmzhl, aufpl, aplzl, stprsnid
          FROM zabsf_pp016
          INTO TABLE @DATA(lt_pp_sf016)
           FOR ALL ENTRIES IN @lt_pp_sf021
         WHERE areaid  EQ @inputobj-areaid
           AND hname   EQ @l_hname
           AND werks   EQ @inputobj-werks
           AND arbpl   EQ @lt_pp_sf021-arbpl
           AND aufnr   EQ @lt_pp_sf021-aufnr
           AND vornr   EQ @lt_pp_sf021-vornr.
*           AND shiftid EQ @l_shiftid.

        LOOP AT lt_pp_sf021 INTO DATA(ls_pp_sf021).
          IF ls_pp_sf021-status_oper NE 'AGU' AND ls_pp_sf021-status_oper NE 'CONC' AND
             ls_pp_sf021-status_oper NE 'STOP'.

*          Get aufpl, aplzl and rueck
            READ TABLE lt_pp_sf016 INTO DATA(ls_pp_sf016) WITH KEY arbpl = ls_pp_sf021-arbpl
                                                                   aufnr = ls_pp_sf021-aufnr
                                                                   vornr = ls_pp_sf021-vornr.
            IF sy-subrc EQ 0.
*            Get counter final
              READ TABLE count_fin_tab INTO DATA(ls_count_fin) WITH KEY aufnr = ls_pp_sf021-aufnr
                                                                        vornr = ls_pp_sf021-vornr.


*            Check blocks
              CALL METHOD zabsf_pp_cl_wait_enqueue=>wait_for_dequeue_res
                EXPORTING
                  i_aufnr    = ls_pp_sf021-aufnr
                  i_max_time = l_wait
                IMPORTING
                  e_gname    = l_gname
                  e_garg     = l_garg
                  e_guname   = l_guname
                  e_return   = l_subrc.

              IF l_subrc NE 0.
                EXIT.
              ENDIF.

*            Save stop time - Confirm times
              CALL METHOD lref_sf_event_act->(l_method)
                EXPORTING
                  arbpl      = arbpl
                  werks      = werks
                  aufnr      = ls_pp_sf021-aufnr
                  vornr      = ls_pp_sf021-vornr
                  date       = datesr
                  time       = l_time
                  oprid      = inputobj-oprid
                  rueck      = ls_pp_sf016-rueck
                  aufpl      = ls_pp_sf016-aufpl
                  aplzl      = ls_pp_sf016-aplzl
                  actv_id    = 'STOP_PRO'
                  stprsnid   = stprsnid
                  count_fin  = ls_count_fin-count_fin
                CHANGING
                  actionid   = actionid
                  return_tab = return_tab.
            ENDIF.
          ENDIF.
        ENDLOOP.

        IF l_subrc NE 0.
          CALL METHOD zabsf_pp_cl_log=>add_message
            EXPORTING
              msgty      = 'E'
              msgno      = '093'
              msgv1      = l_guname
              msgv2      = l_gname
              msgv3      = l_guname
            CHANGING
              return_tab = return_tab.
          EXIT.
        ENDIF.

* BMR INSERT 26.09.2016 -change WC status even if  lt_pp_sf021 is empty
        CALL METHOD lref_sf_status->status_object
          EXPORTING
            arbpl       = arbpl
            werks       = inputobj-werks
            objty       = c_obart_ca
            method      = 'G'
          CHANGING
            status_out  = l_status_out
            status_desc = l_status_desc
            stsma_out   = l_stsma_out
            return_tab  = return_tab.

*      Get next  status for workcenter
        SELECT SINGLE status_next
          FROM zabsf_pp022
          INTO @l_status_next
         WHERE objty       EQ @c_obart_ca
           AND status_last EQ @l_status_out
           AND stsma       EQ @l_stsma_out
           AND actionid    EQ @actionid.

*      Change status
        CALL METHOD lref_sf_status->status_object
          EXPORTING
            arbpl      = arbpl
            werks      = werks
            objty      = c_obart_ca
            status     = l_status_next
            stsma      = l_stsma_out
            method     = 'S'
            actionid   = actionid
          CHANGING
            return_tab = return_tab.

      ELSE.
*      For other types areas
*      Get current status of workcenter
        CALL METHOD lref_sf_status->status_object
          EXPORTING
            arbpl       = arbpl
            werks       = inputobj-werks
            objty       = c_obart_ca
            method      = 'G'
          CHANGING
            status_out  = l_status_out
            status_desc = l_status_desc
            stsma_out   = l_stsma_out
            return_tab  = return_tab.

*      Get next  status for workcenter
        SELECT SINGLE status_next
          FROM zabsf_pp022
          INTO @l_status_next
         WHERE objty       EQ @c_obart_ca
           AND status_last EQ @l_status_out
           AND stsma       EQ @l_stsma_out
           AND actionid    EQ @actionid.

*      Change status
        CALL METHOD lref_sf_status->status_object
          EXPORTING
            arbpl      = arbpl
            werks      = werks
            objty      = c_obart_ca
            status     = l_status_next
            stsma      = l_stsma_out
            method     = 'S'
            actionid   = actionid
          CHANGING
            return_tab = return_tab.
      ENDIF.
    ELSE.
*    Operation not completed
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'E'
          msgno      = '012'
        CHANGING
          return_tab = return_tab.
    ENDIF.
  ELSE.
*  Check if exist stop reason saved
    SELECT SINGLE *
      FROM zabsf_pp010
      INTO @DATA(ls_pp_sf010)
     WHERE areaid   EQ @inputobj-areaid
       AND hname    EQ @l_hname
       AND werks    EQ @inputobj-werks
       AND arbpl    EQ @arbpl
       AND timeend  EQ '000000'.

    IF sy-subrc EQ 0.
      CLEAR l_activity.

*    Time
      l_time_calc = l_time.
*    Date
      l_date_calc = datesr.

*    Calculate stop time in minutes
      CALL METHOD lref_sf_calc_min->calc_minutes
        EXPORTING
          date       = ls_pp_sf010-datesr
          time       = ls_pp_sf010-time
          proc_date  = l_date_calc
          proc_time  = l_time_calc
        CHANGING
          activity   = l_activity
          return_tab = return_tab.

*    Update stop time of Work center
*      update zabsf_pp010 from @( value #( base ls_pp_sf010 stoptime = l_activity
*                                                            stopunit = c_min
*                                                            endda    = datesr "BMR INSERT
*                                                            timeend  = l_time ) ).

      ls_pp_sf010-stoptime = l_activity.
      ls_pp_sf010-stopunit = c_min.
      ls_pp_sf010-endda    = datesr.
      ls_pp_sf010-timeend  = l_time.
      UPDATE zabsf_pp010 FROM  ls_pp_sf010.
      IF sy-subrc EQ 0.
        CLEAR: l_status_next,
               l_flag_stop.

        REFRESH: lt_pp_sf021,
                 lt_pp_sf016.


        COMMIT WORK AND WAIT.

*      Get next status for operation
        SELECT SINGLE status_next
          FROM zabsf_pp022
          INTO @l_status_next
         WHERE objty       EQ @c_obart_ov
           AND status_last EQ @space
           AND status_next NE @space.

*      Change status of all operation of workcenter
        SELECT *
          FROM zabsf_pp021
          INTO TABLE @lt_pp_sf021
         WHERE arbpl       EQ @arbpl
           AND status_oper NE @l_status_next.

*      Get confirmations
        SELECT DISTINCT arbpl, aufnr, vornr, rueck, rmzhl, aufpl, aplzl, stprsnid
          FROM zabsf_pp016
          INTO TABLE @lt_pp_sf016
           FOR ALL ENTRIES IN @lt_pp_sf021
         WHERE areaid  EQ @inputobj-areaid
           AND hname   EQ @l_hname
           AND werks   EQ @inputobj-werks
           AND arbpl   EQ @lt_pp_sf021-arbpl
           AND aufnr   EQ @lt_pp_sf021-aufnr
           AND vornr   EQ @lt_pp_sf021-vornr.
*           AND shiftid EQ @l_shiftid.

        CLEAR ls_pp_sf021.

        LOOP AT lt_pp_sf021 INTO ls_pp_sf021 WHERE status_oper EQ 'STOP'.
          CLEAR ls_pp_sf016.

*        Get aufpl, aplzl and rueck
          READ TABLE lt_pp_sf016 INTO ls_pp_sf016 WITH KEY arbpl = ls_pp_sf021-arbpl
                                                           aufnr = ls_pp_sf021-aufnr
                                                           vornr = ls_pp_sf021-vornr.

*        Save stop time
          CALL METHOD lref_sf_event_act->(l_method)
            EXPORTING
              arbpl      = arbpl
              werks      = werks
              aufnr      = ls_pp_sf021-aufnr
              vornr      = ls_pp_sf021-vornr
              date       = datesr
              time       = l_time
              oprid      = inputobj-oprid
              rueck      = ls_pp_sf016-rueck
              aufpl      = ls_pp_sf016-aufpl
              aplzl      = ls_pp_sf016-aplzl
              actv_id    = 'END_PARC' "'INIT_PRO'
            CHANGING
              actionid   = l_actionid
              return_tab = return_tab.

          l_flag_stop = 'X'.
        ENDLOOP.

*        if l_flag_stop is not initial.
*        Get current status of Workcenter
        CALL METHOD lref_sf_status->status_object
          EXPORTING
            arbpl       = arbpl
            werks       = inputobj-werks
            objty       = c_obart_ca
            method      = 'G'
          CHANGING
            status_out  = l_status_out
            status_desc = l_status_desc
            stsma_out   = l_stsma_out
            return_tab  = return_tab.

*        Get next  status for workcenter
        SELECT SINGLE status_next
          FROM zabsf_pp022
          INTO @l_status_next
         WHERE objty       EQ @c_obart_ca
           AND status_last EQ @l_status_out
           AND stsma       EQ @l_stsma_out
           AND actionid    EQ @actionid.

*        Change status
        CALL METHOD lref_sf_status->status_object
          EXPORTING
            arbpl      = arbpl
            werks      = werks
            objty      = c_obart_ca
            status     = l_status_next
            stsma      = l_stsma_out
            method     = 'S'
            actionid   = actionid
          CHANGING
            return_tab = return_tab.
*        endif.
      ENDIF.
    ENDIF.
  ENDIF.

  CHECK actionid = 'STOP'.

  LOOP AT lt_pp_sf021 INTO DATA(ls_sf021).
    DELETE FROM zabsf_pp069 WHERE werks = werks
                               AND aufnr = ls_sf021-aufnr
                               AND vornr = ls_sf021-vornr
                               AND flag_shift = abap_true.
  ENDLOOP.
  CHECK sy-subrc = 0.
  COMMIT WORK.

ENDMETHOD.
ENDCLASS.
