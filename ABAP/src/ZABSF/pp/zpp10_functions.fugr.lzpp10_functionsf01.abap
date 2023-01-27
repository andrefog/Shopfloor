*----------------------------------------------------------------------*
***INCLUDE LZPP02_FUNCTIONSF01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  INIT_VARIABLES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM init_variables .
  REFRESH: gt_return.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CREATE_BATCH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->LS_BATCH  text
*      <--P_BATCH_NEW  text
*      <--IT_RETURN  text
*----------------------------------------------------------------------*
FORM create_batch  USING    ls_batch TYPE zabsf_batch
                   CHANGING p_batch_new.

*Internal tables
  DATA: lt_char_of_batch  TYPE TABLE OF clbatch,
        lt_char_batch_aux TYPE TABLE OF clbatch,
        lt_new_batch      TYPE TABLE OF mcha.

*Structures
  DATA: ls_batch_create  TYPE mcha,
        ls_batch_new     TYPE mcha,
        ls_batch_cons    TYPE zabsf_pp_s_batch_consumption,
        ls_char_of_batch TYPE clbatch,
        ls_return        TYPE bapiret2.

*Variables
  DATA: l_ref_matnr     TYPE matnr,
        l_ref_charg     TYPE charg_d,
        l_ref_werks     TYPE werks_d,
        l_nr_batch_cons TYPE i.

*Constants
  CONSTANTS: c_kzcla      TYPE t156-kzcla VALUE '1', "Option to classify batches
             c_xkcfc      TYPE t156-xkcfc VALUE 'X', "Extended classification via CFC
             c_objty      TYPE cr_objty   VALUE 'A',   "Work Center
             c_veran_100  TYPE ap_veran   VALUE '100', "Vulcanization
             c_veran_200  TYPE ap_veran   VALUE '200', "Thermoplastic
             c_workcenter TYPE atnam      VALUE 'ZWORKCENTER'. "Name of characteristic

*Data to New Batch
*Material
  ls_batch_create-matnr = ls_batch-matnr.
*Plant
  ls_batch_create-werks = ls_batch-werks.
*Valuation Type
  ls_batch_create-bwtar = ls_batch-bwtar.
*Production date
  ls_batch_create-hsdat = ls_batch-hsdat.

*Check workcenter
  SELECT SINGLE *
    FROM crhd
    INTO @DATA(ls_crhd)
   WHERE arbpl EQ @ls_batch-arbpl
     AND objty EQ @c_objty
     AND begda LE @sy-datum
     AND endda GE @sy-datum
     AND veran IN ( @c_veran_100, @c_veran_200 ).

  IF sy-subrc NE 0.
*  Count batch consumption
    DESCRIBE TABLE ls_batch-charg_t LINES l_nr_batch_cons.

    IF l_nr_batch_cons GT 1.
      LOOP AT ls_batch-charg_t INTO ls_batch_cons WHERE inheritance EQ abap_true.
        IF sy-tabix EQ 1.
*         Reference Material
          l_ref_matnr = ls_batch_cons-matnr.
*        Reference Batch
          l_ref_charg = ls_batch_cons-charg.
*        Reference Plant
          l_ref_werks = ls_batch_cons-werks.
        ELSE.
          REFRESH lt_char_batch_aux.

*        Get characteristic
          PERFORM get_characteristic TABLES lt_char_batch_aux
                                     USING  ls_batch_cons-matnr ls_batch_cons-charg
                                            ls_batch_cons-werks.

          IF lt_char_batch_aux[] IS NOT INITIAL.
            APPEND LINES OF lt_char_batch_aux TO lt_char_of_batch.
          ENDIF.
        ENDIF.

*        REFRESH lt_char_batch_aux.
*
**      Get characteristic Z_MAT_PACKAGING
*        PERFORM get_characteristic_matnr TABLES lt_char_batch_aux
*                                         USING  ls_batch_cons-matnr ls_batch_cons-werks.
*
*        IF lt_char_batch_aux[] IS NOT INITIAL.
*          APPEND LINES OF lt_char_batch_aux TO lt_char_of_batch.
*        ENDIF.
      ENDLOOP.
    ELSE.
