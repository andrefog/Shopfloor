*&---------------------------------------------------------------------*
*&  Include        Z_LP_PP_SF_CONSUMPTIONS_CHGO01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'PF_CONSUM'.
  SET TITLEBAR 'T100'.
ENDMODULE.                 " STATUS_0100  OUTPUT


*&---------------------------------------------------------------------*
*&      Module  INIT_ALV  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE init_alv OUTPUT.


  IF ( g_custom_container IS INITIAL ).

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

*  Toolbar
    PERFORM prepare_toolbar.

* Grid Events
    PERFORM set_grid_events.

    gs_layout-zebra             = 'X'.
    gs_layout-cwidth_opt        = 'X'.
*    gs_layout-box_fname         = 'SEL'.
    gs_layout-sel_mode          = 'D'.
*    gs_layout-edit              = ''.
    gs_layout-ctab_fname         = 'COLOR'.

*  Prepare layout for first display
    CALL METHOD g_grid->set_table_for_first_display
      EXPORTING
        is_layout            = gs_layout
        is_variant           = l_variant
        i_save               = 'A'
        it_toolbar_excluding = pt_exclude
        i_bypassing_buffer   = 'X'
      CHANGING
        it_fieldcatalog      = gt_fieldcatalog
        it_outtab            = gt_alv.

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
      I_BUFFER_ACTIVE        = 'X'
      i_structure_name       = c_struc_alv
      I_BYPASSING_BUFFER     = 'X'
    CHANGING
      ct_fieldcat            = gt_fieldcatalog[]
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

  LOOP AT gt_fieldcatalog ASSIGNING <fs_fieldcat>.

    CASE <fs_fieldcat>-fieldname.

*        <fs_fieldcat>-edit = 'X'.
*        <fs_fieldcat>-checkbox = 'X'.
*        <fs_fieldcat>-no_out = 'X'.
      WHEN 'FLG_CHG'.
        <fs_fieldcat>-no_out = 'X'.

      WHEN 'ICON'.
        <fs_fieldcat>-scrtext_l = 'Processo'.
        <fs_fieldcat>-scrtext_m = 'Processo'.
        <fs_fieldcat>-scrtext_s = 'Processo'.
        <fs_fieldcat>-just = 'C'.
        <fs_fieldcat>-seltext = 'Processo'.
        <fs_fieldcat>-icon = 'X'.
        <fs_fieldcat>-col_opt = 'X'.
      WHEN OTHERS.
    ENDCASE.
  ENDLOOP.

ENDFORM.                    " PREPARE_FIELDCATALOG
*&---------------------------------------------------------------------*
*&      Module  STATUS_0900  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_0900 OUTPUT.
  SET PF-STATUS '0900'.
  SET TITLEBAR '900'.
ENDMODULE.
