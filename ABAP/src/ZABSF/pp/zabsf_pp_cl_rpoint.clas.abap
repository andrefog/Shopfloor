class ZABSF_PP_CL_RPOINT definition
  public
  final
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !INITIAL_REFDT type VVDATUM
      !INPUT_OBJECT type ZABSF_PP_S_INPUTOBJECT .
  methods GET_RPOINT_DETAIL
    importing
      !HNAME type CR_HNAME
      !RPOINT type ZABSF_PP_E_RPOINT
    changing
      !RPOINT_DETAIL type ZABSF_PP_S_RPOINT_DETAIL
      !RETURN_TAB type BAPIRET2_T .
  methods GET_MATERIAL_RPOINT
    importing
      !HNAME type CR_HNAME
      !RPOINT type ZABSF_PP_E_RPOINT
    changing
      !MAT_PLAN_TAB type ZABSF_PP_T_MAT_PLAN
      !MAT_NPLAN_TAB type ZABSF_PP_T_MAT_PLAN
      !RETURN_TAB type BAPIRET2_T .
  methods GET_PASS_MATERIAL
    importing
      !HNAME type CR_HNAME
      !RPOINT type ZABSF_PP_E_RPOINT
      !MATNR type MATNR
      !GERNR type GERNR
    changing
      !PASSNUMBER type ZABSF_PP_E_PASSNUMBER
      !DEFECTS_TAB type ZABSF_PP_T_DEFECTS
      !PASSAGE_TAB type ZABSF_PP_T_PASSAGE
      !RETURN_TAB type BAPIRET2_T .
  methods SET_REFDT
    importing
      !NEW_REFDT type VVDATUM .
  methods SET_PASS_MATERIAL
    importing
      !HNAME type CR_HNAME
      !RPOINT type ZABSF_PP_E_RPOINT
      !MATNR type MATNR
      !GERNR type GERNR
      !PASSNUMBER type ZABSF_PP_E_PASSNUMBER
      !FLAG_DEF type ZABSF_PP_E_FLAG_DEF
      !DEFECTID type ZABSF_PP_E_DEFECTID optional
    changing
      !RETURN_TAB type BAPIRET2_T .
  methods SET_QUALITY_RPOINT
    importing
      !RPOINT type ZABSF_PP_E_RPOINT
      !MATNR type MATNR
      !REWORK_TAB type ZABSF_PP_T_REWORK optional
      !SCRAP_QTY type RU_XMNGA optional
      !GRUND type CO_AGRND optional
    changing
      !RETURN_TAB type BAPIRET2_T .
  methods ADD_REM_MATNR
    importing
      !HNAME type CR_HNAME
      !RPOINT type ZABSF_PP_E_RPOINT
      !MATNR type MATNR
      !ADD_REM type ZABSF_PP_E_ADD_REM
      !VORNR type VORNR
    changing
      !RETURN_TAB type BAPIRET2_T .
  methods GET_DEFECTS_RPOINT
    importing
      !RPOINT type ZABSF_PP_E_RPOINT
      !REASONTYP type ZABSF_PP_E_REASONTYP
    changing
      !DEFECTS_TAB type ZABSF_PP_T_DEFECTS optional
      !REASON_TAB type ZABSF_PP_T_REASON optional
      !RETURN_TAB type BAPIRET2_T .
  methods SET_SCRAP_RPOINT
    importing
      !RPOINT type ZABSF_PP_E_RPOINT
      !MATNR type MATNR
      !PLANORDER type PLNUM optional
      !REFDT type DATUM
      !SCRAP_TAB type ZABSF_PP_T_SCRAP
      !IS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
    changing
      !RETURN_TAB type BAPIRET2_T .
protected section.
private section.

  data REFDT type VVDATUM .
  data INPUTOBJ type ZABSF_PP_S_INPUTOBJECT .
  constants C_DOMAIN type DD01L-DOMNAME value 'ZABSF_PP_D_FLAG_DEF' ##NO_TEXT.
  constants C_REASONTYP type ZABSF_PP_E_REASONTYP value 'D' ##NO_TEXT.
ENDCLASS.



CLASS ZABSF_PP_CL_RPOINT IMPLEMENTATION.


METHOD add_rem_matnr.
  DATA ls_zabsf_pp048 TYPE zabsf_pp048.

*Check if material unplanned has been added already
  SELECT SINGLE *
    FROM zabsf_pp048
    INTO CORRESPONDING FIELDS OF ls_zabsf_pp048
   WHERE areaid EQ inputobj-areaid
     AND werks  EQ inputobj-werks
     AND hname  EQ hname
     AND rpoint EQ rpoint
     AND vornr  EQ vornr
     AND matnr  EQ matnr.

  IF sy-subrc NE 0.
    IF add_rem EQ 'A'.
      CLEAR ls_zabsf_pp048.

*    Add material not planned
      ls_zabsf_pp048-areaid = inputobj-areaid.
      ls_zabsf_pp048-hname = hname.
      ls_zabsf_pp048-werks = inputobj-werks.
      ls_zabsf_pp048-rpoint = rpoint.
      ls_zabsf_pp048-vornr = vornr.
      ls_zabsf_pp048-matnr = matnr.

      INSERT INTO zabsf_pp048 VALUES ls_zabsf_pp048.

      IF sy-subrc EQ 0.
*      Operation completed successfully
        CALL METHOD zabsf_pp_cl_log=>add_message
          EXPORTING
            msgty      = 'S'
            msgno      = '013'
          CHANGING
            return_tab = return_tab.
      ELSE.
*      Operation not completed successfully
        CALL METHOD zabsf_pp_cl_log=>add_message
          EXPORTING
            msgty      = 'E'
            msgno      = '012'
          CHANGING
            return_tab = return_tab.
      ENDIF.
    ENDIF.
  ELSE.
    IF add_rem EQ 'R'.
      DELETE zabsf_pp048 FROM ls_zabsf_pp048.

      IF sy-subrc EQ 0.
*      Operation completed successfully
        CALL METHOD zabsf_pp_cl_log=>add_message
          EXPORTING
            msgty      = 'S'
            msgno      = '013'
          CHANGING
            return_tab = return_tab.
      ELSE.
