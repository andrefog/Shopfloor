*&---------------------------------------------------------------------*
*&  Include           ZABSF_CALC_WORKERS_KPI_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  INIT_VARIABLES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM init_variables .
  REFRESH gt_output.

  CLEAR: g_cont_proc.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .
*Internal tables
  DATA: lt_pp_sf065 TYPE TABLE OF zabsf_pp065.

*Structures
  DATA: ls_pp_sf062 TYPE zabsf_pp062.

*Variables
  DATA: l_count_id    TYPE i,
        l_status_proc TYPE zabsf_status,
        lv_tmp_plan   TYPE p LENGTH 3 DECIMALS 4, " VALUE '0.9815',
        lv_planajust  TYPE p LENGTH 3 DECIMALS 3. " VALUE '0.979'.

*Constants
  CONSTANTS: c_proc_conc TYPE zabsf_status VALUE 'P', "Processing completed
             c_in_proc   TYPE zabsf_status VALUE 'E', "Processing
             c_re_proc   TYPE zabsf_status VALUE 'R', "Reprocessed
             c_objty     TYPE cr_objty     VALUE 'A'. "Work center

  SELECT  parid, parva
    FROM zabsf_pp032
    INTO TABLE @DATA(lt_zlp_pp_sf032)
   WHERE werks EQ @p_werks
     AND parid IN ('CONST_TMP_PLANEADO','CONST_TMP_PLANAJUST').


  IF p_simul IS NOT INITIAL AND p_prc IS NOT INITIAL.
*  Get all active cards processed
    SELECT *
      FROM zabsf_pp065 as zlp_pp_sf065
      INTO TABLE @DATA(lt_ficha_active)
     WHERE werks    EQ @p_werks
       AND reversal EQ @abap_false
*       AND ficha    EQ @p_ficha
       AND EXISTS ( SELECT ficha
                      FROM zabsf_card_proc
                     WHERE oprid    EQ zlp_pp_sf065~oprid
                       AND werks    EQ zlp_pp_sf065~werks
                       AND ficha    EQ zlp_pp_sf065~ficha
                       AND oprid    IN @so_pernr
                       AND status   EQ @c_proc_conc
                       AND date_proc IN @so_date ).
  ELSE.
    REFRESH lt_ficha_active.

* Get all card notes not in zpp02_card_proc(cards processed) + not in zpp02_card_proc
    SELECT *
      FROM zabsf_pp065 as zlp_pp_sf065
      INTO TABLE @lt_ficha_active
     WHERE werks    EQ @p_werks
       AND reversal EQ @abap_false
       AND oprid    IN @so_pernr
*       AND ficha    EQ @p_ficha
       AND ( NOT EXISTS ( SELECT ficha
                            FROM zabsf_card_proc                " Processing + Reprocessed
                           WHERE oprid     EQ zlp_pp_sf065~oprid
                             AND werks     EQ zlp_pp_sf065~werks
                             AND ficha     EQ zlp_pp_sf065~ficha
                             AND oprid     IN @so_pernr
                             AND status    EQ @c_proc_conc
                             AND date_proc IN @so_date )
         OR NOT EXISTS ( SELECT ficha                     " Not Processed
                            FROM zabsf_card_proc
                           WHERE oprid EQ zlp_pp_sf065~oprid
                             AND werks EQ zlp_pp_sf065~werks
                             AND ficha EQ zlp_pp_sf065~ficha ) ).
  ENDIF.

  CHECK lt_ficha_active[] IS NOT INITIAL.

  IF ( p_simul = 'X' AND p_notprc = 'X' ) OR p_save = 'X'.
    DATA(lv_where) = 'iedd  LE @p_lim_dt'.
  ENDIF.

**  Get cards relevant for KPI calculations
  SELECT rueck, rmzhl, isdd, isbd, arbid, werks, aplzl, aufpl, aufnr, stokz, stzhl, iserh, lmnga, xmnga, ism03, anzma, iedd
    FROM afru
    INTO TABLE @DATA(lt_afru)
     FOR ALL ENTRIES IN @lt_ficha_active
   WHERE rueck EQ @lt_ficha_active-conf_no
     AND rmzhl EQ @lt_ficha_active-conf_cnt
     AND stokz EQ @space
     AND stzhl EQ @space
     AND (lv_where)
     AND EXISTS ( SELECT crhd~objid
                    FROM crhd AS crhd INNER JOIN zabsf_pp067 AS sf067 ON  sf067~werks EQ crhd~werks
                                                                       AND sf067~veran EQ crhd~veran
                   WHERE crhd~objty EQ @c_objty
                     AND crhd~objid EQ afru~arbid
                     AND crhd~werks EQ @p_werks
                     AND sf067~kpi  NE @space ).

  CHECK lt_afru[] IS NOT INITIAL.

  SORT lt_afru BY rueck rmzhl.
  LOOP AT lt_ficha_active INTO DATA(ls_ficha_active).

    READ TABLE lt_afru TRANSPORTING NO FIELDS WITH KEY rueck = ls_ficha_active-conf_no
                                                       rmzhl = ls_ficha_active-conf_cnt
                       BINARY SEARCH.

    IF sy-subrc <> 0.
      DELETE lt_ficha_active.
    ENDIF.

  ENDLOOP.

  APPEND LINES OF lt_ficha_active TO lt_pp_sf065.

  SORT lt_pp_sf065 BY conf_no oprid ficha.

  DELETE ADJACENT DUPLICATES FROM lt_pp_sf065 COMPARING conf_no oprid ficha.

  CHECK lt_pp_sf065[] IS NOT INITIAL.

