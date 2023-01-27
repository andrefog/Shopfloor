*----------------------------------------------------------------------*
***INCLUDE Z_LP_PP_SF_MATNR_COCKPIT_F01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  CREATE_F4_FIELD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_C_AREA  text
*      -->P_C_VORG  text
*      -->P_C_AREA_DYN  text
*      -->P_PA_AREA  text
*      -->P_IT_AREA  text
*----------------------------------------------------------------------*
FORM create_f4_field  USING p_retfield p_val_org p_dyn_field so_option p_it TYPE STANDARD TABLE.

  DATA: it_return TYPE TABLE OF ddshretval,
        wa_return TYPE ddshretval.

  REFRESH it_return.
  CLEAR wa_return.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = p_retfield
      value_org       = p_val_org
      dynpprog        = sy-cprog
      dynpnr          = sy-dynnr
      dynprofield     = p_dyn_field
    TABLES
      value_tab       = p_it
      return_tab      = it_return
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.
ENDFORM.                    " CREATE_F4_FIELD
*&---------------------------------------------------------------------*
*&      Form  INIT_VARIABLES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM init_variables .
  REFRESH gt_alv.
ENDFORM.                    " INIT_VARIABLES
*&---------------------------------------------------------------------*
*&      Form  GET_TIME_PROD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_time_prod .
  DATA: lt_zafru TYPE TABLE OF zabsf_pp016,
        lt_afko  TYPE TABLE OF afko,
        lt_makt  TYPE TABLE OF makt.

  DATA: ls_zafru TYPE zabsf_pp016,
        ls_afko  TYPE afko,
        ls_alv   TYPE zabsf_pp_s_matnr_alv,
        ls_makt  TYPE makt.

  DATA: r_aufnr  TYPE RANGE OF aufnr,
        wa_aufnr LIKE LINE OF r_aufnr.

  REFRESH: lt_zafru,
           lt_afko,
           lt_makt,
           r_aufnr.

  CLEAR: ls_zafru,
         ls_afko,
         ls_makt,
         ls_alv,
         wa_aufnr.

*Get production order
  SELECT *
    FROM zabsf_pp016
    INTO CORRESPONDING FIELDS OF TABLE lt_zafru
   WHERE areaid EQ pa_area
     AND iebd IN so_date.

*Get production order for material
  SELECT aufnr stlbez
    FROM afko
    INTO CORRESPONDING FIELDS OF TABLE lt_afko
     FOR ALL ENTRIES IN lt_zafru
   WHERE aufnr  EQ lt_zafru-aufnr
     AND stlbez IN so_matnr.

*Get material descriptions
  SELECT matnr maktx
    FROM makt
    INTO CORRESPONDING FIELDS OF TABLE lt_makt
     FOR ALL ENTRIES IN lt_afko
   WHERE matnr EQ lt_afko-stlbez
     AND spras EQ sy-langu.

*Create range for production order
  LOOP AT lt_afko INTO ls_afko.
    CLEAR wa_aufnr.

    wa_aufnr-sign = 'I'.
    wa_aufnr-option = 'EQ'.
    wa_aufnr-low = ls_afko-aufnr.

    APPEND wa_aufnr TO r_aufnr.
  ENDLOOP.

  SORT r_aufnr.

  DELETE ADJACENT DUPLICATES FROM r_aufnr.

*Delete order with no match with material
  DELETE lt_zafru WHERE aufnr NOT IN r_aufnr.

  CLEAR ls_zafru.

  LOOP AT lt_zafru INTO ls_zafru.
    CLEAR: ls_alv,
           ls_makt,
           ls_afko.

*  Area
    ls_alv-areaid = pa_area.

*  Material
    READ TABLE lt_afko INTO ls_afko WITH KEY aufnr = ls_zafru-aufnr.

    IF sy-subrc EQ 0.
      ls_alv-matnr = ls_afko-stlbez.

*    Material description
      READ TABLE lt_makt INTO ls_makt WITH KEY matnr = ls_afko-stlbez.

      IF sy-subrc EQ 0.
        ls_alv-maktx = ls_makt-maktx.
      ENDIF.
    ENDIF.

*  Date
    ls_alv-data = ls_zafru-iebd.
*  Production order
    ls_alv-aufnr = ls_zafru-aufnr.
