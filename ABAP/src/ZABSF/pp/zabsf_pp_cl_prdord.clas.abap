class ZABSF_PP_CL_PRDORD definition
  public
  final
  create public .

public section.

  types:
    BEGIN OF ty_matnr_werks,
        matnr TYPE matnr,
        werks TYPE werks_d,
      END OF ty_matnr_werks .
  types:
    tt_matnr_werks TYPE STANDARD TABLE OF ty_matnr_werks WITH DEFAULT KEY .

  methods GET_ORDEROPERATIONS
    importing
      !IV_AUFNR type AUFNR
    exporting
      !ET_ORDEROPERATIONS type ZABSF_PP_T_PRODORD_OPERATIONS
      !ET_RETURN type BAPIRET2_TAB .
  class-methods CHECK_BATCH_OPEN_FOR_USE
    importing
      !WERKS type WERKS_D
      !CHARG type CHARG_D
    changing
      !VALID type FLAG .
  class-methods CREATE_PRODUCTION_BATCH
    importing
      !IM_REFBATCH_VAR type CHARG_D optional
      !IM_REFMATNR_VAR type MATNR
      !IM_REFWERKS_VAR type WERKS_D
      !IT_CHARACTS_TAB type ZABSF_PP_TT_BATCH_CHARACT optional
    exporting
      !ET_RETURN_TAB type BAPIRET2_T
      !EX_NEWBATCH_VAR type CHARG_D
      !EX_ERROR_VAR type FLAG .
  class-methods GET_MATERIAL_SERIAL_PROFILE
    importing
      !IT_MATERIALS type TT_MATNR_WERKS
    returning
      value(RT_SERIALPROF) type ZABSF_PP_T_MATERIALSERIALPROF .
  class-methods UPDATE_RESB_BATCH
    importing
      !IM_AUFNR_VAR type AUFNR
      !IM_RESB_TAB type RESB_T
    exporting
      !ET_RETURN_TAB type BAPIRET2_T .
  methods CALCULATE_QTY_ABSOLUTE_DELTA
    importing
      !ARBPL type ARBPL
      !AUFNR type AUFNR
      !VORNR type VORNR
      !MATNR type MATNR
      !LMNGA type LMNGA
    exporting
      !CONFIRM_QTY type LMNGA
      !RETURN_TAB type BAPIRET2_T .
  methods CHECK_AVAILABLE_STOCK
    importing
      !AREAID type ZABSF_PP_E_AREAID
      !ARBPL type ARBPL
      !AUFNR type AUFNR
      !GOODSMOVEMENTS_TAB type BAPI2017_GM_ITEM_CREATE_T
      !IS_SCRAP type FLAG optional
    exporting
      !MSG_ERROR type FLAG
      !RETURN_TAB type BAPIRET2_T .
  methods CHECK_MATERIAL
    importing
      !MATNR type MATNR
    changing
      !MAKTX type MAKTX
      !MEINS type MEINS
      !RETURN_TAB type BAPIRET2_T
      !XCHPF type XCHPF
      !MEINS_OUTPUT type MEINS optional .
  methods CONSTRUCTOR
    importing
      !INITIAL_REFDT type VVDATUM
      !INPUT_OBJECT type ZABSF_PP_S_INPUTOBJECT .
  methods CONVERT_UNIT
    importing
      !MATNR type MCEKPO-MATNR
      !SOURCE_VALUE type I
      !SOURCE_UNIT type MARA-MEINS
      !LMNGA type LMNGA
    changing
      !PRDQTY_BOX type ZABSF_PP_E_PRDQTY_BOX
      !BOXQTY type ZABSF_PP_E_BOXQTY
      !UNIT_ALT type MEINS optional .
  methods GET_AVAILABILITY_STATUS
    importing
      !IM_WERKSVAL_VAR type WERKS_D
    changing
      !CH_PRODORDR_STR type ZABSF_PP_S_PRDORD_DETAIL .
  methods GET_ORDERS_REWORK
    importing
      !HNAME type CR_HNAME
      !ARBPL type ARBPL
      !WERKS type WERKS_D
    changing
      !OPER_WRKCTR_TAB type ZABSF_PP_T_OPERADOR
      !PRDORD_TAB type ZABSF_PP_T_PRDORD_DETAIL
      !RETURN_TAB type BAPIRET2_T .
  methods GET_PROD_ORDERS_UNASSIGN
    importing
      !ARBPL type ARBPL
      !IT_STEUS_FILTERS type STRING_TABLE optional
    changing
      !PRDORD_UNASSIGN type ZABSF_PP_T_PRODORD_UNASSIGN
      !RETURN_TAB type BAPIRET2_T .
  methods GET_QTY_BOX
    importing
      !MATNR type MATNR
      !SOURCE_VALUE type I
      !LMNGA type LMNGA
      !GMEIN type MEINS optional
      !AUFPL type CO_AUFPL
      !APLZL type CO_APLZL
    changing
      !PRDQTY_BOX type ZABSF_PP_E_PRDQTY_BOX optional
      !BOXQTY type ZABSF_PP_E_BOXQTY optional
      !UNIT_ALT type MEINS optional .
  methods GET_QTY_VORNR
    importing
      !AUFNR type AUFNR
      !VORNR type VORNR
      !LMNGA type LMNGA
      !AUFPL type CO_AUFPL
    changing
      !QTY_PROC type ZABSF_PP_E_QTY
      !VORNR_TOT type ZABSF_PP_E_VORNR optional
      !RETURN_TAB type BAPIRET2_T .
  methods GET_QUALIFICATIONS
    importing
      value(ARBPL) type ARBPL
      value(INPUTOBJ) type ZABSF_PP_S_INPUTOBJECT
    changing
      value(PRORD_TAB) type ZABSF_PP_T_PRDORD_DETAIL
      value(RETURN_TAB) type BAPIRET2_T .
  methods GET_QUALI_PERNR_ACTIVE_PRDORD
    importing
      !ARBPL type ARBPL
      !PERNR type PERNR_D
      !AUFNR type AUFNR
    exporting
      !SCALE_ID type SCALE_ID
      !PROFCY type RATING
      !PROFC_TEXT type PROFC_TEXT
      !QUALI type QUALI_D
      !QTEXT type QTEXT .
  methods GET_THEORICAL_DATA
    importing
      !AUFNR type AUFNR optional
      !VORNR type VORNR optional
      !AUFPL type CO_AUFPL
      !APLZL type CO_APLZL
      !PLNTY type PLNTY optional
      !PLNNR type PLNNR optional
    exporting
      !VGW02 type VGWRT
      !THEORETICAL_TIME type VGWRT
      !BMSCH type BMSCH
      !THEORETICAL_QTY type BMSCH .
  methods GET_TOTAL_QUANTITY_COUNTER
    importing
      !RUECK type CO_RUECK
      !FICHA type ZABSF_PP_E_FICHA
    exporting
      !TOTAL_QTY type GAMNG .
  methods PALETE_DATA
    importing
      !MATNR type MATNR
      !BATCH type CHARG_D
    exporting
      !PALETE_DATA type ZABSF_PALETE_DATA_TAB
    changing
      !RETURN_TAB type BAPIRET2_T .
  methods SAVE_DATA_CONFIRMATION
    importing
      !TIPORD type ZABSF_PP_E_TIPORD default 'N'
      !IS_CONF_DATA type ZABSF_PP_S_CONF_ADIT_DATA
    changing
      !RETURN_TAB type BAPIRET2_T .
  methods SET_BATCH_OPEN_FOR_USE
    importing
      !GOODSMOVEMENTS_TAB type BAPI2017_GM_ITEM_CREATE_T .
  methods SET_BOX_QUANTITY
    importing
      !AUFNR type AUFNR
      !VORNR type VORNR
      !AUFPL type CO_AUFPL
      !APLZL type CO_APLZL
      !BOXQTY type ZABSF_PP_E_BOXQTY
    exporting
      !RETURN_TAB type BAPIRET2_T .
  methods SET_QUANTITY
    importing
      !AREAID type ZABSF_PP_E_AREAID
      !WERKS type WERKS_D
      !ARBPL type ARBPL optional
      !QTY_CONF_TAB type ZABSF_PP_T_QTY_CONF
      !TIPORD type ZABSF_PP_E_TIPORD default 'N'
      !CHECK_STOCK type FLAG optional
      !FIRST_CYCLE type FLAG optional
      value(BACKOFFICE) type FLAG optional
      value(SHIFTID) type ZABSF_PP_E_SHIFTID optional
    exporting
      !LENUM type LENUM
    changing
      !RETURN_TAB type BAPIRET2_T .
  methods SET_QUANTITY_ORD
    importing
      !AREAID type ZABSF_PP_E_AREAID
      !WERKS type WERKS_D
      !ARBPL type ARBPL optional
      !QTY_CONF_TAB type ZABSF_PP_T_QTY_CONF
      !TIPORD type ZABSF_PP_E_TIPORD default 'N'
      !CHECK_STOCK type FLAG optional
      !FIRST_CYCLE type FLAG optional
      value(BACKOFFICE) type FLAG optional
      value(SHIFTID) type ZABSF_PP_E_SHIFTID optional
      value(SUPERVISOR) type FLAG optional
      value(INPUTOBJ) type ZABSF_PP_S_INPUTOBJECT optional
      value(VENDOR) type LIFNR optional
      !MATERIALBATCH type ZABSF_PP_T_MATERIALBATCH optional
      !MATERIALSERIAL type ZABSF_PP_T_MATERIALSERIAL optional
      !IV_STORAGE_LOCATION type LGORT_D optional
      !IV_EQUIPMENT type CHAR100 optional
    exporting
      !CONF_TAB type ZABSF_PP_T_CONFIRMATION
    changing
      !RETURN_TAB type BAPIRET2_T .
  methods SET_QUANTITY_ORD_RPACK
    importing
      !AREAID type ZABSF_PP_E_AREAID
      !WERKS type WERKS_D
      !ARBPL type ARBPL optional
      !QTY_CONF_TAB type ZABSF_PP_T_QTY_CONF
      !TIPORD type ZABSF_PP_E_TIPORD default 'N'
      !CHECK_STOCK type FLAG optional
      !FIRST_CYCLE type FLAG optional
      value(BACKOFFICE) type FLAG optional
      value(SHIFTID) type ZABSF_PP_E_SHIFTID optional
      value(SUPERVISOR) type FLAG optional
    exporting
      !CONF_TAB type ZABSF_PP_T_CONFIRMATION
    changing
      !RETURN_TAB type BAPIRET2_T .
  methods SET_QUANTITY_SCRAP_RPACK
    importing
      !ARBPL type ARBPL
      !AUFNR type AUFNR optional
      !VORNR type VORNR optional
      !MATNR type MATNR optional
      !SCRAP_QTY type RU_XMNGA optional
      !NUMB_CYCLE type NUMC10 optional
      !DEFECTID type ZABSF_PP_E_DEFECTID optional
      !GRUND type CO_AGRND optional
      !FLAG_CREATE type FLAG optional
      !REWORK_QTY type RU_RMNGA optional
      !FLAG_SCRAP_LIST type FLAG optional
      !CHARG_T type ZABSF_PP_T_BATCH_CONSUMPTION optional
      value(BACKOFFICE) type FLAG optional
      value(SHIFTID) type ZABSF_PP_E_SHIFTID optional
    exporting
      !CONF_TAB type ZABSF_PP_T_CONFIRMATION
    changing
      !AUFNR_REWORK type AUFNR optional
      !RETURN_TAB type BAPIRET2_T .
  methods SET_REFDT
    importing
      !NEW_REFDT type VVDATUM .
  methods GET_PROD_ORDERS
    importing
      !HNAME type CR_HNAME
      !ARBPL type ARBPL
      !WERKS type WERKS_D
      !ACTIONID type ZABSF_PP_E_ACTION
      !AUFNR type AUFNR optional
      !VORNR type VORNR optional
      !IT_ISTAT_FILTERS type STRING_TABLE
    changing
      !OPER_WRKCTR_TAB type ZABSF_PP_T_OPERADOR
      !PRDORD_TAB type ZABSF_PP_T_PRDORD_DETAIL
      !RETURN_TAB type BAPIRET2_T .
protected section.
private section.

  data REFDT type VVDATUM .
  data INPUTOBJ type ZABSF_PP_S_INPUTOBJECT .
  constants PRDTY_DISCRET type ZABSF_PP_E_PRDTY value 'D' ##NO_TEXT.
  constants PRDTY_REPETITIVE type ZABSF_PP_E_PRDTY value 'R' ##NO_TEXT.
  constants MEINH_TARGET type MEINH value 'CX' ##NO_TEXT.
  constants CONF_REAL type ZABSF_PP_E_CONFTYPE value 'R' ##NO_TEXT.
  constants CONF_STAND type ZABSF_PP_E_CONFTYPE value 'S' ##NO_TEXT.
  constants STATUS type J_STATUS value 'At' ##NO_TEXT.
  constants STSMA type J_STSMA value 'ZCT02' ##NO_TEXT.
  constants FIRST_VORNR type VORNR value '0010' ##NO_TEXT.
ENDCLASS.



CLASS ZABSF_PP_CL_PRDORD IMPLEMENTATION.


METHOD calculate_qty_absolute_delta.
* Constants
    CONSTANTS: c_objty TYPE cr_objty           VALUE 'A', "Work center
               c_a     TYPE zabsf_pp_e_reg_quant VALUE 'A'. "Absolute

*  Get shift for user
    SELECT SINGLE shiftid
      FROM zabsf_pp052
      INTO (@DATA(l_shiftid))
     WHERE areaid EQ @inputobj-areaid
       AND oprid  EQ @inputobj-oprid.

*  Get hierarchy of Work center
    SELECT SINGLE crhs~objty_hy, crhs~objid_hy
      FROM crhs AS crhs
     INNER JOIN crhd AS crhd
        ON crhd~objty EQ crhs~objty_ho
       AND crhd~objid EQ crhs~objid_ho
     WHERE crhd~objty EQ @c_objty
       AND crhd~arbpl EQ @arbpl
       AND crhd~begda LT @sy-datum
       AND crhd~endda GT @sy-datum
       AND crhd~werks EQ @inputobj-werks
      INTO (@DATA(l_objty_hy),@DATA(l_objid_hy)).

*  Get hierarchy name
    SELECT SINGLE name
      FROM crhh
      INTO (@DATA(l_hname))
     WHERE objty EQ @l_objty_hy
       AND objid EQ @l_objid_hy.

*>>BMR EDIT 07.10.2016 - get process type from sf013 instead
*  Check if save quantity absolute or delta
*    SELECT SINGLE reg_quant
*      FROM ZABSF_PP002
*      INTO (@DATA(l_reg_quant))
*     WHERE areaid  EQ @inputobj-areaid
*       AND werks   EQ @inputobj-werks
*       AND shiftid EQ @l_shiftid
*       AND hname   EQ @l_hname
*       AND endda   GT @sy-datum
*       AND begda   LT @sy-datum.

    SELECT SINGLE reg_quant
      FROM zabsf_pp013
      INTO (@DATA(l_reg_quant))
     WHERE areaid  EQ @inputobj-areaid
       AND werks   EQ @inputobj-werks
       AND arbpl   EQ @arbpl
       AND endda   GT @sy-datum
       AND begda   LT @sy-datum.


*<< BMR END EDIT 07.10.2016

    CASE l_reg_quant.
      WHEN c_a.
*      Get batch production
        SELECT SINGLE batch
          FROM zabsf_pp066
          INTO (@DATA(l_batch))
         WHERE werks EQ @inputobj-werks
           AND aufnr EQ @aufnr
           AND vornr EQ @vornr.

*      Get Storage location
        SELECT SINGLE lgort
          FROM afpo
          INTO (@DATA(l_lgort))
         WHERE aufnr EQ @aufnr.

*      Check quantity confirmed
        SELECT SINGLE cinsm, clabs
          FROM mchb
          INTO (@DATA(l_cinsm),@DATA(l_clabs))
         WHERE matnr EQ @matnr
           AND werks EQ @inputobj-werks
           AND lgort EQ @l_lgort
           AND charg EQ @l_batch.
* BMR EDIT 04.05.2018 - esta a arredondar a qtd às unidades
*      Stock batch - Quantity confirmed
*        DATA(l_stock) = l_cinsm + l_clabs.
        DATA: l_stock TYPE menge_d,
              l_lmnga TYPE menge_d.
*      Good quantity to confirm
*        DATA(l_lmnga) = lmnga - l_stock.

        l_stock = l_cinsm + l_clabs.

        l_lmnga =  lmnga - l_stock.
*<<BMR END EDIT.

        IF l_lmnga LE 0.
*        Invalid registration. Work center & with absolute qauntity registration.
          CALL METHOD zabsf_pp_cl_log=>add_message
            EXPORTING
              msgty      = 'E'
              msgno      = '088'
              msgv1      = arbpl
            CHANGING
              return_tab = return_tab.
        ELSE.
*        Quantity to confirm
          confirm_qty = l_lmnga.
        ENDIF.
      WHEN OTHERS.
*      Quantity to confirm
        confirm_qty = lmnga.
    ENDCASE.
  ENDMETHOD.


METHOD check_available_stock.
* Constants
    CONSTANTS: c_261 TYPE bwart VALUE '261'. "GI for order

    DATA l_tot_pec TYPE erfmg.

    DATA goodsmovs_tot    TYPE bapi2017_gm_item_create_t.

    DATA: lv_batch_valid TYPE flag.

*  Get order tupe
    SELECT SINGLE auart
      FROM aufk
      INTO (@DATA(l_auart))
     WHERE aufnr EQ @aufnr.

    REFRESH goodsmovs_tot.
    MOVE goodsmovements_tab[] TO goodsmovs_tot[].

*  Check if batch had available stock
    LOOP AT goodsmovements_tab INTO DATA(ls_goodsmovements) WHERE move_type EQ c_261.
*    Get material with Batch management requirement indicator
      SELECT SINGLE matkl, xchpf
        FROM mara
        INTO (@DATA(l_matkl),@DATA(l_xchpf))
       WHERE matnr EQ @ls_goodsmovements-material
         AND xchpf EQ @abap_true.

      IF l_xchpf IS NOT INITIAL.
*      Get Available stock for batch in storage bin
        SELECT SINGLE verme
          FROM lqua
          INTO (@DATA(l_verme))
         WHERE matnr EQ @ls_goodsmovements-material
           AND werks EQ @ls_goodsmovements-plant
           AND charg EQ @ls_goodsmovements-batch
* Begin: SMP ticket 9000010888 - Check Status após alteração no centro de trabalho
*           AND EXISTS ( SELECT crhd~objid
*                          FROM crhd AS crhd
*                         INNER JOIN pkhd AS pkhd
*                            ON crhd~werks EQ pkhd~werks
*                           AND crhd~prvbe EQ pkhd~prvbe
*                         WHERE pkhd~lgnum EQ lqua~lgnum
*                           AND pkhd~lgtyp EQ lqua~lgtyp
*                           AND pkhd~lgpla EQ lqua~lgpla
*                           AND pkhd~matnr EQ lqua~matnr
*                           AND pkhd~werks EQ lqua~werks
*                           AND crhd~arbpl EQ @arbpl ).
AND EXISTS ( SELECT rsnum
                            FROM resb
                           WHERE matnr EQ @ls_goodsmovements-material
                             AND werks EQ @ls_goodsmovements-plant
                             AND lgtyp EQ lqua~lgtyp
                             AND lgpla EQ lqua~lgpla ).
* End: SMP ticket 9000010888
*      Check consumption batch validations
        SELECT SINGLE f_reg_qty
          FROM zabsf_pp071
          INTO (@DATA(l_f_reg_qty))
         WHERE areaid EQ @areaid
           AND werks  EQ @ls_goodsmovements-plant
           AND auart  EQ @l_auart
           AND matkl  EQ @l_matkl.

        IF l_f_reg_qty IS INITIAL.
          "Total of Good Parts
          CLEAR l_tot_pec.
          LOOP AT goodsmovs_tot INTO DATA(ls_goodsmovs_tot)
                                WHERE move_type EQ c_261
                                  AND material EQ ls_goodsmovements-material
                                  AND plant EQ ls_goodsmovements-plant
                                  AND batch EQ ls_goodsmovements-batch.

            l_tot_pec = l_tot_pec + ls_goodsmovs_tot-entry_qnt.
          ENDLOOP.

          IF ( l_verme LT ls_goodsmovements-entry_qnt OR
               l_verme LT l_tot_pec ).
            "Check if batch is set for valid use in table ZABSF_PP078
            CLEAR lv_batch_valid.
            CALL METHOD me->check_batch_open_for_use
              EXPORTING
                werks = ls_goodsmovements-plant
                charg = ls_goodsmovements-batch
              CHANGING
                valid = lv_batch_valid.
            IF lv_batch_valid IS INITIAL.
*          Message: There is no stock available in the consumption batches for registration.
              CALL METHOD zabsf_pp_cl_log=>add_message
                EXPORTING
                  msgty      = 'E'
                  msgno      = '095'
                CHANGING
                  return_tab = return_tab.

*          Message error
              msg_error = abap_true.

              EXIT.
            ENDIF.
          ENDIF.
        ELSE.

          IF ( l_verme EQ ls_goodsmovements-entry_qnt ).
            LOOP AT goodsmovements_tab INTO DATA(ls_goods_cogi)
                                    WHERE move_type = c_261
                                      AND material EQ ls_goodsmovements-material
                                      AND plant EQ ls_goodsmovements-plant
                                      AND batch EQ ls_goodsmovements-batch
                                      AND entry_qnt <> l_verme.
            ENDLOOP.
            IF ( sy-subrc = 0 ).
*          Quantity missing (COGI)
              CALL METHOD zabsf_pp_cl_log=>add_message
                EXPORTING
                  msgty      = 'W'
                  msgno      = '097'
                  msgv1      = ls_goodsmovements-material
                  msgv2      = ls_goods_cogi-entry_qnt
                CHANGING
                  return_tab = return_tab.
            ENDIF.
          ENDIF.

          IF ( l_verme LT ls_goodsmovements-entry_qnt ).
*          Warning: No stock available.
            CALL METHOD zabsf_pp_cl_log=>add_message
              EXPORTING
                msgty      = 'W'
                msgno      = '096'
              CHANGING
                return_tab = return_tab.
          ELSEIF ( is_scrap = 'X' ).
*          Success: Registo da Sucata realizado com Sucesso!
            CALL METHOD zabsf_pp_cl_log=>add_message
              EXPORTING
                msgty      = 'S'
                msgno      = '102'
              CHANGING
                return_tab = return_tab.
          ENDIF.
        ENDIF.

*      Clear variables
        CLEAR: l_matkl,
               l_xchpf,
               l_f_reg_qty,
               l_verme.
      ENDIF.
    ENDLOOP.

*  Sort internal tables
    SORT return_tab BY type ASCENDING id ASCENDING number ASCENDING.

*  Delete duplicates records
    DELETE ADJACENT DUPLICATES FROM return_tab.

*  Clear variables
    CLEAR: l_auart.
  ENDMETHOD.


METHOD check_batch_open_for_use.

    DATA: lv_validation_date TYPE zabsf_pp_e_validation_date,
          lv_valid_days      TYPE zabsf_pp_e_valid_days.

    SELECT SINGLE MAX( validation_date ) valid_days
      INTO (lv_validation_date,lv_valid_days)
      FROM zabsf_pp078
     WHERE werks = werks
       AND charg = charg
      GROUP BY validation_date valid_days.

    CHECK sy-subrc EQ 0.

    lv_validation_date = lv_validation_date + lv_valid_days.
    IF lv_validation_date >= sy-datum.
      valid = 'X'.
    ENDIF.
  ENDMETHOD.


METHOD check_material.

  DATA: ls_marc  TYPE marc,
        ld_matnr TYPE matnr.

  CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
    EXPORTING
      input  = matnr
    IMPORTING
      output = ld_matnr.

  TRANSLATE ld_matnr TO UPPER CASE.

* Check if material exist in system and plant
  SELECT SINGLE *
    FROM marc
    INTO CORRESPONDING FIELDS OF ls_marc
   WHERE matnr EQ ld_matnr
     AND werks EQ inputobj-werks.

  IF sy-subrc EQ 0.
*  Get Base Unit of Measure
    SELECT SINGLE meins xchpf
      FROM mara
      INTO (meins, xchpf)
     WHERE matnr EQ ld_matnr.

*   Get description of material
    SELECT SINGLE maktx
      FROM makt
      INTO maktx
     WHERE matnr EQ ld_matnr
       AND spras EQ sy-langu.

    CALL FUNCTION 'CONVERSION_EXIT_CUNIT_OUTPUT'
      EXPORTING
        input          = meins
        language       = sy-langu
      IMPORTING
        output         = meins_output
      EXCEPTIONS
        unit_not_found = 1
        OTHERS         = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

  ELSE.
*  Material not found in plant
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'E'
        msgno      = '035'
        msgv1      = ld_matnr
        msgv2      = inputobj-werks
      CHANGING
        return_tab = return_tab.
  ENDIF.
ENDMETHOD.


METHOD CONSTRUCTOR.

*Ref. Date
  refdt    = initial_refdt.

*App input data
  inputobj = input_object.

ENDMETHOD.


METHOD CONVERT_UNIT.
*  DATA: e_target_value TYPE p,
*        e_kumza        TYPE komv-kumza,
*        e_kumne        TYPE komv-kumne,
*        e_last_err_msg TYPE arrang_err,
*        l_lmnga        TYPE char17,
*        l_target       TYPE char17,
*        format_imp     TYPE p,
*        i_source_value TYPE p,
*        i_target_unit  TYPE mara-meins,
*        output         TYPE meinh.
*
*  CLEAR: i_target_unit,
*         i_source_value,
*         output,
*         e_target_value,
*         e_kumza,
*         e_kumne,
*         e_last_err_msg,
*         l_lmnga,
*         l_target,
*         boxqty.
*
**Convert unit to internal unit
*  CALL FUNCTION 'CONVERSION_EXIT_CUNIT_INPUT'
*    EXPORTING
*      input          = meinh_target
*    IMPORTING
*      output         = output
*    EXCEPTIONS
*      unit_not_found = 1
*      OTHERS         = 2.
*
**Quantity to convert
*  i_source_value = source_value.
*
**Target Unit
*  i_target_unit = output.
*
**Convert Unit - Total box
*  CALL FUNCTION 'MM_ARRANG_QUANTITY_CONVERSION'
*    EXPORTING
*      i_matnr                 = matnr
*      i_source_value          = i_source_value
*      i_source_unit           = source_unit
*      i_target_unit           = i_target_unit
*    IMPORTING
*      e_target_value          = e_target_value
*      e_kumza                 = e_kumza
*      e_kumne                 = e_kumne
*      e_last_err_msg          = e_last_err_msg
*    EXCEPTIONS
*      invalid_condition_table = 1
*      quantity_conversion     = 2
*      invalid_input_data      = 3
*      OTHERS                  = 4.
*
*  IF e_target_value IS NOT INITIAL.
**    l_target = e_target_value.
*    boxqty = e_kumne.
*  ENDIF.
*
*  CLEAR: e_target_value,
*         e_kumza,
*         e_kumne,
*         e_last_err_msg.

**GEt box of confirmed yield.
*  CALL FUNCTION 'MM_ARRANG_QUANTITY_CONVERSION'
*    EXPORTING
*      i_matnr                 = matnr
*      i_source_value          = lmnga
*      i_source_unit           = source_unit
*      i_target_unit           = i_target_unit
*    IMPORTING
*      e_target_value          = e_target_value
*      e_kumza                 = e_kumza
*      e_kumne                 = e_kumne
*      e_last_err_msg          = e_last_err_msg
*    EXCEPTIONS
*      invalid_condition_table = 1
*      quantity_conversion     = 2
*      invalid_input_data      = 3
*      OTHERS                  = 4.
*
*  IF e_target_value IS NOT INITIAL.
**    l_lmnga = e_target_value.
*    prdqty_box = e_target_value.
*  ENDIF.

*  CONDENSE: l_lmnga,
*            l_target.
*
*  IF l_lmnga IS NOT INITIAL AND l_target IS NOT INITIAL.
**    CONCATENATE l_lmnga '/' l_target INTO boxqty.
*  ELSEIF l_lmnga IS INITIAL AND l_target IS NOT INITIAL.
**    CONCATENATE '0' '/' l_target INTO boxqty.
*  ELSE.
**    boxqty = 0.
*  ENDIF.

*Types for MARM
  TYPES: BEGIN OF ty_marm,
           nrseq TYPE numc5,
           meinh TYPE marm-meinh,
           umrez TYPE marm-umrez,
           umren TYPE marm-umren,
           azsub TYPE meanzsub,      "Number of Lower-Level Units of Measure
           mesub TYPE mesub,         "Lower-Level Unit of Measure in a Packing Hierarchy
           bunit TYPE char1,
         END OF ty_marm.

*Internal tables
  DATA: lt_marm TYPE TABLE OF ty_marm.

*Structures
  DATA: ls_marm TYPE ty_marm.

*Variables
  DATA: l_num_init     TYPE numc5,
        l_mesub        TYPE mesub,
        l_azsub        TYPE absai,
        l_nrseq        TYPE numc5,
        l_source_value TYPE p,
        l_source_unit  TYPE meins,
        l_target_unit  TYPE meins,
        l_kumne        TYPE komv-kumne,
        l_kumza        TYPE komv-kumza.

*Get material detail
  SELECT SINGLE *
    FROM mara
    INTO @DATA(ls_mara)
   WHERE matnr EQ @matnr.

  IF ls_mara IS NOT INITIAL.
*  Get Units of Measure for Material
    SELECT meinh, umrez, umren
      FROM marm
      INTO CORRESPONDING FIELDS OF TABLE @lt_marm
     WHERE matnr EQ @ls_mara-matnr.

    IF lt_marm[] IS NOT INITIAL.
*    Calculates the lower units
      LOOP AT lt_marm INTO ls_marm.
        IF ls_marm-umren IS NOT INITIAL.
          ls_marm-azsub = ls_marm-umrez / ls_marm-umren.
          MODIFY lt_marm FROM ls_marm.
        ENDIF.
      ENDLOOP.

*    Creates the hierarchical structure of units of measurement
      SORT lt_marm BY azsub DESCENDING.

      DESCRIBE TABLE lt_marm LINES l_num_init.

*    Lower-Level Unit of Measure in a Packing Hierarchy
      l_mesub = ls_mara-meins.
*    Sequence
      l_nrseq = l_num_init.

      CLEAR ls_marm.

      LOOP AT lt_marm INTO ls_marm.
        IF sy-tabix EQ 1.
          IF ls_marm-umrez IS NOT INITIAL.
*          Number of Lower-Level Units of Measure
            l_azsub = ls_marm-umren / ls_marm-umrez.
          ENDIF.

          CLEAR l_mesub.
        ENDIF.
        IF sy-tabix EQ l_num_init.
          ls_marm-bunit = 'X'. "unidade mais pequena
        ENDIF.

*      Sequence
        ls_marm-nrseq = l_nrseq.
*      Number of Lower-Level Units of Measure
        IF ls_marm-umrez IS NOT INITIAL AND l_azsub IS NOT INITIAL.
          ls_marm-azsub = ls_marm-umren / ls_marm-umrez / l_azsub.
        ENDIF.

*      Lower-Level Unit of Measure in a Packing Hierarchy
        ls_marm-mesub = l_mesub.

        MODIFY lt_marm FROM ls_marm.

*      Lower-Level Unit of Measure in a Packing Hierarchy
        l_mesub = ls_marm-meinh.

*      Number of Lower-Level Units of Measure
        IF ls_marm-umrez IS NOT INITIAL.
          l_azsub = ls_marm-umren / ls_marm-umrez.
        ENDIF.

*      Sequence
        SUBTRACT 1 FROM l_nrseq.
      ENDLOOP.

      LOOP AT lt_marm INTO ls_marm.
        IF  ls_marm-bunit = 'X'.
*        Target Unit
          l_target_unit = ls_marm-meinh.
        ELSE.
*        Source Unit
          l_source_unit = ls_marm-meinh.
        ENDIF.
      ENDLOOP.

*    Quantity
      l_source_value = source_value.

*    Get quantity conversion
      CALL FUNCTION 'MM_ARRANG_QUANTITY_CONVERSION'
        EXPORTING
          i_matnr                 = matnr
          i_source_value          = l_source_value
          i_source_unit           = l_source_unit
          i_target_unit           = l_target_unit
        IMPORTING
          e_kumne                 = l_kumne
          e_kumza                 = l_kumza
        EXCEPTIONS
          invalid_condition_table = 1
          quantity_conversion     = 2
          invalid_input_data      = 3
          OTHERS                  = 4.

      IF l_kumza IS NOT INITIAL.
        boxqty = l_kumza.
*      Alternative unit
        unit_alt = l_target_unit.
      ENDIF.
    ENDIF.
  ENDIF.
ENDMETHOD.


method create_production_batch.
    "constantes
    constants: c_kzcla type t156-kzcla value '1', "Option to classify batches
               c_xkcfc type t156-xkcfc value 'X'. "Extended classification via CFC
    "variáveis locais
    data: ls_batch_create  type mcha,
          ls_newbatch_str  type mcha,
          lt_char_of_batch type table of clbatch,
          lt_newbatch_tab  type table of mcha.

    "limpar variáveis exportação
    clear: et_return_tab, ex_newbatch_var, ex_error_var.
    "percorrer todas as caracteristicas
    loop at it_characts_tab into data(ls_characts_str).
      append value #( atnam = ls_characts_str-atnam
                      atwtb = ls_characts_str-atwrt ) to lt_char_of_batch.
    endloop.
    "material
    ls_batch_create-matnr = im_refmatnr_var.
    "centro
    ls_batch_create-werks = im_refwerks_var.
    "tipo de avaliação
    " ls_batch_create-bwtar = im_refbatch_var.
    "data de produção
    ls_batch_create-hsdat = sy-datum.
    "criar lote
    call function 'VB_CREATE_BATCH'
      exporting
        ymcha                        = ls_batch_create
        ref_matnr                    = im_refmatnr_var
        ref_charg                    = im_refbatch_var
        ref_werks                    = im_refwerks_var
        kzcla                        = c_kzcla
        xkcfc                        = c_xkcfc
      importing
        ymcha                        = ls_newbatch_str
      tables
        char_of_batch                = lt_char_of_batch
        new_batch                    = lt_newbatch_tab
        return                       = et_return_tab
      exceptions
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
        others                       = 33.
    if sy-subrc ne 0.
    endif.

    loop at et_return_tab transporting no fields
      where type ca 'AEX'.
      "exportação de erro
      ex_error_var = abap_true.
      "sair do processo
      return.
    endloop.

    ex_newbatch_var = ls_newbatch_str-charg.

    call function 'BAPI_TRANSACTION_COMMIT'
      exporting
        wait = 'X'.

  endmethod.


method get_availability_status.
    "obter configuração
    try.
        "ATP Checked
        call method zcl_bc_fixed_values=>get_single_value
          exporting
            im_paramter_var = zcl_bc_fixed_values=>gc_statsatp_cst
            im_modulesp_var = zcl_bc_fixed_values=>gc_productn_cst
          importing
            ex_prmvalue_var = data(lv_atpcheck_var).

        "componentes em falta
        call method zcl_bc_fixed_values=>get_single_value
          exporting
            im_paramter_var = zcl_bc_fixed_values=>gc_missingm_cst
            im_modulesp_var = zcl_bc_fixed_values=>gc_productn_cst
          importing
            ex_prmvalue_var = data(lv_missingm_var).
      catch zcx_pp_exceptions.
        "sair do processamento
        return.
    endtry.

    "verificar status de override
    select single *
      from zabsf_pp080
      into @data(ls_override_str)
        where aufnr    eq @ch_prodordr_str-aufnr
          and override eq @abap_true.
    if sy-subrc eq 0.
      "set color Yellow
      ch_prodordr_str-status_color = 'Y'.
      "set override status
      ch_prodordr_str-override = abap_true.

      ch_prodordr_str-components_checked = abap_true.
      ch_prodordr_str-missing_parts = abap_true.
      "sair do processamento
      return.
    else.
      "verficar ATP checked ou missing components
      select aufk~aufnr, aufk~objnr,
             jest~stat
        into table @data(lt_ordersts_tab)
        from aufk as aufk
        left join jest as jest
          on jest~objnr eq aufk~objnr
         and jest~inact eq @space
       where aufk~aufnr  eq @ch_prodordr_str-aufnr
         and ( jest~stat eq @lv_atpcheck_var or
               jest~stat eq @lv_missingm_var ).
      if sy-subrc ne 0.
        ch_prodordr_str-status_color = 'R'.
        "sair do processamento
        return.
      endif.

      if line_exists( lt_ordersts_tab[ stat = lv_missingm_var ] ).
        "cor vermelha
        ch_prodordr_str-status_color = 'R'.
        ch_prodordr_str-components_checked = abap_true.
        ch_prodordr_str-missing_parts = abap_true.
        return.
      endif.

      if line_exists( lt_ordersts_tab[ stat = lv_atpcheck_var ] )
       and not line_exists( lt_ordersts_tab[ stat = lv_missingm_var ] ).
        "cor verde
        ch_prodordr_str-status_color = 'G'.
        ch_prodordr_str-components_checked = abap_true.
      endif.
    endif.
  endmethod.


  METHOD get_material_serial_profile.
    SELECT matnr sernp
      FROM marc
      INTO TABLE rt_serialprof
      FOR ALL ENTRIES IN it_materials
      WHERE matnr EQ it_materials-matnr
        AND werks EQ it_materials-werks.
  ENDMETHOD.


  METHOD get_orderoperations.
    SELECT o~aufnr AS order, c~vornr AS operation, c~ltxa1 AS description
      FROM afko AS o
      INNER JOIN afvc AS c
        ON c~aufpl EQ o~aufpl
      INTO TABLE @et_orderoperations
      WHERE o~aufnr EQ @iv_aufnr.
  ENDMETHOD.


