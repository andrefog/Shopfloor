*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZBC_FIXVAL_T....................................*
DATA:  BEGIN OF STATUS_ZBC_FIXVAL_T                  .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZBC_FIXVAL_T                  .
CONTROLS: TCTRL_ZBC_FIXVAL_T
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZBC_FIXVAL_T                  .
TABLES: ZBC_FIXVAL_T                   .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
