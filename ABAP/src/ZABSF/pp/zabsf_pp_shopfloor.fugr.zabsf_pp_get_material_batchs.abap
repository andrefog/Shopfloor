FUNCTION zabsf_pp_get_material_batchs .
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(IV_MATNR) TYPE  MATNR
*"     REFERENCE(IV_WERKS) TYPE  WERKS_D
*"     REFERENCE(IV_REFDT) TYPE  VVDATUM
*"     REFERENCE(IS_INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(ET_MATERIALBATCHS) TYPE  ZABSF_PP_T_MATERIALBATCH
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  DATA lv_matnr TYPE matnr.
  CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
    EXPORTING
      input  = iv_matnr
    IMPORTING
      output = lv_matnr.

  SELECT matnr, werks, charg
    FROM mchb
    INTO TABLE @DATA(lt_materialsbatch)
    WHERE matnr EQ @lv_matnr
      AND werks EQ @iv_werks.

  SORT lt_materialsbatch BY matnr charg werks.
  DELETE ADJACENT DUPLICATES FROM lt_materialsbatch COMPARING matnr werks charg.

  IF lt_materialsbatch[] IS INITIAL.
    SELECT COUNT( * ) UP TO 1 ROWS
      FROM marc
      WHERE matnr EQ @lv_matnr
        AND werks EQ @iv_werks
        AND xchpf EQ @abap_true.

    IF sy-subrc IS INITIAL.
      lt_materialsbatch = VALUE #( ( matnr = lv_matnr werks = iv_werks ) ).
    ENDIF.
  ENDIF.

  LOOP AT lt_materialsbatch ASSIGNING FIELD-SYMBOL(<fs_materialbatchs>).
    CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
      EXPORTING
        input  = <fs_materialbatchs>-matnr
      IMPORTING
        output = <fs_materialbatchs>-matnr.
  ENDLOOP.

  et_materialbatchs = VALUE #( FOR ls_materialsbatch IN lt_materialsbatch ( material = ls_materialsbatch-matnr
                                                                            plant    = ls_materialsbatch-werks
                                                                            batch    = ls_materialsbatch-charg ) ).

ENDFUNCTION.