*      Operation not completed successfully
        CALL METHOD zabsf_pp_cl_log=>add_message
          EXPORTING
            msgty      = 'E'
            msgno      = '012'
          CHANGING
            return_tab = return_tab.
      ENDIF.
    ELSE.
*    Material unplnanned has beeb added already
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'I'
          msgno      = '049'
        CHANGING
          return_tab = return_tab.
    ENDIF.
  ENDIF.
ENDMETHOD.


METHOD CONSTRUCTOR.
*Ref. Date
  refdt    = initial_refdt.

*App input data
  inputobj = input_object.
ENDMETHOD.


METHOD get_defects_rpoint.
  DATA: lt_zabsf_pp026 TYPE TABLE OF zabsf_pp026.

  DATA: ls_zabsf_pp026 TYPE zabsf_pp026.

  FIELD-SYMBOLS <fs_defects> TYPE zabsf_pp_s_defects.

  IF reasontyp EQ 'D'.
*  Get defects
    SELECT zabsf_pp026~defectid zabsf_pp026_t~defect_desc
      INTO CORRESPONDING FIELDS OF TABLE defects_tab
      FROM zabsf_pp026 AS zabsf_pp026
     INNER JOIN zabsf_pp026_t AS zabsf_pp026_t
        ON zabsf_pp026_t~arbpl EQ zabsf_pp026~arbpl
       AND zabsf_pp026_t~defectid EQ zabsf_pp026~defectid
     WHERE zabsf_pp026~areaid EQ inputobj-areaid
       AND zabsf_pp026~werks  EQ inputobj-werks
       AND zabsf_pp026~arbpl  EQ rpoint.

    IF sy-subrc EQ 0.
*    Operation completed successfully
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'S'
          msgno      = '013'
        CHANGING
          return_tab = return_tab.
    ELSE.
*    No defects found
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'E'
          msgno      = '032'
          msgv1      = inputobj-areaid
          msgv2      = rpoint
          msgv3      = inputobj-werks
        CHANGING
          return_tab = return_tab.
    ENDIF.
  ENDIF.

  IF reasontyp EQ 'C'.
*  Reason for variances in completion confirmations
    SELECT grund grdtx
      FROM trugt
      INTO CORRESPONDING FIELDS OF TABLE reason_tab
      WHERE werks EQ inputobj-werks
        AND spras EQ sy-langu.

    IF sy-subrc EQ 0.
*    Operation completed successfully
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'S'
          msgno      = '013'
        CHANGING
          return_tab = return_tab.
    ELSE.
*    No reason found
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'E'
          msgno      = '033'
          msgv1      = inputobj-werks
        CHANGING
          return_tab = return_tab.
    ENDIF.
  ENDIF.
ENDMETHOD.


METHOD get_material_rpoint.
  DATA: lt_zabsf_pp042 TYPE TABLE OF zabsf_pp042,
        lt_plaf        TYPE TABLE OF plaf,
        lt_mkal        TYPE TABLE OF mkal,
        lt_plpo        TYPE TABLE OF plpo,
        lt_makt        TYPE TABLE OF makt,
        lt_afko        TYPE TABLE OF afko,
        lt_pzpsy       TYPE TABLE OF pzps,
        lt_pzpsx       TYPE TABLE OF pzps,
        lt_pkosa       TYPE TABLE OF pkosa_proc_a,
        lt_aufk        TYPE TABLE OF aufk.

  DATA: ls_mat_plan	   TYPE zabsf_pp_s_mat_plan,
        ls_zabsf_pp042 TYPE zabsf_pp042,
        ls_plaf        TYPE plaf,
        ls_mkal        TYPE mkal,
        ls_plpo        TYPE plpo,
        ls_makt        TYPE makt,
        ls_afko        TYPE afko,
        ls_pzpsy       TYPE pzps,
        ls_pzpsx       TYPE pzps,
        ls_zabsf_pp048 TYPE zabsf_pp048,
        ld_week        TYPE scal-week,
        ld_first_day   TYPE sy-datum,
        ld_day_week    TYPE sy-datum,
        ld_last_day    TYPE sy-datum,
        ld_date        TYPE scal-date,
        ld_objid       TYPE cr_objid,
        flag_plan      TYPE c,
        ld_days        TYPE vtbbewe-atage.

  CONSTANTS: c_correct_option      TYPE scal-indicator VALUE '-',
             c_factory_calendar_id TYPE scal-fcalid    VALUE 'PT',
             c_message_type        TYPE sy-msgty       VALUE 'S'.

  REFRESH: lt_zabsf_pp042,
           lt_plaf,
           lt_mkal,
           lt_plpo,
           lt_makt,
           lt_pkosa,
           lt_aufk,
           lt_afko.

  CLEAR: ls_mat_plan,
         ls_zabsf_pp042,
         ls_plaf,
         ls_mkal,
         ls_plpo,
         ls_makt,
         ld_week,
         ld_first_day,
         ld_last_day,
         ld_day_week,
         ld_date,
         ld_objid,
         flag_plan,
         ld_days.

*Get all  planned materials
  SELECT *
    FROM zabsf_pp042
    INTO CORRESPONDING FIELDS OF TABLE lt_zabsf_pp042
    WHERE areaid EQ inputobj-areaid
      AND werks  EQ inputobj-werks
      AND hname  EQ hname.

  IF lt_zabsf_pp042[] IS NOT INITIAL.
*  Get week
    CALL FUNCTION 'GET_WEEK_INFO_BASED_ON_DATE'
      EXPORTING
        date   = refdt
      IMPORTING
        week   = ld_week
        monday = ld_first_day
        sunday = ld_last_day.

    IF sy-subrc EQ 0.
