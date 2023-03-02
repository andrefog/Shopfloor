*&---------------------------------------------------------------------*
*&  Programa         ZPP_PRINT_LABELS
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& DESCRIPTION    : Programa de (re)impressão de etiquetas
*&
*& AUTHOR(S)      : Bruno Ribeiro - Abaco Consulting
*& CREATED ON     : 30.03.2020
*&---------------------------------------------------------------------*
TABLES: zpp_labels_t.
CLASS: gcl_print_label DEFINITION DEFERRED.

DATA: go_printlbl_obj TYPE REF TO gcl_print_label ##NEEDED,
      go_excption_obj TYPE REF TO zcx_pp_exceptions ##NEEDED.