** Get Inspection Lots
*  SELECT charg, stat35
*    FROM qals
*    INTO TABLE @DATA(lt_qals)
*     FOR ALL ENTRIES IN @lt_ficha_active
*   WHERE werk  EQ @p_werks
*     AND charg EQ @lt_ficha_active-charg
*     AND charg NE @space
*     AND stat35 EQ 'X'.

* Get Work Centers
  SELECT objid, arbpl
    FROM crhd
    INTO TABLE @DATA(lt_crhd)
    FOR ALL ENTRIES IN @lt_afru
   WHERE objid EQ @lt_afru-arbid
     AND objty EQ @c_objty.

* Get Materials from Prod Order
  SELECT aufnr, plnbez, stlbez
    FROM afko
    INTO TABLE @DATA(lt_afko)
  FOR ALL ENTRIES IN @lt_afru
   WHERE aufnr EQ @lt_afru-aufnr.

  IF lt_crhd[] IS NOT INITIAL.
**  Get Hiearchy name of Work Center
    SELECT crhd~arbpl, crhh~name
      FROM crhd INNER JOIN crhs ON  crhd~objty EQ crhs~objty_ho
                                AND crhd~objid EQ crhs~objid_ho
                INNER JOIN crhh ON  crhh~objty EQ crhs~objty_hy
                                AND crhh~objid EQ crhs~objid_hy
      INTO TABLE @DATA(lt_crhs)
       FOR ALL ENTRIES IN @lt_crhd
     WHERE crhd~objty EQ @c_objty
       AND crhd~arbpl EQ @lt_crhd-arbpl
       AND crhd~begda LT @sy-datum
       AND crhd~endda GT @sy-datum
       AND crhd~werks EQ @p_werks.
  ENDIF.

  IF lt_crhs[] IS NOT INITIAL.
*   Get Areas from Hiearchy of Work Center
    SELECT areaid, hname, shiftid
      FROM zabsf_pp002
      INTO TABLE @DATA(lt_pp_sf002)
       FOR ALL ENTRIES IN @lt_crhs
     WHERE werks   EQ @p_werks
       AND hname   EQ @lt_crhs-name
       AND endda   GT @sy-datum
       AND begda   LT @sy-datum.
  ENDIF.

* Get causes by Work Center
  SELECT areaid, stprsnid, tip_respon
    FROM zabsf_pp011
    INTO TABLE @DATA(lt_pp_sf011)
     FOR ALL ENTRIES IN @lt_ficha_active
   WHERE werks    EQ @p_werks
     AND stprsnid EQ @lt_ficha_active-stprsnid
     AND endda    GT @sy-datum
     AND begda    LT @sy-datum
     AND inact    EQ @space.

* Get causes by Work Center and operation
  SELECT areaid, stprsnid, tip_respon
    FROM zabsf_pp015
    INTO TABLE @DATA(lt_pp_sf015)
     FOR ALL ENTRIES IN @lt_ficha_active
   WHERE werks    EQ @p_werks
     AND stprsnid EQ @lt_ficha_active-stprsnid
     AND endda    GT @sy-datum
     AND begda    LT @sy-datum.

  SORT lt_afko BY aufnr.

  READ TABLE lt_zlp_pp_sf032 INTO DATA(ls_zlp_pp_sf032) WITH KEY parid = 'CONST_TMP_PLANEADO'.
  IF sy-subrc = 0.
    lv_tmp_plan = ls_zlp_pp_sf032-parva.
  ENDIF.

  CLEAR ls_zlp_pp_sf032.
  READ TABLE lt_zlp_pp_sf032 INTO ls_zlp_pp_sf032 WITH KEY parid = 'CONST_TMP_PLANAJUST'.
  IF sy-subrc = 0.
    lv_planajust = ls_zlp_pp_sf032-parva.
  ENDIF.

  IF lt_pp_sf065[] IS NOT INITIAL.