*    Get last working day of week
      CALL FUNCTION 'DATE_CONVERT_TO_FACTORYDATE'
        EXPORTING
          correct_option               = c_correct_option
          date                         = ld_last_day
          factory_calendar_id          = c_factory_calendar_id
        IMPORTING
          date                         = ld_date
        EXCEPTIONS
          calendar_buffer_not_loadable = 1
          correct_option_invalid       = 2
          date_after_range             = 3
          date_before_range            = 4
          date_invalid                 = 5
          factory_calendar_not_found   = 6
          OTHERS                       = 7.

      IF sy-subrc <> 0.
        CALL METHOD zabsf_pp_cl_log=>add_message
          EXPORTING
            msgid      = sy-msgid
            msgty      = sy-msgty
            msgno      = sy-msgno
          CHANGING
            return_tab = return_tab.
      ENDIF.


      IF ld_first_day IS NOT INITIAL AND ld_date IS NOT INITIAL.
**      Get number OF days OF week
*        CALL FUNCTION 'FIMA_DAYS_AND_MONTHS_AND_YEARS'
*          EXPORTING
*            i_date_from = ld_first_day
*            i_date_to   = ld_date
*          IMPORTING
*            e_days      = ld_days.
*
*        IF ld_days IS NOT INITIAL.
*          ADD 1 TO ld_days.
*        ENDIF.
*        ld_first_day = sy-datum.
        ld_day_week = sy-datum.

        WHILE ld_day_week LE ld_date.

          CALL FUNCTION 'DATE_CHECK_WORKINGDAY'
            EXPORTING
              date                = ld_day_week
              factory_calendar_id = c_factory_calendar_id
              message_type        = c_message_type
            EXCEPTIONS
              date_no_workingday  = 4.
          IF sy-subrc <> 0.
            CONTINUE.
          ELSE.
            ADD 1 TO ld_days.
          ENDIF.

          CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
            EXPORTING
              date      = ld_day_week
              days      = '1'
              months    = '00'
              signum    = '+'
              years     = '00'
            IMPORTING
              calc_date = ld_day_week.
        ENDWHILE.

        IF ld_days EQ 0.
          ld_days = 1.
        ENDIF.

*      Get all planned orders for planned material
        SELECT *
          FROM plaf
          INTO CORRESPONDING FIELDS OF TABLE lt_plaf
           FOR ALL ENTRIES IN lt_zabsf_pp042
         WHERE matnr EQ lt_zabsf_pp042-matnr
           AND rsnum NE space
           AND pedtr LE ld_date.
*           AND psttr LE ld_date.
*           AND ( psttr GE ld_first_day AND
*                 psttr LE ld_date ).
      ENDIF.

*    Get Task List Type and Key for Task List Group
      SELECT *
        FROM mkal
        INTO CORRESPONDING FIELDS OF TABLE lt_mkal
         FOR ALL ENTRIES IN lt_zabsf_pp042
       WHERE matnr EQ lt_zabsf_pp042-matnr
         AND werks EQ inputobj-werks
         AND adatu LE refdt
         AND bdatu GE refdt.

*    Get material description
      SELECT *
        FROM makt
        INTO CORRESPONDING FIELDS OF TABLE lt_makt
         FOR ALL ENTRIES IN lt_zabsf_pp042
       WHERE matnr EQ lt_zabsf_pp042-matnr
         AND spras EQ sy-langu.

      IF lt_mkal[] IS NOT INITIAL.
*      Get Production Process
        SELECT *
          FROM pkosa_proc_a
          INTO CORRESPONDING FIELDS OF TABLE lt_pkosa
           FOR ALL ENTRIES IN lt_mkal
         WHERE werks    EQ inputobj-werks
           AND matnr    EQ lt_mkal-matnr
           AND verid_nd EQ lt_mkal-verid.

*      Get Production Process
        SELECT *
          FROM aufk
          INTO CORRESPONDING FIELDS OF TABLE lt_aufk
           FOR ALL ENTRIES IN lt_pkosa
         WHERE werks  EQ inputobj-werks
           AND procnr EQ lt_pkosa-procnr
           AND loekz  EQ space.

*      Get order associated to material
        SELECT *
          FROM afko
          INTO CORRESPONDING FIELDS OF TABLE lt_afko
           FOR ALL ENTRIES IN lt_aufk
         WHERE aufnr EQ lt_aufk-aufnr.

**      Get order associated to material
*        SELECT *
*          FROM afko
*          INTO CORRESPONDING FIELDS OF TABLE lt_afko
*           FOR ALL ENTRIES IN lt_mkal
*         WHERE plnbez EQ lt_mkal-matnr
*           AND plnty EQ lt_mkal-plnty
*           AND plnnr EQ lt_mkal-plnnr.

*      Get objid of report point
        SELECT SINGLE objid
          FROM crhd
          INTO ld_objid
         WHERE arbpl EQ rpoint
           AND werks EQ inputobj-werks
           AND objty EQ 'A'.

*      Get operation and quantity yield
        SELECT *
          INTO CORRESPONDING FIELDS OF TABLE lt_plpo
          FROM plpo AS plpo
         INNER JOIN t430 AS t430
            ON t430~steus EQ plpo~steus
*           AND t430~ruek EQ '1'  "Código original Shopfloor
         INNER JOIN plas AS plas
            ON plas~plnty EQ plpo~plnty
           AND plas~plnnr EQ plpo~plnnr
           AND plas~plnkn EQ plpo~plnkn
           AND plas~zaehl EQ plpo~zaehl
           FOR ALL ENTRIES IN lt_mkal
         WHERE plpo~werks EQ inputobj-werks
           AND plpo~arbid EQ ld_objid
           AND plpo~plnty EQ lt_mkal-plnty
           AND plpo~plnnr EQ lt_mkal-plnnr
           AND plas~datuv LE sy-datum
           AND plas~loekz EQ space
* Begin JOL - 22/11/2022
           AND ( t430~ruek EQ '1' OR
                 t430~ruek EQ space ). "Mostar chaves de controlo FPY0 e ZPSU
* End JOL - 22/11/2022
      ENDIF.

      LOOP AT lt_zabsf_pp042 INTO ls_zabsf_pp042.
        CLEAR: ls_mat_plan,
               ls_plaf,
               ls_mkal,
               ls_plpo,
               ls_afko,
               ls_zabsf_pp048,
               flag_plan.

*      Material
        ls_mat_plan-matnr = ls_zabsf_pp042-matnr.
