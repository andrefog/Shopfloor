*&---------------------------------------------------------------------*
*&  Include           Z_LP_PP_SF_REPORT_OEE_TOP
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&  Types
*&---------------------------------------------------------------------*
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
         ktext TYPE cr_ktext,
         kapid TYPE kapid,
       END OF ty_arbpl.

*Indicator OEE
TYPES: BEGIN OF ty_oee,
         oeeid      TYPE zabsf_pp_e_oeeid,
         oeeid_desc TYPE zabsf_pp_e_oeeid_desc,
       END OF ty_oee.

*Shift
TYPES: BEGIN OF ty_shift,
         shiftid    TYPE zabsf_pp_e_shiftid,
         shift_desc TYPE zabsf_pp_e_shiftdesc,
       END OF ty_shift.

*Type for values calculated
TYPES: BEGIN OF ty_calc_value,
         areaid       TYPE zabsf_pp_e_areaid,
         hname        TYPE cr_hname,
         werks        TYPE werks_d,
         arbpl        TYPE arbpl,
         oeeid        TYPE zabsf_pp_e_oeeid,
         shiftid      TYPE zabsf_pp_e_shiftid,
         data         TYPE datum,
         plan_prod    TYPE mengv13,
         oper_time    TYPE mengv13,
         tot_pieces   TYPE mengv13,
         run_rate     TYPE mengv13,
         run_rate_prd TYPE mengv13,
         good_pieces  TYPE mengv13,
         real_time    TYPE mengv13,
         avaibility   TYPE mengv13,
         performance  TYPE mengv13,
         quality      TYPE mengv13,
         oee          TYPE mengv13,
         productivit  TYPE mengv13,
       END OF ty_calc_value.

*&---------------------------------------------------------------------*
*&  Tables
*&---------------------------------------------------------------------*
TABLES: zabsf_pp051.

*&---------------------------------------------------------------------*
*&  Tables
*&---------------------------------------------------------------------*
DATA: it_area     TYPE TABLE OF ty_area,      "Area
      it_hname    TYPE TABLE OF ty_hname,     "Hierarchy
      it_arbpl    TYPE TABLE OF ty_arbpl,     "Workcenter
      it_oee      TYPE TABLE OF ty_oee,       "Indicator OEE
      it_shift    TYPE TABLE OF ty_shift,     "Shift
      gt_oee      TYPE TABLE OF zabsf_pp051, "Report OEE
      gt_oee_alv  TYPE TABLE OF zabsf_pp_s_data_alv,
      gt_calc_val TYPE TABLE OF ty_calc_value,
      gt_afru     TYPE TABLE OF afru,
      gt_error    TYPE bapiret2_t.

*&---------------------------------------------------------------------*
*&  Work Areas
*&---------------------------------------------------------------------*
DATA: gs_oee     TYPE zabsf_pp051, "Report OEE
      gs_oee_alv TYPE zabsf_pp_s_data_alv.

*&---------------------------------------------------------------------*
*&  Variables
*&---------------------------------------------------------------------*
DATA: gv_plan_prod    TYPE mengv13,
      gv_oper_time    TYPE mengv13,
      gv_tot_pieces   TYPE mengv13,
      gv_run_rate     TYPE mengv13,
      gv_run_rate_prd TYPE mengv13,
      gv_good_pieces  TYPE mengv13,
      gv_real_time    TYPE mengv13,
      gv_avaibility   TYPE mengv13,
      gv_performance  TYPE mengv13,
      gv_quality      TYPE mengv13,
      gv_oee          TYPE mengv13,
      gv_productivit  TYPE mengv13,
      flag_error      TYPE c.

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
DATA: r_objid  TYPE RANGE OF cr_objid,
      wa_objid LIKE LINE OF r_objid.

