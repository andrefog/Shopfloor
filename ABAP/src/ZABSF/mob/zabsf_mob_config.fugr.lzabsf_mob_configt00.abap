*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZABSF_MOB_CONFIG................................*
DATA:  BEGIN OF STATUS_ZABSF_MOB_CONFIG              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZABSF_MOB_CONFIG              .
CONTROLS: TCTRL_ZABSF_MOB_CONFIG
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZABSF_MOB_CONFIG              .
TABLES: ZABSF_MOB_CONFIG               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
