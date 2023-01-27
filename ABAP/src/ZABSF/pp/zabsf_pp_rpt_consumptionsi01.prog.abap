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

ENDFORM.
