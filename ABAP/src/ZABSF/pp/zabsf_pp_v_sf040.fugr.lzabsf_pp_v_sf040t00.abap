*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZABSF_PP_V_SF040................................*
TABLES: ZABSF_PP_V_SF040, *ZABSF_PP_V_SF040. "view work areas
CONTROLS: TCTRL_ZABSF_PP_V_SF040
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZABSF_PP_V_SF040. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZABSF_PP_V_SF040.
* Table for entries selected to show on screen
DATA: BEGIN OF ZABSF_PP_V_SF040_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZABSF_PP_V_SF040.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZABSF_PP_V_SF040_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZABSF_PP_V_SF040_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZABSF_PP_V_SF040.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZABSF_PP_V_SF040_TOTAL.

*.........table declarations:.................................*
TABLES: ZABSF_PP061                    .
