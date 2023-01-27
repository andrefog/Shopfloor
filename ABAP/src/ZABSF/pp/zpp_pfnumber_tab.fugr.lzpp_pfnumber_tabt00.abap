*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZPP_PFNUMBER_TAB................................*
DATA:  BEGIN OF STATUS_ZPP_PFNUMBER_TAB              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZPP_PFNUMBER_TAB              .
CONTROLS: TCTRL_ZPP_PFNUMBER_TAB
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZPP_PFNUMBER_TAB              .
TABLES: ZPP_PFNUMBER_TAB               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