*  Production time
    IF ls_zafru-ism02 IS NOT INITIAL AND ls_zafru-ism03 IS INITIAL.
      ls_alv-prodtime = ls_zafru-ism02.
*    Unidade
      ls_alv-unit = ls_zafru-ile02.
    ELSEIF ls_zafru-ism02 IS NOT INITIAL AND ls_zafru-ism03 IS NOT INITIAL.
      ls_alv-prodtime = ls_zafru-ism02.
*    Unidade
      ls_alv-unit = ls_zafru-ile02.
    ELSE.
      ls_alv-prodtime = ls_zafru-ism03.
*    Unidade
      ls_alv-unit = ls_zafru-ile03.
    ENDIF.

    APPEND ls_alv TO gt_alv.
  ENDLOOP.
ENDFORM.                    " GET_TIME_PROD
*&---------------------------------------------------------------------*
*&      Form  GET_TIME_STOP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_time_stop .
  DATA: lt_zafru     TYPE TABLE OF zabsf_pp016,
        lt_afko      TYPE TABLE OF afko,
        lt_stop_desc TYPE TABLE OF zabsf_pp015_t,
        lt_makt      TYPE TABLE OF makt.

  DATA: ls_zafru     TYPE zabsf_pp016,
        ls_afko      TYPE afko,
        ls_alv       TYPE zabsf_pp_s_matnr_alv,
        ls_stop_desc TYPE zabsf_pp015_t,
        ls_makt      TYPE makt.

  DATA: r_aufnr  TYPE RANGE OF aufnr,
        wa_aufnr LIKE LINE OF r_aufnr.

  REFRESH: lt_zafru,
           lt_afko,
           lt_stop_desc,
           lt_makt,
           r_aufnr.

  CLEAR: ls_zafru,
         ls_afko,
         ls_alv,
         ls_stop_desc,
         ls_makt,
         wa_aufnr.

*Get stop reason description
  SELECT *
    FROM zabsf_pp015_t
    INTO CORRESPONDING FIELDS OF TABLE lt_stop_desc
   WHERE areaid EQ pa_area
     AND spras EQ sy-langu.

*Get production order
  SELECT *
    FROM zabsf_pp016
    INTO CORRESPONDING FIELDS OF TABLE lt_zafru
   WHERE areaid EQ pa_area
     AND iebd IN so_date.

*Get production order for material
  SELECT aufnr stlbez
    FROM afko
    INTO CORRESPONDING FIELDS OF TABLE lt_afko
     FOR ALL ENTRIES IN lt_zafru
   WHERE aufnr  EQ lt_zafru-aufnr
     AND stlbez IN so_matnr.

*Get material descriptions
  SELECT matnr maktx
    FROM makt
    INTO CORRESPONDING FIELDS OF TABLE lt_makt
     FOR ALL ENTRIES IN lt_afko
   WHERE matnr EQ lt_afko-stlbez
     AND spras EQ sy-langu.

*Create range for production order
  LOOP AT lt_afko INTO ls_afko.
    CLEAR wa_aufnr.

    wa_aufnr-sign = 'I'.
    wa_aufnr-option = 'EQ'.
    wa_aufnr-low = ls_afko-aufnr.

    APPEND wa_aufnr TO r_aufnr.
  ENDLOOP.

  SORT r_aufnr.

  DELETE ADJACENT DUPLICATES FROM r_aufnr.

*Delete order with no match with material
  DELETE lt_zafru WHERE aufnr NOT IN r_aufnr.

  CLEAR ls_zafru.

  LOOP AT lt_zafru INTO ls_zafru.
    CLEAR: ls_alv,
           ls_stop_desc,
           ls_makt,
           ls_afko.

*  Area
    ls_alv-areaid = pa_area.

*  Material
    READ TABLE lt_afko INTO ls_afko WITH KEY aufnr = ls_zafru-aufnr.

    IF sy-subrc EQ 0.
      ls_alv-matnr = ls_afko-stlbez.

*    Material description
      READ TABLE lt_makt INTO ls_makt WITH KEY matnr = ls_afko-stlbez.

      IF sy-subrc EQ 0.
        ls_alv-maktx = ls_makt-maktx.
      ENDIF.
    ENDIF.

*  Date
    ls_alv-data = ls_zafru-iebd.
