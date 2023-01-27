*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations


*Types for goodmovements to warehouse
TYPES: BEGIN OF ty_goodsmvt,
        aufnr  TYPE aufnr,
        objnr  TYPE j_objnr,
        gstrs  TYPE co_gstrs,
        gamng  TYPE gamng,
        gmein  TYPE meins,
        plnbez TYPE matnr,
        stlbez TYPE matnr,
        aufpl  TYPE co_aufpl,
        aplzl  TYPE co_aplzl,
        arbid	 TYPE cr_objid,
        vornr  TYPE vornr,
        ltxa1  TYPE ltxa1,
        lmnga  TYPE ru_lmnga,
        steus  TYPE steus,
        stat   TYPE j_status,
        stat1  TYPE j_status,
       END OF ty_goodsmvt.

*Types for last operation mark confirmed
TYPES: BEGIN OF ty_vornr,
        aufpl     TYPE co_aufpl,
        vornr     TYPE vornr,       "last operation
        vornr_ant TYPE vornr,       "last operation mark confirmed
        aplzl_ant TYPE co_aplzl,    "couter of last mark confirmed
       END OF ty_vornr.
