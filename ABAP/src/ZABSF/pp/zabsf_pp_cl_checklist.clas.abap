class ZABSF_PP_CL_CHECKLIST definition
  public
  final
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !INITIAL_REFDT type VVDATUM
      !INPUT_OBJECT type ZABSF_PP_S_INPUTOBJECT .
  methods GET_CHECKLIST
    importing
      value(PM_ORDER) type AUFNR
      value(CHECKLIST_STEP) type VORNR
    changing
      value(CHECKLIST) type ZABSF_PP_T_CHECKLIST
      value(RETURN_TAB) type BAPIRET2_T .
  methods SET_CHECKLIST
    importing
      value(CHECKLIST) type ZABSF_PP_T_CHECKLIST
      value(PM_ORDER) type AUFNR
      value(OBSERVATIONS) type STRING optional
    changing
      value(RETURN_TAB) type BAPIRET2_T .
protected section.
private section.

  data REFDT type VVDATUM .
  data INPUTOBJ type ZABSF_PP_S_INPUTOBJECT .
ENDCLASS.



CLASS ZABSF_PP_CL_CHECKLIST IMPLEMENTATION.


METHOD CONSTRUCTOR.

*ref. date
  refdt = initial_refdt.

*App input data
    inputobj = input_object.
  ENDMETHOD.


METHOD get_checklist.

    DATA: ls_checklist TYPE zabsf_pp_s_checklist,
          ls_v_equi    TYPE v_equi,
          ls_aufk      TYPE aufk.

    DATA: ls_main_step      TYPE afvc,
          lt_sub_operations TYPE TABLE OF afvc,
          lt_operations     TYPE TABLE OF afvc,
          ls_operations     TYPE afvc,
          ls_sub_operations LIKE LINE OF lt_sub_operations.

    DATA: lv_objid TYPE cr_objid,
          lv_aufpl TYPE co_aufpl,
          lv_sumnr TYPE sumkntnr VALUE IS INITIAL.


* get routing of PM order
    SELECT SINGLE aufpl FROM afko INTO lv_aufpl
      WHERE aufnr = pm_order.

* check order type
    SELECT SINGLE * FROM aufk INTO ls_aufk
      WHERE aufnr = pm_order.

    IF ls_aufk-auart NE 'ZMLD'.

* get all main routing operation
      SELECT * FROM afvc INTO TABLE lt_operations
        WHERE aufpl = lv_aufpl
        AND sumnr = lv_sumnr. "no sub-operations

      LOOP AT lt_operations INTO ls_operations.

        CALL FUNCTION 'CHAR_NUMC_CONVERSION'
          EXPORTING
            input   = ls_operations-vornr
          IMPORTING
            numcstr = ls_checklist-index_id.
        ls_checklist-stepid = ls_operations-vornr.
        ls_checklist-substepid = ls_operations-vornr. "copy stepid to substepid
        ls_checklist-stepdesc = ls_operations-ltxa1.

        APPEND ls_checklist TO checklist.
        CLEAR: ls_operations, ls_checklist.
      ENDLOOP.

    ELSE.
* sort table by sub-operation number.

* get main routing operation
      SELECT SINGLE *  FROM afvc INTO ls_main_step
        WHERE aufpl = lv_aufpl
        AND vornr = checklist_step
        AND sumnr = lv_sumnr.

* get all suboperation
      SELECT * FROM afvc INTO TABLE lt_sub_operations
        WHERE  aufpl = lv_aufpl
        AND sumnr = ls_main_step-aplzl.

      LOOP AT lt_sub_operations INTO ls_sub_operations.

        CALL FUNCTION 'CHAR_NUMC_CONVERSION'
          EXPORTING
            input   = ls_sub_operations-vornr
          IMPORTING
            numcstr = ls_checklist-index_id.

        ls_checklist-stepid = ls_main_step-vornr.
        ls_checklist-substepid = ls_sub_operations-vornr.
        ls_checklist-stepdesc = ls_sub_operations-ltxa1.

        APPEND ls_checklist TO checklist.
        CLEAR: ls_sub_operations, ls_checklist.
      ENDLOOP.
    ENDIF.

    SORT checklist BY index_id ASCENDING.
  ENDMETHOD.


