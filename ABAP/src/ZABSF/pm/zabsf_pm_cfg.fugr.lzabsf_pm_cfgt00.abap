*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZABSF_PM_CHARACT................................*
DATA:  BEGIN OF STATUS_ZABSF_PM_CHARACT              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZABSF_PM_CHARACT              .
CONTROLS: TCTRL_ZABSF_PM_CHARACT
            TYPE TABLEVIEW USING SCREEN '0002'.
*...processing: ZABSF_PM_PARAM..................................*
DATA:  BEGIN OF STATUS_ZABSF_PM_PARAM                .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZABSF_PM_PARAM                .
CONTROLS: TCTRL_ZABSF_PM_PARAM
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZABSF_PM_CHARACT              .
TABLES: *ZABSF_PM_PARAM                .
TABLES: ZABSF_PM_CHARACT               .
TABLES: ZABSF_PM_PARAM                 .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
