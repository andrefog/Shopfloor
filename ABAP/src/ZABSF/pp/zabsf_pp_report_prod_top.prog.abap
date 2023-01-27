*&---------------------------------------------------------------------*
*&  Include           Z_LP_PP_SF_REPORT_PROD_TOP
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Types
*&---------------------------------------------------------------------*
*Area
TYPES: BEGIN OF ty_area,
         areaid    TYPE zabsf_pp_e_areaid,
         area_desc TYPE zabsf_pp_e_areadesc,
       END OF ty_area.

*Hierarchy
TYPES: BEGIN OF ty_hname,
         hname TYPE cr_hname,
         ktext  TYPE cr_ktext,
       END OF ty_hname.

*Workcenter
TYPES: BEGIN OF ty_arbpl,
         arbpl TYPE arbpl,
         ktext  TYPE cr_ktext,
       END OF ty_arbpl.

*Shift
TYPES: BEGIN OF ty_shift,
         shiftid     TYPE zabsf_pp_e_shiftid,
         shift_desc TYPE zabsf_pp_e_shiftdesc,
       END OF ty_shift.

*&---------------------------------------------------------------------*
*&  Tables
*&---------------------------------------------------------------------*
TABLES: zabsf_pp055.

*&---------------------------------------------------------------------*
*&  Tables
*&---------------------------------------------------------------------*
DATA: it_area     TYPE TABLE OF ty_area,      "Area
      it_hname    TYPE TABLE OF ty_hname,     "Hierarchy
      it_arbpl    TYPE TABLE OF ty_arbpl,     "Workcenter
      it_shift    TYPE TABLE OF ty_shift,     "Shift
      gt_prod     TYPE TABLE OF zabsf_pp055,
      gt_prod_alv TYPE TABLE OF zabsf_pp_s_data_alv,
      gt_error    TYPE bapiret2_t.


*&---------------------------------------------------------------------*
*&  Work Areas
*&---------------------------------------------------------------------*
DATA: gs_prod     TYPE zabsf_pp055, "Report Prodcution
      gs_prod_alv TYPE zabsf_pp_s_data_alv.

*&---------------------------------------------------------------------*
*&  Variables
*&---------------------------------------------------------------------*
DATA: gv_stoptime TYPE zabsf_pp_e_stoptime,
      gv_stopunit TYPE zabsf_pp_e_stopunit.

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

CONSTANTS c_struc_alv TYPE dd02l-tabname VALUE 'ZABSF_PP_S_DATA_ALV'.

*&---------------------------------------------------------------------*
*&  Ranges
*&---------------------------------------------------------------------*


*&---------------------------------------------------------------------*
*&  Field symbols
*&---------------------------------------------------------------------*
FIELD-SYMBOLS: <fs_prod> TYPE zabsf_pp055.

*&---------------------------------------------------------------------*
*&  Constants
*&---------------------------------------------------------------------*
CONSTANTS: c_area  TYPE dfies-fieldname VALUE 'AREAID',
           c_hname TYPE dfies-fieldname VALUE 'HNAME',
           c_shift TYPE dfies-fieldname VALUE 'SHIFTID',
           c_arbpl TYPE dfies-fieldname VALUE 'ARBPL',
           c_vorg  TYPE ddbool_d        VALUE 'S',
           c_unit  TYPE char03          VALUE 'MIN',
           c_mec   TYPE zabsf_pp_e_areaid VALUE 'MEC',
           c_opt   TYPE zabsf_pp_e_areaid VALUE 'OPT',
           c_prd   TYPE zabsf_pp_e_areaid VALUE 'PRD',
           c_mont  TYPE zabsf_pp_e_areaid VALUE 'MONT'.


CONSTANTS: c_area_dyn  TYPE dynfnam VALUE 'PA_AREA',
           c_hname_dyn TYPE dynfnam VALUE 'SO_HNAME',
           c_shift_dyn TYPE dynfnam VALUE 'SO_SHIFTID',
           c_arbpl_dyn TYPE dynfnam VALUE 'SO_ARBPL'.

*&---------------------------------------------------------------------*
*&  Selection Screen
*&---------------------------------------------------------------------*

SELECTION-SCREEN: BEGIN OF BLOCK a1 WITH FRAME TITLE TEXT-000.
PARAMETERS: pa_regt RADIOBUTTON GROUP r1 USER-COMMAND radio DEFAULT 'X',
            pa_hist RADIOBUTTON GROUP r1.
SELECTION-SCREEN: END OF BLOCK a1.

SELECTION-SCREEN: BEGIN OF BLOCK a2 WITH FRAME TITLE TEXT-001.
PARAMETERS: pa_area  TYPE zabsf_pp055-areaid OBLIGATORY,  "Area
            pa_werks TYPE zabsf_pp055-werks  DEFAULT '0070' OBLIGATORY.  "Plant

SELECT-OPTIONS: so_hname FOR zabsf_pp055-hname    NO INTERVALS MODIF ID sp1,  "Name of hierarchy
                so_arbpl FOR zabsf_pp055-arbpl    NO INTERVALS MODIF ID sp1,  "Workcenter
                so_shift FOR zabsf_pp055-shiftid  MODIF ID sp1,               "Shift
                so_date  FOR zabsf_pp055-data     DEFAULT sy-datum TO sy-datum MODIF ID sp2.
