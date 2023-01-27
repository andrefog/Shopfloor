*&---------------------------------------------------------------------*
*&  Programa         ZPP_PRINT_LABELS
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& DESCRIPTION    : Programa de (re)impressão de etiquetas
*&
*& AUTHOR(S)      : Bruno Ribeiro - Abaco Consulting
*& CREATED ON     : 30.03.2020
*&---------------------------------------------------------------------*
selection-screen begin of block b1 with frame title text-001.
parameters: p_copies type int1 default 1 obligatory,
            p_prewin type flag1 default abap_true,
            p_printr type rspopname matchcode object prin obligatory,
            p_langu  type spras default 'PT' obligatory.
selection-screen end of block b1.

selection-screen begin of block b2 with frame title text-002.
select-options: so_numb for zpp_labels_t-label_from.
parameters:     p_seqnr  type flag.

selection-screen end of block b2.
selection-screen begin of block b3 with frame title text-003.
parameters: p_aufnr type aufnr matchcode object ash_orde obligatory,
            p_batch type charg_d,
            p_matnr type matnr no-display,
            p_maktx type atwrt no-display,
            p_pspnr type ps_psp_pnr no-display,
            p_quant type int2 no-display,
            p_meins type meins default 'UN' no-display,
            " p_solda type char12,
            p_shopf type flag no-display,
            p_rueck type co_rueck,
            p_rmzhl type co_rmzhl.

selection-screen end of block b3.
