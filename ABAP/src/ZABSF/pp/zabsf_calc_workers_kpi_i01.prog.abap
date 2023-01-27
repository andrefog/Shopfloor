*----------------------------------------------------------------------*
***INCLUDE ZPP02_CALC_WORKERS_KPI_I01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE g_ok_code.
    WHEN 'BACK' OR 'CANCEL'.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT_COMMAND_ALL  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_command_all INPUT.
*Check if alv is not initial
  IF g_grid IS NOT INITIAL.
*  Free alv
    CALL METHOD g_grid->free.
    CLEAR g_grid.
  ENDIF.

*Go to initial screen
  SET SCREEN 0.
  LEAVE PROGRAM.
ENDMODULE.