METHOD set_checklist.

    CONSTANTS: gc_ok(5)  VALUE '[OK.]:',
               gc_nok(5) VALUE '[NOK]:',
               gc_ne(5)  VALUE '[N/E]:'.


    TYPES: BEGIN OF ty_user_stats,
             objnr     TYPE j_objnr,
             user_stat TYPE j_status,
           END OF ty_user_stats.

    TYPES: BEGIN OF ty_notes,
             rueck     TYPE co_rueck,
             rmzhl     TYPE co_rmzhl,
             ltxa1     TYPE co_rtext,
             aufpl     TYPE co_aufpl,
             aplzl     TYPE co_aplzl,
             step_desc TYPE ltxa1,
           END OF ty_notes.

    DATA: lref_sf_maintenance    TYPE REF TO zabsf_pp_cl_maintenance.

    DATA: ls_checklist LIKE LINE OF checklist.

    DATA: lt_notes      TYPE TABLE OF ty_notes,
          ls_notes      LIKE LINE OF lt_notes,
          lt_steps_desc TYPE TABLE OF ty_notes,
          ls_steps_desc LIKE LINE OF lt_steps_desc,
          lines         TYPE STANDARD TABLE OF tline,
          ls_line       LIKE LINE OF lines.

    DATA: lt_afvc        TYPE TABLE OF afvc,
          ls_afvc        LIKE LINE OF lt_afvc,
          ls_afvc_aux    LIKE LINE OF lt_afvc,
          ls_aufk        TYPE aufk,
          lv_aufpl       TYPE co_aufpl,
          lv_user_stat   TYPE j_status,
          lt_user_stats  TYPE TABLE OF ty_user_stats,
          ls_user_stats  LIKE LINE OF lt_user_stats,
          lv_equnr       TYPE equnr,
          lv_description TYPE matnr,
          lv_aufnr       TYPE aufnr.

    DATA: lt_timetickets      TYPE TABLE OF bapi_alm_timeconfirmation,
          ls_timetickets      LIKE LINE OF lt_timetickets,
          ls_return           TYPE bapiret2,
          lt_return_detail    TYPE TABLE OF bapi_alm_return,
          lv_spras            TYPE spras,
          lf_dont_close       TYPE boole_d,
          lf_create_notif     TYPE boole_d,
          lf_found_operations TYPE boole_d.

    DATA: lt_operations     TYPE TABLE OF bapi_alm_order_operation_e,
          ls_operations     LIKE LINE OF lt_operations,
          lt_return         TYPE TABLE OF bapiret2,
          ls_op_detail      TYPE  bapi_alm_order_operation_e,
          lt_op_detail_ret  TYPE TABLE OF bapiret2,
          lt_op_detail_text TYPE TABLE OF  bapi_alm_text,
          lt_op_detail_txtl TYPE TABLE OF bapi_alm_text_lines,
          lt_bapi_methods   TYPE TABLE OF bapi_alm_order_method,
          ls_bapi_methods   LIKE LINE OF lt_bapi_methods,
          lt_ordmaint_ret   TYPE bapiret2_t,
          lt_maint_header   TYPE TABLE OF bapi_alm_order_headers_i,
          ls_maint_header   LIKE LINE OF lt_maint_header.

    DATA: lt_longtext TYPE TABLE OF bapi2080_notfulltxti,
          ls_longtext LIKE LINE OF lt_longtext.

    FIELD-SYMBOLS:<fs_checklist> TYPE zabsf_pp_s_checklist,
                  <fs_notes>     TYPE ty_notes.

* set local language
    lv_spras = sy-langu.
    SET LOCALE LANGUAGE lv_spras.

* get order type
    SELECT SINGLE * FROM aufk INTO ls_aufk
      WHERE aufnr = pm_order.

* get routing for PM order.
    SELECT SINGLE aufpl FROM afko INTO lv_aufpl
      WHERE aufnr = pm_order.

    SELECT * FROM afvc INTO TABLE lt_afvc
      WHERE aufpl = lv_aufpl.

    CHECK ls_aufk-auart IS NOT INITIAL.

    IF ls_aufk-auart NE 'ZMLD'.

      LOOP AT checklist ASSIGNING <fs_checklist>.

        <fs_checklist>-stepid = <fs_checklist>-substepid.
        CLEAR <fs_checklist>-substepid. "remove sub steps

      ENDLOOP.

    ELSE.
* -- confirm main operation only if contains subitems.

      READ TABLE checklist INTO ls_checklist INDEX 1.

      IF ls_checklist-substepid IS NOT INITIAL.

        ls_timetickets-orderid = pm_order.
        ls_timetickets-operation = ls_checklist-stepid.
        ls_timetickets-fin_conf = '1'.
        ls_timetickets-complete = abap_true.
        ls_timetickets-plant = inputobj-werks.

        APPEND ls_timetickets TO lt_timetickets.
        CLEAR ls_timetickets.
      ENDIF.
    ENDIF.


    LOOP AT checklist INTO ls_checklist.
      ls_timetickets-orderid = pm_order.
      ls_timetickets-operation = ls_checklist-stepid.
      ls_timetickets-sub_oper = ls_checklist-substepid.
      ls_timetickets-fin_conf = '1'.
      ls_timetickets-complete = abap_true.
      ls_timetickets-plant = inputobj-werks.

      CASE abap_true.
        WHEN ls_checklist-ok.
          CONCATENATE gc_ok ls_checklist-observations INTO ls_timetickets-conf_text.
          ls_user_stats-user_stat = 'E0002'.

        WHEN ls_checklist-nok.
          CONCATENATE gc_nok ls_checklist-observations INTO ls_timetickets-conf_text.
          ls_user_stats-user_stat = 'E0003'.

        WHEN ls_checklist-ne.
          CONCATENATE gc_ne ls_checklist-observations INTO ls_timetickets-conf_text.
          ls_user_stats-user_stat = 'E0004'.
      ENDCASE.

