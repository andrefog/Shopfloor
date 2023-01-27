*&---------------------------------------------------------------------*
*&  Include           Z_LP_PP_SF_PASSAGE_SCREEN
*&---------------------------------------------------------------------*
SELECTION-SCREEN: BEGIN OF BLOCK a1 WITH FRAME TITLE TEXT-000.
SELECT-OPTIONS: so_matnr FOR zabsf_pp047-matnr NO INTERVALS,  "Material
                so_gernr FOR zabsf_pp047-gernr NO INTERVALS,
                so_opt   FOR zabsf_pp047-result_def NO INTERVALS,
                so_date  FOR zabsf_pp047-date_reg DEFAULT sy-datum TO sy-datum.

PARAMETERS: pa_area TYPE zabsf_pp_e_areaid DEFAULT 'MONT'.

SELECTION-SCREEN: END OF BLOCK a1.
