FUNCTION zabsf_pp_get_material_serial .
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_MATNR) TYPE  MATNR
*"     REFERENCE(IV_WERKS) TYPE  WERKS_D
*"     REFERENCE(IV_AUFNR) TYPE  AUFNR OPTIONAL
*"     REFERENCE(IV_REFDT) TYPE  VVDATUM OPTIONAL
*"     REFERENCE(IS_INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(ET_MATERIALSERIAL) TYPE  ZABSF_PP_T_MATERIALSERIAL
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  DATA lv_matnr TYPE matnr.
  CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
    EXPORTING
      input  = iv_matnr
    IMPORTING
      output = lv_matnr.

  DATA(lt_matserprof) =
    zabsf_pp_cl_prdord=>get_material_serial_profile(
      VALUE #( (
        matnr = lv_matnr
        werks = iv_werks ) ) ).

  DATA(lv_sernp) = VALUE #( lt_matserprof[ 1 ]-sernp OPTIONAL ).

  " If Material have a Serial Profile, get not used serials created for this material
  IF lv_sernp IS NOT INITIAL.
    IF iv_aufnr IS SUPPLIED.
      SELECT lgort UP TO 1 ROWS
        FROM resb
        INTO @DATA(lv_lgort)
        WHERE aufnr EQ @iv_aufnr
          AND matnr EQ @lv_matnr
          AND werks EQ @iv_werks.
      ENDSELECT.

      IF lv_lgort IS NOT INITIAL.
        DATA(lr_lgort) = VALUE range_t_lgort_d( ( sign = 'I' option = 'EQ' low = lv_lgort ) ).
      ENDIF.
    ENDIF.

    SELECT i~matnr, s~b_werk, i~sernr
      FROM equi AS i
      INNER JOIN eqbs AS s
        ON s~equnr EQ i~equnr
      INTO TABLE @DATA(lt_materialserial)
      WHERE i~matnr   EQ @lv_matnr
        AND i~s_eqbs  EQ @abap_true
        AND s~b_werk  EQ @iv_werks
        AND s~b_lager IN @lr_lgort.

    et_materialserial =
      VALUE #( FOR s IN lt_materialserial (
        material = s-matnr
        plant    = s-b_werk
        required = abap_true
        serial   = s-sernr ) ).
  ENDIF.

  " If no serial was passed, send a line with serial is required or not
  CHECK et_materialserial[] IS INITIAL.

  et_materialserial =
    VALUE #( (
      material = lv_matnr
      plant    = iv_werks
      required = COND #( WHEN lv_sernp IS INITIAL THEN abap_false ELSE abap_true )
    ) ).
ENDFUNCTION.
