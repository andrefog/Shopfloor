*----------------------------------------------------------------------*
***INCLUDE Z_LP_PP_SF_REPORT_WARE_F01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  INIT_VARIABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM init_variable .

ENDFORM.                    " INIT_VARIABLE
*&---------------------------------------------------------------------*
*&      Form  CHECK_SO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_PA_AREA  text
*      -->P_PA_WERKS  text
*----------------------------------------------------------------------*
FORM check_so  USING p_areaid p_werks.

  DATA lt_zabsf_pp025 TYPE TABLE OF zabsf_pp025.

  DATA: ls_zabsf_pp025 TYPE zabsf_pp025,
        ls_ware        LIKE LINE OF so_ware.

  IF so_ware[] IS INITIAL.
*  Get warehouse
    SELECT *
      FROM zabsf_pp025
      INTO CORRESPONDING FIELDS OF TABLE lt_zabsf_pp025
     WHERE areaid EQ p_areaid
       AND werks  EQ p_werks.

    LOOP AT lt_zabsf_pp025 INTO ls_zabsf_pp025.
      ls_ware-sign = 'I'.
      ls_ware-option = 'EQ'.
      ls_ware-low = ls_zabsf_pp025-wareid.

      APPEND ls_ware TO so_ware.
    ENDLOOP.

    SORT so_ware.

    DELETE ADJACENT DUPLICATES FROM so_ware.
  ENDIF.
ENDFORM.                    " CHECK_SO
*&---------------------------------------------------------------------*
*&      Form  CREATE_F4_FIELD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_C_WARE  text
*      -->P_C_VORG  text
*      -->P_C_WARE_DYN  text
*      -->P_SO_WARE_HIGH  text
*      -->P_IT_WARE  text
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
*&      Form  SHOW_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM show_data .
*Get data to alv
  PERFORM fill_data_alv.

  IF gt_cntrl_alv[] IS NOT INITIAL.
*  Show data
    CALL SCREEN 100.
  ENDIF.
ENDFORM.                    " SHOW_DATA
*&---------------------------------------------------------------------*
*&      Form  FILL_DATA_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fill_data_alv .
*Types for totals
  TYPES: BEGIN OF ty_total,
           wareid   TYPE zabsf_pp_e_wareid,
           zcntrl   TYPE zabsf_pp_e_zcntrl,
           defectid TYPE zabsf_pp_e_defectid,
           matnr    TYPE matnr,
           week     TYPE kweek,
           qtdweek  TYPE zabsf_pp_e_qtdweek,
         END OF ty_total.

  DATA: lt_total     TYPE TABLE OF ty_total,
        lt_cntrl_alv TYPE TABLE OF zabsf_pp_s_cntrl_alv,
        lt_ware_desc TYPE TABLE OF zabsf_pp025_t.

  DATA: ls_total     TYPE ty_total,
        ls_cntrl_alv TYPE zabsf_pp_s_cntrl_alv,
        ls_ware_desc TYPE zabsf_pp025_t,
        ld_day       TYPE scal-indicator.

  FIELD-SYMBOLS <fs_alv> TYPE zabsf_pp_s_cntrl_alv.

  CLEAR: ls_cntrl_alv,
         gs_cntrl.

*Get data to get description
  LOOP AT gt_cntrl INTO gs_cntrl.
    CLEAR ls_cntrl_alv.
    MOVE-CORRESPONDING gs_cntrl TO ls_cntrl_alv.

    APPEND ls_cntrl_alv TO lt_cntrl_alv.
  ENDLOOP.

  DELETE ADJACENT DUPLICATES FROM lt_cntrl_alv.

*Get description of warehouses
  SELECT *
    FROM zabsf_pp025_t
    INTO CORRESPONDING FIELDS OF TABLE lt_ware_desc
     FOR ALL ENTRIES IN lt_cntrl_alv
   WHERE wareid EQ lt_cntrl_alv-wareid.

*Get total week for defects
  LOOP AT gt_cntrl INTO gs_cntrl.
*  Total quantiry defects
    READ TABLE lt_total INTO ls_total WITH KEY wareid   = gs_cntrl-wareid
                                               zcntrl   = gs_cntrl-zcntrl
                                               defectid = gs_cntrl-defectid
                                               matnr    = gs_cntrl-matnr
                                               week     = gs_cntrl-week.

    IF sy-subrc EQ 0.
*    Add value defect to total
      ADD gs_cntrl-qtdtot TO ls_total-qtdweek.
      MODIFY TABLE lt_total FROM ls_total TRANSPORTING qtdweek.
    ELSE.
