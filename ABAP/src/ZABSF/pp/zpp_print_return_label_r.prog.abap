*&---------------------------------------------------------------------*
*& Report ZPP_PRINT_RETURN_LABEL_R
*&---------------------------------------------------------------------*
*&Criado por: João Lopes
*&DATA:       30.03.2020
*&Descrição: F_LOG_004 - Impressão da etiqueta de devolução
*&---------------------------------------------------------------------*
REPORT zpp_print_return_label_r.
"includes do programa
INCLUDE rvadtabl.

"variáveis globais
DATA: gt_labels_tab TYPE zpp_return_prod_label_tt.
*----------------------------------------------------------------------*
*       FORM ENTRY
*----------------------------------------------------------------------*
*       procedure for output prcessing
*----------------------------------------------------------------------*
*  -->  RETURN_CODE    : code for processing
*  -->  SCREEN_OUTPUT  : output on screen
*----------------------------------------------------------------------*
FORM entry USING ef_return_code   TYPE i
                 if_screen_output TYPE c ##CALLED.

  "variáveis locais
  DATA: lv_formname     TYPE tdsfname,
        lv_fm_name      TYPE rs38l_fnam,
        ls_ctrparam_str TYPE ssfctrlop,
        ls_soutputs_str TYPE ssfcompop.

  "considerar apenas impressão
  IF tnapr-nacha NE '1'.
    "sair do processamento
    RETURN.
  ENDIF.

  "nome do formulário
  lv_formname = tnapr-sform.
  "opções de output
  ls_soutputs_str-tddest = nast-ldest.
  "novo request de spool
  ls_soutputs_str-tdnewid = 'X'.
  "impressão imediata
  ls_soutputs_str-tdimmed = nast-dimme.
  "eliminar após saida
  ls_soutputs_str-tddelete = nast-delet.

  "nº de cópias
  IF nast-anzal EQ 0.
    ls_soutputs_str-tdcopies = '1'.
  ELSE.
    ls_soutputs_str-tdcopies = nast-anzal.
  ENDIF.

  "parametros de impressão
  ls_ctrparam_str-no_open = 'X'.
  ls_ctrparam_str-no_close = 'X'.
  ls_ctrparam_str-langu = nast-spras.
  ls_ctrparam_str-replangu1 = nast-spras.
  "ls_ctrparam_str-preview = abap_false.

  "obter nome do formulário
  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = lv_formname
    IMPORTING
      fm_name            = lv_fm_name
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.
  IF sy-subrc <> 0.
    "devolver id do erro
    ef_return_code = sy-subrc.
    "actualizar mensagem na NACE
    PERFORM protocol_update USING if_screen_output.
    "sair do processamento
    RETURN.
  ENDIF.

  "obter lotes
  PERFORM get_batches.

  "abrir formulário
  CALL FUNCTION 'SSF_OPEN'
    EXPORTING
      user_settings      = abap_false
      output_options     = ls_soutputs_str
      control_parameters = ls_ctrparam_str
    EXCEPTIONS
      formatting_error   = 1
      internal_error     = 2
      send_error         = 3
      user_canceled      = 4
      OTHERS             = 5.
  IF sy-subrc <> 0.
    "devolver id do erro
    ef_return_code = sy-subrc.
    "actualizar mensagem na NACE
    PERFORM protocol_update USING if_screen_output.
    "sair do processamento
    RETURN.
  ENDIF.

  LOOP AT gt_labels_tab INTO DATA(ls_labels).
    "invocar formulário
    CALL FUNCTION lv_fm_name
      EXPORTING
        control_parameters       = ls_ctrparam_str
        output_options           = ls_soutputs_str
        user_settings            = abap_false
        is_return_prod_label_str = ls_labels
      EXCEPTIONS
        formatting_error         = 1
        internal_error           = 2
        send_error               = 3
        user_canceled            = 4
        OTHERS                   = 5.
    IF sy-subrc NE 0.
      ef_return_code = sy-subrc.
      "actualizar mensagem na NACE
      PERFORM protocol_update USING if_screen_output.
      "sair do processamento
      RETURN.
    ENDIF.
    ls_soutputs_str-tdnewid   = abap_false.
  ENDLOOP.

  "encerrar formulário
  CALL FUNCTION 'SSF_CLOSE'
    EXCEPTIONS
      formatting_error = 1
      internal_error   = 2
      send_error       = 3
      OTHERS           = 4.
  IF sy-subrc NE 0.
    ef_return_code = sy-subrc.
    "actualizar mensagem na NACE
    PERFORM protocol_update USING if_screen_output.
    "sair do processamento
    RETURN.
  ENDIF.
  ef_return_code = sy-subrc.
ENDFORM.

