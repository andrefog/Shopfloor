*&---------------------------------------------------------------------*
*&  Include           Z_LP_PP_SF_SCRAP_TOP
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Tables
*&---------------------------------------------------------------------*
TABLES: zabsf_pp034.

*&---------------------------------------------------------------------*
*&  Types
*&---------------------------------------------------------------------*
*Warehouse
TYPES: BEGIN OF ty_ware,
         wareid    TYPE zabsf_pp_e_wareid,
         ware_desc  TYPE zabsf_pp_e_ware_desc,
       END OF ty_ware.

*&---------------------------------------------------------------------*
*&  Internal Tables
*&---------------------------------------------------------------------*
DATA: gt_alv  TYPE TABLE OF zabsf_pp_s_scrap_alv,
      it_ware TYPE TABLE OF ty_ware.

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

CONSTANTS c_struc_alv TYPE dd02l-tabname VALUE 'ZABSF_PP_S_SCRAP_ALV'.

*&---------------------------------------------------------------------*
*&  Constants
*&---------------------------------------------------------------------*
CONSTANTS: c_ware     TYPE dfies-fieldname VALUE 'WAREID',
           c_ware_dyn TYPE dynfnam         VALUE 'SO_WARE',
           c_vorg     TYPE ddbool_d        VALUE 'S',
           c_werks    TYPE werks_d         VALUE '0070'.
