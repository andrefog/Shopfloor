*&---------------------------------------------------------------------*
*& Include          ZABSF_DASHBOARD_JOB_TOP
*&---------------------------------------------------------------------*
TABLES:
  zabsf_pp010.

*&---------------------------------------------------------------------*
*&  Types
*&---------------------------------------------------------------------*
*Areas
TYPES:
  BEGIN OF ty_area,
    areaid TYPE zabsf_pp008-areaid,
  END OF ty_area,

  tt_areas TYPE STANDARD TABLE OF ty_area WITH DEFAULT KEY.

* Hierarchies
TYPES:
  BEGIN OF ty_hierarchy,
    areaid TYPE zabsf_pp002-areaid,
    hname  TYPE zabsf_pp002-hname,
  END OF ty_hierarchy,

  tt_hierarchies TYPE STANDARD TABLE OF ty_hierarchy WITH DEFAULT KEY.

* Shifts
TYPES:
  BEGIN OF ty_shift,
    areaid  TYPE zabsf_pp001-areaid,
    shiftid TYPE zabsf_pp001-shiftid,
  END OF ty_shift,

  tt_shifts TYPE STANDARD TABLE OF ty_shift WITH DEFAULT KEY.

*Workcenter
TYPES:
  BEGIN OF ty_workcenter,
    areaid TYPE zabsf_pp_e_areaid,
    hname  TYPE cr_hname,
    arbpl  TYPE arbpl,
    objid  TYPE cr_objid,
    kapid  TYPE kapid,
  END OF ty_workcenter,

  tt_workcenters TYPE STANDARD TABLE OF ty_workcenter WITH DEFAULT KEY.

*Type for values calculated
TYPES:
  BEGIN OF ty_calc_value,
    areaid       TYPE zlp_sf_e_areaid,
    hname        TYPE cr_hname,
    werks        TYPE werks_d,
    arbpl        TYPE arbpl,
    objid        TYPE crhd-objid,
    kapid        TYPE crhd-kapid,
    oeeid        TYPE zlp_sf_e_oeeid,
    shiftid      TYPE zlp_sf_e_shiftid,
    date         TYPE datum,
    week         TYPE scal-week,
    plan_prod    TYPE mengv13,
    oper_time    TYPE mengv13,
    tot_pieces   TYPE mengv13,
    run_rate     TYPE mengv13,
    run_rate_prd TYPE mengv13,
    good_pieces  TYPE mengv13,
    real_time    TYPE mengv13,
    availability TYPE mengv13,
    performance  TYPE mengv13,
    quality      TYPE mengv13,
    oee          TYPE mengv13,
    productivit  TYPE mengv13,
  END OF ty_calc_value,

  tt_calc_values TYPE STANDARD TABLE OF ty_calc_value WITH DEFAULT KEY.

TYPES:
  BEGIN OF ty_stop,
    areaid     TYPE zabsf_pp010-areaid,
    hname      TYPE zabsf_pp010-hname,
    arbpl      TYPE zabsf_pp010-arbpl,
    datesr     TYPE zabsf_pp010-datesr,
    shiftid    TYPE zabsf_pp010-shiftid,
    time       TYPE zabsf_pp010-time,
    endda      TYPE zabsf_pp010-endda,
    timeend    TYPE zabsf_pp010-timeend,
    stoptime   TYPE zabsf_pp010-stoptime,
    motivetype TYPE zabsf_pp011-motivetype,
  END OF ty_stop,

  tt_stops TYPE STANDARD TABLE OF ty_stop WITH DEFAULT KEY.

TYPES:
  BEGIN OF ty_times,
    areaid   TYPE zabsf_pp046-areaid,
    hname    TYPE zabsf_pp046-hname,
    arbpl    TYPE zabsf_pp046-rpoint,
    date     TYPE zabsf_pp046-datesr,
    time     TYPE zabsf_pp046-begtime,
    shiftid  TYPE zabsf_pp046-shiftid,
    worktime TYPE dec15,
  END OF ty_times,

  tt_times TYPE STANDARD TABLE OF ty_times WITH DEFAULT KEY.