*    Get batch consumption
      READ TABLE ls_batch-charg_t INTO ls_batch_cons WITH KEY inheritance = abap_true.

      IF sy-subrc EQ 0.
*      Reference Material
        l_ref_matnr = ls_batch_cons-matnr.
*      Reference Batch
        l_ref_charg = ls_batch_cons-charg.
*      Reference Plant
        l_ref_werks = ls_batch_cons-werks.

**      Get characteristic Z_MAT_PACKAGING
*        PERFORM get_characteristic_matnr TABLES lt_char_batch_aux
*                                         USING  ls_batch_cons-matnr ls_batch_cons-werks.
*
*        IF lt_char_batch_aux[] IS NOT INITIAL.
*          APPEND LINES OF lt_char_batch_aux TO lt_char_of_batch.
*        ENDIF.
      ENDIF.
    ENDIF.

    REFRESH lt_char_batch_aux.

*  Get characteristic Z_MAT_PACKAGING
    PERFORM get_characteristic_matnr TABLES lt_char_batch_aux
                                     USING  ls_batch-matnr ls_batch-werks.

    IF lt_char_batch_aux[] IS NOT INITIAL.
      APPEND LINES OF lt_char_batch_aux TO lt_char_of_batch.
    ENDIF.
  ENDIF.

*Add characteristic - Work center
  IF lt_char_of_batch[] IS NOT INITIAL.
    READ TABLE lt_char_of_batch ASSIGNING FIELD-SYMBOL(<fs_char_of_batch>) WITH KEY atnam = c_workcenter.

    IF sy-subrc EQ 0.
      <fs_char_of_batch>-atwtb = ls_batch-arbpl.
    ELSE.
      CLEAR ls_char_of_batch.
      ls_char_of_batch-atnam = c_workcenter.
      ls_char_of_batch-atwtb = ls_batch-arbpl.

      APPEND ls_char_of_batch TO lt_char_of_batch.
    ENDIF.
  ELSE.
    CLEAR ls_char_of_batch.
    ls_char_of_batch-atnam = c_workcenter.
    ls_char_of_batch-atwtb = ls_batch-arbpl.

    APPEND ls_char_of_batch TO lt_char_of_batch.
  ENDIF.

*Create Batch
  CALL FUNCTION 'VB_CREATE_BATCH'
    EXPORTING
      ymcha                        = ls_batch_create
      ref_matnr                    = l_ref_matnr
      ref_charg                    = l_ref_charg
      ref_werks                    = l_ref_werks
      kzcla                        = c_kzcla
      xkcfc                        = c_xkcfc
    IMPORTING
      ymcha                        = ls_batch_new
    TABLES
      char_of_batch                = lt_char_of_batch
      new_batch                    = lt_new_batch
      return                       = gt_return
    EXCEPTIONS
      no_material                  = 1
      no_batch                     = 2
      no_plant                     = 3
      material_not_found           = 4
      plant_not_found              = 5
      stoloc_not_found             = 6
      lock_on_material             = 7
      lock_on_plant                = 8
      lock_on_batch                = 9
      lock_system_error            = 10
      no_authority                 = 11
      batch_exist                  = 12
      stoloc_exist                 = 13
      illegal_batch_number         = 14
      no_batch_handling            = 15
      no_valuation_area            = 16
      valuation_type_not_found     = 17
      no_valuation_found           = 18
      error_automatic_batch_number = 19
      cancelled                    = 20
      wrong_status                 = 21
      interval_not_found           = 22
      number_range_not_extern      = 23
      object_not_found             = 24
      error_check_batch_number     = 25
      no_external_number           = 26
      no_customer_number           = 27
      no_class                     = 28
      error_in_classification      = 29
      inconsistency_in_key         = 30
      region_of_origin_not_found   = 31
      country_of_origin_not_found  = 32
      OTHERS                       = 33.

  IF gt_return[] IS INITIAL AND sy-subrc EQ 0.
*  Save batch
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.

*    New Batch created
    p_batch_new = ls_batch_new-charg.
  ELSE.
    CLEAR ls_return.