PARAMETERS: pa_date TYPE zabsf_pp051-data DEFAULT sy-datum MODIF ID sp3.
SELECTION-SCREEN: END OF BLOCK a2.

SELECTION-SCREEN: BEGIN OF BLOCK a3 WITH FRAME TITLE TEXT-002.
PARAMETERS: pa_simul RADIOBUTTON GROUP r2 DEFAULT 'X' MODIF ID sp3,
            pa_creat RADIOBUTTON GROUP r2 MODIF ID sp3.
SELECTION-SCREEN: END OF BLOCK a3.

*&---------------------------------------------------------------------*
*&  Disable parameter in selection screen
*&---------------------------------------------------------------------*
AT SELECTION-SCREEN OUTPUT.

*Put parameter date invisible
  LOOP AT SCREEN.
    IF pa_regt IS NOT INITIAL.
      IF screen-group1 = 'SP2'.
        screen-input = '0'.
        screen-invisible = '1'.
        screen-required = '0'.
        MODIFY SCREEN.
      ENDIF.
    ENDIF.

*  Put selection screen a3 inactive
    IF pa_hist IS NOT INITIAL.
      IF screen-group1 = 'SP3'.
        screen-input = '0'.
        screen-invisible = '1'.
        screen-active = '0'.
        MODIFY SCREEN.
      ENDIF.

*    Put date obligatory
      IF screen-group1 = 'SP2'.
        screen-input = '1'.
        screen-invisible = '0'.
        screen-required = '1'.
        MODIFY SCREEN.
      ENDIF.
    ENDIF.
  ENDLOOP.

*&---------------------------------------------------------------------*
*&  F4 for select options
*&---------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_area.
*Get area id and area description
  SELECT *
    FROM zabsf_pp000_t
    INTO CORRESPONDING FIELDS OF TABLE it_area
    WHERE spras EQ sy-langu.

*Sort table
  SORT it_area BY areaid.

*Delete duplicates
  DELETE ADJACENT DUPLICATES FROM it_area.

  PERFORM create_f4_field USING c_area c_vorg c_area_dyn pa_area it_area.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR so_hname-low.
*Get Hierarchies
  SELECT sft002~hname crtx~ktext
    INTO CORRESPONDING FIELDS OF TABLE it_hname
    FROM zabsf_pp002 AS sft002
   INNER JOIN crhh AS crhh
      ON crhh~name EQ sft002~hname
   INNER JOIN crtx AS crtx
      ON crtx~objty EQ crhh~objty
     AND crtx~objid EQ crhh~objid
   WHERE sft002~areaid  EQ pa_area
     AND sft002~werks   EQ pa_werks
     AND sft002~shiftid IN so_shift
     AND sft002~begda   LE pa_date
     AND sft002~endda   GE pa_date
     AND crhh~objty     EQ 'H'
     AND crtx~spras     EQ sy-langu.

*Sort table
  SORT it_hname BY hname.

*Delete duplicates
  DELETE ADJACENT DUPLICATES FROM it_hname.

  PERFORM create_f4_field USING c_hname c_vorg c_hname_dyn so_hname-low it_hname.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR so_arbpl-low.

*Get workceter
  PERFORM get_workcenters TABLES so_hname USING pa_area pa_werks CHANGING it_arbpl.

*Sort table
  SORT it_arbpl BY arbpl.
*Delete duplicates
  DELETE ADJACENT DUPLICATES FROM it_arbpl.

  PERFORM create_f4_field USING c_arbpl c_vorg c_arbpl_dyn so_arbpl-low it_arbpl.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR so_shift-low.
*Get shift
  SELECT sft001~shiftid sft001t~shift_desc
    INTO CORRESPONDING FIELDS OF TABLE it_shift
    FROM zabsf_pp001 AS sft001
   INNER JOIN zabsf_pp001_t AS sft001t
      ON sft001t~areaid  EQ sft001~areaid
     AND sft001t~werks   EQ sft001~werks
     AND sft001t~shiftid EQ sft001~shiftid
   WHERE sft001~areaid EQ pa_area
     AND sft001~werks  EQ pa_werks
     AND sft001~begda  LE pa_date
     AND sft001~endda  GE pa_date
     AND sft001t~spras EQ sy-langu.

*Sort table
  SORT it_shift BY shiftid.

*Delete duplicates
  DELETE ADJACENT DUPLICATES FROM it_shift.

  PERFORM create_f4_field USING c_shift c_vorg c_shift_dyn so_shift-low it_shift.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR so_shift-high.
*Get shift
  SELECT sft001~shiftid sft001t~shift_desc
    INTO CORRESPONDING FIELDS OF TABLE it_shift
    FROM zabsf_pp001 AS sft001
   INNER JOIN zabsf_pp001_t AS sft001t
      ON sft001t~areaid  EQ sft001~areaid
     AND sft001t~werks   EQ sft001~werks
     AND sft001t~shiftid EQ sft001~shiftid
   WHERE sft001~areaid EQ pa_area
     AND sft001~werks  EQ pa_werks
     AND sft001~begda  LE pa_date
     AND sft001~endda  GE pa_date
     AND sft001t~spras EQ sy-langu.

*Sort table
  SORT it_shift BY shiftid.

*Delete duplicates
  DELETE ADJACENT DUPLICATES FROM it_shift.

  PERFORM create_f4_field USING c_shift c_vorg c_shift_dyn so_shift-low it_shift.
