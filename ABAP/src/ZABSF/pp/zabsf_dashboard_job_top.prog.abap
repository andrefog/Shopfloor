*&---------------------------------------------------------------------*
*& Include          ZABSF_DASHBOARD_JOB_TOP
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&  Types
*&---------------------------------------------------------------------*
*Type order detail
TYPES: BEGIN OF ty_prdord,
         aufnr  TYPE aufnr,
         objnr  TYPE j_objnr,
         auart  TYPE auart,
         gstrp  TYPE pm_ordgstrp,
         gltrp  TYPE co_gltrp,
         gstrs  TYPE co_gstrs,
         gsuzs  TYPE co_gsuzs,
         gltrs  TYPE co_gltrs,
         ftrmi  TYPE co_ftrmi,
         gamng  TYPE gamng,
         gmein  TYPE meins,
         plnbez TYPE matnr,
         plnty  TYPE plnty,
         plnnr  TYPE plnnr,
         stlbez TYPE matnr,
         aufpl  TYPE co_aufpl,
         aplzl  TYPE co_aplzl,
         trmdt  TYPE trmdt,
         vornr  TYPE vornr,
         ltxa1  TYPE ltxa1,
         steus  TYPE steus,
         rueck  TYPE co_rueck,
         rmzhl  TYPE co_rmzhl,
         lmnga  TYPE ru_lmnga,
         stat   TYPE j_status,
         zerma  TYPE dzerma,
         fsavd  TYPE fsavd,
         fsavz  TYPE fsavz,
         sssld  TYPE sssld,
         ssslz  TYPE ssslz,
         mgvrg  TYPE mgvrg,
         meinh  TYPE vorme,
         vgw01  TYPE vgwrt,
         vge01  TYPE vgwrteh,
         vgw02  TYPE vgwrt,
         vge02  TYPE vgwrteh,
         vgw03  TYPE vgwrt,
         vge03  TYPE vgwrteh,
         bmsch  TYPE bmsch,
         autwe  TYPE autwe,
       END OF ty_prdord.



*Area
TYPES: BEGIN OF ty_area,
         areaid    TYPE zabsf_pp_e_areaid,
         area_desc TYPE zabsf_pp_e_areadesc,
       END OF ty_area.
TYPES ty_t_area TYPE STANDARD TABLE OF ty_area.

*Hierarchy
TYPES: BEGIN OF ty_hname,
         hname TYPE cr_hname,
         ktext TYPE cr_ktext,
       END OF ty_hname.

*Workcenter
TYPES: BEGIN OF ty_arbpl,
         arbpl TYPE arbpl,
         objid TYPE cr_objid,
         kapid TYPE kapid,
       END OF ty_arbpl.

*Quantities
TYPES: BEGIN OF ty_qtd_desc,
         seqid    TYPE zabsf_pp_e_seqid,
         qtd_desc TYPE char15,
       END OF ty_qtd_desc.

*Shift
TYPES: BEGIN OF ty_shift,
         shiftid    TYPE zabsf_pp_e_shiftid,
         shift_desc TYPE zabsf_pp_e_shiftdesc,
       END OF ty_shift.

*Types for totals
*TYPES: BEGIN OF ty_total,
*         areaid      TYPE zabsf_pp_e_areaid,
*         hname       TYPE cr_hname,
*         werks       TYPE werks_d,
*         arbpl       TYPE arbpl,
*         shiftid     TYPE zlp_sf_e_shiftid,
*         week        TYPE kweek,
*         tot_gamng   TYPE zlp_sf_e_tweek,
*         tot_lmnga   TYPE zlp_sf_e_tweek,
*         tot_xmnga   TYPE zlp_sf_e_tweek,
*         tot_rmnga   TYPE zlp_sf_e_tweek,
*         tot_qtdprod TYPE zlp_sf_e_tweek,
*         tot_pctprod TYPE zlp_sf_e_tweek,
*       END OF ty_total.

*&---------------------------------------------------------------------*
*&  Tables
*&---------------------------------------------------------------------*
TABLES: zabsf_pp056.

