*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZABSF_AUTHOBJPRO................................*
DATA:  BEGIN OF STATUS_ZABSF_AUTHOBJPRO              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZABSF_AUTHOBJPRO              .
CONTROLS: TCTRL_ZABSF_AUTHOBJPRO
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZABSF_AUTHOBJPRO              .
TABLES: ZABSF_AUTHOBJPRO               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
