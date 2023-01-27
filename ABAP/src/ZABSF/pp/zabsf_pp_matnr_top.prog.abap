*&---------------------------------------------------------------------*
*&  Include           Z_LP_PP_SF_MATNR_TOP
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Tables
*&---------------------------------------------------------------------*
TABLES: mara.

*&---------------------------------------------------------------------*
*&  Types
*&---------------------------------------------------------------------*
*Area
TYPES: BEGIN OF ty_area,
         areaid    TYPE zabsf_pp_e_areaid,
         area_desc TYPE zabsf_pp_e_areadesc,
       END OF ty_area.

*&---------------------------------------------------------------------*
*&  Internal Tables
*&---------------------------------------------------------------------*
DATA: gt_alv  TYPE TABLE OF zabsf_pp_s_matnr_alv,
      it_area TYPE TABLE OF ty_area. "Area

*&---------------------------------------------------------------------*
*&  Constants
*&---------------------------------------------------------------------*
CONSTANTS: c_area     TYPE dfies-fieldname VALUE 'AREAID',
           c_area_dyn TYPE dynfnam         VALUE 'PA_AREA',
           c_vorg     TYPE ddbool_d        VALUE 'S'.

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

CONSTANTS c_struc_alv TYPE dd02l-tabname VALUE 'ZABSF_PP_S_MATNR_ALV'.
