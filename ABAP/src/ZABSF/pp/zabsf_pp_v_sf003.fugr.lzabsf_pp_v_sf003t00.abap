*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZABSF_PP_V_SF003................................*
TABLES: ZABSF_PP_V_SF003, *ZABSF_PP_V_SF003. "view work areas
CONTROLS: TCTRL_ZABSF_PP_V_SF003
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZABSF_PP_V_SF003. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZABSF_PP_V_SF003.
* Table for entries selected to show on screen
DATA: BEGIN OF ZABSF_PP_V_SF003_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZABSF_PP_V_SF003.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZABSF_PP_V_SF003_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZABSF_PP_V_SF003_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZABSF_PP_V_SF003.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZABSF_PP_V_SF003_TOTAL.

*.........table declarations:.................................*
TABLES: ZABSF_PP003                    .
TABLES: ZABSF_PP003_T                  .
