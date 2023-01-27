*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZABSF_PP_V_SF045................................*
TABLES: ZABSF_PP_V_SF045, *ZABSF_PP_V_SF045. "view work areas
CONTROLS: TCTRL_ZABSF_PP_V_SF045
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZABSF_PP_V_SF045. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZABSF_PP_V_SF045.
* Table for entries selected to show on screen
DATA: BEGIN OF ZABSF_PP_V_SF045_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZABSF_PP_V_SF045.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZABSF_PP_V_SF045_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZABSF_PP_V_SF045_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZABSF_PP_V_SF045.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZABSF_PP_V_SF045_TOTAL.

*.........table declarations:.................................*
TABLES: ZABSF_PP068                    .
