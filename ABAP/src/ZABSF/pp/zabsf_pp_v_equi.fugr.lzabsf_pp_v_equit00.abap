*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZABSF_PP_V_EQUI.................................*
TABLES: ZABSF_PP_V_EQUI, *ZABSF_PP_V_EQUI. "view work areas
CONTROLS: TCTRL_ZABSF_PP_V_EQUI
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZABSF_PP_V_EQUI. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZABSF_PP_V_EQUI.
* Table for entries selected to show on screen
DATA: BEGIN OF ZABSF_PP_V_EQUI_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZABSF_PP_V_EQUI.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZABSF_PP_V_EQUI_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZABSF_PP_V_EQUI_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZABSF_PP_V_EQUI.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZABSF_PP_V_EQUI_TOTAL.

*.........table declarations:.................................*
TABLES: ZABSF_EQUIPMENTS               .