*  Convert the message
    CALL FUNCTION 'BALW_BAPIRETURN_GET2'
      EXPORTING
        type   = 'E'
        cl     = sy-msgid
        number = sy-msgno
        par1   = sy-msgv1
        par2   = sy-msgv2
        par3   = sy-msgv3
        par4   = sy-msgv4
      IMPORTING
        return = ls_return.

*  Format message
    CALL FUNCTION 'FORMAT_MESSAGE'
      EXPORTING
        id        = sy-msgid
        lang      = sy-langu
        no        = sy-msgno
        v1        = sy-msgv1
        v2        = sy-msgv2
        v3        = sy-msgv3
        v4        = sy-msgv4
      IMPORTING
        msg       = ls_return-message
      EXCEPTIONS
        not_found = 1
        OTHERS    = 2.

*  Append message error
    APPEND ls_return TO gt_return.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CHANGE_BATCH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  LS_BATCH        text
*  <--  P_BATCH_NEW     text
*----------------------------------------------------------------------*
FORM change_batch USING ls_batch TYPE zabsf_batch
                        p_batch_new.
*Internal Tables
  DATA: lt_characteristics TYPE TABLE OF bapi_char,
        lt_char_values     TYPE TABLE OF bapi_char_values,
        lt_char_of_batch   TYPE TABLE OF clbatch,
        lt_char_batch_aux  TYPE TABLE OF clbatch,
        lt_return_batch    TYPE TABLE OF bapiret2.

*Structures
  DATA: ls_return          TYPE bapireturn1,
        ls_characteristics TYPE bapi_char,
        ls_ymcha           TYPE mcha,
        ls_char_of_batch   TYPE clbatch,
        ls_charg_cons      TYPE zabsf_pp_s_batch_consumption.

*Variables
  DATA: l_batch_level TYPE kzdch,
        l_klart       TYPE klassenart,
        l_class       TYPE klasse_d.

*Constants
  CONSTANTS: c_kzdch      TYPE kzdch VALUE '0',     "Batch unique at plant level
             c_kzcla      TYPE kzcla VALUE '1',
             c_xkcfc      TYPE xkcfc VALUE 'X',
             c_mtart_halb TYPE mtart VALUE 'HALB', "Material type
             c_mtart_fert TYPE mtart VALUE 'FERT', "Material type
             c_matkl_050  TYPE matkl VALUE '050',  "Material grupo
             c_matkl_001  TYPE matkl VALUE '001'.  "Material grupo

*Get batch level
  CALL FUNCTION 'VB_BATCH_DEFINITION'
    IMPORTING
      kzdch = l_batch_level.

  IF l_batch_level NE c_kzdch.
*  Get class name and number
    PERFORM get_batch_class USING ls_batch-matnr
                            CHANGING l_klart
                                     l_class.

    IF l_class IS NOT INITIAL AND l_klart IS NOT INITIAL.
*    Get characteristic of batch
      CALL FUNCTION 'BAPI_CLASS_GET_CHARACTERISTICS'
        EXPORTING
          classnum        = l_class
          classtype       = l_klart
        IMPORTING
          return          = ls_return
        TABLES
          characteristics = lt_characteristics
          char_values     = lt_char_values.

      IF lt_characteristics[] IS NOT INITIAL.
        CLEAR ls_characteristics.

        LOOP AT lt_characteristics INTO ls_characteristics.
          CLEAR ls_char_of_batch.

          CASE ls_characteristics-name_char.
            WHEN 'Z_PROD_ORDER'. "Production Order
              ls_char_of_batch-atnam = ls_characteristics-name_char.

*            Remove left zeros
              CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
                EXPORTING
                  input  = ls_batch-aufnr
                IMPORTING
                  output = ls_char_of_batch-atwtb.