METHOD get_orders_rework.
  DATA: lt_prdord_temp  TYPE TABLE OF ty_prdord_temp,
        lt_ZABSF_PP019 TYPE TABLE OF zabsf_pp019.

  DATA: wa_prdord_temp TYPE ty_prdord_temp,
        wa_prdord      TYPE zabsf_pp_s_prdord_detail,
        wa_ZABSF_PP019 TYPE zabsf_pp019,
        wa_afru        TYPE afru,
        ls_objid       TYPE cr_objid,
        ld_lmnga       TYPE ru_lmnga,
        ld_rmnga       TYPE ru_rmnga,
        ld_xmnga       TYPE ru_xmnga,
        ld_class       TYPE recaimplclname.

  DATA: lref_sf_operator TYPE REF TO zif_ABSF_PP_operator,
        lref_sf_status   TYPE REF TO zabsf_pp_cl_status.

  DATA: r_auart  TYPE RANGE OF auart,
        wa_auart LIKE LINE OF r_auart.

  FIELD-SYMBOLS <orders_tmp> TYPE ty_prdord_temp.

  REFRESH lt_prdord_temp.

  CLEAR: wa_prdord_temp,
         wa_prdord,
         ls_objid,
         ld_lmnga.

*Get class of interface
  SELECT SINGLE imp_clname
      FROM zabsf_pp003
      INTO ld_class
     WHERE werks EQ inputobj-werks
       AND id_class EQ '3'
       AND endda GE refdt
       AND begda LE refdt.

  TRY .
      CREATE OBJECT lref_sf_operator TYPE (ld_class)
        EXPORTING
          initial_refdt = refdt
          input_object  = inputobj.

    CATCH cx_sy_create_object_error.
*    No data for object in customizing table
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'E'
          msgno      = '019'
          msgv1      = ld_class
        CHANGING
          return_tab = return_tab.

      EXIT.
  ENDTRY.

*Object for class status
  CREATE OBJECT lref_sf_status
    EXPORTING
      initial_refdt = refdt
      input_object  = inputobj.

*Get objid of workcenter
  SELECT SINGLE objid
    FROM crhd
    INTO ls_objid
    WHERE arbpl EQ arbpl
      AND werks EQ werks.

*Get all order type
  SELECT *
    FROM zabsf_pp019
    INTO CORRESPONDING FIELDS OF TABLE lt_ZABSF_PP019
    WHERE areaid EQ inputobj-areaid.

*Get all orders in workcenter
  SELECT aufk~aufnr aufk~objnr aufk~auart afko~gstrp afko~gltrp afko~gstrs afko~gltrs
         afko~ftrmi afko~gamng afko~gmein afko~plnbez afko~stlbez afko~aufpl afko~trmdt
         afvc~aplzl afvc~vornr afvc~ltxa1 afvc~steus afvc~rueck afvc~rmzhl jest1~stat
         afvc~zerma
    INTO CORRESPONDING FIELDS OF TABLE lt_prdord_temp
    FROM afvc AS afvc
    INNER JOIN t430 AS t430
     ON t430~steus EQ afvc~steus
    AND t430~ruek EQ '1'
    INNER JOIN afko AS afko
     ON afko~aufpl EQ afvc~aufpl
    INNER JOIN aufk AS aufk
     ON afko~aufnr EQ aufk~aufnr
    INNER JOIN jest AS jest
      ON jest~objnr EQ aufk~objnr
     AND jest~stat  EQ 'I0002'
     AND jest~inact EQ space
     LEFT OUTER JOIN jest AS jest1
      ON jest1~objnr EQ aufk~objnr
     AND jest1~stat  EQ 'I0009' " CONF
     AND jest1~inact EQ space
    WHERE afvc~arbid EQ ls_objid.

  DELETE lt_prdord_temp WHERE stat = 'I0009'.

*Fill internal table with the information of orders
  IF lt_prdord_temp[] IS NOT INITIAL.

*  Fill internal table with the information of orders
    LOOP AT lt_prdord_temp ASSIGNING <orders_tmp>.
      CLEAR: wa_prdord,
             ld_lmnga.

*    Plant
      wa_prdord-werks = werks.
*    Workcenter
      wa_prdord-arbpl = arbpl.
*    Order number
      wa_prdord-aufnr = <orders_tmp>-aufnr.
*    Tipo de Ordem
      wa_prdord-auart = <orders_tmp>-auart.
*    Operation Number
      wa_prdord-vornr = <orders_tmp>-vornr.
*    Description of operation
      wa_prdord-ltxa1 = <orders_tmp>-ltxa1.
*    Confirmation number of operation
      wa_prdord-rueck = <orders_tmp>-rueck.
*    Routing number for operation
      wa_prdord-aufpl   = <orders_tmp>-aufpl.
*    General counter for order
      wa_prdord-aplzl   = <orders_tmp>-aplzl.

*    Material Number
      IF <orders_tmp>-plnbez IS NOT INITIAL.
        wa_prdord-matnr = <orders_tmp>-plnbez.
      ELSE.
        wa_prdord-matnr = <orders_tmp>-stlbez.
      ENDIF.

*    Material Description
      SELECT SINGLE maktx
        FROM makt
        INTO wa_prdord-maktx
        WHERE matnr EQ wa_prdord-matnr
          AND spras EQ sy-langu.

*    Target quantity
      wa_prdord-gamng = <orders_tmp>-gamng.
*    Base Unit
      wa_prdord-gmein = <orders_tmp>-gmein.
*    Sched. start
      wa_prdord-gstrs = <orders_tmp>-gstrs.
*    Reprogramation of Order
      IF <orders_tmp>-ftrmi NE <orders_tmp>-trmdt.
        wa_prdord-date_reprog = 'X'.
      ENDIF.

*    Confirmed yield
      SELECT SUM( lmnga ) SUM( xmnga ) SUM( rmnga )
        FROM afru
        INTO (ld_lmnga, ld_xmnga, ld_rmnga)
       WHERE rueck EQ <orders_tmp>-rueck
         AND aufnr EQ <orders_tmp>-aufnr
         AND vornr EQ <orders_tmp>-vornr
         AND stokz EQ space
         AND stzhl EQ space.

      IF sy-subrc EQ 0.
*      Confirmed yield
        wa_prdord-lmnga = ld_lmnga.
*      Scrap quantity
        wa_prdord-xmnga = ld_xmnga.
*      Rework Quantity
        wa_prdord-rmnga = ld_rmnga.
      ENDIF.

*    Get quantity and operation missing
      CALL METHOD me->get_qty_vornr
        EXPORTING
          aufnr      = <orders_tmp>-aufnr
          vornr      = <orders_tmp>-vornr
          lmnga      = ld_lmnga
          aufpl      = <orders_tmp>-aufpl
        CHANGING
          qty_proc   = wa_prdord-qty_proc
          vornr_tot  = wa_prdord-vornr_tot
          return_tab = return_tab.

*    Check if order is rework or normal with order type
      READ TABLE lt_ZABSF_PP019 INTO wa_ZABSF_PP019 WITH KEY auart = <orders_tmp>-auart.

      IF sy-subrc EQ 0.
        wa_prdord-tipord = wa_ZABSF_PP019-tipord.
      ENDIF.

*    Get status of order
      CALL METHOD lref_sf_status->status_object
        EXPORTING
          aufnr       = <orders_tmp>-aufnr
          objty       = 'OR'
          method      = 'G'
        CHANGING
          status_out  = wa_prdord-status
          status_desc = wa_prdord-status_desc
          return_tab  = return_tab.

      APPEND wa_prdord TO prdord_tab.
    ENDLOOP.

*  Order by ascending
    SORT prdord_tab BY aufnr ASCENDING.

*  Delete Order of other Area
    REFRESH r_auart.

    CLEAR: wa_ZABSF_PP019,
           wa_auart.

    LOOP AT lt_ZABSF_PP019 INTO wa_ZABSF_PP019.
      wa_auart-sign = 'I'.
      wa_auart-option = 'EQ'.
      wa_auart-low = wa_ZABSF_PP019-auart.

      APPEND wa_auart TO r_auart.
    ENDLOOP.

*  Delete order types not belonging to the area
    DELETE prdord_tab WHERE auart NOT IN r_auart.

*  Delete status FECH from prdord_tab
    DELETE prdord_tab WHERE status EQ 'FECH'.
    DELETE prdord_tab WHERE status EQ ''.

*  Delete operation with status Completed
    DELETE prdord_tab WHERE status_oper EQ 'CONC'.

*  Get operator of Workcenter
    CALL METHOD lref_sf_operator->get_operator_wrkctr
      EXPORTING
        arbpl           = arbpl
      CHANGING
        oper_wrkctr_tab = oper_wrkctr_tab
        return_tab      = return_tab.

  ELSE.
*  No orders found for inputs
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'I'
        msgno      = '011'
      CHANGING
        return_tab = return_tab.
  ENDIF.
ENDMETHOD.


METHOD get_prod_orders.
*Internal tables
  DATA: lt_prdord_temp TYPE TABLE OF ty_prdord_temp,
        lt_prdord_aux  TYPE TABLE OF ty_prdord_temp.

*Structures
  DATA: ls_prdord TYPE zabsf_pp_s_prdord_detail.

*Variables
  DATA: l_matnr            TYPE mcekpo-matnr,
        l_source_value     TYPE i,
        l_boxqty           TYPE zabsf_pp_e_boxqty,
        l_date_past        TYPE begda,
        l_date_future      TYPE begda,
        l_days             TYPE t5a4a-dlydy,
        l_months           TYPE t5a4a-dlymo,
        l_years            TYPE t5a4a-dlyyr,
        l_langu            TYPE sy-langu,
        l_theoretical_time TYPE vgwrt,
        l_bmsch            TYPE bmsch,
        l_theoretical_qty  TYPE bmsch.

*Reference
  DATA: lref_sf_operator         TYPE REF TO zif_absf_pp_operator,
        lref_sf_status           TYPE REF TO zabsf_pp_cl_status,
        lref_sf_schedules        TYPE REF TO zabsf_pp_cl_schd_regimes,
        lref_sf_batch_operations TYPE REF TO zabsf_pp_cl_batch_operations,
        lref_sf_parameters       TYPE REF TO zabsf_pp_cl_parameters.

*Ranges
  DATA: r_auart    TYPE RANGE OF auart,
        ls_r_auart LIKE LINE OF r_auart,
        r_rueck    TYPE RANGE OF co_rueck,
        r_ruek     TYPE RANGE OF ruek,
        ls_r_ruek  LIKE LINE OF r_ruek,
        ls_r_rueck LIKE LINE OF r_rueck,
        r_rmzhl    TYPE RANGE OF co_rmzhl,
        ls_r_rmzhl LIKE LINE OF r_rmzhl.

  DATA: lv_get_schedule   TYPE flag,
        lv_get_prod_info  TYPE flag,
        lv_get_only_marco TYPE flag.

  DATA: ls_marm           TYPE marm,
        ls_unit           TYPE  zabsf_pp_s_units_of_matnr,
        lv_pepelemt_var   TYPE ps_psp_ele,
        ls_inputobj_str   TYPE zabsf_pp_s_inputobject,
        lv_read_label_var TYPE steus.

  DATA: lt_aufktext_tab TYPE TABLE OF tline.

*Constants
  CONSTANTS: c_parid      TYPE zabsf_pp_e_parid VALUE 'DATA_GET',
             c_parid_at01 TYPE zabsf_pp_e_parid VALUE 'DATA_GET_AT01',
             c_meins      TYPE meins          VALUE 'MIN',
             c_time_24    TYPE sy-uzeit       VALUE '240000',
             c_multimat   TYPE aufart VALUE 'ZPP3'.

  REFRESH: lt_prdord_temp.

  CLEAR: ls_prdord,
         l_matnr,
         l_source_value,
         l_date_past,
         l_date_future,
         l_days,
         l_months,
         l_years.

*Set local language for user
  l_langu = sy-langu.

  SET LOCALE LANGUAGE l_langu.

* Start Change ABACO(AON) : 15.12.2022
* Description: Added filtering support to delete matching status
  DATA lt_istat_filters TYPE string_table.
*Set hardcoded status filters
  lt_istat_filters = VALUE #( ( CONV #( 'I0009' ) ) ).

*Add user defined status filters
  lt_istat_filters = VALUE #( BASE lt_istat_filters FOR lv_istat_filter IN it_istat_filters ( lv_istat_filter ) ).
* End Change ABACO(AON) : 15.12.2022

*>> SETUP CONF
  CREATE OBJECT lref_sf_parameters
    EXPORTING
      initial_refdt = refdt
      input_object  = inputobj.

  CALL METHOD lref_sf_parameters->get_output_settings
    EXPORTING
      parid           = lref_sf_parameters->c_schedule
    IMPORTING
      parameter_value = lv_get_schedule
    CHANGING
      return_tab      = return_tab.

  CALL METHOD lref_sf_parameters->get_output_settings
    EXPORTING
      parid           = lref_sf_parameters->c_prod_info
    IMPORTING
      parameter_value = lv_get_prod_info
    CHANGING
      return_tab      = return_tab.

  CALL METHOD lref_sf_parameters->get_output_settings
    EXPORTING
      parid           = lref_sf_parameters->c_marco_only
    IMPORTING
      parameter_value = lv_get_only_marco
    CHANGING
      return_tab      = return_tab.

  IF lv_get_only_marco EQ abap_true.

* Marco operations Range
    ls_r_ruek-option = 'EQ'.
    ls_r_ruek-low = '1'.
    ls_r_ruek-sign = 'I'.
    APPEND ls_r_ruek TO r_ruek.
  ENDIF.


*Get class of interface
  SELECT SINGLE imp_clname
    FROM zabsf_pp003
    INTO (@DATA(l_class))
   WHERE werks    EQ @inputobj-werks
     AND id_class EQ '3'
     AND endda    GE @refdt
     AND begda    LE @refdt.

  TRY .
      CREATE OBJECT lref_sf_operator TYPE (l_class)
        EXPORTING
          initial_refdt = refdt
          input_object  = inputobj.

    CATCH cx_sy_create_object_error.
*    No data for object in customizing table
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'E'
          msgno      = '019'
          msgv1      = l_class
        CHANGING
          return_tab = return_tab.

      EXIT.
  ENDTRY.

  "obter configuração
*  TRY.
*      "obter valores da configuração
*      CALL METHOD zcl_bc_fixed_values=>get_single_value
*        EXPORTING
*          im_paramter_var = zcl_bc_fixed_values=>gc_charplan_cst
*          im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
*          im_werksval_var = werks
*        IMPORTING
*          ex_prmvalue_var = DATA(lv_charplan_var).
*
*      "chave operação etiqueta anterior
*      IF werks NE '2110'.
*        CALL METHOD zcl_bc_fixed_values=>get_single_value
*          EXPORTING
*            im_paramter_var = zcl_bc_fixed_values=>gc_pp_read_label_cst
*            im_modulesp_var = zcl_bc_fixed_values=>gc_productn_cst
*            im_werksval_var = werks
*          IMPORTING
*            ex_prmvalue_var = DATA(lv_opervar_var).
*        "chave de operação
*        lv_read_label_var = lv_opervar_var.
*      ENDIF.
*    CATCH zcx_bc_exceptions INTO DATA(lo_bcexceptions_obj).
*      "falta configuração
*      CALL METHOD zabsf_pp_cl_log=>add_message
*        EXPORTING
*          msgty      = lo_bcexceptions_obj->msgty
*          msgno      = lo_bcexceptions_obj->msgno
*          msgid      = lo_bcexceptions_obj->msgid
*          msgv1      = lo_bcexceptions_obj->msgv1
*          msgv2      = lo_bcexceptions_obj->msgv2
*          msgv3      = lo_bcexceptions_obj->msgv3
*          msgv4      = lo_bcexceptions_obj->msgv4
*        CHANGING
*          return_tab = return_tab.
*      "sair do processamento
*      RETURN.
*  ENDTRY.

*Object for class status
  CREATE OBJECT lref_sf_status
    EXPORTING
      initial_refdt = refdt
      input_object  = inputobj.

*Get objid of workcenter
  SELECT SINGLE objid
  FROM crhd
  INTO (@DATA(l_objid))
  WHERE arbpl EQ @arbpl
   AND werks EQ @werks.

*Get all order type
  SELECT *
    FROM zabsf_pp019
    INTO TABLE @DATA(lt_zabsf_pp019)
   WHERE areaid EQ @inputobj-areaid.

  IF sy-subrc EQ 0.
    REFRESH r_auart.

    LOOP AT lt_zabsf_pp019 INTO DATA(ls_zabsf_pp019).
      CLEAR: ls_r_auart.
      ls_r_auart-sign = 'I'.
      ls_r_auart-option = 'EQ'.
      ls_r_auart-low = ls_zabsf_pp019-auart.

      APPEND ls_r_auart TO r_auart.
    ENDLOOP.
  ENDIF.

*Get type area
  SELECT SINGLE tarea_id
    FROM zabsf_pp008
    INTO (@DATA(l_tarea_id))
   WHERE areaid EQ @inputobj-areaid
     AND werks  EQ @inputobj-werks
     AND endda  GE @refdt
     AND begda  LE @refdt.

*Get default unit
  SELECT SINGLE parva
    FROM zabsf_pp032
    INTO (@DATA(lv_unit_default))
   WHERE parid EQ 'UNIT_SELECTION'.

*Get number of year to get orders
  IF l_tarea_id EQ 'AT01'.
    SELECT SINGLE parva
      FROM zabsf_pp032
      INTO (@DATA(l_date_get))
     WHERE parid EQ @c_parid_at01.
  ELSE.
    SELECT SINGLE parva
      FROM zabsf_pp032
      INTO (@l_date_get)
     WHERE parid EQ @c_parid.
  ENDIF.

*  ld_years = ld_date_get.
  l_months = l_date_get.

*Date in past
  CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
    EXPORTING
      date      = sy-datum
      days      = l_days
      months    = l_months
      signum    = '-'
      years     = l_years
    IMPORTING
      calc_date = l_date_past.

*Date in future
  CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
    EXPORTING
      date      = sy-datum
      days      = l_days
      months    = l_months
      signum    = '+'
      years     = l_years
    IMPORTING
      calc_date = l_date_future.

*Get all orders in workcenter
  DATA: lt_aufnr_rng TYPE RANGE OF aufnr,
        lt_vornr_rng TYPE RANGE OF vornr.
  IF aufnr IS NOT INITIAL.
    APPEND VALUE #( sign   = 'I'
                    option = 'EQ'
                    low    = aufnr ) TO lt_aufnr_rng.
  ENDIF.
  IF vornr IS NOT INITIAL.
    APPEND VALUE #( sign   = 'I'
                    option = 'EQ'
                    low    = vornr ) TO lt_vornr_rng.
  ENDIF.
*Get all orders in workcenter (or only a specific order/operation)
  "ADR - 12/10/22 Verificar se existem Areas para trazer todas as ordens, incluindo as que não estão assignadas
  DATA:   lr_type_all_op_area_rule     TYPE RANGE OF atnam.
  TRY.
      zcl_bc_fixed_values=>get_ranges_value( EXPORTING
                                               im_paramter_var = zcl_bc_fixed_values=>gc_all_op_tp_area_cst
                                               im_modulesp_var = zcl_bc_fixed_values=>gc_productn_cst
                                             IMPORTING
                                               ex_valrange_tab = lr_type_all_op_area_rule ).
    CATCH zcx_pp_exceptions.
  ENDTRY.

  "area e initial
  IF lr_type_all_op_area_rule IS INITIAL.
    "sair do processamento
    RETURN.
  ENDIF.

  " ordens assinadas pela area 'AGU', 'PREP', 'PROC', 'STOP' e sem assinar 'INIT'
  IF inputobj-areaid NOT IN lr_type_all_op_area_rule .
    " Unicamente as ordens assinadas  STATUS 'AGU', 'PREP', 'PROC', 'STOP'
    DATA(lr_status_oper) =
      VALUE plmt_audit_ranges_for_status( sign = 'I' option = 'EQ'
        ( low = 'AGU' ) ( low = 'PREP') ( low = 'PROC') ( low = 'STOP') ).
  ELSE.

    lr_status_oper =
     VALUE plmt_audit_ranges_for_status( sign = 'I' option = 'EQ'
       ( low = 'AGU' ) ( low = 'PREP') ( low = 'PROC') ( low = 'STOP') ( low = 'INIT') ( low = 'INI') ).
  ENDIF.


  IF inputobj-areaid NOT IN lr_type_all_op_area_rule .
    " Unicamente as ordens assinadas  STATUS 'AGU', 'PREP', 'PROC', 'STOP'
*  lr_status_oper =
*      VALUE plmt_audit_ranges_for_status( sign = 'I' option = 'EQ'
*        ( low = 'AGU' ) ( low = 'PREP') ( low = 'PROC') ( low = 'STOP') ).

    SELECT aufk~aufnr aufk~objnr aufk~auart afko~gstrp afko~gltrp afko~gstrs afko~gsuzs afko~gltrs
        afko~ftrmi afko~gamng afko~gmein afko~plnbez afko~plnty afko~plnnr afko~cy_seqnr afko~stlbez
        afko~aufpl afko~trmdt afvc~aplzl afvc~vornr afvc~ltxa1 afvc~steus afvc~rueck
        afvc~rmzhl jest1~stat afvc~zerma t430~autwe t430~ruek
      INTO CORRESPONDING FIELDS OF TABLE lt_prdord_temp
      FROM afvc AS afvc
      INNER JOIN t430 AS t430
        ON t430~steus EQ afvc~steus
          "AND t430~ruek EQ '1'
      INNER JOIN afko AS afko
        ON afko~aufpl EQ afvc~aufpl
      INNER JOIN aufk AS aufk
        ON afko~aufnr EQ aufk~aufnr

      INNER JOIN zabsf_pp021 AS sf021
        ON sf021~aufnr EQ aufk~aufnr AND
           sf021~vornr EQ afvc~vornr
      INNER JOIN jest AS jest
        ON jest~objnr EQ aufk~objnr AND
           jest~stat  EQ 'I0002' AND
           jest~inact EQ space
      LEFT OUTER JOIN jest AS jest1
*      ON jest1~objnr EQ aufk~objnr
        ON jest1~objnr EQ afvc~objnr AND
           jest1~stat  EQ 'I0009' AND " CONF
           jest1~inact EQ space
      WHERE afvc~arbid EQ l_objid
        AND ( afko~gstrp GE l_date_past AND
              afko~gstrp LE l_date_future )
        AND sf021~arbpl EQ arbpl
*        AND sf021~status_oper IN lr_status_oper
        AND sf021~status_oper IN lr_status_oper
        AND aufk~auart IN r_auart
        AND aufk~aufnr IN lt_aufnr_rng
        AND afvc~vornr IN lt_vornr_rng
        AND t430~ruek IN r_ruek.
  ELSE.

    SELECT aufk~aufnr aufk~objnr aufk~auart afko~gstrp afko~gltrp afko~gstrs afko~gsuzs afko~gltrs
           afko~ftrmi afko~gamng afko~gmein afko~plnbez afko~plnty afko~plnnr afko~cy_seqnr afko~stlbez
           afko~aufpl afko~trmdt afvc~aplzl afvc~vornr afvc~ltxa1 afvc~steus afvc~rueck
           afvc~rmzhl jest1~stat afvc~zerma t430~autwe t430~ruek
      INTO CORRESPONDING FIELDS OF TABLE lt_prdord_temp
      FROM afvc AS afvc
      INNER JOIN t430 AS t430
        ON t430~steus EQ afvc~steus
          "AND t430~ruek EQ '1'
      INNER JOIN afko AS afko
        ON afko~aufpl EQ afvc~aufpl
      INNER JOIN aufk AS aufk
        ON afko~aufnr EQ aufk~aufnr
*      INNER JOIN zabsf_pp021 AS sf021
*        ON sf021~aufnr EQ aufk~aufnr
*        AND sf021~vornr EQ afvc~vornr
      INNER JOIN jest AS jest
        ON jest~objnr EQ aufk~objnr AND
           jest~stat  EQ 'I0002' AND
           jest~inact EQ space
      LEFT OUTER JOIN jest AS jest1
*        ON jest1~objnr EQ aufk~objnr
        ON jest1~objnr EQ afvc~objnr AND
           jest1~stat  EQ 'I0009' AND " CONF
           jest1~inact EQ space
      WHERE afvc~arbid EQ l_objid
        AND ( afko~gstrp GE l_date_past AND
              afko~gstrp LE l_date_future )
*        AND sf021~arbpl EQ arbpl
*        AND sf021~status_oper IN lr_status_oper
*        AND sf021~status_oper IN lr_status_oper
        AND aufk~auart IN r_auart
        AND aufk~aufnr IN lt_aufnr_rng
        AND afvc~vornr IN lt_vornr_rng
        AND t430~ruek IN r_ruek.

  ENDIF.


  "END ADR - 12/10/22.
  "DELETE lt_prdord_temp WHERE stat = 'I0009'.
* Start Change ABACO(AON) : 15.12.2022
* Description: Added filtering support to delete matching status
  LOOP AT lt_istat_filters ASSIGNING FIELD-SYMBOL(<fs_istat_filter>).
    DELETE lt_prdord_temp WHERE stat = <fs_istat_filter>.
  ENDLOOP.
* End Change ABACO(AON) : 15.12.2022

*Fill internal table with the information of orders
  IF lt_prdord_temp[] IS NOT INITIAL.
    REFRESH lt_prdord_aux.

    lt_prdord_aux[] = lt_prdord_temp[].

    LOOP AT lt_prdord_aux ASSIGNING FIELD-SYMBOL(<fs_prdord>).

*    Get object
      SELECT SINGLE afvc~objnr
        FROM afvc AS afvc
        INNER JOIN afko AS afko
          ON afko~aufpl EQ afvc~aufpl
        WHERE afko~aufnr EQ @<fs_prdord>-aufnr
          AND afvc~vornr EQ @<fs_prdord>-vornr
        INTO (@DATA(l_objnr)).

      IF l_objnr IS NOT INITIAL.
*      Check status
        SELECT *
          FROM jest
          INTO TABLE @DATA(lt_jest)
          WHERE objnr EQ @l_objnr
            AND ( stat EQ 'I0045' OR   "ENTE
                  stat EQ 'I0009' ) "CONF
            AND inact EQ @space.

        IF lt_jest[] IS NOT INITIAL.
          DELETE lt_prdord_temp WHERE aufnr EQ <fs_prdord>-aufnr
                                  AND vornr EQ <fs_prdord>-vornr.

        ENDIF.
      ENDIF.
    ENDLOOP.

*  Get missing quantity and box
    SELECT aufnr, matnr, vornr, gamng, lmnga, gmein, missingqty, boxqty, prdqty_box
      FROM zabsf_pp017
      INTO TABLE @DATA(lt_zabsf_pp017)
      FOR ALL ENTRIES IN @lt_prdord_temp
      WHERE aufnr EQ @lt_prdord_temp-aufnr
        AND vornr EQ @lt_prdord_temp-vornr.

*  Get status of operation
    SELECT *
      FROM zabsf_pp021
      INTO TABLE @DATA(lt_zabsf_pp021)
      FOR ALL ENTRIES IN @lt_prdord_temp
      WHERE arbpl EQ @arbpl
        AND aufnr EQ @lt_prdord_temp-aufnr
        AND vornr EQ @lt_prdord_temp-vornr.

*  Get description of field zerma
    SELECT *
      FROM t429t
      INTO TABLE @DATA(lt_t429t)
      FOR ALL ENTRIES IN @lt_prdord_temp
      WHERE werks EQ @inputobj-werks
        AND spras EQ @sy-langu
        AND zerma EQ @lt_prdord_temp-zerma.

    "get PEP element of production orders
    SELECT *
      FROM afpo
      INTO TABLE @DATA(lt_afpotabl_tab)
      FOR ALL ENTRIES IN @lt_prdord_temp
       WHERE aufnr EQ @lt_prdord_temp-aufnr
         AND projn NE @abap_false
         AND xloek EQ @abap_false.
    IF sy-subrc EQ 0.
      "get project PEP
      SELECT *
        FROM prps
        INTO TABLE @DATA(lt_projects_tab)
        FOR ALL ENTRIES IN @lt_afpotabl_tab
        WHERE pspnr EQ @lt_afpotabl_tab-projn.
    ENDIF.

    "sequência das ordens
    IF lt_prdord_temp IS NOT INITIAL.
      "obter sequência das ordens
      SELECT *
        FROM zabsf_pp084
        INTO TABLE @DATA(lt_sequence_tab)
        FOR ALL ENTRIES IN @lt_prdord_temp
        WHERE werks EQ @werks
          AND arbpl EQ @arbpl
          AND aufnr EQ @lt_prdord_temp-aufnr
          AND vornr EQ @lt_prdord_temp-vornr.
    ENDIF.

*  Fill internal table with the information of orders
    LOOP AT lt_prdord_temp ASSIGNING FIELD-SYMBOL(<fs_orders_tmp>).
      CLEAR: ls_prdord,
             l_matnr,
             l_source_value.
      "ler etiqueta anterior
      IF <fs_orders_tmp>-steus EQ lv_read_label_var AND
        <fs_orders_tmp>-auart EQ 'ZPP2'.
        ls_prdord-read_label = abap_true.
      ENDIF.
*    Marco Operation
      IF <fs_orders_tmp>-ruek EQ '1'.
        ls_prdord-marco = abap_true.
      ENDIF.
      "sequência da ordem
      SHIFT <fs_orders_tmp>-cy_seqnr LEFT DELETING LEADING '0'.
      ls_prdord-cy_seqnr = <fs_orders_tmp>-cy_seqnr.
      "sequência no shopfloor
      ls_prdord-sequence = COND #( WHEN line_exists( lt_sequence_tab[ werks = werks
                                                                      arbpl = arbpl
                                                                      aufnr = <fs_orders_tmp>-aufnr
                                                                      vornr = <fs_orders_tmp>-vornr ] )
                                   THEN lt_sequence_tab[ werks = werks
                                                         arbpl = arbpl
                                                         aufnr = <fs_orders_tmp>-aufnr
                                                         vornr = <fs_orders_tmp>-vornr ]-sequence ).
*    Plant
      ls_prdord-werks = werks.
*    Workcenter
      ls_prdord-arbpl = arbpl.
*    Order number
      ls_prdord-aufnr = <fs_orders_tmp>-aufnr.
*    Tipo de Ordem
      ls_prdord-auart = <fs_orders_tmp>-auart.
*    Operation Number
      ls_prdord-vornr = <fs_orders_tmp>-vornr.
*    Description of operation
      ls_prdord-ltxa1 = <fs_orders_tmp>-ltxa1.
*    Confirmation number of operation
      ls_prdord-rueck = <fs_orders_tmp>-rueck.
*    Routing number for operation
      ls_prdord-aufpl = <fs_orders_tmp>-aufpl.
*    General counter for order
      ls_prdord-aplzl = <fs_orders_tmp>-aplzl.
*    PEP Element
      lv_pepelemt_var  = COND #( WHEN line_exists( lt_afpotabl_tab[ aufnr = ls_prdord-aufnr ] )
                                THEN lt_afpotabl_tab[ aufnr = ls_prdord-aufnr ]-projn ).

* Start Change ABACO(AON) : 31.10.2022
* Description: Added steus
      ls_prdord-steus = <fs_orders_tmp>-steus.
* End Change ABACO(AON) : 31.10.2022

      "format conversion
      IF lv_pepelemt_var IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_ABPSP_OUTPUT'
          EXPORTING
            input  = lv_pepelemt_var
          IMPORTING
            output = ls_prdord-schematics.
        "project
        ls_prdord-psphi = COND #( WHEN line_exists( lt_projects_tab[ pspnr = lv_pepelemt_var ] )
                                THEN lt_projects_tab[ pspnr = lv_pepelemt_var ]-psphi ).
        "format conversion
        CALL FUNCTION 'CONVERSION_EXIT_KONPD_OUTPUT'
          EXPORTING
            input  = ls_prdord-psphi
          IMPORTING
            output = ls_prdord-project.
      ENDIF.

*    Material Number
      IF <fs_orders_tmp>-plnbez IS NOT INITIAL.
        ls_prdord-matnr = <fs_orders_tmp>-plnbez.
      ELSE.
        ls_prdord-matnr = <fs_orders_tmp>-stlbez.
      ENDIF.
*    Material Description
      SELECT SINGLE cuobj
        FROM afpo
        INTO @DATA(lv_cuobj_var)
         WHERE aufnr EQ @ls_prdord-aufnr.
      "read data from classification
      zcl_mm_classification=>get_material_desc_by_object( EXPORTING
                                                            im_cuobj_var       = lv_cuobj_var
                                                          IMPORTING
                                                            ex_description_var = DATA(lv_matrdesc_var) ).
      IF lv_matrdesc_var IS NOT INITIAL.
        ls_prdord-maktx = lv_matrdesc_var.
      ELSE.
        "get description from database table
        SELECT SINGLE maktx
         FROM makt
          INTO @ls_prdord-maktx
           WHERE matnr EQ @ls_prdord-matnr
             AND spras EQ @sy-langu.
      ENDIF.
* Unit of measure.
      SELECT * FROM marm INTO TABLE @DATA(lt_marm)
        WHERE matnr EQ  @ls_prdord-matnr.

      LOOP AT lt_marm INTO ls_marm.

        ls_unit-matnr = ls_marm-matnr.
        ls_unit-meinh = ls_marm-meinh.

        CALL FUNCTION 'CONVERSION_EXIT_CUNIT_OUTPUT'
          EXPORTING
            input          = ls_marm-meinh
            language       = sy-langu
          IMPORTING
            output         = ls_unit-meinh_output
          EXCEPTIONS
            unit_not_found = 1
            OTHERS         = 2.
        IF sy-subrc <> 0.
* Implement suitable error handling here
        ENDIF.

        IF  ls_marm-meinh EQ lv_unit_default.
          ls_unit-default_unit = abap_true.
        ENDIF.

        APPEND ls_unit TO ls_prdord-units.
        CLEAR: ls_unit, ls_marm.
      ENDLOOP.

      SORT ls_prdord-units BY default_unit DESCENDING.

*    Target quantity
      ls_prdord-gamng = <fs_orders_tmp>-gamng.
*    Base Unit
      ls_prdord-gmein = <fs_orders_tmp>-gmein.
*    Sched. start
      ls_prdord-gstrs = <fs_orders_tmp>-gstrs.
*    Sched_ time
      IF <fs_orders_tmp>-gsuzs EQ c_time_24.
        ls_prdord-gsuzs = <fs_orders_tmp>-gsuzs - 1.
      ELSE.
        ls_prdord-gsuzs = <fs_orders_tmp>-gsuzs.
      ENDIF.

*    Reprogramation of Order
      IF <fs_orders_tmp>-ftrmi NE <fs_orders_tmp>-trmdt.
        ls_prdord-date_reprog = 'X'.
      ENDIF.

*    Confirmed yield
      SELECT SUM( gmnga ), SUM( xmnga ), SUM( rmnga )
        FROM afru
        INTO (@DATA(l_lmnga), @DATA(l_xmnga), @DATA(l_rmnga))
       WHERE rueck EQ @<fs_orders_tmp>-rueck
         AND aufnr EQ @<fs_orders_tmp>-aufnr
         AND vornr EQ @<fs_orders_tmp>-vornr
         AND stokz EQ @space
         AND stzhl EQ @space.

      IF sy-subrc EQ 0.
*      Confirmed yield
        ls_prdord-lmnga = l_lmnga.
*      Scrap quantity
        ls_prdord-xmnga = l_xmnga.
*      Rework Quantity
        ls_prdord-rmnga = l_rmnga.
      ENDIF.

* Start Change ABACO(AON) : 09.11.2022
* Description: Append on ZABSF_PP017

*    Get missing quantity and box
      READ TABLE lt_zabsf_pp017 INTO DATA(ls_zabsf_pp017) WITH KEY aufnr = <fs_orders_tmp>-aufnr
                                                          vornr = <fs_orders_tmp>-vornr
                                                          matnr = ls_prdord-matnr.

      IF sy-subrc EQ 0.
*      Reverse quantity
        SELECT SUM( lmnga )
          FROM afru
          INTO @DATA(l_reverse)
         WHERE rueck EQ @<fs_orders_tmp>-rueck
           AND aufnr EQ @<fs_orders_tmp>-aufnr
           AND stokz NE @space
           AND stzhl NE @space.

        ls_prdord-missingqty = <fs_orders_tmp>-gamng - l_lmnga - l_rmnga - l_xmnga - l_reverse.

        ls_prdord-prdqty_box = ls_zabsf_pp017-prdqty_box.
        ls_prdord-boxqty = ls_zabsf_pp017-boxqty.
      ELSE.
*      Calc missing quantity
        ls_prdord-missingqty = <fs_orders_tmp>-gamng - ( l_lmnga + l_xmnga + l_rmnga ).

*    Quantity of Box
*     Get basic unit of material
        SELECT SINGLE meins
          FROM mara
          INTO @DATA(ld_meins)
          WHERE matnr EQ @ls_prdord-matnr.

        IF sy-subrc NE 0.
          ld_meins = <fs_orders_tmp>-gmein.
        ENDIF.

*      Quantity to convert
        l_source_value = <fs_orders_tmp>-gamng.
        l_matnr = ls_prdord-matnr.
        DATA(l_source_unit) = ld_meins.