TYPES:
  BEGIN OF ty_afru,
    rueck    TYPE afru-rueck,
    arbid    TYPE afru-arbid,
    lmnga    TYPE afru-lmnga,
    xmnga    TYPE afru-xmnga,
    rmnga    TYPE afru-rmnga,
    erzet    TYPE afru-erzet,
    isdd     TYPE afru-isdd,
    aufpl    TYPE afru-aufpl,
    aplzl    TYPE afru-aplzl,
    vornr    TYPE afru-vornr,
    kaptprog TYPE afru-kaptprog,
  END OF ty_afru,

  tt_afru TYPE STANDARD TABLE OF ty_afru WITH DEFAULT KEY.

TYPES:
  BEGIN OF ty_afvc,
    aufpl TYPE afvc-aufpl,
    aplzl TYPE afvc-aplzl,
    plnkn TYPE afvc-plnkn,
    plnty TYPE afvc-plnty,
    plnnr TYPE afvc-plnnr,
    zaehl TYPE afvc-zaehl,
    vornr TYPE afvc-vornr,
    arbid TYPE afvc-arbid,
    rueck TYPE afvc-rueck,
  END OF ty_afvc,

  tt_afvc TYPE STANDARD TABLE OF ty_afvc WITH DEFAULT KEY.

TYPES:
  BEGIN OF ty_plpo,
    plnty TYPE plpo-plnty,
    plnnr TYPE plpo-plnnr,
    plnkn TYPE plpo-plnkn,
    zaehl TYPE plpo-zaehl,
    vornr TYPE plpo-vornr,
    bmsch TYPE plpo-bmsch,
    vgw03 TYPE plpo-vgw03,
  END OF ty_plpo,

  tt_plpo TYPE STANDARD TABLE OF ty_plpo WITH DEFAULT KEY.

TYPES:
  BEGIN OF ty_kako,
    kapid   TYPE kako-kapid,
    aznor   TYPE kako-aznor,
    begzt   TYPE kako-begzt,
    endzt   TYPE kako-endzt,
    ngrad   TYPE kako-ngrad,
    pause   TYPE kako-pause,
    kapter  TYPE kako-kapter,
  END OF ty_kako,

  tt_kako TYPE STANDARD TABLE OF ty_kako WITH DEFAULT KEY.

TYPES:
  BEGIN OF ty_rework,
    areaid  TYPE zabsf_pp049-areaid,
    rpoint  TYPE zabsf_pp049-rpoint,
    data    TYPE zabsf_pp049-data,
    time    TYPE zabsf_pp049-time,
    shiftid TYPE zabsf_pp049-shiftid,
    rework  TYPE zabsf_pp049-rework,
  END OF ty_rework,

  tt_rework TYPE STANDARD TABLE OF ty_rework WITH DEFAULT KEY.

*&---------------------------------------------------------------------*
*&  Tables
*&---------------------------------------------------------------------*
DATA:
  gt_shifts      TYPE tt_shifts,
  gt_hierarchies TYPE tt_hierarchies,
  gt_areas       TYPE tt_areas,
  gt_stops       TYPE tt_stops,
  gt_times       TYPE tt_times,
  gt_rework      TYPE tt_rework,
  gt_workcenters TYPE tt_workcenters,
  gt_afru        TYPE tt_afru,
  gt_afvc        TYPE tt_afvc,
  gt_plpo        TYPE tt_plpo,
  gt_error       TYPE bapiret2_t,
  gt_kako        TYPE tt_kako,
  gt_calc_val    TYPE tt_calc_values.

*&---------------------------------------------------------------------*
*&  Variables
*&---------------------------------------------------------------------*
DATA:
  gv_date_past   TYPE begda,
  gv_date_future TYPE endda.

CONSTANTS:
  gc_mec(3) TYPE c VALUE 'MEC',
  gc_opt(3) TYPE c VALUE 'OPT',
  gc_minute TYPE i VALUE 60.

*&---------------------------------------------------------------------*
*&  Selection Screen
*&---------------------------------------------------------------------*
SELECTION-SCREEN: BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-b01.

SELECT-OPTIONS:
  s_hname FOR zabsf_pp010-hname,
  s_arbpl FOR zabsf_pp010-arbpl,
  s_shift FOR zabsf_pp010-shiftid.

SELECTION-SCREEN SKIP.

PARAMETERS:
  p_date  TYPE datum DEFAULT sy-datum, "Date
  p_werks TYPE zabsf_pp056-werks OBLIGATORY,  "Plant
  p_30day TYPE flag.

SELECTION-SCREEN: END OF BLOCK b01.
