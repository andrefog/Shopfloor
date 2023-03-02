FUNCTION zabsf_pp_getmaterials.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_WERKS) TYPE  WERKS_D
*"     VALUE(IV_MATNR) TYPE  MATNR OPTIONAL
*"     REFERENCE(IS_INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(ET_MATERIALS) TYPE  ZABSF_PP_T_MATERIALS
*"     VALUE(ET_RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  DATA: lv_matnr             TYPE matnr.
  DATA: rg_matnr TYPE RANGE OF matnr.

  lv_matnr = iv_matnr.

  IF lv_matnr IS NOT INITIAL.
    APPEND INITIAL LINE TO rg_matnr ASSIGNING FIELD-SYMBOL(<fs_matnr>).
    <fs_matnr>-sign = 'I'.
    <fs_matnr>-option = 'EQ'.
    <fs_matnr>-low = lv_matnr.
  ENDIF.

  SELECT mchb~matnr, mchb~werks, makt~maktx
    FROM mchb AS mchb
    INNER JOIN makt AS makt
    ON mchb~matnr EQ makt~matnr
    INTO CORRESPONDING FIELDS OF TABLE @et_materials
      WHERE mchb~werks EQ @iv_werks
      AND mchb~matnr IN @rg_matnr
      AND makt~spras = @sy-langu.

  SORT et_materials BY werks matnr maktx.
  DELETE ADJACENT DUPLICATES FROM et_materials COMPARING werks matnr maktx.

ENDFUNCTION.