*      Convert Unit
        CALL METHOD me->convert_unit
          EXPORTING
            matnr        = l_matnr
            source_value = l_source_value
            source_unit  = l_source_unit
            lmnga        = l_lmnga
          CHANGING
            prdqty_box   = ls_prdord-prdqty_box
            boxqty       = ls_prdord-boxqty.

*      Insert data in database
        CLEAR ls_zabsf_pp017.
        ls_zabsf_pp017-aufnr = <fs_orders_tmp>-aufnr.
        ls_zabsf_pp017-matnr = ls_prdord-matnr.
        ls_zabsf_pp017-vornr = <fs_orders_tmp>-vornr.
        ls_zabsf_pp017-gamng = <fs_orders_tmp>-gamng.
        ls_zabsf_pp017-lmnga = l_lmnga.
        ls_zabsf_pp017-missingqty = <fs_orders_tmp>-gamng - ( l_lmnga + l_xmnga + l_rmnga ).
        ls_zabsf_pp017-gmein = <fs_orders_tmp>-gmein.
        ls_zabsf_pp017-prdqty_box = ls_prdord-prdqty_box.
        ls_zabsf_pp017-boxqty = ls_prdord-boxqty.

        DATA ls_zabsf_pp017_alt TYPE zabsf_pp017.
        MOVE-CORRESPONDING ls_zabsf_pp017 TO ls_zabsf_pp017_alt.
        INSERT INTO zabsf_pp017 VALUES ls_zabsf_pp017_alt.
      ENDIF.
* End Change ABACO(AON) : 09.11.2022


*    Get quantity and operation missing
      CALL METHOD me->get_qty_vornr
        EXPORTING
          aufnr      = <fs_orders_tmp>-aufnr
          vornr      = <fs_orders_tmp>-vornr
          lmnga      = l_lmnga
          aufpl      = <fs_orders_tmp>-aufpl
        CHANGING
          qty_proc   = ls_prdord-qty_proc
          vornr_tot  = ls_prdord-vornr_tot
          return_tab = return_tab.

      ls_prdord-qty_proc = ls_prdord-qty_proc - l_rmnga - l_xmnga.

*    Check if order is rework or normal with order type
      READ TABLE lt_zabsf_pp019 INTO ls_zabsf_pp019 WITH KEY auart = <fs_orders_tmp>-auart.

      IF sy-subrc EQ 0.
        ls_prdord-tipord = ls_zabsf_pp019-tipord.
      ENDIF.

*    Get operators
      CALL METHOD lref_sf_operator->get_operator_ord
        EXPORTING
          arbpl        = arbpl
          aufnr        = <fs_orders_tmp>-aufnr
          vornr        = <fs_orders_tmp>-vornr
          tipord       = ls_prdord-tipord
        CHANGING
          operator_tab = ls_prdord-oprid_tab
          return_tab   = return_tab.

*    Get status of order
      CALL METHOD lref_sf_status->status_object
        EXPORTING
          aufnr       = <fs_orders_tmp>-aufnr
          objty       = 'OR'
          method      = 'G'
          actionid    = actionid
        CHANGING
          status_out  = ls_prdord-status
          status_desc = ls_prdord-status_desc
          return_tab  = return_tab.

      IF ls_prdord-status IS INITIAL.
        ls_prdord-status = 'INI'.
      ENDIF.

      " Areas com condições para aparecer as ordens já em estado AGU
      IF inputobj-areaid IN lr_type_all_op_area_rule AND ls_prdord-status IS INITIAL.
        ls_prdord-status = 'AGU'.
      ENDIF.

*    Get status of operation
      READ TABLE lt_zabsf_pp021 INTO DATA(ls_zabsf_pp021) WITH KEY arbpl = arbpl
                                                                     aufnr = <fs_orders_tmp>-aufnr
                                                                     vornr = <fs_orders_tmp>-vornr.
      " Areas com condições para aparecer as ordens já em estado AGU
      IF inputobj-areaid IN lr_type_all_op_area_rule.
        IF ls_zabsf_pp021-status_oper EQ 'INI'.
          ls_zabsf_pp021-status_oper = 'AGU'.
        ENDIF.
      ENDIF.

      IF sy-subrc EQ 0.
        ls_prdord-status_oper = ls_zabsf_pp021-status_oper.
      ELSE.
*      Save status of operation in database
        CALL METHOD lref_sf_status->status_object
          EXPORTING
            arbpl      = arbpl
            aufnr      = <fs_orders_tmp>-aufnr
            vornr      = <fs_orders_tmp>-vornr
            objty      = 'OV'
            method     = 'S'
*           status_oper = status_actv
            actionid   = 'NEXT' "actionid
          CHANGING
            status_out = ls_prdord-status_oper
            return_tab = return_tab.

*        wa_prdord-status_oper = 'INI'.
      ENDIF.

      ls_prdord-zerma_txt = <fs_orders_tmp>-zerma.

*SETUP
      IF lv_get_prod_info EQ abap_true.
*    Get Current theoretical cycle counter and Total theoretical quantity
        CALL METHOD me->get_theorical_data
          EXPORTING
            aufnr            = <fs_orders_tmp>-aufnr
            vornr            = <fs_orders_tmp>-vornr
            aufpl            = <fs_orders_tmp>-aufpl
            aplzl            = <fs_orders_tmp>-aplzl
            plnty            = <fs_orders_tmp>-plnty
            plnnr            = <fs_orders_tmp>-plnnr
          IMPORTING
*           vgw02            = l_vgw02
            theoretical_time = l_theoretical_time
            bmsch            = l_bmsch
            theoretical_qty  = l_theoretical_qty.

*    Current theoretical cycle counter
        IF l_theoretical_time IS NOT INITIAL.
          ls_prdord-time_mcycle = l_theoretical_time.
        ENDIF.

*    Total theoretical quantity
        IF l_theoretical_qty IS NOT INITIAL.
          ls_prdord-numb_mcycle = l_theoretical_qty.
        ENDIF.

*    Theoretical quantity
        IF l_bmsch IS NOT INITIAL.
          ls_prdord-theoretical_qty = l_bmsch.
        ENDIF.
      ENDIF.

*    Name of user
      SELECT SINGLE vorna, nachn
        FROM pa0002
        INTO (@DATA(l_vorna), @DATA(l_nachn))
       WHERE pernr EQ @inputobj-pernr.

      IF l_vorna IS NOT INITIAL OR l_nachn IS NOT INITIAL.
*      First and last name
        CONCATENATE l_vorna l_nachn INTO ls_prdord-cname SEPARATED BY space.
      ENDIF.

*>> SETUP Get regimes and schedules
      IF lv_get_schedule EQ abap_true.

        IF lref_sf_schedules IS NOT BOUND.
*      Create object for schedules, regime and qualifications
          CREATE OBJECT lref_sf_schedules
            EXPORTING
              initial_refdt = refdt
              input_object  = inputobj.
        ENDIF.

*    Get schedules and regimes
        CALL METHOD lref_sf_schedules->get_info_for_prodorder
          EXPORTING
            confirmation  = ls_prdord-rueck
          IMPORTING
            schedule_id   = ls_prdord-schedule_id
            schedule_desc = ls_prdord-schedule_desc
            regime_id     = ls_prdord-regime_id
            regime_desc   = ls_prdord-regime_desc
            count_ini     = ls_prdord-count_ini.
      ENDIF.

*>>> BMR INSERT 29.08.2016 - get batch number
      IF lref_sf_batch_operations IS NOT BOUND.
*      Create object for Batch operations
        CREATE OBJECT lref_sf_batch_operations
          EXPORTING
            initial_refdt = refdt
            input_object  = inputobj.
      ENDIF.

*    Get batch
      CALL METHOD lref_sf_batch_operations->get_batch
        EXPORTING
          aufnr   = ls_prdord-aufnr
          vornr   = ls_prdord-vornr
        IMPORTING
          e_batch = ls_prdord-batch
          e_lenum = ls_prdord-lenum.
*<<< BMR INSERT

*    Get card active
      SELECT SINGLE ficha
        FROM zabsf_pp066
        INTO (@DATA(l_ficha))
       WHERE werks EQ @ls_prdord-werks
         AND aufnr EQ @ls_prdord-aufnr
         AND vornr EQ @ls_prdord-vornr.

*    Get number cycle confirmed
      SELECT SUM( numb_cycle )
        FROM zabsf_pp065
        INTO (@DATA(l_numb_cycle))
       WHERE conf_no EQ @ls_prdord-rueck
         AND ficha   EQ @l_ficha.

*    Number cycle
      ls_prdord-numb_cycle = l_numb_cycle.

*    Get good quantity and scrap of card active
      SELECT DISTINCT conf_no, conf_cnt
        FROM zabsf_pp065
        INTO TABLE @DATA(lt_sf_065)
       WHERE conf_no  EQ @ls_prdord-rueck
         AND ficha    EQ @l_ficha
         AND reversal NE @abap_true.

      IF lt_sf_065[] IS NOT INITIAL.
        REFRESH: r_rueck,
                 r_rmzhl.

*      Range for Confirmation number
        CLEAR ls_r_rueck.
        ls_r_rueck-sign = 'I'.
        ls_r_rueck-option = 'EQ'.
        ls_r_rueck-low = ls_prdord-rueck.

        APPEND ls_r_rueck TO r_rueck.

*      Range for counter of confirmation number
        LOOP AT lt_sf_065 INTO DATA(ls_sf_065).
          CLEAR ls_r_rmzhl.
          ls_r_rmzhl-sign = 'I'.
          ls_r_rmzhl-option = 'EQ'.
          ls_r_rmzhl-low = ls_sf_065-conf_cnt.

          APPEND ls_r_rmzhl TO r_rmzhl.
        ENDLOOP.
*SETUP
        IF lv_get_prod_info EQ abap_true.
*      Sum good quantity and scrap quantity
          SELECT SUM( lmnga ), SUM( xmnga )
            FROM afru
            INTO (@DATA(l_lmnga_card), @DATA(l_xmnga_card))
           WHERE rueck IN @r_rueck
             AND rmzhl IN @r_rmzhl.

*      Good quantity - Card active
          ls_prdord-lmnga_card = l_lmnga_card.
*      Scrap quantity - Card active
          ls_prdord-xmnga_card = l_xmnga_card.
        ENDIF.
      ENDIF.

*    Get total quantity (Scrap and good quantity) from counter initial active
*SETUP
      IF lv_get_prod_info EQ abap_true.
        CALL METHOD me->get_total_quantity_counter
          EXPORTING
            rueck     = ls_prdord-rueck
            ficha     = l_ficha
          IMPORTING
            total_qty = ls_prdord-total_qty.

      ENDIF.
*    Automatic good movements
      ls_prdord-autwe = <fs_orders_tmp>-autwe.

      "get availability status
      get_availability_status(  EXPORTING
                                  im_werksval_var = werks
                                CHANGING
                                  ch_prodordr_str = ls_prdord ).
      "check missing parts flag
      IF ls_prdord-missing_parts EQ abap_true.
        "Only for a specific order/operation
        IF aufnr IS NOT INITIAL AND vornr IS NOT INITIAL.
          "plant
          ls_inputobj_str-werks = werks.
          "get missing materials
          CALL FUNCTION 'ZABSF_PP_CHECK_MAT_AVAIL_ORDER'
            EXPORTING
              aufnr               = ls_prdord-aufnr
              inputobj            = ls_inputobj_str
            IMPORTING
              et_missing_mats_tab = ls_prdord-availability_information.
        ENDIF.
      ENDIF.
      "multimaterial flag
      IF ls_prdord-auart EQ c_multimat.
        ls_prdord-multimaterial = abap_true.
        "get componentes
        zabsf_pp_cl_consumptions=>get_mulitmaterial_components( EXPORTING
                                                                  inputobj       = me->inputobj
                                                                  aufnr          = ls_prdord-aufnr
                                                                  vornr          = ls_prdord-vornr
                                                                CHANGING
                                                                  components_tab = ls_prdord-components
                                                                  ch_orderqtt_var = ls_prdord-gamng
                                                                  ch_produced_var = ls_prdord-lmnga
                                                                  ch_missing_var  = ls_prdord-missingqty ).
      ELSE.
        "quantida em falta
*02/01/2023 ADR:  se mantem o resto calculado previamente com o scrap.
*        ls_prdord-missingqty = ls_prdord-gamng - ls_prdord-lmnga.
      ENDIF.

      "get plano fabrico
      CALL METHOD zcl_mm_classification=>get_classification_config
        EXPORTING
          im_instance_cuobj_var = lv_cuobj_var
        IMPORTING
          ex_classfication_tab  = DATA(lt_classfic_tab)
        EXCEPTIONS
          instance_not_found    = 1
          OTHERS                = 2.
      IF sy-subrc <> 0.
      ENDIF.
      "plano de fabrico
*      ls_prdord-production_plan = COND #( WHEN line_exists( lt_classfic_tab[ atnam = lv_charplan_var ] )
*                                          THEN lt_classfic_tab[ atnam = lv_charplan_var ]-atwrt ).
*>>> ABACO-AJB 18.02.2021 - Total traceability
*      IF ls_prdord-production_plan IS NOT INITIAL.
*        SELECT SINGLE traceability
*          INTO ls_prdord-traceability
*          FROM zpp_pfnumber_tab
*          WHERE plano_fabrico = ls_prdord-production_plan.
*      ENDIF.
*<<< ABACO-AJB 18.02.2021 - Total traceability

      "programa
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          id                      = 'KOPF'
          language                = sy-langu
          name                    = CONV tdobname( |{ sy-mandt }{ ls_prdord-aufnr ALPHA = IN }| )
          object                  = 'AUFK'
        TABLES
          lines                   = lt_aufktext_tab
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
      IF sy-subrc <> 0.
      ENDIF.
      "programa
      IF line_exists( lt_aufktext_tab[ 1 ] ).
        "programa
        ls_prdord-program = lt_aufktext_tab[ 1 ]-tdline.
      ENDIF.

      "BMR 17.06.2020 - posto de trabalho
      SELECT SINGLE kako~kapid, kako~name, kakt~ktext
        FROM zabsf_pp014 AS p14
        INNER JOIN kako AS kako
         ON kako~kapid EQ p14~kapid
        LEFT JOIN kakt AS kakt
         ON kakt~kapid EQ kako~kapid
         AND kakt~spras EQ @sy-langu
        INTO ( @ls_prdord-kapid, @ls_prdord-name, @ls_prdord-ktext )
          WHERE p14~aufnr EQ @ls_prdord-aufnr
            AND p14~vornr EQ @ls_prdord-vornr
            AND p14~arbpl EQ @arbpl
            AND p14~status EQ 'A'.

      APPEND: ls_prdord TO prdord_tab.

*      DATA ls_ZABSF_PP017 TYPE ZABSF_PP017.
**      INSERT VALUE #( aufnr = ls_prdord-aufnr
*      ls_ZABSF_PP017 = VALUE #( aufnr = ls_prdord-aufnr
*                                matnr = ls_prdord-matnr
*                                vornr = ls_prdord-vornr
*                                gamng = ls_prdord-gamng
*                                lmnga = ls_prdord-lmnga "ld_lmnga
*                                missingqty = ls_prdord-missingqty "<orders_tmp>-gamng - ( ld_lmnga + ld_xmnga + ld_rmnga )
*                                gmein = ls_prdord-gmein
*                                prdqty_box = ls_prdord-prdqty_box
*                                boxqty = ls_prdord-boxqty )." INTO ZABSF_PP017.
**      INSERT ls_zabsf_pp017 INTO ZABSF_PP017.
*      INSERT INTO ZABSF_PP017 VALUES ls_zabsf_pp017.
      REFRESH: lt_aufktext_tab.
      CLEAR: lv_pepelemt_var, lv_cuobj_var, lv_matrdesc_var.
    ENDLOOP.

*  Order by ascending
    SORT prdord_tab BY aufnr ASCENDING.

    LOOP AT prdord_tab ASSIGNING FIELD-SYMBOL(<fs_order>) WHERE status_oper EQ 'CONC'.
      CLEAR: l_objnr.

*    Get object of operation
      SELECT SINGLE objnr
        FROM afvc
        INTO l_objnr
       WHERE aufpl EQ <fs_order>-aufpl
         AND aplzl EQ <fs_order>-aplzl.

      IF l_objnr IS NOT INITIAL.
*      Check if operation is not confirmed
        SELECT SINGLE stat
          FROM jest
          INTO (@DATA(l_stat))
         WHERE objnr EQ @l_objnr
           AND stat  EQ 'I0009' "CONF
           AND inact EQ 'X'.

        IF l_stat IS NOT INITIAL.
*        Change status of operation
          <fs_order>-status_oper = 'INI'.


*        Update in database
          UPDATE zabsf_pp021 SET status_oper = <fs_order>-status_oper
                            WHERE arbpl EQ <fs_order>-arbpl
                              AND aufnr EQ <fs_order>-aufnr
                              AND vornr EQ <fs_order>-vornr.
        ENDIF.
      ENDIF.

      REFRESH: lt_marm.
    ENDLOOP.

*  Delete operation with status Completed
    DELETE prdord_tab WHERE status_oper EQ 'CONC'.

*  Get operator of Workcenter
    CALL METHOD lref_sf_operator->get_operator_wrkctr
      EXPORTING
        arbpl           = arbpl
      CHANGING
        oper_wrkctr_tab = oper_wrkctr_tab
        return_tab      = return_tab.

  ELSE.
*  No orders found for inputs
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'I'
        msgno      = '011'
      CHANGING
        return_tab = return_tab.
  ENDIF.

  "ordenar ordens por posição
  SORT prdord_tab BY sequence ASCENDING.
  "remover entradas com prioridade inícial
  DATA(lt_no_prio_tab) = VALUE zabsf_pp_t_prdord_detail( FOR ls_order_str IN prdord_tab
                                                         WHERE ( sequence IS INITIAL )
                                                               ( ls_order_str ) ).
  DELETE prdord_tab
    WHERE sequence IS INITIAL.
  "adicionar ordens no final da listagem
  APPEND LINES OF lt_no_prio_tab TO prdord_tab.
ENDMETHOD.


METHOD get_prod_orders_unassign.
*  Internal tables
  DATA: lt_prdord_unassign_tmp TYPE TABLE OF ty_prdord_unassign.

*  Structures
  DATA: ls_prdord_unassign TYPE zabsf_pp_s_prodord_unassign.

* Class
  DATA: lref_sf_parameters TYPE REF TO zabsf_pp_cl_parameters,
        lt_aufktext_tab    TYPE TABLE OF tline.

*  Variables
  DATA: l_matnr           TYPE mcekpo-matnr,
        l_date_past       TYPE begda,
        l_date_future     TYPE begda,
        l_days            TYPE t5a4a-dlydy,
        l_months          TYPE t5a4a-dlymo,
        l_years           TYPE t5a4a-dlyyr,
        l_langu           TYPE sy-langu,
        lv_get_only_marco TYPE flag,
        lv_pepelemt_var   TYPE ps_psp_ele.

*  Ranges
  DATA: r_auart    TYPE RANGE OF auart,
        ls_r_auart LIKE LINE OF r_auart.

*  Constants
  CONSTANTS: c_parid      TYPE zabsf_pp_e_parid VALUE 'DATA_GET',
             c_parid_at01 TYPE zabsf_pp_e_parid VALUE 'DATA_GET_AT01',
             c_meins      TYPE meins          VALUE 'MIN',
             c_time_24    TYPE sy-uzeit       VALUE '240000'.

  REFRESH: lt_prdord_unassign_tmp.

  CLEAR: l_matnr,
         l_date_past,
         l_date_future,
         l_days,
         l_months,
         l_years.

  DATA: r_ruek    TYPE RANGE OF ruek,
        ls_r_ruek LIKE LINE OF r_ruek.
*  Set local language for user
  l_langu = sy-langu.

  SET LOCALE LANGUAGE l_langu.

*Setup
*>> SETUP CONF
  CREATE OBJECT lref_sf_parameters
    EXPORTING
      initial_refdt = refdt
      input_object  = inputobj.

  "obter valores da configuração
  TRY.
      CALL METHOD zcl_bc_fixed_values=>get_single_value
        EXPORTING
          im_paramter_var = zcl_bc_fixed_values=>gc_charplan_cst
          im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
          im_werksval_var = inputobj-werks
        IMPORTING
          ex_prmvalue_var = DATA(lv_charplan_var).
    CATCH zcx_pp_exceptions INTO DATA(lo_bcexceptions_obj).
  ENDTRY.

  CALL METHOD lref_sf_parameters->get_output_settings
    EXPORTING
      parid           = lref_sf_parameters->c_marco_only
    IMPORTING
      parameter_value = lv_get_only_marco
    CHANGING
      return_tab      = return_tab.

  IF lv_get_only_marco EQ abap_true.

* Marco operations Range
    ls_r_ruek-option = 'EQ'.
    ls_r_ruek-low = '1'.
    ls_r_ruek-sign = 'I'.
    APPEND ls_r_ruek TO r_ruek.
  ENDIF.

*  Get objid of workcenter
  SELECT SINGLE objid
    FROM crhd
    INTO (@DATA(l_objid))
   WHERE arbpl EQ @arbpl
     AND werks EQ @inputobj-werks.

*  Get all order type
  SELECT *
    FROM zabsf_pp019
    INTO TABLE @DATA(lt_zabsf_pp019)
   WHERE areaid EQ @inputobj-areaid.

  IF sy-subrc EQ 0.
    REFRESH r_auart.

    LOOP AT lt_zabsf_pp019 INTO DATA(ls_zabsf_pp019).
      CLEAR: ls_r_auart.
      ls_r_auart-sign = 'I'.
      ls_r_auart-option = 'EQ'.
      ls_r_auart-low = ls_zabsf_pp019-auart.

      APPEND ls_r_auart TO r_auart.
    ENDLOOP.
  ENDIF.

*  Get type area
  SELECT SINGLE tarea_id
    FROM zabsf_pp008
    INTO (@DATA(l_tarea_id))
   WHERE areaid EQ @inputobj-areaid
     AND werks  EQ @inputobj-werks
     AND endda  GE @refdt
     AND begda  LE @refdt.

*  Get number of year to get orders
  IF l_tarea_id EQ 'AT01'.
    SELECT SINGLE parva
      FROM zabsf_pp032
      INTO (@DATA(l_date_get))
     WHERE parid EQ @c_parid_at01.
  ELSE.
    SELECT SINGLE parva
      FROM zabsf_pp032
      INTO (@l_date_get)
     WHERE parid EQ @c_parid.
  ENDIF.

*  ld_years = ld_date_get.
  l_months = l_date_get.

*  Date in past
  CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
    EXPORTING
      date      = sy-datum
      days      = l_days
      months    = l_months
      signum    = '-'
      years     = l_years
    IMPORTING
      calc_date = l_date_past.

*  Date in future
  CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
    EXPORTING
      date      = sy-datum
      days      = l_days
      months    = l_months
      signum    = '+'
      years     = l_years
    IMPORTING
      calc_date = l_date_future.

*  Get all orders in workcenter
  SELECT aufk~aufnr afko~gstrs afko~gsuzs afko~plnbez afko~stlbez afko~gamng
         afvc~vornr afvc~ltxa1 jest1~stat afvc~steus
    INTO CORRESPONDING FIELDS OF TABLE lt_prdord_unassign_tmp
    FROM afvc AS afvc
   INNER JOIN t430 AS t430
      ON t430~steus EQ afvc~steus
"      AND t430~ruek EQ '1'
   INNER JOIN afko AS afko
      ON afko~aufpl EQ afvc~aufpl
   INNER JOIN aufk AS aufk
      ON afko~aufnr EQ aufk~aufnr
   INNER JOIN jest AS jest
      ON jest~objnr EQ aufk~objnr
     AND jest~stat  EQ 'I0002'
     AND jest~inact EQ space
    LEFT OUTER JOIN jest AS jest1
*      ON jest1~objnr EQ aufk~objnr
      ON jest1~objnr EQ afvc~objnr
     AND jest1~stat  EQ 'I0009' " CONF
     AND jest1~inact EQ space
   WHERE afvc~arbid EQ l_objid
     AND ( afko~gstrp GE l_date_past AND
           afko~gstrp LE l_date_future )
     AND aufk~auart IN r_auart
         AND t430~ruek IN r_ruek.

* Start Change ABACO(AON) : 21.12.2022
* Description: Added filtering support to delete matching steus
  LOOP AT it_steus_filters ASSIGNING FIELD-SYMBOL(<fs_steus_filter>).
    DELETE lt_prdord_unassign_tmp WHERE steus = <fs_steus_filter>.
  ENDLOOP.
* End Change ABACO(AON) : 21.12.2022

  DELETE lt_prdord_unassign_tmp WHERE stat = 'I0009'.

  IF lt_prdord_unassign_tmp[] IS NOT INITIAL.
*    Get all orders with initial status
    SELECT *
      FROM zabsf_pp021
      INTO TABLE @DATA(lt_sf021)
     WHERE arbpl EQ @arbpl
       AND status_oper IN ('AGU', 'PREP', 'PROC', 'STOP').

    "elementos pep
    SELECT *
      FROM afpo
      INTO TABLE @DATA(lt_afpotabl_tab)
      FOR ALL ENTRIES IN @lt_prdord_unassign_tmp
     WHERE aufnr EQ @lt_prdord_unassign_tmp-aufnr
       AND projn NE @abap_false.

    LOOP AT lt_prdord_unassign_tmp INTO DATA(ls_prdord_unassign_tmp).
*      Check status
      READ TABLE lt_sf021 INTO DATA(ls_sf021) WITH KEY aufnr = ls_prdord_unassign_tmp-aufnr
                                                       vornr = ls_prdord_unassign_tmp-vornr.

      IF sy-subrc NE 0.
        CLEAR ls_prdord_unassign.

*        Move same fields
        MOVE-CORRESPONDING ls_prdord_unassign_tmp TO ls_prdord_unassign.

*        Material
        IF ls_prdord_unassign_tmp-plnbez IS NOT INITIAL.
          ls_prdord_unassign-matnr = ls_prdord_unassign_tmp-plnbez.
        ELSE.
          ls_prdord_unassign-matnr = ls_prdord_unassign_tmp-stlbez.
        ENDIF.

        CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
          EXPORTING
            input  = ls_prdord_unassign-matnr
          IMPORTING
            output = ls_prdord_unassign-matnr.

*    Material Description
        SELECT cuobj UP TO 1 ROWS
          FROM afpo
          INTO @DATA(lv_cuobj_var)
           WHERE aufnr EQ @ls_prdord_unassign-aufnr.
        ENDSELECT.
        "read data from classification
        zcl_mm_classification=>get_material_desc_by_object( EXPORTING
                                                              im_cuobj_var       = lv_cuobj_var
                                                            IMPORTING
                                                              ex_description_var = DATA(lv_matrdesc_var) ).
        IF lv_matrdesc_var IS NOT INITIAL.
          ls_prdord_unassign-maktx = lv_matrdesc_var.
        ELSE.
          "get description from database table
          SELECT SINGLE maktx
            FROM makt
            INTO @ls_prdord_unassign-maktx
           WHERE matnr EQ @ls_prdord_unassign-matnr
             AND spras EQ @sy-langu.
        ENDIF.
*        Sched_ time
        IF ls_prdord_unassign-gsuzs EQ c_time_24.
          ls_prdord_unassign-gsuzs = ls_prdord_unassign-gsuzs - 1.
        ENDIF.

        "obter configuração
        CALL METHOD zcl_mm_classification=>get_classification_config
          EXPORTING
            im_instance_cuobj_var = lv_cuobj_var
          IMPORTING
            ex_classfication_tab  = DATA(lt_classfic_tab)
          EXCEPTIONS
            instance_not_found    = 1
            OTHERS                = 2.
        IF sy-subrc <> 0.
        ENDIF.

        "elemento PEP
        lv_pepelemt_var  = COND #( WHEN line_exists( lt_afpotabl_tab[ aufnr = ls_prdord_unassign-aufnr ] )
                                   THEN lt_afpotabl_tab[ aufnr = ls_prdord_unassign-aufnr ]-projn ).
        IF lv_pepelemt_var IS NOT INITIAL.
          CALL FUNCTION 'CONVERSION_EXIT_ABPSP_OUTPUT'
            EXPORTING
              input  = lv_pepelemt_var
            IMPORTING
              output = ls_prdord_unassign-schematics.
        ENDIF.
        " plano de fabrico
        ls_prdord_unassign-production_plan = COND #( WHEN line_exists( lt_classfic_tab[ atnam = lv_charplan_var ] )
                                                     THEN lt_classfic_tab[ atnam = lv_charplan_var ]-atwrt ).

        " quantidade a produzir
        ls_prdord_unassign-quantitytomake = ls_prdord_unassign_tmp-gamng.

        "obter programa de corte
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            id                      = 'KOPF'
            language                = sy-langu
            name                    = CONV tdobname( |{ sy-mandt }{ ls_prdord_unassign-aufnr ALPHA = IN }| )
            object                  = 'AUFK'
          TABLES
            lines                   = lt_aufktext_tab
          EXCEPTIONS
            id                      = 1
            language                = 2
            name                    = 3
            not_found               = 4
            object                  = 5
            reference_check         = 6
            wrong_access_to_archive = 7
            OTHERS                  = 8.
        IF sy-subrc <> 0.
        ENDIF.
        IF line_exists( lt_aufktext_tab[ 1 ] ).
          "primeira linha do texto
          ls_prdord_unassign-program = lt_aufktext_tab[ 1 ]-tdline.
        ENDIF.
        APPEND ls_prdord_unassign TO prdord_unassign.
      ENDIF.
      CLEAR: ls_prdord_unassign, lv_pepelemt_var.
    ENDLOOP.
  ENDIF.
ENDMETHOD.


METHOD get_qty_box.
*  Variables
    DATA: l_source_unit TYPE mara-meins.

*  Constants
    CONSTANTS: c_mtart_fert TYPE mtart VALUE 'FERT',
               c_mtart_halb TYPE mtart VALUE 'HALB',
               c_mtart_hawa TYPE mtart VALUE 'HAWA'.

*  Get basic unit of material
    SELECT SINGLE meins, mtart
      FROM mara
      INTO (@DATA(l_meins),@DATA(l_mtart))
     WHERE matnr EQ @matnr.

    IF l_mtart EQ c_mtart_fert OR l_mtart EQ c_mtart_halb.
      IF l_meins IS INITIAL.
        l_meins = gmein.
      ENDIF.

*    Unit
      l_source_unit = l_meins.

*    Convert Unit
      CALL METHOD me->convert_unit
        EXPORTING
          matnr        = matnr
          source_value = source_value
          source_unit  = l_source_unit
          lmnga        = lmnga
        CHANGING
          prdqty_box   = prdqty_box
          boxqty       = boxqty
          unit_alt     = unit_alt.

      IF boxqty IS INITIAL.
*      Get box quantiy for product semi finished
        SELECT SINGLE usr04, use04
          FROM afvu
          INTO (@DATA(l_usr04), @DATA(l_use04))
         WHERE aufpl EQ @aufpl
           AND aplzl EQ @aplzl.

        boxqty = l_usr04.
      ENDIF.
    ELSE.
*    Get box quantiy for product semi finished
      SELECT SINGLE usr04, use04
        FROM afvu
        INTO (@l_usr04, @l_use04)
       WHERE aufpl EQ @aufpl
         AND aplzl EQ @aplzl.

      boxqty = l_usr04.
    ENDIF.

    IF boxqty IS INITIAL AND ( l_mtart EQ c_mtart_halb OR l_mtart EQ c_mtart_hawa ).
      boxqty = 1.
    ENDIF.
  ENDMETHOD.


METHOD GET_QTY_VORNR.

  DATA: lt_afvc TYPE TABLE OF afvc,
        lt_afvv TYPE TABLE OF afvv,
        lt_t430 TYPE TABLE OF t430.

  DATA: wa_afvc    TYPE afvc,
        wa_afvv    TYPE afvv,
        wa_t430    TYPE t430,
        ls_jest    TYPE jest,
        ld_lmnga   TYPE lmnga,
        ld_xmnga   TYPE xmnga,
        flag       TYPE c,
        flag_first TYPE c. "First operation


  REFRESH: lt_afvc,
           lt_afvv,
           lt_t430.

  CLEAR: wa_afvc,
         wa_afvv,
         wa_t430,
         ls_jest,
         ld_lmnga,
         ld_xmnga,
         flag,
         flag_first.

  IF aufpl IS NOT INITIAL AND vornr IS NOT INITIAL.
*  Get previous operations
    SELECT *
      FROM afvc
      INTO CORRESPONDING FIELDS OF TABLE lt_afvc
      WHERE aufpl EQ aufpl
        AND vornr LT vornr.

    IF sy-subrc NE 0.
*    Not found previous operation because is first operation
*    DO another selection
      SELECT *
        FROM afvc
        INTO CORRESPONDING FIELDS OF TABLE lt_afvc
       WHERE aufpl EQ aufpl
         AND vornr EQ vornr.

      IF sy-subrc EQ 0.
        flag_first = 'X'.
      ENDIF.
    ENDIF.

    IF lt_afvc[] IS NOT INITIAL.
*    Get quantity of previous operations
      SELECT *
        FROM afvv
        INTO CORRESPONDING FIELDS OF TABLE lt_afvv
         FOR ALL ENTRIES IN lt_afvc
       WHERE aufpl EQ lt_afvc-aufpl
         AND aplzl EQ lt_afvc-aplzl.

*    Get Control key of previous operations
      SELECT *
        FROM t430
        INTO CORRESPONDING FIELDS OF TABLE lt_t430
     FOR ALL ENTRIES IN lt_afvc
       WHERE steus EQ lt_afvc-steus and steus ne 'PP01'.
"BMR COmment 23.04.2020         "AND ruek  EQ '1'.

*    Order by last operation
      SORT lt_afvc BY aufpl vornr DESCENDING.

      LOOP AT lt_afvc INTO wa_afvc.
        READ TABLE lt_t430 INTO wa_t430 WITH KEY steus = wa_afvc-steus.

        IF sy-subrc EQ 0.
*        Check if operation was confirmed
          SELECT SINGLE *
            FROM jest
            INTO CORRESPONDING FIELDS OF ls_jest
           WHERE objnr EQ wa_afvc-objnr.
*             AND ( stat EQ 'I0010' OR "CONF PARC
*                   stat EQ 'I0009' ).  "CONF

          IF sy-subrc EQ 0.
            READ TABLE lt_afvv INTO wa_afvv WITH KEY aufpl = wa_afvc-aufpl
                                                     aplzl = wa_afvc-aplzl.
            ld_lmnga = wa_afvv-lmnga.
            ld_xmnga = wa_afvv-xmnga.

            flag = 'X'.
            EXIT.
          ENDIF.
        ENDIF.
      ENDLOOP.

*    Check if exist more than one operation
      IF flag IS NOT INITIAL.
        qty_proc = ld_lmnga - lmnga.

        IF qty_proc LT 0.
          qty_proc = 0.
        ENDIF.

        IF flag_first IS NOT INITIAL.
          qty_proc = 9999999999.
        ENDIF.
      ENDIF.
    ENDIF.

*  Get total operation
    SELECT COUNT(*)
      FROM afvc
      INTO vornr_tot
     WHERE aufpl EQ aufpl
       AND vornr GT vornr.
"BMR comment 20.07.2020 - incluir ultima operação na contagem
*  Not include last operation
*    IF vornr_tot IS NOT INITIAL.
*      SUBTRACT 1 FROM vornr_tot.
*    ENDIF.
  ENDIF.
ENDMETHOD.


METHOD get_qualifications.

    CONSTANTS: c_gen_autonomous(1)  VALUE 1,     "Autonomous
               c_gen_no_qualific(1) VALUE 2,     "No qualification
               c_mat_self_apprv(1)  VALUE 1,     "Self Approval
               c_mat_no_qualifc(1)  VALUE 2.     "No qualification


    DATA: lv_matnr        TYPE matnr,
          lv_pernr        TYPE pernr_d,
          lv_other_pernr  TYPE pernr_d,
          lv_matnr_output TYPE matnr,
          lv_length       TYPE i,
          lv_offset       TYPE i,
*          lt_sf067        TYPE TABLE OF ZABSF_PP067,
*          ls_sf067        LIKE LINE OF lt_sf067,
          lv_alt_spras    TYPE spras.



    DATA: lt_profile     TYPE TABLE OF hrpe_profq,
          ls_profile     LIKE LINE OF lt_profile,
          ls_profile_mat LIKE LINE OF lt_profile,
          ls_profile_aux LIKE LINE OF lt_profile,
          lt_objects     TYPE TABLE OF hrsobid,
          ls_objects     LIKE LINE OF lt_objects,
          ls_oprid_tab   TYPE zabsf_pp_s_operador,
          ls_first_user  TYPE zabsf_pp_s_operador.

    FIELD-SYMBOLS: <fs_prodord_tab> LIKE LINE OF prord_tab.

* get default language
    SELECT SINGLE spras FROM zabsf_pp061 INTO lv_alt_spras
        WHERE werks = inputobj-werks
        AND is_default EQ abap_true.

    SELECT SINGLE veran  FROM crhd
      WHERE objty = 'A'
      AND werks = @inputobj-werks
      AND  arbpl = @arbpl
    INTO (@DATA(lv_veran)).

    IF sy-subrc NE 0.
      "send message error - no responsability found
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'E'
          msgno      = '082'
          msgv1      = arbpl
        CHANGING
          return_tab = return_tab.

      EXIT.
    ENDIF.

    SELECT * FROM zabsf_pp067 INTO TABLE @DATA(lt_sf067)
      WHERE werks = @inputobj-werks
      AND veran = @lv_veran.

    IF lt_sf067[] IS INITIAL.
      " send message error - no parametrization

      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'E'
          msgno      = '083'
          msgv1      = arbpl
        CHANGING
          return_tab = return_tab.
      EXIT.
    ENDIF.

    READ TABLE lt_sf067 INTO DATA(ls_sf067) INDEX 1.


    LOOP AT prord_tab ASSIGNING <fs_prodord_tab>.