*              ls_char_of_batch-atwtb = ls_batch-aufnr.
            WHEN 'Z_INJECT_BATCH'. "Batch Number
              ls_char_of_batch-atnam = ls_characteristics-name_char.
              ls_char_of_batch-atwtb = p_batch_new.
            WHEN 'Z_COMPOUND'.
              LOOP AT ls_batch-charg_t INTO ls_charg_cons WHERE charg IS NOT INITIAL
                                                            AND inheritance EQ space.
                CLEAR ls_char_of_batch.

                ls_char_of_batch-atnam = ls_characteristics-name_char.
                ls_char_of_batch-atwtb = ls_charg_cons-charg.

                APPEND ls_char_of_batch TO lt_char_of_batch.
              ENDLOOP.
              CLEAR ls_char_of_batch.

            WHEN 'Z_MOULD'. "Mould
              IF ls_batch-eqktx IS NOT INITIAL.
                ls_char_of_batch-atnam = ls_characteristics-name_char.
                ls_char_of_batch-atwtb = ls_batch-eqktx.
              ENDIF.
            WHEN 'Z_SHIFT'. "Shift
              IF ls_batch-kaptprog IS NOT INITIAL.
                ls_char_of_batch-atnam = ls_characteristics-name_char.
                ls_char_of_batch-atwtb = ls_batch-kaptprog.
              ENDIF.
            WHEN 'Z_OPERATOR'. "Operator
              IF ls_batch-pernr IS NOT INITIAL.
                ls_char_of_batch-atnam = ls_characteristics-name_char.
                ls_char_of_batch-atwtb = ls_batch-pernr.
              ENDIF.
            WHEN 'Z_INJECTION_DATE'. "Date
              ls_char_of_batch-atnam = ls_characteristics-name_char.

              IF ls_batch-hsdat IS NOT INITIAL.
                CALL FUNCTION 'CONVERT_DATE_TO_EXTERNAL'
                  EXPORTING
                    date_internal = ls_batch-hsdat
                  IMPORTING
                    date_external = ls_char_of_batch-atwtb.
              ELSE.
                CALL FUNCTION 'CONVERT_DATE_TO_EXTERNAL'
                  EXPORTING
                    date_internal = sy-datlo
                  IMPORTING
                    date_external = ls_char_of_batch-atwtb.
              ENDIF.

            WHEN 'Z_MAT_PACKAGING'.
*            Check material
              SELECT SINGLE mandt
                FROM mara
                INTO (@DATA(l_mandt))
               WHERE matnr EQ @ls_batch-matnr
                 AND ( mtart EQ @c_mtart_halb OR
                       mtart EQ @c_mtart_fert ) .
*                 AND ( ( mtart EQ @c_mtart_halb AND
*                         matkl EQ @c_matkl_050 )
*                   OR (  mtart EQ @c_mtart_fert AND
*                         matkl EQ @c_matkl_001 ) ) .

              IF sy-subrc EQ 0.
*              Get characteristic Z_MAT_PACKAGING
                PERFORM get_characteristic_matnr TABLES lt_char_batch_aux
                                                 USING  ls_batch-matnr ls_batch-werks.

                IF lt_char_batch_aux[] IS NOT INITIAL.
                  APPEND LINES OF lt_char_batch_aux TO lt_char_of_batch.
                ENDIF.
              ENDIF.
          ENDCASE.

          IF ls_char_of_batch IS NOT INITIAL.
            APPEND ls_char_of_batch TO lt_char_of_batch.
          ENDIF.
        ENDLOOP.
      ENDIF.

*    Batch to change
*    Material
      ls_ymcha-matnr = ls_batch-matnr.
*    Plant
      ls_ymcha-werks = ls_batch-werks.
*    Batch
      ls_ymcha-charg = p_batch_new.

*    Change value Batch Characteristics
      CALL FUNCTION 'VB_CHANGE_BATCH'
        EXPORTING
          ymcha                       = ls_ymcha
          kzcla                       = c_kzcla
          xkcfc                       = c_xkcfc
        TABLES
          char_of_batch               = lt_char_of_batch
          return                      = lt_return_batch
        EXCEPTIONS
          no_material                 = 1
          no_batch                    = 2
          no_plant                    = 3
          material_not_found          = 4
          plant_not_found             = 5
          lock_on_material            = 6
          lock_on_plant               = 7
          lock_on_batch               = 8
          lock_system_error           = 9
          no_authority                = 10
          batch_not_exist             = 11
          no_class                    = 12
          error_in_classification     = 13
          error_in_valuation_change   = 14
          error_in_status_change      = 15
          region_of_origin_not_found  = 16
          country_of_origin_not_found = 17
          OTHERS                      = 18.

      IF lt_return_batch[] IS NOT INITIAL.
        APPEND LINES OF lt_return_batch TO gt_return.
      ELSE.
