*----------------------------------------------------------------------*
***INCLUDE Z_LP_PP_SF_REPORT_QUANT_O01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'QTD100'.
  SET TITLEBAR 'SP100'.
ENDMODULE.                 " STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  INIT_ALV  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE init_alv OUTPUT.
  DATA it_sort TYPE lvc_t_sort.

  IF g_custom_container IS INITIAL.
    REFRESH it_sort.

*  Create CONTAINER object with reference to container name in the screen
    CREATE OBJECT g_custom_container
      EXPORTING
        container_name = g_container.

*  Create GRID object with reference to parent name
    CREATE OBJECT g_grid
      EXPORTING
        i_parent = g_custom_container.

*  Create fieldcatalo
    PERFORM prepare_fieldcatalog.

*  Sort data in ALV
    PERFORM create_sort CHANGING it_sort.

    gs_layout-zebra     = 'X'.
    gs_layout-cwidth_opt = 'X'.

*  Preparar a o layout para a primeira visualização
    CALL METHOD g_grid->set_table_for_first_display
      EXPORTING
        is_layout          = gs_layout
        is_variant         = l_variant
        i_save             = 'A'
        i_bypassing_buffer = 'X'
      CHANGING
        it_fieldcatalog    = gt_fieldcatalog
        it_outtab          = gt_qtd_alv
        it_sort            = it_sort.
  ENDIF.
ENDMODULE.                 " INIT_ALV  OUTPUT
*&---------------------------------------------------------------------*
*&      Form  PREPARE_FIELDCATALOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM prepare_fieldcatalog .
  DATA lt_date TYPE TABLE OF ty_date.

  DATA: ls_fieldcatalog TYPE lvc_s_fcat,
        ls_date         TYPE ty_date.

  REFRESH gt_fieldcatalog.

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = c_struc_alv
    CHANGING
      ct_fieldcat            = gt_fieldcatalog[]
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

  PERFORM get_dates CHANGING lt_date.

  LOOP AT gt_fieldcatalog INTO ls_fieldcatalog.
    CLEAR ls_date.

    CASE ls_fieldcatalog-fieldname.
      WHEN 'OEEID'.
        ls_fieldcatalog-no_out = 'X'.
      WHEN 'OEEID_DESC'.
        ls_fieldcatalog-no_out = 'X'.
      WHEN 'STPRSNID'.
        ls_fieldcatalog-no_out = 'X'.
      WHEN 'STPRSN_DESC'.
        ls_fieldcatalog-no_out = 'X'.
      WHEN 'VDATA1'.
*      Read date in table
        READ TABLE lt_date INTO ls_date WITH KEY day = ls_fieldcatalog-fieldname+5(1).

        PERFORM change_field USING  ls_date
                             CHANGING ls_fieldcatalog-coltext ls_fieldcatalog-scrtext_l
                                      ls_fieldcatalog-scrtext_m ls_fieldcatalog-scrtext_s
                                      ls_fieldcatalog-no_out.
      WHEN 'VDATA2'.
*      Read date in table
        READ TABLE lt_date INTO ls_date WITH KEY day = ls_fieldcatalog-fieldname+5(1).

        PERFORM change_field USING ls_date
                             CHANGING ls_fieldcatalog-coltext ls_fieldcatalog-scrtext_l
                                      ls_fieldcatalog-scrtext_m ls_fieldcatalog-scrtext_s
                                      ls_fieldcatalog-no_out.
      WHEN 'VDATA3'.
*      Read date in table
        READ TABLE lt_date INTO ls_date WITH KEY day = ls_fieldcatalog-fieldname+5(1).

        PERFORM change_field USING ls_date
                             CHANGING ls_fieldcatalog-coltext ls_fieldcatalog-scrtext_l
                                      ls_fieldcatalog-scrtext_m ls_fieldcatalog-scrtext_s
                                      ls_fieldcatalog-no_out.
      WHEN 'VDATA4'.
*      Read date in table
        READ TABLE lt_date INTO ls_date WITH KEY day = ls_fieldcatalog-fieldname+5(1).

        PERFORM change_field USING ls_date
                             CHANGING ls_fieldcatalog-coltext ls_fieldcatalog-scrtext_l
                                      ls_fieldcatalog-scrtext_m ls_fieldcatalog-scrtext_s
                                      ls_fieldcatalog-no_out.
      WHEN 'VDATA5'.
*      Read date in table
        READ TABLE lt_date INTO ls_date WITH KEY day = ls_fieldcatalog-fieldname+5(1).

        PERFORM change_field USING ls_date
                             CHANGING ls_fieldcatalog-coltext ls_fieldcatalog-scrtext_l
                                      ls_fieldcatalog-scrtext_m ls_fieldcatalog-scrtext_s
                                      ls_fieldcatalog-no_out.
      WHEN 'VDATA6'.
*      Read date in table
        READ TABLE lt_date INTO ls_date WITH KEY day = ls_fieldcatalog-fieldname+5(1).

        PERFORM change_field USING ls_date
                             CHANGING ls_fieldcatalog-coltext ls_fieldcatalog-scrtext_l
                                      ls_fieldcatalog-scrtext_m ls_fieldcatalog-scrtext_s
                                      ls_fieldcatalog-no_out.
      WHEN 'VDATA7'.
