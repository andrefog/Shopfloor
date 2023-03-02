FUNCTION zabsf_pp_get_stock_deposit.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(IV_MATNR) TYPE  MATNR OPTIONAL
*"     REFERENCE(IV_WERKS) TYPE  WERKS_D
*"     REFERENCE(IV_LGORT) TYPE  LGORT_D
*"     REFERENCE(IV_LGPBE) TYPE  LGPBE OPTIONAL
*"     REFERENCE(IS_INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"  EXPORTING
*"     VALUE(ET_STOCKDEPOSIT) TYPE  ZABSF_PP_T_STOCK_DEPOSIT
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  DATA: lv_matnr             TYPE matnr,
        lv_lgort             TYPE lgort_d,
        lv_lgpbe             TYPE lgpbe,
        es_stockdeposit      TYPE zabsf_pp_s_stock_deposit,
        ls_stockdeposits_new TYPE zabsf_pp_s_stock_deposit,
        lt_deposit_positions TYPE zabsf_cl_odata=>tt_deposit_positions,
        ls_deposit_positions TYPE zabsf_cl_odata=>ty_deposit_positions.

  DATA: rg_matnr TYPE RANGE OF matnr,
        rg_lgort TYPE RANGE OF lgort_d,
        rg_lgpbe TYPE RANGE OF lgpbe.

  CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
    EXPORTING
      input  = iv_matnr
    IMPORTING
      output = lv_matnr.

  IF lv_matnr IS NOT INITIAL.
    APPEND INITIAL LINE TO rg_matnr ASSIGNING FIELD-SYMBOL(<fs_matnr>).
    <fs_matnr>-sign = 'I'.
    <fs_matnr>-option = 'EQ'.
    <fs_matnr>-low = lv_matnr.
  ENDIF.

  lv_lgort = iv_lgort.
  IF lv_lgort IS NOT INITIAL.
    APPEND INITIAL LINE TO rg_lgort ASSIGNING FIELD-SYMBOL(<fs_lgort>).
    <fs_lgort>-sign = 'I'.
    <fs_lgort>-option = 'EQ'.
    <fs_lgort>-low = lv_lgort.
    " area id = 'OPT'
  ELSEIF lv_lgort IS INITIAL AND is_inputobj-areaid EQ 'OPT'.
    APPEND INITIAL LINE TO rg_lgort ASSIGNING <fs_lgort>.
    <fs_lgort>-sign = 'I'.
    <fs_lgort>-option = 'EQ'.
    <fs_lgort>-low = '0019'.
    APPEND INITIAL LINE TO rg_lgort ASSIGNING <fs_lgort>.
    <fs_lgort>-sign = 'I'.
    <fs_lgort>-option = 'EQ'.
    <fs_lgort>-low = '0062'.
    APPEND INITIAL LINE TO rg_lgort ASSIGNING <fs_lgort>.
    <fs_lgort>-sign = 'I'.
    <fs_lgort>-option = 'EQ'.
    <fs_lgort>-low = '0080'.
    APPEND INITIAL LINE TO rg_lgort ASSIGNING <fs_lgort>.
    <fs_lgort>-sign = 'I'.
    <fs_lgort>-option = 'EQ'.
    <fs_lgort>-low = '0030'.
    APPEND INITIAL LINE TO rg_lgort ASSIGNING <fs_lgort>.
    <fs_lgort>-sign = 'I'.
    <fs_lgort>-option = 'EQ'.
    <fs_lgort>-low = '0180'.
    " area id = 'MEC'
  ELSEIF lv_lgort IS INITIAL AND is_inputobj-areaid EQ 'MEC'.
    APPEND INITIAL LINE TO rg_lgort ASSIGNING <fs_lgort>.
    <fs_lgort>-sign = 'I'.
    <fs_lgort>-option = 'EQ'.
    <fs_lgort>-low = '0017'.
    APPEND INITIAL LINE TO rg_lgort ASSIGNING <fs_lgort>.
    <fs_lgort>-sign = 'I'.
    <fs_lgort>-option = 'EQ'.
    <fs_lgort>-low = '0018'.
  ELSEIF lv_lgort IS INITIAL AND is_inputobj-areaid EQ 'MONT'.
    APPEND INITIAL LINE TO rg_lgort ASSIGNING <fs_lgort>.
    <fs_lgort>-sign = 'I'.
    <fs_lgort>-option = 'EQ'.
    <fs_lgort>-low = '0070'.
    APPEND INITIAL LINE TO rg_lgort ASSIGNING <fs_lgort>.
    <fs_lgort>-sign = 'I'.
    <fs_lgort>-option = 'EQ'.
    <fs_lgort>-low = '0079'.
    APPEND INITIAL LINE TO rg_lgort ASSIGNING <fs_lgort>.
    <fs_lgort>-sign = 'I'.
    <fs_lgort>-option = 'EQ'.
    <fs_lgort>-low = '0067'.
  ENDIF.

  lv_lgpbe = iv_lgpbe.

  IF lv_lgpbe IS NOT INITIAL.
    APPEND INITIAL LINE TO rg_lgpbe ASSIGNING FIELD-SYMBOL(<fs_lgpbe>).
    <fs_lgpbe>-sign = 'I'.
    <fs_lgpbe>-option = 'EQ'.
    <fs_lgpbe>-low = lv_lgpbe.
  ELSE.
    SELECT DISTINCT lgpbe, werks, lgort
        FROM mard
        INTO TABLE @DATA(lt_mard)
        WHERE werks EQ @iv_werks
          AND lgort IN @rg_lgort.

    LOOP AT lt_mard ASSIGNING FIELD-SYMBOL(<fs_mard>).
      CLEAR: ls_deposit_positions.
      ls_deposit_positions = VALUE zabsf_cl_odata=>ty_deposit_positions( plant = <fs_mard>-werks
                                                         lgort = <fs_mard>-lgort
                                                         lgpbe = <fs_mard>-lgpbe ).

      APPEND ls_deposit_positions TO lt_deposit_positions.
    ENDLOOP.

    SORT lt_deposit_positions BY lgpbe ASCENDING.

    LOOP AT lt_deposit_positions ASSIGNING FIELD-SYMBOL(<fs_deposit_position>).
      APPEND INITIAL LINE TO rg_lgpbe ASSIGNING <fs_lgpbe>.
      <fs_lgpbe>-sign = 'I'.
      <fs_lgpbe>-option = 'EQ'.
      <fs_lgpbe>-low = <fs_deposit_position>-lgpbe.
    ENDLOOP.
  ENDIF.

  SELECT a~matnr, a~werks, a~lgort, a~charg, a~clabs, a~cspem, b~meins, c~maktx, d~dispo, e~grpdesc
    FROM mchb AS a
    INNER JOIN mara AS b ON b~matnr = a~matnr
    LEFT JOIN makt AS c ON c~matnr = a~matnr
                       AND c~spras = @sy-langu
    INNER JOIN marc AS d ON d~matnr = a~matnr
                        AND d~werks = a~werks
    LEFT JOIN zlp_pp_sf054 AS e ON e~dispo = d~dispo
                               AND e~spras = @sy-langu
    WHERE a~matnr IN @rg_matnr