*  Get regime descriptions
    SELECT regime_id, regime_desc
      FROM zabsf_pp062_t
      INTO TABLE @DATA(lt_sf062_t)
       FOR ALL ENTRIES IN @lt_pp_sf065
     WHERE werks     EQ @p_werks
       AND regime_id EQ @lt_pp_sf065-regime_id
       AND spras     EQ @sy-langu.
  ENDIF.

  LOOP AT lt_pp_sf065 INTO DATA(ls_pp_sf065).
    CLEAR gs_output.

    READ TABLE lt_afru INTO DATA(ls_afru) WITH KEY rueck = ls_pp_sf065-conf_no
                                                   rmzhl = ls_pp_sf065-conf_cnt
                       BINARY SEARCH.

*    Date - Get start time of Preparation or Production
    IF ls_afru-isdd IS NOT INITIAL AND ls_afru-isbd IS INITIAL.
      gs_output-tmp_data = ls_afru-isdd.
    ELSE.
      gs_output-tmp_data = ls_afru-isbd.
    ENDIF.

    gs_output-tmp_turno = ls_pp_sf065-shiftid.    "Shift ID
    gs_output-tmp_ficha = ls_pp_sf065-ficha.      "Card
    gs_output-tmp_regime = ls_pp_sf065-regime_id. "Regime ID

*  Read regime descriptions
    READ TABLE lt_sf062_t INTO DATA(ls_sf062_t) WITH KEY regime_id = ls_pp_sf065-regime_id.

    IF sy-subrc EQ 0.
*    Regime description
      gs_output-tmp_regime_desc = ls_sf062_t-regime_desc.
    ENDIF.

    gs_output-tmp_nroper  = ls_pp_sf065-oprid.    "Operator ID

*    Operator name
    SELECT SINGLE cname
      FROM pa0002
      INTO gs_output-tmp_nome
     WHERE pernr EQ ls_pp_sf065-oprid.

*    Work center
    READ TABLE lt_crhd INTO DATA(ls_crhd) WITH KEY objid = ls_afru-arbid.
    IF sy-subrc = 0.
      gs_output-tmp_centrotrab = ls_crhd-arbpl. "Work Center
    ENDIF.

*    Mould ID
    CALL FUNCTION 'Z_PP10_GET_MOULD'
      EXPORTING
        iv_aufpl = ls_afru-aufpl
        iv_aplzl = ls_afru-aplzl
        iv_werks = ls_afru-werks
      IMPORTING
        ev_equnr = gs_output-tmp_moldemanutencao.

*    Get material from Production Order
    READ TABLE lt_afko INTO DATA(ls_afko) WITH KEY aufnr = ls_afru-aufnr.
    IF sy-subrc = 0.
*    Material
      IF ls_afko-plnbez IS NOT INITIAL.
        gs_output-tmp_idmolde = ls_afko-plnbez.
      ELSE.
        gs_output-tmp_idmolde = ls_afko-stlbez.
      ENDIF.

*    Material description
      SELECT SINGLE maktx
        FROM makt
        INTO gs_output-tmp_dscmolde
       WHERE matnr EQ gs_output-tmp_idmolde
         AND spras EQ sy-langu.
    ENDIF.

**Special situation
    gs_output-tmp_sitespecial = ls_pp_sf065-sitespecial.

    LOOP AT lt_ficha_active INTO ls_ficha_active WHERE conf_no  EQ ls_pp_sf065-conf_no
                                                   AND werks    EQ ls_pp_sf065-werks
                                                   AND ficha    EQ ls_pp_sf065-ficha
                                                   AND oprid    EQ ls_pp_sf065-oprid.

      READ TABLE lt_afru INTO DATA(ls_afru_ficha) WITH KEY rueck = ls_ficha_active-conf_no
                                                          rmzhl = ls_ficha_active-conf_cnt
                                                          stokz = space
                                                          stzhl = space.
      IF sy-subrc = 0.

**gs_output-TMP_TTrab
        gs_output-tmp_ttrab = gs_output-tmp_ttrab + ( ls_afru_ficha-ism03 / ls_afru_ficha-anzma ).

