*&---------------------------------------------------------------------*
*&  Include           ZABSF_PP_REPORT1_TOP
*&---------------------------------------------------------------------*

************************************************************************
* TABLES
************************************************************************
TABLES:
  zabsf_pp010,
  aufk.

************************************************************************
* TYPES
************************************************************************
TYPES:
  BEGIN OF ty_workcenter,
    werks TYPE crhh-werks,
    hname TYPE crhh-name,
    arbpl TYPE crhd-arbpl,
    objid TYPE crhd-objid,
    kapid TYPE kako-kapid,
    stsma TYPE jsto-stsma,
    stat  TYPE jest-stat,
  END OF ty_workcenter,

  tt_workcenter TYPE STANDARD TABLE OF ty_workcenter WITH DEFAULT KEY.

TYPES:
  BEGIN OF ty_afru,
    rueck    TYPE afru-rueck,
    arbid    TYPE afru-arbid,
    werks    TYPE afru-werks,
    lmnga    TYPE afru-lmnga,
    xmnga    TYPE afru-xmnga,
    rmnga    TYPE afru-rmnga,
    isdd     TYPE afru-isdd,
    isdz     TYPE afru-isdz,
    aufnr    TYPE afru-aufnr,
    vornr    TYPE afru-vornr,
    kaptprog TYPE afru-kaptprog,
    auart    TYPE aufk-auart,
    matnr    TYPE afpo-matnr,
    steus    TYPE afvc-steus,
  END OF ty_afru,

  tt_afru TYPE STANDARD TABLE OF ty_afru WITH DEFAULT KEY.

TYPES:
  BEGIN OF ty_stops,
    areaid   TYPE zabsf_pp010-areaid,
    hname    TYPE zabsf_pp010-hname,
    werks    TYPE zabsf_pp010-werks,
    arbpl    TYPE zabsf_pp010-arbpl,
    begda    TYPE zabsf_pp010-datesr,
    shiftid  TYPE zabsf_pp010-shiftid,
    begtm    TYPE zabsf_pp010-time,
    endda    TYPE zabsf_pp010-endda,
    endtm    TYPE zabsf_pp010-timeend,
    stoptime TYPE zabsf_pp010-stoptime,
  END OF ty_stops,

  tt_stops TYPE STANDARD TABLE OF ty_stops WITH DEFAULT KEY.

TYPES:
  BEGIN OF ty_rework,
    aufnr    TYPE zabsf_pp004-aufnr,
    defectid TYPE zabsf_pp004-defectid,
    rework   TYPE zabsf_pp004-rework,
    data     TYPE zabsf_pp004-data,
    timer    TYPE zabsf_pp004-timer,
  END OF ty_rework,

  tt_rework TYPE STANDARD TABLE OF ty_rework WITH DEFAULT KEY.

TYPES:
  BEGIN OF ty_scraps,
    matnr TYPE zabsf_pp034-matnr,
    data  TYPE zabsf_pp034-data,
    time  TYPE zabsf_pp034-time,
    grund TYPE zabsf_pp034-grund,
  END OF ty_scraps,

  tt_scraps TYPE STANDARD TABLE OF ty_scraps WITH DEFAULT KEY.

TYPES:
  BEGIN OF ty_trugt,
    werks TYPE trugt-werks,
    grund TYPE trugt-grund,
    grdtx TYPE trugt-grdtx,
  END OF ty_trugt,

  tt_trugt TYPE STANDARD TABLE OF ty_trugt WITH DEFAULT KEY.

TYPES:
  ty_alv TYPE zabsf_pp_s_alv_report2,
  tt_alv TYPE STANDARD TABLE OF ty_alv WITH DEFAULT KEY.

************************************************************************
* INTERNAL TABLES
************************************************************************
DATA:
  gt_workcenters TYPE tt_workcenter,
  gt_afru        TYPE tt_afru,
  gt_stops       TYPE tt_stops,
  gt_reworks     TYPE tt_rework,
  gt_scraps      TYPE tt_scraps,
  gt_trugt       TYPE tt_trugt,
  gt_alv         TYPE tt_alv.

************************************************************************
* GLOBAL VARIABLES
************************************************************************
DATA:
  gv_begda TYPE begda,
  gv_endda TYPE endda.