*      Read date in table
        READ TABLE lt_date INTO ls_date WITH KEY day = ls_fieldcatalog-fieldname+5(1).

        PERFORM change_field USING ls_date
                             CHANGING ls_fieldcatalog-coltext ls_fieldcatalog-scrtext_l
                                      ls_fieldcatalog-scrtext_m ls_fieldcatalog-scrtext_s
                                      ls_fieldcatalog-no_out.
    ENDCASE.

    MODIFY gt_fieldcatalog FROM ls_fieldcatalog.
  ENDLOOP.
ENDFORM.                    " PREPARE_FIELDCATALOG
*&---------------------------------------------------------------------*
*&      Form  GET_DATES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_dates CHANGING it_date TYPE STANDARD TABLE.
  DATA: ls_qtd  TYPE ZABSF_PP056,
        ls_date TYPE ty_date.

  REFRESH it_date.

  CLEAR: ls_qtd,
         ls_date.

*Get dates in internal table
  LOOP AT gt_qtd INTO ls_qtd.
    MOVE ls_qtd-data TO ls_date-data.

    APPEND ls_date TO it_date.
  ENDLOOP.

  DELETE ADJACENT DUPLICATES FROM it_date.

  LOOP AT it_date INTO ls_date.
*  Get number of day
    CALL FUNCTION 'DATE_COMPUTE_DAY'
      EXPORTING
        date = ls_date-data
      IMPORTING
        day  = ls_date-day.

*  Abbreviation for day
    CASE ls_date-day.
      WHEN 1. "Monday
        ls_date-tday = text-003.
      WHEN 2. "Tuesday
        ls_date-tday = text-004.
      WHEN 3. "Wednesday
        ls_date-tday = text-005.
      WHEN 4. "Thursday
        ls_date-tday = text-006.
      WHEN 5. "Friday
        ls_date-tday = text-007.
      WHEN 6. "Saturday
        ls_date-tday = text-008.
      WHEN 7. "Sunday
        ls_date-tday = text-009.
    ENDCASE.

*  Show field in alv
    ls_date-show = 'X'.

    MODIFY it_date FROM ls_date.
  ENDLOOP.
ENDFORM.                    " GET_DATES
*&---------------------------------------------------------------------*
*&      Form  CHANGE_FIELD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LT_DATE  text
*      <--P_LS_FIELDCATALOG_COLTEXT  text
*      <--P_LS_FIELDCATALOG_SCRTEXT_L  text
*      <--P_LS_FIELDCATALOG_SCRTEXT_M  text
*      <--P_LS_FIELDCATALOG_SCRTEXT_S  text
*      <--P_LS_FIELDCATALOG_NO_OUT  text
*----------------------------------------------------------------------*
FORM change_field  USING    st_date TYPE ty_date
                   CHANGING p_coltext p_scrtext_l p_scrtext_m
                            p_scrtext_s p_no_out.

  DATA ld_text(6) TYPE c.

  CLEAR ld_text.

  IF st_date-show IS NOT INITIAL.
*  Create name of column
    CONCATENATE st_date-tday '-' st_date-data+6(2) INTO ld_text.
*  Name of the column
    p_coltext = ld_text.
*  Long Field Label
    p_scrtext_l = ld_text.
*  Medium Field Label
    p_scrtext_m = ld_text.
*  Short Field Label
    p_scrtext_s = ld_text.
  ELSE.
*  No output
    p_no_out = 'X'.
  ENDIF.
ENDFORM.                    " CHANGE_FIELD
*&---------------------------------------------------------------------*
*&      Form  CREATE_SORT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM create_sort CHANGING it_sort TYPE STANDARD TABLE.
  DATA: ls_fieldcatalog TYPE lvc_s_fcat,
        ls_sort         TYPE lvc_s_sort.

  CLEAR: ls_fieldcatalog,
         ls_sort.

  LOOP AT gt_fieldcatalog INTO ls_fieldcatalog.
    CLEAR ls_sort.

    CASE ls_fieldcatalog-fieldname.
      WHEN 'AREAID'.
        ls_sort-fieldname = ls_fieldcatalog-fieldname.
        ls_sort-down = 'X'.
      WHEN 'AREA_DESC'.
        ls_sort-fieldname = ls_fieldcatalog-fieldname.
        ls_sort-down = 'X'.
      WHEN 'HNAME'.
        ls_sort-fieldname = ls_fieldcatalog-fieldname.
        ls_sort-down = 'X'.
      WHEN 'HKTEXT'.
        ls_sort-fieldname = ls_fieldcatalog-fieldname.
        ls_sort-down = 'X'.
      WHEN 'WERKS'.
        ls_sort-fieldname = ls_fieldcatalog-fieldname.
        ls_sort-down = 'X'.
      WHEN 'NAME1'.
        ls_sort-fieldname = ls_fieldcatalog-fieldname.
        ls_sort-down = 'X'.
      WHEN 'ARBPL'.
        ls_sort-fieldname = ls_fieldcatalog-fieldname.
        ls_sort-down = 'X'.
      WHEN 'KTEXT'.
        ls_sort-fieldname = ls_fieldcatalog-fieldname.
        ls_sort-down = 'X'.
      WHEN 'OEEID'.
        ls_sort-fieldname = ls_fieldcatalog-fieldname.
        ls_sort-down = 'X'.
      WHEN 'OEEID_DESC'.
        ls_sort-fieldname = ls_fieldcatalog-fieldname.
        ls_sort-down = 'X'.
    ENDCASE.

    IF ls_sort IS NOT INITIAL.
      APPEND ls_sort TO it_sort.
    ENDIF.
  ENDLOOP.

ENDFORM.                    " CREATE_SORT