*    AND a~lgort EQ @iv_lgort
    AND a~lgort IN @rg_lgort
    AND a~werks EQ @iv_werks
    AND a~clabs GT '0'
    INTO CORRESPONDING FIELDS OF TABLE @et_stockdeposit.

  SORT et_stockdeposit BY matnr werks lgort.

  SELECT a~matnr, a~werks, a~lgort, a~labst AS clabs, a~speme AS cspem, a~lgpbe, b~meins, c~maktx, d~dispo, e~grpdesc
    FROM mard AS a
    INNER JOIN mara AS b ON b~matnr = a~matnr
    LEFT JOIN makt AS c ON  c~matnr = a~matnr
                        AND c~spras = @sy-langu
    INNER JOIN marc AS d ON  d~matnr = a~matnr
                        AND d~werks = a~werks
    LEFT JOIN zlp_pp_sf054 AS e ON e~dispo = d~dispo
                               AND e~spras = @sy-langu
    WHERE a~matnr IN @rg_matnr
    AND a~lgort IN @rg_lgort
    AND a~lvorm EQ @space
    AND a~werks EQ @iv_werks
    AND a~lgpbe IN @rg_lgpbe
    AND a~labst GT '0'
    INTO TABLE @DATA(lt_stockdeposits).

  SORT lt_stockdeposits BY matnr werks lgort.

  IF et_stockdeposit[] IS NOT INITIAL.
    LOOP AT et_stockdeposit ASSIGNING FIELD-SYMBOL(<fs_et_stockdeposit>).

      READ TABLE lt_stockdeposits ASSIGNING FIELD-SYMBOL(<fs_stockdeposits>) WITH KEY matnr = <fs_et_stockdeposit>-matnr
                                                                                      werks = <fs_et_stockdeposit>-werks
                                                                                      lgort = <fs_et_stockdeposit>-lgort BINARY SEARCH.

      IF sy-subrc <> 0.
        DELETE et_stockdeposit WHERE matnr = <fs_et_stockdeposit>-matnr AND werks = <fs_et_stockdeposit>-werks AND lgort = <fs_et_stockdeposit>-lgort.
      ELSE.

        CALL FUNCTION 'CONVERSION_EXIT_CUNIT_OUTPUT'
          EXPORTING
            input          = <fs_et_stockdeposit>-meins
            language       = 'P'
          IMPORTING
