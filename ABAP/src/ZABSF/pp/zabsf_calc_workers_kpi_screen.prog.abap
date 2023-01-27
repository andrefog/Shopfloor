*&---------------------------------------------------------------------*
*&  Include           ZABSF_CALC_WORKERS_KPI_SCREEN
*&---------------------------------------------------------------------*
*Screen block - Selection criteria
SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.
PARAMETERS: p_werks  TYPE werks_d DEFAULT '1020',
            p_direct TYPE dxfilename.
PARAMETERS: p_lim_dt TYPE sy-datum     MODIF ID m3.

SELECTION-SCREEN: END OF BLOCK b1.

*Screen block - Process Mode
SELECTION-SCREEN: BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-t02.
PARAMETERS: p_simul RADIOBUTTON GROUP r2 DEFAULT 'X' USER-COMMAND run_b2,
            p_save  RADIOBUTTON GROUP r2.
SELECTION-SCREEN: END OF BLOCK b2.

*Screen block - Status Card
SELECTION-SCREEN: BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-t03.
PARAMETERS: p_notprc RADIOBUTTON GROUP r1 DEFAULT 'X' MODIF ID m1 USER-COMMAND run_b3,
            p_prc    RADIOBUTTON GROUP r1 MODIF ID m1.

SELECT-OPTIONS: so_date  FOR  sy-datum     MODIF ID m2,
                so_pernr FOR  pa0002-pernr MODIF ID m2.
SELECTION-SCREEN: END OF BLOCK b3.

PARAMETERS: p_backsf AS CHECKBOX.

*Change screen
AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF screen-name EQ 'P_BACKSF'.
      screen-invisible = '1'.
      MODIFY SCREEN.
    ENDIF.
    IF p_simul IS NOT INITIAL.
      IF screen-group1 = 'M1'.
        screen-input = '1'.
        screen-invisible = '0'.
        screen-required = '0'.
        MODIFY SCREEN.
      ENDIF.

      IF p_notprc IS NOT INITIAL.
        IF screen-group1 = 'M2'.
          screen-input = '0'.
          screen-invisible = '1'.
          screen-required = '0'.
        ENDIF.
        MODIFY SCREEN.
      ELSE.
        IF screen-group1 = 'M3'.
          screen-input = '0'.
          screen-invisible = '1'.
          screen-required = '0'.
        ENDIF.
        MODIFY SCREEN.
      ENDIF.
    ELSE.
      IF screen-group1 = 'M1' OR screen-group1 = 'M2'." OR screen-group1 = 'M3'.
        screen-input = '0'.
        screen-invisible = '1'.
        screen-required = '0'.
        MODIFY SCREEN.
      ENDIF.
    ENDIF.
  ENDLOOP.

*F4 for parameter
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_direct.

  DATA:
    gt_file_table  TYPE filetable,  "Table Holding Selected Files
    gw_file        TYPE file_table,
    gw_rc          TYPE i,          "Return Code, Number of Files or -1 If Error Occurred
    gw_user_action TYPE i.          "OPTIONAL  User Action (See Class Constants ACTION_OK, ACTION_CANCEL)

*  CALL METHOD cl_gui_frontend_services=>file_open_dialog
*    EXPORTING
*      file_filter             = '(*.xls,*.xlsx)|*.xls*'
*    CHANGING
*      file_table              = gt_file_table
*      rc                      = gw_rc
*      user_action             = gw_user_action
*    EXCEPTIONS
*      file_open_dialog_failed = 1
*      cntl_error              = 2
*      error_no_gui            = 3
*      not_supported_by_gui    = 4
*      OTHERS                  = 5.

*DATA WINDOW_TITLE    TYPE STRING.
*DATA INITIAL_FOLDER  TYPE STRING.
  DATA selected_folder TYPE string.

  CALL METHOD cl_gui_frontend_services=>directory_browse
*  EXPORTING
*    window_title         = window_title
*    initial_folder       = initial_folder
    CHANGING
      selected_folder = selected_folder
*  EXCEPTIONS
*     cntl_error      = 1
*     error_no_gui    = 2
*     not_supported_by_gui = 3
*     others          = 4
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here

  ENDIF.
  p_direct = selected_folder.

*  IF sy-subrc EQ 0.
*    READ TABLE gt_file_table INTO gw_file INDEX 1.
*    p_file = gw_file-filename.
*  ENDIF.
