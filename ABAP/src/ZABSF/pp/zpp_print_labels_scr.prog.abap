*&---------------------------------------------------------------------*
*&  Programa         ZPP_PRINT_LABELS
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& DESCRIPTION    : Programa de (re)impressão de etiquetas
*&
*& AUTHOR(S)      : Bruno Ribeiro - Abaco Consulting
*& CREATED ON     : 30.03.2020
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS: p_copies TYPE int1 DEFAULT 1 OBLIGATORY,
            p_prewin TYPE flag1 DEFAULT abap_true,
            p_printr TYPE rspopname MATCHCODE OBJECT prin OBLIGATORY,
            p_langu  TYPE spras DEFAULT 'PT' OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
SELECT-OPTIONS: so_numb FOR zpp_labels_t-label_from.
PARAMETERS:     p_seqnr  TYPE flag.

SELECTION-SCREEN END OF BLOCK b2.
SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
PARAMETERS: p_aufnr TYPE aufnr MATCHCODE OBJECT ash_orde OBLIGATORY,
            p_batch TYPE charg_d,
            p_matnr TYPE matnr NO-DISPLAY,
            p_maktx TYPE atwrt NO-DISPLAY,
            p_pspnr TYPE ps_psp_pnr NO-DISPLAY,
            p_quant TYPE int2 NO-DISPLAY,
            p_meins TYPE meins DEFAULT 'UN' NO-DISPLAY,
            " p_solda type char12,
            p_shopf TYPE flag NO-DISPLAY,
            p_rueck TYPE co_rueck,
            p_rmzhl TYPE co_rmzhl.

SELECTION-SCREEN END OF BLOCK b3.