*    Get stop time (TMP_TPara1; TMP_TPara2; TMP_TPara3)
        IF ls_ficha_active-stprsnid NE space.
          READ TABLE lt_crhs INTO DATA(ls_crhs) WITH KEY arbpl = ls_crhd-arbpl.
          IF sy-subrc = 0.

            READ TABLE lt_pp_sf002 INTO DATA(ls_pp_sf002) WITH KEY shiftid = ls_pp_sf065-shiftid
                                                                   hname = ls_crhs-name.

            IF sy-subrc = 0.
              READ TABLE lt_pp_sf011 INTO DATA(ls_pp_sf011) WITH KEY areaid = ls_pp_sf002-areaid
                                                                     stprsnid = ls_ficha_active-stprsnid.
              IF sy-subrc EQ 0.
                CASE ls_pp_sf011-tip_respon.
                  WHEN 'E'. "Company Responsibility
                    ADD ls_afru_ficha-iserh TO gs_output-tmp_tpara1.
                  WHEN 'O'. "Operator responsibility
                    ADD ls_afru_ficha-iserh TO gs_output-tmp_tpara3.
                  WHEN OTHERS. "W/ Responsibility
                    ADD ls_afru_ficha-iserh TO gs_output-tmp_tpara2.
                ENDCASE.
              ELSE.
                READ TABLE lt_pp_sf015 INTO DATA(ls_pp_sf015) WITH KEY areaid = ls_pp_sf002-areaid
                                                                       stprsnid = ls_ficha_active-stprsnid.
                IF sy-subrc EQ 0.
                  CASE ls_pp_sf015-tip_respon.
                    WHEN 'E'. "Company Responsibility
                      ADD ls_afru_ficha-iserh TO gs_output-tmp_tpara1.
                    WHEN 'O'. "Operator responsibility
                      ADD ls_afru_ficha-iserh TO gs_output-tmp_tpara3.
                    WHEN OTHERS. "W/ Responsibility
                      ADD ls_afru_ficha-iserh TO gs_output-tmp_tpara2.
                  ENDCASE.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.

**gs_output-TMP_Embalado
        ADD ls_afru_ficha-lmnga TO gs_output-tmp_embalado. "Quantity Packed

*    Quantity produced
        IF ls_afru_ficha-lmnga IS NOT INITIAL OR ls_afru_ficha-xmnga IS NOT INITIAL.
          ADD ls_afru_ficha-lmnga TO gs_output-tmp_producao. "Good quantity
          ADD ls_afru_ficha-xmnga TO gs_output-tmp_producao. "Scrap quantity
        ENDIF.

**gs_output-tmp_defeitos
        IF ls_afru_ficha-xmnga IS NOT INITIAL.
          ADD ls_afru_ficha-xmnga TO gs_output-tmp_defeitos. "Scarp quantity
        ENDIF.

      ENDIF.

***gs_output-TMP_Pend
*      LOOP AT lt_qals TRANSPORTING NO FIELDS WHERE charg = ls_ficha_active-charg.
*        ADD 1 TO gs_output-tmp_pend. "Pending boxes
*      ENDLOOP.

    ENDLOOP.

**gs_output-TMP_TCiclo
    gs_output-tmp_tciclo = ls_pp_sf065-time_mcycle. "Theorical Time Cicle
**gs_output-TMP_NRCav
    gs_output-tmp_nrcav = ls_pp_sf065-numb_mcycle.  "Theorical quantity by cycle


    IF gs_output-tmp_tciclo  <> 0.
**gs_output-TMP_Planeado
*   Planned quantity
      gs_output-tmp_planeado = ( gs_output-tmp_ttrab / gs_output-tmp_tciclo ) * gs_output-tmp_nrcav  * lv_tmp_plan.

**gs_output-TMP_PlanAjust
*   Planned Quantity Adjusted
      gs_output-tmp_planajust = ( ( gs_output-tmp_ttrab + gs_output-tmp_tpara3 ) / gs_output-tmp_tciclo ) * gs_output-tmp_nrcav  * lv_planajust.
    ENDIF.

**gs_output-TMP_Perc
*   Efficient Rate
    IF gs_output-tmp_planajust <> 0.
      gs_output-tmp_perc = gs_output-tmp_embalado / gs_output-tmp_planajust.
    ENDIF.

**gs_output-TMP_CicEmb
* Packed qty by cycle
    IF gs_output-tmp_nrcav <> 0.
      gs_output-tmp_cicemb = gs_output-tmp_embalado / gs_output-tmp_nrcav.
    ENDIF.

**gs_output-TMP_CicPAj
*   Adjusted Qty by cycle
    IF gs_output-tmp_nrcav <> 0.
      gs_output-tmp_cicpaj = gs_output-tmp_planajust / gs_output-tmp_nrcav.
    ENDIF.

    APPEND gs_output TO gt_output.
    CLEAR ls_afru.
  ENDLOOP.

  SORT gt_output BY tmp_data ASCENDING.

  LOOP AT gt_output ASSIGNING FIELD-SYMBOL(<fs_output>).
*  Counter for number lines in file
    ADD 1 TO l_count_id.
*  ID
    <fs_output>-tmp_id = l_count_id.

*>>> 16.01.2017 - PAP - For process Combi
    CLEAR ls_pp_sf062.

*  Check if regime type was relevant for combi
    SELECT SINGLE *
      FROM zabsf_pp062
      INTO @ls_pp_sf062
     WHERE regime_id  EQ @<fs_output>-tmp_regime
       AND div_reward EQ @abap_true.

    IF ls_pp_sf062 IS NOT INITIAL.
*    Operator Work Time (two Production Order processed in same time)
      <fs_output>-tmp_ttrab = <fs_output>-tmp_ttrab / 2.
    ENDIF.
