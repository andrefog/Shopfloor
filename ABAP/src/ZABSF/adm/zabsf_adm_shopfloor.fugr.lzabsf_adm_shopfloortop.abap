FUNCTION-POOL zabsf_adm_shopfloor.          "MESSAGE-ID ..

* INCLUDE LZABSF_ADM_SHOPFLOORD...           " Local class definition

TYPES:
  BEGIN OF ty_s_hierarchy.
    INCLUDE STRUCTURE zabsf_pp_s_wrkctr.
  TYPES:
    objid TYPE cr_objid,
  END OF ty_s_hierarchy,

  ty_t_hirarchy TYPE STANDARD TABLE OF ty_s_hierarchy WITH DEFAULT KEY.
