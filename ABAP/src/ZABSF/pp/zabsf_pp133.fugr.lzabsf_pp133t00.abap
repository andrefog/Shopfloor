*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZABSF_PP133.....................................*
DATA:  BEGIN OF STATUS_ZABSF_PP133                   .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZABSF_PP133                   .
CONTROLS: TCTRL_ZABSF_PP133
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZABSF_PP133                   .
TABLES: ZABSF_PP133                    .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
