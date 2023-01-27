*----------------------------------------------------------------------*
***INCLUDE Z_LP_PP_SF_MATNR_COCKPIT_I01.
*----------------------------------------------------------------------*
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

*  IF g_container IS NOT INITIAL.
*    CALL METHOD g_container->free.
*    CLEAR g_container.
*  ENDIF.

  SET SCREEN 0.
  LEAVE PROGRAM.
ENDMODULE.                 " EXIT_COMMAND_ALL  INPUT
