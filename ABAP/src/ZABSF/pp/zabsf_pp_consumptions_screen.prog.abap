*&---------------------------------------------------------------------*
*&  Include   Z_LP_PP_SF_CONSUMPTIONS_SCREEN
*&---------------------------------------------------------------------*
SELECTION-SCREEN: BEGIN OF BLOCK a1 WITH FRAME TITLE TEXT-000.
*PARAMETERS: pa_area TYPE ZABSF_PP_e_areaid DEFAULT 'OPT'.
*SELECT-OPTIONS: so_matnr FOR ZABSF_PP034-matnr  NO INTERVALS,  "Material
*                so_date  FOR ZABSF_PP034-data DEFAULT sy-datum TO sy-datum.

PARAMETERS p_werks TYPE zabsf_pp076-werks DEFAULT c_werks OBLIGATORY.
SELECT-OPTIONS: s_data  FOR zabsf_pp076-data DEFAULT sy-datum TO sy-datum,
                s_shift FOR zabsf_pp076-shiftid MODIF ID sp1,
                s_aufnr FOR zabsf_pp076-aufnr,
                s_ficha FOR zabsf_pp076-ficha.
SELECTION-SCREEN: END OF BLOCK a1.


*&---------------------------------------------------------------------*
*&  F4 for select options
*&---------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_shift-low.

*Get shift
  REFRESH it_shift.
  SELECT sft001~shiftid sft001t~shift_desc
    INTO CORRESPONDING FIELDS OF TABLE it_shift
    FROM zabsf_pp001 AS sft001
   INNER JOIN zabsf_pp001_t AS sft001t
      ON sft001t~areaid  EQ sft001~areaid
     AND sft001t~werks   EQ sft001~werks
     AND sft001t~shiftid EQ sft001~shiftid
   WHERE "sft001~areaid EQ p_area
         sft001~werks  EQ p_werks
     AND sft001~begda  LE s_data-low
     AND sft001~endda  GE s_data-high
     AND sft001t~spras EQ sy-langu.

*Sort table
  SORT it_shift BY shiftid.

*Delete duplicates
  DELETE ADJACENT DUPLICATES FROM it_shift.
  PERFORM create_f4_field USING c_shift c_vorg c_shift_dyn s_shift-low it_shift.


AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_shift-high.

*Get shift
  REFRESH it_shift.
  SELECT sft001~shiftid sft001t~shift_desc
    INTO CORRESPONDING FIELDS OF TABLE it_shift
    FROM zabsf_pp001 AS sft001
   INNER JOIN zabsf_pp001_t AS sft001t
      ON sft001t~areaid  EQ sft001~areaid
     AND sft001t~werks   EQ sft001~werks
     AND sft001t~shiftid EQ sft001~shiftid
   WHERE "sft001~areaid EQ p_area
         sft001~werks  EQ p_werks
     AND sft001~begda  LE s_data-low
     AND sft001~endda  GE s_data-high
     AND sft001t~spras EQ sy-langu.

*Sort table
  SORT it_shift BY shiftid.

*Delete duplicates
  DELETE ADJACENT DUPLICATES FROM it_shift.
  PERFORM create_f4_field USING c_shift c_vorg c_shift_dyn s_shift-high it_shift.