* convert MATNR for READ TABLE
      CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
        EXPORTING
          input  = <fs_prodord_tab>-matnr
        IMPORTING
          output = lv_matnr_output.

      lv_matnr_output = lv_matnr_output+0(7). "get subset of mantr.

* get users of production order.
      LOOP AT <fs_prodord_tab>-oprid_tab INTO ls_oprid_tab
        WHERE status = 'A'.

        ls_objects-otype = 'P'.
        ls_objects-plvar = '01'.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = ls_oprid_tab-oprid
          IMPORTING
            output = lv_pernr.

        ls_objects-sobid = lv_pernr.

        APPEND ls_objects TO lt_objects.

        CLEAR: ls_oprid_tab, ls_objects, lv_pernr.
      ENDLOOP.

**check if logged user is assgnied to production order.
*        LOOP AT <fs_prodord_tab>-oprid_tab TRANSPORTING NO FIELDS
*          WHERE oprid = inputobj-oprid.
*
*          EXIT.
*        ENDLOOP.
*
*        IF sy-subrc NE 0.
** add user to get catalogs
*          ls_objects-otype = 'P'.
*          ls_objects-plvar = '01'.
*          ls_objects-sobid = inputobj-pernr.
*
*          APPEND ls_objects TO lt_objects.
*        ENDIF.


* get catalog for users on Production order.
      CALL FUNCTION 'RHPP_Q_PROFILE_READ'
        EXPORTING
          begda            = sy-datum
          endda            = sy-datum
          with_stext       = 'X'
          with_qk_info     = 'X'
        TABLES
          objects          = lt_objects
          profile          = lt_profile
        EXCEPTIONS
          no_authority     = 1
          wrong_otype      = 2
          object_not_found = 3
          undefined        = 4
          OTHERS           = 5.
      IF sy-subrc <> 0.
      ENDIF.

      IF lt_profile IS NOT INITIAL.

* for first registerd user on production order.
        READ TABLE <fs_prodord_tab>-oprid_tab INTO ls_first_user INDEX 1.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = ls_first_user-oprid
          IMPORTING
            output = lv_pernr.

* general catalog
        READ TABLE lt_profile INTO ls_profile WITH KEY sobid = lv_pernr
                                                       scale_id = ls_sf067-general_cat.

* check parts catalog
        IF ls_profile-profcy EQ c_gen_autonomous. "check if first user is Autonomous.

          READ TABLE lt_profile INTO ls_profile_mat WITH KEY sobid = lv_pernr
                                                             ttext = lv_matnr_output
                                                             scale_id = ls_sf067-material_cat.

          IF ls_profile_mat-profcy EQ c_mat_self_apprv. "check if logged user is self approval for matnr.
* check other users
            LOOP AT <fs_prodord_tab>-oprid_tab INTO ls_oprid_tab
              WHERE oprid NE ls_first_user-oprid. "inputobj-oprid.

              CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                EXPORTING
                  input  = ls_oprid_tab-oprid
                IMPORTING
                  output = lv_other_pernr. "others users.

              <fs_prodord_tab>-qtext = ls_profile_mat-profc_text. "self aproval
              <fs_prodord_tab>-quali = ls_profile_mat-class_id. "self aproval.

              READ TABLE lt_profile INTO ls_profile_aux WITH KEY sobid = lv_other_pernr
                                                                 ttext = lv_matnr_output.

              IF ls_profile_aux-profcy NE c_mat_self_apprv OR sy-subrc NE 0.
                <fs_prodord_tab>-qtext = ls_profile-profc_text. "autonomous
                <fs_prodord_tab>-quali = ls_profile-class_id. "autonomous
                EXIT.
              ENDIF.

              CLEAR: ls_oprid_tab, ls_profile_aux, lv_other_pernr.
            ENDLOOP.

            IF sy-subrc NE 0. "only main user is assgined to order ans he is self aproval
              <fs_prodord_tab>-qtext =  ls_profile_mat-profc_text.
              <fs_prodord_tab>-quali = ls_profile_mat-class_id.
            ENDIF.

          ELSE.
            "main user is Autonomous but not self approvel for matnr or no data found.
            <fs_prodord_tab>-qtext = ls_profile-profc_text.
            <fs_prodord_tab>-quali = ls_profile-class_id.
            CLEAR ls_profile_mat.
          ENDIF.

        ELSE.
          "no qualification or no data found
          <fs_prodord_tab>-qtext = ls_profile-profc_text.
          <fs_prodord_tab>-quali = ls_profile-class_id.
        ENDIF.
      ELSE.
        "send error message - no catalogs found.
      ENDIF.

* default values:
      SELECT SINGLE * INTO @DATA(ls_t77tp) FROM t77tp
        WHERE scale_id = @ls_sf067-general_cat
        AND rating =  @c_gen_no_qualific
        AND langu = @sy-langu.

      IF sy-subrc NE 0.
* get description for default language.
        SELECT SINGLE * INTO @ls_t77tp FROM t77tp
          WHERE scale_id = @ls_sf067-general_cat
          AND rating =  @c_gen_no_qualific
          AND langu = @lv_alt_spras.

      ENDIF.

      IF <fs_prodord_tab>-qtext IS INITIAL.
        <fs_prodord_tab>-qtext = ls_t77tp-pstext.
      ENDIF.

      <fs_prodord_tab>-quali = ''.
      REFRESH lt_objects.

      CLEAR: ls_profile, ls_profile_mat, ls_profile_aux, lv_pernr, ls_first_user.
    ENDLOOP.
  ENDMETHOD.


METHOD GET_QUALI_PERNR_ACTIVE_PRDORD.
*  Internal tables
    DATA: lt_objects TYPE TABLE OF hrsobid,
          lt_profile TYPE TABLE OF hrpe_profq.

*  Structures
    DATA: ls_objects TYPE hrsobid.

*  Constants
    CONSTANTS: c_objty              TYPE cr_objty VALUE 'A',  "Work center
               c_plvar_01           TYPE plvar    VALUE '01', "Current plan
               c_otype_p            TYPE otype    VALUE 'P',  "Person
               c_gen_autonomous(1)  TYPE c        VALUE '1',     "Autonomous
               c_gen_no_qualific(1) TYPE c        VALUE '2',     "No qualification
               c_mat_self_apprv(1)  TYPE c        VALUE '1'.     "Self Approval

* Get default language
    SELECT SINGLE spras
      FROM ZABSF_PP061
      INTO (@DATA(l_langu_alt))
     WHERE werks      EQ @inputobj-werks
       AND is_default EQ @abap_true.

*  Get Person responsible for the work center
    SELECT SINGLE veran
      FROM crhd
      INTO (@DATA(l_veran))
     WHERE objty EQ @c_objty
       AND werks EQ @inputobj-werks
       AND arbpl EQ @arbpl.

    IF sy-subrc EQ 0.
*    Get qualification for person responsible active
      SELECT SINGLE *
        FROM ZABSF_PP067
        INTO @DATA(ls_pp_sf067)
       WHERE werks = @inputobj-werks
         AND veran = @l_veran.

      IF sy-subrc EQ 0.
        CLEAR ls_objects.

*      Object type
        ls_objects-otype = c_otype_p.
*      Plan variante
        ls_objects-plvar = c_plvar_01.
*      Operator number
        ls_objects-sobid = pernr.

        APPEND ls_objects TO lt_objects.

        IF lt_objects[] IS NOT INITIAL.
*        Get catalog for users
          CALL FUNCTION 'RHPP_Q_PROFILE_READ'
            TABLES
              objects          = lt_objects
              profile          = lt_profile
            EXCEPTIONS
              no_authority     = 1
              wrong_otype      = 2
              object_not_found = 3
              undefined        = 4
              OTHERS           = 5.

          IF lt_profile[] IS NOT INITIAL.
*          General catalog
            READ TABLE lt_profile INTO DATA(ls_profile) WITH KEY sobid    = pernr
                                                                 scale_id = ls_pp_sf067-general_cat.

            IF ls_profile-profcy EQ c_gen_autonomous.
*            Get material from Production Order
              SELECT SINGLE plnbez, stlbez
                FROM afko
                INTO (@DATA(l_plnbez), @DATA(l_stlbez))
               WHERE aufnr EQ @aufnr.

*            Material
              IF l_plnbez IS NOT INITIAL.
                DATA(l_matnr) = l_plnbez.
              ELSE.
                l_matnr = l_stlbez.
              ENDIF.

*            Get subset of mantr.
              l_matnr = l_matnr+0(7).

*            General material catalog
              READ TABLE lt_profile INTO DATA(ls_profile_mat) WITH KEY sobid    = pernr
                                                                       ttext    = l_matnr
                                                                       scale_id = ls_pp_sf067-material_cat.

              IF ls_profile_mat-profcy EQ c_mat_self_apprv.
*              Only main user is assgined to order ans he is self aproval
                quali = ls_profile_mat-class_id.
                qtext = ls_profile_mat-profc_text.
                scale_id = ls_profile_mat-scale_id.
                profcy = ls_profile_mat-profcy.
                profc_text = ls_profile_mat-profc_text.
              ELSE.
*              Main user is Autonomous but not self approvel for matnr or no data found.
                quali = ls_profile-class_id.
                qtext = ls_profile-profc_text.
                scale_id = ls_profile-scale_id.
                profcy = ls_profile-profcy.
                profc_text = ls_profile-profc_text.
              ENDIF.
            ELSE.
*            No qualification or no data found
              quali = ls_profile-class_id.
              qtext = ls_profile-profc_text.
              scale_id = ls_profile-scale_id.
              profcy = ls_profile-profcy.
              profc_text = ls_profile-profc_text.

              IF qtext IS INITIAL.
*              Get no qualification description
                SELECT SINGLE pstext
                  FROM t77tp
                  INTO (@DATA(l_pstext))
                 WHERE scale_id EQ @ls_pp_sf067-general_cat
                   AND rating   EQ @c_gen_no_qualific
                   AND langu    EQ @sy-langu.

                IF sy-subrc NE 0.
*                Get no qualification description - alternative language
                  SELECT SINGLE pstext
                    FROM t77tp
                    INTO @l_pstext
                   WHERE scale_id EQ @ls_pp_sf067-general_cat
                     AND rating   EQ @c_gen_no_qualific
                     AND langu    EQ @l_langu_alt.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


METHOD get_theorical_data.
*  Internal
    DATA: lt_return_tab TYPE bapiret2_t.

*  Reference
    DATA: lref_sf_calc_min  TYPE REF TO zabsf_pp_cl_event_act.

*  Variables
    DATA: l_activity  TYPE ru_ismng,
          l_time_in   TYPE qmih-auszt,
          l_time_out  TYPE qmih-auszt,
          l_proc_time TYPE pr_time.

    CLEAR: vgw02,
           theoretical_time,
           bmsch,
           theoretical_qty.

*  Constants
    CONSTANTS: c_meins TYPE meins    VALUE 'MIN',
               c_objty TYPE cr_objty VALUE 'A'.

*  Get theoritical times and quantity
    SELECT SINGLE vgw02, vge02, bmsch
      FROM afvv
      INTO (@DATA(l_vgw02),@DATA(l_vge02),@DATA(l_bmsch))
     WHERE aufpl EQ @aufpl
       AND aplzl EQ @aplzl.

*  Current theoretical cycle counter
    IF l_vgw02 IS NOT INITIAL.
      IF l_vge02 NE c_meins.
        CLEAR: l_time_in,
               l_time_out.

*      Time to convert in Minutes
        l_time_in = l_vgw02.

        CALL FUNCTION 'PM_TIME_CONVERSION'
          EXPORTING
            time_in           = l_time_in
            unit_in_int       = l_vge02
            unit_out_int      = 'MIN'
          IMPORTING
            time_out          = l_time_out
          EXCEPTIONS
            invalid_time_unit = 1
            OTHERS            = 2.

        vgw02 = l_time_out.
      ELSE.
        vgw02 = l_vgw02.
      ENDIF.
    ENDIF.

*  Check Task List Type and Key for Task List Group
    IF plnty IS INITIAL AND plnnr IS INITIAL.
*     Get Task List Type and Key for Task List Group
      SELECT SINGLE plnnr, plnty
        FROM afko
        INTO (@DATA(l_plnnr), @DATA(l_plnty))
       WHERE aufnr EQ @aufnr.
    ELSE.
      l_plnty = plnty.
      l_plnnr = plnnr.
    ENDIF.

*  Check if exist Efficiency rate filled in Task List
    SELECT SINGLE crhd~zgr02
      FROM afvc AS afvc
     INNER JOIN crhd AS crhd
        ON crhd~objty EQ @c_objty
       AND crhd~objid EQ afvc~arbid
     WHERE aufpl EQ @aufpl
       AND aplzl EQ @aplzl
      INTO (@DATA(l_zgr02)).

*    SELECT SINGLE zgr02
*      FROM plpo
*      INTO (@DATA(l_zgr02))
*     WHERE plnty EQ @l_plnty
*       AND plnnr EQ @l_plnnr.

    IF sy-subrc EQ 0.
*    Key for performance efficiency rate
      SELECT SINGLE zgter
        FROM tc31a
        INTO (@DATA(l_zgter))
       WHERE zgrad EQ @l_zgr02
         AND datub GE @sy-datum.

      IF sy-subrc EQ 0.
*      Efficiency rate
        vgw02 = vgw02 / ( l_zgter / 100 ).
      ENDIF.
    ENDIF.

*  Total theoretical quantity
    IF l_bmsch IS NOT INITIAL.
      bmsch = l_bmsch .
    ENDIF.

*  Calculate Theoretical Times and Quantities
*  Check lenght of time
    DATA(l_lengh) = strlen( inputobj-timeconf ).

    IF l_lengh LT 6.
      CONCATENATE '0' inputobj-timeconf INTO DATA(l_time).
    ELSE.
      l_time = inputobj-timeconf.
    ENDIF.

*  Theoretical Time
    IF vgw02 IS NOT INITIAL.
*    Get card active
      SELECT SINGLE ficha
        FROM zabsf_pp066
        INTO (@DATA(l_ficha))
       WHERE aufnr EQ @aufnr
         AND vornr EQ @vornr.

      IF l_ficha IS NOT INITIAL OR l_ficha NE 0.
*      Get first confirmation of card
        SELECT conf_no, conf_cnt UP TO 1 ROWS
          FROM zabsf_pp065
          INTO (@DATA(l_conf_no),@DATA(l_conf_cnt))
         WHERE ficha EQ @l_ficha
         ORDER BY conf_cnt ASCENDING.
        ENDSELECT.

        IF l_conf_no IS NOT INITIAL AND l_conf_cnt IS NOT INITIAL.
*        Get start time of Preparation or Production
          SELECT SINGLE isdd, isdz, isbd, isbz
            FROM afru
            INTO (@DATA(l_isdd),@DATA(l_isdz),@DATA(l_isbd),@DATA(l_isbz))
           WHERE rueck EQ @l_conf_no
             AND rmzhl EQ @l_conf_cnt.

          IF l_isdz IS NOT INITIAL AND l_isbz IS INITIAL.
            CLEAR l_proc_time.

*          Time
            l_proc_time = l_time.

*          Create object of class - Calculate time in minutes
            IF lref_sf_calc_min IS NOT BOUND.
              CREATE OBJECT lref_sf_calc_min
                EXPORTING
                  initial_refdt = sy-datum
                  input_object  = inputobj.
            ENDIF.

*          Calculte times in minutes
            CALL METHOD lref_sf_calc_min->calc_minutes
              EXPORTING
                date       = l_isdd
                time       = l_isdz
                proc_date  = inputobj-dateconf
                proc_time  = l_proc_time
              CHANGING
                activity   = l_activity
                return_tab = lt_return_tab.

            theoretical_time = trunc( l_activity / vgw02 ).
          ELSE.
            CLEAR l_proc_time.

*          Time
            l_proc_time = l_time.

*          Create object of class - Calculate time in minutes
            IF lref_sf_calc_min IS NOT BOUND.
              CREATE OBJECT lref_sf_calc_min
                EXPORTING
                  initial_refdt = sy-datum
                  input_object  = inputobj.
            ENDIF.

*          Calculte times in minutes
            CALL METHOD lref_sf_calc_min->calc_minutes
              EXPORTING
                date       = l_isbd
                time       = l_isbz
                proc_date  = inputobj-dateconf
                proc_time  = l_proc_time
              CHANGING
                activity   = l_activity
                return_tab = lt_return_tab.

            theoretical_time = trunc( l_activity / vgw02 ).
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

*  Theoretical Quantity
    IF theoretical_time IS NOT INITIAL.
      theoretical_qty = trunc( theoretical_time ) * bmsch.
    ENDIF.
  ENDMETHOD.


METHOD get_total_quantity_counter.
    IF ficha IS NOT INITIAL OR ficha NE 0.
*    Get last record saved if final counter
      SELECT * UP TO 1 ROWS
        FROM zabsf_pp065
        INTO @DATA(ls_pp_sf065)
       WHERE conf_no EQ @rueck
         AND ficha   EQ @ficha
*       AND oprid     EQ @inputobj-oprid
*       AND ( count_fin EQ 0 OR count_fin NE @space )
       ORDER BY conf_cnt.
      ENDSELECT.

      IF sy-subrc EQ 0.
*      Get all confirmations from last final counter
        SELECT DISTINCT conf_no, conf_cnt
          FROM zabsf_pp065
          INTO TABLE @DATA(lt_pp_sf065)
         WHERE conf_no  EQ @rueck
           AND conf_cnt GE @ls_pp_sf065-conf_cnt.
*         AND oprid    EQ @inputobj-oprid.
      ELSE.
        REFRESH lt_pp_sf065.

*      SORT lt_pp_sf065 BY conf_no ASCENDING conf_cnt ASCENDING.
*
*      DELETE ADJACENT DUPLICATES FROM lt_pp_sf065.

*      Get all confirmations from last final counter
        SELECT conf_no, conf_cnt
          FROM zabsf_pp065
          INTO TABLE @lt_pp_sf065
         WHERE conf_no EQ @rueck
           AND oprid   EQ @inputobj-oprid.
      ENDIF.

      IF lt_pp_sf065[] IS NOT INITIAL.
*      Get scrap quantity and scrap
        SELECT rmzhl, lmnga, xmnga
          FROM afru
          INTO TABLE @DATA(lt_afru)
           FOR ALL ENTRIES IN @lt_pp_sf065
         WHERE rueck EQ @lt_pp_sf065-conf_no
           AND rmzhl EQ @lt_pp_sf065-conf_cnt
           AND stokz EQ @space
           AND stzhl EQ @space.

        IF lt_afru[] IS NOT INITIAL.
          LOOP AT lt_afru INTO DATA(ls_afru).
            DATA(l_total) = ls_afru-lmnga + ls_afru-xmnga.

            ADD l_total TO total_qty.
          ENDLOOP.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


METHOD palete_data.
    DATA: lv_por_completar TYPE lqua-verme,
          lv_verme_palete  TYPE lqua-verme.
    DATA: ls_palete_data TYPE zabsf_palete_data.

    BREAK ab_nss.

    SELECT SINGLE parva FROM zabsf_pp032 INTO @DATA(lv_lgpla)
      WHERE werks = @inputobj-werks
        AND parid = 'PALLET_LGPLA'.

    SELECT SINGLE parva FROM zabsf_pp032 INTO @DATA(lv_lgtyp)
      WHERE werks = @inputobj-werks
        AND parid = 'SUPPLYMENT_LGTYP'.

    SELECT * FROM lqua INTO TABLE @DATA(lt_lqua)
      WHERE matnr = @matnr
        AND charg = @batch
        AND lgtyp = @lv_lgtyp
        AND lgpla = @lv_lgpla.
    LOOP AT lt_lqua INTO DATA(ls_lqua).

      SELECT SINGLE * FROM marm INTO @DATA(ls_marm)
        WHERE matnr = @matnr
          AND meinh = 'PAL'.

      lv_verme_palete = ls_lqua-verme * ls_marm-umren / ls_marm-umrez.
      IF lv_verme_palete < 1. " PODE HAVER PALETIZAÇÃO
*VALOR EM UN BASICA POR COMPLETAR NA PALETE
        ls_palete_data-menge = ls_marm-umrez / ls_marm-umren - ls_lqua-verme.
        ls_palete_data-meins = ls_lqua-meins.
        ls_palete_data-lenum = ls_lqua-lenum.
        APPEND ls_palete_data TO palete_data.
        CLEAR ls_palete_data.
      ENDIF.
    ENDLOOP.
    IF sy-subrc EQ 0.
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'S'
          msgno      = '013'
        CHANGING
          return_tab = return_tab.
    ELSE.
*      CALL METHOD zabsf_pp_cl_log=>add_message
*        EXPORTING
*          msgty      = 'E'
*          msgno      = '012'
*        CHANGING
*          return_tab = return_tab.
    ENDIF.
  ENDMETHOD.


method save_data_confirmation.
*  Internal tables
    data: lt_pp_sf065 type table of zabsf_pp065.

*  Variables
    data: l_nr_operator type i,
          l_time_in     type qmih-auszt,
          l_time_out    type qmih-auszt,
          l_pernr       type pernr_d,
          l_bmsch       type bmsch.

*  Constants
    constants c_meins type meins value 'MIN'.

*  Number of employees in Production Order
    select *
      from zabsf_pp014
      into table @data(lt_pp_sf014)
     where arbpl  eq @is_conf_data-arbpl
       and aufnr  eq @is_conf_data-aufnr
       and vornr  eq @is_conf_data-vornr
       and tipord eq @tipord
       and status eq 'A'.

    if lt_pp_sf014[] is not initial.
*    Check if exist records saved for confirmation
      select single *
        from zabsf_pp065
        into @data(ls_pp_sf065)
       where conf_no  eq @is_conf_data-conf_no
         and conf_cnt eq @is_conf_data-conf_cnt.

      if sy-subrc eq 0.

      else.
*      Counter number of operators in Production Order
        describe table lt_pp_sf014 lines l_nr_operator.

*      Get data of first confirmation in Production
*        select * up to 1 rows
*          from zabsf_pp065
*          into @data(ls_conf_adit)
*         where conf_no eq @is_conf_data-conf_no
*           and ficha   eq @is_conf_data-ficha
*         order by conf_cnt ascending.
*        endselect.

*      Move data to save
        move-corresponding is_conf_data to ls_pp_sf065.
        clear ls_pp_sf065-ficha.

*      Werks
        ls_pp_sf065-werks = inputobj-werks.

*      Operator ID
        ls_pp_sf065-oprid = inputobj-oprid.

*      Check if regime was filled
*        IF ls_pp_sf065-regime_id IS INITIAL.
*          ls_pp_sf065-regime_id = ls_conf_adit-regime_id.
*        ENDIF.
*
**      Check if schedule was filled
*        IF ls_pp_sf065-schedule_id IS INITIAL.
*          ls_pp_sf065-schedule_id = ls_conf_adit-schedule_id.
*        ENDIF.

*      Card
*        IF ls_pp_sf065-ficha IS INITIAL.
*          ls_pp_sf065-ficha = ls_conf_adit-ficha.
*        ENDIF.

*      Initial counter
*        if ls_pp_sf065-count_ini is initial.
*          ls_pp_sf065-count_ini = ls_conf_adit-count_ini.
*        endif.

*      Final counter
        if ls_pp_sf065-count_fin is initial.
**        Get data of last confirmation in Production with final counter
*          SELECT count_fin UP TO 1 ROWS
*            FROM zabsf_pp065
*            INTO (@DATA(l_count_fin))
*           WHERE conf_no   EQ @is_conf_data-conf_no
*             AND count_fin NE @space
*             AND ficha     EQ @is_conf_data-ficha
*           ORDER BY conf_cnt DESCENDING.
*          ENDSELECT.
*
*          ls_pp_sf065-count_fin = l_count_fin.
        endif.

*      Cause ID
*        if is_conf_data-stprsnid is not initial.
*          ls_pp_sf065-stprsnid = is_conf_data-stprsnid.
*        endif.


*      Get Routing number of operations in the order and General counter for order
        select single afvc~aufpl, afvc~aplzl
          from afko as afko
         inner join afvc as afvc
            on afvc~aufpl eq afko~aufpl
         where afko~aufnr eq @is_conf_data-aufnr
           and afvc~vornr eq @is_conf_data-vornr
          into (@data(l_aufpl),@data(l_aplzl)).

*      Get theoritical times and quantity
*        CALL METHOD me->get_theorical_data
*          EXPORTING
*            aufnr = is_conf_data-aufnr
*            vornr = is_conf_data-vornr
*            aufpl = l_aufpl
*            aplzl = l_aplzl
*          IMPORTING
*            vgw02 = ls_pp_sf065-time_mcycle
*            bmsch = l_bmsch.

*      Total theoretical quantity
        "  ls_pp_sf065-numb_mcycle = l_bmsch.

        if l_nr_operator gt 1.
          loop at lt_pp_sf014 into data(ls_pp_sf014).
*          Check operator
            if ls_pp_sf065-oprid eq ls_pp_sf014-oprid.
              clear: ls_pp_sf065-scale_id,
                     ls_pp_sf065-quali,
                     ls_pp_sf065-profcy,
                     ls_pp_sf065-profc_text.

*            Get qualification of operator
*              CALL METHOD me->get_quali_pernr_active_prdord
*                EXPORTING
*                  arbpl      = is_conf_data-arbpl
*                  pernr      = inputobj-pernr
*                  aufnr      = is_conf_data-aufnr
*                IMPORTING
*                  scale_id   = ls_pp_sf065-scale_id
*                  quali      = ls_pp_sf065-quali
*                  profcy     = ls_pp_sf065-profcy
*                  profc_text = ls_pp_sf065-profc_text.

*            Append data to internal table
              insert ls_pp_sf065 into table lt_pp_sf065.
            else.
              clear: ls_pp_sf065-scale_id,
                     ls_pp_sf065-quali,
                     ls_pp_sf065-profcy,
                     ls_pp_sf065-profc_text.

*            Change operator
              ls_pp_sf065-oprid = ls_pp_sf014-oprid.

*            Personal number
*              CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*                EXPORTING
*                  input  = ls_pp_sf065-oprid
*                IMPORTING
*                  output = l_pernr.

*            Get qualification of operator
*              CALL METHOD me->get_quali_pernr_active_prdord
*                EXPORTING
*                  arbpl      = is_conf_data-arbpl
*                  pernr      = l_pernr
*                  aufnr      = is_conf_data-aufnr
*                IMPORTING
*                  scale_id   = ls_pp_sf065-scale_id
*                  quali      = ls_pp_sf065-quali
*                  profcy     = ls_pp_sf065-profcy
*                  profc_text = ls_pp_sf065-profc_text.

*            Append data to internal table
              insert ls_pp_sf065 into table lt_pp_sf065.
            endif.
          endloop.
        else.
*        Personal number
*          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*            EXPORTING
*              input  = ls_pp_sf065-oprid
*            IMPORTING
*              output = l_pernr.
*
**            Get qualification of operator
*          CALL METHOD me->get_quali_pernr_active_prdord
*            EXPORTING
*              arbpl      = is_conf_data-arbpl
*              pernr      = l_pernr
*              aufnr      = is_conf_data-aufnr
*            IMPORTING
*              scale_id   = ls_pp_sf065-scale_id
*              quali      = ls_pp_sf065-quali
*              profcy     = ls_pp_sf065-profcy
*              profc_text = ls_pp_sf065-profc_text.

*        Append data to internal table
          insert ls_pp_sf065 into table lt_pp_sf065.
        endif.

*      Save data in database
        if lt_pp_sf065[] is not initial.
          insert zabsf_pp065 from table lt_pp_sf065.

          if sy-subrc eq 0.
            commit work and wait.
          else.
            call method zabsf_pp_cl_log=>add_message
              exporting
                msgty      = 'E'
                msgno      = '142'
              changing
                return_tab = return_tab.
          endif.
        endif.
      endif.
    endif.
  endmethod.


METHOD set_batch_open_for_use.
* Constants
    CONSTANTS: c_261 TYPE bwart VALUE '261'. "GI for order
    DATA: ls_ZABSF_PP078 TYPE zabsf_pp078.

    LOOP AT goodsmovements_tab INTO DATA(ls_goodsmovements) WHERE move_type EQ c_261
                                                             AND batch IS NOT INITIAL.
      "Insert batch in ZABSF_PP078
      CLEAR ls_ZABSF_PP078.
      ls_ZABSF_PP078-werks = ls_goodsmovements-plant.
      ls_ZABSF_PP078-charg = ls_goodsmovements-batch.
      ls_ZABSF_PP078-validation_date = sy-datum.
      ls_ZABSF_PP078-valid_days = 1.
      MODIFY zabsf_pp078 FROM ls_ZABSF_PP078.
    ENDLOOP.

  ENDMETHOD.


METHOD set_box_quantity.
*  Structures
    DATA: ls_orderdata  TYPE bapi_pp_order_change,
          ls_orderdatax TYPE bapi_pp_order_changex,
          ls_return     TYPE bapiret2.

*  Variables
    DATA: l_boxqty TYPE zabsf_pp_e_boxqty,
          l_vornr  TYPE vornr,
          l_aplzl  TYPE co_aplzl.

*  Export to memory Box quantity
    EXPORT l_boxqty FROM boxqty TO MEMORY ID 'BOXQTY_SF'.
*  Export to memory Activity Number
    EXPORT l_vornr FROM vornr TO MEMORY ID 'VORNR_SF'.
*  Export to memory general counter for order
    EXPORT l_aplzl FROM aplzl TO MEMORY ID 'APLZL_SF'.

*  Change box quantity
    CALL FUNCTION 'BAPI_PRODORD_CHANGE'
      EXPORTING
        number     = aufnr
        orderdata  = ls_orderdata
        orderdatax = ls_orderdatax
      IMPORTING
        return     = ls_return.

    IF sy-subrc EQ 0.
*    Operation completed sucessfully
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'S'
          msgno      = '013'
        CHANGING
          return_tab = return_tab.
    ENDIF.
  ENDMETHOD.


METHOD set_quantity.
  DATA: it_timetickets    TYPE TABLE OF bapi_pp_timeticket,
        it_timeticket_aux TYPE TABLE OF bapi_pp_timeticket,
        detail_return     TYPE TABLE OF bapi_coru_return,
        lt_mkal           TYPE TABLE OF mkal.

  DATA: wa_timetickets    TYPE bapi_pp_timeticket,
        wa_timeticket_aux TYPE bapi_pp_timeticket,
        wa_detail_return  TYPE bapi_coru_return,
        return            TYPE bapiret2,
        ls_return         TYPE bapiret1,
        ls_prdty          TYPE zabsf_pp_e_prdty,
        wa_qty_conf       TYPE zabsf_pp_s_qty_conf,
        ls_zabsf_pp017    TYPE zabsf_pp017,
        ls_zabsf_pp035    TYPE zabsf_pp035,
        ls_zabsf_pp057    TYPE zabsf_pp057,
        ls_afru           TYPE afru,
        i_source_value    TYPE i,
        ls_conftype       TYPE zabsf_pp_e_conftype,
        propose           TYPE bapi_pp_conf_prop,
        ld_wareid         TYPE zabsf_pp_e_areaid,
        ld_lmnga          TYPE lmnga,
        ls_bflushflags    TYPE bapi_rm_flg,
        ls_bflushdatagen  TYPE bapi_rm_datgen,
        ls_bflushdatamts  TYPE bapi_rm_datstock,
        confirmation      TYPE bapi_rm_datkey-confirmation,
        ls_mkal           TYPE mkal,
        ld_shiftid        TYPE zabsf_pp_e_shiftid,
        lv_reverse        TYPE ru_lmnga,
        lv_lmnga          TYPE ru_lmnga,
        lv_rmnga          TYPE ru_rmnga,
        lv_xmnga          TYPE ru_xmnga.


  CLEAR: ls_bflushflags,
         ls_bflushdatagen,
         ls_conftype,
         ls_prdty,
         wa_qty_conf.

*  IF NOT lenum IS INITIAL.
*    DATA:  ls_imprime TYPE zpp10_imprime.
*    ls_imprime-uname = sy-uname.
*    ls_imprime-imprime = 'X'.
*    MODIFY zpp10_imprime FROM ls_imprime.
**    EXPORT flag_nao_imprime = flag_nao_imprime TO DATABASE indx(xy) FROM wa_indx CLIENT
**      sy-mandt
**      ID 'IMPRIME_PALETE'.
*
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

*Get process type
  SELECT SINGLE prdty
    FROM zabsf_pp013
    INTO ls_prdty
   WHERE areaid EQ areaid
     AND werks  EQ werks
     AND arbpl  EQ arbpl.

  IF sy-subrc EQ 0.
    CASE ls_prdty.
      WHEN prdty_discret. "Discret
        REFRESH: it_timeticket_aux,
                 it_timetickets,
                 detail_return.

        CLEAR: wa_timeticket_aux,
               wa_timetickets,
               propose.

*      Check order type
        IF tipord EQ 'N'.
*        Propose data for confirmation times and quantity
          propose-activity = 'X'.
        ELSE.
*        Propose data for confirmation quantity
          propose-quantity = 'X'.
        ENDIF.

        LOOP AT qty_conf_tab INTO wa_qty_conf.
*        Insert data for confirmation
          wa_timetickets-orderid = wa_qty_conf-aufnr.
          wa_timetickets-operation = wa_qty_conf-vornr.

*        Check stock for material
          IF check_stock IS NOT INITIAL.
            CLEAR: ld_wareid,
                   ld_lmnga.

            SELECT SINGLE wareid
              FROM zabsf_pp039
              INTO ld_wareid
             WHERE areaid EQ inputobj-areaid
               AND werks EQ inputobj-werks
               AND ware_next EQ space.

            IF sy-subrc EQ 0.
              SELECT SINGLE lmnga
                FROM zabsf_pp035
                INTO ld_lmnga
               WHERE wareid EQ ld_wareid
                 AND matnr  EQ wa_qty_conf-matnr.

              IF wa_qty_conf-lmnga GT ld_lmnga.
                CALL METHOD zabsf_pp_cl_log=>add_message
                  EXPORTING
                    msgty      = 'E'
                    msgno      = '042'
                    msgv1      = ld_wareid
                    msgv2      = ld_lmnga
                  CHANGING
                    return_tab = return_tab.

                EXIT.
              ELSE.
                wa_timetickets-yield = wa_qty_conf-lmnga.
              ENDIF.
            ENDIF.
          ELSE.
            wa_timetickets-yield = wa_qty_conf-lmnga.
          ENDIF.

          APPEND wa_timetickets TO it_timeticket_aux.

          CALL FUNCTION 'BAPI_PRODORDCONF_GET_TT_PROP'
            EXPORTING
              propose       = propose
            IMPORTING
              return        = ls_return
            TABLES
              timetickets   = it_timeticket_aux
              detail_return = detail_return.
        ENDLOOP.

*      Create two lines in timeticket (one for quantity and another for times)
        CLEAR wa_timetickets.

        LOOP AT it_timeticket_aux INTO wa_timeticket_aux.
*        Line for quantity
          wa_timetickets-conf_no = wa_timeticket_aux-conf_no.
          wa_timetickets-orderid = wa_timeticket_aux-orderid.
          wa_timetickets-operation = wa_timeticket_aux-operation.
          wa_timetickets-sequence = wa_timeticket_aux-sequence.
          wa_timetickets-postg_date = wa_timeticket_aux-postg_date.
          wa_timetickets-plant = wa_timeticket_aux-plant.
          wa_timetickets-kaptprog = ld_shiftid.


          READ TABLE qty_conf_tab INTO wa_qty_conf WITH KEY aufnr = wa_timeticket_aux-orderid
                                                            vornr = wa_timeticket_aux-operation.

          IF sy-subrc EQ 0.
            wa_timetickets-yield = wa_qty_conf-lmnga.
          ENDIF.

          wa_timetickets-conf_quan_unit = wa_timeticket_aux-conf_quan_unit.
          wa_timetickets-conf_quan_unit_iso = wa_timeticket_aux-conf_quan_unit_iso.
          wa_timetickets-ex_created_by = inputobj-oprid.

          APPEND wa_timetickets TO it_timetickets.

          IF tipord EQ 'N'.
*          Line for times
            MOVE-CORRESPONDING wa_timeticket_aux TO wa_timetickets.
            wa_timetickets-ex_created_by = inputobj-oprid.
            wa_timetickets-kaptprog = ld_shiftid.

            CLEAR: wa_timetickets-yield,
                   wa_timetickets-conf_quan_unit,
                   wa_timetickets-conf_quan_unit_iso.

            APPEND wa_timetickets TO it_timetickets.
          ENDIF.
        ENDLOOP.

        IF it_timetickets[] IS NOT INITIAL.
*      Create confirmation
          CALL FUNCTION 'BAPI_PRODORDCONF_CREATE_TT'
            IMPORTING
              return        = ls_return
            TABLES
              timetickets   = it_timetickets
              detail_return = detail_return.

          IF ls_return IS INITIAL.
            CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
              EXPORTING
                wait = 'X'.
          ENDIF.
        ENDIF.

        CLEAR: ls_afru,
               ls_zabsf_pp017,
               i_source_value.

        DELETE ADJACENT DUPLICATES FROM detail_return.

*      Details of operation
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

          IF wa_detail_return-type EQ 'I' OR wa_detail_return-type EQ 'S'.
            CLEAR wa_qty_conf.

            READ TABLE qty_conf_tab INTO wa_qty_conf WITH KEY aufnr = wa_detail_return-message_v1.