*<<< 16.01.2017 - PAP - For process Combi
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CONFIRM_EXECUTION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM confirm_execution.
*Variables
  DATA: l_answer TYPE c.

*Pop up
  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      text_question  = TEXT-t04
    IMPORTING
      answer         = l_answer
    EXCEPTIONS
      text_not_found = 1
      OTHERS         = 2.

  IF l_answer EQ '1'.
    g_cont_proc = abap_false.
  ELSE.
    g_cont_proc = abap_true.
    RETURN.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_SCRAP_QUANTITY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_FICHA  text
*      -->P_CONF_NO  text
*      <--P_TMP_DEFEITOS  text
*----------------------------------------------------------------------*
FORM get_scrap_quantity  USING    p_conf_no
                                  p_werks
                                  p_ficha
                         CHANGING p_tmp_defeitos.


*Get all confirmations saved for carc
  SELECT DISTINCT conf_no, conf_cnt
    FROM zabsf_pp065
    INTO TABLE @DATA(lt_pp_sf065)
   WHERE conf_no EQ @p_conf_no
     AND werks   EQ @p_werks
     AND ficha   EQ @p_ficha.

*Get quantity scrap
  LOOP AT lt_pp_sf065 INTO DATA(ls_pp_sf065).
*  Get scrap quantity
    SELECT SINGLE xmnga
      FROM afru
      INTO (@DATA(l_xmnga))
     WHERE rueck EQ @ls_pp_sf065-conf_no
       AND rmzhl EQ @ls_pp_sf065-conf_cnt
       AND stokz EQ @space
       AND stzhl EQ @space.

    IF l_xmnga IS NOT INITIAL.
      ADD l_xmnga TO p_tmp_defeitos.
    ENDIF.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_QUANTITY_PRODUCED
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_CONF_NO  text
*      -->P_WERKS  text
*      -->P_FICHA  text
*      <--P_TMP_PRODUCAO  text
*----------------------------------------------------------------------*
FORM get_quantity_produced  USING    p_conf_no
                                     p_werks
                                     p_ficha
                            CHANGING p_tmp_producao.

*Get all confirmations saved for carc
  SELECT DISTINCT conf_no, conf_cnt
    FROM zabsf_pp065
    INTO TABLE @DATA(lt_pp_sf065)
   WHERE conf_no EQ @p_conf_no
     AND werks   EQ @p_werks
     AND ficha   EQ @p_ficha.

*Get quantity scrap and good quantity
  LOOP AT lt_pp_sf065 INTO DATA(ls_pp_sf065).
*  Get scrap quantity
    SELECT SINGLE lmnga, xmnga
      FROM afru
      INTO (@DATA(l_lmnga),@DATA(l_xmnga))
     WHERE rueck EQ @ls_pp_sf065-conf_no
       AND rmzhl EQ @ls_pp_sf065-conf_cnt
       AND stokz EQ @space
       AND stzhl EQ @space.

    IF l_lmnga IS NOT INITIAL OR l_xmnga IS NOT INITIAL.
*    Good quantity
      ADD l_lmnga TO p_tmp_producao.
*    Scrap quantity
      ADD l_xmnga TO p_tmp_producao.
    ENDIF.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_STOP_TIME
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_CONF_NO     text
*      -->P_WERKS       text
*      -->P_FICHA       text
*      -->P_CENTROTRAB  text
*      -->P_TURNO       text
*      <--P_TMP_TPARA1  text
*      <--P_TMP_TPARA2  text
*      <--P_TMP_TPARA3  text
*----------------------------------------------------------------------*
FORM get_stop_time  USING    p_conf_no
                             p_werks
                             p_ficha
                             p_centrotrab
                             p_turno
                    CHANGING p_tmp_tpara1
                             p_tmp_tpara2
                             p_tmp_tpara3.

*Structures
  DATA: ls_r_areaid TYPE /iwbep/s_sel_opt.

*Range
  DATA: r_areaid TYPE TABLE OF /iwbep/s_sel_opt.

*Constants
  CONSTANTS: c_objty TYPE cr_objty VALUE 'A'. "Work center

*Get hierarchy of Work center
  SELECT crhs~objty_hy, crhs~objid_hy
    FROM crhs AS crhs
   INNER JOIN crhd AS crhd
      ON crhd~objty EQ crhs~objty_ho
     AND crhd~objid EQ crhs~objid_ho
   WHERE crhd~objty EQ @c_objty
     AND crhd~arbpl EQ @p_centrotrab
     AND crhd~begda LT @sy-datum
     AND crhd~endda GT @sy-datum
     AND crhd~werks EQ @p_werks
    INTO TABLE @DATA(lt_crhs).

  IF lt_crhs[] IS NOT INITIAL.