*      Material description
        READ TABLE lt_makt INTO ls_makt WITH KEY matnr = ls_mat_plan-matnr.

        IF sy-subrc EQ 0.
          ls_mat_plan-maktx = ls_makt-maktx.
        ENDIF.

*      Unit
        ls_mat_plan-gmein = ls_zabsf_pp042-gmein.
*      Passage
        IF ls_zabsf_pp042-passage IS NOT INITIAL.
          ls_mat_plan-passage = ls_zabsf_pp042-passage.
        ENDIF.

*      Sum quantity planned
        LOOP AT lt_plaf INTO ls_plaf WHERE matnr EQ ls_mat_plan-matnr.
          ADD ls_plaf-gsmng TO ls_mat_plan-gsmng.
* Begin JOL - 22/11/2022 - "Get previous planned orders"
          IF ls_plaf-pedtr BETWEEN ld_first_day AND ld_last_day.
            ADD ls_plaf-gsmng TO ls_mat_plan-gsmngweek.
          ELSE.
            ADD ls_plaf-gsmng TO ls_mat_plan-gsmngdelay.
          ENDIF.
* End JOL - 22/11/2022
          CLEAR ls_plaf.
*        For add planned material
          flag_plan = 'X'.
        ENDLOOP.

*      Takt for Material
        IF ls_mat_plan-gsmng IS NOT INITIAL AND ld_days IS NOT INITIAL.
          ls_mat_plan-amount = ls_mat_plan-gsmng / ld_days.
*        ELSE.
*          ls_mat_plan-amount = ls_ZABSF_PP042-takt.
        ENDIF.

* Begin JOL - 22/11/2022 - Get stock from warehouse 0070 and 0079
*      Stock 0070
        SELECT SINGLE labst
          FROM mard
          INTO @ls_mat_plan-stk0070
          WHERE matnr  EQ @ls_mat_plan-matnr
            AND werks  EQ @inputobj-werks
            AND lgort  EQ '0070'.
*      Stock 0079
        SELECT SINGLE labst
           FROM mard
           INTO @ls_mat_plan-stk0079
          WHERE matnr  EQ @ls_mat_plan-matnr
            AND werks  EQ @inputobj-werks
            AND lgort  EQ '0079'.
* End JOL - 22/11/2022

* Get operation and operation description
        READ TABLE lt_mkal INTO ls_mkal WITH KEY matnr = ls_mat_plan-matnr.

        IF sy-subrc EQ 0.
*          READ TABLE lt_plpo INTO ls_plpo WITH KEY plnty = ls_mkal-plnty
*                                                   plnnr = ls_mkal-plnnr.
          DATA(lv_length) = ''.

          LOOP AT lt_plpo INTO ls_plpo WHERE plnty EQ ls_mkal-plnty
                                         AND plnnr EQ ls_mkal-plnnr.
            CLEAR: lv_length.
*          IF sy-subrc EQ 0.
*          Operation
            ls_mat_plan-vornr = ls_plpo-vornr.
* Begin JOL - 22/12/2022 - delete leading zeros "ltxa1" field.
*          Operation Description
            lv_length = strlen( ls_plpo-ltxa1 ).

            IF lv_length ne 2.
              CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
                EXPORTING
                  input  = ls_plpo-ltxa1
                IMPORTING
                  output = ls_plpo-ltxa1.
            ENDIF.

            ls_mat_plan-ltxa1 =  ls_plpo-ltxa1.
* Begin JOL - 22/12/2022
*          ENDIF.

*          Get all operation of cost collector
            CALL FUNCTION 'RM_PLPO_STRUCTURE_GET_ALL'
              EXPORTING
                i_group_counter  = ls_mkal-alnal
                i_group_key      = ls_mkal-plnnr
                i_refdate        = refdt
                i_task_list_type = ls_mkal-plnty
              TABLES
                pzpstab          = lt_pzpsy
              EXCEPTIONS
                no_records       = 01.

*          Delete operation not equal Indicator for Reporting Point/Milestone Operation
            DELETE lt_pzpsy WHERE kzzpk EQ space.

*          Get order
            READ TABLE lt_afko INTO ls_afko WITH KEY plnbez = ls_mat_plan-matnr.

            IF sy-subrc EQ 0.
*            Get quantity yield
              SELECT SUM( lmnga )
                FROM afru
                INTO ls_mat_plan-lmnga
               WHERE rueck EQ ls_afko-rueck
                 AND aufnr EQ ls_afko-aufnr
                 AND vornr EQ ls_plpo-vornr
                 AND budat EQ refdt
                 AND stokz EQ space
                 AND stzhl EQ space.

*            Get quantity yield for week
              SELECT SUM( lmnga )
                FROM afru
                INTO ls_mat_plan-lmngasm
               WHERE rueck EQ ls_afko-rueck
                 AND aufnr EQ ls_afko-aufnr
                 AND vornr EQ ls_plpo-vornr
                 AND ( budat LE ld_date AND
                       budat GE ld_first_day )
                 AND stokz EQ space
                 AND stzhl EQ space.

*            Get quantity yield of preview reporting point
              CALL FUNCTION 'RM_CPZP_READ'
                EXPORTING
*                 i_safnr      = aufnr
                  i_pkosa      = ls_afko-aufnr
                  i_verid      = ls_mkal-verid
                  i_datum      = refdt
                TABLES
                  e_pzps       = lt_pzpsx
                EXCEPTIONS
                  data_in_pzpp = 1
                  not_found    = 2
                  wrong_input  = 3
                  date_error   = 4
                  OTHERS       = 5.

              LOOP AT lt_pzpsy INTO ls_pzpsy WHERE vorne LT ls_plpo-vornr.
                READ TABLE lt_pzpsx INTO ls_pzpsx WITH KEY vorne = ls_pzpsy-vorne.

                IF sy-subrc EQ 0.
                  ls_mat_plan-qtdrpoint = ls_pzpsx-lmvrg.
                  EXIT.
                ENDIF.
              ENDLOOP.
            ENDIF.
*        ENDIF.

            CLEAR ls_zabsf_pp048.