*      Save batch changes
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = 'X'.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_BATCH_CLASS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LS_BATCH_MATNR  text
*      <--P_L_KLART  text
*      <--P_L_CLASS  text
*----------------------------------------------------------------------*
FORM get_batch_class  USING    p_matnr
                      CHANGING p_klart
                               p_class.

*Variables
  DATA: l_objek TYPE cuobn.

*Constants
  CONSTANTS: c_kzdch    TYPE kzdch   VALUE '0',     "Batch unique at plant level
             c_obj_mcha TYPE tabelle VALUE 'MCHA',
             c_obj_mch1 TYPE tabelle VALUE 'MCH1',
             c_mafid    TYPE klmaf   VALUE 'O',     "Indicator: Object/Class
             c_obj_mara TYPE tabelle VALUE 'MARA'.

*Get Class Type
  SELECT SINGLE tcla~klart
    FROM tcla JOIN tclao
      ON tcla~klart EQ tclao~klart
   WHERE tcla~obtab    EQ @c_obj_mcha
     AND tcla~intklart EQ @space
     AND tcla~multobj  EQ @abap_true
     AND tclao~obtab   EQ @c_obj_mch1
    INTO (@DATA(l_klart)).

*Key of Object to be Classified
  l_objek = p_matnr.

*Get object internal number of Class
  SELECT SINGLE cuobj
    FROM inob
    INTO (@DATA(l_cuobj))
   WHERE klart EQ @l_klart
     AND obtab EQ @c_obj_mara
     AND objek EQ @l_objek.

  IF l_cuobj IS NOT INITIAL.
*  Get object of Class
    SELECT SINGLE clint
      FROM kssk
      INTO (@DATA(l_clint))
     WHERE objek EQ @l_cuobj
       AND mafid EQ @c_mafid
       AND klart EQ @l_klart.

    IF l_clint IS NOT INITIAL.
*    Get name of Class
      SELECT SINGLE class
        FROM klah
        INTO (@DATA(l_class))
       WHERE clint EQ @l_clint.

*    Class Name
      p_class = l_class.
*    Class Number
      p_klart = l_klart.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_CHARACTERISTIC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LS_BATCH_CONS_MATNR  text
*      -->P_LS_BATCH_CONS_CHARG  text
*      -->P_LS_BATCH_CONS_WERKS  text
*      <--P_LT_CHAR_OF_BATCH  text
*----------------------------------------------------------------------*
FORM get_characteristic  TABLES it_char_of_batch
                         USING    p_matnr
                                  p_charg
                                  p_werks.


*Internal tables
  DATA: lt_object TYPE TABLE OF bapi1003_object_keys,
        lt_return TYPE TABLE OF bapiret2,
        lt_numtab TYPE TABLE OF bapi1003_alloc_values_num,
        lt_chatab TYPE TABLE OF bapi1003_alloc_values_char,
        lt_curtab TYPE TABLE OF bapi1003_alloc_values_curr.

*Structures
  DATA: ls_object        TYPE bapi1003_object_keys,
        ls_numtab        TYPE bapi1003_alloc_values_num,
        ls_chatab        TYPE bapi1003_alloc_values_char,
        ls_curtab        TYPE bapi1003_alloc_values_curr,
        ls_char_of_batch TYPE clbatch.

*Variables
  DATA: l_klart     TYPE klassenart,
        l_class     TYPE klasse_d,
        l_objectkey TYPE objnum,
        l_date_in   TYPE nlei-ibgdt,
        l_date_out  TYPE char10.

*Constants
  CONSTANTS: c_mch1 TYPE tabelle VALUE 'MCH1'.

*Get class name and number
  PERFORM get_batch_class USING    p_matnr
                          CHANGING l_klart
                                   l_class.

*Create object
  CLEAR ls_object.
  ls_object-key_field = 'MATNR'.
  ls_object-value_int = p_matnr.
  APPEND ls_object TO lt_object.

  CLEAR ls_object.
  ls_object-key_field = 'WERKS'.
  ls_object-value_int = p_werks.
  APPEND ls_object TO lt_object.

  CLEAR ls_object.
  ls_object-key_field = 'CHARG'.
  ls_object-value_int = p_charg.
  APPEND ls_object TO lt_object.

  CALL FUNCTION 'BAPI_OBJCL_CONCATENATEKEY'
    EXPORTING
      objecttable    = c_mch1
    IMPORTING
      objectkey_conc = l_objectkey
    TABLES
      objectkeytable = lt_object
      return         = lt_return.

