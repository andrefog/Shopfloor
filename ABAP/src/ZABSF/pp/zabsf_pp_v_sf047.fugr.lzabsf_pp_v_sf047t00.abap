*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZABSF_PP_V_SF047................................*
TABLES: ZABSF_PP_V_SF047, *ZABSF_PP_V_SF047. "view work areas
CONTROLS: TCTRL_ZABSF_PP_V_SF047
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZABSF_PP_V_SF047. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZABSF_PP_V_SF047.
* Table for entries selected to show on screen
DATA: BEGIN OF ZABSF_PP_V_SF047_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZABSF_PP_V_SF047.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZABSF_PP_V_SF047_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZABSF_PP_V_SF047_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZABSF_PP_V_SF047.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZABSF_PP_V_SF047_TOTAL.

*.........table declarations:.................................*
TABLES: TC24                           .
TABLES: TRUG                           .
TABLES: TRUGT                          .
TABLES: ZABSF_PP072                    .
