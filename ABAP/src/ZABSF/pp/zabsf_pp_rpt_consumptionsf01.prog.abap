*&---------------------------------------------------------------------*
*&  Include          Z_LP_PP_SF_CONSUMPTIONS_CHGF01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  INIT_VARIABLES
*&---------------------------------------------------------------------*
FORM init_variables .
  REFRESH gt_alv.
ENDFORM.                    " INIT_VARIABLES


*&---------------------------------------------------------------------*
*&      Form  GET_CONSUMPTIONS
*&---------------------------------------------------------------------*
FORM get_consumptions.

  REFRESH: lt_consumpt.
*Get Consumptions to Correct
  SELECT a~werks, a~data, a~shiftid, a~aufnr, a~ficha,
         a~matnr, b~maktx, a~batch, a~verme, a~status_cons,
         a~ernam, a~erdat
    FROM zabsf_pp076 AS a
    LEFT JOIN makt AS b
          ON a~matnr = b~matnr AND
             b~spras = @sy-langu
    INTO CORRESPONDING FIELDS OF TABLE @lt_consumpt
   WHERE a~werks   EQ @p_werks
     AND a~status_cons IN @s_stat
     AND a~data    IN @s_data
     AND a~shiftid IN @s_shift
     AND a~aufnr   IN @s_aufnr
     AND a~ficha   IN @s_ficha
     AND a~status_cons EQ @c_stat_p.


  IF lt_consumpt[] IS NOT INITIAL.
**  Get material descriptions
*    SELECT matnr maktx
*      FROM makt
*      INTO CORRESPONDING FIELDS OF TABLE lt_makt
*       FOR ALL ENTRIES IN lt_consumpt
*     WHERE matnr EQ lt_consumpt-matnr
*       AND spras EQ sy-langu.
*
*    LOOP AT lt_consumpt INTO lt_consumpt.
*
*      MOVE-CORRESPONDING ls_scrap TO ls_alv.
*
**    Material description
*      READ TABLE lt_makt INTO ls_makt WITH KEY matnr = ls_scrap-matnr.
*      IF sy-subrc EQ 0.
*        ls_alv-maktx = ls_makt-maktx.
*      ENDIF.
*
*      APPEND ls_alv TO gt_alv.
*    ENDLOOP.
  ENDIF.


* Fill ALV
  MOVE-CORRESPONDING lt_consumpt[] TO gt_alv[].

ENDFORM.                    " GET_CONSUMPTIONS



*&---------------------------------------------------------------------*
*&      Form  CREATE_F4_FIELD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_C_WARE  text
*      -->P_C_VORG  text
*      -->P_C_WARE_DYN  text
*      -->P_SO_WARE  text
*      -->P_IT_WARE  text
*----------------------------------------------------------------------*
FORM create_f4_field USING p_retfield p_val_org p_dyn_field
                           so_option p_it
                     TYPE STANDARD TABLE.

  DATA: it_return TYPE TABLE OF ddshretval,
        wa_return TYPE ddshretval.

  REFRESH it_return.
  CLEAR wa_return.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = p_retfield
      value_org       = p_val_org
      dynpprog        = sy-cprog
      dynpnr          = sy-dynnr
      dynprofield     = p_dyn_field
    TABLES
      value_tab       = p_it
      return_tab      = it_return
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.

ENDFORM.                    " CREATE_F4_FIELD