*Get batch detail
  CALL FUNCTION 'BAPI_OBJCL_GETDETAIL'
    EXPORTING
      objectkey       = l_objectkey
      objecttable     = c_mch1
      classnum        = l_class
      classtype       = l_klart
    TABLES
      allocvaluesnum  = lt_numtab
      allocvalueschar = lt_chatab
      allocvaluescurr = lt_curtab
      return          = lt_return.

*Numeric characteristic
  IF lt_numtab[] IS NOT INITIAL.
    LOOP AT lt_numtab INTO ls_numtab.
      CLEAR ls_char_of_batch.
      ls_char_of_batch-atnam = ls_numtab-charact.

      CALL FUNCTION 'CTCV_CONVERT_FLOAT_TO_DATE'
        EXPORTING
          float = ls_numtab-value_from
        IMPORTING
          date  = ls_char_of_batch-atwtb.

      IF ls_char_of_batch-atnam = 'Z_INJECTION_DATE'.
*      Input date
        l_date_in = ls_char_of_batch-atwtb.

        CLEAR ls_char_of_batch-atwtb.

*      Output date
        CALL FUNCTION 'FORMAT_DATE_4_OUTPUT'
          EXPORTING
            datin  = l_date_in
            format = 'DDMMYYYY'
          IMPORTING
            datex  = l_date_out.

        ls_char_of_batch-atwtb = l_date_out.
      ENDIF.

      APPEND ls_char_of_batch TO it_char_of_batch.
    ENDLOOP.
  ENDIF.

*Char characteristics
  IF lt_chatab[] IS NOT INITIAL.
    LOOP AT lt_chatab INTO ls_chatab.
      CLEAR ls_char_of_batch.
      ls_char_of_batch-atnam = ls_chatab-charact.
      ls_char_of_batch-atwtb = ls_chatab-value_neutral.

      APPEND ls_char_of_batch TO it_char_of_batch.
    ENDLOOP.
  ENDIF.

*Currency characteristic
  IF lt_curtab[] IS NOT INITIAL.
    LOOP AT lt_curtab INTO ls_curtab.
      CLEAR ls_char_of_batch.
      ls_char_of_batch-atnam = ls_curtab-charact.
      ls_char_of_batch-atwtb = ls_curtab-value_from.

      APPEND ls_char_of_batch TO it_char_of_batch.
    ENDLOOP.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_CHARACTERISTIC_MATNR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LT_CHAR_BATCH_AUX  text
*      -->P_LS_BATCH_CONS_MATNR  text
*      -->P_LS_BATCH_CONS_WERKS  text
*----------------------------------------------------------------------*
FORM get_characteristic_matnr  TABLES   it_char_of_batch
                               USING    p_matnr
                                        p_werks.

*Internal tables
  DATA: lt_allocvaluesnum  TYPE TABLE OF bapi1003_alloc_values_num,
        lt_allocvalueschar TYPE TABLE OF bapi1003_alloc_values_char,
        lt_allocvaluescurr TYPE TABLE OF bapi1003_alloc_values_curr,
        lt_return          TYPE TABLE OF bapiret2.

*Structures
  DATA: ls_char_of_batch TYPE clbatch.

*Variables
  DATA: l_object  TYPE objnum.

*Constants
  CONSTANTS: c_objecttable TYPE tabelle VALUE 'MARA',
             c_atnam       TYPE atnam   VALUE 'Z_MAT_PACKAGING'.

*Get Internal Class Number
  SELECT SINGLE clint
    FROM kssk
    INTO (@DATA(l_clint))
   WHERE objek EQ @p_matnr.

  IF l_clint IS NOT INITIAL.
*  Get Class number
    SELECT SINGLE klart, class
      FROM klah
      INTO (@DATA(l_klart), @DATA(l_class))
     WHERE clint EQ @l_clint.

*  Object - Material
    l_object = p_matnr.