*           LONG_TEXT      = LONG_TEXT
            output         = <fs_et_stockdeposit>-meins
*           SHORT_TEXT     = SHORT_TEXT
          EXCEPTIONS
            unit_not_found = 1
            OTHERS         = 2.
        IF sy-subrc <> 0.
* Implement suitable error handling here
        ENDIF.

        IF is_inputobj-areaid EQ 'OPT'.
          CASE <fs_et_stockdeposit>-lgort.
            WHEN '0019'.
              <fs_et_stockdeposit>-clabslgort0019 = <fs_et_stockdeposit>-clabs.
            WHEN '0062'.
              <fs_et_stockdeposit>-clabslgort0062 = <fs_et_stockdeposit>-clabs.
            WHEN '0080'.
              <fs_et_stockdeposit>-clabslgort0080 = <fs_et_stockdeposit>-clabs.
            WHEN '0030'.
              <fs_et_stockdeposit>-clabslgort0030 = <fs_et_stockdeposit>-clabs.
            WHEN '0180'.
              <fs_et_stockdeposit>-clabslgort0030 = <fs_et_stockdeposit>-clabs.
          ENDCASE.

        ELSEIF is_inputobj-areaid EQ 'MEC'.
          CASE <fs_et_stockdeposit>-lgort.
            WHEN '0017'.
              <fs_et_stockdeposit>-clabslgort0019 = <fs_et_stockdeposit>-clabs.
            WHEN '0018'.
              <fs_et_stockdeposit>-clabslgort0062 = <fs_et_stockdeposit>-clabs.
          ENDCASE.

        ELSEIF is_inputobj-areaid EQ 'MONT'.
          CASE <fs_et_stockdeposit>-lgort.
            WHEN '0070'.
              <fs_et_stockdeposit>-clabslgort0019 = <fs_et_stockdeposit>-clabs.
            WHEN '0079'.
              <fs_et_stockdeposit>-clabslgort0062 = <fs_et_stockdeposit>-clabs.
            WHEN '0067'.
              <fs_et_stockdeposit>-clabslgort0062 = <fs_et_stockdeposit>-clabs.
          ENDCASE.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDIF.

  LOOP AT lt_stockdeposits INTO DATA(ls_stockdeposits).
    CLEAR ls_stockdeposits_new.

    SORT et_stockdeposit BY matnr werks lgort.

