*----------------------------------------------------------------------*
***INCLUDE Z_LP_PP_SF_MATNR_COCKPIT_O01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'PF_PROD'.
  SET TITLEBAR 'T100'.
ENDMODULE.                 " STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  STATUS_0200  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0200 OUTPUT.
  SET PF-STATUS 'PF_STOP'.
  SET TITLEBAR 'T200'.
ENDMODULE.                 " STATUS_0200  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  STATUS_0300  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0300 OUTPUT.
  SET PF-STATUS 'PF_SCRAP'.
  SET TITLEBAR 'T300'.
ENDMODULE.                 " STATUS_0300  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  STATUS_0400  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0400 OUTPUT.
  SET PF-STATUS 'PF_REWRK'.
  SET TITLEBAR 'T400'.
ENDMODULE.                 " STATUS_0400  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  INIT_ALV  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE init_alv OUTPUT.

  IF g_custom_container IS INITIAL.
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

    gs_layout-zebra     = 'X'.
    gs_layout-cwidth_opt = 'X'.

*  Prepare layout for first display
    CALL METHOD g_grid->set_table_for_first_display
      EXPORTING
        is_layout          = gs_layout
        is_variant         = l_variant
        i_save             = 'A'
        i_bypassing_buffer = 'X'
      CHANGING
        it_fieldcatalog    = gt_fieldcatalog
        it_outtab          = gt_alv.
  ELSE.
    CALL METHOD g_grid->refresh_table_display.
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
  FIELD-SYMBOLS <fs_fieldcat> TYPE lvc_s_fcat.

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

  LOOP AT gt_fieldcatalog ASSIGNING <fs_fieldcat>.
    CASE <fs_fieldcat>-fieldname.
      WHEN 'PRODTIME'.
        IF pa_prod IS INITIAL.
          <fs_fieldcat>-no_out = 'X'.
        ENDIF.
      WHEN 'STPRSN_DESC'.
        IF pa_stop IS INITIAL.
          <fs_fieldcat>-no_out = 'X'.
        ENDIF.
      WHEN 'STOPTIME'.
        IF pa_stop IS INITIAL.
          <fs_fieldcat>-no_out = 'X'.
        ENDIF.
      WHEN 'GRDTX'.
        IF pa_scrap IS INITIAL.
          <fs_fieldcat>-no_out = 'X'.
        ENDIF.
      WHEN 'SCRAP'.
        IF pa_scrap IS INITIAL.
          <fs_fieldcat>-no_out = 'X'.
        ENDIF.
      WHEN 'DEFECT_DESC'.
        IF pa_rewrk IS INITIAL.
          <fs_fieldcat>-no_out = 'X'.
        ENDIF.
      WHEN 'REWORK'.
        IF pa_rewrk IS INITIAL.
          <fs_fieldcat>-no_out = 'X'.
        ENDIF.
    ENDCASE.
  ENDLOOP.
ENDFORM.                    " PREPARE_FIELDCATALOG
