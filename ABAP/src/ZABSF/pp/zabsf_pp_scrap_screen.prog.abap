*&---------------------------------------------------------------------*
*&  Include           Z_LP_PP_SF_SCRAP_SCREEN
*&---------------------------------------------------------------------*
SELECTION-SCREEN: BEGIN OF BLOCK a1 WITH FRAME TITLE TEXT-000.
PARAMETERS: pa_area TYPE zabsf_pp_e_areaid DEFAULT 'OPT'.

SELECT-OPTIONS: so_matnr FOR zabsf_pp034-matnr  NO INTERVALS,  "Material
                so_ware  FOR zabsf_pp034-wareid NO INTERVALS,
                so_date  FOR zabsf_pp034-data DEFAULT sy-datum TO sy-datum.
SELECTION-SCREEN: END OF BLOCK a1.

*&---------------------------------------------------------------------*
*&  F4 for select options
*&---------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR so_ware-low.

*Get warehouse
  SELECT zabsf_pp025~wareid zabsf_pp025_t~ware_desc
    INTO CORRESPONDING FIELDS OF TABLE it_ware
    FROM zabsf_pp025 AS zabsf_pp025
   INNER JOIN zabsf_pp025_t AS zabsf_pp025_t
      ON zabsf_pp025_t~areaid EQ zabsf_pp025~areaid
     AND zabsf_pp025_t~werks  EQ zabsf_pp025~werks
     AND zabsf_pp025_t~wareid EQ zabsf_pp025~wareid
   WHERE zabsf_pp025~areaid EQ pa_area
     AND zabsf_pp025~werks  EQ c_werks.

*Sort table
  SORT it_ware BY wareid.

*Delete duplicates
  DELETE ADJACENT DUPLICATES FROM it_ware.

  PERFORM create_f4_field USING c_ware c_vorg c_ware_dyn so_ware it_ware.
