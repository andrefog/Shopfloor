*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZABSF_ADM_PARAM.................................*
DATA:  BEGIN OF STATUS_ZABSF_ADM_PARAM               .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZABSF_ADM_PARAM               .
CONTROLS: TCTRL_ZABSF_ADM_PARAM
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZABSF_ADM_PARAM               .
TABLES: ZABSF_ADM_PARAM                .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