*          Get value of confirmation
            SELECT SINGLE *
              FROM afru
              INTO CORRESPONDING FIELDS OF ls_afru
              WHERE rueck EQ wa_detail_return-conf_no
                AND rmzhl EQ wa_detail_return-conf_cnt
                AND aufnr EQ wa_qty_conf-aufnr.

            IF sy-subrc EQ 0.
*            Get value in Database
              SELECT SINGLE *
                FROM zabsf_pp017
                INTO CORRESPONDING FIELDS OF ls_zabsf_pp017
               WHERE aufnr EQ wa_qty_conf-aufnr
                 AND matnr EQ wa_qty_conf-matnr
                 AND vornr EQ wa_qty_conf-vornr.

              IF sy-subrc EQ 0.
                CLEAR: lv_reverse,
                       lv_lmnga,
                       lv_rmnga,
                       lv_xmnga.

*              PAP - START - 01.04.2015 - Get sum of Reversed
*              Reverse quantity
                SELECT SUM( lmnga )
                  FROM afru
                  INTO lv_reverse
                 WHERE rueck EQ wa_detail_return-conf_no
                   AND aufnr EQ wa_qty_conf-aufnr
                   AND stokz NE space
                   AND stzhl NE space.

*              Confirmed quantity
                SELECT SUM( lmnga ) SUM( rmnga ) SUM( xmnga )
                  FROM afru
                  INTO (lv_lmnga, lv_rmnga, lv_xmnga)
                 WHERE rueck EQ wa_detail_return-conf_no
                   AND aufnr EQ wa_qty_conf-aufnr
                   AND stokz EQ space
                   AND stzhl EQ space.
*                PAP - START - 01.04.2015 - Get sum of Reversed

                ADD ls_afru-lmnga TO ls_zabsf_pp017-lmnga.

*                ls_ZABSF_PP017-missingqty = ls_ZABSF_PP017-gamng - ls_ZABSF_PP017-lmnga.
                ls_zabsf_pp017-missingqty = ls_zabsf_pp017-gamng - lv_lmnga - lv_rmnga - lv_xmnga - lv_reverse.
                i_source_value = ls_zabsf_pp017-gamng.

*              Convert Unit
                CALL METHOD me->convert_unit
                  EXPORTING
                    matnr        = ls_zabsf_pp017-matnr
                    source_value = i_source_value
                    source_unit  = ls_zabsf_pp017-gmein
                    lmnga        = ls_afru-lmnga
                  CHANGING
                    prdqty_box   = ls_zabsf_pp017-prdqty_box
                    boxqty       = ls_zabsf_pp017-boxqty.

                ADD ls_afru-lmnga TO ls_zabsf_pp017-prdqty_box.
*              Update database
                UPDATE zabsf_pp017 FROM ls_zabsf_pp017.
              ENDIF.

              IF check_stock IS NOT INITIAL.
                CLEAR ls_zabsf_pp035.

*              Get information of warehouse
                SELECT SINGLE *
                 FROM zabsf_pp035
                 INTO ls_zabsf_pp035
                WHERE wareid EQ ld_wareid
                  AND matnr  EQ wa_qty_conf-matnr.

                SUBTRACT ls_afru-lmnga FROM ls_zabsf_pp035-lmnga.

                UPDATE zabsf_pp035 FROM ls_zabsf_pp035.
              ENDIF.
            ENDIF.

*         Transfer quantity to warehouse virtual
            IF wa_qty_conf-wareid IS NOT INITIAL.
              CLEAR ls_zabsf_pp035.

*            Check if exist quantity saved
              SELECT SINGLE *
                FROM zabsf_pp035
                INTO CORRESPONDING FIELDS OF ls_zabsf_pp035
                WHERE areaid EQ inputobj-areaid
                  AND wareid EQ wa_qty_conf-wareid
                  AND matnr  EQ wa_qty_conf-matnr.

              IF sy-subrc EQ 0.
                ADD ls_afru-lmnga TO ls_zabsf_pp035-stock.
                UPDATE zabsf_pp035 FROM ls_zabsf_pp035.
              ELSE.
                ls_zabsf_pp035-areaid = inputobj-areaid.
                ls_zabsf_pp035-wareid = wa_qty_conf-wareid.
                ls_zabsf_pp035-matnr = wa_qty_conf-matnr.
                ls_zabsf_pp035-stock = ls_afru-lmnga.
                ls_zabsf_pp035-gmein = ls_afru-gmein.

                INSERT zabsf_pp035 FROM ls_zabsf_pp035.
              ENDIF.

              IF ls_afru-lmnga NE 0.
*            Saved regist of quantity good
                CLEAR ls_zabsf_pp057.

                ls_zabsf_pp057-areaid = inputobj-areaid.
                ls_zabsf_pp057-wareid = wa_qty_conf-wareid.
                ls_zabsf_pp057-matnr = wa_qty_conf-matnr.
                ls_zabsf_pp057-data = refdt.
                ls_zabsf_pp057-time = sy-uzeit.
                ls_zabsf_pp057-oprid = inputobj-oprid.
                ls_zabsf_pp057-lmnga = ls_afru-lmnga.
                ls_zabsf_pp057-gmein = ls_afru-gmein.

                INSERT zabsf_pp057 FROM ls_zabsf_pp057.

                IF sy-subrc EQ 0.
*              Operation completed successfully
                  CALL METHOD zabsf_pp_cl_log=>add_message
                    EXPORTING
                      msgty      = 'S'
                      msgno      = '013'
                    CHANGING
                      return_tab = return_tab.
                ELSE.
*              Operation not completed successfully
                  CALL METHOD zabsf_pp_cl_log=>add_message
                    EXPORTING
                      msgty      = 'E'
                      msgno      = '012'
                    CHANGING
                      return_tab = return_tab.

                  CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDLOOP.
      WHEN prdty_repetitive. "Repetitive

**      Control parameter for confirmation
**      Backflush type
*        ls_bflushflags-bckfltype = '02'.
**      Scope of activity backflush
*        ls_bflushflags-activities_type = '1'.
**      Scope of GI posting
*        ls_bflushflags-components_type = '1'.
*
**      Production Versions of Material
*        SELECT *
*          FROM mkal
*          INTO CORRESPONDING FIELDS OF TABLE lt_mkal
*           FOR ALL ENTRIES IN qty_conf_tab
*         WHERE matnr EQ qty_conf_tab-matnr
*           AND werks EQ inputobj-werks.
*
**      Backflush Parameters Independent of Process
*        LOOP AT qty_conf_tab INTO wa_qty_conf.
*          CLEAR: ls_bflushdatagen,
*                 ls_mkal,
*                 confirmation,
*                 return.
*
**        Material
*          ls_bflushdatagen-materialnr = wa_qty_conf-matnr.
**        Plant
*          ls_bflushdatagen-prodplant = inputobj-werks.
**        Planning plant
*          ls_bflushdatagen-planplant = inputobj-werks.
*
*          READ TABLE lt_mkal INTO ls_mkal WITH KEY matnr = wa_qty_conf-matnr.
*
*          IF sy-subrc EQ 0.
**          Storage Location
*            ls_bflushdatagen-storageloc = ls_mkal-alort.
**          Production Version
*            ls_bflushdatagen-prodversion = ls_mkal-verid.
**          Production line
*            ls_bflushdatagen-prodline = ls_mkal-mdv01.
*          ENDIF.
*
**        Posting date
*          ls_bflushdatagen-postdate = sy-datum.
**        Document date
*          ls_bflushdatagen-docdate = sy-datum.
**        Quantity in Unit of Entry
*          ls_bflushdatagen-backflquant = wa_qty_conf-lmnga.
**        Unit of measure
*          ls_bflushdatagen-unitofmeasure = wa_qty_conf-gmein.
*
**        Report point
*          ls_bflushdatamts-reppoint = wa_qty_conf-vornr.
*
*          CALL FUNCTION 'BAPI_REPMANCONF1_CREATE_MTS'
*            EXPORTING
*              bflushflags   = ls_bflushflags
*              bflushdatagen = ls_bflushdatagen
*              bflushdatamts = ls_bflushdatamts
*            IMPORTING
*              confirmation  = confirmation
*              return        = return.
*
*          IF return IS INITIAL AND confirmation IS NOT INITIAL.
*            CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
*              EXPORTING
*                wait = 'X'.
*          ELSE.
*            APPEND return TO return_tab.
*          ENDIF.
*        ENDLOOP.
*
*        DELETE ADJACENT DUPLICATES FROM return_tab.
    ENDCASE.
  ELSE.
*  No data found in customizing table for Workcenter
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'E'
        msgno      = '022'
        msgv1      = arbpl
      CHANGING
        return_tab = return_tab.
  ENDIF.
ENDMETHOD.


METHOD set_quantity_ord.

*Internal tables
  DATA: lt_qty_conf                TYPE zabsf_pp_t_qty_conf,
        lt_timeticket_prop         TYPE TABLE OF bapi_pp_timeticket,
        lt_goodsmovements_prop     TYPE TABLE OF bapi2017_gm_item_create,
        lt_link_conf_goodsmov_prop TYPE TABLE OF bapi_link_conf_goodsmov,
        lt_timetickets             TYPE TABLE OF bapi_pp_timeticket,
        lt_goodsmovements          TYPE TABLE OF bapi2017_gm_item_create,
        lt_link_conf_goodsmov      TYPE TABLE OF bapi_link_conf_goodsmov,
        lt_detail_return           TYPE TABLE OF bapi_coru_return,
        lt_create_batch            TYPE zabsf_pp_t_goodmovements,
        lt_goodsmovements_new      TYPE TABLE OF bapi2017_gm_item_create,
        lt_return_tab2             TYPE bapiret2_t,
        lt_return_tab3             TYPE bapiret2_t.

*Structures
  DATA: ls_propose            TYPE bapi_pp_conf_prop,
        ls_timeticket_prop    TYPE bapi_pp_timeticket,
        ls_timetickets        TYPE bapi_pp_timeticket,
        ls_goodsmovements     TYPE bapi2017_gm_item_create,
        ls_link_conf_goodsmov TYPE bapi_link_conf_goodsmov,
        ls_return             TYPE bapiret1,
        ls_return_conf        TYPE bapiret2,
        ls_conf_data          TYPE zabsf_pp_s_conf_adit_data,
        ls_create_batch       TYPE zabsf_pp_s_goodmovements,
        ls_conf_tab           TYPE zabsf_pp_s_confirmation,
        ls_goodsmovements_new TYPE bapi2017_gm_item_create,
        lv_no101_var          TYPE flag.

*Reference
  DATA: lref_sf_prdord TYPE REF TO zabsf_pp_cl_prdord.

*Variables
  DATA: l_source_value TYPE i,
        l_conf_no      TYPE co_rueck,
        l_conf_cnt     TYPE co_rmzhl,
        l_new_batch    TYPE charg_d,
        l_langu        TYPE spras,
        l_flag         TYPE flag,
        l_wait_cancel  TYPE i,
        l_stock        TYPE labst,
        l_entry_qnt    TYPE  erfmg,
        l_index        TYPE sy-tabix,
        lv_umb_qtt     TYPE bstmg.

  DATA: lv_lenum_lines TYPE i.

  DATA:
    ls_batchattributes   TYPE bapibatchatt,
    ls_batchattributes_e TYPE bapibatchatt,
    ls_batchattributesx  TYPE bapibatchattx,
    ls_return_chg        TYPE bapiret2,
    lt_return_chg        TYPE bapiret2_t,
    lv_matnr_chg         TYPE bapibatchkey-material,
    lv_charg_chg         TYPE bapibatchkey-batch,
    lv_werks_chg         TYPE bapibatchkey-plant.

  DATA: ls_zpp10_datas_lote TYPE zpp10_datas_lote,
        lr_steus_rng        TYPE RANGE OF steus,
        lr_zpp2_copy_rng    TYPE RANGE OF atnam,
        lt_characts_tab     TYPE zabsf_pp_tt_batch_charact,
        lv_operador_var     TYPE atnam,
        lv_aramador_var     TYPE atnam.

*Constants
  CONSTANTS: c_101         TYPE bwart          VALUE '101', "GR goods receipt
             c_261         TYPE bwart          VALUE '261', "GI for order
             c_mtart_verp  TYPE mtart          VALUE 'VERP', "Material type - Packing
             c_inspection  TYPE aufart         VALUE 'ZINS',
             c_wait_cancel TYPE zabsf_pp_e_parid VALUE 'WAIT_CANCEL'.


*Set language local for user
  l_langu = sy-langu.

  SET LOCALE LANGUAGE l_langu.

*Translate to upper case
  TRANSLATE inputobj-oprid TO UPPER CASE.

*>>SETUP
  DATA: lref_sf_parameters TYPE REF TO zabsf_pp_cl_parameters,
        ls_output_settings TYPE zabsf_pp_s_visual_settings.

  CREATE OBJECT lref_sf_parameters
    EXPORTING
      initial_refdt = refdt
      input_object  = inputobj.

  CALL METHOD lref_sf_parameters->get_output_settings
    EXPORTING
      get_all        = abap_true
    IMPORTING
      all_parameters = ls_output_settings
    CHANGING
      return_tab     = return_tab.

*  IF backoffice IS INITIAL.
  IF shiftid IS INITIAL.
*  Get shift witch operator is associated
    SELECT SINGLE shiftid
      FROM zabsf_pp052
      INTO (@DATA(l_shiftid))
     WHERE areaid EQ @inputobj-areaid
       AND oprid  EQ @inputobj-oprid.

    IF sy-subrc NE 0.
*    Operator is not associated with shift
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
*  Shift ID
    l_shiftid = shiftid.
  ENDIF.

  "obter configuração impressão de etiquetas por operação
*  try.
*      zcl_bc_fixed_values=>get_ranges_value( exporting
*                                               im_paramter_var = zcl_bc_fixed_values=>gc_printprd_cst
*                                               im_modulesp_var = zcl_bc_fixed_values=>gc_productn_cst
*                                             importing
*                                               ex_valrange_tab = lr_steus_rng ).
*
*      "carcateristica com os operadores
*      zcl_bc_fixed_values=>get_single_value( exporting
*                                       im_paramter_var = zcl_bc_fixed_values=>gc_charopers_cst
*                                       im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
*                                     importing
*                                       ex_prmvalue_var = data(lv_valuechr_var) ).
*
*      lv_operador_var = lv_valuechr_var.
*
*      "carcateristica com os armadores
*      zcl_bc_fixed_values=>get_single_value( exporting
*                                       im_paramter_var = zcl_bc_fixed_values=>gc_charamacao_cst
*                                       im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
*                                     importing
*                                       ex_prmvalue_var = lv_valuechr_var ).
*      lv_aramador_var = lv_valuechr_var.
*
*      "caracteristicas a copiar na EM das ZPP2
*      zcl_bc_fixed_values=>get_ranges_value( exporting
*                                               im_paramter_var = zcl_bc_fixed_values=>gc_zpp2_char_copy_cst
*                                               im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
*                                               im_werksval_var = inputobj-werks
*                                             importing
*                                               ex_valrange_tab = lr_zpp2_copy_rng ).
*    catch zcx_bc_exceptions into data(lo_bcexceptions_obj).
*      " falta configuração
*      call method zabsf_pp_cl_log=>add_message
*        exporting
*          msgty      = lo_bcexceptions_obj->msgty
*          msgno      = lo_bcexceptions_obj->msgno
*          msgid      = lo_bcexceptions_obj->msgid
*          msgv1      = lo_bcexceptions_obj->msgv1
*          msgv2      = lo_bcexceptions_obj->msgv2
*          msgv3      = lo_bcexceptions_obj->msgv3
*          msgv4      = lo_bcexceptions_obj->msgv4
*        changing
*          return_tab = return_tab.
*      return.
*  endtry.

  "obter chaves de controlo para impressão de etiquetas
  READ TABLE qty_conf_tab INTO DATA(ls_confoper_str) INDEX 1.
  IF sy-subrc EQ 0.
    "dados da operação
    SELECT SINGLE afko~aufnr, afvc~vornr, afvc~steus
      FROM afko AS afko
      INNER JOIN afvc AS afvc
      ON afvc~aufpl EQ afko~aufpl
          INTO @DATA(ls_operation_str)
      WHERE afko~aufnr EQ @ls_confoper_str-aufnr
      AND afvc~vornr EQ @ls_confoper_str-vornr
      AND afvc~loekz EQ @space.
  ENDIF.

  IF ls_confoper_str-rueck IS NOT INITIAL.
    "verificar se confirmaçao anterior pertence à ordem+operação
    SELECT SINGLE afko~aufnr, afvc~vornr, afvc~steus
      FROM afko AS afko
     INNER JOIN afvc AS afvc
        ON afvc~aufpl EQ afko~aufpl
            INTO @DATA(ls_labelcheck_str)
     WHERE afko~aufnr EQ @ls_confoper_str-aufnr
       AND afvc~rueck EQ @ls_confoper_str-rueck.
    IF sy-subrc NE 0.
      "Etiqueta não pertence a esta ordem
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgid      = 'ZABSF_PP'
          msgty      = 'E'
          msgno      = '143'
          msgv1      = arbpl
          msgv2      = werks
        CHANGING
          return_tab = return_tab.
      "sair do processamento
      RETURN.
    ENDIF.
  ELSE.
    SELECT SINGLE afko~aufnr, afvc~vornr, afvc~steus
      FROM afko AS afko
      INNER JOIN afvc AS afvc
      ON afvc~aufpl EQ afko~aufpl
          INTO @ls_operation_str
      WHERE afko~aufnr EQ @ls_confoper_str-aufnr
      AND afvc~vornr EQ @ls_confoper_str-vornr.
  ENDIF.

  "flag de impressão de etiquetas
*  data(lv_printlabel_var) = cond #( when ls_operation_str-steus in lr_steus_rng
*                                    then abap_true ).
*  if lv_printlabel_var eq abap_true.
*    "obter impressora
*    select single printer
*      into @data(lv_printer_var)
*      from zabsf_pp081
*        where werks eq @werks
*          and arbpl eq @arbpl.
*    if sy-subrc ne 0.
*      call method zabsf_pp_cl_log=>add_message
*        exporting
*          msgid      = 'ZABSF_PP'
*          msgty      = 'E'
*          msgno      = '134'
*          msgv1      = arbpl
*          msgv2      = werks
*        changing
*          return_tab = return_tab.
*      "sair do processamento
*      return.
*    endif.
*  endif.

  " Check lenght of time
  DATA(l_lengh) = strlen( inputobj-timeconf ).
  DATA(l_wait) = 20.

  IF l_lengh LT 6.
    CONCATENATE '0' inputobj-timeconf INTO DATA(l_time).
  ELSE.
    CLEAR l_lengh.
    l_time = inputobj-timeconf - l_wait.
    l_lengh = strlen( l_time ).

    IF l_lengh LT 6.
      CONCATENATE '0' l_time INTO l_time.
    ENDIF.
  ENDIF.

  "obter posto de trabalho
  SELECT SINGLE kapid
    FROM zabsf_pp014
    INTO @DATA(lv_workstation_id_var)
      WHERE aufnr EQ @ls_confoper_str-aufnr
        AND vornr EQ @ls_confoper_str-vornr
        AND arbpl EQ @arbpl
        AND oprid EQ @inputobj-oprid
        AND kapid NE @space
        AND status EQ 'A'.
  IF sy-subrc EQ 0.
    SELECT SINGLE name
      FROM kako
      INTO @DATA(lv_workstation_var)
        WHERE kapid EQ @lv_workstation_id_var.
  ENDIF.


*Get process type
  SELECT SINGLE prdty
    FROM zabsf_pp013
    INTO (@DATA(l_prdty))
   WHERE areaid EQ @areaid
     AND werks  EQ @werks
     AND arbpl  EQ @arbpl.

  IF sy-subrc EQ 0.
    CASE l_prdty.
      WHEN prdty_discret. "Discret
        REFRESH: lt_timeticket_prop,
                 lt_goodsmovements_prop,
                 lt_link_conf_goodsmov_prop,
                 lt_timetickets,
                 lt_detail_return.

        CLEAR: ls_propose.

*      Propose data for confirmation quantity
        ls_propose-goodsmovement = abap_true.

*      To change
        lt_qty_conf[] = qty_conf_tab[].

        LOOP AT lt_qty_conf ASSIGNING FIELD-SYMBOL(<fs_qty_conf>).
          CLEAR ls_timeticket_prop.

*        Insert data for confirmation
*        Production Order
          ls_timeticket_prop-orderid = <fs_qty_conf>-aufnr.
*        Production Order Operation
          ls_timeticket_prop-operation = <fs_qty_conf>-vornr.
*        Production Order Unit Quantity

***** BEGIN JOL - 01/02/2023 - convert the Confirmation Unit
          CALL FUNCTION 'CONVERSION_EXIT_CUNIT_INPUT'
            EXPORTING
              input          = <fs_qty_conf>-gmein
              language       = 'P'
            IMPORTING
*             LONG_TEXT      = LONG_TEXT
              output         = <fs_qty_conf>-gmein
*             SHORT_TEXT     = SHORT_TEXT
            EXCEPTIONS
              unit_not_found = 1
              OTHERS         = 2.
          IF sy-subrc <> 0.
* Implement suitable error handling here
          ENDIF.

          ls_timeticket_prop-conf_quan_unit = <fs_qty_conf>-gmein.
***** END JOL - 01/02/2023

          SELECT SINGLE meins FROM mara INTO @DATA(lv_meins)
            WHERE matnr EQ @<fs_qty_conf>-matnr.

          CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
            EXPORTING
              i_matnr              = <fs_qty_conf>-matnr
              i_in_me              = <fs_qty_conf>-gmein
              i_out_me             = lv_meins
              i_menge              = <fs_qty_conf>-lmnga
            IMPORTING
              e_menge              = lv_umb_qtt
            EXCEPTIONS
              error_in_application = 1
              error                = 2
              OTHERS               = 3.

*<< BMR
          CALL METHOD me->calculate_qty_absolute_delta
            EXPORTING
              arbpl       = arbpl
              aufnr       = <fs_qty_conf>-aufnr
              vornr       = <fs_qty_conf>-vornr
              matnr       = <fs_qty_conf>-matnr
              lmnga       = lv_umb_qtt
            IMPORTING
              confirm_qty = ls_timeticket_prop-yield
              return_tab  = return_tab.

          IF return_tab[] IS NOT INITIAL.
            DATA(l_error) = abap_true.
            EXIT.
          ENDIF.

          <fs_qty_conf>-lmnga = ls_timeticket_prop-yield.
*BMR - reconverter para a medida da confirmação
          CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
            EXPORTING
              i_matnr              = <fs_qty_conf>-matnr
              i_in_me              = lv_meins
              i_out_me             = <fs_qty_conf>-gmein
              i_menge              = <fs_qty_conf>-lmnga
            IMPORTING
              e_menge              = ls_timeticket_prop-yield
            EXCEPTIONS
              error_in_application = 1
              error                = 2
              OTHERS               = 3.

          APPEND ls_timeticket_prop TO lt_timeticket_prop.

*        Propose data to confirmation
          CALL FUNCTION 'BAPI_PRODORDCONF_GET_TT_PROP'
            EXPORTING
              propose            = ls_propose
            IMPORTING
              return             = ls_return
            TABLES
              timetickets        = lt_timeticket_prop
              goodsmovements     = lt_goodsmovements_prop
              link_conf_goodsmov = lt_link_conf_goodsmov_prop
              detail_return      = lt_detail_return.

          DATA lv_material TYPE string.

          LOOP AT lt_goodsmovements_prop ASSIGNING FIELD-SYMBOL(<ls_goodsmovement>).
            CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
              EXPORTING
                input  = <ls_goodsmovement>-material
              IMPORTING
                output = lv_material.

            <ls_goodsmovement>-batch = VALUE #( materialbatch[ material = lv_material ]-batch OPTIONAL ).
          ENDLOOP.

* Start Change ABACO(AON) : 15.11.2022
* Description: Change the storage location
          IF iv_storage_location IS NOT INITIAL.
            LOOP AT lt_goodsmovements_prop ASSIGNING FIELD-SYMBOL(<fs_goodsmovements_prop>).
              <fs_goodsmovements_prop>-stge_loc = iv_storage_location.
            ENDLOOP.
          ENDIF.
* End Change ABACO(AON) : 15.11.2022

          IF ls_return IS NOT INITIAL.
*          Message error
            APPEND ls_return TO return_tab.

            LOOP AT lt_detail_return INTO DATA(ls_detail_return).
              IF ( ls_detail_return-type NE 'I' AND ls_detail_return-type NE 'S' ).
                CLEAR ls_return_conf.

                ls_return_conf-type = ls_detail_return-type.
                ls_return_conf-id = ls_detail_return-id.
                ls_return_conf-number = ls_detail_return-number.
                ls_return_conf-message = ls_detail_return-message.
                ls_return_conf-message_v1 = ls_detail_return-message_v1.
                ls_return_conf-message_v2 = ls_detail_return-message_v2.
                ls_return_conf-message_v3 = ls_detail_return-message_v3.
                ls_return_conf-message_v4 = ls_detail_return-message_v4.

                APPEND ls_return_conf TO return_tab.
              ENDIF.
            ENDLOOP.

*          If exist error exit program
            l_error = abap_true.
          ENDIF.
        ENDLOOP.

        READ TABLE lt_goodsmovements_prop INTO DATA(ls_goodsmovements_tmp) WITH KEY move_type = '101'.
        IF sy-subrc EQ 0.
          "verficar se todos componentes foram consumidos
          zabsf_pp_cl_consumptions=>check_consumption( EXPORTING
                                                         im_aufnr_var  = ls_confoper_str-aufnr
                                                       IMPORTING
                                                         et_return_tab = return_tab
                                                         et_resb_tab   = DATA(lt_resb_tab) ).
          IF return_tab IS NOT INITIAL.
            "sair do processamento
            RETURN.
          ENDIF.
          "verificar se existem items para alterar
          IF lt_resb_tab IS NOT INITIAL.
            "ordenar tabela de items da ordem
            SORT lt_resb_tab BY posnr.
            "actualizar ordem com os lotes consumidos
            zabsf_pp_cl_prdord=>update_resb_batch( EXPORTING
                                                     im_aufnr_var  = ls_confoper_str-aufnr
                                                     im_resb_tab   = lt_resb_tab
                                                   IMPORTING
                                                     et_return_tab = return_tab ).

            IF return_tab IS NOT INITIAL.
              "sair do processamento
              RETURN.
            ENDIF.
          ENDIF.
        ENDIF.

*      Exit if exist errors
        IF l_error IS NOT INITIAL.
          EXIT.
        ENDIF.

        CLEAR ls_timeticket_prop.

*      Create data to confirmation
        IF lt_timeticket_prop[] IS NOT INITIAL.
          LOOP AT lt_timeticket_prop INTO ls_timeticket_prop.
            CLEAR ls_timetickets.

*          Line for quantity
            ls_timetickets-conf_no = ls_timeticket_prop-conf_no.
            ls_timetickets-orderid = ls_timeticket_prop-orderid.
            ls_timetickets-operation = ls_timeticket_prop-operation.
            ls_timetickets-sequence = ls_timeticket_prop-sequence.

*          Record date
            IF inputobj-dateconf IS NOT INITIAL.
              ls_timetickets-exec_start_date = ls_timetickets-exec_fin_date = inputobj-dateconf.
              ls_timetickets-postg_date = inputobj-dateconf.
            ELSE.
              ls_timetickets-postg_date = ls_timeticket_prop-postg_date.
            ENDIF.

*          Record time
            IF l_time IS NOT INITIAL.
              ls_timetickets-exec_start_time = ls_timetickets-exec_fin_time = l_time.
            ENDIF.

            ls_timetickets-plant = ls_timeticket_prop-plant.
            ls_timetickets-kaptprog = l_shiftid.

*          Counter Number of employees in Production Order
            SELECT COUNT( * )
              FROM zabsf_pp014
              INTO (@DATA(l_nr_operator))
             WHERE arbpl  EQ @arbpl
               AND aufnr  EQ @ls_timeticket_prop-orderid
               AND vornr  EQ @ls_timeticket_prop-operation
               AND tipord EQ @tipord
               AND status EQ 'A'.

            IF l_nr_operator IS NOT INITIAL.
*            Number of employees
              ls_timetickets-no_of_employee = l_nr_operator.
            ENDIF.

*          Get good quantity to confirm
            READ TABLE lt_qty_conf INTO DATA(ls_qty_conf) WITH KEY aufnr = ls_timeticket_prop-orderid
                                                                   vornr = ls_timeticket_prop-operation.

            IF sy-subrc EQ 0.
*            Good quantity
*              ls_timetickets-yield = ls_qty_conf-lmnga.
            ENDIF.

            ls_timetickets-yield = ls_timeticket_prop-yield.

            ls_timetickets-conf_quan_unit = ls_timeticket_prop-conf_quan_unit.
            ls_timetickets-conf_quan_unit_iso = ls_timeticket_prop-conf_quan_unit_iso.
            ls_timetickets-ex_created_by = inputobj-oprid.
            ls_timetickets-conf_text = lv_workstation_var.

            APPEND ls_timetickets TO lt_timetickets.
          ENDLOOP.
        ENDIF.

*      Create data to goods movements
        IF lt_goodsmovements_prop[] IS NOT INITIAL.
*        Read production order and operation
          READ TABLE lt_qty_conf INTO ls_qty_conf INDEX 1.

          IF sy-subrc EQ 0.
*          Production order
            DATA(l_aufnr) = ls_qty_conf-aufnr.
*           Production order operation
            DATA(l_vornr) = ls_qty_conf-vornr.
          ENDIF.

*        Get batches consumption
          SELECT *
            FROM zabsf_pp069
            INTO TABLE @DATA(lt_pp_sf069)
           WHERE werks EQ @inputobj-werks
             AND aufnr EQ @l_aufnr
             AND vornr EQ @l_vornr.

          CLEAR l_index.
          LOOP AT lt_goodsmovements_prop INTO DATA(ls_goodsmovements_prop).
            CLEAR ls_goodsmovements.
            l_index = sy-tabix.

*          Move same fields to output table
            MOVE-CORRESPONDING ls_goodsmovements_prop TO ls_goodsmovements.

**          Movement type
*            CASE ls_goodsmovements_prop-move_type.
*              WHEN c_101. "GR goods receipt
**              Get batch production
*                SELECT SINGLE batch
*                  FROM zabsf_pp066
*                  INTO (@DATA(l_batch))
*                 WHERE werks EQ @inputobj-werks
*                   AND aufnr EQ @l_aufnr
*                   AND vornr EQ @l_vornr.
*
*                IF sy-subrc EQ 0.
*
*                  SELECT SINGLE mtart FROM mara
*                    INTO @DATA(lv_mtart)
*                    WHERE matnr = @ls_goodsmovements_prop-material.
*
*                  ls_goodsmovements-batch = l_batch.
*
**                Batch Production
*                  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*                    EXPORTING
*                      input  = l_batch
*                    IMPORTING
*                      output = ls_goodsmovements-batch.
*                ENDIF.
**                 Old batch
*                DATA(l_old_batch) = ls_goodsmovements-batch.
*
*                "obrigatório ter o lote associado
*                IF ls_goodsmovements-batch IS INITIAL.
**                  call method zabsf_pp_cl_log=>add_message
**                    exporting
**                      msgty      = 'E'
**                      msgno      = '126'
**                    changing
**                      return_tab = return_tab.
**                  return.
*                ENDIF.
*              WHEN c_261. "GI for order
*
*                IF ls_qty_conf-charg_t[] IS NOT INITIAL.
*                  LOOP AT ls_qty_conf-charg_t INTO DATA(ls_charg) WHERE matnr EQ ls_goodsmovements_prop-material.
**                  Batch consumption
*                    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*                      EXPORTING
*                        input  = ls_charg-charg
*                      IMPORTING
*                        output = ls_goodsmovements-batch.
*                  ENDLOOP.
*                ELSE.
**                Get batch consumption for material
*                  READ TABLE lt_pp_sf069 INTO DATA(ls_pp_sf069_temp) WITH KEY matnr = ls_goodsmovements_prop-material.
*
*                  IF sy-subrc EQ 0.
**                  Batch consumption
*                    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*                      EXPORTING
*                        input  = ls_pp_sf069_temp-batch
*                      IMPORTING
*                        output = ls_goodsmovements-batch.
*                  ENDIF.
*                ENDIF.
*            ENDCASE.

            READ TABLE lt_goodsmovements ASSIGNING FIELD-SYMBOL(<fs_goods>)
                  WITH KEY material = ls_goodsmovements_prop-material
                           move_type = c_261.
            IF ( sy-subrc = 0 ).
              <fs_goods>-entry_qnt = <fs_goods>-entry_qnt +
                                     ls_goodsmovements-entry_qnt.
              DELETE lt_link_conf_goodsmov_prop INDEX l_index.
              CONTINUE.
            ELSE.
              IF ( l_index IS INITIAL ).
                l_index = sy-tabix + 1.
              ELSE.
                l_index = l_index + 1.
              ENDIF.
            ENDIF.

*          Append to output table
            APPEND ls_goodsmovements TO lt_goodsmovements.
          ENDLOOP.

        ENDIF.
***************************************************************
        "If supervisor is active, store batches in table
*        if supervisor = 'X'.
*          call method me->set_batch_open_for_use
*            exporting
*              goodsmovements_tab = lt_goodsmovements.
*        endif.


*        if backoffice is initial and supervisor is initial
** SETUP
*        and ls_output_settings-batch_validation eq abap_true.
**        Check validation for Consumption batchs
*          call method me->check_available_stock
*            exporting
*              areaid             = areaid
*              arbpl              = arbpl
*              aufnr              = l_aufnr
*              goodsmovements_tab = lt_goodsmovements
*            importing
*              msg_error          = l_error
**             return_tab         = return_tab
*              return_tab         = lt_return_tab2.
*
**        Exit if exist errors
*          if ( l_error is not initial ).
***         Send error msg to Shopfloor
*            move lt_return_tab2[] to return_tab[].
*            exit.
*          endif.
*        endif.


*      Link to confirmation of good movement
        IF lt_link_conf_goodsmov_prop[] IS NOT INITIAL.
          READ TABLE lt_link_conf_goodsmov_prop INTO DATA(ls_link_conf_goodsmov_prop) INDEX 1.
          LOOP AT lt_goodsmovements INTO ls_goodsmovements.
            DATA(lv_tabix_) = sy-tabix.
            ls_link_conf_goodsmov-index_confirm = ls_link_conf_goodsmov_prop-index_confirm.
            ls_link_conf_goodsmov-index_goodsmov = lv_tabix_.
            APPEND ls_link_conf_goodsmov TO lt_link_conf_goodsmov.
          ENDLOOP.
*          LOOP AT lt_link_conf_goodsmov_prop INTO DATA(ls_link_conf_goodsmov_prop).
**          Move same fields to output table
*            MOVE-CORRESPONDING ls_link_conf_goodsmov_prop TO ls_link_conf_goodsmov.
*
**          Append to output table
*            APPEND ls_link_conf_goodsmov TO lt_link_conf_goodsmov.
*          ENDLOOP.
        ENDIF.

        IF lt_timetickets[] IS NOT INITIAL. "AND lt_goodsmovements[] IS NOT INITIAL.
          REFRESH lt_create_batch.
          CLEAR ls_goodsmovements.

          READ TABLE lt_goodsmovements ASSIGNING FIELD-SYMBOL(<fs_goodmovements>)
            WITH KEY move_type = c_101.
          IF sy-subrc EQ 0.
            "obter operadores logados na ordem
            SELECT *
              FROM zabsf_pp014
              INTO TABLE @DATA(lt_pp_sf014)
             WHERE arbpl  EQ @arbpl
               AND aufnr  EQ @ls_confoper_str-aufnr
               AND vornr  EQ @ls_confoper_str-vornr
               AND tipord EQ @tipord
               AND status EQ 'A'.
            "ordenar por operador
            SORT lt_pp_sf014 BY oprid.
            "remover duplicados
            DELETE ADJACENT DUPLICATES FROM lt_pp_sf014 COMPARING oprid.
            "criar tabela com operadores logados na ordem
            LOOP AT lt_pp_sf014 INTO DATA(ls_sf14_str).
              APPEND VALUE #( atnam = lv_operador_var
                              atwrt = ls_sf14_str-oprid ) TO lt_characts_tab.
            ENDLOOP.
            "obter operadores da operação anterior
            SELECT *
              FROM zabsf_pp065
              INTO TABLE @DATA(lt_previous_tab)
               WHERE conf_no EQ @ls_confoper_str-rueck
                 AND conf_cnt EQ @ls_confoper_str-rmzhl.
            LOOP AT lt_previous_tab INTO DATA(ls_pp065_str).
              APPEND VALUE #( atnam = lv_aramador_var
                              atwrt = ls_pp065_str-oprid ) TO lt_characts_tab.
            ENDLOOP.

            "objecto configurador
            SELECT SINGLE cuobj
              FROM afpo
              INTO @DATA(lv_cuobj_var)
               WHERE aufnr EQ @ls_confoper_str-aufnr.
            "ler configuração da ordem de produção - material cabeçalho
            CALL METHOD zcl_mm_classification=>get_classification_config
              EXPORTING
                im_instance_cuobj_var = lv_cuobj_var
              IMPORTING
                ex_classfication_tab  = DATA(lt_classifc_tab)
              EXCEPTIONS
                instance_not_found    = 1
                OTHERS                = 2.
            IF sy-subrc <> 0.