*          Check if exist material unplanned was atributed to area
            SELECT SINGLE *
              FROM zabsf_pp048
              INTO CORRESPONDING FIELDS OF ls_zabsf_pp048
             WHERE areaid EQ inputobj-areaid
               AND werks  EQ inputobj-werks
               AND hname  EQ hname
               AND matnr  EQ ls_mat_plan-matnr
               AND rpoint EQ rpoint
               AND vornr  EQ ls_mat_plan-vornr.

            IF flag_plan IS NOT INITIAL.
*            Planned Material
              APPEND ls_mat_plan TO mat_plan_tab.

              IF ls_zabsf_pp048 IS NOT INITIAL.
                DELETE zabsf_pp048 FROM ls_zabsf_pp048.
              ENDIF.
            ELSE.
*            Unplanned Material
              APPEND ls_mat_plan TO mat_nplan_tab.

              IF ls_zabsf_pp048 IS NOT INITIAL.
                DELETE mat_nplan_tab WHERE matnr EQ ls_zabsf_pp048-matnr.

*                CLEAR: ls_mat_plan-lmnga,
*                       ls_mat_plan-lmngasm.

                APPEND ls_mat_plan TO mat_plan_tab.
              ENDIF.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ELSE.
*  No data found
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'E'
        msgno      = '46'
        msgv1      = hname
        msgv2      = rpoint
      CHANGING
        return_tab = return_tab.
  ENDIF.
ENDMETHOD.


METHOD get_pass_material.
  DATA: lt_zabsf_pp047 TYPE TABLE OF zabsf_pp047.

  DATA: ls_zabsf_pp047 TYPE zabsf_pp047,
        ls_passage     TYPE zabsf_pp_s_passage,
        lines          TYPE i.

  DATA lref_sf_defect TYPE REF TO zabsf_pp_cl_rework.

  REFRESH lt_zabsf_pp047.

  CLEAR: ls_zabsf_pp047,
         lines.

  IF rpoint IS NOT INITIAL AND matnr IS NOT INITIAL AND gernr IS NOT INITIAL.

*  Create object of class defect
    CREATE OBJECT lref_sf_defect
      EXPORTING
        initial_refdt = refdt
        input_object  = inputobj.

*  Get details of passage
    SELECT *
      FROM zabsf_pp047
      INTO CORRESPONDING FIELDS OF TABLE lt_zabsf_pp047
     WHERE areaid EQ inputobj-areaid
       AND rpoint EQ rpoint
       AND hname EQ hname
       AND matnr EQ matnr
       AND gernr EQ gernr.

    IF lt_zabsf_pp047[] IS NOT INITIAL.
      LOOP AT lt_zabsf_pp047 INTO ls_zabsf_pp047.
        CLEAR ls_passage.

*      Passage number
        ls_passage-passnumber = ls_zabsf_pp047-passnumber.
*      Description for defect flag
        ls_passage-result_def = ls_zabsf_pp047-result_def.
*      Defect description
        ls_passage-defect_desc = ls_zabsf_pp047-defect_desc.

        APPEND ls_passage TO passage_tab.
      ENDLOOP.

*    Get number passage saved in database
      DESCRIBE TABLE lt_zabsf_pp047 LINES lines.

*    Add 1 lo lines, this mean the next regist for passage
      IF lines NE 0.
        passnumber = lines + 1.
      ENDIF.
    ELSE.
*    No data found
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'I'
          msgno      = '018'
        CHANGING
          return_tab = return_tab.
    ENDIF.

    IF passnumber IS INITIAL.
      passnumber = 1.
    ENDIF.
*  Get defect
    CALL METHOD lref_sf_defect->get_defects
      EXPORTING
        arbpl       = rpoint
        reasontyp   = c_reasontyp
      CHANGING
        defects_tab = defects_tab
        return_tab  = return_tab.

  ELSE.
*  Operation not completed successfully
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'E'
        msgno      = '012'
      CHANGING
        return_tab = return_tab.
  ENDIF.
ENDMETHOD.


METHOD get_rpoint_detail.
  DATA: lref_sf_status   TYPE REF TO zabsf_pp_cl_status,
        lref_sf_operator TYPE REF TO zif_absf_pp_operator,
        lref_sf_prodord  TYPE REF TO zabsf_pp_cl_prdord.

  DATA: ls_mat_plan TYPE zabsf_pp_s_mat_plan,
        ld_objid    TYPE cr_objid,
        ld_class    TYPE recaimplclname,
        ld_shiftid  TYPE zabsf_pp_e_shiftid.

  CLEAR: ls_mat_plan,
         ld_objid,
         ld_class,
         ld_shiftid.

  TRANSLATE inputobj-oprid TO UPPER CASE.

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

*Hierarchy Name
  rpoint_detail-hname = hname.

*Report point name
  rpoint_detail-rpoint = rpoint.

*Get expiration date of workcenter
  SELECT SINGLE endda objid
    FROM crhd
    INTO (rpoint_detail-endda, ld_objid)
    WHERE arbpl EQ rpoint
      AND werks EQ inputobj-werks.

*Get description of workcenter
  SELECT SINGLE ktext
    FROM crtx
    INTO rpoint_detail-ktext
   WHERE objty EQ 'A'
     AND objid EQ ld_objid
     AND spras EQ sy-langu.

  IF rpoint_detail IS NOT INITIAL.
*  Create object of class status
    CREATE OBJECT lref_sf_status
      EXPORTING
        initial_refdt = refdt
        input_object  = inputobj.

*  Create object of class order
    CREATE OBJECT lref_sf_prodord
      EXPORTING
        initial_refdt = refdt
        input_object  = inputobj.

*  Get class of interface
    SELECT SINGLE imp_clname
        FROM zabsf_pp003
        INTO ld_class
       WHERE werks EQ inputobj-werks
         AND id_class EQ '3'
         AND endda GE refdt
         AND begda LE refdt.

    TRY .
*      Create object of class operator
        CREATE OBJECT lref_sf_operator TYPE (ld_class)
          EXPORTING
            initial_refdt = refdt
            input_object  = inputobj.

      CATCH cx_sy_create_object_error.
