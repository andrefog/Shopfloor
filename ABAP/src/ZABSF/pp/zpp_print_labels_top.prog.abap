*&---------------------------------------------------------------------*
*&  Programa         ZPP_PRINT_LABELS
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& DESCRIPTION    : Programa de (re)impressão de etiquetas
*&
*& AUTHOR(S)      : Bruno Ribeiro - Abaco Consulting
*& CREATED ON     : 30.03.2020
*&---------------------------------------------------------------------*
tables: zpp_labels_t.
class: gcl_print_label definition deferred.

data: go_printlbl_obj type ref to gcl_print_label ##NEEDED,
      go_excption_obj type ref to zcx_bc_exceptions ##NEEDED.