*    Insert new line in internal table total
      MOVE-CORRESPONDING gs_cntrl TO ls_total.
      ls_total-qtdweek = gs_cntrl-qtdtot.

      INSERT ls_total INTO TABLE lt_total.
    ENDIF.
  ENDLOOP.

*Fill glbal internal table to show data in alv
  CLEAR gs_cntrl.

  LOOP AT gt_cntrl INTO gs_cntrl.
    CLEAR: gs_cntrl_alv,
           ls_cntrl_alv.

*  Check if exist same data to show
    READ TABLE gt_cntrl_alv INTO ls_cntrl_alv WITH KEY wareid   = gs_cntrl-wareid
                                                       zcntrl   = gs_cntrl-zcntrl
                                                       defectid = gs_cntrl-defectid
                                                       matnr    = gs_cntrl-matnr
                                                       week     = gs_cntrl-week.

    IF sy-subrc EQ 0.
      ADD gs_cntrl-qtdprod TO ls_cntrl_alv-qtdprod.

*    Get number day in week
      CALL FUNCTION 'DATE_COMPUTE_DAY'
        EXPORTING
          date = gs_cntrl-data
        IMPORTING
          day  = ld_day.

*    Put value defect in corresponding day in week
      CASE ld_day.
        WHEN 1.
          ADD gs_cntrl-qtdtot TO ls_cntrl_alv-vdata1.
        WHEN 2.
          ADD gs_cntrl-qtdtot TO ls_cntrl_alv-vdata2.
        WHEN 3.
          ADD gs_cntrl-qtdtot TO ls_cntrl_alv-vdata3.
        WHEN 4.
          ADD gs_cntrl-qtdtot TO ls_cntrl_alv-vdata4.
        WHEN 5.
          ADD gs_cntrl-qtdtot TO ls_cntrl_alv-vdata5.
        WHEN 6.
          ADD gs_cntrl-qtdtot TO ls_cntrl_alv-vdata6.
        WHEN 7.
          ADD gs_cntrl-qtdtot TO ls_cntrl_alv-vdata7.
      ENDCASE.

      MODIFY TABLE gt_cntrl_alv FROM ls_cntrl_alv TRANSPORTING qtdprod vdata1 vdata2 vdata3 vdata4 vdata5 vdata6 vdata7.
    ELSE.
*    Move information to same fields
      MOVE-CORRESPONDING gs_cntrl TO gs_cntrl_alv.

*    Read description for Warehouse
      READ TABLE lt_ware_desc INTO ls_ware_desc WITH KEY wareid = gs_cntrl-wareid.

      IF sy-subrc EQ 0.
*      Warehouse description
        gs_cntrl_alv-ware_desc = ls_ware_desc-ware_desc.
      ENDIF.

*    Get number day in week
      CALL FUNCTION 'DATE_COMPUTE_DAY'
        EXPORTING
          date = gs_cntrl-data
        IMPORTING
          day  = ld_day.

*    Put value defect in corresponding day in week
      CASE ld_day.
        WHEN 1.
          gs_cntrl_alv-vdata1 = gs_cntrl-qtdtot.
        WHEN 2.
          gs_cntrl_alv-vdata2 = gs_cntrl-qtdtot.
        WHEN 3.
          gs_cntrl_alv-vdata3 = gs_cntrl-qtdtot.
        WHEN 4.
          gs_cntrl_alv-vdata4 = gs_cntrl-qtdtot.
        WHEN 5.
          gs_cntrl_alv-vdata5 = gs_cntrl-qtdtot.
        WHEN 6.
          gs_cntrl_alv-vdata6 = gs_cntrl-qtdtot.
        WHEN 7.
          gs_cntrl_alv-vdata7 = gs_cntrl-qtdtot.
      ENDCASE.

*    Total value oee in week
      CLEAR ls_total.
      LOOP AT lt_total INTO ls_total WHERE wareid   EQ gs_cntrl-wareid
                                       AND zcntrl   EQ gs_cntrl-zcntrl
                                       AND defectid EQ gs_cntrl-defectid
                                       AND matnr    EQ gs_cntrl-matnr
                                       AND week     EQ gs_cntrl-week.
*      Total for shift
        ADD ls_total-qtdweek TO gs_cntrl_alv-qtdweek.
      ENDLOOP.

*    Data for ALV
      APPEND gs_cntrl_alv TO gt_cntrl_alv.
    ENDIF.
  ENDLOOP.

  LOOP AT gt_cntrl_alv ASSIGNING <fs_alv>.
    IF <fs_alv>-qtdprod NE 0.
      <fs_alv>-pctrej = ( <fs_alv>-qtdweek / <fs_alv>-qtdprod ) * 100.
    ENDIF.
  ENDLOOP.
ENDFORM.                    " FILL_DATA_ALV