*    IF is_inputobj-areaid EQ 'MONT' OR is_inputobj-areaid EQ 'OPT'.
    CALL FUNCTION 'CONVERSION_EXIT_CUNIT_OUTPUT'
      EXPORTING
        input          = ls_stockdeposits-meins
        language       = 'P'
      IMPORTING
*       LONG_TEXT      = LONG_TEXT
        output         = ls_stockdeposits-meins
*       SHORT_TEXT     = SHORT_TEXT
      EXCEPTIONS
        unit_not_found = 1
        OTHERS         = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.
*    ENDIF.

    READ TABLE et_stockdeposit ASSIGNING <fs_et_stockdeposit> WITH KEY matnr = ls_stockdeposits-matnr
                                                                       werks = ls_stockdeposits-werks
                                                                       lgort = ls_stockdeposits-lgort BINARY SEARCH.

*    IF sy-subrc <> 0 AND is_inputobj-areaid <> 'OPT'.
*      APPEND INITIAL LINE TO et_stockdeposit ASSIGNING FIELD-SYMBOL(<fs_stockdeposit>).
*
*      <fs_stockdeposit> = CORRESPONDING #( ls_stockdeposits ).
    IF  sy-subrc <> 0 AND is_inputobj-areaid EQ 'OPT'.
      ls_stockdeposits_new = VALUE zabsf_pp_s_stock_deposit( matnr = ls_stockdeposits-matnr
                                                             werks = ls_stockdeposits-werks
                                                             lgort = ls_stockdeposits-lgort
                                                             maktx = ls_stockdeposits-maktx
                                                             meins = ls_stockdeposits-meins
                                                             cspem = ls_stockdeposits-cspem
                                                             dispo = ls_stockdeposits-dispo
                                                             grpdesc = ls_stockdeposits-grpdesc ).

      CASE ls_stockdeposits-lgort.
        WHEN '0019'.
          ls_stockdeposits_new-clabslgort0019 = ls_stockdeposits-clabs.
        WHEN '0062'.
          ls_stockdeposits_new-clabslgort0062 = ls_stockdeposits-clabs.
        WHEN '0080'.
          ls_stockdeposits_new-clabslgort0080 = ls_stockdeposits-clabs.
        WHEN '0030'.
          ls_stockdeposits_new-clabslgort0030 = ls_stockdeposits-clabs.
        WHEN '0180'.
          ls_stockdeposits_new-clabslgort0180 = ls_stockdeposits-clabs.
      ENDCASE.

      APPEND ls_stockdeposits_new TO et_stockdeposit.
    ELSEIF sy-subrc EQ 0 AND is_inputobj-areaid EQ 'OPT'.
      CASE ls_stockdeposits-lgort.
        WHEN '0019'.
          <fs_et_stockdeposit>-clabslgort0019 = ls_stockdeposits-clabs.
        WHEN '0062'.
          <fs_et_stockdeposit>-clabslgort0062 = ls_stockdeposits-clabs.
        WHEN '0080'.
          <fs_et_stockdeposit>-clabslgort0080 = ls_stockdeposits-clabs.
        WHEN '0030'.
          <fs_et_stockdeposit>-clabslgort0030 = ls_stockdeposits-clabs.
        WHEN '0180'.
          <fs_et_stockdeposit>-clabslgort0180 = ls_stockdeposits-clabs.
      ENDCASE.

    ELSEIF sy-subrc <> 0 AND is_inputobj-areaid EQ 'MEC'.
      ls_stockdeposits_new = VALUE zabsf_pp_s_stock_deposit( matnr = ls_stockdeposits-matnr
                                                             werks = ls_stockdeposits-werks
                                                             lgort = ls_stockdeposits-lgort
                                                             maktx = ls_stockdeposits-maktx
                                                             meins = ls_stockdeposits-meins
                                                             cspem = COND #( WHEN ls_stockdeposits-lgort EQ '0017'
                                                                       THEN ls_stockdeposits-cspem
                                                                       ELSE '' )
                                                             dispo = ls_stockdeposits-dispo
                                                             grpdesc = ls_stockdeposits-grpdesc ).

      CASE ls_stockdeposits-lgort.
        WHEN '0017'.
          ls_stockdeposits_new-clabslgort0017 = ls_stockdeposits-clabs.
        WHEN '0018'.
          ls_stockdeposits_new-clabslgort0018 = ls_stockdeposits-clabs.
      ENDCASE.

      APPEND ls_stockdeposits_new TO et_stockdeposit.
    ELSEIF sy-subrc EQ 0 AND is_inputobj-areaid EQ 'MEC'.
      CASE ls_stockdeposits-lgort.
        WHEN '0017'.
          <fs_et_stockdeposit>-clabslgort0017 = ls_stockdeposits-clabs.
          <fs_et_stockdeposit>-cspem = ls_stockdeposits-cspem.
        WHEN '0018'.
          <fs_et_stockdeposit>-clabslgort0018 = ls_stockdeposits-clabs.
      ENDCASE.

    ELSEIF sy-subrc <> 0 AND is_inputobj-areaid EQ 'MONT'.
      ls_stockdeposits_new = VALUE zabsf_pp_s_stock_deposit( matnr = ls_stockdeposits-matnr
                                                             werks = ls_stockdeposits-werks
                                                             lgort = ls_stockdeposits-lgort
                                                             maktx = ls_stockdeposits-maktx
                                                             meins = ls_stockdeposits-meins
                                                             cspem = COND #( WHEN ls_stockdeposits-lgort EQ '0070'
                                                                       THEN ls_stockdeposits-cspem
                                                                       ELSE '' )
                                                             dispo = ls_stockdeposits-dispo
                                                             grpdesc = ls_stockdeposits-grpdesc ).

      CASE ls_stockdeposits-lgort.
        WHEN '0070'.
          ls_stockdeposits_new-clabslgort0070 = ls_stockdeposits-clabs.
        WHEN '0079'.
          ls_stockdeposits_new-clabslgort0079 = ls_stockdeposits-clabs.
        WHEN '0067'.
          ls_stockdeposits_new-clabslgort0067 = ls_stockdeposits-clabs.
      ENDCASE.

      APPEND ls_stockdeposits_new TO et_stockdeposit.
    ELSEIF sy-subrc EQ 0 AND is_inputobj-areaid EQ 'MONT'.
      CASE ls_stockdeposits-lgort.
        WHEN '0070'.
          <fs_et_stockdeposit>-clabslgort0070 = ls_stockdeposits-clabs.
          <fs_et_stockdeposit>-cspem = ls_stockdeposits-cspem.
        WHEN '0079'.
          <fs_et_stockdeposit>-clabslgort0079 = ls_stockdeposits-clabs.
        WHEN '0067'.
          <fs_et_stockdeposit>-clabslgort0067 = ls_stockdeposits-clabs.
      ENDCASE.
    ENDIF.
  ENDLOOP.

  SORT et_stockdeposit BY matnr werks lgort.

