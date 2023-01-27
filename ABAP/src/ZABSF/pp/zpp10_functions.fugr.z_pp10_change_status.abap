FUNCTION Z_PP10_CHANGE_STATUS.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(IV_RUECK) TYPE  CO_RUECK
*"     REFERENCE(IV_RMZHL) TYPE  CO_RMZHL
*"     REFERENCE(IV_OPRID) TYPE  ZABSF_PP_E_OPRID
*"  EXPORTING
*"     REFERENCE(EV_FLAG) TYPE  FLAG
*"----------------------------------------------------------------------

*Variables
  DATA: l_batch_vulc  TYPE charg_d,
        l_wait_cancel TYPE i.

*Constants
  DATA: c_bwart_261    TYPE bwart          VALUE '261',
        c_art          TYPE qpart          VALUE '04',
        c_status_e0002 TYPE j_status       VALUE 'E0002',
        c_status_e0004 TYPE j_status       VALUE 'E0004',
        c_wait_cancel  TYPE zabsf_pp_e_parid VALUE 'WAIT_CANCEL'.

*Após cada confirmação da ordem de produção do tipo ZINS, é necessário validar
*o lote de consumo, via tabela AFWI. Na tabela ZLP_PP_SF065 (nº confirmação = CONF_NO
*e contador da confirmação efetuada =CONF_CNT) selecionar o/os operadores
*(OPRID) envolvidos na operação da ordem de produção de inspeção.

*  SELECT conf_no, conf_cnt, oprid, charg
*    FROM zlp_pp_sf065
*    INTO TABLE @DATA(lt_zlp_pp_sf065)
*   WHERE conf_no  EQ @iv_rueck
*     AND conf_cnt EQ @iv_rmzhl.
*
*  CHECK sy-subrc = 0.

*Obtenção do lote consumo – Obter os documentos para o nº de confirmação, tabela AFWI (campo RUECK)
*que se referem a consumos (tipos de movimentos 261 (na tabela AUFM – BWART= 261)
*bem como o lote (campo AUFM- CHARG) associado a cada movimento.

  SELECT afwi~rueck, afwi~rmzhl, afwi~mblnr, afwi~mjahr, afwi~mblpo,
         aufm~charg, aufm~matnr, aufm~werks
    INTO TABLE @DATA(lt_afwi)
    FROM afwi AS afwi
    INNER JOIN aufm AS aufm
       ON aufm~mblnr EQ afwi~mblnr
      AND aufm~mjahr EQ afwi~mjahr
      AND aufm~zeile EQ afwi~mblpo
      AND aufm~bwart EQ @c_bwart_261   "Tipo de movimento  - Condição especificada: 261!
    WHERE afwi~rueck EQ @iv_rueck
      AND afwi~rmzhl EQ @iv_rmzhl.

  CHECK sy-subrc = 0.

*Se o operador de inspeção é um dos vários operadores que contribuíram para a produção do lote de consumo
*(tabela ZLP_PP_SF065 para o lote de consumo= CHARG), selecionar o lote de controlo (PRUEFLOS) da tabela QALS,
*tipo de controlo (campo ART) =04 associado ao lote de consumo (QALS-CHARG)

  LOOP AT lt_afwi INTO DATA(ls_afwi).
*  Get prodcution batch - Vulca
    CALL FUNCTION 'Z_PP10_GET_BATCH_CHARACTERISTC'
      EXPORTING
        i_werks      = ls_afwi-werks
        i_batch      = ls_afwi-charg
        i_matnr      = ls_afwi-matnr
      IMPORTING
        e_batch_vulc = l_batch_vulc.

*  Get all operator in production of batch
    SELECT DISTINCT oprid
      FROM zabsf_pp065
      INTO TABLE @DATA(lt_pp_sf065)
     WHERE charg EQ @l_batch_vulc.

    TRY.
        DATA(ls_zlp_pp_sf065) = lt_pp_sf065[ oprid = iv_oprid ].
      CATCH cx_sy_itab_line_not_found.
    ENDTRY.

    CHECK ls_zlp_pp_sf065 IS NOT INITIAL.

*  Get control batch
    SELECT prueflos, art, objnr, obtyp, charg
      FROM qals
      INTO TABLE @DATA(lt_qals)
     WHERE charg EQ @ls_afwi-charg
       AND art   EQ @c_art.

    CHECK sy-subrc = 0.

*  Check status
    SELECT *
      FROM jest
      INTO TABLE @DATA(lt_jest)
       FOR ALL ENTRIES IN @lt_qals
     WHERE objnr EQ @lt_qals-objnr
       AND inact EQ @abap_false.

*se o status de lote já estiver com E0004 então não é efetuada nenhuma alteração.
    TRY.
        DATA(ls_jest_e0004) = lt_jest[ stat = c_status_e0004 ].
      CATCH cx_sy_itab_line_not_found.
    ENDTRY.

    CHECK ls_jest_e0004 IS INITIAL.

*Se o status de utilizador (ZINSLOT) DO lote de controlo (QALS-PRUEFLOS) FOR E0002
*(Responsabilidade DO operador), então deverá passar para O status
*E0004 (Responsab.operador/Inspecionad).
*Validação : se O status de lote já estiver com E0004 então não é efetuada nenhuma alteração.

    TRY.
        DATA(ls_jest_e0002) = lt_jest[ stat = c_status_e0002 ].
      CATCH cx_sy_itab_line_not_found.
    ENDTRY.

    CHECK ls_jest_e0002 IS NOT INITIAL.

*  Change status
    CALL FUNCTION 'STATUS_CHANGE_EXTERN'
      EXPORTING
        objnr               = ls_jest_e0002-objnr
        user_status         = c_status_e0004
        set_chgkz           = abap_true
      EXCEPTIONS
        object_not_found    = 1
        status_inconsistent = 2
        status_not_allowed  = 3
        OTHERS              = 4.

    IF sy-subrc  = 0.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.

      ev_flag = abap_false.
    ELSE.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      ev_flag = abap_true.
    ENDIF.
  ENDLOOP.



ENDFUNCTION.