*  Get hierarchy name
    SELECT name
      FROM crhh
      INTO TABLE @DATA(lt_crhh)
       FOR ALL ENTRIES IN @lt_crhs
     WHERE objty EQ @lt_crhs-objty_hy
       AND objid EQ @lt_crhs-objid_hy.

    IF lt_crhh[] IS NOT INITIAL.
*    Get area ID
      SELECT DISTINCT areaid
        FROM zabsf_pp002
        INTO TABLE @DATA(lt_pp_sf002)
         FOR ALL ENTRIES IN @lt_crhh
       WHERE werks   EQ @p_werks
         AND shiftid EQ @p_turno
         AND hname   EQ @lt_crhh-name
         AND endda   GT @sy-datum
         AND begda   LT @sy-datum.

      LOOP AT lt_pp_sf002 INTO DATA(ls_pp_sf002).
        CLEAR ls_r_areaid.
        ls_r_areaid-sign = 'I'.
        ls_r_areaid-opt = 'EQ'.
        ls_r_areaid-low = ls_pp_sf002-areaid.

        APPEND ls_r_areaid TO r_areaid.
      ENDLOOP.
    ENDIF.
  ENDIF.

*Get all confirmations saved for carc
  SELECT DISTINCT conf_no, conf_cnt, stprsnid
    FROM zabsf_pp065
    INTO TABLE @DATA(lt_pp_sf065)
   WHERE conf_no  EQ @p_conf_no
     AND werks    EQ @p_werks
     AND ficha    EQ @p_ficha
     AND stprsnid NE @space.

*Get break time
  LOOP AT lt_pp_sf065 INTO DATA(ls_pp_sf065).
*  Get break time
    SELECT SINGLE iserh
      FROM afru
      INTO (@DATA(l_iserh))
     WHERE rueck EQ @ls_pp_sf065-conf_no
       AND rmzhl EQ @ls_pp_sf065-conf_cnt
       AND stokz EQ @space
       AND stzhl EQ @space.

*  Check responsibility of stop reason
    SELECT SINGLE tip_respon
      FROM zabsf_pp011
      INTO (@DATA(l_tip_respon_w))
     WHERE areaid   IN @r_areaid
       AND werks    EQ @p_werks
*       AND arbpl    EQ @p_centrotrab
       AND stprsnid EQ @ls_pp_sf065-stprsnid
       AND endda    GT @sy-datum
       AND begda    LT @sy-datum
       AND inact    EQ @space.

    IF sy-subrc EQ 0.
      CASE l_tip_respon_w.
        WHEN 'E'. "Company Responsibility
          ADD l_iserh TO p_tmp_tpara1.
        WHEN 'O'. "Operator responsibility
          ADD l_iserh TO p_tmp_tpara3.
        WHEN OTHERS. "W/ Responsibility
          ADD l_iserh TO p_tmp_tpara2.
      ENDCASE.
    ENDIF.

*  Check responsibility of stop reason
    SELECT SINGLE tip_respon
      FROM zabsf_pp015
      INTO (@DATA(l_tip_respon_o))
     WHERE areaid   IN @r_areaid
       AND werks    EQ @p_werks
*       AND arbpl    EQ @p_centrotrab
       AND stprsnid EQ @ls_pp_sf065-stprsnid
       AND endda    GT @sy-datum
       AND begda    LT @sy-datum.

    IF sy-subrc EQ 0.
      CASE l_tip_respon_o.
        WHEN 'E'. "Company Responsibility
          ADD l_iserh TO p_tmp_tpara1.
        WHEN 'O'. "Operator responsibility
          ADD l_iserh TO p_tmp_tpara3.
        WHEN OTHERS. "W/ Responsibility
          ADD l_iserh TO p_tmp_tpara2.
      ENDCASE.
    ENDIF.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_CARD_RELEVANT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--LT_FICHA_ACTIVE  text
*----------------------------------------------------------------------*
FORM get_card_relevant CHANGING lt_ficha_active TYPE ANY TABLE.
*Internal table
  DATA: lt_ficha_active_temp TYPE TABLE OF zabsf_pp065.

*Constants
  CONSTANTS: c_objty TYPE cr_objty VALUE 'A'. "Work center

*Move to temporary internal table
  MOVE lt_ficha_active[] TO lt_ficha_active_temp[].

*Get detail of card - Additional data
  SELECT conf_no, conf_cnt, ficha
    FROM zabsf_pp065
    INTO TABLE @DATA(lt_pp_sf065)
    FOR ALL ENTRIES IN @lt_ficha_active_temp
   WHERE conf_no EQ @lt_ficha_active_temp-conf_no
     AND oprid   EQ @lt_ficha_active_temp-oprid
     AND ficha   EQ @lt_ficha_active_temp-ficha.

  IF lt_pp_sf065[] IS NOT INITIAL.
