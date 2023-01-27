class ZABSF_PP_CL_MAINTENANCE definition
  public
  final
  create public .

public section.

  types:
    TY_NOTOK_TEXTS_TABLE type TABLE OF BAPI2080_NOTFULLTXTI .

  methods CONSTRUCTOR
    importing
      !INITIAL_REFDT type VVDATUM
      !INPUT_OBJECT type ZABSF_PP_S_INPUTOBJECT .
  methods GET_EQUIPMENTS_LIST
    importing
      value(ARBPL) type ARBPL
    exporting
      value(EQUIPMENTS) type ZABSF_PP_T_EQUIPMENT
      value(RETURN_TAB) type BAPIRET2_T .
  methods CREATE_MAINTENANCE_NOTIF
    importing
      value(ARBPL) type ARBPL
      value(DESCRIPTION) type MATNR
      value(EQUIPMENT) type EQUNR
      value(BREAKDOWN) type BOOLE_D optional
      value(COMMENTARY) type STRING
      value(NOTIF_TYPE) type QMART optional
      value(NOT_OKS_TEXTS) type TY_NOTOK_TEXTS_TABLE optional
    exporting
      value(RETURN_TAB) type BAPIRET2_T .
  methods LOOK_FOR_CHECKLIST
    importing
      value(ARBPL) type ARBPL
    changing
      value(CHECKLIST) type BOOLE_D
      value(PM_ORDER) type AUFNR
      value(FIRST_OPERATION) type VORNR .
protected section.
private section.

  data REFDT type VVDATUM .
  data INPUTOBJ type ZABSF_PP_S_INPUTOBJECT .
ENDCLASS.



CLASS ZABSF_PP_CL_MAINTENANCE IMPLEMENTATION.


  method CONSTRUCTOR.

*Ref. Date
  refdt    = initial_refdt.

*App input data
  inputobj = input_object.

  endmethod.


  METHOD create_maintenance_notif.

    CONSTANTS: gc_param_id TYPE zabsf_pp_e_parid VALUE 'NOTIFY_TYPE'.

    DATA: ls_notif_header  TYPE bapi2080_nothdri,
          ls_header_export TYPE bapi2080_nothdre,
          ls_header_save   TYPE bapi2080_nothdre,
          lt_return        TYPE TABLE OF bapiret2,
          lt_return_save   TYPE TABLE OF bapiret2.

    DATA: lt_textline TYPE TABLE OF tdline,
          ls_textline LIKE LINE OF lt_textline,
          lt_longtext TYPE TABLE OF bapi2080_notfulltxti,
          ls_longtext LIKE LINE OF lt_longtext.

    DATA lv_objkey TYPE objkey.


    FIELD-SYMBOLS <fs_longtext> TYPE bapi2080_notfulltxti.

    ls_notif_header-equipment = equipment.
    ls_notif_header-short_text = description.
    ls_notif_header-breakdown = breakdown.

    IF notif_type IS INITIAL.

      SELECT SINGLE parva FROM zabsf_pp032 INTO notif_type
        WHERE werks = inputobj-werks
        AND parid = gc_param_id.

      IF sy-subrc NE 0.
* missing customization - throw error message and leave.
        CALL METHOD zabsf_pp_cl_log=>add_message
          EXPORTING
            msgty      = 'E'
            msgno      = '073'
          CHANGING
            return_tab = return_tab.

        EXIT.
      ENDIF.

    ENDIF.

    CASE breakdown.

      WHEN abap_true.
        ls_notif_header-priority = '1'.

      WHEN   abap_false.
        ls_notif_header-priority = '3'.

      WHEN OTHERS.
        ls_notif_header-priority = '3'.

    ENDCASE.

    CALL FUNCTION 'SOTR_SERV_STRING_TO_TABLE'
      EXPORTING
        text     = commentary
*       FLAG_NO_LINE_BREAKS       = 'X'
*       line_length = 132
*       LANGU    = SY-LANGU
      TABLES
        text_tab = lt_textline.

    APPEND LINES OF not_oks_texts TO lt_longtext.

    LOOP AT lt_textline INTO ls_textline.

      ls_longtext-text_line  =  ls_textline.
      ls_longtext-objtype = 'QMEL'.
      ls_longtext-format_col = '/'.
      APPEND ls_longtext TO lt_longtext.
      CLEAR ls_textline.
    ENDLOOP.

    LOOP AT lt_longtext ASSIGNING <fs_longtext>.
      ADD 1 TO lv_objkey.
      <fs_longtext>-objkey = lv_objkey.

    ENDLOOP.

    CALL FUNCTION 'BAPI_ALM_NOTIF_CREATE'
      EXPORTING
        notif_type         = notif_type
        notifheader        = ls_notif_header
        task_determination = abap_true
      IMPORTING
        notifheader_export = ls_header_export
      TABLES
        longtexts          = lt_longtext
        return             = lt_return.

    LOOP AT lt_return TRANSPORTING NO FIELDS
                WHERE ( type CA 'AEX' ).  " Abort, Error, or Dump
      EXIT.
    ENDLOOP.

    IF sy-subrc EQ 0.

      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      return_tab = lt_return.

    ELSE.

      CALL FUNCTION 'BAPI_ALM_NOTIF_SAVE'
        EXPORTING
          number      = ls_header_export-notif_no
        IMPORTING
          notifheader = ls_header_save
        TABLES
          return      = lt_return_save.

      IF ls_header_save-notif_no IS NOT INITIAL.

        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = abap_true.

