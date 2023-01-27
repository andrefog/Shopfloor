*&---------------------------------------------------------------------*
*&  Include           Z_LP_PP_SF_CONSUMPTIONS_CHGTOP
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&  Tables
*&---------------------------------------------------------------------*
TABLES: zabsf_pp076.

*&---------------------------------------------------------------------*
*&  Types
*&---------------------------------------------------------------------*
*Shift
TYPES: BEGIN OF ty_shift,
         shiftid    TYPE zabsf_pp_e_shiftid,
         shift_desc TYPE zabsf_pp_e_shiftdesc,
       END OF ty_shift.

*&---------------------------------------------------------------------*
*&  Internal Tables
*&---------------------------------------------------------------------*
DATA: gt_alv      TYPE TABLE OF zabsf_pp_s_consumptions_alv,
      lt_consumpt TYPE TABLE OF zabsf_pp076,
      it_shift    TYPE TABLE OF ty_shift.  "Shift

*&---------------------------------------------------------------------*
*&  Structures
*&---------------------------------------------------------------------*
DATA: ls_consumpt    TYPE zabsf_pp076,
      ls_lp_pp_sf076 TYPE zabsf_pp076.


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

DATA : ls_exclude TYPE ui_func,
       pt_exclude TYPE ui_functions.


*&---------------------------------------------------------------------*
*&  Variables
*&---------------------------------------------------------------------*
DATA: l_answer,
      l_not_exec.

*&---------------------------------------------------------------------*
*&  Constants
*&---------------------------------------------------------------------*
CONSTANTS: c_shift     TYPE dfies-fieldname VALUE 'SHIFTID',
           c_vorg      TYPE ddbool_d        VALUE 'S',
           c_shift_dyn TYPE dynfnam         VALUE 'S_SHIFT',
           c_werks     TYPE werks_d          VALUE '1020',
           c_stat_p    TYPE zabsf_pp_e_status_cons VALUE 'P', "To processed
           c_stat_d    TYPE zabsf_pp_e_status_cons VALUE 'D', "Deleted
           c_stat_c    TYPE zabsf_pp_e_status_cons VALUE 'C'. "Completed

CONSTANTS c_struc_alv TYPE dd02l-tabname
                      VALUE 'ZABSF_PP_S_CONSUMPTIONS_ALV'.
