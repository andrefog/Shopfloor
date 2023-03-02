*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZABSF_PP_V_SF092................................*
TABLES: ZABSF_PP_V_SF092, *ZABSF_PP_V_SF092. "view work areas
CONTROLS: TCTRL_ZABSF_PP_V_SF092
TYPE TABLEVIEW USING SCREEN '0002'.
DATA: BEGIN OF STATUS_ZABSF_PP_V_SF092. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZABSF_PP_V_SF092.
* Table for entries selected to show on screen
DATA: BEGIN OF ZABSF_PP_V_SF092_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZABSF_PP_V_SF092.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZABSF_PP_V_SF092_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZABSF_PP_V_SF092_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZABSF_PP_V_SF092.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZABSF_PP_V_SF092_TOTAL.

*.........table declarations:.................................*
TABLES: ZABSF_PP092                    .