* add success message
        CALL METHOD zabsf_pp_cl_log=>add_message
          EXPORTING
            msgty      = 'S'
            msgno      = '070'
            msgv1      = ls_header_save-notif_no
          CHANGING
            return_tab = return_tab.

      ELSE.
        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

        LOOP AT lt_return_save TRANSPORTING NO FIELDS
               WHERE ( type CA 'AEX' ).  " Abort, Error, or Dump
          EXIT.
        ENDLOOP.

        IF sy-subrc EQ 0.
          return_tab = lt_return_save.
        ELSE.

* add error message
          CALL METHOD zabsf_pp_cl_log=>add_message
            EXPORTING
              msgty      = 'E'
              msgno      = '071'
            CHANGING
              return_tab = return_tab.
        ENDIF.
      ENDIF.

    ENDIF.


  ENDMETHOD.


  METHOD get_equipments_list.
*  Structures
    DATA: ls_equipments TYPE zabsf_pp_s_equipment.

*  Variables
    DATA: l_langu TYPE spras.

*  Set local language for user
    l_langu = inputobj-language.

    SET LOCALE LANGUAGE l_langu.

*  Get workcenter objid
    SELECT SINGLE objid
      FROM crhd
      INTO (@DATA(l_objid))
     WHERE arbpl EQ @arbpl
       AND objty EQ 'A'
       AND werks EQ @inputobj-werks.

    IF sy-subrc EQ 0.
*    Get data from database view
      SELECT DISTINCT equnr
        FROM v_equi
        INTO TABLE @DATA(lt_v_equi)
       WHERE ppsid EQ @l_objid
         AND eqtyp EQ 'P'.

*      SORT lt_v_equi BY equnr.
*      DELETE ADJACENT DUPLICATES FROM lt_v_equi COMPARING equnr.

      IF lt_v_equi[] IS NOT INITIAL.
*      Get equipment description
        SELECT equnr, eqktx
          FROM eqkt
          INTO TABLE @DATA(lt_equi_txt)
           FOR ALL ENTRIES IN @lt_v_equi
         WHERE equnr EQ @lt_v_equi-equnr
           AND spras EQ @sy-langu.

*      Get descriptions for alternative language
        IF lt_equi_txt IS INITIAL.
*        Get equipment description
          SELECT SINGLE spras
            FROM ZABSF_PP061
            INTO (@DATA(l_alt_spras))
           WHERE werks      EQ @inputobj-werks
             AND is_default EQ @abap_true.

          IF l_alt_spras IS NOT INITIAL.
*          Get equipment description
            SELECT equnr, eqktx
              FROM eqkt
              INTO TABLE @lt_equi_txt
               FOR ALL ENTRIES IN @lt_v_equi
             WHERE equnr EQ @lt_v_equi-equnr
               AND spras EQ @l_alt_spras.
          ENDIF.
        ENDIF.

        LOOP AT lt_v_equi INTO DATA(ls_v_equi).
          CLEAR: ls_equipments.

*        Equipment number
          ls_equipments-equnr = ls_v_equi-equnr.

*        Read equipment description
          READ TABLE lt_equi_txt INTO DATA(ls_equi_txt) WITH KEY equnr = ls_v_equi-equnr.

          IF sy-subrc EQ 0.
*          Equipment description
            ls_equipments-eqktx = ls_equi_txt-eqktx.
          ENDIF.

          APPEND ls_equipments TO equipments.
        ENDLOOP.
*      ELSE.
**      Add message if no data found
*        CALL METHOD zcl_lp_pp_sf_log=>add_message
*          EXPORTING
*            msgty      = 'E'
*            msgno      = '066'
*          CHANGING
*            return_tab = return_tab.
      ENDIF.
    ELSE.