*             Implement suitable error handling here
            ENDIF.
            "copiar o valor das caracteristicas
            LOOP AT lt_classifc_tab INTO DATA(ls_classific_str)
              WHERE atnam IN lr_zpp2_copy_rng.
              "adicionar caracteristica a ser copiada
              APPEND VALUE #( atnam = ls_classific_str-atnam
                              atwrt = ls_classific_str-atwrt ) TO lt_characts_tab.
            ENDLOOP.

            "criar lote de produção
            CALL METHOD zabsf_pp_cl_prdord=>create_production_batch
              EXPORTING
                im_refmatnr_var = <fs_goodmovements>-material
                im_refwerks_var = werks
                it_characts_tab = lt_characts_tab
              IMPORTING
                et_return_tab   = DATA(lt_ret_tab)
                ex_newbatch_var = DATA(ex_newbatch_var)
                ex_error_var    = DATA(lv_bacth_error_var).

            IF lv_bacth_error_var = abap_true.
              APPEND LINES OF lt_ret_tab TO return_tab.
              "sair do processamento
              RETURN.
            ENDIF.
            IF ex_newbatch_var IS NOT INITIAL.
              <fs_goodmovements>-batch = ex_newbatch_var.
            ENDIF.
          ENDIF.
          "preecher linha com novo lote


*            select single * from mch1
*              into @data(ls_mch1)
*              where matnr = @<fs_goodmovements>-material
*                and charg = @<fs_goodmovements>-batch.
*
*            if sy-subrc is initial.
*              ls_batchattributes-expirydate = ls_mch1-vfdat.
*              ls_zpp10_datas_lote-vfdat = ls_mch1-vfdat.
*              ls_batchattributes-prod_date = ls_mch1-hsdat.
*              ls_zpp10_datas_lote-hsdat = ls_mch1-hsdat.
*
*              ls_zpp10_datas_lote-batch = <fs_goodmovements>-batch.
*              ls_zpp10_datas_lote-matnr = <fs_goodmovements>-material.
*
*              ls_batchattributesx-expirydate = abap_true.
*              ls_batchattributesx-prod_date = abap_true.
*
*              modify zpp10_datas_lote from ls_zpp10_datas_lote.
*
*              lv_charg_chg = <fs_goodmovements>-batch.
*              lv_matnr_chg = <fs_goodmovements>-material.
*              lv_werks_chg = werks.
*            endif.

          CLEAR l_error.

*        Check if exist errors
          LOOP AT return_tab INTO DATA(ls_return_tab) WHERE type NE 'S'
                                                        AND type NE 'I'
                                                        AND type NE 'W'.
            l_error = abap_true.
            EXIT.
          ENDLOOP.

          IF l_error IS NOT INITIAL.
            EXIT.
          ENDIF.

** Validate lines of goodsmovements table movement with type = '261' and
*  if propose greater than stock create new line with the difference and
*  change quantity in old line with stock quantity. The difference goes
*  to COGI
          REFRESH lt_goodsmovements_new.
          LOOP AT lt_goodsmovements ASSIGNING <fs_goodmovements>
                                    WHERE move_type EQ c_261.

*    Get material with Batch management requirement indicator
            SELECT SINGLE xchpf
              FROM mara
              INTO @DATA(l_xchpf)
             WHERE matnr EQ @<fs_goodmovements>-material
               AND xchpf EQ @abap_true.
            CHECK sy-subrc = 0 AND NOT l_xchpf IS INITIAL.

*            Check quantity confirmed
            SELECT SINGLE cinsm, clabs
              FROM mchb
              INTO (@DATA(l_cinsm),@DATA(l_clabs))
             WHERE matnr EQ @<fs_goodmovements>-material
               AND werks EQ @<fs_goodmovements>-plant
               AND lgort EQ @<fs_goodmovements>-stge_loc
               AND charg EQ @<fs_goodmovements>-batch.
            IF ( sy-subrc EQ 0 ).
*        Stock quantity of Batch
              CLEAR l_stock.
              l_stock = l_cinsm + l_clabs.

              IF ( l_stock < <fs_goodmovements>-entry_qnt ).
**             New Line with delta
                CLEAR ls_goodsmovements_new.
                MOVE-CORRESPONDING <fs_goodmovements> TO
                                   ls_goodsmovements_new.
                ls_goodsmovements_new-entry_qnt =
                        <fs_goodmovements>-entry_qnt - l_stock.
                APPEND ls_goodsmovements_new TO lt_goodsmovements_new.

**             Old line with stock available
                MOVE l_stock TO <fs_goodmovements>-entry_qnt.

                CLEAR ls_link_conf_goodsmov.
                DESCRIBE TABLE lt_link_conf_goodsmov LINES DATA(lv_cnt).
                READ TABLE lt_link_conf_goodsmov
                      INTO ls_link_conf_goodsmov INDEX lv_cnt.
                ADD 1 TO ls_link_conf_goodsmov-index_goodsmov.
                APPEND ls_link_conf_goodsmov TO lt_link_conf_goodsmov.
              ENDIF.
            ENDIF.
          ENDLOOP.
          IF ( NOT lt_goodsmovements_new[] IS INITIAL ).
            LOOP AT lt_goodsmovements_new INTO ls_goodsmovements_new.
              APPEND ls_goodsmovements_new TO lt_goodsmovements.
            ENDLOOP.
          ENDIF.


          READ TABLE lt_goodsmovements INTO DATA(ls_goodsmovements_tmp2) WITH KEY move_type = '101'.
          IF sy-subrc EQ 0.
            IF ls_goodsmovements_tmp2-batch IS INITIAL.
              DATA(flag_erro) = ''.
            ENDIF.
          ENDIF.

          IF flag_erro = 'X'.
            CALL METHOD zabsf_pp_cl_log=>add_message
              EXPORTING
                msgty      = 'E'
                msgno      = '126'
              CHANGING
                return_tab = return_tab.
            CHECK NOT ls_goodsmovements_tmp-batch IS INITIAL.
          ENDIF.

*        Create confirmation
          DATA: wa_indx TYPE indx.
          DATA: flag_nao_imprime TYPE c.
          DATA: lv_matnr_ TYPE matnr,
                lv_charg_ TYPE charg_d.
          DATA: ls_imprime TYPE zpp10_imprime.
          DATA:   opcode_usr_attr(1)  TYPE x VALUE 5.
          SELECT SINGLE * FROM zabsf_pp066 INTO @DATA(ls_pp066)
              WHERE werks = @werks
                AND aufnr = @<fs_qty_conf>-aufnr
                AND vornr = @<fs_qty_conf>-vornr.

*          DATA(lt_matserprof) =
*            get_material_serial_profile( VALUE #(
*              FOR m IN lt_goodsmovements (
*                matnr = m-material
*                werks = m-plant ) ) ).

*          IF materialserial[] is initial OR line_exists( lt_goodsmovements[ move_type = c_101 ] ).

          "criar confirmação
          CALL FUNCTION 'BAPI_PRODORDCONF_CREATE_TT'
            IMPORTING
              return             = ls_return
            TABLES
              timetickets        = lt_timetickets
*             goodsmovements     = lt_goodsmovements
              link_conf_goodsmov = lt_link_conf_goodsmov
              detail_return      = lt_detail_return.

          IF ls_return IS INITIAL.
            CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
              EXPORTING
                wait = 'X'.

            ">> BMR INSERT 13.04.2020 - impressão de etiquetas
*            if lv_printlabel_var eq abap_true.
*              "dados da etiqueta
*              read table qty_conf_tab into data(ls_conf_str) index 1.
*              read table lt_detail_return into data(ls_detailrt_str) index 1.
*              "obter dados do movimento 101
*              read table lt_goodsmovements into data(ls_goodmvmt_str) with key move_type = '101'.
*              if sy-subrc eq 0.
*                if ls_goodmvmt_str-batch is not initial
*                  and ls_goodmvmt_str-material is not initial.
*
*                  "obter descrição do material a partir do lote
*                  zcl_mm_classification=>get_material_desc_by_batch( exporting
*                                                                       im_material_var    = ls_goodmvmt_str-material
*                                                                       im_batch_var       = ls_goodmvmt_str-batch
*                                                                     importing
*                                                                       ex_description_var = data(lv_matrdesc_var) ).
*                else.
*                  "read data from classification
*                  zcl_mm_classification=>get_material_desc_by_object( exporting
*                                                                        im_cuobj_var       = lv_cuobj_var
*                                                                      importing
*                                                                        ex_description_var = lv_matrdesc_var ).
*                endif.
*                "dados da etiqueta
*                data(ls_newlabel_str) = value zpp_labels_t( rueck = ls_detailrt_str-conf_no
*                                                            rmzhl = ls_detailrt_str-conf_cnt
*                                                            aufnr = ls_goodmvmt_str-orderid
*                                                            arbpl = arbpl
*                                                            werks = ls_goodmvmt_str-plant
*                                                            charg = ls_goodmvmt_str-batch
*                                                            matnr = ls_goodmvmt_str-material
*                                                            maktx = lv_matrdesc_var
*                                                            pspnr = ls_goodmvmt_str-wbs_elem
*                                                            menge = ls_goodmvmt_str-entry_qnt
*                                                            meins = 'UN' "ls_goodmvmt_str-entry_uom
*                                                            uname = inputobj-oprid
*                                                            aedat = sy-datum
*                                                            lifnr = vendor
*                                                            label_from  = ls_conf_str-confirmed_qtt + 1
*                                                            label_to    = ls_conf_str-required_qtt ).
*              else.
*                "etiqueta sem movimento 101
*                lv_no101_var = abap_true.
*                read table lt_timetickets into data(ls_timetickets_str) index 1.
*                if sy-subrc eq 0.
*                  "nome do material
*                  select single cuobj
*                    from afpo
*                    into @lv_cuobj_var
*                     where aufnr eq @ls_timetickets_str-orderid.
*                  "read data from classification
*                  zcl_mm_classification=>get_material_desc_by_object( exporting
*                                                                        im_cuobj_var       = lv_cuobj_var
*                                                                      importing
*                                                                        ex_description_var = lv_matrdesc_var ).
*                  ls_newlabel_str = value zpp_labels_t( rueck = ls_detailrt_str-conf_no
*                                                        rmzhl = ls_detailrt_str-conf_cnt
*                                                        aufnr = ls_timetickets_str-orderid
*                                                        arbpl = arbpl
*                                                        werks = werks
*                                                        charg = space
*                                                        matnr = ls_conf_str-matnr
*                                                        maktx = lv_matrdesc_var
*                                                        pspnr = space
*                                                        menge = ls_timetickets_str-yield
*                                                        meins = 'UN'
*                                                        uname = inputobj-oprid
*                                                        aedat = sy-datum
*                                                        tims  = sy-uzeit
*                                                        lifnr = vendor
*                                                        label_from  = ls_conf_str-confirmed_qtt + 1
*                                                        label_to    = ls_conf_str-required_qtt ).
*                endif.
*              endif.
*              modify zpp_labels_t from ls_newlabel_str.
*              if lv_no101_var eq abap_false.
*                "limpar campos - não sai confirmação na etiqueta qd é movimento 101
*                clear: ls_newlabel_str-rueck, ls_newlabel_str-rmzhl.
*              endif.
*              "lançar impressão
*              if vendor is not initial.
*                "impressão fornecedor
*                zabsf_pp_cl_print=>vendor_pp_label_process( exporting
*                                                              im_newlabel_str = ls_newlabel_str
*                                                              im_aufnrval_var = |{ ls_newlabel_str-aufnr alpha = in }|
*                                                              im_quantity_var = conv #( ls_newlabel_str-menge )
*                                                            changing
*                                                              ch_return_tab   = return_tab ).
*              else.
*                "impressão normal
*                zabsf_pp_cl_print=>dst_print_pp_label( exporting
*                                                         im_soldador_var = inputobj-oprid
*                                                         im_workcent_var = arbpl
*                                                         im_newlabel_str = ls_newlabel_str
*                                                       changing
*                                                         ch_return_tab   = return_tab ).
*              endif.
*            endif.
            "<< BMR END INSERT
          ENDIF.

*        Delete duplicate error message
          DELETE ADJACENT DUPLICATES FROM lt_detail_return.

          CLEAR ls_detail_return.

*        Details of operation
          LOOP AT lt_detail_return INTO ls_detail_return.
            CLEAR ls_return_conf.

            ls_return_conf-type = ls_detail_return-type.
            ls_return_conf-id = ls_detail_return-id.
            ls_return_conf-number = ls_detail_return-number.
            ls_return_conf-message = ls_detail_return-message.
            ls_return_conf-message_v1 = ls_detail_return-message_v1.
            ls_return_conf-message_v2 = ls_detail_return-message_v2.
            ls_return_conf-message_v3 = ls_detail_return-message_v3.
            ls_return_conf-message_v4 = ls_detail_return-message_v4.

            APPEND ls_return_conf TO return_tab.

            IF ls_detail_return-type EQ 'I' OR ls_detail_return-type EQ 'S'.
              CLEAR: ls_qty_conf,
                     ls_conf_tab.

*            Confirmation number
              ls_conf_tab-conf_no = ls_detail_return-conf_no.
              ls_conf_tab-conf_cnt = ls_detail_return-conf_cnt.
*            Confirmation counter
              APPEND ls_conf_tab TO conf_tab.

*            Check if was inspection order
              SELECT SINGLE @abap_true
                FROM aufk
                INTO @DATA(l_exist)
               WHERE aufnr EQ @ls_detail_return-message_v1
                 AND auart EQ @c_inspection.

              IF l_exist EQ abap_true.
*              Get time wait
                SELECT SINGLE parva
                  FROM zabsf_pp032
                  INTO (@DATA(l_wait_param))
                 WHERE parid EQ @c_wait_cancel.

                IF l_wait_param IS NOT INITIAL.
                  l_wait_cancel = l_wait_param.
                ENDIF.

*              Wait for backgroud update SAP Table - AFWI
                IF l_wait_cancel IS NOT INITIAL.
                  WAIT UP TO l_wait_cancel SECONDS.
                ELSE.
                  WAIT UP TO 5 SECONDS.
                ENDIF.

*              Change status
*                call function 'Z_PP10_CHANGE_STATUS'
*                  exporting
*                    iv_rueck = ls_detail_return-conf_no
*                    iv_rmzhl = ls_detail_return-conf_cnt
*                    iv_oprid = inputobj-oprid
*                  importing
*                    ev_flag  = l_flag.
              ENDIF.

*            Get detail of Production Order confirmed
              READ TABLE lt_qty_conf INTO ls_qty_conf WITH KEY aufnr = ls_detail_return-message_v1.

              IF sy-subrc EQ 0.
*              Get quantity confirmed
                SELECT SINGLE *
                  FROM afru
                  INTO @DATA(ls_afru)
                 WHERE rueck EQ @ls_detail_return-conf_no
                   AND rmzhl EQ @ls_detail_return-conf_cnt
                   AND aufnr EQ @ls_qty_conf-aufnr.

                IF sy-subrc EQ 0.
                  CLEAR: l_source_value.

*                Get value values of quantities saved in Database
                  SELECT SINGLE *
                    FROM zabsf_pp017
                    INTO @DATA(ls_pp_sf017)
                   WHERE aufnr EQ @ls_qty_conf-aufnr
                     AND matnr EQ @ls_qty_conf-matnr
                     AND vornr EQ @ls_qty_conf-vornr.

                  IF sy-subrc EQ 0.
*                    CLEAR l_batch.

*                  Reverse quantity
                    SELECT SUM( lmnga )
                      FROM afru
                      INTO (@DATA(l_reverse))
                     WHERE rueck EQ @ls_detail_return-conf_no
                       AND aufnr EQ @ls_qty_conf-aufnr
                       AND stokz NE @space
                       AND stzhl NE @space.

*                  Confirmed quantity
                    SELECT SUM( lmnga ), SUM( rmnga ), SUM( xmnga )
                      FROM afru
                      INTO (@DATA(l_lmnga), @DATA(l_rmnga), @DATA(l_xmnga))
                     WHERE rueck EQ @ls_detail_return-conf_no
                       AND aufnr EQ @ls_qty_conf-aufnr
                       AND stokz EQ @space
                       AND stzhl EQ @space.

*                  Good quantity
                    ADD ls_afru-lmnga TO ls_pp_sf017-lmnga.
*                  Missing quantity
                    ls_pp_sf017-missingqty = ls_pp_sf017-gamng - l_lmnga - l_rmnga - l_reverse.
*                      ls_pp_sf017-missingqty = ls_pp_sf017-gamng - l_lmnga - l_rmnga - l_xmnga - l_reverse. "Commented code 28.09.2016
*                  Quantity
                    l_source_value = ls_pp_sf017-gamng.

*                  Get Routing number for operations and General counter for order
*                    select single afko~aufpl, afvc~aplzl
*                      from afko as afko
*                     inner join afvc as afvc
*                        on afvc~aufpl eq afko~aufpl
*                     where afko~aufnr eq @ls_qty_conf-aufnr
*                       and afvc~vornr eq @ls_qty_conf-vornr
*                      into (@l_aufpl , @l_aplzl).

*BEGIN JOL - 17/11/2022 - Add the "prdqty_box" field to zabsf_pp017 table.
*              Convert Unit
                    CALL METHOD me->convert_unit
                      EXPORTING
                        matnr        = ls_pp_sf017-matnr
                        source_value = l_source_value
                        source_unit  = ls_pp_sf017-gmein
                        lmnga        = ls_afru-lmnga
                      CHANGING
                        prdqty_box   = ls_pp_sf017-prdqty_box
                        boxqty       = ls_pp_sf017-boxqty.

*                  Get batch production
*                    SELECT SINGLE batch
*                      FROM zabsf_pp066
*                      INTO @l_batch
*                     WHERE werks EQ @inputobj-werks
*                       AND aufnr EQ @ls_qty_conf-aufnr
*                       AND vornr EQ @ls_qty_conf-vornr.

*                    IF l_batch IS NOT INITIAL.
*END JOL.
*                    Quantity Produced
                    ADD ls_afru-lmnga TO ls_pp_sf017-prdqty_box.
*                    ENDIF.
*BEGIN ADR - 17/11/2022 - Add the "equipment" field to zabsf_pp017 table.
                    ls_pp_sf017-equipment = iv_equipment.
*END ADR.
*                  Update database
                    UPDATE zabsf_pp017 FROM @ls_pp_sf017.
                  ENDIF.
                ENDIF.
              ENDIF.

              IF ls_detail_return-conf_no IS NOT INITIAL AND ls_detail_return-conf_cnt IS NOT INITIAL.
*              Work center
                ls_conf_data-arbpl = arbpl.
*              Production order
                ls_conf_data-aufnr = ls_qty_conf-aufnr.
*              Production order operation
                ls_conf_data-vornr = ls_qty_conf-vornr.
*              Confirmation number
                ls_conf_data-conf_no = ls_detail_return-conf_no.
*              Confirmation counter
                ls_conf_data-conf_cnt = ls_detail_return-conf_cnt.
*              Cycle number
                "    ls_conf_data-numb_cycle = ls_qty_conf-numb_cycle.
*              Card active and batch
*                select single ficha, batch
*                  from zabsf_pp066
*                  into (@ls_conf_data-ficha, @ls_conf_data-charg)
*                 where werks eq @inputobj-werks
*                   and aufnr eq @ls_qty_conf-aufnr
*                   and vornr eq @ls_qty_conf-vornr.

**              When confirm all box quantity
*                IF ls_conf_data-charg IS INITIAL.
*                  IF l_old_batch IS NOT INITIAL.
*                    ls_conf_data-charg = l_old_batch.
*                  ELSE.
*                    ls_conf_data-charg = l_new_batch.
*                  ENDIF.
*                ENDIF.

*              Shift ID
                ls_conf_data-shiftid = l_shiftid.

**              Get batch production
*                SELECT SINGLE batch
*                  FROM ZABSF_PP066
*                  INTO ls_conf_data-charg
*                 WHERE werks EQ inputobj-werks
*                   AND aufnr EQ ls_qty_conf-aufnr
*                   AND vornr EQ ls_qty_conf-vornr.
                "guardar os opoeradores da ordem
                IF lref_sf_prdord IS NOT BOUND.
*                Create object
                  CREATE OBJECT lref_sf_prdord
                    EXPORTING
                      initial_refdt = refdt
                      input_object  = inputobj.
                ENDIF.

*              Save aditional data of confirmation
                CALL METHOD lref_sf_prdord->save_data_confirmation
                  EXPORTING
                    is_conf_data = ls_conf_data
                  CHANGING
                    return_tab   = return_tab.
              ENDIF.

*            Save Batch consumption
              LOOP AT ls_qty_conf-charg_t INTO DATA(ls_batch).
*>> BMR INSERT - add leading zeros to batch number
                CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                  EXPORTING
                    input  = ls_batch-charg
                  IMPORTING
                    output = ls_batch-charg.
*<< BMR END INSERT.
*                if ls_batch-maktx is not initial.
*                  "obter nome que está  no lote
*                  call method zcl_mm_classification=>get_material_desc_by_batch
*                    exporting
*                      im_material_var    = ls_batch-matnr
*                      im_batch_var       = ls_batch-charg
*                    importing
*                      ex_description_var = data(lv_batchname_var).
*                  "verificar se o nome é igual
*                  if lv_batchname_var ne ls_batch-maktx.
*                    call method zabsf_pp_cl_log=>add_message
*                      exporting
*                        msgty      = 'E'
*                        msgno      = '89'
*                        msgv1      = ls_batch-charg
*                        msgv2      = ls_batch-maktx
*                      changing
*                        return_tab = lt_return_tab.
*
*                    append lines of lt_return_tab to return_tab.
*                    exit.
*                  endif.
*                endif.

*              CHeck if exist batch consumption saved
                SELECT SINGLE *
                  FROM zabsf_pp069
                  INTO @DATA(ls_pp_sf069)
                 WHERE werks EQ @ls_batch-werks
                   AND aufnr EQ @ls_qty_conf-aufnr
                   AND vornr EQ @ls_qty_conf-vornr
                   AND matnr EQ @ls_batch-matnr.

                IF ls_pp_sf069 IS NOT INITIAL AND ls_pp_sf069-batch NE ls_batch-charg.
*                Update with new batch consumption
*                  update zabsf_pp069 from @( value #( base ls_pp_sf069 batch = ls_batch-charg ) ).

                  ls_pp_sf069-batch = ls_batch-charg.
                  UPDATE zabsf_pp069 FROM ls_pp_sf069.

                  COMMIT WORK AND WAIT.
                ELSE.
                  IF ls_pp_sf069 IS INITIAL.
*                  Add batch consumption for use in process
*                    insert zabsf_pp069 from table @( value #( ( werks = ls_batch-werks
*                                                                aufnr = ls_qty_conf-aufnr
*                                                                vornr = ls_qty_conf-vornr
*                                                                matnr = ls_batch-matnr
*                                                                batch = ls_batch-charg ) ) ).
                    ls_pp_sf069-werks = ls_batch-werks.
                    ls_pp_sf069-aufnr = ls_qty_conf-aufnr.
                    ls_pp_sf069-vornr = ls_qty_conf-vornr.
                    ls_pp_sf069-matnr = ls_batch-matnr.
                    ls_pp_sf069-batch = ls_batch-charg.

                    INSERT INTO zabsf_pp069 VALUES ls_pp_sf069.

                    COMMIT WORK AND WAIT.
                  ENDIF.
                ENDIF.
              ENDLOOP.
            ENDIF.
          ENDLOOP.


*            IF materialserial[] IS NOT INITIAL.
*              SELECT SINGLE autyp, auart, rsord, werks
*                FROM aufk
*                INTO @DATA(ls_aufk)
*                WHERE aufnr EQ @ls_qty_conf-aufnr.
**
*              LOOP AT lt_goodsmovements ASSIGNING FIELD-SYMBOL(<ls_goodsmvt>).
*                DATA(lt_sernos) =
*                  VALUE sernr_t(
*                    FOR s IN materialserial
*                    WHERE ( material EQ <ls_goodsmvt>-material )
*                    ( sernr = s-serial ) ).
*
*                CALL FUNCTION 'SERNR_ADD_TO_PP'
*                  EXPORTING
*                    profile  = VALUE #( lt_matserprof[ matnr = <ls_goodsmvt>-material ]-sernp OPTIONAL )
*                    material = <ls_goodsmvt>-material
*                    quantity = <ls_goodsmvt>-quantity
*                    ppaufnr  = ls_qty_conf-aufnr
*                    ppposnr  = ls_qty_conf-vornr
*                    ppautyp  = ls_aufk-autyp
*                    ppaufart = ls_aufk-auart
*                    pmrsord  = ls_aufk-rsord
*                    ppwerk   = ls_aufk-werks
*                  TABLES
*                    sernos   = lt_sernos.
*              ENDLOOP.
*            ENDIF.
*          ELSE.
          IF lt_goodsmovements[] IS NOT INITIAL.
            DATA lt_goodsmvt_serialnumber TYPE tab_bapi_goodsmvt_serialnumber.
            CLEAR lt_goodsmvt_serialnumber[].
            LOOP AT lt_goodsmovements ASSIGNING FIELD-SYMBOL(<ls_goodsmvt>).
              DATA(lv_matdoc_item) = CONV mblpo( sy-tabix ).

              CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
                EXPORTING
                  input  = <ls_goodsmvt>-material
                IMPORTING
                  output = lv_material.

              CHECK line_exists( materialserial[ material = lv_material ] ).
              APPEND VALUE #(
                  matdoc_itm = lv_matdoc_item
                  serialno   =  materialserial[ material = lv_material ]-serial
                ) TO lt_goodsmvt_serialnumber.
            ENDLOOP.

            DATA(ls_header) =
              VALUE bapi2017_gm_head_01(
                pstng_date    = sy-datum
                doc_date      = sy-datum
                gr_gi_slip_no = 3
                ref_doc_no    = ls_qty_conf-aufnr ).

            MODIFY lt_goodsmovements
              FROM VALUE #( reserv_no = ''
                            res_item = '' )
              TRANSPORTING reserv_no res_item
              WHERE reserv_no NE ''.

            IF line_exists( lt_goodsmovements[ move_type = '101' ] ).
              DATA(lv_goodsmvt_code) = CONV bapi2017_gm_code( '02' ).
            ELSE.
              lv_goodsmvt_code = '03'.
            ENDIF.

            CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
              EXPORTING
                goodsmvt_header       = ls_header
                goodsmvt_code         = lv_goodsmvt_code
              TABLES
                goodsmvt_item         = lt_goodsmovements
                goodsmvt_serialnumber = lt_goodsmvt_serialnumber
                return                = lt_return_tab3.

            IF NOT line_exists( lt_return_tab3[ type = if_msg_output=>msgtype_error ] ).
              CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
                EXPORTING
                  wait = abap_true.
            ELSE.
              APPEND LINES OF lt_return_tab3 TO return_tab.
            ENDIF.
          ENDIF.


*          ENDIF. "IF MATERIALSERIAL[] IS NOT INITIAL.
        ENDIF.

*        IF ( NOT lt_return_tab2[] IS INITIAL ).
***       Add Warnings/Errors
*          LOOP AT  lt_return_tab2 INTO DATA(ls_return2).
*            INSERT ls_return2 INTO return_tab INDEX 1.
*          ENDLOOP.
*        ENDIF.

      WHEN prdty_repetitive. "Repetitive
*      Not relevant for project
    ENDCASE.

  ELSE.
*  No data found in customizing table for Workcenter
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'E'
        msgno      = '022'
        msgv1      = arbpl
      CHANGING
        return_tab = return_tab.
  ENDIF.

*  DATA: it_timetickets    TYPE TABLE OF bapi_pp_timeticket,
*        it_timeticket_aux TYPE TABLE OF bapi_pp_timeticket,
*        detail_return     TYPE TABLE OF bapi_coru_return,
*        lt_mkal           TYPE TABLE OF mkal.
*
*  DATA: wa_timetickets    TYPE bapi_pp_timeticket,
*        wa_timeticket_aux TYPE bapi_pp_timeticket,
*        wa_detail_return  TYPE bapi_coru_return,
*        return            TYPE bapiret2,
*        ls_return         TYPE bapiret1,
*        ls_prdty          TYPE zabsf_pp_e_prdty,
*        wa_qty_conf       TYPE zabsf_pp_s_qty_conf,
*        ls_zabsf_pp017    TYPE zabsf_pp017,
*        ls_zabsf_pp035    TYPE zabsf_pp035,
*        ls_zabsf_pp057    TYPE zabsf_pp057,
*        ls_afru           TYPE afru,
*        i_source_value    TYPE i,
*        ls_conftype       TYPE zabsf_pp_e_conftype,
*        propose           TYPE bapi_pp_conf_prop,
*        ld_wareid         TYPE zabsf_pp_e_areaid,
*        ld_lmnga          TYPE lmnga,
*        ls_bflushflags    TYPE bapi_rm_flg,
*        ls_bflushdatagen  TYPE bapi_rm_datgen,
*        ls_bflushdatamts  TYPE bapi_rm_datstock,
*        confirmation      TYPE bapi_rm_datkey-confirmation,
*        ls_mkal           TYPE mkal,
*        ld_shiftid        TYPE zabsf_pp_e_shiftid,
*        lv_reverse        TYPE ru_lmnga,
*        lv_lmnga          TYPE ru_lmnga,
*        lv_rmnga          TYPE ru_rmnga,
*        lv_xmnga          TYPE ru_xmnga.
*
*  CLEAR: ls_bflushflags,
*         ls_bflushdatagen,
*         ls_conftype,
*         ls_prdty,
*         wa_qty_conf.
*
**  IF NOT lenum IS INITIAL.
**    DATA:  ls_imprime TYPE zpp10_imprime.
**    ls_imprime-uname = sy-uname.
**    ls_imprime-imprime = 'X'.
**    MODIFY zpp10_imprime FROM ls_imprime.
***    EXPORT flag_nao_imprime = flag_nao_imprime TO DATABASE indx(xy) FROM wa_indx CLIENT
***      sy-mandt
***      ID 'IMPRIME_PALETE'.
**
**  ENDIF.
*
*  TRANSLATE inputobj-oprid TO UPPER CASE. "CLS 16.06.2015
**Get shift witch operator is associated
*  SELECT SINGLE shiftid
*    FROM zabsf_pp052
*    INTO ld_shiftid
*   WHERE areaid EQ inputobj-areaid
*     AND oprid EQ inputobj-oprid.
*
*  IF sy-subrc NE 0.
**  Operator is not associated with shift
*    CALL METHOD zabsf_pp_cl_log=>add_message
*      EXPORTING
*        msgty      = 'E'
*        msgno      = '061'
*        msgv1      = inputobj-oprid
*      CHANGING
*        return_tab = return_tab.
*
*    EXIT.
*  ENDIF.
*
**Get process type
*  SELECT SINGLE prdty
*    FROM zabsf_pp013
*    INTO ls_prdty
*   WHERE areaid EQ areaid
*     AND werks  EQ werks
*     AND arbpl  EQ arbpl.
*
*  IF sy-subrc EQ 0.
*    CASE ls_prdty.
*      WHEN prdty_discret. "Discret
*        REFRESH: it_timeticket_aux,
*                 it_timetickets,
*                 detail_return.
*
*        CLEAR: wa_timeticket_aux,
*               wa_timetickets,
*               propose.
*
**      Check order type
*        IF tipord EQ 'N'.
**         Propose data for confirmation times and quantity
*          propose-activity = 'X'.
*        ELSE.
**         Propose data for confirmation quantity
*          propose-quantity = 'X'.
*        ENDIF.
*
*        LOOP AT qty_conf_tab INTO wa_qty_conf.
**        Insert data for confirmation
*          wa_timetickets-orderid = wa_qty_conf-aufnr.
*          wa_timetickets-operation = wa_qty_conf-vornr.
*
**        Check stock for material
*          IF check_stock IS NOT INITIAL.
*            CLEAR: ld_wareid,
*                   ld_lmnga.
*
*            SELECT SINGLE wareid
*              FROM zabsf_pp039
*              INTO ld_wareid
*             WHERE areaid EQ inputobj-areaid
*               AND werks EQ inputobj-werks
*               AND ware_next EQ space.
*
*            IF sy-subrc EQ 0.
*              SELECT SINGLE lmnga
*                FROM zabsf_pp035
*                INTO ld_lmnga
*               WHERE wareid EQ ld_wareid
*                 AND matnr  EQ wa_qty_conf-matnr.
*
*              IF wa_qty_conf-lmnga GT ld_lmnga.
*                CALL METHOD zabsf_pp_cl_log=>add_message
*                  EXPORTING
*                    msgty      = 'E'
*                    msgno      = '042'
*                    msgv1      = ld_wareid
*                    msgv2      = ld_lmnga
*                  CHANGING
*                    return_tab = return_tab.
*
*                EXIT.
*              ELSE.
*                wa_timetickets-yield = wa_qty_conf-lmnga.
*              ENDIF.
*            ENDIF.
*          ELSE.
*            wa_timetickets-yield = wa_qty_conf-lmnga.
*          ENDIF.
*
*          APPEND wa_timetickets TO it_timeticket_aux.
*
*          CALL FUNCTION 'BAPI_PRODORDCONF_GET_TT_PROP'
*            EXPORTING
*              propose       = propose
*            IMPORTING
*              return        = ls_return
*            TABLES
*              timetickets   = it_timeticket_aux
*              detail_return = detail_return.
*        ENDLOOP.
*
**      Create two lines in timeticket (one for quantity and another for times)
*        CLEAR wa_timetickets.
*
*        LOOP AT it_timeticket_aux INTO wa_timeticket_aux.
**        Line for quantity
*          wa_timetickets-conf_no = wa_timeticket_aux-conf_no.
*          wa_timetickets-orderid = wa_timeticket_aux-orderid.
*          wa_timetickets-operation = wa_timeticket_aux-operation.
*          wa_timetickets-sequence = wa_timeticket_aux-sequence.
*          wa_timetickets-postg_date = wa_timeticket_aux-postg_date.
*          wa_timetickets-plant = wa_timeticket_aux-plant.
*          wa_timetickets-kaptprog = ld_shiftid.
*
*          READ TABLE qty_conf_tab INTO wa_qty_conf WITH KEY aufnr = wa_timeticket_aux-orderid
*                                                            vornr = wa_timeticket_aux-operation.
*
*          IF sy-subrc EQ 0.
*            wa_timetickets-yield = wa_qty_conf-lmnga.
*          ENDIF.
*
*          wa_timetickets-conf_quan_unit = wa_timeticket_aux-conf_quan_unit.
*          wa_timetickets-conf_quan_unit_iso = wa_timeticket_aux-conf_quan_unit_iso.
*          wa_timetickets-ex_created_by = inputobj-oprid.
*
*          APPEND wa_timetickets TO it_timetickets.
*
*          IF tipord EQ 'N'.
**          Line for times
*            MOVE-CORRESPONDING wa_timeticket_aux TO wa_timetickets.
*            wa_timetickets-ex_created_by = inputobj-oprid.
*            wa_timetickets-kaptprog = ld_shiftid.
*
*            CLEAR: wa_timetickets-yield,
*                   wa_timetickets-conf_quan_unit,
*                   wa_timetickets-conf_quan_unit_iso.
*
*            APPEND wa_timetickets TO it_timetickets.
*          ENDIF.
*        ENDLOOP.
*
*        IF it_timetickets[] IS NOT INITIAL.
**      Create confirmation
*          CALL FUNCTION 'BAPI_PRODORDCONF_CREATE_TT'
*            IMPORTING
*              return        = ls_return
*            TABLES
*              timetickets   = it_timetickets
*              detail_return = detail_return.
*
*          IF ls_return IS INITIAL.
*            CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
*              EXPORTING
*                wait = 'X'.
*          ENDIF.
*        ENDIF.
*
*        CLEAR: ls_afru,
*               ls_zabsf_pp017,
*               i_source_value.
*
*        DELETE ADJACENT DUPLICATES FROM detail_return.
*
**      Details of operation
*        LOOP AT detail_return INTO wa_detail_return.
*          CLEAR return.
*
*          return-type = wa_detail_return-type.
*          return-id = wa_detail_return-id.
*          return-number = wa_detail_return-number.
*          return-message = wa_detail_return-message.
*          return-message_v1 = wa_detail_return-message_v1.
*          return-message_v2 = wa_detail_return-message_v2.
*          return-message_v3 = wa_detail_return-message_v3.
*          return-message_v4 = wa_detail_return-message_v4.
*
*          APPEND return TO return_tab.
*
*          IF wa_detail_return-type EQ 'I' OR wa_detail_return-type EQ 'S'.
*            CLEAR wa_qty_conf.
*
*            READ TABLE qty_conf_tab INTO wa_qty_conf WITH KEY aufnr = wa_detail_return-message_v1.
*
**          Get value of confirmation
*            SELECT SINGLE *
*              FROM afru
*              INTO CORRESPONDING FIELDS OF ls_afru
*              WHERE rueck EQ wa_detail_return-conf_no
*                AND rmzhl EQ wa_detail_return-conf_cnt
*                AND aufnr EQ wa_qty_conf-aufnr.
*
*            IF sy-subrc EQ 0.
**            Get value in Database
*              SELECT SINGLE *
*                FROM zabsf_pp017
*                INTO CORRESPONDING FIELDS OF ls_zabsf_pp017
*               WHERE aufnr EQ wa_qty_conf-aufnr
*                 AND matnr EQ wa_qty_conf-matnr
*                 AND vornr EQ wa_qty_conf-vornr.
*
*              IF sy-subrc EQ 0.
*                CLEAR: lv_reverse,
*                       lv_lmnga,
*                       lv_rmnga,
*                       lv_xmnga.
*
**              PAP - START - 01.04.2015 - Get sum of Reversed
**              Reverse quantity
*                SELECT SUM( lmnga )
*                  FROM afru
*                  INTO lv_reverse
*                 WHERE rueck EQ wa_detail_return-conf_no
*                   AND aufnr EQ wa_qty_conf-aufnr
*                   AND stokz NE space
*                   AND stzhl NE space.
*
**              Confirmed quantity
*                SELECT SUM( lmnga ) SUM( rmnga ) SUM( xmnga )
*                  FROM afru
*                  INTO (lv_lmnga, lv_rmnga, lv_xmnga)
*                 WHERE rueck EQ wa_detail_return-conf_no
*                   AND aufnr EQ wa_qty_conf-aufnr
*                   AND stokz EQ space
*                   AND stzhl EQ space.
**                PAP - START - 01.04.2015 - Get sum of Reversed
*
*                ADD ls_afru-lmnga TO ls_zabsf_pp017-lmnga.
*
**                ls_ZABSF_PP017-missingqty = ls_ZABSF_PP017-gamng - ls_ZABSF_PP017-lmnga.
*                ls_zabsf_pp017-missingqty = ls_zabsf_pp017-gamng - lv_lmnga - lv_rmnga - lv_xmnga - lv_reverse.
*                i_source_value = ls_zabsf_pp017-gamng.
*
**              Convert Unit
*                CALL METHOD me->convert_unit
*                  EXPORTING
*                    matnr        = ls_zabsf_pp017-matnr
*                    source_value = i_source_value
*                    source_unit  = ls_zabsf_pp017-gmein
*                    lmnga        = ls_afru-lmnga
*                  CHANGING
*                    prdqty_box   = ls_zabsf_pp017-prdqty_box
*                    boxqty       = ls_zabsf_pp017-boxqty.
*
*                ADD ls_afru-lmnga TO ls_zabsf_pp017-prdqty_box.
*
**BEGIN ADR - 16/11/2022 - Add the "equipment" field to zabsf_pp017 table.
*                ls_zabsf_pp017-equipment = iv_equipment.
**END ADR.
**              Update database
*                UPDATE zabsf_pp017 FROM ls_zabsf_pp017.
*              ENDIF.
*
*              IF check_stock IS NOT INITIAL.
*                CLEAR ls_zabsf_pp035.
*
**              Get information of warehouse
*                SELECT SINGLE *
*                 FROM zabsf_pp035
*                 INTO ls_zabsf_pp035
*                WHERE wareid EQ ld_wareid
*                  AND matnr  EQ wa_qty_conf-matnr.
*
*                SUBTRACT ls_afru-lmnga FROM ls_zabsf_pp035-lmnga.
*
*                UPDATE zabsf_pp035 FROM ls_zabsf_pp035.
*              ENDIF.
*            ENDIF.
*
**         Transfer quantity to warehouse virtual
*            IF wa_qty_conf-wareid IS NOT INITIAL.
*              CLEAR ls_zabsf_pp035.
*
**            Check if exist quantity saved
*              SELECT SINGLE *
*                FROM zabsf_pp035
*                INTO CORRESPONDING FIELDS OF ls_zabsf_pp035
*                WHERE areaid EQ inputobj-areaid
*                  AND wareid EQ wa_qty_conf-wareid
*                  AND matnr  EQ wa_qty_conf-matnr.
*
*              IF sy-subrc EQ 0.
*                ADD ls_afru-lmnga TO ls_zabsf_pp035-stock.
*                UPDATE zabsf_pp035 FROM ls_zabsf_pp035.
*              ELSE.
*                ls_zabsf_pp035-areaid = inputobj-areaid.
*                ls_zabsf_pp035-wareid = wa_qty_conf-wareid.
*                ls_zabsf_pp035-matnr = wa_qty_conf-matnr.
*                ls_zabsf_pp035-stock = ls_afru-lmnga.
*                ls_zabsf_pp035-gmein = ls_afru-gmein.
*
*                INSERT zabsf_pp035 FROM ls_zabsf_pp035.
*              ENDIF.
*
*              IF ls_afru-lmnga NE 0.
**            Saved regist of quantity good
*                CLEAR ls_zabsf_pp057.
*
*                ls_zabsf_pp057-areaid = inputobj-areaid.
*                ls_zabsf_pp057-wareid = wa_qty_conf-wareid.
*                ls_zabsf_pp057-matnr = wa_qty_conf-matnr.
*                ls_zabsf_pp057-data = refdt.
*                ls_zabsf_pp057-time = sy-uzeit.
*                ls_zabsf_pp057-oprid = inputobj-oprid.
*                ls_zabsf_pp057-lmnga = ls_afru-lmnga.
*                ls_zabsf_pp057-gmein = ls_afru-gmein.
*
*                INSERT zabsf_pp057 FROM ls_zabsf_pp057.
*
*                IF sy-subrc EQ 0.
**              Operation completed successfully
*                  CALL METHOD zabsf_pp_cl_log=>add_message
*                    EXPORTING
*                      msgty      = 'S'
*                      msgno      = '013'
*                    CHANGING
*                      return_tab = return_tab.
*                ELSE.
**              Operation not completed successfully
*                  CALL METHOD zabsf_pp_cl_log=>add_message
*                    EXPORTING
*                      msgty      = 'E'
*                      msgno      = '012'
*                    CHANGING
*                      return_tab = return_tab.
*
*                  CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
*                ENDIF.
*              ENDIF.
*            ENDIF.
*          ENDIF.
*        ENDLOOP.
*      WHEN prdty_repetitive. "Repetitive
*
***      Control parameter for confirmation
***      Backflush type
**        ls_bflushflags-bckfltype = '02'.
***      Scope of activity backflush
**        ls_bflushflags-activities_type = '1'.
***      Scope of GI posting
**        ls_bflushflags-components_type = '1'.
**
***      Production Versions of Material
**        SELECT *
**          FROM mkal
**          INTO CORRESPONDING FIELDS OF TABLE lt_mkal
**           FOR ALL ENTRIES IN qty_conf_tab
**         WHERE matnr EQ qty_conf_tab-matnr
**           AND werks EQ inputobj-werks.
**
***      Backflush Parameters Independent of Process
**        LOOP AT qty_conf_tab INTO wa_qty_conf.
**          CLEAR: ls_bflushdatagen,
**                 ls_mkal,
**                 confirmation,
**                 return.
**
***        Material
**          ls_bflushdatagen-materialnr = wa_qty_conf-matnr.
***        Plant
**          ls_bflushdatagen-prodplant = inputobj-werks.
***        Planning plant
**          ls_bflushdatagen-planplant = inputobj-werks.
**
**          READ TABLE lt_mkal INTO ls_mkal WITH KEY matnr = wa_qty_conf-matnr.
**
**          IF sy-subrc EQ 0.
***          Storage Location
**            ls_bflushdatagen-storageloc = ls_mkal-alort.
***          Production Version
**            ls_bflushdatagen-prodversion = ls_mkal-verid.
***          Production line
**            ls_bflushdatagen-prodline = ls_mkal-mdv01.
**          ENDIF.
**
***        Posting date
**          ls_bflushdatagen-postdate = sy-datum.
***        Document date
**          ls_bflushdatagen-docdate = sy-datum.
***        Quantity in Unit of Entry
**          ls_bflushdatagen-backflquant = wa_qty_conf-lmnga.
***        Unit of measure
**          ls_bflushdatagen-unitofmeasure = wa_qty_conf-gmein.
**
***        Report point
**          ls_bflushdatamts-reppoint = wa_qty_conf-vornr.
**
**          CALL FUNCTION 'BAPI_REPMANCONF1_CREATE_MTS'
**            EXPORTING
**              bflushflags   = ls_bflushflags
**              bflushdatagen = ls_bflushdatagen
**              bflushdatamts = ls_bflushdatamts
**            IMPORTING
**              confirmation  = confirmation
**              return        = return.
**
**          IF return IS INITIAL AND confirmation IS NOT INITIAL.
**            CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
**              EXPORTING
**                wait = 'X'.
**          ELSE.
**            APPEND return TO return_tab.
**          ENDIF.
**        ENDLOOP.
**
**        DELETE ADJACENT DUPLICATES FROM return_tab.
*    ENDCASE.
*  ELSE.
**  No data found in customizing table for Workcenter
*    CALL METHOD zabsf_pp_cl_log=>add_message
*      EXPORTING
*        msgty      = 'E'
*        msgno      = '022'
*        msgv1      = arbpl
*      CHANGING
*        return_tab = return_tab.
*  ENDIF.
ENDMETHOD.


