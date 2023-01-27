*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

*Temp shift data
TYPES: BEGIN OF ty_s_shift_tmp,
         areaid      TYPE zabsf_pp_e_areaid,
         werks       TYPE werks_d,
         shiftid     TYPE zabsf_pp_e_shiftid,
         shift_desc  TYPE zabsf_pp_e_shiftdesc,
         fcalid      TYPE wfcid,
         shift_start TYPE eshift_start,
         shift_end   TYPE eshift_end,
         shift_down  TYPE zabsf_pp_e_shift_down,
         shift_up    TYPE zabsf_pp_e_shift_up,
       END OF ty_s_shift_tmp.

TYPES ty_t_shift_tmp TYPE STANDARD TABLE OF ty_s_shift_tmp.
