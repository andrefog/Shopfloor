*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZABSF_PP_V_SF079................................*
TABLES: ZABSF_PP_V_SF079, *ZABSF_PP_V_SF079. "view work areas
CONTROLS: TCTRL_ZABSF_PP_V_SF079
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZABSF_PP_V_SF079. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZABSF_PP_V_SF079.
* Table for entries selected to show on screen
DATA: BEGIN OF ZABSF_PP_V_SF079_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZABSF_PP_V_SF079.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZABSF_PP_V_SF079_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZABSF_PP_V_SF079_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZABSF_PP_V_SF079.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZABSF_PP_V_SF079_TOTAL.

*.........table declarations:.................................*
TABLES: ZABSF_PP079                    .
TABLES: ZABSF_PP079_T                  .