METHOD set_quantity_ord_rpack.

*Internal tables
  DATA: lt_qty_conf                TYPE zabsf_pp_t_qty_conf,
        lt_timeticket_prop         TYPE TABLE OF bapi_pp_timeticket,
        lt_goodsmovements_prop     TYPE TABLE OF bapi2017_gm_item_create,
        lt_link_conf_goodsmov_prop TYPE TABLE OF bapi_link_conf_goodsmov,
        lt_timetickets             TYPE TABLE OF bapi_pp_timeticket,
        lt_goodsmovements          TYPE TABLE OF bapi2017_gm_item_create,
        lt_link_conf_goodsmov      TYPE TABLE OF bapi_link_conf_goodsmov,
        lt_detail_return           TYPE TABLE OF bapi_coru_return,
        lt_create_batch            TYPE zabsf_pp_t_goodmovements,
        lt_goodsmovements_new      TYPE TABLE OF bapi2017_gm_item_create,
        lt_return_tab2             TYPE bapiret2_t,
        lt_ret_tab_scrap           TYPE bapiret2_t.

*Structures
  DATA: ls_propose            TYPE bapi_pp_conf_prop,
        ls_timeticket_prop    TYPE bapi_pp_timeticket,
        ls_timetickets        TYPE bapi_pp_timeticket,
        ls_goodsmovements     TYPE bapi2017_gm_item_create,
        ls_link_conf_goodsmov TYPE bapi_link_conf_goodsmov,
        ls_return             TYPE bapiret1,
        ls_return_conf        TYPE bapiret2,
        ls_conf_data          TYPE zabsf_pp_s_conf_adit_data,
        ls_create_batch       TYPE zabsf_pp_s_goodmovements,
        ls_conf_tab           TYPE zabsf_pp_s_confirmation,
        ls_goodsmovements_new TYPE bapi2017_gm_item_create,
        ls_batch_cons         TYPE zabsf_pp_s_batch_consumption.

*Reference
  DATA: lref_sf_prdord TYPE REF TO zabsf_pp_cl_prdord.

*Variables
  DATA: l_source_value TYPE i,
        l_conf_no      TYPE co_rueck,
        l_conf_cnt     TYPE co_rmzhl,
        l_new_batch    TYPE charg_d,
        l_langu        TYPE spras,
        l_flag         TYPE flag,
        l_wait_cancel  TYPE i,
        l_stock        TYPE labst,
        l_entry_qnt    TYPE	erfmg,
        l_index        TYPE sy-tabix,
        l_total_cons   TYPE erfmg,
        l_done.

*Constants
  CONSTANTS: c_101         TYPE bwart          VALUE '101', "GR goods receipt
             c_261         TYPE bwart          VALUE '261', "GI for order
             c_mtart_verp  TYPE mtart          VALUE 'VERP', "Material type - Packing
             c_inspection  TYPE aufart         VALUE 'ZINS',
             c_wait_cancel TYPE zabsf_pp_e_parid VALUE 'WAIT_CANCEL'.


*Set language local for user
  l_langu = sy-langu.

  SET LOCALE LANGUAGE l_langu.

*Translate to upper case
  TRANSLATE inputobj-oprid TO UPPER CASE.

  IF backoffice IS INITIAL.
*  Get shift witch operator is associated
    SELECT SINGLE shiftid
      FROM zabsf_pp052
      INTO (@DATA(l_shiftid))
     WHERE areaid EQ @inputobj-areaid
       AND oprid  EQ @inputobj-oprid.

    IF sy-subrc NE 0.
*    Operator is not associated with shift
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
*  Shift ID
    l_shiftid = shiftid.
  ENDIF.

*Check lenght of time
  DATA(l_lengh) = strlen( inputobj-timeconf ).

  IF l_lengh LT 6.
    CONCATENATE '0' inputobj-timeconf INTO DATA(l_time).
  ELSE.
    l_time = inputobj-timeconf.
  ENDIF.

*Get process type
  SELECT SINGLE prdty
    FROM zabsf_pp013
    INTO (@DATA(l_prdty))
   WHERE areaid EQ @areaid
     AND werks  EQ @werks
     AND arbpl  EQ @arbpl.

  IF sy-subrc EQ 0.
    CASE l_prdty.
      WHEN prdty_discret. "Discret
        REFRESH: lt_timeticket_prop,
                 lt_goodsmovements_prop,
                 lt_link_conf_goodsmov_prop,
                 lt_timetickets,
                 lt_detail_return.

        CLEAR: ls_propose.

*      Propose data for confirmation quantity
        ls_propose-goodsmovement = abap_true.

*      To change
        lt_qty_conf[] = qty_conf_tab[].

        LOOP AT lt_qty_conf ASSIGNING FIELD-SYMBOL(<fs_qty_conf>).
          IF ( <fs_qty_conf>-lmnga IS INITIAL ).
*          Not EXECUTE goods quantity
            DATA(l_not_exec) = abap_true.
            EXIT.
          ENDIF.
          CLEAR ls_timeticket_prop.

*        Insert data for confirmation
*        Production Order
          ls_timeticket_prop-orderid = <fs_qty_conf>-aufnr.
*        Production Order Operation
          ls_timeticket_prop-operation = <fs_qty_conf>-vornr.
*        Production Order Quantity
          CALL METHOD me->calculate_qty_absolute_delta
            EXPORTING
              arbpl       = arbpl
              aufnr       = <fs_qty_conf>-aufnr
              vornr       = <fs_qty_conf>-vornr
              matnr       = <fs_qty_conf>-matnr
              lmnga       = <fs_qty_conf>-lmnga
            IMPORTING
              confirm_qty = ls_timeticket_prop-yield
              return_tab  = return_tab.

          IF return_tab[] IS NOT INITIAL.
            DATA(l_error) = abap_true.
            EXIT.
          ENDIF.

          <fs_qty_conf>-lmnga = ls_timeticket_prop-yield.

          APPEND ls_timeticket_prop TO lt_timeticket_prop.

*        Propose data to confirmation
          CALL FUNCTION 'BAPI_PRODORDCONF_GET_TT_PROP'
            EXPORTING
              propose            = ls_propose
            IMPORTING
              return             = ls_return
            TABLES
              timetickets        = lt_timeticket_prop
              goodsmovements     = lt_goodsmovements_prop
              link_conf_goodsmov = lt_link_conf_goodsmov_prop
              detail_return      = lt_detail_return.

          IF ls_return IS NOT INITIAL.
*          Message error
            APPEND ls_return TO return_tab.

            LOOP AT lt_detail_return INTO DATA(ls_detail_return).
              IF ( ls_detail_return-type NE 'I' AND ls_detail_return-type NE 'S' ).
                CLEAR ls_return_conf.

                ls_return_conf-type = ls_detail_return-type.
                ls_return_conf-id = ls_detail_return-id.
                ls_return_conf-number = ls_detail_return-number.
                ls_return_conf-message = ls_detail_return-message.
                ls_return_conf-message_v1 = ls_detail_return-message_v1.
                ls_return_conf-message_v2 = ls_detail_return-message_v2.
                ls_return_conf-message_v3 = ls_detail_return-message_v3.
                ls_return_conf-message_v4 = ls_detail_return-message_v4.

                APPEND ls_return_conf TO return_tab.
              ENDIF.
            ENDLOOP.

*          If exist error exit program
            l_error = abap_true.
          ENDIF.
        ENDLOOP.

*      Exit if exist errors
        IF l_error IS NOT INITIAL.
          EXIT.
        ENDIF.


        IF l_not_exec IS INITIAL.
          CLEAR ls_timeticket_prop.

*      Create data to confirmation
          IF lt_timeticket_prop[] IS NOT INITIAL.
            LOOP AT lt_timeticket_prop INTO ls_timeticket_prop.
              CLEAR ls_timetickets.

*          Line for quantity
              ls_timetickets-conf_no = ls_timeticket_prop-conf_no.
              ls_timetickets-orderid = ls_timeticket_prop-orderid.
              ls_timetickets-operation = ls_timeticket_prop-operation.
              ls_timetickets-sequence = ls_timeticket_prop-sequence.

*          Record date
              IF inputobj-dateconf IS NOT INITIAL.
                ls_timetickets-exec_start_date = ls_timetickets-exec_fin_date = inputobj-dateconf.
                ls_timetickets-postg_date = inputobj-dateconf.
              ELSE.
                ls_timetickets-postg_date = ls_timeticket_prop-postg_date.
              ENDIF.

*          Record time
              IF l_time IS NOT INITIAL.
                ls_timetickets-exec_start_time = ls_timetickets-exec_fin_time = l_time.
              ENDIF.

              ls_timetickets-plant = ls_timeticket_prop-plant.
              ls_timetickets-kaptprog = l_shiftid.

*          Counter Number of employees in Production Order
              SELECT COUNT( * )
                FROM zabsf_pp014
                INTO (@DATA(l_nr_operator))
               WHERE arbpl  EQ @arbpl
                 AND aufnr  EQ @ls_timeticket_prop-orderid
                 AND vornr  EQ @ls_timeticket_prop-operation
                 AND tipord EQ @tipord
                 AND status EQ 'A'.

              IF l_nr_operator IS NOT INITIAL.
*            Number of employees
                ls_timetickets-no_of_employee = l_nr_operator.
              ENDIF.

*          Get good quantity to confirm
              READ TABLE lt_qty_conf INTO DATA(ls_qty_conf) WITH KEY aufnr = ls_timeticket_prop-orderid
                                                                     vornr = ls_timeticket_prop-operation.

              IF sy-subrc EQ 0.
*            Good quantity
                ls_timetickets-yield = ls_qty_conf-lmnga.
              ENDIF.

              ls_timetickets-conf_quan_unit = ls_timeticket_prop-conf_quan_unit.
              ls_timetickets-conf_quan_unit_iso = ls_timeticket_prop-conf_quan_unit_iso.
              ls_timetickets-ex_created_by = inputobj-oprid.

              APPEND ls_timetickets TO lt_timetickets.
            ENDLOOP.
          ENDIF.


***********************************************************
*      Create data to goods movements
          IF lt_goodsmovements_prop[] IS NOT INITIAL.
*        Read production order and operation
            READ TABLE lt_qty_conf INTO ls_qty_conf INDEX 1.

            IF sy-subrc EQ 0.
*          Production order
              DATA(l_aufnr) = ls_qty_conf-aufnr.
*           Production order operation
              DATA(l_vornr) = ls_qty_conf-vornr.
            ENDIF.


*        Get batches consumption
            SELECT *
              FROM zabsf_pp077
              INTO TABLE @DATA(lt_pp_sf077)
             WHERE werks EQ @inputobj-werks
               AND aufnr EQ @l_aufnr
               AND vornr EQ @l_vornr
             ORDER BY indice ASCENDING.

*  Sort by (24.05.2017 Elastomer wants order by picking entry)
            SORT lt_pp_sf077 BY indice ASCENDING.
**        Sort by
*            SORT lt_pp_sf077 BY batch ASCENDING.


            REFRESH lt_goodsmovements_new.
            CLEAR: l_total_cons, l_done.
*        Eliminate lines '261' with batch management and copy table sf077
            LOOP AT lt_goodsmovements_prop INTO DATA(ls_goodsmovs_prop).

*         Batch conversion
              CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                EXPORTING
                  input  = ls_goodsmovs_prop-batch
                IMPORTING
                  output = ls_goodsmovs_prop-batch.

              IF ( ls_goodsmovs_prop-move_type = c_101 ).

*              Get batch production
                SELECT SINGLE batch
                  FROM zabsf_pp066
                  INTO (@DATA(l_batch))
                 WHERE werks EQ @inputobj-werks
                   AND aufnr EQ @l_aufnr
                   AND vornr EQ @l_vornr.
                IF ( sy-subrc EQ 0 ).
*                Batch Production
                  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                    EXPORTING
                      input  = l_batch
                    IMPORTING
                      output = ls_goodsmovs_prop-batch.

*                 Old batch
                  DATA(l_old_batch) = ls_goodsmovs_prop-batch.
                ENDIF.

**           Save total quantity
                DATA(l_total) = ls_goodsmovs_prop-entry_qnt.
                MOVE ls_goodsmovs_prop TO ls_goodsmovements_new.
                APPEND ls_goodsmovements_new TO lt_goodsmovements_new.
                CONTINUE.
              ENDIF.

**           Batch management
              SELECT SINGLE xchpf
                FROM mara
                INTO @DATA(l_xchpf)
                WHERE matnr = @ls_goodsmovs_prop-material.

              IF ( l_xchpf = 'X' ).

                CHECK l_done = space.
                DELETE TABLE lt_goodsmovements_prop FROM ls_goodsmovs_prop.
                IF ( sy-subrc = 0 ).

                  LOOP AT lt_pp_sf077 INTO DATA(ls_pp_sf077).

                    CLEAR ls_goodsmovements_new.
**          Get Available stock for batch in storage bin
                    SELECT SINGLE verme
                      FROM lqua
                      INTO (@DATA(l_verme))
                     WHERE matnr EQ @ls_pp_sf077-matnr
                       AND werks EQ @ls_pp_sf077-werks
                       AND charg EQ @ls_pp_sf077-batch
                       AND EXISTS ( SELECT crhd~objid
                                      FROM crhd AS crhd
                                     INNER JOIN pkhd AS pkhd
                                        ON crhd~werks EQ pkhd~werks
                                       AND crhd~prvbe EQ pkhd~prvbe
                                     WHERE pkhd~lgnum EQ lqua~lgnum
                                       AND pkhd~lgtyp EQ lqua~lgtyp
                                       AND pkhd~lgpla EQ lqua~lgpla
                                       AND pkhd~matnr EQ lqua~matnr
                                       AND pkhd~werks EQ lqua~werks
                                       AND crhd~arbpl EQ @arbpl ).

                    IF ( l_verme >= l_total ).
                      l_total_cons = l_total_cons + l_verme.
                      MOVE-CORRESPONDING ls_pp_sf077 TO ls_goodsmovs_prop.
                      ls_goodsmovs_prop-material = ls_pp_sf077-matnr.
*                      ls_goodsmovs_prop-material_long = ls_pp_sf077-matnr.
                      ls_goodsmovs_prop-entry_qnt = l_total.
                      ls_goodsmovs_prop-reserv_no = ls_pp_sf077-rsnum.
                      ls_goodsmovs_prop-res_item = ls_pp_sf077-rspos.
                      MOVE ls_goodsmovs_prop TO ls_goodsmovements_new.
                      APPEND ls_goodsmovements_new TO lt_goodsmovements_new.
                      l_done = 'X'.
                      EXIT.
                    ELSE.
                      l_total_cons = l_total_cons + l_verme.
                      l_total = l_total - l_verme.
                      MOVE-CORRESPONDING ls_pp_sf077 TO ls_goodsmovs_prop.
                      ls_goodsmovs_prop-material = ls_pp_sf077-matnr.
*                      ls_goodsmovs_prop-material_long = ls_pp_sf077-matnr.
                      ls_goodsmovs_prop-entry_qnt = l_verme.
                      ls_goodsmovs_prop-reserv_no = ls_pp_sf077-rsnum.
                      ls_goodsmovs_prop-res_item = ls_pp_sf077-rspos.
                      MOVE ls_goodsmovs_prop TO ls_goodsmovements_new.
                      APPEND ls_goodsmovements_new TO lt_goodsmovements_new.
                      CONTINUE.
                    ENDIF.
                  ENDLOOP.
                ENDIF.
              ELSE.
                CLEAR ls_goodsmovements_new.
                MOVE ls_goodsmovs_prop TO ls_goodsmovements_new.
                APPEND ls_goodsmovements_new TO lt_goodsmovements_new.
              ENDIF.
            ENDLOOP.

            IF ( NOT lt_goodsmovements_new[] IS INITIAL ).
              REFRESH lt_goodsmovements_prop.
              LOOP AT lt_goodsmovements_new INTO ls_goodsmovements_new.
                APPEND ls_goodsmovements_new TO lt_goodsmovements_prop.
              ENDLOOP.
            ENDIF.

            IF ( l_total_cons < l_total ).
*          Warning: No stock available.
              CALL METHOD zabsf_pp_cl_log=>add_message
                EXPORTING
                  msgty      = 'E'
                  msgno      = '096'
                CHANGING
                  return_tab = return_tab.

              EXIT.
            ENDIF.

**      Refresh Link Table
            REFRESH lt_link_conf_goodsmov_prop.
            LOOP AT lt_goodsmovements_prop INTO DATA(ls_goods_prop).
              DATA(l_tabix) = sy-tabix.
              CLEAR ls_link_conf_goodsmov.
              ls_link_conf_goodsmov-index_confirm = 1.
              ls_link_conf_goodsmov-index_goodsmov = l_tabix.
              APPEND ls_link_conf_goodsmov TO lt_link_conf_goodsmov_prop.
            ENDLOOP.


            LOOP AT lt_goodsmovements_prop INTO DATA(ls_goodsmovements_prop).
              CLEAR ls_goodsmovements.
*          Move same fields to output table
              MOVE-CORRESPONDING ls_goodsmovements_prop TO ls_goodsmovements.
*          Append to output table
              APPEND ls_goodsmovements TO lt_goodsmovements.
            ENDLOOP.

          ENDIF.
***************************************************************


          IF backoffice IS INITIAL AND supervisor IS INITIAL.
*        Check validation for Consumption batchs
            CALL METHOD me->check_available_stock
              EXPORTING
                areaid             = areaid
                arbpl              = arbpl
                aufnr              = l_aufnr
                goodsmovements_tab = lt_goodsmovements
              IMPORTING
                msg_error          = l_error
*               return_tab         = return_tab
                return_tab         = lt_return_tab2.

*        Exit if exist errors
            IF l_error IS NOT INITIAL.
**         Send error msg to Shopfloor
              MOVE lt_return_tab2[] TO return_tab[].
              EXIT.
            ENDIF.
          ENDIF.

*      Link to confirmation of good movement
          IF lt_link_conf_goodsmov_prop[] IS NOT INITIAL.
            LOOP AT lt_link_conf_goodsmov_prop INTO DATA(ls_link_conf_goodsmov_prop).
*          Move same fields to output table
              MOVE-CORRESPONDING ls_link_conf_goodsmov_prop TO ls_link_conf_goodsmov.

*          Append to output table
              APPEND ls_link_conf_goodsmov TO lt_link_conf_goodsmov.
            ENDLOOP.
          ENDIF.


          IF lt_timetickets[] IS NOT INITIAL. "AND lt_goodsmovements[] IS NOT INITIAL.
            REFRESH lt_create_batch.
            CLEAR ls_goodsmovements.

            LOOP AT lt_goodsmovements INTO ls_goodsmovements.
              CLEAR ls_create_batch.

*          Get Routing number for operations and General counter for order
              SELECT SINGLE afko~aufpl, afvc~aplzl
                FROM afko AS afko
               INNER JOIN afvc AS afvc
                  ON afvc~aufpl EQ afko~aufpl
               WHERE afko~aufnr EQ @l_aufnr
                 AND afvc~vornr EQ @l_vornr
                INTO (@DATA(l_aufpl), @DATA(l_aplzl)).

*          Move data to create batch or to validate
              ls_create_batch-aufnr = l_aufnr.
              ls_create_batch-vornr = l_vornr.
              ls_create_batch-aufpl = l_aufpl.
              ls_create_batch-aplzl = l_aplzl.
              ls_create_batch-werks = ls_goodsmovements-plant.
              ls_create_batch-matnr = ls_goodsmovements-material.
              ls_create_batch-lgort = ls_goodsmovements-stge_loc.
              ls_create_batch-charg = ls_goodsmovements-batch.
              ls_create_batch-bwart = ls_goodsmovements-move_type.
              ls_create_batch-erfmg = ls_goodsmovements-entry_qnt.
              ls_create_batch-erfme = ls_goodsmovements-entry_uom.
              ls_create_batch-bwtar = ls_goodsmovements-val_type.

              MOVE-CORRESPONDING ls_goodsmovements TO ls_create_batch.

              ls_create_batch-hsdat = inputobj-dateconf.

              APPEND ls_create_batch TO lt_create_batch.
            ENDLOOP.


*        Create batch
            CALL FUNCTION 'Z_PP02_DATA_TO_CREATE_BATCH'
              EXPORTING
                iv_first_cycle   = first_cycle
                iv_shiftid       = l_shiftid
                is_inputobject   = inputobj
                iv_refdt         = refdt
                it_goodmovements = lt_create_batch
              IMPORTING
                ev_new_batch     = l_new_batch
              TABLES
                return_tab       = return_tab.

            IF l_new_batch IS NOT INITIAL.
              LOOP AT lt_goodsmovements ASSIGNING FIELD-SYMBOL(<fs_goodmovements>) WHERE move_type EQ c_101.
                <fs_goodmovements>-batch = l_new_batch.
              ENDLOOP.

*          Packaging consumption - boxes and bags
              LOOP AT lt_goodsmovements ASSIGNING <fs_goodmovements> WHERE move_type EQ c_261.
*            Check material with material group VERP
                SELECT SINGLE mtart
                  FROM mara
                  INTO (@DATA(l_mtart))
                 WHERE matnr EQ @<fs_goodmovements>-material.

                IF l_mtart EQ c_mtart_verp.
                  <fs_goodmovements>-entry_qnt = 1.
                ENDIF.
              ENDLOOP.
            ELSE.
*          Packaging consumption - boxes and bags
              LOOP AT lt_goodsmovements ASSIGNING <fs_goodmovements> WHERE move_type EQ c_261.
                CLEAR l_mtart.

*            Check material with material group VERP
                SELECT SINGLE mtart
                  FROM mara
                  INTO @l_mtart
                 WHERE matnr EQ @<fs_goodmovements>-material.

                IF l_mtart EQ c_mtart_verp.
                  <fs_goodmovements>-entry_qnt = 0.
                ENDIF.
              ENDLOOP.
            ENDIF.

            CLEAR l_error.

*        Check if exist errors
            LOOP AT return_tab INTO DATA(ls_return_tab) WHERE type NE 'S'
                                                          AND type NE 'I'
                                                          AND type NE 'W'.
              l_error = abap_true.
              EXIT.
            ENDLOOP.

            IF l_error IS NOT INITIAL.
              EXIT.
            ENDIF.

*        Create confirmation
            CALL FUNCTION 'BAPI_PRODORDCONF_CREATE_TT'
              IMPORTING
                return             = ls_return
              TABLES
                timetickets        = lt_timetickets
                goodsmovements     = lt_goodsmovements
                link_conf_goodsmov = lt_link_conf_goodsmov
                detail_return      = lt_detail_return.

            IF ( ls_return IS INITIAL ).
*          Sucess
              CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
                EXPORTING
                  wait = 'X'.

              WAIT UP TO 2 SECONDS.

*         Update table ZABSF_PP077 for consumption
              LOOP AT lt_pp_sf077 INTO DATA(ls_sf077).
                READ TABLE lt_goodsmovements INTO ls_goodsmovements
                     WITH KEY batch = ls_sf077-batch.
                IF ( sy-subrc = 0 ).
**          Get Available stock for batch in storage bin
                  SELECT SINGLE verme
                    FROM lqua
                    INTO (@DATA(lv_verme))
                   WHERE matnr EQ @ls_sf077-matnr
                     AND werks EQ @ls_sf077-werks
                     AND charg EQ @ls_sf077-batch
                     AND EXISTS ( SELECT crhd~objid
                                    FROM crhd AS crhd
                                   INNER JOIN pkhd AS pkhd
                                      ON crhd~werks EQ pkhd~werks
                                     AND crhd~prvbe EQ pkhd~prvbe
                                   WHERE pkhd~lgnum EQ lqua~lgnum
                                     AND pkhd~lgtyp EQ lqua~lgtyp
                                     AND pkhd~lgpla EQ lqua~lgpla
                                     AND pkhd~matnr EQ lqua~matnr
                                     AND pkhd~werks EQ lqua~werks
                                     AND crhd~arbpl EQ @arbpl ).
                  IF ( NOT lv_verme IS INITIAL ).
