*&---------------------------------------------------------------------*
*&  Include           ZABSF_CALC_WORKERS_KPI_CLASS
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&       Class (Defimition)  lcl_event_receiver
*&---------------------------------------------------------------------*
*        Text
*----------------------------------------------------------------------*
CLASS lcl_event_receiver DEFINITION.
  PUBLIC SECTION.
    METHODS:
      handle_toolbar FOR EVENT toolbar OF cl_gui_alv_grid
        IMPORTING e_object e_interactive,

      handle_user_command FOR EVENT user_command OF cl_gui_alv_grid
        IMPORTING e_ucomm.
ENDCLASS.
*&---------------------------------------------------------------------*
*&       Class (Implementation)  lcl_event_receiver
*&---------------------------------------------------------------------*
*        Text
*----------------------------------------------------------------------*
CLASS lcl_event_receiver IMPLEMENTATION.
  METHOD handle_toolbar.
    DATA: ls_toolbar  TYPE stb_button.

*   Append a separator to normal toolbar
    CLEAR ls_toolbar.
    MOVE 3 TO ls_toolbar-butn_type. "Separator

    APPEND ls_toolbar TO e_object->mt_toolbar.

*   Append an icon to show booking table
    CLEAR ls_toolbar.
    MOVE 'FILE' TO ls_toolbar-function.
    MOVE icon_write_file TO ls_toolbar-icon.
    MOVE 'Criar ficheiro'(h01) TO ls_toolbar-quickinfo.
    MOVE 'Ficheiro'(h02) TO ls_toolbar-text.
    MOVE ' ' TO ls_toolbar-disabled.

    APPEND ls_toolbar TO e_object->mt_toolbar.
  ENDMETHOD.

  METHOD handle_user_command.
*  Variables
    DATA: l_file_separator TYPE c,
          l_filename       TYPE localfile.

    CASE e_ucomm.
      WHEN 'FILE'.

        IF p_save IS NOT INITIAL.
*  Pop up to check whether to continue the process
          PERFORM confirm_execution.
          CHECK g_cont_proc IS INITIAL.
        ENDIF.

*       Get file separator
        CALL METHOD cl_gui_frontend_services=>get_file_separator
          CHANGING
            file_separator       = l_file_separator
          EXCEPTIONS
            not_supported_by_gui = 1
            error_no_gui         = 2
            cntl_error           = 3
            OTHERS               = 4.

*       Create file name
        PERFORM create_filename USING l_file_separator
                                CHANGING l_filename.

*       Save files created
        IF l_filename IS NOT INITIAL.
          PERFORM save_file USING l_filename.
          PERFORM save_data.
        ENDIF.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.               "lcl_event_receiver