*      No data for object in customizing table
        CALL METHOD zabsf_pp_cl_log=>add_message
          EXPORTING
            msgty      = 'E'
            msgno      = '019'
            msgv1      = ld_class
          CHANGING
            return_tab = return_tab.

        EXIT.
    ENDTRY.

*  Get material for report point
    CALL METHOD me->get_material_rpoint
      EXPORTING
        hname         = hname
        rpoint        = rpoint
      CHANGING
        mat_plan_tab  = rpoint_detail-mat_plan_tab
        mat_nplan_tab = rpoint_detail-mat_nplan_tab
        return_tab    = return_tab.

*  Get takt for area and unit
    SELECT SINGLE takt gmein
      FROM zabsf_pp044
      INTO (rpoint_detail-takt, rpoint_detail-gmein)
     WHERE areaid EQ inputobj-areaid
       AND werks  EQ inputobj-werks
       AND hname  EQ hname
       AND rpoint EQ rpoint.

*  Get total of confirmed yield and quantity for report point
    LOOP AT rpoint_detail-mat_plan_tab INTO ls_mat_plan.
*    Confirmed yield
      ADD ls_mat_plan-lmnga TO rpoint_detail-lmnga.
*    Quantity planned
      ADD ls_mat_plan-gsmng TO rpoint_detail-gsmng.
*    Confirmed yield for week
      ADD ls_mat_plan-lmngasm TO rpoint_detail-lmngasm.
    ENDLOOP.

*  Get current status of Workcenter
    CALL METHOD lref_sf_status->status_object
      EXPORTING
        arbpl       = rpoint
        werks       = inputobj-werks
        objty       = 'CA'
        method      = 'G'
      CHANGING
        status_out  = rpoint_detail-status
        status_desc = rpoint_detail-status_desc
        return_tab  = return_tab.

*  Get operator of Workcenter
    CALL METHOD lref_sf_operator->get_operator_wrkctr
      EXPORTING
        arbpl           = rpoint
      CHANGING
        oper_wrkctr_tab = rpoint_detail-oper_rpoint_tab
        return_tab      = return_tab.

*  Get operator active in Workcenter
    CALL METHOD lref_sf_operator->get_operator_rpoint
      EXPORTING
        rpoint       = rpoint
      CHANGING
        operator_tab = rpoint_detail-opr_arpoint_tab
        return_tab   = return_tab.

*    LOOP AT rpoint_detail-opr_arpoint_tab ASSIGNING FIELD-SYMBOL(<ls_aop>).
*      DELETE rpoint_detail-oper_rpoint_tab WHERE oprid = <ls_aop>-oprid.
*    ENDLOOP.

  ELSE.
*  No workcenter detail found
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'I'
        msgno      = '006'
      CHANGING
        return_tab = return_tab.
  ENDIF.
ENDMETHOD.


METHOD set_pass_material.
  DATA: ls_zabsf_pp047 TYPE zabsf_pp047,
        ld_text_domain TYPE dd07t-ddtext.

  CLEAR: ls_zabsf_pp047,
         ld_text_domain.

  IF rpoint IS NOT INITIAL AND matnr IS NOT INITIAL AND gernr IS NOT INITIAL AND
     passnumber IS NOT INITIAL AND flag_def IS NOT INITIAL.

*  Area
    ls_zabsf_pp047-areaid = inputobj-areaid.
*  Reporting point
    ls_zabsf_pp047-rpoint = rpoint.
*  Hierarchies (Area)
    ls_zabsf_pp047-hname = hname.
*  Material
    ls_zabsf_pp047-matnr = matnr.
*  Serial number
    ls_zabsf_pp047-gernr = gernr.
*  Passage number
    ls_zabsf_pp047-passnumber = passnumber.
*  Date
    ls_zabsf_pp047-date_reg = sy-datum.

*  Get Description for defect flag in Domain
    CALL FUNCTION 'STF4_GET_DOMAIN_VALUE_TEXT'
      EXPORTING
        iv_domname      = c_domain
        iv_value        = flag_def
      IMPORTING
        ev_value_text   = ld_text_domain
      EXCEPTIONS
        value_not_found = 1
        OTHERS          = 2.

    IF sy-subrc <> 0.
* Implement suitable error handling here
    ELSE.
      ls_zabsf_pp047-result_def = ld_text_domain.
    ENDIF.

*  Get description for defect
    SELECT SINGLE defect_desc
      FROM zabsf_pp026_t
      INTO ls_zabsf_pp047-defect_desc
     WHERE areaid   EQ inputobj-areaid
       AND werks    EQ inputobj-werks
       AND arbpl    EQ rpoint
       AND defectid EQ defectid
       AND spras    EQ sy-langu.

*  Saved data in database
    INSERT INTO zabsf_pp047 VALUES ls_zabsf_pp047.

    IF sy-subrc NE 0.
*    Operation not completed successfully
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'E'
          msgno      = '012'
        CHANGING
          return_tab = return_tab.
    ELSE.
*    Operation completed successfully
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'S'
          msgno      = '013'
        CHANGING
          return_tab = return_tab.
    ENDIF.
  ELSE.
*  Operation not completed successfully
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'E'
        msgno      = '012'
      CHANGING
        return_tab = return_tab.
  ENDIF.
ENDMETHOD.


METHOD set_quality_rpoint.

  DATA: wa_zabsf_pp049 TYPE zabsf_pp049,
        ls_rework      TYPE zabsf_pp_s_rework,
        ld_shiftid     TYPE zabsf_pp_e_shiftid.

  CLEAR: wa_zabsf_pp049,
         ls_rework.

*  IF scrap_qty IS NOT INITIAL AND grund IS NOT INITIAL.

*  ELSE.
** No data found
*    CALL METHOD ZABSF_PP_cl_log=>add_message
*      EXPORTING
*        msgty      = 'I'
*        msgno      = '038'
*        msgv1      = wareid
*      CHANGING
*        return_tab = return_tab.
*  ENDIF.

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

  IF rework_tab[] IS NOT INITIAL.
    CLEAR ls_rework.
    LOOP AT rework_tab INTO ls_rework.
      CLEAR wa_zabsf_pp049.

