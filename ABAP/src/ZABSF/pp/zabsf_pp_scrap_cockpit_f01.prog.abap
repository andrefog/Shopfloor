*&---------------------------------------------------------------------*
*&  Include           Z_LP_PP_SF_SCRAP_COCKPIT_F01
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
  REFRESH gt_alv.
ENDFORM.                    " INIT_VARIABLES
*&---------------------------------------------------------------------*
*&      Form  GET_SCRAP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_scrap .
  DATA: lt_scrap  TYPE TABLE OF zabsf_pp034,
        lt_reason TYPE TABLE OF trugt,
        lt_makt   TYPE TABLE OF makt.

  DATA: ls_reason TYPE trugt,
        ls_scrap  TYPE zabsf_pp034,
        ls_alv    TYPE zabsf_pp_s_scrap_alv,
        ls_makt   TYPE makt.

  REFRESH: lt_scrap,
           lt_reason,
           lt_makt.

  CLEAR: ls_reason,
         ls_alv,
         ls_makt.

*Reason for variances in completion confirmations
  SELECT grund grdtx
    FROM trugt
    INTO CORRESPONDING FIELDS OF TABLE lt_reason
    WHERE werks EQ c_werks
      AND spras EQ sy-langu.

*Get scrap
  SELECT *
    FROM zabsf_pp034
    INTO CORRESPONDING FIELDS OF TABLE lt_scrap
   WHERE areaid EQ pa_area
     AND wareid IN so_ware
     AND matnr  IN so_matnr
     AND data   IN so_date.

  IF lt_scrap[] IS NOT INITIAL.
*  Get material descriptions
    SELECT matnr maktx
      FROM makt
      INTO CORRESPONDING FIELDS OF TABLE lt_makt
       FOR ALL ENTRIES IN lt_scrap
     WHERE matnr EQ lt_scrap-matnr
       AND spras EQ sy-langu.

    LOOP AT lt_scrap INTO ls_scrap.
      CLEAR: ls_alv,
             ls_makt,
             ls_reason.

      MOVE-CORRESPONDING ls_scrap TO ls_alv.

*    Stop reason description
      READ TABLE lt_reason INTO ls_reason WITH KEY grund = ls_scrap-grund.

      IF  sy-subrc EQ 0.
        ls_alv-grdtx = ls_reason-grdtx.
      ENDIF.

*    Material description
      READ TABLE lt_makt INTO ls_makt WITH KEY matnr = ls_scrap-matnr.

      IF sy-subrc EQ 0.
        ls_alv-maktx = ls_makt-maktx.
      ENDIF.

      APPEND ls_alv TO gt_alv.
    ENDLOOP.
  ENDIF.
ENDFORM.                    " GET_SCRAP
*&---------------------------------------------------------------------*
*&      Form  CREATE_F4_FIELD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_C_WARE  text
*      -->P_C_VORG  text
*      -->P_C_WARE_DYN  text
*      -->P_SO_WARE  text
*      -->P_IT_WARE  text
*----------------------------------------------------------------------*
FORM create_f4_field USING p_retfield p_val_org p_dyn_field so_option p_it TYPE STANDARD TABLE.
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
