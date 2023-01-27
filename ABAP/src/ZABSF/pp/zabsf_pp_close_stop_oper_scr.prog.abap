*&---------------------------------------------------------------------*
*&  Include           ZPP_CLOSE_STOP_OPER_SCREEN
*&---------------------------------------------------------------------*
SELECTION-SCREEN: BEGIN OF BLOCK a1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: s_werks FOR aufk-werks OBLIGATORY NO-EXTENSION NO INTERVALS DEFAULT '1000'.
SELECTION-SCREEN: END OF BLOCK a1.