* set table for status update.

      "check if is sub  operation.
      IF ls_checklist-substepid IS NOT INITIAL.
        "get parent operation
        READ TABLE lt_afvc INTO ls_afvc_aux WITH KEY aufpl = lv_aufpl
                                                 vornr = ls_checklist-stepid
                                                 sumnr = ''.
        "get child operation
        READ TABLE lt_afvc INTO ls_afvc WITH KEY  aufpl = lv_aufpl
                                                  vornr = ls_checklist-substepid
                                                  sumnr = ls_afvc_aux-aplzl.
        IF sy-subrc EQ 0.
          "create object ID.
          CONCATENATE 'OV' ls_afvc-aufpl ls_afvc-aplzl INTO ls_user_stats-objnr.
          APPEND ls_user_stats TO lt_user_stats.
        ENDIF.

      ELSE.
        "Operations
        READ TABLE lt_afvc INTO ls_afvc_aux WITH KEY aufpl = lv_aufpl
                                              vornr = ls_checklist-stepid
                                              sumnr = ''.

        CONCATENATE 'OV' ls_afvc_aux-aufpl ls_afvc_aux-aplzl INTO ls_user_stats-objnr.
        APPEND ls_user_stats TO lt_user_stats.
      ENDIF.

      APPEND ls_timetickets TO lt_timetickets.
      CLEAR: ls_checklist, ls_timetickets, ls_afvc, ls_afvc_aux, ls_user_stats.

    ENDLOOP.

    CALL FUNCTION 'BAPI_ALM_CONF_CREATE'
      EXPORTING
        testrun       = abap_false
      IMPORTING
        return        = ls_return
      TABLES
        timetickets   = lt_timetickets
        detail_return = lt_return_detail.

    IF ls_return-type CA 'AEX'.

      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
*send error message and
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgid      = ls_return-id
          msgty      = ls_return-type
          msgno      = ls_return-number
          msgv1      = ls_return-message_v1
          msgv2      = ls_return-message_v2
          msgv3      = ls_return-message_v3
          msgv4      = ls_return-message_v4
        CHANGING
          return_tab = return_tab.
      EXIT.

    ELSE.

      LOOP AT lt_user_stats INTO ls_user_stats.

        CALL FUNCTION 'STATUS_CHANGE_EXTERN'
          EXPORTING
            client      = sy-mandt
            objnr       = ls_user_stats-objnr
            user_status = ls_user_stats-user_stat
            set_chgkz   = abap_true.

        IF sy-subrc <> 0.
* Implement suitable error handling here
        ENDIF.

        CLEAR ls_user_stats.
      ENDLOOP.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.

      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'S'
          msgno      = '79'
        CHANGING
          return_tab = return_tab.

    ENDIF.

* clear buffer
    CALL FUNCTION 'CO_ZF_DATA_RESET_COMPLETE'
      EXPORTING
        i_no_ocm_reset = ' '
        i_status_reset = 'X'.

* get order operations
    CALL FUNCTION 'BAPI_ALM_ORDER_GET_DETAIL'
      EXPORTING
        number        = pm_order
      TABLES
        et_operations = lt_operations
        return        = lt_return.

* get status of each operation
    LOOP AT lt_operations INTO ls_operations.

      lf_found_operations = abap_true.
      CALL FUNCTION 'BAPI_ALM_OPERATION_GET_DETAIL'
        EXPORTING
          iv_orderid      = pm_order
          iv_activity     = ls_operations-activity
          iv_sub_activity = ls_operations-sub_activity
        IMPORTING
          es_operation    = ls_op_detail
        TABLES
          return          = lt_op_detail_ret
          et_text         = lt_op_detail_text
          et_text_lines   = lt_op_detail_txtl.

      IF ls_op_detail-complete = abap_false.
        lf_dont_close = abap_true.
      ENDIF.

      CLEAR: ls_operations, ls_op_detail.
    ENDLOOP.

    IF lt_operations IS INITIAL.
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'E'
          msgno      = '81'
        CHANGING
          return_tab = return_tab.

    ELSE.
      lf_found_operations = abap_true.
    ENDIF.

    CHECK lf_dont_close NE abap_true AND lf_found_operations EQ abap_true.

