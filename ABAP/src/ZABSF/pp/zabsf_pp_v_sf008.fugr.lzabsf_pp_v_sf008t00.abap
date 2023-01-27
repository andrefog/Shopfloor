*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZABSF_PP_V_SF008................................*
TABLES: ZABSF_PP_V_SF008, *ZABSF_PP_V_SF008. "view work areas
CONTROLS: TCTRL_ZABSF_PP_V_SF008
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZABSF_PP_V_SF008. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZABSF_PP_V_SF008.
* Table for entries selected to show on screen
DATA: BEGIN OF ZABSF_PP_V_SF008_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZABSF_PP_V_SF008.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZABSF_PP_V_SF008_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZABSF_PP_V_SF008_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZABSF_PP_V_SF008.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZABSF_PP_V_SF008_TOTAL.

*.........table declarations:.................................*
TABLES: ZABSF_PP008                    .
TABLES: ZABSF_PP008_T                  .
TABLES: ZABSF_PP059                    .
TABLES: ZABSF_PP059_T                  .
