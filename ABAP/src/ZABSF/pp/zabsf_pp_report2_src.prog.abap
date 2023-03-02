*&---------------------------------------------------------------------*
*&  Include           ZABSF_PP_REPORT1_SRC
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-b01. " Select Parameters
SELECT-OPTIONS:
  s_werks   FOR zabsf_pp010-werks,
  s_hname   FOR zabsf_pp010-hname,
  s_arbpl   FOR zabsf_pp010-arbpl,
  s_shift   FOR zabsf_pp010-shiftid,
  s_aufnr   FOR aufk-aufnr,
  s_date    FOR sy-datum NO-EXTENSION.
*  s_operid  FOR zabsf_pp002-hname.
SELECTION-SCREEN END OF BLOCK b01.