**    Get information of rework
*      SELECT SINGLE *
*        FROM ZABSF_PP049
*        INTO CORRESPONDING FIELDS OF wa_ZABSF_PP049
*       WHERE areaid   EQ inputobj-areaid
*         AND rpoint   EQ rpoint
*         AND matnr    EQ matnr
*         AND defectid EQ ls_rework-defectid
*         AND data     EQ sy-datum
*         AND oprid    EQ inputobj-oprid.
*
*      IF sy-subrc EQ 0.
**      Update database with quantity of rework
*        ADD ls_rework-rework TO wa_ZABSF_PP049-rework.
*
*        UPDATE ZABSF_PP049 FROM wa_ZABSF_PP049.
*
*        IF sy-subrc EQ 0.
**        Operation completed successfully
*          CALL METHOD ZABSF_PP_cl_log=>add_message
*            EXPORTING
*              msgty      = 'S'
*              msgno      = '013'
*            CHANGING
*              return_tab = return_tab.
*        ELSE.
**            Operation not completed successfully
*          CALL METHOD ZABSF_PP_cl_log=>add_message
*            EXPORTING
*              msgty      = 'E'
*              msgno      = '012'
*            CHANGING
*              return_tab = return_tab.
*
*          CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
*        ENDIF.
*      ELSE.
*      Create new line in database
*      Area
      wa_zabsf_pp049-areaid = inputobj-areaid.
*      Reporting point
      wa_zabsf_pp049-rpoint = rpoint.
*      Material
      wa_zabsf_pp049-matnr = matnr.
*      ID defect
      wa_zabsf_pp049-defectid = ls_rework-defectid.
*      Rework quantity
      wa_zabsf_pp049-rework = ls_rework-rework.

*      Unit
      SELECT SINGLE meins
        FROM mara
        INTO wa_zabsf_pp049-vorme
        WHERE matnr EQ matnr.

*      Date
      wa_zabsf_pp049-data = refdt.
*      Date
      wa_zabsf_pp049-time = sy-uzeit.
*      Shift
      wa_zabsf_pp049-shiftid = ld_shiftid.
*      Operator
      wa_zabsf_pp049-oprid = inputobj-oprid.

      INSERT zabsf_pp049 FROM wa_zabsf_pp049.

      IF sy-subrc EQ 0.
*        Operation completed successfully
        CALL METHOD zabsf_pp_cl_log=>add_message
          EXPORTING
            msgty      = 'S'
            msgno      = '013'
          CHANGING
            return_tab = return_tab.
      ELSE.
*        Operation not completed successfully
        CALL METHOD zabsf_pp_cl_log=>add_message
          EXPORTING
            msgty      = 'E'
            msgno      = '012'
          CHANGING
            return_tab = return_tab.

        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      ENDIF.
*      ENDIF.
    ENDLOOP.
  ENDIF.
ENDMETHOD.


METHOD SET_REFDT.

*Set new reference date
  refdt = new_refdt.

  ENDMETHOD.


  METHOD set_scrap_rpoint.
    DATA: ls_bflushflags    TYPE bapi_rm_flg,
          ls_bflushdatagen  TYPE bapi_rm_datgen,
          ls_bflushdatamts  TYPE bapi_rm_datstock,
          lv_plnum          TYPE plnum,
          lv_confirmation   TYPE bapi_rm_datkey-confirmation,
          ls_return         TYPE bapiret2,
          ls_goodsmovements TYPE bapi2017_gm_item_create,
          lt_goodsmovements TYPE TABLE OF bapi2017_gm_item_create,
          lt_components     TYPE zabsf_pp_t_components,
          lt_return         TYPE bapiret2_t,
          lref_sf_consum    TYPE REF TO zif_absf_pp_consumptions,
          lv_class          TYPE recaimplclname,
          lv_method         TYPE seocmpname,
          ls_zabsf_pp049    TYPE zabsf_pp049,
          lv_qty_av         TYPE bapicm61v-wkbst,
          lv_stock_fail(1),
          lt_wmdvs          TYPE TABLE OF bapiwmdvs,
          lt_wmdve          TYPE TABLE OF bapiwmdve.

    CONSTANTS: c_bwart TYPE bwart VALUE '261'.

    TRANSLATE inputobj-oprid TO UPPER CASE.

* Get shift witch operator is associated
    SELECT SINGLE shiftid
      FROM zabsf_pp052
      INTO @DATA(lv_shiftid)
     WHERE areaid EQ @inputobj-areaid
       AND oprid EQ @inputobj-oprid.

    IF sy-subrc NE 0.
      IF 1 = 2. MESSAGE e061(zabsf_pp) . ENDIF.
* Operator is not associated with shift
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'E'
          msgno      = '061'
          msgv1      = inputobj-oprid
        CHANGING
          return_tab = return_tab.

      EXIT.
    ENDIF.

    IF scrap_tab[] IS NOT INITIAL.

*Get class of interface
      SELECT SINGLE imp_clname methodname
         FROM zabsf_pp003
         INTO (lv_class, lv_method)
         WHERE werks    EQ is_inputobj-werks
           AND id_class EQ '9'
           AND endda    GE refdt
           AND begda    LE refdt.

      TRY .
          CREATE OBJECT lref_sf_consum TYPE (lv_class)
            EXPORTING
              initial_refdt = CONV datum( refdt )
              input_object  = is_inputobj.

        CATCH cx_sy_create_object_error INTO DATA(lo_exception).

          CALL METHOD zcl_lp_pp_sf_log=>add_message
            EXPORTING
              msgty      = 'E'
              msgno      = '019'
              msgv1      = lv_class
            CHANGING
              return_tab = lt_return.

          EXIT.
      ENDTRY.

      LOOP AT scrap_tab INTO DATA(ls_scrap).
        CLEAR: ls_bflushflags,
               ls_bflushdatagen,
               ls_bflushdatamts,
               lt_goodsmovements[].

        "" Control PARAMETERS for confirmation
* Backflush type
        ls_bflushflags-bckfltype = '02'.
* Scrap type for reporting point scrap backflush
        ls_bflushflags-rp_scraptype = '1'.
