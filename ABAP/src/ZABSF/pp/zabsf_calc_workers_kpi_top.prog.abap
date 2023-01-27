*&---------------------------------------------------------------------*
*&  Include          ZABSF_CALC_WORKERS_KPI_TOP
*&---------------------------------------------------------------------*

*Predefine a local class for event handling to allow the
*declaration of a reference variable before the class is defined.
CLASS lcl_event_receiver DEFINITION DEFERRED.

*Types Pools
TYPE-POOLS: icon.

*Tables
TABLES: pa0002.

*Types
TYPES: BEGIN OF ty_csv,
         line TYPE string,
       END OF ty_csv.

*Global Internal tables
DATA: gt_fieldcatalog TYPE TABLE OF lvc_s_fcat,
      gt_output       TYPE TABLE OF zabsf_pp_s_calc_workers_kpi.

*Global Structures
DATA: gs_output TYPE zabsf_pp_s_calc_workers_kpi,
      gs_layout TYPE lvc_s_layo,
      gs_csv    TYPE ty_csv.

*Global references
DATA: g_custom_container TYPE REF TO cl_gui_custom_container,
      g_grid             TYPE REF TO cl_gui_alv_grid,
      g_event_receiver   TYPE REF TO lcl_event_receiver.

*Global variables
DATA: g_container TYPE scrfname VALUE 'GR_CONTAINER',
      g_ok_code   TYPE syucomm,
      g_cont_proc TYPE flag.

*Global constant
CONSTANTS c_struc_alv TYPE dd02l-tabname VALUE 'ZABSF_PP_S_CALC_WORKERS_KPI'.
