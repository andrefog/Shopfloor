*&---------------------------------------------------------------------*
*&  Include           Z_LP_PP_SF_CONSUMPTIONS_CHGI01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_ALL  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_all INPUT.
  CASE ok_code.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT' OR 'CANCEL'.
      LEAVE PROGRAM.
    WHEN 'SAVE'.
*      PERFORM validate_data.
*      CHECK l_not_exec IS INITIAL.
*      PERFORM save_data.
  ENDCASE.
ENDMODULE.                 " USER_COMMAND_ALL  INPUT
*&---------------------------------------------------------------------*
*&      Module  EXIT_COMMAND_ALL  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_command_all INPUT.

  IF g_grid IS NOT INITIAL.
    CALL METHOD g_grid->free.
    CLEAR g_grid.
  ENDIF.

  SET SCREEN 0.
  LEAVE PROGRAM.
ENDMODULE.                 " EXIT_COMMAND_ALL  INPUT


*&---------------------------------------------------------------------*
*&      Form  PREPARE_TOOLBAR
*&---------------------------------------------------------------------*
FORM prepare_toolbar .

  REFRESH pt_exclude.
  CLEAR ls_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_append_row.
  APPEND ls_exclude TO pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_insert_row.
  APPEND ls_exclude TO pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_delete_row.
  APPEND ls_exclude TO pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_copy.
  APPEND ls_exclude TO pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_copy_row.
  APPEND ls_exclude TO pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_cut.
  APPEND ls_exclude TO pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_paste.
  APPEND ls_exclude TO pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_paste_new_row.
  APPEND ls_exclude TO pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_undo.
  APPEND ls_exclude TO pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_move_row.
  APPEND ls_exclude TO pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_check.
  APPEND ls_exclude TO pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_refresh.
  APPEND ls_exclude TO pt_exclude.

ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  VALIDATE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM validate_data .


  CLEAR: l_answer, l_not_exec.
  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      titlebar              = TEXT-010
      text_question         = TEXT-011
*     text_button_1         = 'Continue'(001)
*     text_button_2         = 'Cancel'(002)
      default_button        = '2'
      display_cancel_button = ' '
    IMPORTING
      answer                = l_answer
    EXCEPTIONS
      text_not_found        = 1
      OTHERS                = 2.
  IF ( l_answer = 2 ).
    l_not_exec = 'X'.
  ENDIF.
  CHECK l_not_exec IS INITIAL.


  LOOP AT gt_alv INTO DATA(ls_alv_check)
           WHERE status_cons EQ 'D' OR status_cons EQ 'P'. "changed

    READ TABLE lt_consumpt INTO DATA(ls_cons_orig)
        WITH KEY werks = ls_alv_check-werks
            data = ls_alv_check-data
            shiftid = ls_alv_check-shiftid
            aufnr = ls_alv_check-aufnr
            ficha = ls_alv_check-ficha
            status_cons = ls_alv_check-status_cons.

*    SELECT SINGLE status_cons
*      FROM ZABSF_PP076
*      INTO @DATA(l_stat)
*      WHERE werks = @ls_alv_check-werks AND
*            data  = @ls_alv_check-data AND
*            shiftid  = @ls_alv_check-shiftid AND
*            aufnr = @ls_alv_check-aufnr AND
*            ficha = @ls_alv_check-ficha AND
*            status_cons = @ls_consumpt-status_cons.
    IF ( sy-subrc <> 0 ).
      EXIT.
    ENDIF.
  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0900  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0900 INPUT.

  case sy-ucomm.
    when 'OK'.
      set screen 0.
      LEAVE SCREEN.

    when 'CANCEL'.
      clear l_motivo.
      set screen 0.
      LEAVE SCREEN.
  endcase.



ENDMODULE.