* Scope of activity backflush
        ls_bflushflags-activities_type = '1'.
* Scope of GI posting
        ls_bflushflags-components_type = '1'.

*Backflush Parameters Independent of Process
* Material
        ls_bflushdatagen-materialnr = matnr.
* Plant
        ls_bflushdatagen-prodplant = inputobj-werks.
* Planning plant
        ls_bflushdatagen-planplant = inputobj-werks.

* Production Versions of Material
        SELECT SINGLE *
          FROM mkal
          INTO @DATA(ls_mkal)
         WHERE matnr EQ @matnr
           AND werks EQ @inputobj-werks
           AND adatu LE @refdt
           AND bdatu GE @refdt.

        IF sy-subrc EQ 0.
* Storage Location
          ls_bflushdatagen-storageloc = ls_mkal-alort.
* Production Version
          ls_bflushdatagen-prodversion = ls_mkal-verid.
* Production line
          ls_bflushdatagen-prodline = ls_mkal-mdv01.
        ENDIF.

* Posting date
        ls_bflushdatagen-postdate = refdt.
* Document date
        ls_bflushdatagen-docdate = refdt.
* Quantity scrap in Unit of Entry
        ls_bflushdatagen-scrapquant = ls_scrap-scrap_qty.
* Unit of measure
        ls_bflushdatagen-unitofmeasure = ls_scrap-meins.
* Shift
        ls_bflushdatagen-docheadertxt = lv_shiftid.

*    IF planorder IS NOT INITIAL.
*      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*        EXPORTING
*          input  = planorder
*        IMPORTING
*          output = lv_plnum.
*
** Check if plan order exist in system
*      SELECT SINGLE *
*        FROM plaf
*        INTO @data(ls_plaf)
*        WHERE plnum EQ @lv_plnum.
*
*      IF sy-subrc NE 0.
**
*        CALL METHOD zabsf_pp_cl_log=>add_message
*          EXPORTING
*            msgty      = 'E'
*            msgno      = '048'
*            msgv1      = planorder
*          CHANGING
*            return_tab = return_tab.
*
*        EXIT.
*      ELSE.
** Plan order
*        ls_bflushdatagen-planorder = lv_plnum.
*      ENDIF.
*    ENDIF.


* nº operation report point
        ls_bflushdatamts-reppoint = ls_scrap-vornr.

        CLEAR lt_components[].
        CLEAR lt_return[].
* get components material
        CALL METHOD lref_sf_consum->(lv_method)
          EXPORTING
            matnr          = CONV matnr( matnr )
            vornr          = CONV pzpnr( ls_scrap-vornr )
            lmnga          = CONV lmnga( ls_scrap-scrap_qty )
            meins          = CONV meins( ls_scrap-meins )
          CHANGING
            components_tab = lt_components
            return_tab     = lt_return.

        DELETE ADJACENT DUPLICATES FROM lt_return.

        IF lt_return[] IS INITIAL AND lt_components[] IS NOT INITIAL.
          LOOP AT lt_components INTO DATA(ls_component).
            CLEAR ls_goodsmovements.
* Material - Component
            ls_goodsmovements-material = ls_component-matnr.
* Plant
            ls_goodsmovements-plant = inputobj-werks.
* Storage Location
            ls_goodsmovements-stge_loc =  ls_component-lgort.
* Movement Type
            ls_goodsmovements-move_type = c_bwart.
* Quantity
            ls_goodsmovements-entry_qnt = ls_component-consqty.
* Unit
            ls_goodsmovements-entry_uom =  ls_component-meins.
* Reservation
            ls_goodsmovements-reserv_no = ls_component-rsnum.
            ls_goodsmovements-res_item = ls_component-rspos.

            APPEND ls_goodsmovements TO lt_goodsmovements.

*Check material availability
            CALL FUNCTION 'BAPI_MATERIAL_AVAILABILITY'
              EXPORTING
                plant      = inputobj-werks
                material   = ls_component-matnr
                unit       = ls_component-meins
                stge_loc   = ls_component-lgort
              IMPORTING
                av_qty_plt = lv_qty_av
              TABLES
                wmdvsx     = lt_wmdvs
                wmdvex     = lt_wmdve.

            IF lv_qty_av < ls_component-consqty.
              lv_stock_fail = 'X'.
              EXIT.
            ENDIF.
          ENDLOOP.

          CLEAR: ls_return, lv_confirmation.

          IF lv_stock_fail IS INITIAL.
*create consumption
            CALL FUNCTION 'BAPI_REPMANCONF1_CREATE_MTS'
              EXPORTING
                bflushflags    = ls_bflushflags
                bflushdatagen  = ls_bflushdatagen
                bflushdatamts  = ls_bflushdatamts
              IMPORTING
                confirmation   = lv_confirmation
                return         = ls_return
              TABLES
                goodsmovements = lt_goodsmovements.

            IF ls_return IS INITIAL AND lv_confirmation IS NOT INITIAL.
              CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
                EXPORTING
                  wait = 'X'.

*  Get number od document created
              SELECT SINGLE belnr
                FROM blpp
                INTO @DATA(lv_belnr)
                WHERE prtnr EQ @lv_confirmation
                  AND belnr NE @space.

              CALL METHOD zabsf_pp_cl_log=>add_message
                EXPORTING
                  msgty      = 'S'
                  msgno      = '034'
                  msgv1      = lv_belnr
                CHANGING
                  return_tab = return_tab.
            ELSE.
              IF ls_return-type = 'A'.
                ls_return-type = 'E'.
              ENDIF.

              APPEND ls_return TO return_tab.
            ENDIF.
          ELSE.
            CALL METHOD zcl_lp_pp_sf_log=>add_message
              EXPORTING
                msgty      = 'E'
                msgno      = '064'
                msgv1      = ls_component-matnr
                msgv2      = inputobj-werks
                msgv3      = ls_component-lgort
                msgv4      = lv_qty_av
              CHANGING
                return_tab = return_tab.

            EXIT.
          ENDIF.

          DELETE ADJACENT DUPLICATES FROM return_tab.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
