*----------------------------------------------------------------------*
***INCLUDE Z_LP_PP_SF_COCKPIT_I01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE ok_code.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      LEAVE PROGRAM.
    WHEN 'B_OEE'.
      CALL TRANSACTION 'ZABSF_PPREPORT_OEE'.
    WHEN 'B_STOP'.
      CALL TRANSACTION 'ZABSF_PPREPORT_STOP'.
    WHEN 'B_QTD'.
      CALL TRANSACTION 'ZABSF_PPREPORT_QUANT'.
    WHEN 'B_PROD'.
      CALL TRANSACTION 'ZABSF_PPREPORT_PROD'.
  ENDCASE.
ENDMODULE.                 " USER_COMMAND_0100  INPUT