*  Get work centers for all confirmation
    SELECT DISTINCT rueck, rmzhl, arbid
      FROM afru
      INTO TABLE @DATA(lt_afru)
       FOR ALL ENTRIES IN @lt_pp_sf065
     WHERE rueck EQ @lt_pp_sf065-conf_no
       AND rmzhl EQ @lt_pp_sf065-conf_cnt
       AND stokz EQ @space
       AND stzhl EQ @space.

    IF lt_afru[] IS NOT INITIAL.

      LOOP AT lt_afru INTO DATA(ls_afru).
*      Check if work center was relevant for calculation
        SELECT SINGLE crhd~mandt
          FROM crhd AS crhd
         INNER JOIN zabsf_pp067 AS sf067
            ON sf067~werks EQ crhd~werks
           AND sf067~veran EQ crhd~veran
         WHERE crhd~objty EQ @c_objty
           AND crhd~objid EQ @ls_afru-arbid
           AND crhd~werks EQ @p_werks
           AND sf067~kpi  NE @space
          INTO @sy-mandt.

        IF sy-subrc NE 0.

        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CREATE_FILENAME
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_FILE_SEPARATOR  text
*      <--P_FILENAME  text
*----------------------------------------------------------------------*
FORM create_filename  USING    p_file_separator
                      CHANGING p_filename.


  IF p_save IS NOT INITIAL.
    CONCATENATE p_direct p_file_separator sy-datlo '-' sy-timlo '_REG' '.csv' INTO p_filename.
  ELSE.
    CONCATENATE p_direct p_file_separator sy-datlo '-' sy-timlo '_SIM' '.csv' INTO p_filename.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SAVE_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_FILENAME  text
*----------------------------------------------------------------------*
FORM save_file  USING    p_filename.
  DATA filename            TYPE string.
  DATA: i_tab_converted_data  TYPE truxs_t_text_data.
*  DATA: gt_comp TYPE abap_component_tab.

  DATA: r_descr TYPE REF TO cl_abap_structdescr.
*        wa_comp TYPE abap_compdescr,
*        gs_comp TYPE abap_componentdescr.


  DATA lt_csv TYPE TABLE OF ty_csv.
  DATA ls_csv TYPE ty_csv.

  DATA: lv_string TYPE string.

  FIELD-SYMBOLS: <fs_wa>  TYPE any,
                 <fs_wa1> TYPE any.

  filename = p_filename.

  r_descr ?= cl_abap_typedescr=>describe_by_data( gs_output ).

  LOOP AT r_descr->components INTO DATA(ls_comp).

    IF sy-tabix EQ 1.
      lv_string = ls_comp-name.
    ELSE.
      CONCATENATE lv_string ';' ls_comp-name INTO lv_string.
    ENDIF.
  ENDLOOP.

  ls_csv-line = lv_string.
  APPEND ls_csv TO lt_csv.

  PERFORM convert_data_csv TABLES lt_csv
                            USING r_descr->components.

  CALL FUNCTION 'SAP_CONVERT_TO_CSV_FORMAT'
    EXPORTING
*     I_FIELD_SEPERATOR    = ';'
*     i_line_header        = 'X'
      i_filename           = p_filename
*     I_APPL_KEEP          = ' '
    TABLES
      i_tab_sap_data       = gt_output
    CHANGING
      i_tab_converted_data = i_tab_converted_data
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.

  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.



*  CALL METHOD cl_gui_frontend_services=>gui_download
*    EXPORTING
*      filename              = filename
*      filetype              = 'ASC'
*      write_field_separator = ' '
*    CHANGING
*      data_tab              = lt_csv[].
*
  CALL METHOD cl_gui_frontend_services=>gui_download
    EXPORTING
      filename              = filename
      filetype              = 'ASC'
      append                = 'X'
      write_field_separator = 'X'
    CHANGING
      data_tab              = lt_csv[].


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SAVE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM save_data .

  DATA: lt_card_proc TYPE TABLE OF zabsf_card_proc,
        ls_card_proc TYPE          zabsf_card_proc,
        oref         TYPE REF TO cx_root,
        text         TYPE string.

