*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZABSF_PPLABELS..................................*
DATA:  BEGIN OF STATUS_ZABSF_PPLABELS                .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZABSF_PPLABELS                .
CONTROLS: TCTRL_ZABSF_PPLABELS
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZABSF_PPLABELS                .
TABLES: ZABSF_PPLABELS                 .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
