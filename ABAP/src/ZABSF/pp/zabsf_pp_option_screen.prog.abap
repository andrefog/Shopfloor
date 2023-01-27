*&---------------------------------------------------------------------*
*&  Include           Z_LP_PP_SF_OPTION_SCREEN
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Selection Screen
*&---------------------------------------------------------------------*
SELECTION-SCREEN: BEGIN OF BLOCK a1 WITH FRAME TITLE text-000.
PARAMETERS: pa_area  TYPE ZABSF_PP_e_areaid,
            pa_werks TYPE werks_d DEFAULT '0070'.

SELECT-OPTIONS: so_matnr FOR mara-matnr NO INTERVALS,  "Material
                so_arbpl FOR crhd-arbpl NO INTERVALS,  "Warehouse
                so_date  FOR mara-ersda DEFAULT sy-datum TO sy-datum.
SELECTION-SCREEN: END OF BLOCK a1.

SELECTION-SCREEN: BEGIN OF BLOCK a2 WITH FRAME TITLE text-001.
PARAMETERS: pa_cron RADIOBUTTON GROUP r1 USER-COMMAND radio DEFAULT 'X',
            pa_med  RADIOBUTTON GROUP r1,
            pa_alrt RADIOBUTTON GROUP r1.
SELECTION-SCREEN: END OF BLOCK a2.


*&---------------------------------------------------------------------*
*&  F4 for select options
*&---------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_area.
*Get area id and area description
  SELECT *
    FROM ZABSF_PP000_t
    INTO CORRESPONDING FIELDS OF TABLE it_area
    WHERE spras EQ sy-langu.

*Sort table
  SORT it_area BY areaid.

*Delete duplicates
  DELETE ADJACENT DUPLICATES FROM it_area.

  PERFORM create_f4_field USING c_area c_vorg c_area_dyn pa_area it_area.