*&---------------------------------------------------------------------*
*&  Field symbols
*&---------------------------------------------------------------------*
FIELD-SYMBOLS: <fs_oee> TYPE zabsf_pp051.
*&---------------------------------------------------------------------*
*&  Constants
*&---------------------------------------------------------------------*
CONSTANTS: c_area  TYPE dfies-fieldname VALUE 'AREAID',
           c_hname TYPE dfies-fieldname VALUE 'HNAME',
           c_oee   TYPE dfies-fieldname VALUE 'OEEID',
           c_shift TYPE dfies-fieldname VALUE 'SHIFTID',
           c_arbpl TYPE dfies-fieldname VALUE 'ARBPL',
           c_vorg  TYPE ddbool_d        VALUE 'S',
           c_unit  TYPE char03          VALUE 'MIN'.


CONSTANTS: c_area_dyn  TYPE dynfnam VALUE 'PA_AREA',
           c_hname_dyn TYPE dynfnam VALUE 'SO_HNAME',
           c_oee_dyn   TYPE dynfnam VALUE 'SO_OEEID',
           c_shift_dyn TYPE dynfnam VALUE 'SO_SHIFTID',
           c_arbpl_dyn TYPE dynfnam VALUE 'SO_ARBPL'.

CONSTANTS: c_vgart  TYPE vgart VALUE 'WR',
           c_blart  TYPE blart VALUE 'WA',
           c_blaum  TYPE blaum VALUE 'PR',
           c_mec(3) TYPE c VALUE 'MEC',
           c_opt(3) TYPE c VALUE 'OPT',
           c_prd(3) TYPE c VALUE 'PRD'.

*&---------------------------------------------------------------------*
*&  Selection Screen
*&---------------------------------------------------------------------*

SELECTION-SCREEN: BEGIN OF BLOCK a1 WITH FRAME TITLE TEXT-009.
PARAMETERS: pa_regt RADIOBUTTON GROUP r1 USER-COMMAND radio DEFAULT 'X',
            pa_hist RADIOBUTTON GROUP r1.
SELECTION-SCREEN: END OF BLOCK a1.

SELECTION-SCREEN: BEGIN OF BLOCK a2 WITH FRAME TITLE TEXT-000.
PARAMETERS: pa_area  TYPE zabsf_pp051-areaid DEFAULT 'MEC' OBLIGATORY,  "Area
            pa_werks TYPE zabsf_pp051-werks DEFAULT '0070' OBLIGATORY.  "Plant

SELECT-OPTIONS: so_hname FOR zabsf_pp051-hname   NO INTERVALS MODIF ID sp1,  "Name of hierarchy
                so_arbpl FOR zabsf_pp051-arbpl   NO INTERVALS MODIF ID sp1,  "Workcenter
                so_oeeid FOR zabsf_pp051-oeeid   NO INTERVALS MODIF ID sp1,  "Indicator OEE
                so_shift FOR zabsf_pp051-shiftid MODIF ID sp1,              "Shift
                so_date  FOR zabsf_pp051-data    DEFAULT sy-datum TO sy-datum MODIF ID sp2.
PARAMETERS: pa_date TYPE zabsf_pp051-data DEFAULT sy-datum MODIF ID sp3.
SELECTION-SCREEN: END OF BLOCK a2.

SELECTION-SCREEN: BEGIN OF BLOCK a3 WITH FRAME TITLE TEXT-001.
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

  PERFORM get_workcenters TABLES so_hname USING pa_area pa_werks CHANGING it_arbpl.

*Sort table
  SORT it_arbpl BY arbpl.
*Delete duplicates
  DELETE ADJACENT DUPLICATES FROM it_arbpl.

  PERFORM create_f4_field USING c_arbpl c_vorg c_arbpl_dyn so_arbpl-low it_arbpl.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR so_oeeid-low.
*Get indicators OEE
  SELECT *
    FROM zabsf_pp050_t
    INTO CORRESPONDING FIELDS OF TABLE it_oee
    WHERE spras EQ sy-langu.
*Sort table
  SORT it_oee BY oeeid.
*Delete duplicates
  DELETE ADJACENT DUPLICATES FROM it_oee.

  PERFORM create_f4_field USING c_oee c_vorg c_oee_dyn so_oeeid-low it_oee.

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

  PERFORM create_f4_field USING c_shift c_vorg c_shift_dyn so_shift-high it_shift.
