*&---------------------------------------------------------------------*
*&  Include           Z_LP_PP_SF_PASSAGE_TOP
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Tables
*&---------------------------------------------------------------------*
TABLES: zabsf_pp047.

*&---------------------------------------------------------------------*
*&  Internal Tables
*&---------------------------------------------------------------------*
DATA: gt_alv  TYPE TABLE OF zabsf_pp_s_passage_alv.

*&---------------------------------------------------------------------*
*&  ALV
*&---------------------------------------------------------------------*
DATA: gt_fieldcatalog    TYPE TABLE OF lvc_s_fcat,
      g_custom_container TYPE REF TO cl_gui_custom_container,
      g_grid             TYPE REF TO cl_gui_alv_grid,
      g_container        TYPE scrfname VALUE 'GR_CONTAINER',
      gs_layout          TYPE lvc_s_layo,
      l_variant          TYPE disvariant,
      ok_code            TYPE syucomm.

CONSTANTS c_struc_alv TYPE dd02l-tabname VALUE 'ZABSF_PP_S_PASSAGE_ALV'.
