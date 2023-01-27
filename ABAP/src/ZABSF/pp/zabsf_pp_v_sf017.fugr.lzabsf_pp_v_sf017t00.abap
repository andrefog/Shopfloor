*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZABSF_PP_V_SF017................................*
TABLES: ZABSF_PP_V_SF017, *ZABSF_PP_V_SF017. "view work areas
CONTROLS: TCTRL_ZABSF_PP_V_SF017
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZABSF_PP_V_SF017. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZABSF_PP_V_SF017.
* Table for entries selected to show on screen
DATA: BEGIN OF ZABSF_PP_V_SF017_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZABSF_PP_V_SF017.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZABSF_PP_V_SF017_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZABSF_PP_V_SF017_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZABSF_PP_V_SF017.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZABSF_PP_V_SF017_TOTAL.

*.........table declarations:.................................*
TABLES: ZABSF_PP023                    .
TABLES: ZABSF_PP023_T                  .
