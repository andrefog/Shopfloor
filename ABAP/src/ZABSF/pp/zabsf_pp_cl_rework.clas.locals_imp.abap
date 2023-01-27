*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

*Temp rework order detail
TYPES: BEGIN OF ty_rework_temp,
         aufnr  TYPE aufnr,
         objnr  TYPE j_objnr,
         auart  TYPE auart,
         plnnr  TYPE plnnr,
         stlbez TYPE matnr,
         stat   TYPE j_status,
       END OF ty_rework_temp.