*  Production order
    ls_alv-aufnr = ls_zafru-aufnr.
*   Stop reason description
    READ TABLE lt_stop_desc INTO ls_stop_desc WITH KEY stprsnid = ls_zafru-stprsnid.

    IF  sy-subrc EQ 0.
      ls_alv-stprsn_desc = ls_stop_desc-stprsn_desc.
    ENDIF.

    ls_alv-stoptime = ls_zafru-stoptime.

    APPEND ls_alv TO gt_alv.
  ENDLOOP.

*>>>PAP - Correcções - 20.05.2015
*  Delete lines with zeros stoptime
  DELETE gt_alv WHERE stoptime EQ 0.
*<<<PAP - Correcções - 20.05.2015
ENDFORM.                    " GET_TIME_STOP
*&---------------------------------------------------------------------*
*&      Form  GET_TIME_SCRAP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_qtd_scrap .
  DATA: lt_afru   TYPE TABLE OF afru,
        lt_afko   TYPE TABLE OF afko,
        lt_reason TYPE TABLE OF trugt,
        lt_makt   TYPE TABLE OF makt.

  DATA: ls_afru   TYPE afru,
        ls_afko   TYPE afko,
        ls_alv    TYPE zabsf_pp_s_matnr_alv,
        ls_reason TYPE trugt,
        ls_makt   TYPE makt.

  DATA: r_aufnr  TYPE RANGE OF aufnr,
        wa_aufnr LIKE LINE OF r_aufnr.

  REFRESH: lt_afru,
           lt_afko,
           lt_reason,
           lt_makt,
           r_aufnr.

  CLEAR: ls_afru,
         ls_afko,
         ls_alv,
         ls_reason,
         ls_makt,
         wa_aufnr.

*Reason for variances in completion confirmations
  SELECT grund grdtx
    FROM trugt
    INTO CORRESPONDING FIELDS OF TABLE lt_reason
    WHERE werks EQ pa_werks
      AND spras EQ sy-langu.

*Get production order
  SELECT *
    FROM afru
    INTO CORRESPONDING FIELDS OF TABLE lt_afru
   WHERE iebd IN so_date
     AND grund NE space.

*Get production order for material
  SELECT aufnr stlbez
    FROM afko
    INTO CORRESPONDING FIELDS OF TABLE lt_afko
     FOR ALL ENTRIES IN lt_afru
   WHERE aufnr  EQ lt_afru-aufnr
     AND stlbez IN so_matnr.

*Get material descriptions
  SELECT matnr maktx
    FROM makt
    INTO CORRESPONDING FIELDS OF TABLE lt_makt
     FOR ALL ENTRIES IN lt_afko
   WHERE matnr EQ lt_afko-stlbez
     AND spras EQ sy-langu.

*Create range for production order
  LOOP AT lt_afko INTO ls_afko.
    CLEAR wa_aufnr.

    wa_aufnr-sign = 'I'.
    wa_aufnr-option = 'EQ'.
    wa_aufnr-low = ls_afko-aufnr.

    APPEND wa_aufnr TO r_aufnr.
  ENDLOOP.

  SORT r_aufnr.

  DELETE ADJACENT DUPLICATES FROM r_aufnr.

*Delete order with no match with material
  DELETE lt_afru WHERE aufnr NOT IN r_aufnr.

  CLEAR ls_afru.

  LOOP AT lt_afru INTO ls_afru.
    CLEAR: ls_alv,
           ls_reason,
           ls_makt,
           ls_afko.

*  Area
    ls_alv-areaid = pa_area.

*  Material
    READ TABLE lt_afko INTO ls_afko WITH KEY aufnr = ls_afru-aufnr.

    IF sy-subrc EQ 0.
      ls_alv-matnr = ls_afko-stlbez.

*    Material description
      READ TABLE lt_makt INTO ls_makt WITH KEY matnr = ls_afko-stlbez.

      IF sy-subrc EQ 0.
        ls_alv-maktx = ls_makt-maktx.
      ENDIF.
    ENDIF.

*  Date
    ls_alv-data = ls_afru-iebd.
*  Production order
    ls_alv-aufnr = ls_afru-aufnr.
