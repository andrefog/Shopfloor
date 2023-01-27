*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZABSF_PP_V_SF015................................*
TABLES: ZABSF_PP_V_SF015, *ZABSF_PP_V_SF015. "view work areas
CONTROLS: TCTRL_ZABSF_PP_V_SF015
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZABSF_PP_V_SF015. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZABSF_PP_V_SF015.
* Table for entries selected to show on screen
DATA: BEGIN OF ZABSF_PP_V_SF015_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZABSF_PP_V_SF015.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZABSF_PP_V_SF015_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZABSF_PP_V_SF015_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZABSF_PP_V_SF015.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZABSF_PP_V_SF015_TOTAL.

*.........table declarations:.................................*
TABLES: ZABSF_PP019                    .
