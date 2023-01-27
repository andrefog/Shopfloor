*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZABSF_MOB_CHARAC................................*
DATA:  BEGIN OF STATUS_ZABSF_MOB_CHARAC              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZABSF_MOB_CHARAC              .
CONTROLS: TCTRL_ZABSF_MOB_CHARAC
            TYPE TABLEVIEW USING SCREEN '0002'.
*...processing: ZABSF_MOB_TRFPRT................................*
DATA:  BEGIN OF STATUS_ZABSF_MOB_TRFPRT              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZABSF_MOB_TRFPRT              .
CONTROLS: TCTRL_ZABSF_MOB_TRFPRT
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZABSF_MOB_CHARAC              .
TABLES: *ZABSF_MOB_TRFPRT              .
TABLES: ZABSF_MOB_CHARAC               .
TABLES: ZABSF_MOB_TRFPRT               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
