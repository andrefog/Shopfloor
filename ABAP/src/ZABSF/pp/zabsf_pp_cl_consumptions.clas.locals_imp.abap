*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

*Type for Bill of material
TYPES: BEGIN OF ty_stlnr,
         stlnr TYPE stnum,
         stlty TYPE stlty,
       END OF ty_stlnr.

*Type for range for components in reporting point
TYPES: BEGIN OF ty_range_comp,
         stlnr TYPE stnum,  "BOM list
         stlty TYPE stlty,  "BOM category
         stknr TYPE	stlkn,  "BOM item node number
       END OF ty_range_comp.