*Constants
  CONSTANTS: c_proc_conc TYPE zabsf_status VALUE 'P', "Processing completed
             c_in_proc   TYPE zabsf_status VALUE 'E', "Processing
             c_re_proc   TYPE zabsf_status VALUE 'R'. "Reprocessed

  DATA(lv_date_proc) = sy-datum.

  SELECT werks, ficha, oprid, status
    INTO TABLE @DATA(lt_card_proc_ctrl)
    FROM zabsf_card_proc
     FOR ALL ENTRIES IN @gt_output
   WHERE werks      EQ @p_werks
     AND ficha      EQ @gt_output-tmp_ficha
     AND tmp_nroper EQ @gt_output-tmp_nroper.

  SORT lt_card_proc_ctrl BY werks ficha oprid.

  LOOP AT gt_output INTO DATA(ls_output). "WHERE tmp_pend = 0.
    MOVE-CORRESPONDING ls_output TO ls_card_proc.
    ls_card_proc-werks     = p_werks.
    ls_card_proc-ficha     = ls_output-tmp_ficha.
    ls_card_proc-oprid     = ls_output-tmp_nroper.
    ls_card_proc-date_proc = lv_date_proc.
    ls_card_proc-uname     = sy-uname.
    ls_card_proc-mandt     = sy-mandt.

    IF p_save = 'X'.
      ls_card_proc-status = c_proc_conc.
    ELSE.
      READ TABLE lt_card_proc_ctrl INTO DATA(ls_card_proc_ctrl) WITH KEY werks = p_werks
                                                                         ficha = ls_output-tmp_ficha
                                                                         oprid = ls_output-tmp_nroper.
      IF sy-subrc = 0 .
        ls_card_proc-status = c_re_proc.
      ELSE.
        ls_card_proc-status = c_in_proc.
      ENDIF.

    ENDIF.
    APPEND ls_card_proc TO lt_card_proc.

  ENDLOOP.
  TRY .
      MODIFY zabsf_card_proc FROM TABLE lt_card_proc.
      IF sy-subrc = 0.
        COMMIT WORK.
      ELSE.
        ROLLBACK WORK.
      ENDIF.
    CATCH cx_sy_open_sql_db INTO oref.
      text = oref->get_text( ).
      ROLLBACK WORK.
  ENDTRY.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CONVERT_DATA_CSV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LT_CSV  text
*      -->P_R_DESCR_>COMPONENTS  text
*----------------------------------------------------------------------*
FORM convert_data_csv  TABLES   pt_csv STRUCTURE gs_csv
                       USING    pt_components TYPE abap_compdescr_tab.

  DATA: ls_csv       TYPE ty_csv,
        lv_p         TYPE p,
        lv_field(30) TYPE c,
        c_number(12) TYPE c VALUE '1234567890 '.

  FIELD-SYMBOLS: <fs_field>.

  SELECT SINGLE *
    FROM usr01
    INTO @DATA(ls_usr01)
   WHERE bname EQ @sy-uname.

  LOOP AT gt_output INTO DATA(ls_output)." WHERE tmp_pend = 0.
    CLEAR ls_csv.
    LOOP AT pt_components INTO DATA(ls_comp).
      CLEAR lv_field.

      ASSIGN COMPONENT ls_comp-name OF STRUCTURE ls_output TO <fs_field>.

      CHECK <fs_field> IS ASSIGNED.

      CASE ls_comp-type_kind.
        WHEN 'D'. "Date
          CONCATENATE <fs_field>+6(2) '-'
                      <fs_field>+4(2) '-'
                      <fs_field>(4)
          INTO lv_field.
        WHEN 'F'. "Float
          IF <fs_field> = 0.
            lv_p = 0.
            lv_field = lv_p.
            REPLACE ALL OCCURRENCES OF '.' IN lv_field WITH ','.
          ELSE.
            CALL FUNCTION 'FLTP_CHAR_CONVERSION'
              EXPORTING
                input = <fs_field>
              IMPORTING
                flstr = lv_field.
          ENDIF.

          CASE ls_usr01-dcpfm.
            WHEN space. " 1.234 567,89
              REPLACE ALL OCCURRENCES OF '.' IN lv_field WITH ''.
            WHEN 'X'.   " 1,234,567.89
              REPLACE ALL OCCURRENCES OF ',' IN lv_field WITH ''.
              REPLACE ALL OCCURRENCES OF '.' IN lv_field WITH ','.
            WHEN 'Y'.  " 1 234 567,89
              REPLACE ALL OCCURRENCES OF ' ' IN lv_field WITH ''.
          ENDCASE.

        WHEN 'P'.
          lv_field = <fs_field>.
          REPLACE ALL OCCURRENCES OF '.' IN lv_field WITH ','.
        WHEN 'N'.
          WRITE <fs_field> TO lv_field.
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
            EXPORTING
              input  = <fs_field>
            IMPORTING
              output = lv_field.
        WHEN 'I'.
          lv_field = <fs_field>.
        WHEN OTHERS.
          WRITE <fs_field> TO lv_field.
      ENDCASE.
      IF lv_field CO c_number.
        CONDENSE lv_field NO-GAPS.
      ELSE.
        CONDENSE lv_field.
      ENDIF.

      IF ls_csv IS INITIAL.
        MOVE lv_field TO ls_csv-line.
      ELSE.
        CONCATENATE ls_csv-line ';' lv_field INTO ls_csv-line.
      ENDIF.

      UNASSIGN <fs_field>.

    ENDLOOP.

    IF ls_csv IS NOT INITIAL.
      APPEND ls_csv TO pt_csv.
    ENDIF.

  ENDLOOP.

ENDFORM.