*  Get material characteristics
    CALL FUNCTION 'BAPI_OBJCL_GETDETAIL'
      EXPORTING
        objectkey       = l_object
        objecttable     = c_objecttable
        classnum        = l_class
        classtype       = l_klart
      TABLES
        allocvaluesnum  = lt_allocvaluesnum
        allocvalueschar = lt_allocvalueschar
        allocvaluescurr = lt_allocvaluescurr
        return          = lt_return.


*  Numeric characteristic
    IF lt_allocvaluesnum[] IS NOT INITIAL.
*    Read characteristic value - Z_MAT_PACKAGING
      READ TABLE lt_allocvaluesnum INTO DATA(ls_allocvaluesnum) WITH KEY charact = c_atnam.

      IF sy-subrc EQ 0.
        CLEAR ls_char_of_batch.
        ls_char_of_batch-atnam = ls_allocvaluesnum-charact.
        ls_char_of_batch-atwtb = ls_allocvaluesnum-value_from.

        APPEND ls_char_of_batch TO it_char_of_batch.
      ENDIF.
    ENDIF.

*  Char characteristics
    IF lt_allocvalueschar[] IS NOT INITIAL.
*    Read characteristic value - Z_MAT_PACKAGING
      READ TABLE lt_allocvalueschar INTO DATA(ls_allocvalueschar) WITH KEY charact = c_atnam.

      IF sy-subrc EQ 0.
        CLEAR ls_char_of_batch.
        ls_char_of_batch-atnam = ls_allocvalueschar-charact.
        ls_char_of_batch-atwtb = ls_allocvalueschar-value_neutral.

        APPEND ls_char_of_batch TO it_char_of_batch.
      ENDIF.
    ENDIF.

*  Currency characteristic
    IF lt_allocvaluescurr[] IS NOT INITIAL.
*    Read characteristic value - Z_MAT_PACKAGING
      READ TABLE lt_allocvaluescurr INTO DATA(ls_allocvaluescurr) WITH KEY charact = c_atnam.

      IF sy-subrc EQ 0.
        CLEAR ls_char_of_batch.
        ls_char_of_batch-atnam = ls_allocvaluescurr-charact.
        ls_char_of_batch-atwtb = ls_allocvaluescurr-value_from.

        APPEND ls_char_of_batch TO it_char_of_batch.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  UPDATE_PROD_DATE_BACH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_IS_BATCH  text
*      -->P_L_BATCH_NEW  text
*----------------------------------------------------------------------*
FORM update_prod_date_batch  USING ls_batch TYPE zabsf_batch
                                   p_batch_new.

*Internal tables
  DATA: lt_return_batch TYPE TABLE OF bapiret2.

*Structures
  DATA: ls_ymcha   TYPE mcha,
        ls_updmcha TYPE updmcha.

*Batch to change
*Material
  ls_ymcha-matnr = ls_batch-matnr.
*Plant
  ls_ymcha-werks = ls_batch-werks.
*Batch
  ls_ymcha-charg = p_batch_new.
*Production date
  ls_ymcha-hsdat = ls_batch-hsdat.

*Update production date
  ls_updmcha-hsdat = abap_true.

*Update production date
  CALL FUNCTION 'VB_CHANGE_BATCH'
    EXPORTING
      ymcha                       = ls_ymcha
      yupdmcha                    = ls_updmcha
    TABLES
      return                      = lt_return_batch
    EXCEPTIONS
      no_material                 = 1
      no_batch                    = 2
      no_plant                    = 3
      material_not_found          = 4
      plant_not_found             = 5
      lock_on_material            = 6
      lock_on_plant               = 7
      lock_on_batch               = 8
      lock_system_error           = 9
      no_authority                = 10
      batch_not_exist             = 11
      no_class                    = 12
      error_in_classification     = 13
      error_in_valuation_change   = 14
      error_in_status_change      = 15
      region_of_origin_not_found  = 16
      country_of_origin_not_found = 17
      OTHERS                      = 18.

  IF lt_return_batch[] IS NOT INITIAL.
    APPEND LINES OF lt_return_batch TO gt_return.
  ELSE.
*  Save batch changes
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.
  ENDIF.
ENDFORM.
