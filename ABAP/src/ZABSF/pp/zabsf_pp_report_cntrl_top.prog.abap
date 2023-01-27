*&---------------------------------------------------------------------*
*&  Include           Z_LP_PP_SF_REPORT_CNTRL_TOP
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Types
*&---------------------------------------------------------------------*
*Workcenter
TYPES: BEGIN OF ty_ware,
        wareid    TYPE ZABSF_PP_e_wareid,
        ware_desc	TYPE ZABSF_PP_e_ware_desc,
       END OF ty_ware.

TYPES: BEGIN OF ty_qtd_prod,
        wareid  TYPE ZABSF_PP_e_wareid,
        zcntrl  TYPE ZABSF_PP_e_zcntrl,
        matnr   TYPE matnr,
        qtdprod TYPE ZABSF_PP_e_qtdprd,
        week    TYPE kweek,
        warecrp TYPE ZABSF_PP_e_wareid, "Corresponding Warehouse
*        data    TYPE datum,
       END OF ty_qtd_prod.

*&---------------------------------------------------------------------*
*&  Tables
*&---------------------------------------------------------------------*
TABLES ZABSF_PP037.
*&---------------------------------------------------------------------*
*&  Internal Tables
*&---------------------------------------------------------------------*
DATA: it_ware      TYPE TABLE OF ty_ware,      "Warehouse
      gt_cntrl     TYPE TABLE OF ZABSF_PP_s_reports_cntrl,
      gt_qtd_prod  TYPE TABLE OF ty_qtd_prod,
      gt_cntrl_alv TYPE TABLE OF ZABSF_PP_s_cntrl_alv.

*&---------------------------------------------------------------------*
*&  Work Areas
*&---------------------------------------------------------------------*
DATA: gs_cntrl     TYPE ZABSF_PP_s_reports_cntrl,
      gs_cntrl_alv TYPE ZABSF_PP_s_cntrl_alv.

*&---------------------------------------------------------------------*
*&  Variables
*&---------------------------------------------------------------------*


*&---------------------------------------------------------------------*
*&  ALV
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ty_date,
        day  TYPE cind,
        data TYPE datum,
        tday TYPE char3,
        show TYPE c,
       END OF ty_date.

DATA: gt_fieldcatalog    TYPE TABLE OF lvc_s_fcat,
      g_custom_container TYPE REF TO cl_gui_custom_container,
      g_grid             TYPE REF TO cl_gui_alv_grid,
      g_container        TYPE scrfname VALUE 'GR_CONTAINER',
      gs_layout          TYPE lvc_s_layo,
      l_variant          TYPE disvariant,
      ok_code            TYPE syucomm.

CONSTANTS c_struc_alv TYPE dd02l-tabname VALUE 'ZABSF_PP_S_CNTRL_ALV'.

*&---------------------------------------------------------------------*
*&  Ranges
*&---------------------------------------------------------------------*


*&---------------------------------------------------------------------*
*&  Field symbols
*&---------------------------------------------------------------------*
FIELD-SYMBOLS <fs_prod> TYPE ty_qtd_prod.

*&---------------------------------------------------------------------*
*&  Constants
*&---------------------------------------------------------------------*
CONSTANTS: c_ware_dyn TYPE dynfnam         VALUE 'SO_WARE',
           c_ware     TYPE dfies-fieldname VALUE 'WAREID',
           c_vorg     TYPE ddbool_d        VALUE 'S',
           c_prod     TYPE ZABSF_PP_e_wareid VALUE 'PROD',
           c_revs     TYPE ZABSF_PP_e_wareid VALUE 'REVS',
           c_supr     TYPE ZABSF_PP_e_wareid VALUE 'SUPR',
           c_cntrl_g  TYPE ZABSF_PP_e_zcntrl VALUE 'G',
           c_cntrl_e  TYPE ZABSF_PP_e_zcntrl VALUE 'E'.

*&---------------------------------------------------------------------*
*&  Selection Screen
*&---------------------------------------------------------------------*
SELECTION-SCREEN: BEGIN OF BLOCK a2 WITH FRAME TITLE text-000.
PARAMETERS: pa_area  TYPE ZABSF_PP_e_areaid DEFAULT 'OPT',  "Area
            pa_week  TYPE kweek           OBLIGATORY,     "Week
            pa_werks TYPE werks_d         OBLIGATORY DEFAULT '0070'.

SELECT-OPTIONS so_ware FOR ZABSF_PP037-wareid.
SELECTION-SCREEN: END OF BLOCK a2.

*&---------------------------------------------------------------------*
*&  F4 for select options
*&---------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR so_ware-low.
*Get warehouse
  SELECT ZABSF_PP025~wareid ZABSF_PP025_t~ware_desc
    INTO CORRESPONDING FIELDS OF TABLE it_ware
    FROM ZABSF_PP025 AS ZABSF_PP025
   INNER JOIN ZABSF_PP025_t AS ZABSF_PP025_t
      ON ZABSF_PP025_t~areaid EQ ZABSF_PP025~areaid
     AND ZABSF_PP025_t~werks  EQ ZABSF_PP025~werks
     AND ZABSF_PP025_t~wareid EQ ZABSF_PP025~wareid
   WHERE ZABSF_PP025~areaid  EQ pa_area
     AND ZABSF_PP025~werks   EQ pa_werks
     AND ZABSF_PP025_t~spras EQ sy-langu.

*Sort table
  SORT it_ware BY wareid.

*Delete duplicates
  DELETE ADJACENT DUPLICATES FROM it_ware.

  PERFORM create_f4_field USING c_ware c_vorg c_ware_dyn so_ware-low it_ware.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR so_ware-high.
*Get warehouse
  SELECT ZABSF_PP025~wareid ZABSF_PP025_t~ware_desc
    INTO CORRESPONDING FIELDS OF TABLE it_ware
    FROM ZABSF_PP025 AS ZABSF_PP025
   INNER JOIN ZABSF_PP025_t AS ZABSF_PP025_t
      ON ZABSF_PP025_t~areaid EQ ZABSF_PP025~areaid
     AND ZABSF_PP025_t~werks  EQ ZABSF_PP025~werks
     AND ZABSF_PP025_t~wareid EQ ZABSF_PP025~wareid
   WHERE ZABSF_PP025~areaid  EQ pa_area
     AND ZABSF_PP025~werks   EQ pa_werks
     AND ZABSF_PP025_t~spras EQ sy-langu.

*Sort table
  SORT it_ware BY wareid.

*Delete duplicates
  DELETE ADJACENT DUPLICATES FROM it_ware.

  PERFORM create_f4_field USING c_ware c_vorg c_ware_dyn so_ware-high it_ware.


**&---------------------------------------------------------------------*
**&  Disable parameter in selection screen
**&---------------------------------------------------------------------*
*AT SELECTION-SCREEN OUTPUT.
*
*  DATA: lv_week  TYPE scal-week,
*        lv_first TYPE sy-datum,
*        lv_last  TYPE sy-datum.
*
**Get week
*  CALL FUNCTION 'GET_WEEK_INFO_BASED_ON_DATE'
*    EXPORTING
*      date   = sy-datum
*    IMPORTING
*      week   = lv_week
*      monday = lv_first
*      sunday = lv_first.
*
**Default week
*  pa_week = lv_week.
