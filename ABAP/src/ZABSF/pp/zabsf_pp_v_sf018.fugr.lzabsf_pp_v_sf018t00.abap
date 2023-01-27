*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZABSF_PP_V_SF018................................*
TABLES: ZABSF_PP_V_SF018, *ZABSF_PP_V_SF018. "view work areas
CONTROLS: TCTRL_ZABSF_PP_V_SF018
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZABSF_PP_V_SF018. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZABSF_PP_V_SF018.
* Table for entries selected to show on screen
DATA: BEGIN OF ZABSF_PP_V_SF018_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZABSF_PP_V_SF018.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZABSF_PP_V_SF018_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZABSF_PP_V_SF018_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZABSF_PP_V_SF018.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZABSF_PP_V_SF018_TOTAL.

*.........table declarations:.................................*
TABLES: ZABSF_PP018                    .
TABLES: ZABSF_PP018_T                  .
TABLES: ZABSF_PP023                    .
TABLES: ZABSF_PP023_T                  .
TABLES: ZABSF_PP024                    .
