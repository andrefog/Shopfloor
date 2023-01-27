*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZABSF_PP_V_SF078................................*
TABLES: ZABSF_PP_V_SF078, *ZABSF_PP_V_SF078. "view work areas
CONTROLS: TCTRL_ZABSF_PP_V_SF078
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZABSF_PP_V_SF078. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZABSF_PP_V_SF078.
* Table for entries selected to show on screen
DATA: BEGIN OF ZABSF_PP_V_SF078_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZABSF_PP_V_SF078.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZABSF_PP_V_SF078_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZABSF_PP_V_SF078_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZABSF_PP_V_SF078.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZABSF_PP_V_SF078_TOTAL.

*.........table declarations:.................................*
TABLES: ZABSF_PP078                    .
