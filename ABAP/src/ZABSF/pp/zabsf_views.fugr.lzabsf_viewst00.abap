*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZABSF_PP081.....................................*
DATA:  BEGIN OF STATUS_ZABSF_PP081                   .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZABSF_PP081                   .
CONTROLS: TCTRL_ZABSF_PP081
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZABSF_PP081                   .
TABLES: ZABSF_PP081                    .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
