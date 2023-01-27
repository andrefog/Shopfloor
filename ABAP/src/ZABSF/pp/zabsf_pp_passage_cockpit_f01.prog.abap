*&---------------------------------------------------------------------*
*&  Include           Z_LP_PP_SF_PASSAGE_COCKPIT_F01
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

ENDFORM.                    " INIT_VARIABLES
*&---------------------------------------------------------------------*
*&      Form  GET_PASSAGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_passage .

  DATA: lt_passage TYPE TABLE OF zabsf_pp047,
        lt_makt    TYPE TABLE OF makt.

  DATA: ls_passage TYPE zabsf_pp047,
        ls_alv     TYPE zabsf_pp_s_passage_alv,
        ls_makt    TYPE makt.

  DATA: lv_char1(1) TYPE c,
        lv_char2(2) TYPE c.

  REFRESH: lt_passage,
           lt_makt.

  CLEAR: lv_char1,
         lv_char2,
         ls_passage,
         ls_makt.

*  lv_char1 = pa_opt(1).
*  lv_char2 = pa_opt+1(2).
*
*  TRANSLATE lv_char2 TO LOWER CASE.
*
*  CLEAR pa_opt.
*
*  CONCATENATE lv_char1 lv_char2 INTO pa_opt.

*Get details of passage
  SELECT *
    FROM zabsf_pp047
    INTO CORRESPONDING FIELDS OF TABLE lt_passage
   WHERE areaid     EQ pa_area
     AND matnr      IN so_matnr
     AND gernr      IN so_gernr
     AND result_def IN so_opt
     AND date_reg   IN so_date.

  IF lt_passage[] IS NOT INITIAL.
*  Get material descriptions
    SELECT matnr maktx
      FROM makt
      INTO CORRESPONDING FIELDS OF TABLE lt_makt
       FOR ALL ENTRIES IN lt_passage
     WHERE matnr EQ lt_passage-matnr
       AND spras EQ sy-langu.

*  MOVE lt_passage[] TO gt_alv[].

    LOOP AT lt_passage INTO ls_passage.
      CLEAR: ls_makt,
             ls_alv.

      MOVE-CORRESPONDING ls_passage TO ls_alv.

*    Material description
      READ TABLE lt_makt INTO ls_makt WITH KEY matnr = ls_passage-matnr.

      IF sy-subrc EQ 0.
        ls_alv-maktx = ls_makt-maktx.
      ENDIF.

      APPEND ls_alv TO gt_alv.
    ENDLOOP.
  ENDIF.
ENDFORM.                    " GET_PASSAGE
