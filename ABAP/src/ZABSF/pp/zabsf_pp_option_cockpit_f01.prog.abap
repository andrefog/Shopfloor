*----------------------------------------------------------------------*
***INCLUDE Z_LP_PP_SF_OPTION_COCKPIT_F01.
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
*&      Form  GET_CRONOGRAPH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_cronograph .
  DATA: lt_cron TYPE TABLE OF zabsf_pp028,
        lt_makt TYPE TABLE OF makt.

  DATA: ls_cron TYPE zabsf_pp028,
        ls_alv  TYPE zabsf_pp_s_option_alv,
        ls_makt TYPE makt.

  REFRESH: lt_cron,
           lt_makt.

  CLEAR: ls_cron,
         ls_alv.

*Get information stored in the Chronograph
  SELECT *
    FROM zabsf_pp028
    INTO CORRESPONDING FIELDS OF TABLE lt_cron
   WHERE arbpl  IN so_arbpl
     AND werks  EQ pa_werks
     AND matnr  IN so_matnr
     AND datasr IN so_date.

  IF lt_cron[] IS NOT INITIAL.
*  Get material descriptions
    SELECT matnr maktx
      FROM makt
      INTO CORRESPONDING FIELDS OF TABLE lt_makt
       FOR ALL ENTRIES IN lt_cron
     WHERE matnr EQ lt_cron-matnr
       AND spras EQ sy-langu.

    LOOP AT lt_cron INTO ls_cron.
      CLEAR: ls_alv,
             ls_makt.

      MOVE-CORRESPONDING ls_cron TO ls_alv.

*    Material description
      READ TABLE lt_makt INTO ls_makt WITH KEY matnr = ls_cron-matnr.

      IF sy-subrc EQ 0.
        ls_alv-maktx = ls_makt-maktx.
      ENDIF.

      APPEND ls_alv TO gt_alv.

    ENDLOOP.
  ENDIF.
ENDFORM.                    " GET_CRONOGRAPH
*&---------------------------------------------------------------------*
*&      Form  GET_MEASUREMENTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_measurements .

  DATA: lt_measure      TYPE TABLE OF zabsf_pp031,
        lt_measure_desc TYPE TABLE OF zabsf_pp029_t,
        lt_makt         TYPE TABLE OF makt.

  DATA: ls_measure      TYPE zabsf_pp031,
        ls_measure_desc TYPE zabsf_pp029_t,
        ls_alv          TYPE zabsf_pp_s_option_alv,
        ls_makt         TYPE makt.

  REFRESH: lt_measure,
           lt_makt,
           lt_measure_desc.

*Get information stored in the Measurements
  SELECT *
    FROM zabsf_pp031
    INTO CORRESPONDING FIELDS OF TABLE lt_measure
   WHERE arbpl  IN so_arbpl
     AND werks  EQ pa_werks
     AND matnr  IN so_matnr
     AND datasr IN so_date.

  IF lt_measure[] IS NOT INITIAL.
*  Get material descriptions
    SELECT matnr maktx
      FROM makt
      INTO CORRESPONDING FIELDS OF TABLE lt_makt
       FOR ALL ENTRIES IN lt_measure
     WHERE matnr EQ lt_measure-matnr
       AND spras EQ sy-langu.

*  Get measurements description
    SELECT *
      FROM zabsf_pp029_t
      INTO CORRESPONDING FIELDS OF TABLE lt_measure_desc
       FOR ALL ENTRIES IN lt_measure
     WHERE measeureid EQ lt_measure-measeureid
       AND spras EQ sy-langu.

    LOOP AT lt_measure INTO ls_measure.
      CLEAR: ls_alv,
             ls_measure_desc,
             ls_makt.

      MOVE-CORRESPONDING ls_measure TO ls_alv.

      READ TABLE lt_measure_desc INTO ls_measure_desc WITH KEY measeureid = ls_measure-measeureid.

      IF sy-subrc EQ 0.
        ls_alv-measeure_desc = ls_measure_desc-measeure_desc.
      ENDIF.

*    Material description
      READ TABLE lt_makt INTO ls_makt WITH KEY matnr = ls_measure-matnr.

      IF sy-subrc EQ 0.
        ls_alv-maktx = ls_makt-maktx.
      ENDIF.

      APPEND ls_alv TO gt_alv.
    ENDLOOP.
  ENDIF.
ENDFORM.                    " GET_MEASUREMENTS
*&---------------------------------------------------------------------*
*&      Form  GET_ALERTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_alerts .
  DATA: lt_alerts TYPE TABLE OF zabsf_pp030,
        lt_makt   TYPE TABLE OF makt.

  DATA: ls_alerts TYPE zabsf_pp030,
        ls_alv    TYPE zabsf_pp_s_option_alv,
        ls_makt   TYPE makt.

  REFRESH: lt_alerts,
           lt_makt.

*Get information stored in the Alerts
  SELECT *
    FROM zabsf_pp030
    INTO CORRESPONDING FIELDS OF TABLE lt_alerts
   WHERE arbpl  IN so_arbpl
     AND werks  EQ pa_werks
     AND matnr  IN so_matnr
     AND datasr IN so_date.

  IF lt_alerts[] IS NOT INITIAL.
*  Get material descriptions
    SELECT matnr maktx
      FROM makt
      INTO CORRESPONDING FIELDS OF TABLE lt_makt
       FOR ALL ENTRIES IN lt_alerts
     WHERE matnr EQ lt_alerts-matnr
       AND spras EQ sy-langu.

*  Get material descriptions
    SELECT matnr maktx
      FROM makt
      INTO CORRESPONDING FIELDS OF TABLE lt_makt
       FOR ALL ENTRIES IN lt_alerts
     WHERE matnr EQ lt_alerts-matnr
       AND spras EQ sy-langu.

    LOOP AT lt_alerts INTO ls_alerts.
      CLEAR: ls_alv,
             ls_makt.

      MOVE-CORRESPONDING ls_alerts TO ls_alv.

*    Material description
      READ TABLE lt_makt INTO ls_makt WITH KEY matnr = ls_alerts-matnr.

      IF sy-subrc EQ 0.
        ls_alv-maktx = ls_makt-maktx.
      ENDIF.

      APPEND ls_alv TO gt_alv.
    ENDLOOP.
  ENDIF.
ENDFORM.                    " GET_ALERTS