* all checklist steps saved, close PM Order.
    ls_bapi_methods-refnumber = 1.
    ls_bapi_methods-objecttype = 'HEADER'.
    ls_bapi_methods-method = 'TECHNICALCOMPLETE'.
    ls_bapi_methods-objectkey = pm_order.
    APPEND ls_bapi_methods TO lt_bapi_methods.
    CLEAR ls_bapi_methods.

    ls_bapi_methods-refnumber = 1.
    ls_bapi_methods-method = 'SAVE'.
    APPEND ls_bapi_methods TO lt_bapi_methods.

    ls_maint_header-orderid = pm_order.
    APPEND ls_maint_header TO lt_maint_header.

    CALL FUNCTION 'BAPI_ALM_ORDER_MAINTAIN'
      TABLES
        it_methods = lt_bapi_methods
        it_header  = lt_maint_header
        return     = lt_ordmaint_ret.

    LOOP AT lt_ordmaint_ret TRANSPORTING NO FIELDS
      WHERE type CA 'AEX'.

      EXIT.
    ENDLOOP.
* send return messages to UI
    IF sy-subrc EQ 0.

      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

      REFRESH return_tab.
      return_tab[] = lt_ordmaint_ret.
    ELSE.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.

      lf_create_notif = abap_true.

    ENDIF.

    CHECK lf_create_notif EQ abap_true.

* Get confirmations
    SELECT *
      FROM afru
    INTO TABLE @DATA(lt_afru)
      WHERE aufnr    EQ @pm_order
        AND werks    EQ @inputobj-werks
        AND stokz    EQ @space
        AND stzhl    EQ @space.

* get notes.
    LOOP AT lt_afru INTO DATA(ls_afru).

      IF ls_afru-ltxa1(5) EQ gc_nok.
        MOVE-CORRESPONDING ls_afru TO ls_notes.
        APPEND ls_notes TO lt_notes.
      ENDIF.

      CLEAR: ls_afru, ls_notes.
    ENDLOOP.

    CHECK lt_notes IS NOT INITIAL.

* get step description
    lt_steps_desc = lt_notes.

    SELECT aufpl
           aplzl
           ltxa1 AS step_desc
    FROM afvc
      INTO CORRESPONDING FIELDS OF TABLE lt_steps_desc
      FOR ALL ENTRIES IN lt_notes
      WHERE aufpl = lt_notes-aufpl
      AND aplzl = lt_notes-aplzl.

    LOOP AT lt_notes ASSIGNING <fs_notes>.

      READ TABLE lt_steps_desc INTO ls_steps_desc WITH KEY  aufpl = <fs_notes>-aufpl
                                                            aplzl = <fs_notes>-aplzl.
      IF sy-subrc EQ 0.
        <fs_notes>-step_desc = ls_steps_desc-step_desc.
      ENDIF.

      CLEAR ls_steps_desc.
    ENDLOOP.

* get equipment
    SELECT SINGLE equnr FROM afih INTO lv_equnr
      WHERE aufnr = pm_order.

* create maintenance notification
    CREATE OBJECT lref_sf_maintenance
      EXPORTING
        initial_refdt = refdt
        input_object  = inputobj.

* get description from SO10 by order type
    IF ls_aufk-auart NE 'ZMLD'.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          id       = 'ST'
          language = sy-langu
          name     = 'Z_SF_NOTIFICATION_FLM'
          object   = 'TEXT'
        TABLES
          lines    = lines.

      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.
    ELSE.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          id       = 'ST'
          language = sy-langu
          name     = 'Z_SF_NOTIFICATION_MLD'
          object   = 'TEXT'
        TABLES
          lines    = lines.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.

    ENDIF.

    READ TABLE lines INTO ls_line INDEX 1.
    lv_description = ls_line-tdline.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        input  = pm_order
      IMPORTING
        output = lv_aufnr.

    CONCATENATE lv_description space lv_aufnr INTO lv_description.

* populate not ok tables.
    LOOP AT lt_notes INTO ls_notes.

      CONCATENATE ls_notes-step_desc ': ' space ls_notes-ltxa1 INTO ls_longtext-text_line. "(40)  + (40) < 132.
      ls_longtext-objtype = 'QMEL'.
      ls_longtext-format_col = '/'.
      APPEND ls_longtext TO lt_longtext.
      CLEAR: ls_notes, ls_longtext.
    ENDLOOP.

    CALL METHOD lref_sf_maintenance->create_maintenance_notif
      EXPORTING
        notif_type    = space
        arbpl         = space
        description   = lv_description
        equipment     = lv_equnr
        breakdown     = abap_false
        commentary    = observations
        not_oks_texts = lt_longtext
      IMPORTING
        return_tab    = return_tab.


  ENDMETHOD.
ENDCLASS.