* low and max quantities
  SELECT matnr, werks, areaid, wareid, low_limit, max_limit
    FROM zabsf_pp041
    INTO TABLE @DATA(lt_pp041)
    WHERE matnr IN @rg_matnr
      AND werks EQ @iv_werks
      AND wareid  IN @rg_lgort.

  SORT lt_pp041 BY matnr werks wareid.

  IF sy-subrc EQ 0.
    LOOP AT et_stockdeposit ASSIGNING FIELD-SYMBOL(<fs_stockdeposit>).

*      IF is_inputobj-areaid <> 'OPT'.
*        READ TABLE lt_pp041 INTO DATA(ls_pp041) WITH KEY matnr = <fs_stockdeposit>-matnr werks = <fs_stockdeposit>-werks  wareid = <fs_stockdeposit>-lgort BINARY SEARCH.
*
*        IF sy-subrc EQ 0.
*          <fs_stockdeposit>-areaid = ls_pp041-areaid.
*          <fs_stockdeposit>-low_limit = ls_pp041-low_limit.
*          <fs_stockdeposit>-max_limit = ls_pp041-max_limit.
*
*          " validate minimum quantity of stock
*          IF <fs_stockdeposit>-clabs LT <fs_stockdeposit>-low_limit.
*            <fs_stockdeposit>-lower_stock = 'Y'.
*          ELSE.
*            <fs_stockdeposit>-lower_stock = 'N'.
*          ENDIF.
*        ENDIF.

      IF is_inputobj-areaid EQ 'MEC'.
        LOOP AT lt_pp041 INTO DATA(ls_pp041) WHERE matnr = <fs_stockdeposit>-matnr AND
                                                   werks = <fs_stockdeposit>-werks AND
                                                 ( wareid = '0017' OR  wareid = '0018' ).
          CASE ls_pp041-wareid.
            WHEN '0017'.
              <fs_stockdeposit>-areaid = ls_pp041-areaid.
              <fs_stockdeposit>-low_limit_lgort0017 = ls_pp041-low_limit.
              <fs_stockdeposit>-max_limit_lgort0017 = ls_pp041-max_limit.

              " validate minimum quantity of stock
              IF <fs_stockdeposit>-clabslgort0017 LT <fs_stockdeposit>-low_limit_lgort0017.
                <fs_stockdeposit>-lower_stock_lgort0017 = 'Y'.
              ELSE.
                <fs_stockdeposit>-lower_stock_lgort0017 = 'N'.
              ENDIF.
            WHEN '0018'.
              <fs_stockdeposit>-areaid = ls_pp041-areaid.
              <fs_stockdeposit>-low_limit_lgort0018 = ls_pp041-low_limit.
              <fs_stockdeposit>-max_limit_lgort0018 = ls_pp041-max_limit.

              " validate minimum quantity of stock
              IF <fs_stockdeposit>-clabslgort0018 LT <fs_stockdeposit>-low_limit_lgort0018.
                <fs_stockdeposit>-lower_stock_lgort0018 = 'Y'.
              ELSE.
                <fs_stockdeposit>-lower_stock_lgort0018 = 'N'.
              ENDIF.
          ENDCASE.
        ENDLOOP.
      ELSEIF is_inputobj-areaid EQ 'MONT'.
        LOOP AT lt_pp041 INTO ls_pp041 WHERE matnr = <fs_stockdeposit>-matnr AND
                                                 werks = <fs_stockdeposit>-werks AND
                                               ( wareid = '0070' OR  wareid = '0079' OR wareid = '0067' ).
          CASE ls_pp041-wareid.
            WHEN '0070'.
              <fs_stockdeposit>-areaid = ls_pp041-areaid.
              <fs_stockdeposit>-low_limit_lgort0070 = ls_pp041-low_limit.
              <fs_stockdeposit>-max_limit_lgort0070 = ls_pp041-max_limit.

              " validate minimum quantity of stock
              IF <fs_stockdeposit>-clabslgort0070 LT <fs_stockdeposit>-low_limit_lgort0070.
                <fs_stockdeposit>-lower_stock_lgort0070 = 'Y'.
              ELSE.
                <fs_stockdeposit>-lower_stock_lgort0070 = 'N'.
              ENDIF.
            WHEN '0079'.
              <fs_stockdeposit>-areaid = ls_pp041-areaid.
              <fs_stockdeposit>-low_limit_lgort0079 = ls_pp041-low_limit.
              <fs_stockdeposit>-max_limit_lgort0079 = ls_pp041-max_limit.

              " validate minimum quantity of stock
              IF <fs_stockdeposit>-clabslgort0079 LT <fs_stockdeposit>-low_limit_lgort0079.
                <fs_stockdeposit>-lower_stock_lgort0079 = 'Y'.
              ELSE.
                <fs_stockdeposit>-lower_stock_lgort0079 = 'N'.
              ENDIF.
            WHEN '0067'.
              <fs_stockdeposit>-areaid = ls_pp041-areaid.
              <fs_stockdeposit>-low_limit_lgort0067 = ls_pp041-low_limit.
              <fs_stockdeposit>-max_limit_lgort0067 = ls_pp041-max_limit.

              " validate minimum quantity of stock
              IF <fs_stockdeposit>-clabslgort0067 LT <fs_stockdeposit>-low_limit_lgort0067.
                <fs_stockdeposit>-lower_stock_lgort0067 = 'Y'.
              ELSE.
                <fs_stockdeposit>-lower_stock_lgort0067 = 'N'.
              ENDIF.
          ENDCASE.
        ENDLOOP.
      ELSEIF is_inputobj-areaid EQ 'OPT'.
        LOOP AT lt_pp041 INTO ls_pp041 WHERE matnr = <fs_stockdeposit>-matnr AND
                                             werks = <fs_stockdeposit>-werks AND
                                             ( wareid = '0019' OR  wareid = '0062' OR  wareid = '0080' OR  wareid = '0030' ).
          CASE ls_pp041-wareid.
            WHEN '0019'.
              <fs_stockdeposit>-areaid = ls_pp041-areaid.
              <fs_stockdeposit>-low_limit_lgort0019 = ls_pp041-low_limit.
              <fs_stockdeposit>-max_limit_lgort0019 = ls_pp041-max_limit.

              " validate minimum quantity of stock
              IF <fs_stockdeposit>-clabslgort0019 LT <fs_stockdeposit>-low_limit_lgort0019.
                <fs_stockdeposit>-lower_stock_lgort0019 = 'Y'.
              ELSE.
                <fs_stockdeposit>-lower_stock_lgort0019 = 'N'.
              ENDIF.
            WHEN '0062'.
              <fs_stockdeposit>-areaid = ls_pp041-areaid.
              <fs_stockdeposit>-low_limit_lgort0062 = ls_pp041-low_limit.
              <fs_stockdeposit>-max_limit_lgort0062 = ls_pp041-max_limit.

              " validate minimum quantity of stock
              IF <fs_stockdeposit>-clabslgort0062 LT <fs_stockdeposit>-low_limit_lgort0062.
                <fs_stockdeposit>-lower_stock_lgort0062 = 'Y'.
              ELSE.
                <fs_stockdeposit>-lower_stock_lgort0062 = 'N'.
              ENDIF.
            WHEN '0080'.
              <fs_stockdeposit>-areaid = ls_pp041-areaid.
              <fs_stockdeposit>-low_limit_lgort0080 = ls_pp041-low_limit.
              <fs_stockdeposit>-max_limit_lgort0080 = ls_pp041-max_limit.

              " validate minimum quantity of stock
              IF <fs_stockdeposit>-clabslgort0080 LT <fs_stockdeposit>-low_limit_lgort0080.
                <fs_stockdeposit>-lower_stock_lgort0080 = 'Y'.
              ELSE.
                <fs_stockdeposit>-lower_stock_lgort0080 = 'N'.
              ENDIF.
            WHEN '0030'.
              <fs_stockdeposit>-areaid = ls_pp041-areaid.
              <fs_stockdeposit>-low_limit_lgort0030 = ls_pp041-low_limit.
              <fs_stockdeposit>-max_limit_lgort0030 = ls_pp041-max_limit.

              " validate minimum quantity of stock
              IF <fs_stockdeposit>-clabslgort0030 LT <fs_stockdeposit>-low_limit_lgort0030.
                <fs_stockdeposit>-lower_stock_lgort0030 = 'Y'.
              ELSE.
                <fs_stockdeposit>-lower_stock_lgort0030 = 'N'.
              ENDIF.
          ENDCASE.
        ENDLOOP.
      ENDIF.
      CLEAR ls_pp041.
    ENDLOOP.
  ENDIF.
ENDFUNCTION.