*                    UPDATE zabsf_pp077 FROM @(
*                        VALUE #( BASE ls_sf077 processed = 'X' ) ).

                    ls_sf077-processed = 'X'.
                    update zabsf_pp077 from ls_sf077.
                    IF ( sy-subrc = 0 ).
                      COMMIT WORK AND WAIT.
                    ENDIF.
                  ELSE.
                    DELETE zabsf_pp077 FROM ls_sf077.
                    IF ( sy-subrc = 0 ).
                      COMMIT WORK AND WAIT.
                    ENDIF.
                  ENDIF.
                ENDIF.
              ENDLOOP.
            ENDIF.


*        Delete duplicate error message
            DELETE ADJACENT DUPLICATES FROM lt_detail_return.

            CLEAR ls_detail_return.

*        Details of operation
            LOOP AT lt_detail_return INTO ls_detail_return.
              CLEAR ls_return_conf.

              ls_return_conf-type = ls_detail_return-type.
              ls_return_conf-id = ls_detail_return-id.
              ls_return_conf-number = ls_detail_return-number.
              ls_return_conf-message = ls_detail_return-message.
              ls_return_conf-message_v1 = ls_detail_return-message_v1.
              ls_return_conf-message_v2 = ls_detail_return-message_v2.
              ls_return_conf-message_v3 = ls_detail_return-message_v3.
              ls_return_conf-message_v4 = ls_detail_return-message_v4.

              APPEND ls_return_conf TO return_tab.

              IF ls_detail_return-type EQ 'I' OR ls_detail_return-type EQ 'S'.
                CLEAR: ls_qty_conf,
                       ls_conf_tab.

*            Confirmation number
                ls_conf_tab-conf_no = ls_detail_return-conf_no.
                ls_conf_tab-conf_cnt = ls_detail_return-conf_cnt.
*            Confirmation counter
                APPEND ls_conf_tab TO conf_tab.

*            Check if was inspection order
                SELECT SINGLE @abap_true
                  FROM aufk
                  INTO @DATA(l_exist)
                 WHERE aufnr EQ @ls_detail_return-message_v1
                   AND auart EQ @c_inspection.

                IF l_exist EQ abap_true.
*              Get time wait
                  SELECT SINGLE parva
                    FROM zabsf_pp032
                    INTO (@DATA(l_wait_param))
                   WHERE parid EQ @c_wait_cancel.

                  IF l_wait_param IS NOT INITIAL.
                    l_wait_cancel = l_wait_param.
                  ENDIF.

*              Wait for backgroud update SAP Table - AFWI
                  IF l_wait_cancel IS NOT INITIAL.
                    WAIT UP TO l_wait_cancel SECONDS.
                  ELSE.
                    WAIT UP TO 5 SECONDS.
                  ENDIF.

*              Change status
                  CALL FUNCTION 'Z_PP02_CHANGE_STATUS'
                    EXPORTING
                      iv_rueck = ls_detail_return-conf_no
                      iv_rmzhl = ls_detail_return-conf_cnt
                      iv_oprid = inputobj-oprid
                    IMPORTING
                      ev_flag  = l_flag.
                ENDIF.

*            Get detail of Production Order confirmed
                READ TABLE lt_qty_conf INTO ls_qty_conf WITH KEY aufnr = ls_detail_return-message_v1.

                IF sy-subrc EQ 0.
*              Get quantity confirmed
                  SELECT SINGLE *
                    FROM afru
                    INTO @DATA(ls_afru)
                   WHERE rueck EQ @ls_detail_return-conf_no
                     AND rmzhl EQ @ls_detail_return-conf_cnt
                     AND aufnr EQ @ls_qty_conf-aufnr.

                  IF sy-subrc EQ 0.
                    CLEAR: l_source_value.

*                Get value values of quantities saved in Database
                    SELECT SINGLE *
                      FROM zabsf_pp017
                      INTO @DATA(ls_pp_sf017)
                     WHERE aufnr EQ @ls_qty_conf-aufnr
                       AND matnr EQ @ls_qty_conf-matnr
                       AND vornr EQ @ls_qty_conf-vornr.

                    IF ( sy-subrc EQ 0 ).
*                  Reverse quantity
                      SELECT SUM( lmnga )
                        FROM afru
                        INTO (@DATA(l_reverse))
                       WHERE rueck EQ @ls_detail_return-conf_no
                         AND aufnr EQ @ls_qty_conf-aufnr
                         AND stokz NE @space
                         AND stzhl NE @space.

*                  Confirmed quantity
                      SELECT SUM( lmnga ), SUM( rmnga ), SUM( xmnga )
                        FROM afru
                        INTO (@DATA(l_lmnga), @DATA(l_rmnga), @DATA(l_xmnga))
                       WHERE rueck EQ @ls_detail_return-conf_no
                         AND aufnr EQ @ls_qty_conf-aufnr
                         AND stokz EQ @space
                         AND stzhl EQ @space.

*                  Good quantity
                      ADD ls_afru-lmnga TO ls_pp_sf017-lmnga.
*                  Missing quantity
                      ls_pp_sf017-missingqty = ls_pp_sf017-gamng - l_lmnga - l_rmnga - l_reverse.
*                      ls_pp_sf017-missingqty = ls_pp_sf017-gamng - l_lmnga - l_rmnga - l_xmnga - l_reverse. "Commented code 28.09.2016
*                  Quantity
                      l_source_value = ls_pp_sf017-gamng.

*                  Get Routing number for operations and General counter for order
                      SELECT SINGLE afko~aufpl, afvc~aplzl
                        FROM afko AS afko
                       INNER JOIN afvc AS afvc
                          ON afvc~aufpl EQ afko~aufpl
                       WHERE afko~aufnr EQ @ls_qty_conf-aufnr
                         AND afvc~vornr EQ @ls_qty_conf-vornr
                        INTO (@l_aufpl , @l_aplzl).

*                  Get box quantity
                      CALL METHOD me->get_qty_box
                        EXPORTING
                          matnr        = ls_pp_sf017-matnr
                          source_value = l_source_value
                          lmnga        = ls_afru-lmnga
                          gmein        = ls_pp_sf017-gmein
                          aufpl        = l_aufpl
                          aplzl        = l_aplzl
                        CHANGING
                          boxqty       = ls_pp_sf017-boxqty.

                      CLEAR l_batch.

*                  Get batch production
                      SELECT SINGLE batch
                        FROM zabsf_pp066
                        INTO @l_batch
                       WHERE werks EQ @inputobj-werks
                         AND aufnr EQ @ls_qty_conf-aufnr
                         AND vornr EQ @ls_qty_conf-vornr.

                      IF l_batch IS NOT INITIAL.
*                    Quantity Produced
                        ADD ls_afru-lmnga TO ls_pp_sf017-prdqty_box.
                      ENDIF.
*                  Update database
                      UPDATE zabsf_pp017 FROM @ls_pp_sf017.
                    ENDIF.
                  ENDIF.
                ENDIF.

                IF ls_detail_return-conf_no IS NOT INITIAL AND ls_detail_return-conf_cnt IS NOT INITIAL.
*              Work center
                  ls_conf_data-arbpl = arbpl.
*              Production order
                  ls_conf_data-aufnr = ls_qty_conf-aufnr.
*              Production order operation
                  ls_conf_data-vornr = ls_qty_conf-vornr.
*              Confirmation number
                  ls_conf_data-conf_no = ls_detail_return-conf_no.
*              Confirmation counter
                  ls_conf_data-conf_cnt = ls_detail_return-conf_cnt.
*              Cycle number
                  ls_conf_data-numb_cycle = ls_qty_conf-numb_cycle.
*              Card active and batch
                  SELECT SINGLE ficha, batch
                    FROM zabsf_pp066
                    INTO (@ls_conf_data-ficha, @ls_conf_data-charg)
                   WHERE werks EQ @inputobj-werks
                     AND aufnr EQ @ls_qty_conf-aufnr
                     AND vornr EQ @ls_qty_conf-vornr.

*              When confirm all box quantity
                  IF ls_conf_data-charg IS INITIAL.
                    IF l_old_batch IS NOT INITIAL.
                      ls_conf_data-charg = l_old_batch.
                    ELSE.
                      ls_conf_data-charg = l_new_batch.
                    ENDIF.
                  ENDIF.

*              Shift ID
                  ls_conf_data-shiftid = l_shiftid.

                  IF lref_sf_prdord IS NOT BOUND.
*                Create object
                    CREATE OBJECT lref_sf_prdord
                      EXPORTING
                        initial_refdt = refdt
                        input_object  = inputobj.
                  ENDIF.

*              Save aditional data of confirmation
                  CALL METHOD lref_sf_prdord->save_data_confirmation
                    EXPORTING
                      is_conf_data = ls_conf_data
                    CHANGING
                      return_tab   = return_tab.
                ENDIF.

              ENDIF.
            ENDLOOP.
          ENDIF.


          IF ( NOT lt_return_tab2[] IS INITIAL ).
**       Add Warnings/Errors
            LOOP AT  lt_return_tab2 INTO DATA(ls_return2).
              INSERT ls_return2 INTO return_tab INDEX 1.
            ENDLOOP.
          ENDIF.
        ENDIF.


****  SCRAP Quantity
        LOOP AT lt_qty_conf ASSIGNING FIELD-SYMBOL(<qty_conf>).

          CHECK NOT <qty_conf>-scrap_qty IS INITIAL.

          READ TABLE lt_pp_sf077 INTO DATA(s_sf077) INDEX 1.
          IF ( sy-subrc = 0 ).
            CLEAR ls_batch_cons.
            ls_batch_cons-matnr = s_sf077-matnr.
            ls_batch_cons-charg = s_sf077-batch.
            ls_batch_cons-werks = s_sf077-werks.
            APPEND ls_batch_cons TO <qty_conf>-charg_t.
          ENDIF.

          DATA l_grund TYPE co_agrnd.
          IF ( <qty_conf>-scrap_qty < 0 ).
            l_grund = '999'.
          ENDIF.

          REFRESH lt_ret_tab_scrap.
          CALL METHOD me->set_quantity_scrap_rpack
            EXPORTING
              arbpl      = arbpl
              aufnr      = <qty_conf>-aufnr
              vornr      = <qty_conf>-vornr
              matnr      = <qty_conf>-matnr
              scrap_qty  = <qty_conf>-scrap_qty
              numb_cycle = <qty_conf>-numb_cycle
              grund      = l_grund
              charg_t    = <qty_conf>-charg_t
              shiftid    = l_shiftid
            CHANGING
              return_tab = lt_ret_tab_scrap.
        ENDLOOP.

        IF ( NOT lt_ret_tab_scrap[] IS INITIAL ).
**       Add Warnings/Errors
          LOOP AT lt_ret_tab_scrap INTO DATA(ls_return_scrap).
            APPEND ls_return_scrap TO return_tab.
          ENDLOOP.
        ENDIF.


      WHEN prdty_repetitive. "Repetitive
*      Not relevant for project

    ENDCASE.

  ELSE.
*  No data found in customizing table for Workcenter
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'E'
        msgno      = '022'
        msgv1      = arbpl
      CHANGING
        return_tab = return_tab.
  ENDIF.
ENDMETHOD.


method set_quantity_scrap_rpack.
*  Internal tables
    data: lt_timetickets_prop        type table of bapi_pp_timeticket,
          lt_goodsmovements_prop     type table of bapi2017_gm_item_create,
          lt_link_conf_goodsmov_prop type table of bapi_link_conf_goodsmov,
          lt_timetickets             type table of bapi_pp_timeticket,
          lt_goodsmovements          type table of bapi2017_gm_item_create,
          lt_link_conf_goodsmov      type table of bapi_link_conf_goodsmov,
          lt_detail_return           type table of bapi_coru_return,
          lt_charg_temp              type zabsf_pp_t_batch_consumption,
          lt_return_tab2             type bapiret2_t,
          lt_create_batch            type zabsf_pp_t_goodmovements.

*  Structures
    data: ls_timetickets_prop   type bapi_pp_timeticket,
          ls_timetickets        type bapi_pp_timeticket,
          ls_goodsmovements     type bapi2017_gm_item_create,
          ls_link_conf_goodsmov type bapi_link_conf_goodsmov,
          ls_propose            type bapi_pp_conf_prop,
          ls_zabsf_pp004        type zabsf_pp004,
          ls_return             type bapiret1,
          ls_return_conf        type bapiret2,
          ls_return_tab         type bapiret2,
          ls_conf_data          type zabsf_pp_s_conf_adit_data,
          ls_charg_temp         type zabsf_pp_s_batch_consumption,
          ls_conf_tab           type zabsf_pp_s_confirmation,
          ls_create_batch       type zabsf_pp_s_goodmovements.

*  Variables
    data l_flag type flag.
    data l_error.
    data l_new_batch    type charg_d.
    data l_source_value type i.

*  Constants
    constants: c_move_typ   type bwart  value '261',
               c_move_ent   type bwart  value '101',
               c_inspection type aufart value 'ZINS',
               c_mtart_verp type mtart  value 'VERP', "Material type - Packing.
               c_batch_fake type charg_d value '0000000001'.

    refresh lt_timetickets_prop.
    clear: ls_timetickets_prop.


*  Upper case operator
    translate inputobj-oprid to upper case.

*  User
    if inputobj-pernr is initial.
      inputobj-pernr = inputobj-oprid.
    endif.

    if backoffice is initial.
*    Get shift witch operator is associated
      select single shiftid
        from zabsf_pp052
        into (@data(l_shiftid))
       where areaid eq @inputobj-areaid
         and oprid  eq @inputobj-oprid.

      if sy-subrc ne 0.
*      Operator is not associated with shift
        call method zabsf_pp_cl_log=>add_message
          exporting
            msgty      = 'E'
            msgno      = '061'
            msgv1      = inputobj-oprid
          changing
            return_tab = return_tab.

        exit.
      endif.
    else.
*    Shift ID
      l_shiftid = shiftid.
    endif.

*  Check lenght of time
    data(l_lengh) = strlen( inputobj-timeconf ).

    if l_lengh lt 6.
      concatenate '0' inputobj-timeconf into data(l_time).
    else.
      l_time = inputobj-timeconf.
    endif.


    if ( aufnr is not initial ).
*    Get sequence for save new data
      select max( seqid )
        from zabsf_pp004
        into (@data(l_seqid))
       where aufnr eq @aufnr.

      add 1 to l_seqid.

*    Save quantity and scrap quantity of production order
*    Fill data to timeticket
      ls_timetickets_prop-orderid = aufnr.
      ls_timetickets_prop-operation = vornr.
      if ( scrap_qty < 0 ).
        ls_timetickets_prop-scrap = scrap_qty * ( -1 ).
      else.
        ls_timetickets_prop-yield = scrap_qty.
      endif.


      append ls_timetickets_prop to lt_timetickets_prop.

      if lt_timetickets_prop[] is not initial.
*      Propose data for quantity
*        ls_propose-quantity = abap_true.
        ls_propose-goodsmovement = abap_true.

        call function 'BAPI_PRODORDCONF_GET_TT_PROP'
          exporting
            propose            = ls_propose
          importing
            return             = ls_return
          tables
            timetickets        = lt_timetickets_prop
            goodsmovements     = lt_goodsmovements_prop
            link_conf_goodsmov = lt_link_conf_goodsmov_prop
            detail_return      = lt_detail_return.

        if ls_return is not initial.
*          Message error
          append ls_return to return_tab.

          loop at lt_detail_return into data(ls_detail_return).
            if ( ls_detail_return-type ne 'I' and ls_detail_return-type ne 'S' ).
              clear ls_return_conf.

              ls_return_conf-type = ls_detail_return-type.
              ls_return_conf-id = ls_detail_return-id.
              ls_return_conf-number = ls_detail_return-number.
              ls_return_conf-message = ls_detail_return-message.
              ls_return_conf-message_v1 = ls_detail_return-message_v1.
              ls_return_conf-message_v2 = ls_detail_return-message_v2.
              ls_return_conf-message_v3 = ls_detail_return-message_v3.
              ls_return_conf-message_v4 = ls_detail_return-message_v4.

              append ls_return_conf to return_tab.
            endif.
          endloop.
        endif.

        clear ls_timetickets_prop.
        refresh lt_timetickets.

        loop at lt_timetickets_prop into ls_timetickets_prop.
          clear ls_zabsf_pp004.

*        Move same fields
          move-corresponding ls_timetickets_prop to ls_timetickets.

*        Record date
          if inputobj-dateconf is not initial.
            ls_timetickets-exec_start_date = ls_timetickets-exec_fin_date = inputobj-dateconf.
            ls_timetickets-postg_date = inputobj-dateconf.
          endif.

*        Record time
          if l_time is not initial.
            ls_timetickets-exec_start_time = ls_timetickets-exec_fin_time = l_time.
          endif.

*        Counter Number of employees in Production Order
          select count( * )
            from zabsf_pp014
            into (@data(l_nr_operator))
           where arbpl  eq @arbpl
             and aufnr  eq @ls_timetickets-orderid
             and vornr  eq @ls_timetickets-operation
             and tipord eq 'N'
             and status eq 'A'.

          if l_nr_operator is not initial.
*          Number of employees
            ls_timetickets-no_of_employee = l_nr_operator.
          endif.

*        User and shift
          ls_timetickets-ex_created_by = inputobj-oprid.
          ls_timetickets-kaptprog = l_shiftid.

*        Check if fields scrap_qty
          if ( scrap_qty is not initial ). " AND grund IS NOT INITIAL ).
            clear ls_timetickets-yield.

*          Insert data for confirmation of scrap quantity
            if ( scrap_qty < 0 ).
              ls_timetickets-scrap = scrap_qty * ( -1 ).
            else.
              ls_timetickets-yield = scrap_qty.
            endif.
            ls_timetickets-dev_reason = grund.

*          Add quantity scrap to confirm
            append ls_timetickets to lt_timetickets.
          endif.
        endloop.

*      Create data to goods movements
        if lt_goodsmovements_prop[] is not initial.
          if charg_t[] is initial.
*          Get batches consumption
            select *
              from zabsf_pp077
              into table @data(lt_pp_sf077)
             where werks eq @inputobj-werks
               and aufnr eq @aufnr
               and vornr eq @vornr
              order by indice ascending.

            if ( lt_pp_sf077[] is not initial ).
              loop at lt_pp_sf077 into data(ls_pp_sf077).
                clear ls_charg_temp.
                ls_charg_temp-charg = ls_pp_sf077-batch.
                move-corresponding ls_pp_sf077 to ls_charg_temp.
                append ls_charg_temp to lt_charg_temp.
              endloop.
            else.
              if ( scrap_qty < 0 ).
*            No indication of batch of consumption in the previous screen
                call method zabsf_pp_cl_log=>add_message
                  exporting
                    msgty      = 'E'
                    msgno      = '087'
                  changing
                    return_tab = return_tab.
                exit.
              else.
*              Fake Batch and quantity adjustments
                clear ls_charg_temp.
                ls_charg_temp-charg = c_batch_fake.
                append ls_charg_temp to lt_charg_temp.
              endif.
            endif.
          else.
            lt_charg_temp[] = charg_t[].
          endif.

          loop at lt_charg_temp into data(ls_charg).
*>> BMR INSERT - add leading zeros to batch number.
            call function 'CONVERSION_EXIT_ALPHA_INPUT'
              exporting
                input  = ls_charg-charg
              importing
                output = ls_charg-charg.
*<< BMR END INSERT

            if ( scrap_qty > 0 ).
              delete lt_goodsmovements_prop where move_type eq c_move_typ.

              loop at lt_goodsmovements_prop into data(ls_goodsmovements_prop)
                                            where move_type eq c_move_ent.
                clear ls_goodsmovements.
*            Move same fields to output table
                move-corresponding ls_goodsmovements_prop to ls_goodsmovements.

*              Get batch production
                select single batch
                  from zabsf_pp066
                  into (@data(l_batch))
                 where werks eq @inputobj-werks
                   and aufnr eq @aufnr
                   and vornr eq @vornr.
                if ( sy-subrc eq 0 ).
*                Batch Production
                  call function 'CONVERSION_EXIT_ALPHA_INPUT'
                    exporting
                      input  = l_batch
                    importing
                      output = ls_goodsmovements-batch.
                endif.

*            Quantity
                ls_goodsmovements-entry_qnt = scrap_qty.

*            Append to output table
                append ls_goodsmovements to lt_goodsmovements.
              endloop.

            else.

              delete lt_goodsmovements_prop where move_type eq c_move_ent.

              loop at lt_goodsmovements_prop into data(ls_goodsmovs_prop)
                                            where material  eq ls_charg-matnr and
                                                  move_type eq c_move_typ.
                clear ls_goodsmovements.
*            Move same fields to output table
                move-corresponding ls_goodsmovs_prop to ls_goodsmovements.

*            Batch consumption
                ls_goodsmovements-batch = ls_charg-charg.
                ls_goodsmovements-entry_qnt = scrap_qty.
                if ( ls_goodsmovements-entry_qnt < 0 ).
                  ls_goodsmovements-entry_qnt = ls_goodsmovements-entry_qnt * ( -1 ).
                endif.

*          Get batches consumption
                select single rsnum, rspos
                  from zabsf_pp077
                  into (@ls_goodsmovements-reserv_no,@ls_goodsmovements-res_item )
                 where werks eq @inputobj-werks
                   and aufnr eq @aufnr
                   and vornr eq @vornr
                   and matnr eq @ls_charg-matnr
                   and batch eq @ls_charg-charg.

*            Append to output table
                append ls_goodsmovements to lt_goodsmovements.
              endloop.
            endif.

          endloop.
        endif.


        if backoffice is initial.
          clear l_error.
*        Check validation for Consumption batchs
          call method me->check_available_stock
            exporting
              areaid             = 'PP01'
              arbpl              = arbpl
              aufnr              = aufnr
              goodsmovements_tab = lt_goodsmovements
            importing
              msg_error          = l_error
*             return_tab         = return_tab
              return_tab         = lt_return_tab2.

*        Exit if exist errors
          if l_error is not initial.
**         Send error msg to Shopfloor
            move lt_return_tab2[] to return_tab[].
            exit.
          endif.
        endif.


**      Refresh Link Table
        refresh lt_link_conf_goodsmov_prop.
        loop at lt_goodsmovements_prop into data(ls_goods_prop).
          data(l_tabix) = sy-tabix.
          clear ls_link_conf_goodsmov.
          ls_link_conf_goodsmov-index_confirm = 1.
          ls_link_conf_goodsmov-index_goodsmov = l_tabix.
          append ls_link_conf_goodsmov to lt_link_conf_goodsmov.
        endloop.


        if lt_timetickets[] is not initial. "AND lt_goodsmovements[] IS NOT INITIAL.
          refresh lt_create_batch.
          clear ls_goodsmovements.

          loop at lt_goodsmovements into ls_goodsmovements.
            clear ls_create_batch.

*          Get Routing number for operations and General counter for order
            select single afko~aufpl, afvc~aplzl
              from afko as afko
             inner join afvc as afvc
                on afvc~aufpl eq afko~aufpl
             where afko~aufnr eq @aufnr
               and afvc~vornr eq @vornr
              into (@data(l_aufpl), @data(l_aplzl)).

*          Move data to create batch or to validate
            ls_create_batch-aufnr = aufnr.
            ls_create_batch-vornr = vornr.
            ls_create_batch-aufpl = l_aufpl.
            ls_create_batch-aplzl = l_aplzl.
            ls_create_batch-werks = ls_goodsmovements-plant.
            ls_create_batch-matnr = ls_goodsmovements-material.
            ls_create_batch-lgort = ls_goodsmovements-stge_loc.
            ls_create_batch-charg = ls_goodsmovements-batch.
            ls_create_batch-bwart = ls_goodsmovements-move_type.
            ls_create_batch-erfmg = ls_goodsmovements-entry_qnt.
            ls_create_batch-erfme = ls_goodsmovements-entry_uom.
            ls_create_batch-bwtar = ls_goodsmovements-val_type.
            move-corresponding ls_goodsmovements to ls_create_batch.

            ls_create_batch-hsdat = inputobj-dateconf.
            append ls_create_batch to lt_create_batch.
          endloop.


*        Create batch
          call function 'Z_PP02_DATA_TO_CREATE_BATCH'
            exporting
*             iv_first_cycle   = first_cycle
              iv_shiftid       = l_shiftid
              is_inputobject   = inputobj
              iv_refdt         = refdt
              it_goodmovements = lt_create_batch
            importing
              ev_new_batch     = l_new_batch
            tables
              return_tab       = return_tab.

          if l_new_batch is not initial.
            loop at lt_goodsmovements assigning field-symbol(<fs_goodmovements>)
                                      where move_type eq c_move_ent.
              <fs_goodmovements>-batch = l_new_batch.
            endloop.

*          Packaging consumption - boxes and bags
            loop at lt_goodsmovements assigning <fs_goodmovements> where move_type eq c_move_typ.
*            Check material with material group VERP
              select single mtart
                from mara
                into (@data(l_mtart))
               where matnr eq @<fs_goodmovements>-material.

              if l_mtart eq c_mtart_verp.
                <fs_goodmovements>-entry_qnt = 1.
              endif.
            endloop.
          else.
*          Packaging consumption - boxes and bags
            loop at lt_goodsmovements assigning <fs_goodmovements> where move_type eq c_move_typ.
              clear l_mtart.

*            Check material with material group VERP
              select single mtart
                from mara
                into @l_mtart
               where matnr eq @<fs_goodmovements>-material.

              if l_mtart eq c_mtart_verp.
                <fs_goodmovements>-entry_qnt = 0.
              endif.
            endloop.
          endif.
          clear l_error.

*        Check if exist errors
          loop at return_tab into data(ls_return2) where type ne 'S'
                                                    and type ne 'I'
                                                    and type ne 'W'.
            l_error = abap_true.
            exit.
          endloop.

          if l_error is not initial.
            exit.
          endif.


*      Free lock
          call function 'DEQUEUE_ALL'.

*      Create confirmation
          call function 'BAPI_PRODORDCONF_CREATE_TT'
            exporting
              post_wrong_entries = '2'
            importing
              return             = ls_return
            tables
              timetickets        = lt_timetickets
              goodsmovements     = lt_goodsmovements
              link_conf_goodsmov = lt_link_conf_goodsmov
              detail_return      = lt_detail_return.

          if ls_return is initial.
*        Save data
            call function 'BAPI_TRANSACTION_COMMIT'
              exporting
                wait = 'X'.

            wait up to 1 seconds.

            if ( scrap_qty < 0 ).
*         Update table ZABSF_PP077 for consumption
              loop at lt_pp_sf077 into data(ls_sf077).
                read table lt_goodsmovements into ls_goodsmovements
                     with key batch = ls_sf077-batch.
                if ( sy-subrc = 0 ).
**          Get Available stock for batch in storage bin
                  select single verme
                    from lqua
                    into (@data(lv_verme))
                   where matnr eq @ls_sf077-matnr
                     and werks eq @ls_sf077-werks
                     and charg eq @ls_sf077-batch
                     and exists ( select crhd~objid
                                    from crhd as crhd
                                   inner join pkhd as pkhd
                                      on crhd~werks eq pkhd~werks
                                     and crhd~prvbe eq pkhd~prvbe
                                   where pkhd~lgnum eq lqua~lgnum
                                     and pkhd~lgtyp eq lqua~lgtyp
                                     and pkhd~lgpla eq lqua~lgpla
                                     and pkhd~matnr eq lqua~matnr
                                     and pkhd~werks eq lqua~werks
                                     and crhd~arbpl eq @arbpl ).
                  if ( not lv_verme is initial ).
*                    UPDATE zabsf_pp077 FROM @(
*                        VALUE #( BASE ls_sf077 processed = 'X' ) ).

                    ls_sf077-processed = 'X'.
                    update zabsf_pp077 from ls_sf077.
                    if ( sy-subrc = 0 ).
                      commit work and wait.
                    endif.
                  else.
                    delete zabsf_pp077 from ls_sf077.
                    if ( sy-subrc = 0 ).
                      commit work and wait.
                    endif.
                  endif.
                endif.
              endloop.
            endif.


            if ( scrap_qty is not initial ).
*          Check is material is initial
              if matnr is initial.
*             Get material from Production Order
                select single plnbez, stlbez
                  from afko
                  into (@data(l_plnbez), @data(l_stlbez))
                 where aufnr eq @aufnr.

*            Material
                if l_plnbez is not initial.
                  data(l_matnr) = l_plnbez.
                else.
                  l_matnr = l_stlbez.
                endif.
              else.
                l_matnr = matnr.
              endif.

*          Get value in Database
              select single *
                from zabsf_pp017
                into @data(ls_zabsf_pp017)
               where aufnr eq @aufnr
                 and matnr eq @l_matnr
                 and vornr eq @vornr.

              if ( sy-subrc eq 0 ).
                clear ls_detail_return.

*            Read number of confirmation
                loop at lt_detail_return into ls_detail_return where message_v1 = aufnr.
                  clear ls_return_tab.

                  ls_return_tab-type = ls_detail_return-type.
                  ls_return_tab-id = ls_detail_return-id.
                  ls_return_tab-number = ls_detail_return-number.
                  ls_return_tab-message = ls_detail_return-message.
                  ls_return_tab-message_v1 = ls_detail_return-message_v1.
                  ls_return_tab-message_v2 = ls_detail_return-message_v2.
                  ls_return_tab-message_v3 = ls_detail_return-message_v3.
                  ls_return_tab-message_v4 = ls_detail_return-message_v4.

                  append ls_return_tab to return_tab.

                  if ls_detail_return-conf_no is not initial and ( ls_detail_return-type eq 'I' or ls_detail_return-type eq 'S' ).
                    clear ls_conf_tab.

*                Confirmation number
                    ls_conf_tab-conf_no = ls_detail_return-conf_no.
                    ls_conf_tab-conf_cnt = ls_detail_return-conf_cnt.
*                Confirmation counter
                    append ls_conf_tab to conf_tab.

*                Check if was inspection order
                    select single @abap_true
                      from aufk
                      into @data(l_exist)
                     where aufnr eq @aufnr
                       and auart eq @c_inspection.

                    if l_exist eq abap_true.
*                  Change status
                      call function 'Z_PP02_CHANGE_STATUS'
                        exporting
                          iv_rueck = ls_detail_return-conf_no
                          iv_rmzhl = ls_detail_return-conf_cnt
                          iv_oprid = inputobj-oprid
                        importing
                          ev_flag  = l_flag.
                    endif.

*                Reverse quantity
                    select sum( lmnga )
                      from afru
                      into (@data(l_reverse))
                     where rueck eq @ls_detail_return-conf_no
                       and aufnr eq @aufnr
                       and stokz ne @space
                       and stzhl ne @space.

*                Get data of quantities
                    select sum( lmnga ), sum( rmnga ), sum( xmnga )
                      from afru
                      into (@data(l_lmnga), @data(l_rmnga), @data(l_xmnga))
                     where rueck eq @ls_detail_return-conf_no
                       and aufnr eq @aufnr
                       and stokz eq @space
                       and stzhl eq @space.

                    l_source_value = ls_zabsf_pp017-gamng.

*                  Get Routing number for operations and General counter for order
                    select single afko~aufpl, afvc~aplzl
                      from afko as afko
                     inner join afvc as afvc
                        on afvc~aufpl eq afko~aufpl
                     where afko~aufnr eq @aufnr
                       and afvc~vornr eq @vornr
                      into (@l_aufpl , @l_aplzl).

*                  Get box quantity
                    call method me->get_qty_box
                      exporting
                        matnr        = ls_zabsf_pp017-matnr
                        source_value = l_source_value
                        lmnga        = l_lmnga
                        gmein        = ls_zabsf_pp017-gmein
                        aufpl        = l_aufpl
                        aplzl        = l_aplzl
                      changing
                        boxqty       = ls_zabsf_pp017-boxqty.

**                Update missing quantity
*                  ls_ZABSF_PP017-missingqty = ls_ZABSF_PP017-gamng - l_lmnga - l_rmnga - l_xmnga - l_reverse.

                    clear l_batch.
*                  Get batch production
                    select single batch
                      from zabsf_pp066
                      into @l_batch
                     where werks eq @inputobj-werks
                       and aufnr eq @aufnr
                       and vornr eq @vornr.

*                Update database
                    if ( scrap_qty > 0 ).
                      if l_batch is not initial.
                        "ls_ZABSF_PP017-prdqty_box = ls_ZABSF_PP017-prdqty_box + scrap_qty.
*                        UPDATE zabsf_pp017 FROM @( VALUE #(
*                          BASE ls_ZABSF_PP017
*                               lmnga = l_lmnga
*                               prdqty_box = ls_ZABSF_PP017-prdqty_box + scrap_qty
*                               missingqty = ls_ZABSF_PP017-missingqty - scrap_qty ) ).

                        ls_zabsf_pp017-lmnga = l_lmnga.
                        ls_zabsf_pp017-prdqty_box = ls_zabsf_pp017-prdqty_box + scrap_qty.
                        ls_zabsf_pp017-missingqty = ls_zabsf_pp017-missingqty - scrap_qty.
                        update zabsf_pp017 from ls_zabsf_pp017.

                      else.
*                        UPDATE zabsf_pp017 FROM @( VALUE #(
*                          BASE ls_ZABSF_PP017
*                               lmnga = l_lmnga
*                               missingqty = ls_ZABSF_PP017-missingqty - scrap_qty ) ).
                        ls_zabsf_pp017-lmnga = l_lmnga.
                        ls_zabsf_pp017-missingqty = ls_zabsf_pp017-missingqty - scrap_qty.
                        update zabsf_pp017 from ls_zabsf_pp017.
                      endif.
                    else.
*                      update zabsf_pp017 from @( value #(
*                        base ls_zabsf_pp017
*                             missingqty = ls_zabsf_pp017-gamng - l_lmnga - l_rmnga - l_reverse ) ).
                      ls_zabsf_pp017-missingqty = ls_zabsf_pp017-gamng - l_lmnga - l_rmnga - l_reverse.
                      update zabsf_pp017 from ls_zabsf_pp017.
                    endif.

*                Save additional data of confirmation
*                Work center
                    ls_conf_data-arbpl = arbpl.
*                Production order
                    ls_conf_data-aufnr = aufnr.
*                Production order operation
                    ls_conf_data-vornr = vornr.
*                Confirmation number
                    ls_conf_data-conf_no = ls_detail_return-conf_no.
*                Confirmation counter
                    ls_conf_data-conf_cnt = ls_detail_return-conf_cnt.
*                Cycle number
                    ls_conf_data-numb_cycle = numb_cycle.
*                Card
                    select single ficha
                      from zabsf_pp066
                      into @ls_conf_data-ficha
                     where werks eq @inputobj-werks
                       and aufnr eq @aufnr
                       and vornr eq @vornr.

*                Shift ID
                    ls_conf_data-shiftid = l_shiftid.


*                Save aditional data of confirmation
                    call method me->save_data_confirmation
                      exporting
                        is_conf_data = ls_conf_data
                      changing
                        return_tab   = return_tab.
                  endif.
                endloop.
              endif.
            endif.
          endif.
        else.
*        Return data
          call function 'BAPI_TRANSACTION_ROLLBACK'.

*        Details of operation
          loop at lt_detail_return into ls_detail_return.
            clear ls_return_tab.

            ls_return_tab-type = ls_detail_return-type.
            ls_return_tab-id = ls_detail_return-id.
            ls_return_tab-number = ls_detail_return-number.
            ls_return_tab-message = ls_detail_return-message.
            ls_return_tab-message_v1 = ls_detail_return-message_v1.
            ls_return_tab-message_v2 = ls_detail_return-message_v2.
            ls_return_tab-message_v3 = ls_detail_return-message_v3.
            ls_return_tab-message_v4 = ls_detail_return-message_v4.

            append ls_return_tab to return_tab.
          endloop.
        endif.
      endif.
    endif.
  endmethod.


METHOD SET_REFDT.

*Set new reference date
  refdt = new_refdt.

  ENDMETHOD.


method update_resb_batch.
    "variáveis locais
    data: lt_bdcdata_tab  type table of bdcdata,
          lt_messages_tab type table of bdcmsgcoll.

    "limpar variáveis de exportação
    refresh et_return_tab.
    "criar batch input
    call method zcl_sf_bdc=>bdc_dynpro
      exporting
        iv_program_var = 'SAPLCOKO1'
        iv_dynpro_var  = '0110'
      changing
        ch_bdcdata_tab = lt_bdcdata_tab.

    call method zcl_sf_bdc=>bdc_field
      exporting
        iv_fnam_var    = 'BDC_CURSOR'
        iv_fval_var    = 'CAUFVD-AUFNR'
      changing
        ch_bdcdata_tab = lt_bdcdata_tab.

    call method zcl_sf_bdc=>bdc_field
      exporting
        iv_fnam_var    = 'BDC_OKCODE'
        iv_fval_var    = '/00'
      changing
        ch_bdcdata_tab = lt_bdcdata_tab.

    call method zcl_sf_bdc=>bdc_field
      exporting
        iv_fnam_var    = 'CAUFVD-AUFNR'
        iv_fval_var    = conv #( im_aufnr_var )
      changing
        ch_bdcdata_tab = lt_bdcdata_tab.

    call method zcl_sf_bdc=>bdc_field
      exporting
        iv_fnam_var    = 'R62CLORD-FLG_OVIEW'
        iv_fval_var    = 'X'
      changing
        ch_bdcdata_tab = lt_bdcdata_tab.


    call method zcl_sf_bdc=>bdc_dynpro
      exporting
        iv_program_var = 'SAPLCOKO1'
        iv_dynpro_var  = '0115'
      changing
        ch_bdcdata_tab = lt_bdcdata_tab.

    call method zcl_sf_bdc=>bdc_field
      exporting
        iv_fnam_var    = 'BDC_OKCODE'
        iv_fval_var    = '=KPU2'
      changing
        ch_bdcdata_tab = lt_bdcdata_tab.

    call method zcl_sf_bdc=>bdc_field
      exporting
        iv_fnam_var    = 'BDC_SUBSCR'
        iv_fval_var    = 'SAPLCOKO1                               0120SUBSCR_0115'
      changing
        ch_bdcdata_tab = lt_bdcdata_tab.

    call method zcl_sf_bdc=>bdc_dynpro
      exporting
        iv_program_var = 'SAPLCOMK'
        iv_dynpro_var  = '0120'
      changing
        ch_bdcdata_tab = lt_bdcdata_tab.


    loop at im_resb_tab into data(ls_resb_str).

      call method zcl_sf_bdc=>bdc_field
        exporting
          iv_fnam_var    = 'BDC_OKCODE'
          iv_fval_var    = '=AUFS'
        changing
          ch_bdcdata_tab = lt_bdcdata_tab.

      call method zcl_sf_bdc=>bdc_dynpro
        exporting
          iv_program_var = 'SAPLCO05'
          iv_dynpro_var  = '0110'
        changing
          ch_bdcdata_tab = lt_bdcdata_tab.

      call method zcl_sf_bdc=>bdc_field
        exporting
          iv_fnam_var    = 'BDC_CURSOR'
          iv_fval_var    = 'RCOSU-POSNR'
        changing
          ch_bdcdata_tab = lt_bdcdata_tab.

      call method zcl_sf_bdc=>bdc_field
        exporting
          iv_fnam_var    = 'BDC_OKCODE'
          iv_fval_var    = '=MORE'
        changing
          ch_bdcdata_tab = lt_bdcdata_tab.

      call method zcl_sf_bdc=>bdc_field
        exporting
          iv_fnam_var    = 'RCOSU-POSNR'
          iv_fval_var    = conv #( ls_resb_str-posnr )
        changing
          ch_bdcdata_tab = lt_bdcdata_tab.

      call method zcl_sf_bdc=>bdc_dynpro
        exporting
          iv_program_var = 'SAPLCOMK'
          iv_dynpro_var  = '0120'
        changing
          ch_bdcdata_tab = lt_bdcdata_tab.

      call method zcl_sf_bdc=>bdc_field
        exporting
          iv_fnam_var    = 'BDC_CURSOR'
          iv_fval_var    = 'RESBD-CHARG(01)'
        changing
          ch_bdcdata_tab = lt_bdcdata_tab.

      call method zcl_sf_bdc=>bdc_field
        exporting
          iv_fnam_var    = 'BDC_OKCODE'
          iv_fval_var    = '/00'
        changing
          ch_bdcdata_tab = lt_bdcdata_tab.

      call method zcl_sf_bdc=>bdc_field
        exporting
          iv_fnam_var    = 'RESBD-CHARG(01)'
          iv_fval_var    = conv #( ls_resb_str-charg )
        changing
          ch_bdcdata_tab = lt_bdcdata_tab.

      call method zcl_sf_bdc=>bdc_dynpro
        exporting
          iv_program_var = 'SAPLCOMD'
          iv_dynpro_var  = '0110'
        changing
          ch_bdcdata_tab = lt_bdcdata_tab.

      call method zcl_sf_bdc=>bdc_field
        exporting
          iv_fnam_var    = 'BDC_OKCODE'
          iv_fval_var    = '/00'
        changing
          ch_bdcdata_tab = lt_bdcdata_tab.

      call method zcl_sf_bdc=>bdc_dynpro
        exporting
          iv_program_var = 'SAPLCOMK'
          iv_dynpro_var  = '0120'
        changing
          ch_bdcdata_tab = lt_bdcdata_tab.
    endloop.


    call method zcl_sf_bdc=>bdc_field
      exporting
        iv_fnam_var    = 'BDC_OKCODE'
        iv_fval_var    = '=KOER'
      changing
        ch_bdcdata_tab = lt_bdcdata_tab.

    call method zcl_sf_bdc=>bdc_field
      exporting
        iv_fnam_var    = 'BDC_SUBSCR'
        iv_fval_var    = 'SAPLCOKO1                               0120SUBSCR_0115'
      changing
        ch_bdcdata_tab = lt_bdcdata_tab.

    call method zcl_sf_bdc=>bdc_field
      exporting
        iv_fnam_var    = 'BDC_OKCODE'
        iv_fval_var    = '=BU'
      changing
        ch_bdcdata_tab = lt_bdcdata_tab.


    call method zcl_sf_bdc=>bdc_field
      exporting
        iv_fnam_var    = 'BDC_SUBSCR'
        iv_fval_var    = 'SAPLCOKO1                               0120SUBSCR_0115'
      changing
        ch_bdcdata_tab = lt_bdcdata_tab.

    "chamar transacção
    call transaction 'CO02' using lt_bdcdata_tab
                     mode   'N'
                     update 'S'
                     messages into lt_messages_tab.
    "verificar se ocorreu erro num dynpro
    if sy-subrc eq 1001.
      "Erro ao actualizar lotes na ordem de produção
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgty      = 'E'
          msgno      = 162
        changing
          return_tab = et_return_tab.
      return.
    endif.
    loop at lt_messages_tab into data(ls_message_str)
      where msgtyp ca 'AEX'.
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgid      = ls_message_str-msgid
          msgty      = ls_message_str-msgtyp
          msgno      = conv #( ls_message_str-msgnr )
          msgv1      = ls_message_str-msgv1
          msgv2      = ls_message_str-msgv2
          msgv3      = ls_message_str-msgv3
          msgv4      = ls_message_str-msgv4
        changing
          return_tab = et_return_tab.
    endloop.
  endmethod.
ENDCLASS.
