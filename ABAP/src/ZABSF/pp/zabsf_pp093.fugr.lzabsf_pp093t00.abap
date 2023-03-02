*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZABSF_PP093.....................................*
DATA:  BEGIN OF STATUS_ZABSF_PP093                   .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZABSF_PP093                   .
CONTROLS: TCTRL_ZABSF_PP093
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZABSF_PP093                   .
TABLES: ZABSF_PP093                    .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
