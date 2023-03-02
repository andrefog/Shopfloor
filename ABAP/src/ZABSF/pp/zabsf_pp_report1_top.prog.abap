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
    aufpl    TYPE afru-aufpl,
    aplzl    TYPE afru-aplzl,
    aufnr    TYPE afru-aufnr,
    vornr    TYPE afru-vornr,
    kaptprog TYPE afru-kaptprog,
    gamng    TYPE afko-gamng,
    stat     TYPE jest-stat,
  END OF ty_afru,

  tt_afru TYPE STANDARD TABLE OF ty_afru WITH DEFAULT KEY.

TYPES:
  BEGIN OF ty_order_setup,
    aufpl TYPE afvc-aufpl,
    aplzl TYPE afvc-aplzl,
    vornr TYPE afvc-vornr,
    werks TYPE afvc-werks,
    arbid TYPE afvc-arbid,
    rueck TYPE afvc-rueck,
    bmsch TYPE plpo-bmsch,
    vgw01 TYPE plpo-vgw01,
    vge01 TYPE plpo-vge01,
    vgw02 TYPE plpo-vgw02,
    vge02 TYPE plpo-vge02,
    vgw03 TYPE plpo-vgw03,
    vge03 TYPE plpo-vge03,
  END OF ty_order_setup,

  tt_order_setup TYPE STANDARD TABLE OF ty_order_setup WITH DEFAULT KEY.

TYPES:
  BEGIN OF ty_stops,
    areaid     TYPE zabsf_pp010-areaid,
    hname      TYPE zabsf_pp010-hname,
    werks      TYPE zabsf_pp010-werks,
    arbpl      TYPE zabsf_pp010-arbpl,
    datesr     TYPE zabsf_pp010-datesr,
    shiftid    TYPE zabsf_pp010-shiftid,
    time       TYPE zabsf_pp010-time,
    endda      TYPE zabsf_pp010-endda,
    timeend    TYPE zabsf_pp010-timeend,
    stoptime   TYPE zabsf_pp010-stoptime,
    motivetype TYPE zabsf_pp011-motivetype,
  END OF ty_stops,

  tt_stops TYPE STANDARD TABLE OF ty_stops WITH DEFAULT KEY.

TYPES:
  BEGIN OF ty_tj30t,
    stsma TYPE tj30t-stsma,
    estat TYPE tj30t-estat,
    spras TYPE tj30t-spras,
    txt30 TYPE tj30t-txt30,
  END OF ty_tj30t,

  tt_tj30t TYPE STANDARD TABLE OF ty_tj30t WITH DEFAULT KEY.

TYPES:
  ty_alv TYPE zabsf_pp_s_alv_report1,
  tt_alv TYPE STANDARD TABLE OF ty_alv WITH DEFAULT KEY.


************************************************************************
* INTERNAL TABLES
************************************************************************
DATA:
  gt_afru        TYPE tt_afru,
  gt_workcenters TYPE tt_workcenter,
  gt_order_setup TYPE tt_order_setup,
  gt_stops       TYPE tt_stops,
  gt_tj30t       TYPE tt_tj30t,
  gt_alv         TYPE tt_alv.

************************************************************************
* GLOBAL VARIABLES
************************************************************************
DATA:
  gv_begda TYPE begda,
  gv_endda TYPE endda.

CONSTANTS:
  gc_stat_order_complete TYPE jest-stat VALUE 'E0005'.