*   Stop reason description
    READ TABLE lt_reason INTO ls_reason WITH KEY grund = ls_afru-grund.

    IF  sy-subrc EQ 0.
      ls_alv-grdtx = ls_reason-grdtx.
    ENDIF.

    ls_alv-scrap = ls_afru-xmnga.

    APPEND ls_alv TO gt_alv.
  ENDLOOP.
ENDFORM.                    " GET_TIME_SCRAP
*&---------------------------------------------------------------------*
*&      Form  GET_TIME_REWRK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_qtd_rewrk .
  DATA: lt_rework  TYPE TABLE OF zabsf_pp004,
        lt_afko    TYPE TABLE OF afko,
        lt_defects TYPE TABLE OF zabsf_pp026_t,
        lt_makt    TYPE TABLE OF makt.

  DATA: ls_rework  TYPE zabsf_pp004,
        ls_afko    TYPE afko,
        ls_alv     TYPE zabsf_pp_s_matnr_alv,
        ls_defects TYPE zabsf_pp026_t,
        ls_makt    TYPE makt.

  DATA: r_aufnr  TYPE RANGE OF aufnr,
        wa_aufnr LIKE LINE OF r_aufnr.

  REFRESH: lt_rework,
           lt_afko,
           lt_defects,
           lt_makt,
           r_aufnr.

  CLEAR: ls_rework,
         ls_afko,
         ls_alv,
         ls_defects,
         ls_makt,
         wa_aufnr.

*Reason for variances in completion confirmations
  SELECT defectid defect_desc
    FROM zabsf_pp026_t
    INTO CORRESPONDING FIELDS OF TABLE lt_defects
    WHERE areaid EQ pa_area
      AND werks  EQ pa_werks
      AND spras  EQ sy-langu.

*Get production order
  SELECT *
    FROM zabsf_pp004
    INTO CORRESPONDING FIELDS OF TABLE lt_rework
   WHERE data IN so_date.

*Get production order for material
  SELECT aufnr stlbez
    FROM afko
    INTO CORRESPONDING FIELDS OF TABLE lt_afko
     FOR ALL ENTRIES IN lt_rework
   WHERE aufnr  EQ lt_rework-aufnr
     AND stlbez IN so_matnr.

*Get material descriptions
  SELECT matnr maktx
    FROM makt
    INTO CORRESPONDING FIELDS OF TABLE lt_makt
     FOR ALL ENTRIES IN lt_afko
   WHERE matnr EQ lt_afko-stlbez
     AND spras EQ sy-langu.

*Create range for production order
  LOOP AT lt_afko INTO ls_afko.
    CLEAR wa_aufnr.

    wa_aufnr-sign = 'I'.
    wa_aufnr-option = 'EQ'.
    wa_aufnr-low = ls_afko-aufnr.

    APPEND wa_aufnr TO r_aufnr.
  ENDLOOP.

  SORT r_aufnr.

  DELETE ADJACENT DUPLICATES FROM r_aufnr.

*Delete order with no match with material
  DELETE lt_rework WHERE aufnr NOT IN r_aufnr.

  CLEAR ls_rework.

  LOOP AT lt_rework INTO ls_rework.
    CLEAR: ls_alv,
           ls_afko,
           ls_defects,
           ls_makt.

*  Area
    ls_alv-areaid = pa_area.

*  Material
    READ TABLE lt_afko INTO ls_afko WITH KEY aufnr = ls_rework-aufnr.

    IF sy-subrc EQ 0.
      ls_alv-matnr = ls_afko-stlbez.

*    Material description
      READ TABLE lt_makt INTO ls_makt WITH KEY matnr = ls_afko-stlbez.

      IF sy-subrc EQ 0.
        ls_alv-maktx = ls_makt-maktx.
      ENDIF.
    ENDIF.

*  Date
    ls_alv-data = ls_rework-data.
*  Production order
    ls_alv-aufnr = ls_rework-aufnr.
*   Stop reason description
    READ TABLE lt_defects INTO ls_defects WITH KEY defectid = ls_rework-defectid.

    IF  sy-subrc EQ 0.
      ls_alv-defect_desc = ls_defects-defect_desc.
    ENDIF.

    ls_alv-rework = ls_rework-rework.

    APPEND ls_alv TO gt_alv.
  ENDLOOP.
ENDFORM.                    " GET_TIME_REWRK