*    Add message for invalid workcenter
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'E'
          msgno      = '066'
        CHANGING
          return_tab = return_tab.
    ENDIF.
  ENDMETHOD.


  METHOD look_for_checklist.

    CONSTANTS: lc_flm_shifts TYPE zabsf_pp_e_parid VALUE 'FLM_VS'.

    TYPES: BEGIN OF ty_maint_orders,
             aufnr TYPE aufnr,
             aufpl TYPE co_aufpl,
           END OF ty_maint_orders.

    TYPES: BEGIN OF ty_shifts,
             shiftid TYPE   zabsf_pp_e_shiftid,
           END OF ty_shifts.

    TYPES: BEGIN OF ty_order_operations,
             aufpl     TYPE co_aufpl,
             vornr     TYPE vornr,
             sumnr     TYPE sumkntnr,
             int_vornr TYPE i,
           END OF ty_order_operations.

    DATA: lt_maint_orders     TYPE TABLE OF ty_maint_orders,
          ls_maint_orders     LIKE LINE OF lt_maint_orders,
          lt_afvc             TYPE TABLE OF afvc,
          ls_afvc             LIKE LINE OF lt_afvc,
          lt_main_operations  TYPE TABLE OF afvc,
          ls_main_operations  LIKE LINE OF lt_main_operations,
          lt_order_operations TYPE TABLE OF ty_order_operations,
          ls_order_operations LIKE LINE OF lt_order_operations,
          lt_shifts           TYPE TABLE OF ty_shifts.

    DATA: lv_objid            TYPE cr_objid,
          lv_shiftid          TYPE zabsf_pp_e_shiftid,
          lv_parva            TYPE xuvalue,
          lf_go_for_checklist TYPE boole_d.

    DATA: ls_v_equi TYPE v_equi.


* get shift from z table
    SELECT SINGLE shiftid FROM zabsf_pp052 INTO lv_shiftid
      WHERE areaid = inputobj-areaid
      AND oprid = inputobj-oprid.
    IF sy-subrc EQ 0.

* get FLM shifts
      SELECT SINGLE parva FROM zabsf_pp032 INTO lv_parva
        WHERE werks = inputobj-werks
        AND parid = lc_flm_shifts.

      IF sy-subrc EQ 0.
        SPLIT lv_parva AT ',' INTO TABLE lt_shifts.

        LOOP AT lt_shifts TRANSPORTING NO FIELDS
          WHERE shiftid = lv_shiftid.

          lf_go_for_checklist = abap_true.
          EXIT.
        ENDLOOP.

      ENDIF.
    ENDIF.

* continue only if shift requires validation
    CHECK lf_go_for_checklist EQ abap_true.


* get workcenter objid
    SELECT SINGLE objid FROM crhd INTO lv_objid
      WHERE arbpl = arbpl
      AND objty = 'A'
      AND werks = inputobj-werks.

* get sup equipment
    SELECT SINGLE * FROM v_equi INTO ls_v_equi
      WHERE ppsid = lv_objid
      AND hequi = ''
      AND owner = ''.

* get all PM orders
    SELECT a~aufnr b~aufpl FROM aufk AS a
      INNER JOIN afko AS b ON a~aufnr = b~aufnr
      INNER JOIN afih AS c ON b~aufnr = c~aufnr
    INTO CORRESPONDING FIELDS OF TABLE lt_maint_orders
      WHERE a~auart = 'ZFLM'
      AND a~phas1 = abap_true
      AND a~phas2 = abap_false
      AND a~phas3 = abap_false
      AND b~gstrp = sy-datum
      AND c~equnr = ls_v_equi-equnr.
    IF sy-subrc EQ 0.
      checklist = abap_true.
    ELSE.
      checklist = abap_false.
    ENDIF.

    SORT lt_maint_orders BY aufnr ASCENDING.

    READ TABLE lt_maint_orders INTO ls_maint_orders INDEX 1.

* get operations.
    SELECT * FROM afvc INTO TABLE lt_afvc
      WHERE aufpl = ls_maint_orders-aufpl
      AND sumnr = ''.

    LOOP AT lt_afvc INTO ls_afvc.

      MOVE-CORRESPONDING ls_afvc TO ls_order_operations.

      CALL FUNCTION 'CHAR_NUMC_CONVERSION'
        EXPORTING
          input   = ls_afvc-vornr
        IMPORTING
          numcstr = ls_order_operations-int_vornr.

      APPEND ls_order_operations TO lt_order_operations.
      CLEAR: ls_afvc, ls_order_operations.

    ENDLOOP.

    SORT lt_order_operations BY int_vornr ASCENDING.

    READ TABLE lt_order_operations INTO ls_order_operations INDEX 1.

    pm_order = ls_maint_orders-aufnr.
    first_operation  = ls_order_operations-vornr.

  ENDMETHOD.
ENDCLASS.