*---------------------------------------------------------------------*
*       FORM PROTOCOL_UPDATE                                          *
*---------------------------------------------------------------------*
*       save processing messages                                      *
*---------------------------------------------------------------------*
FORM protocol_update USING if_screen_output TYPE c.
  "actualização de mensagem na NACE
  CHECK if_screen_output EQ space.
  CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
    EXPORTING
      msg_arbgb = syst-msgid
      msg_nr    = syst-msgno
      msg_ty    = syst-msgty
      msg_v1    = syst-msgv1
      msg_v2    = syst-msgv2
      msg_v3    = syst-msgv3
      msg_v4    = syst-msgv4
    EXCEPTIONS
      OTHERS    = 1.
  IF sy-subrc <> 0. ENDIF.
ENDFORM.
"obter lotes
FORM get_batches.
  "varávies locais
  DATA: lv_document_var TYPE mblnr,
        lv_docmyear_var TYPE mjahr,
        lr_charname_rng TYPE RANGE OF atnam,
        lv_charcomp_var TYPE atnam,
        lv_charlarg_var TYPE atnam,
        lv_matdescr_var TYPE maktx,
        lv_pepelout_var TYPE char24.

  "documento
  lv_document_var = nast-objky(10).
  "ano
  lv_docmyear_var = nast-objky+10(4).
  "obter os movimentos
  SELECT *
    FROM mseg
    INTO TABLE @DATA(lt_docmitems_tab)
     WHERE mblnr EQ @lv_document_var
       AND mjahr EQ @lv_docmyear_var
       AND bwart EQ '262'.
  IF sy-subrc NE 0.
    "sair do processamento
    RETURN.
  ENDIF.
  "obter descrição dos materiais
  SELECT *
    FROM makt
    INTO TABLE @DATA(lt_matrdesc_tab)
    FOR ALL ENTRIES IN @lt_docmitems_tab
      WHERE matnr EQ @lt_docmitems_tab-matnr
        AND spras EQ @sy-langu.
  "obter caracteristicas relevantes
  TRY.
      "nome
      zcl_bc_fixed_values=>get_ranges_value( EXPORTING
                                               im_paramter_var = zcl_bc_fixed_values=>gc_charname_cst
                                               im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
                                             IMPORTING
                                               ex_valrange_tab = lr_charname_rng ).
    CATCH zcx_pp_exceptions.
  ENDTRY.
  TRY.
      "comprimento
      zcl_bc_fixed_values=>get_single_value( EXPORTING
                                               im_paramter_var = zcl_bc_fixed_values=>gc_charcomp_cst
                                               im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
                                             IMPORTING
                                               ex_prmvalue_var = DATA(lv_valuechr_var) ).
      "conversão de formatos
      lv_charcomp_var = lv_valuechr_var.
    CATCH zcx_pp_exceptions.
  ENDTRY.
  TRY.
      "largura
      zcl_bc_fixed_values=>get_single_value( EXPORTING
                                               im_paramter_var = zcl_bc_fixed_values=>gc_charlarg_cst
                                               im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
                                             IMPORTING
                                               ex_prmvalue_var = lv_valuechr_var ).
      "conversão de formatos
      lv_charlarg_var = lv_valuechr_var.
    CATCH zcx_pp_exceptions.
  ENDTRY.
  "percorrer todos os items
  LOOP AT lt_docmitems_tab INTO DATA(ls_msegline_str).
    "obter configuração do lote
    zcl_mm_classification=>get_classification_by_batch( EXPORTING
                                                          im_material_var       = ls_msegline_str-matnr
                                                          im_lote_var           = ls_msegline_str-charg
                                                        IMPORTING
                                                          ex_classification_tab = DATA(lt_characts_tab) ).
    "descrição material
    LOOP AT lt_characts_tab INTO DATA(ls_characts_str)
      WHERE atnam IN lr_charname_rng
        AND ausp1 IS NOT INITIAL.
      "descrição do material
      lv_matdescr_var = ls_characts_str-ausp1.
      "sair do loop
      EXIT.
    ENDLOOP.

    IF lv_matdescr_var IS INITIAL.
      "obter descrição do dado mestre
      lv_matdescr_var = COND #( WHEN line_exists( lt_matrdesc_tab[ matnr = ls_msegline_str-matnr ] )
                                THEN lt_matrdesc_tab[ matnr = ls_msegline_str-matnr ]-maktx ).
    ENDIF.
    "obter desc
    APPEND VALUE #( matnr = ls_msegline_str-matnr
                    maktx = lv_matdescr_var
                    met_comp = COND #( WHEN line_exists( lt_characts_tab[ atnam = lv_charcomp_var ] )
                                       THEN lt_characts_tab[ atnam = lv_charcomp_var ]-ausp1 )
                    met_larg = COND #( WHEN line_exists( lt_characts_tab[ atnam = lv_charlarg_var ] )
                                       THEN lt_characts_tab[ atnam = lv_charlarg_var ]-ausp1 )
                    menge = ls_msegline_str-menge
                    meins = ls_msegline_str-meins
                    pspnr = ls_msegline_str-mat_pspnr
                    batch = ls_msegline_str-charg ) TO gt_labels_tab.
    "limpar variáveis
    CLEAR: lv_matdescr_var.
  ENDLOOP.
  "obter descrição do material na caracteristica
ENDFORM.