*&---------------------------------------------------------------------*
*&  Tables
*&---------------------------------------------------------------------*
DATA: it_area         TYPE TABLE OF ty_area,      "Area
      it_hname        TYPE TABLE OF ty_hname,     "Hierarchy
      it_arbpl        TYPE TABLE OF ty_arbpl,     "Workcenter
      it_shift        TYPE TABLE OF ty_shift,     "Shift
      it_qtd_desc     TYPE TABLE OF ty_qtd_desc,  "Description of types quantity
      gt_qtd          TYPE TABLE OF zabsf_pp056,
      gt_times        TYPE TABLE OF zabsf_pp055,
      gt_stops        TYPE TABLE OF zabsf_pp053,
      gt_qtt_schedule TYPE TABLE OF zabsf_pp073,
      gt_util_time    TYPE TABLE OF zabsf_pp074,
      gt_sf010        TYPE TABLE OF zabsf_pp010,
      "  gt_qtd_alv      TYPE TABLE OF zlp_sf_s_data_alv,
      gt_afru         TYPE TABLE OF afru,
      gt_afru_aux     TYPE TABLE OF afru,
      " gt_total        TYPE TABLE OF ty_total,
      gt_error        TYPE bapiret2_t,
      gt_days         TYPE TABLE OF casdayattr,
      gt_workcenters  TYPE TABLE OF ty_arbpl.

*&---------------------------------------------------------------------*
*&  Work Areas
*&---------------------------------------------------------------------*
DATA: gs_qtd   TYPE zabsf_pp056, "Report OEE
      "gs_qtd_alv TYPE zlp_sf_s_data_alv,
      gr_dates TYPE rsis_t_range,
      gr_arbid TYPE rsis_t_range.
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


DATA: gv_datum TYPE datum,
      gv_uzeit TYPE tims.

"CONSTANTS c_struc_alv TYPE dd02l-tabname VALUE 'ZLP_SF_S_DATA_ALV'.

*&---------------------------------------------------------------------*
*&  Ranges
*&---------------------------------------------------------------------*
DATA: r_objid  TYPE RANGE OF cr_objid,
      wa_objid LIKE LINE OF r_objid.

*&---------------------------------------------------------------------*
*&  Field symbols
*&---------------------------------------------------------------------*
FIELD-SYMBOLS: <fs_qtd> TYPE zabsf_pp056.
*&---------------------------------------------------------------------*
*&  Constants
*&---------------------------------------------------------------------*
CONSTANTS: c_area  TYPE dfies-fieldname VALUE 'AREAID',
           c_hname TYPE dfies-fieldname VALUE 'HNAME',
           c_shift TYPE dfies-fieldname VALUE 'SHIFTID',
           c_arbpl TYPE dfies-fieldname VALUE 'ARBPL',
           c_vorg  TYPE ddbool_d        VALUE 'S',
           c_unit  TYPE char03          VALUE 'MIN'.


CONSTANTS: c_area_dyn  TYPE dynfnam VALUE 'PA_AREA',
           c_hname_dyn TYPE dynfnam VALUE 'SO_HNAME',
           c_shift_dyn TYPE dynfnam VALUE 'SO_SHIFTID',
           c_arbpl_dyn TYPE dynfnam VALUE 'SO_ARBPL'.

CONSTANTS: c_vgart  TYPE vgart VALUE 'WS',
           c_blart  TYPE blart VALUE 'WA',
           c_blaum  TYPE blaum VALUE 'PR',
           c_mec(3) TYPE c VALUE 'MEC',
           c_opt(3) TYPE c VALUE 'OPT'.
*&---------------------------------------------------------------------*
*&  Selection Screen
*&---------------------------------------------------------------------*


SELECTION-SCREEN: BEGIN OF BLOCK a2 WITH FRAME TITLE TEXT-001.
PARAMETERS: pa_werks TYPE zabsf_pp056-werks OBLIGATORY,  "Plant
            pa_30day TYPE flag.

SELECTION-SCREEN: END OF BLOCK a2.
