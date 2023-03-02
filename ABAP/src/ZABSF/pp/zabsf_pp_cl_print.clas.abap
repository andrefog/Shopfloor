class ZABSF_PP_CL_PRINT definition
  public
  final
  create public .

public section.

  interfaces ZIF_ABSF_PP_PRINT .

  methods CONSTRUCTOR
    importing
      !INITIAL_REFDT type VVDATUM
      !INPUT_OBJECT type ZABSF_PP_S_INPUTOBJECT .
  class-methods DST_PRINT_PP_LABEL
    importing
      !IM_NEWLABEL_STR type ZPP_LABELS_T
      !IM_WORKCENT_VAR type ARBPL
      !IM_SOLDADOR_VAR type CHAR12
    changing
      !CH_RETURN_TAB type BAPIRET2_T .
  class-methods PRINT_SHORT_LABEL
    importing
      !INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !ARBPL type ARBPL
      !AUFNR type AUFNR
      !MATNR type MATNR
    exporting
      !RETURN_TAB type BAPIRET2_T .
  class-methods GET_PRODUCTION_LABELS_DATA
    importing
      !IM_AUFNRVAL_VAR type AUFNR optional
      !IM_BATCHVAL_VAR type CHARG_D optional
      !IM_MATERIAL_VAR type MATNR optional
      !IM_MATNDESC_VAR type ATWRT optional
      !IM_PROJTPEP_VAR type PS_PSP_PNR optional
      !IM_QUANTITY_VAR type INT2 optional
      !IM_QTT_UNIT_VAR type MEINS optional
      !IM_CONFIRMT_VAR type CO_RUECK optional
      !IM_CONFCONT_VAR type CO_RMZHL optional
      !IM_SEQUENCE_VAR type FLAG optional
      !IM_SO_NUMBR_TAB type ANY TABLE optional
      !IM_SHOPFLOR_VAR type FLAG optional
    exporting
      !EX_TBLABELS_TAB type ZPP_PROD_LABEL_TT
    raising
      ZCX_PP_EXCEPTIONS .
  class-methods VENDOR_PP_LABEL_PROCESS
    importing
      !IM_NEWLABEL_STR type ZPP_LABELS_T
      !IM_AUFNRVAL_VAR type AUFNR
      !IM_QUANTITY_VAR type INT2
    changing
      !CH_RETURN_TAB type BAPIRET2_T .
protected section.
private section.

  data REFDT type VVDATUM .
  data INPUTOBJ type ZABSF_PP_S_INPUTOBJECT .
ENDCLASS.



CLASS ZABSF_PP_CL_PRINT IMPLEMENTATION.


METHOD CONSTRUCTOR.
*Ref. Date
  refdt = initial_refdt.

*App input data
  inputobj = input_object.
ENDMETHOD.


method dst_print_pp_label.
    "variáveis locais
    data: lv_job_name        type btcjob,
          lv_job_nr          type btcjobcnt,
          lv_job_released(1),
          lr_label_rng       type range of int4,
          lv_printseq_var    type flag,
          lv_netiquet_var    type int2.

    "nome do job
    lv_job_name = 'ZPP_PRINT_LABELS_R'.
    "obter impressora
    select single printer
      into @data(lv_printer_var)
      from zabsf_pp081
        where werks eq @im_newlabel_str-werks
          and arbpl eq @im_workcent_var.
    if sy-subrc ne 0.
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgid      = 'ZABSF_PP'
          msgty      = 'E'
          msgno      = '134'
          msgv1      = im_workcent_var
          msgv2      = im_newlabel_str-werks
        changing
          return_tab = ch_return_tab.
      "sair do processamento
      return.
    endif.
    "criar job
    call function 'JOB_OPEN'
      exporting
        jobname          = lv_job_name
      importing
        jobcount         = lv_job_nr
      exceptions
        cant_create_job  = 1
        invalid_job_data = 2
        jobname_missing  = 3
        others           = 4.
    if syst-subrc ne 0.
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgid      = sy-msgid
          msgty      = sy-msgty
          msgno      = sy-msgno
          msgv1      = sy-msgv1
          msgv2      = sy-msgv2
          msgv3      = sy-msgv3
          msgv4      = sy-msgv4
        changing
          return_tab = ch_return_tab.
      "sair do processamento
      return.
    endif.
    "criar range de etiquetas
    append value #( sign   = 'I'
                    option = 'BT'
                    low    = im_newlabel_str-label_from
                    high   = im_newlabel_str-label_to ) to lr_label_rng.
    "activar flag impressão em sequência
    lv_printseq_var = abap_true.
    "conversão de formatos
    lv_netiquet_var = im_newlabel_str-menge.
    "submit ao programa de impressão
    submit (lv_job_name)
      with p_copies eq '1'
      with p_prewin eq abap_false
      with p_printr eq lv_printer_var
      with p_langu  eq sy-langu
      with p_seqnr  eq abap_true
      with so_numb in lr_label_rng
      with p_aufnr eq im_newlabel_str-aufnr
      with p_batch eq im_newlabel_str-charg
      with p_matnr eq im_newlabel_str-matnr
      with p_quant eq lv_netiquet_var
      with p_maktx eq im_newlabel_str-maktx
      with p_meins eq im_newlabel_str-meins
      with p_rueck eq im_newlabel_str-rueck
      with p_rmzhl eq im_newlabel_str-rmzhl
      with p_shopf eq abap_true
        via job lv_job_name number lv_job_nr
        and return.
    if sy-subrc ne 0.
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgid      = sy-msgid
          msgty      = sy-msgty
          msgno      = sy-msgno
          msgv1      = sy-msgv1
          msgv2      = sy-msgv2
          msgv3      = sy-msgv3
          msgv4      = sy-msgv4
        changing
          return_tab = ch_return_tab.
      "sair do processamento
      return.
    endif.
    "encerrar job
    call function 'JOB_CLOSE'
      exporting
        jobcount             = lv_job_nr
        jobname              = lv_job_name
        strtimmed            = 'X'
      importing
        job_was_released     = lv_job_released
      exceptions
        cant_start_immediate = 1
        invalid_startdate    = 2
        jobname_missing      = 3
        job_close_failed     = 4
        job_nosteps          = 5
        job_notex            = 6
        lock_failed          = 7
        others               = 8.
    if sy-subrc ne 0.
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgid      = sy-msgid
          msgty      = sy-msgty
          msgno      = sy-msgno
          msgv1      = sy-msgv1
          msgv2      = sy-msgv2
          msgv3      = sy-msgv3
          msgv4      = sy-msgv4
        changing
          return_tab = ch_return_tab.
    endif.
  endmethod.


METHOD get_production_labels_data.
    "constantes locais
    CONSTANTS: lc_multimat_cst TYPE aufart VALUE 'ZPP3'.
    "variáveis locais
    DATA: lv_etiqcout_var TYPE int4 VALUE 1,
          lv_totaletq_var TYPE int4,
          lv_etiqcout_chr TYPE char4,
          lv_totaletq_chr TYPE char4,
          lv_cycleint_var TYPE int4,
          lt_etiqrang_rng TYPE RANGE OF int4,
          lt_aufktext_tab TYPE TABLE OF tline,
          lr_charname_rng TYPE RANGE OF atnam,
          lv_chartipo_var TYPE atnam,
          lv_chardim1_var TYPE atnam,
          lv_characab_var TYPE atnam,
          lr_charpeso_rng TYPE RANGE OF atnam,
          lv_matdescr_var TYPE atwrt,
          lv_charpeso_var TYPE atwrt,
          lv_charplan_var TYPE atnam,
          lv_operador_var TYPE atnam,
          lv_operlist_var TYPE string,
          lv_operlabl_var TYPE zpp_prod_label_s-soldador.
    "limpara variáveis locais
    REFRESH: ex_tblabels_tab.
    "obter centro da ordem de produção
    SELECT SINGLE werks, auart
      FROM aufk
      INTO ( @DATA(lv_werksval_var), @DATA(lv_ordertyp_var) )
        WHERE aufnr EQ @im_aufnrval_var.
    IF sy-subrc  NE 0.
      "sair do processamento
      RETURN.
    ENDIF.
    "obter características relevantes
    TRY.
        "nome
        zcl_bc_fixed_values=>get_ranges_value( EXPORTING
                                                 im_paramter_var = zcl_bc_fixed_values=>gc_charname_cst
                                                 im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
                                               IMPORTING
                                                 ex_valrange_tab = lr_charname_rng ).
        "tipologia
        zcl_bc_fixed_values=>get_single_value( EXPORTING
                                                 im_paramter_var = zcl_bc_fixed_values=>gc_chartipo_cst
                                                 im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
                                                 im_werksval_var = lv_werksval_var
                                               IMPORTING
                                                 ex_prmvalue_var = DATA(lv_valuechr_var) ).
        "conversão de formatos
        lv_chartipo_var = lv_valuechr_var.

        "dim1
        zcl_bc_fixed_values=>get_single_value( EXPORTING
                                                 im_paramter_var = zcl_bc_fixed_values=>gc_chardim1_cst
                                                 im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
                                                 im_werksval_var = lv_werksval_var
                                               IMPORTING
                                                 ex_prmvalue_var = lv_valuechr_var ).
        "conversão de formatos
        lv_chardim1_var = lv_valuechr_var.

        "acabamento
        zcl_bc_fixed_values=>get_single_value( EXPORTING
                                                 im_paramter_var = zcl_bc_fixed_values=>gc_characab_cst
                                                 im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
                                               IMPORTING
                                                 ex_prmvalue_var = lv_valuechr_var ).
        "conversão de formatos
        lv_characab_var = lv_valuechr_var.

        "caracteristica plano de fabrico
        zcl_bc_fixed_values=>get_single_value( EXPORTING
                                                 im_paramter_var = zcl_bc_fixed_values=>gc_charplan_cst
                                                 im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
                                                 im_werksval_var = lv_werksval_var
                                               IMPORTING
                                                 ex_prmvalue_var = lv_valuechr_var ).
        lv_charplan_var = lv_valuechr_var.

        "carcateristica com os operadores
        zcl_bc_fixed_values=>get_single_value( EXPORTING
                                         im_paramter_var = zcl_bc_fixed_values=>gc_charopers_cst
                                         im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
                                       IMPORTING
                                         ex_prmvalue_var = lv_valuechr_var ).
        lv_operador_var = lv_valuechr_var.

        "caractiristica peso
        zcl_bc_fixed_values=>get_ranges_value( EXPORTING
                                                        im_paramter_var = zcl_bc_fixed_values=>gc_charpeso_cst
                                                        im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
                                                      IMPORTING
                                                        ex_valrange_tab = lr_charpeso_rng ).
      CATCH zcx_pp_exceptions INTO DATA(lo_excprtion_obj).
        "lançar excepção
        RAISE EXCEPTION TYPE zcx_pp_exceptions
          EXPORTING
            msgty = lo_excprtion_obj->msgty
            msgid = lo_excprtion_obj->msgid
            msgno = lo_excprtion_obj->msgno
            msgv1 = lo_excprtion_obj->msgv1
            msgv2 = lo_excprtion_obj->msgv2
            msgv3 = lo_excprtion_obj->msgv3
            msgv4 = lo_excprtion_obj->msgv4.
    ENDTRY.
    "obter objecto configurador da ordem
    SELECT SINGLE cuobj
      FROM afpo
      INTO @DATA(lv_cuobj_var)
     WHERE aufnr EQ @im_aufnrval_var.

    "conversão de valores
    lt_etiqrang_rng = im_so_numbr_tab.
    "etiqueta incial
    lv_etiqcout_var = lt_etiqrang_rng[ 1 ]-low.
    "etiqueta final
    lv_totaletq_var = lt_etiqrang_rng[ 1 ]-high.
    "contador de cycle
    IF im_sequence_var EQ abap_true.
      IF im_quantity_var IS NOT INITIAL.
        "imprime n etiquetas
        lv_cycleint_var = im_quantity_var.
      ELSE.
        lv_cycleint_var = 1 + ( lv_totaletq_var - lv_etiqcout_var ).
      ENDIF.
    ELSE.
      lv_cycleint_var = 1.
    ENDIF.
    "obter PEP da ordem
    SELECT SINGLE projn
      FROM afpo
      INTO @DATA(lv_pepelemt_var)
        WHERE aufnr EQ @im_aufnrval_var
          AND projn NE @abap_false.
    "criar n etiquetas
    DO lv_cycleint_var TIMES.
      "obter caracteristicas do lote
      IF im_batchval_var IS NOT INITIAL.
        "obter material do lote
        SELECT SINGLE matnr
          FROM mcha
          INTO @DATA(lv_material_var)
            WHERE charg EQ @im_batchval_var
              AND werks EQ @lv_werksval_var.
        "ler caracteristicas do lote
        zcl_mm_classification=>get_classification_by_batch( EXPORTING
                                                              im_material_var       = lv_material_var
                                                              im_lote_var           = im_batchval_var
                                                              IMPORTING
                                                              ex_classification_tab = DATA(lt_characts_tab) ).
        "obter operadores da ordem
        LOOP AT lt_characts_tab INTO DATA(ls_characts_str)
          WHERE atnam EQ lv_operador_var.
          "concatenar operadores
          lv_operlist_var = |{ lv_operlist_var } { ls_characts_str-ausp1 }|.
          CLEAR ls_characts_str.
        ENDLOOP.
        CONDENSE lv_operlist_var.
        MOVE lv_operlist_var TO lv_operlabl_var.
        CLEAR lv_operlist_var.
      ENDIF.
      "descrição material a partir do lote
      LOOP AT lt_characts_tab INTO ls_characts_str
        WHERE atnam IN lr_charname_rng
          AND ausp1 IS NOT INITIAL.
        "descrição do material
        lv_matdescr_var = ls_characts_str-ausp1.
        "sair do loop
        CLEAR ls_characts_str.
        EXIT.
      ENDLOOP.
      "peso
      LOOP AT lt_characts_tab INTO ls_characts_str
        WHERE atnam IN lr_charpeso_rng.
        lv_charpeso_var = ls_characts_str-ausp1.
        EXIT.
      ENDLOOP.
      "descrição o material a partir da ordem
      IF lv_matdescr_var IS INITIAL.
        "read data from classification
        zcl_mm_classification=>get_material_desc_by_object( EXPORTING
                                                              im_cuobj_var       = lv_cuobj_var
                                                            IMPORTING
                                                              ex_description_var = lv_matdescr_var ).
      ENDIF.
      "impressão via shopfloor
      IF im_shopflor_var NE abap_true AND im_matndesc_var IS NOT INITIAL.
        "validar material
        IF lv_matdescr_var NE im_matndesc_var.
          "Material &1 não associado à ordem de produção &2
          RAISE EXCEPTION TYPE zcx_pp_exceptions
            EXPORTING
              msgty = sy-abcde+4(1)
              msgid = 'ZABSF_PP'
              msgv1 = CONV #( lv_matdescr_var )
              msgv2 = CONV #( im_aufnrval_var )
              msgno = '137'.
        ENDIF.
      ENDIF.
      IF lv_ordertyp_var EQ lc_multimat_cst.
        "obter plano de fabrico
        READ TABLE lt_characts_tab INTO DATA(ls_charact_str) WITH KEY atnam = lv_charplan_var.
        IF sy-subrc EQ 0.
          DATA(lv_prodplan_var) = ls_charact_str-ausp1.
        ENDIF.
      ELSE.
        IF im_batchval_var IS INITIAL.
          "obter operadores a partir da confirmação
          SELECT *
            FROM zabsf_pp065
            INTO TABLE @DATA(lt_operators_tab)
              WHERE conf_no  EQ @im_confirmt_var
                AND conf_cnt EQ @im_confcont_var.
          "percorrer lista de operadores
          LOOP AT lt_operators_tab INTO DATA(ls_operators_str).
            "concatenar operadores
            lv_operlist_var = |{ lv_operlist_var } { ls_operators_str-oprid }|.
            CLEAR ls_characts_str.
          ENDLOOP.
          CONDENSE lv_operlist_var.
          "truncar a 40
          MOVE lv_operlist_var TO lv_operlabl_var.
        ENDIF.
        "plano fabrico
        CALL METHOD zcl_mm_classification=>get_classification_config
          EXPORTING
            im_instance_cuobj_var = lv_cuobj_var
          IMPORTING
            ex_classfication_tab  = DATA(lt_classfic_tab)
          EXCEPTIONS
            instance_not_found    = 1
            OTHERS                = 2.
        IF sy-subrc <> 0.
        ENDIF.
        "plano de fabrico obtido através da configurador da ordem
        lv_prodplan_var = COND #( WHEN line_exists( lt_classfic_tab[ atnam = lv_charplan_var ] )
                                  THEN lt_classfic_tab[ atnam = lv_charplan_var ]-atwrt ).
        "obter peso da configuração se não existir no lote
        IF lv_charpeso_var IS INITIAL.
          LOOP AT lt_classfic_tab INTO DATA(ls_classfic_str)
            WHERE atnam IN lr_charpeso_rng.
            "peso
            lv_charpeso_var = ls_classfic_str-atwrt.
            "sair do loop
            EXIT.
          ENDLOOP.
        ENDIF.
      ENDIF.

** HTM - 31.03.2021 - Total traceability + Update form - BEG
** Origem no include ZCNMM_PRD_ORDER_AUT - ATCO10
      IF lv_prodplan_var IS NOT INITIAL.

        SELECT SINGLE traceability
          INTO @DATA(lv_traceability)
          FROM zpp_pfnumber_tab
         WHERE plano_fabrico EQ @lv_prodplan_var.

        IF lv_traceability EQ abap_true.

          REFRESH lt_aufktext_tab.

          CALL FUNCTION 'READ_TEXT'
            EXPORTING
              id                      = 'KOPF'
              language                = sy-langu
              name                    = CONV tdobname( |{ sy-mandt }{ im_aufnrval_var ALPHA = IN }| )
              object                  = 'AUFK'
            TABLES
              lines                   = lt_aufktext_tab
            EXCEPTIONS
              id                      = 1
              language                = 2
              name                    = 3
              not_found               = 4
              object                  = 5
              reference_check         = 6
              wrong_access_to_archive = 7
              OTHERS                  = 8.
          IF sy-subrc <> 0.
          ENDIF.
          "programa
          IF line_exists( lt_aufktext_tab[ 11 ] ).
            "programa
            DATA(lv_tdline) = lt_aufktext_tab[ 11 ]-tdline.
            CLEAR:
              lv_etiqcout_chr,
              lv_totaletq_chr.
            SPLIT lv_tdline AT '/' INTO lv_etiqcout_chr lv_totaletq_chr.
            MOVE: lv_etiqcout_chr TO lv_etiqcout_var,
                  lv_totaletq_chr TO lv_totaletq_var.
          ENDIF.

        ENDIF.    "IF lv_traceability EQ abap_true.

      ENDIF.    "IF lv_charpeso_var IS NOT INITIAL.
** HTM - 31.03.2021 - Total traceability + Update form - END

      "dados da etiqueta
      APPEND VALUE #( aufnr     = im_aufnrval_var
                      batch     = |{ im_batchval_var ALPHA = OUT }|
                      matnr     = lv_material_var
                      maktx     = lv_matdescr_var
                      pspnr     = lv_pepelemt_var
                      counter   = lv_etiqcout_var
                      total     = lv_totaletq_var
                      meins     = 'UN'
                      bzy_pf    = lv_prodplan_var
                      rueck     =	im_confirmt_var
                      menge     = '1' "uma unidade
                      rmzhl     = im_confcont_var
                      zby_peso  = lv_charpeso_var
                      zbyaca    = COND #( WHEN line_exists( lt_characts_tab[ atnam = lv_characab_var ] )
                                          THEN lt_characts_tab[ atnam = lv_characab_var ]-ausp1 )
                      werks     = lv_werksval_var
                      tipologia = COND #( WHEN line_exists( lt_characts_tab[ atnam = lv_chartipo_var ] )
                                          THEN lt_characts_tab[ atnam = lv_chartipo_var ]-ausp1 )
                      dim1      = COND #( WHEN line_exists( lt_characts_tab[ atnam = lv_chardim1_var ] )
                                          THEN lt_characts_tab[ atnam = lv_chardim1_var ]-ausp1 )
                      soldador  = lv_operlabl_var ) TO ex_tblabels_tab.
      "incrementar contador
      lv_etiqcout_var = 1 + lv_etiqcout_var.
      "limpar variáveis
      CLEAR: lv_operlabl_var, lv_operlist_var.
    ENDDO.
  ENDMETHOD.


method print_short_label.

    "constantes locais
    constants: lc_formname_cst type tdsfname value 'ZPP_PROD_LABEL_SHORT'.

    "variáveis locais
    data: lv_funcname_var type rs38l_fnam,
          ls_ctrparam_str type ssfctrlop,
          ls_soutputs_str type ssfcompop,
          lv_formname_var type tdsfname,
          lt_aufktext_tab type table of tline,
          lv_prodplan_var type atwrt,
          lv_charplan_var type atnam.

    "obter centro da ordem de produção
    select single werks, auart
      from aufk
      into ( @data(lv_werksval_var), @data(lv_ordertyp_var) )
        where aufnr eq @aufnr.
    if sy-subrc ne 0.
      return.
    endif.
    "obter configuração
    try.
        "obter caracteristica plano de fabrico
        zcl_bc_fixed_values=>get_single_value( exporting
                                                 im_paramter_var = zcl_bc_fixed_values=>gc_charplan_cst
                                                 im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
                                                 im_werksval_var = lv_ordertyp_var
                                               importing
                                                 ex_prmvalue_var = data(lv_valuechr_var) ).
        lv_charplan_var = lv_valuechr_var.
      catch zcx_pp_exceptions into data(lo_bcexceptions_obj).
        "falta configuração
        call method zabsf_pp_cl_log=>add_message
          exporting
            msgty      = lo_bcexceptions_obj->msgty
            msgno      = lo_bcexceptions_obj->msgno
            msgid      = lo_bcexceptions_obj->msgid
            msgv1      = lo_bcexceptions_obj->msgv1
            msgv2      = lo_bcexceptions_obj->msgv2
            msgv3      = lo_bcexceptions_obj->msgv3
            msgv4      = lo_bcexceptions_obj->msgv4
          changing
            return_tab = return_tab.
        return.
    endtry.

    "obter impressora
    select single printer
      into @data(lv_printer_var)
      from zabsf_pp081
        where werks eq @inputobj-werks
          and arbpl eq @arbpl.
    if sy-subrc ne 0.
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgid      = 'ZABSF_PP'
          msgty      = 'E'
          msgno      = '134'
          msgv1      = arbpl
          msgv2      = inputobj-werks
        changing
          return_tab = return_tab.
      "sair do processamento
      return.
    endif.

    "nome do formulário
    lv_formname_var = lc_formname_cst.
    "obter PEP da ordem
    select single projn, cuobj
      from afpo
      into ( @data(lv_pepelemt_var), @data(lv_cuobj_var) )
        where aufnr eq @aufnr
          and projn ne @abap_false.
    "plano fabrico
    call method zcl_mm_classification=>get_classification_config
      exporting
        im_instance_cuobj_var = lv_cuobj_var
      importing
        ex_classfication_tab  = data(lt_classfic_tab)
      exceptions
        instance_not_found    = 1
        others                = 2.
    if sy-subrc <> 0.
    endif.
    "plano de fabrico
    lv_prodplan_var = cond #( when line_exists( lt_classfic_tab[ atnam = lv_charplan_var ] )
                              then lt_classfic_tab[ atnam = lv_charplan_var ]-atwrt ).

    "obter nome do formulário
    call function 'SSF_FUNCTION_MODULE_NAME'
      exporting
        formname           = lv_formname_var
      importing
        fm_name            = lv_funcname_var
      exceptions
        no_form            = 1
        no_function_module = 2
        others             = 3.
    if sy-subrc ne 0.
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgid      = 'ZABSF_PP'
          msgty      = 'E'
          msgno      = '131'
          msgv1      = arbpl
          msgv2      = inputobj-werks
        changing
          return_tab = return_tab.
      "sair do processamento
      return.
    endif.
    "opções de output
    ls_soutputs_str-tddest   = lv_printer_var.
    ls_soutputs_str-tdnewid  = abap_true.
    ls_soutputs_str-tdimmed  = abap_true.
    ls_soutputs_str-tdnoprev = abap_false.
    ls_soutputs_str-tdcopies = 1.

    if sy-batch eq abap_true.
      ls_ctrparam_str-no_dialog = abap_true.
    endif.
    ls_ctrparam_str-no_open   = abap_true.
    ls_ctrparam_str-no_close  = abap_true.
    ls_ctrparam_str-langu     = sy-langu.
    ls_ctrparam_str-replangu1 = sy-langu.
    ls_soutputs_str-tdnewid   = abap_true.
    "abrir formulário
    call function 'SSF_OPEN'
      exporting
        user_settings      = abap_false
        output_options     = ls_soutputs_str
        control_parameters = ls_ctrparam_str
      exceptions
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        others             = 5.
    if sy-subrc ne 0.
      "Erro ao abrir formulário
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgid      = 'ZABSF_PP'
          msgty      = 'E'
          msgno      = '130'
          msgv1      = arbpl
          msgv2      = inputobj-werks
        changing
          return_tab = return_tab.
      "sair do processamento
      return.
    endif.
    "obter descrição do material
    zcl_mm_classification=>get_material_desc_by_object( exporting
                                                          im_cuobj_var       = lv_cuobj_var
                                                        importing
                                                          ex_description_var = data(lv_matrdesc_var) ).

    if lv_matrdesc_var is initial.
      data(lv_matnr) = |{ matnr alpha = in }|.
      select single maktx
        from makt
        into @lv_matrdesc_var
          where matnr eq @lv_matnr
            and spras eq @sy-langu.
    endif.
    data(ls_strlabel_str) = value zpp_prod_label_s( pspnr  = lv_pepelemt_var
                                                    bzy_pf = lv_prodplan_var
                                                    maktx  = lv_matrdesc_var
                                                    matnr  = lv_matnr ) .
    "invocar formulário
    call function lv_funcname_var
      exporting
        control_parameters = ls_ctrparam_str
        output_options     = ls_soutputs_str
        user_settings      = abap_false
        is_prod_label_str  = ls_strlabel_str
      exceptions
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        others             = 5.
    if sy-subrc ne 0.
    else ##NEEDED.
    endif.
    ls_soutputs_str-tdnewid = abap_false.
    "encerrar formulário
    call function 'SSF_CLOSE'
      exceptions
        formatting_error = 1
        internal_error   = 2
        send_error       = 3
        others           = 4.
    if sy-subrc ne 0.
      "Erro ao encerrar o formulário
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgid      = 'ZABSF_PP'
          msgty      = 'E'
          msgno      = '132'
          msgv1      = arbpl
          msgv2      = inputobj-werks
        changing
          return_tab = return_tab.
      "sair do processamento
      return.
    endif.
  endmethod.


method vendor_pp_label_process.
    "constantes locais
    constants: lc_finshgod_cst type tdsfname value 'ZPP_PROD_LABEL',
               lc_semifinh_cst type tdsfname value 'ZPP_PROD_LABEL_SA',
               lc_ordrzpp3_cst type auart    value 'ZPP3',
               lc_ordrzpp2_cst type auart    value 'ZPP2'.
    "variáveis locais
    data: lr_label_rng       type range of int4,
          lv_funcname_var    type rs38l_fnam,
          ls_ctrparam_str    type ssfctrlop,
          ls_soutputs_str    type ssfcompop,
          lv_formname_var    type tdsfname,
          lv_binfilesize     type so_obj_len,
          lv_pdf_xstring     type xstring,
          st_job_output_info type ssfcrescl,
          lt_otfdata         type table of itcoo,
          lt_pdftab          type table of tline.

    "criar range de etiquetas
    append value #( sign   = 'I'
                    option = 'BT'
                    low    = im_newlabel_str-label_from
                    high   = im_newlabel_str-label_to ) to lr_label_rng.
    "obter lista de etiquetas
    try.
        zabsf_pp_cl_print=>get_production_labels_data( exporting
                                                         im_aufnrval_var = im_newlabel_str-aufnr
                                                         im_batchval_var = im_newlabel_str-charg
                                                         im_material_var = im_newlabel_str-matnr
                                                         im_matndesc_var = im_newlabel_str-maktx
                                                         im_projtpep_var = im_newlabel_str-pspnr
                                                         im_quantity_var = im_quantity_var
                                                         im_qtt_unit_var = 'UN'
                                                         im_confirmt_var = im_newlabel_str-rueck
                                                         im_confcont_var = im_newlabel_str-rmzhl
                                                         im_sequence_var = abap_true
                                                         im_so_numbr_tab = lr_label_rng
                                                         im_shopflor_var = abap_true
                                                       importing
                                                         ex_tblabels_tab = data(lt_labels_tab) ).

      catch zcx_pp_exceptions into data(lo_bcexceptions_obj) .
        "falta configuração
        call method zabsf_pp_cl_log=>add_message
          exporting
            msgty      = 'W'
            msgno      = lo_bcexceptions_obj->msgno
            msgid      = lo_bcexceptions_obj->msgid
            msgv1      = lo_bcexceptions_obj->msgv1
            msgv2      = lo_bcexceptions_obj->msgv2
            msgv3      = lo_bcexceptions_obj->msgv3
            msgv4      = lo_bcexceptions_obj->msgv4
          changing
            return_tab = ch_return_tab.
        "sair do processamento
        return.
    endtry.

    "obter tipo de ordem de produção
    select single auart
      from aufk
      into @data(lv_ordertyp_var)
        where aufnr eq @im_aufnrval_var.
    if sy-subrc eq 0.
      "nome do formulário
      lv_formname_var = cond #( when lv_ordertyp_var eq lc_ordrzpp2_cst
                                then lc_finshgod_cst
                                when lv_ordertyp_var eq lc_ordrzpp3_cst
                                then lc_semifinh_cst ).
    else.
      "Ordem de produção &1 não existe
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgty      = 'W'
          msgno      = '153'
          msgid      = 'ZABSF_PP'
        changing
          return_tab = ch_return_tab.
      "sair do processamento
      return.
    endif.

    "obter nome do formulário
    call function 'SSF_FUNCTION_MODULE_NAME'
      exporting
        formname           = lv_formname_var
      importing
        fm_name            = lv_funcname_var
      exceptions
        no_form            = 1
        no_function_module = 2
        others             = 3.
    if sy-subrc ne 0.
      "Erro ao obter nome do formulário
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgty      = 'W'
          msgno      = '131'
          msgid      = 'ZABSF_PP'
        changing
          return_tab = ch_return_tab.
      "sair do processamento
      return.
    endif.

    "opções de output
    ls_soutputs_str-tdnewid  = abap_true.
    ls_soutputs_str-tddest  = 'LOCL'.
    ls_soutputs_str-tdimmed  = abap_true.
    ls_soutputs_str-tdcopies = 1.
    ls_ctrparam_str-no_dialog = abap_true.

    ls_ctrparam_str-no_open   = abap_true.
    ls_ctrparam_str-no_close  = abap_true.
    ls_ctrparam_str-langu     = sy-langu.
    ls_ctrparam_str-replangu1 = sy-langu.
    ls_soutputs_str-tdnewid   = abap_true.

    ls_ctrparam_str-getotf = abap_true.
    ls_ctrparam_str-no_dialog = abap_true.
    ls_soutputs_str-tdnoprev = abap_true.

    ls_soutputs_str-xdfcmode = 'X'.
    ls_soutputs_str-xsfcmode = 'X'.
    "abrir formulário
*    call function 'SSF_OPEN'
*      exporting
*        user_settings      = abap_false
*        output_options     = ls_soutputs_str
*        control_parameters = ls_ctrparam_str
*      exceptions
*        formatting_error   = 1
*        internal_error     = 2
*        send_error         = 3
*        user_canceled      = 4
*        others             = 5.
*    if sy-subrc ne 0.
*      "Erro ao abrir formulário
*      call method zabsf_pp_cl_log=>add_message
*        exporting
*          msgty      = sy-abcde+4(1)
*          msgno      = '130'
*          msgid      = 'ZABSF_PP'
*        changing
*          return_tab = ch_return_tab.
*      "sair do processamento
*      return.
*    endif.

    "percorrer todas as labels
    loop at lt_labels_tab into data(ls_strlabel_str).

      ls_ctrparam_str-no_open = abap_false.
      ls_ctrparam_str-no_close = abap_false.

      "invocar formulário
      call function lv_funcname_var
        exporting
          control_parameters = ls_ctrparam_str
          output_options     = ls_soutputs_str
          user_settings      = abap_false
          is_prod_label_str  = ls_strlabel_str
        importing
          job_output_info    = st_job_output_info
        exceptions
          formatting_error   = 1
          internal_error     = 2
          send_error         = 3
          user_canceled      = 4
          others             = 5.
      if sy-subrc ne 0.
      else ##NEEDED.
      endif.
      "construir tabela OTF
      append lines of st_job_output_info-otfdata[] to  lt_otfdata[].
      "limpar variáveis
      refresh st_job_output_info-otfdata[].

      " ls_soutputs_str-tdnewid = abap_false.
    endloop.

    "converter para PDF
    call function 'CONVERT_OTF'
      exporting
        format                = 'PDF'
        max_linewidth         = 10
      importing
        bin_filesize          = lv_binfilesize
        bin_file              = lv_pdf_xstring
      tables
        otf                   = lt_otfdata[]
        lines                 = lt_pdftab[]
      exceptions
        err_max_linewidth     = 1
        err_format            = 2
        err_conv_not_possible = 3
        err_bad_otf           = 4
        others                = 5.
    if sy-subrc <> 0.
      "erro ao gerar OTF
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgty      = 'W'
          msgno      = sy-msgno
          msgid      = sy-msgid
          msgv1      = sy-msgv1
          msgv2      = sy-msgv2
          msgv3      = sy-msgv3
          msgv4      = sy-msgv4
        changing
          return_tab = ch_return_tab.
      "sair do processamento
      return.
    endif.

    data:
      l_document_data      type sodocchgi1,
      l_document_type      type so_obj_tp,
      l_document_info      type sofolenti1,
      l_object_content_hex type table of solix,
      l_line_content_hex   type solix,
      l_only_name          type string,
      l_extension          type hap_attachment_type,
      l_msgno              type char3,
      l_data_read          type i,
      l_vendor_id          type borident,
      l_attachment_id      type borident,
      ls_doc_bor_key       type hap_s_doc_bor_key,
      conv_class           type ref to cl_abap_conv_in_ce,
      off_class            type ref to cl_abap_view_offlen.

    data: lv_rcode              type sy-subrc.

    data: lt_object_header type standard table of solisti1,
          ls_object_header type solisti1.

    data filelength          type i.
    data binary_tab          type standard table of soli.


    data: ls_objectbo  type sibflporb,
          ls_objectatt type sibflporb,
          ls_link      type obl_s_link,
          lv_lifnr     type lifnr.

    data l_folder_id  type sofdk.
    data(gv_pdf_content) = cl_document_bcs=>xstring_to_solix( lv_pdf_xstring ).

    call function 'SO_FOLDER_ROOT_ID_GET'
      exporting
        region                = 'B'
      importing
        folder_id             = l_folder_id
      exceptions
        communication_failure = 1
        owner_not_exist       = 2
        system_failure        = 3
        x_error               = 4
        others                = 5.


    l_document_data-obj_descr = 'etiquetas'.
    l_document_data-obj_name  = 'ATTACHMENT'.
    l_only_name = 'etiquetas.PDF'.

    l_document_type = 'PDF'.

    l_document_data-doc_size = lv_binfilesize.
    concatenate '&SO_FILENAME=' l_only_name into ls_object_header-line.
    append ls_object_header to lt_object_header.

    call function 'SO_DOCUMENT_INSERT_API1'
      exporting
        folder_id                  = l_folder_id
        document_data              = l_document_data
        document_type              = l_document_type
      importing
        document_info              = l_document_info
      tables
        contents_hex               = gv_pdf_content
        object_header              = lt_object_header
      exceptions
        folder_not_exist           = 1
        document_type_not_exist    = 2
        operation_no_authorization = 3
        parameter_error            = 4
        x_error                    = 5
        enqueue_error              = 6
        others                     = 7.


* fill key information for the business object
    ls_doc_bor_key-planversion = '01'.
    ls_doc_bor_key-id = im_aufnrval_var.

    clear ls_doc_bor_key-partid.

* assign BOR-key (for appraisal document)
    l_vendor_id = ls_doc_bor_key.
    l_vendor_id-objtype = 'BUS2005'.

    l_attachment_id-objtype = 'MESSAGE'.
    l_attachment_id-objkey  = l_document_info-doc_id(34).

    ls_objectbo-typeid    = 'BUS2005'.

    ls_objectbo-instid    = im_aufnrval_var.
    ls_objectbo-catid = 'BO'.
    ls_objectatt-typeid   = 'MESSAGE'.
    ls_objectatt-instid    =  l_document_info-doc_id(34).
    ls_objectatt-catid     = 'BO'.
    ls_link-reltype       = 'ATTA'.

    call method cl_binary_relation=>create_link
      exporting
        is_object_a = ls_objectbo
        is_object_b = ls_objectatt
        ip_reltype  = ls_link-reltype.

    commit work and wait.

    "encerrar formulário
    call function 'SSF_CLOSE'
      exceptions
        formatting_error = 1
        internal_error   = 2
        send_error       = 3
        others           = 4.
    if sy-subrc ne 0.
      "Erro ao encerrar o formulário
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgty      = 'W'
          msgno      = '132'
          msgid      = 'ZABSF_PP'
        changing
          return_tab = ch_return_tab.
      "sair do processamento
      return.
    endif.
  endmethod.


METHOD zif_absf_pp_print~generate_file.
  DATA: it_selection TYPE TABLE OF rsparams,
        it_pdf       TYPE TABLE OF tline.

  DATA: e_usr01         TYPE usr01,
        copies          TYPE pri_params-prcop VALUE '001',
        expiration      TYPE pri_params-pexpi VALUE 1,
        list_name       TYPE pri_params-plist,
        list_text       TYPE pri_params-prtxt,
        out_parameters  TYPE pri_params,
        valid           TYPE string,
        curr_report     TYPE raldb_repo,
        ls_selection    TYPE rsparams,
        ls_matnr        TYPE matnr,
        ld_rqident      TYPE rspoid,
        pdf_bytecount   TYPE i,
        pdf_spoolid     TYPE tsp01-rqident,
        list_pagecount  TYPE i,
        btc_jobname     TYPE tbtcjob-jobname,
        btc_jobcount    TYPE tbtcjob-jobcount,
        bin_file        TYPE xstring,
        filename        TYPE string,
        ld_linsz(3)     TYPE c,
        ls_ZABSF_PP043 TYPE zabsf_pp043,
        spoolid         TYPE tsp01_sp0r-rqid_char.


  REFRESH: it_selection,
           it_pdf.

  CLEAR: e_usr01,
         copies,
         expiration,
         list_name,
         list_text,
         out_parameters,
         valid,
         curr_report,
         ls_selection,
         ls_matnr,
         ld_rqident,
         pdf_bytecount,
         pdf_spoolid,
         list_pagecount,
         btc_jobname,
         btc_jobcount,
         bin_file,
         filename,
         ld_linsz(3),
         ls_ZABSF_PP043,
         spoolid.

  IF matnr_tab[] IS NOT INITIAL.
*  Get print parameter for user
    CALL FUNCTION 'GET_PRINT_PARAM'
      EXPORTING
        i_bname = sy-uname
      IMPORTING
        e_usr01 = e_usr01.

*  Get name of program to create report
    SELECT SINGLE *
      FROM zabsf_pp043
      INTO CORRESPONDING FIELDS OF ls_ZABSF_PP043
      WHERE areaid EQ inputobj-areaid
        AND werks  EQ inputobj-werks
        AND doc_id EQ doc_id.

    IF sy-subrc EQ 0.
      CONCATENATE ls_ZABSF_PP043-filename '_' inputobj-areaid INTO list_text.

      list_name = inputobj-areaid.

      CALL FUNCTION 'GET_PRINT_PARAMETERS'
        EXPORTING
          copies                 = copies
          expiration             = expiration
          destination            = e_usr01-spld
          immediately            = space
          list_name              = list_name
          list_text              = list_text
          new_list_id            = 'X'
          no_dialog              = 'X'
          user                   = sy-uname
        IMPORTING
          out_parameters         = out_parameters
          valid                  = valid
        EXCEPTIONS
          archive_info_not_found = 1
          invalid_print_params   = 2
          invalid_archive_params = 3
          OTHERS                 = 4.

      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.

*    Change parameters
      out_parameters-linsz = 255.
      ld_linsz = out_parameters-linsz.
* Clear out_parameters-paart = x_65_80(DEFAULT) to new

      CONCATENATE out_parameters-paart(5) ld_linsz  INTO out_parameters-paart.

*    Get select option of report
      CALL FUNCTION 'RS_REFRESH_FROM_SELECTOPTIONS'
        EXPORTING
          curr_report     = ls_ZABSF_PP043-report
        TABLES
          selection_table = it_selection
        EXCEPTIONS
          not_found       = 1
          no_report       = 2
          OTHERS          = 3.

      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.

*    Create range in select-option of report
      READ TABLE it_selection INTO ls_selection WITH KEY kind = 'S'.

      IF sy-subrc EQ 0.
        DELETE TABLE it_selection FROM ls_selection.

        LOOP AT matnr_tab INTO ls_matnr.
          CLEAR ls_selection-low.

*        Put left zeros in material
          CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
            EXPORTING
              input        = ls_matnr
            IMPORTING
              output       = ls_matnr
            EXCEPTIONS
              length_error = 1
              OTHERS       = 2.

          IF sy-subrc <> 0.
* Implement suitable error handling here
          ENDIF.

          ls_selection-sign = 'I'.
          ls_selection-option = 'EQ'.
          ls_selection-low = ls_matnr.
          APPEND ls_selection TO it_selection.
        ENDLOOP.
      ENDIF.

*    Submit program to create report
      SUBMIT (ls_ZABSF_PP043-report) WITH SELECTION-TABLE it_selection
                                      TO SAP-SPOOL
                                      SPOOL PARAMETERS out_parameters
                                      WITHOUT SPOOL DYNPRO
                                      AND RETURN.

*    Get spool number
      SELECT rqident UP TO 1 ROWS
        FROM tsp01
        INTO ld_rqident
       WHERE rqowner EQ sy-uname
         AND rqtitle EQ list_text
       ORDER BY rqcretime DESCENDING.
      ENDSELECT.

      IF ld_rqident IS NOT INITIAL.
*      Convert number of spool in PDF
        CALL FUNCTION 'CONVERT_ABAPSPOOLJOB_2_PDF'
          EXPORTING
            src_spoolid              = ld_rqident
            no_dialog                = space
            pdf_destination          = 'X'
            get_size_from_format     = space
          IMPORTING
            pdf_bytecount            = pdf_bytecount
            pdf_spoolid              = pdf_spoolid
            list_pagecount           = list_pagecount
            btc_jobname              = btc_jobname
            btc_jobcount             = btc_jobcount
            bin_file                 = bin_file
          TABLES
            pdf                      = it_pdf
          EXCEPTIONS
            err_no_abap_spooljob     = 1
            err_no_spooljob          = 2
            err_no_permission        = 3
            err_conv_not_possible    = 4
            err_bad_destdevice       = 5
            user_cancelled           = 6
            err_spoolerror           = 7
            err_temseerror           = 8
            err_btcjob_open_failed   = 9
            err_btcjob_submit_failed = 10
            err_btcjob_close_failed  = 11
            OTHERS                   = 12.

        IF sy-subrc <> 0.
*    Implement suitable error handling here
        ENDIF.

        spoolid = ld_rqident.
        CONDENSE spoolid.

*      Delete spool number
        CALL FUNCTION 'RSPO_R_RDELETE_SPOOLREQ'
          EXPORTING
            spoolid = spoolid.

*      Transform pdf in bin file
        CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
          EXPORTING
            buffer     = bin_file
          TABLES
            binary_tab = pdf_content.

*      Name of file to create
        CONCATENATE list_text ls_ZABSF_PP043-ext_file INTO file.
      ENDIF.
    ELSE.
*    No data found
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'E'
          msgno      = '045'
        CHANGING
          return_tab = return_tab.
    ENDIF.
  ELSE.
*  No data found for material
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'E'
        msgno      = '044'
      CHANGING
        return_tab = return_tab.
  ENDIF.
ENDMETHOD.


METHOD zif_absf_pp_print~get_name_form.

*Get name of form
  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = formname
    IMPORTING
      fm_name            = fm_name
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.

  IF sy-subrc <> 0.
*  Standard error
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgid      = sy-msgid
        msgty      = sy-msgty
        msgno      = sy-msgno
        msgv1      = sy-msgv1
        msgv2      = sy-msgv2
        msgv3      = sy-msgv3
        msgv4      = sy-msgv4
      CHANGING
        return_tab = return_tab.
  ENDIF.
ENDMETHOD.


METHOD zif_absf_pp_print~print.
  DATA: lt_defects_desc TYPE TABLE OF zabsf_pp037_t,
        gt_defects      TYPE zabsf_pp_t_def_print,
        lt_form         TYPE TABLE OF zabsf_pp033.

  DATA: ls_ZABSF_PP017  TYPE zabsf_pp017,
        lf_fm_name       TYPE rs38l_fnam,
        lf_fm_name_otr   TYPE rs38l_fnam,
        ld_formname      TYPE tdsfname,
        ld_form          TYPE na_fname,
        ld_arbpl         TYPE arbpl,        "Workcenter or Warehouse
        ld_arbpl_next    TYPE arbpl,
        ld_gwemg         TYPE co_gwemg,
        ld_rework        TYPE ru_rmnga,
        ls_defects_desc  TYPE zabsf_pp037_t,
        ls_defects       TYPE zabsf_pp_s_def_print,
        ls_rework        TYPE zabsf_pp_s_rework,
        ls_form          TYPE zabsf_pp033,
        ld_print         TYPE rspopname,
        ld_print_otr     TYPE rspopname,
        ls_control_param TYPE ssfctrlop,
        ld_output_opt    TYPE ssfcompop,
        ld_qty_proc      TYPE zabsf_pp_e_qty,
        ld_aufpl         TYPE co_aufpl,
        ld_rueck         TYPE co_rueck,
        ld_lmnga         TYPE lmnga,
        ls_afvc          TYPE afvc,
        lines            TYPE i.

  DATA lref_sf_prodord TYPE REF TO zabsf_pp_cl_prdord.

  REFRESH: lt_defects_desc,
           gt_defects.

  CLEAR: ls_ZABSF_PP017,
         lf_fm_name,
         ld_formname,
         ld_form,
         ld_arbpl,
         ld_gwemg,
         ld_rework,
         ls_defects_desc,
         ls_defects,
         ls_rework,
         ls_control_param,
         ld_output_opt,
         ls_form.

  IF ware_print_st IS NOT INITIAL OR arbpl_print_st IS NOT INITIAL.
*  Check if warehouse was filled
    IF ware_print_st-wareid IS NOT INITIAL.
      ld_arbpl = ware_print_st-wareid.
*  Check if workcenter was filled
    ELSEIF arbpl_print_st-arbpl IS NOT INITIAL.
      ld_arbpl = arbpl_print_st-arbpl.
    ENDIF.

*  Get name of form
    SELECT *
      FROM zabsf_pp033
      INTO CORRESPONDING FIELDS OF TABLE lt_form
     WHERE areaid EQ inputobj-areaid
       AND werks EQ inputobj-werks
       AND arbpl EQ ld_arbpl.

    IF sy-subrc EQ 0.

      DESCRIBE TABLE lt_form LINES lines.

      IF lines EQ 1.
        READ TABLE lt_form INTO ls_form INDEX lines.

*      Print
        ld_print = ls_form-impr_out.

*      Get name of function module
        ld_formname = ls_form-sform.

        CALL METHOD me->zif_absf_pp_print~get_name_form
          EXPORTING
            formname   = ld_formname
          CHANGING
            fm_name    = lf_fm_name
            return_tab = return_tab.
      ELSE.
        READ TABLE lt_form INTO ls_form WITH KEY arbpl = ld_arbpl
                                                 flag_form = space.

        IF sy-subrc EQ 0.
*        Print
          ld_print = ls_form-impr_out.

*        Get name of function module
          ld_formname = ls_form-sform.

          CALL METHOD me->zif_absf_pp_print~get_name_form
            EXPORTING
              formname   = ld_formname
            CHANGING
              fm_name    = lf_fm_name
              return_tab = return_tab.
        ENDIF.

        READ TABLE lt_form INTO ls_form WITH KEY arbpl = ld_arbpl
                                                 flag_form = 'X'.

        IF sy-subrc EQ 0.
          CLEAR ld_formname.
*        Print
          ld_print_otr = ls_form-impr_out.

*        Get name of function module
          ld_formname = ls_form-sform.

          CALL METHOD me->zif_absf_pp_print~get_name_form
            EXPORTING
              formname   = ld_formname
            CHANGING
              fm_name    = lf_fm_name_otr
              return_tab = return_tab.
        ENDIF.
      ENDIF.
    ELSE.
*    Not found layout
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'E'
          msgno      = '059'
          msgv1      = inputobj-areaid
          msgv2      = ld_arbpl
        CHANGING
          return_tab = return_tab.
    ENDIF.
  ENDIF.

  IF arbpl_print_st IS NOT INITIAL.
*  Create object of class
    CREATE OBJECT lref_sf_prodord
      EXPORTING
        initial_refdt = refdt
        input_object  = inputobj.

*  Get value in Database
    SELECT SINGLE *
      FROM zabsf_pp017
      INTO CORRESPONDING FIELDS OF ls_ZABSF_PP017
     WHERE aufnr EQ arbpl_print_st-aufnr
       AND matnr EQ arbpl_print_st-matnr
       AND vornr EQ arbpl_print_st-vornr.

*  Get Routing number for operations
    SELECT SINGLE aufpl
      FROM afko
      INTO ld_aufpl
     WHERE aufnr EQ arbpl_print_st-aufnr.

*  Get Confirmation
    SELECT SINGLE rueck
      FROM afvc
      INTO ld_rueck
     WHERE aufpl EQ ld_aufpl
       AND vornr EQ arbpl_print_st-vornr.


*  Confirmed yield
    SELECT SUM( lmnga )
      FROM afru
      INTO ld_lmnga
     WHERE rueck EQ ld_rueck
       AND aufnr EQ arbpl_print_st-aufnr
       AND vornr EQ arbpl_print_st-vornr
       AND stokz EQ space
       AND stzhl EQ space.

*  Get quantity and operation missing
    CALL METHOD lref_sf_prodord->get_qty_vornr
      EXPORTING
        aufnr      = arbpl_print_st-aufnr
        vornr      = arbpl_print_st-vornr
        lmnga      = ld_lmnga
        aufpl      = ld_aufpl
      CHANGING
        qty_proc   = ld_qty_proc
        return_tab = return_tab.

*  Get next operation
    SELECT * UP TO 1 ROWS
      INTO CORRESPONDING FIELDS OF ls_afvc
      FROM afvc AS afvc
      INNER JOIN t430 AS t430
      ON t430~steus EQ afvc~steus
      WHERE afvc~aufpl EQ ld_aufpl
        AND afvc~vornr GT arbpl_print_st-vornr
        AND t430~ruek  EQ '1'
      ORDER BY vornr ASCENDING.
    ENDSELECT.

* Get next workcenter
    SELECT SINGLE arbpl
      FROM crhd
      INTO ld_arbpl_next
     WHERE objid EQ ls_afvc-arbid.

*  Print
    IF ld_print IS NOT INITIAL.
      ld_output_opt-tddest = ld_print.
    ELSE.
      ld_output_opt-tddest = 'LOCL'.
    ENDIF.

    ld_output_opt-tdnewid = 'X'.
    ld_output_opt-tdimmed = space.

    ls_control_param-no_dialog = 'X'.

    IF lf_fm_name IS NOT INITIAL.
      CALL FUNCTION lf_fm_name
        EXPORTING
          control_parameters = ls_control_param
          output_options     = ld_output_opt
          user_settings      = space
          areaid             = inputobj-areaid
          matnr              = arbpl_print_st-matnr
          aufnr              = arbpl_print_st-aufnr
          arbpl              = arbpl_print_st-arbpl
          pstng_date         = refdt
          lmnga              = ls_ZABSF_PP017-lmnga
          missingqty         = ls_ZABSF_PP017-missingqty
          qty_proc           = ld_qty_proc
          arbpl_next         = ld_arbpl_next
        EXCEPTIONS
          formatting_error   = 1
          internal_error     = 2
          send_error         = 3
          user_canceled      = 4
          OTHERS             = 5.

      IF sy-subrc <> 0.
*      Standard error
        CALL METHOD zabsf_pp_cl_log=>add_message
          EXPORTING
            msgid      = sy-msgid
            msgty      = sy-msgty
            msgno      = sy-msgno
            msgv1      = sy-msgv1
            msgv2      = sy-msgv2
            msgv3      = sy-msgv3
            msgv4      = sy-msgv4
          CHANGING
            return_tab = return_tab.
      ELSE.
*      Operation completed successuflly
        CALL METHOD zabsf_pp_cl_log=>add_message
          EXPORTING
            msgty      = 'S'
            msgno      = '013'
          CHANGING
            return_tab = return_tab.
      ENDIF.

*    Reset box quantity
      IF ls_ZABSF_PP017 IS NOT INITIAL.
        CLEAR ls_ZABSF_PP017-prdqty_box.

        UPDATE zabsf_pp017 FROM ls_ZABSF_PP017.

        IF sy-subrc NE 0.
*        Operation not completed successuflly
          CALL METHOD zabsf_pp_cl_log=>add_message
            EXPORTING
              msgty      = 'E'
              msgno      = '012'
            CHANGING
              return_tab = return_tab.
        ELSE.
*        Operation completed successuflly
          CALL METHOD zabsf_pp_cl_log=>add_message
            EXPORTING
              msgty      = 'S'
              msgno      = '013'
            CHANGING
              return_tab = return_tab.
        ENDIF.
      ELSE.
*      Operation completed successuflly
        CALL METHOD zabsf_pp_cl_log=>add_message
          EXPORTING
            msgty      = 'E'
            msgno      = '018'
          CHANGING
            return_tab = return_tab.
      ENDIF.
    ENDIF.
  ENDIF.

  IF ware_print_st IS NOT INITIAL.

    IF lf_fm_name IS NOT INITIAL.
*    Get defects descritpion
      SELECT *
        FROM zabsf_pp037_t
        INTO CORRESPONDING FIELDS OF TABLE lt_defects_desc
         FOR ALL ENTRIES IN ware_print_st-rework_tab
       WHERE areaid EQ inputobj-areaid
         AND werks EQ inputobj-werks
         AND wareid EQ ware_print_st-wareid
         AND defectid EQ ware_print_st-rework_tab-defectid
         AND spras EQ sy-langu.

      LOOP AT ware_print_st-rework_tab INTO ls_rework.
        CLEAR ls_defects.

*      Get total of rework
        ADD ls_rework-rework TO ld_rework.

*       Read defect description
        READ TABLE lt_defects_desc INTO ls_defects_desc WITH KEY defectid = ls_rework-defectid.

        IF sy-subrc EQ 0.
*        Defect description
          ls_defects-defect_desc = ls_defects_desc-defect_desc.
*        Defect quantity
          ls_defects-rework = ls_rework-rework.

          APPEND ls_defects TO gt_defects.
        ENDIF.
      ENDLOOP.

*    Delivered quantity
      ld_gwemg = ware_print_st-lmnga + ld_rework.

      IF ld_print IS NOT INITIAL.
        ld_output_opt-tddest = ld_print.
      ELSE.
        ld_output_opt-tddest = 'LOCL'.
      ENDIF.

      IF gt_defects[] IS NOT INITIAL.
        ld_output_opt-tdnewid = 'X'.
        ld_output_opt-tdimmed = space.

        ls_control_param-no_dialog = 'X'.

        CALL FUNCTION lf_fm_name
          EXPORTING
            control_parameters = ls_control_param
            output_options     = ld_output_opt
            user_settings      = space
            wareid             = ware_print_st-wareid
            matnr              = ware_print_st-matnr
            gwemg              = ld_gwemg
            lmnga              = ware_print_st-lmnga
            rework             = ld_rework
            pstng_date         = refdt
          TABLES
            gt_defects         = gt_defects
          EXCEPTIONS
            formatting_error   = 1
            internal_error     = 2
            send_error         = 3
            user_canceled      = 4
            OTHERS             = 5.

        IF sy-subrc <> 0.
*    Standard error
          CALL METHOD zabsf_pp_cl_log=>add_message
            EXPORTING
              msgid      = sy-msgid
              msgty      = sy-msgty
              msgno      = sy-msgno
              msgv1      = sy-msgv1
              msgv2      = sy-msgv2
              msgv3      = sy-msgv3
              msgv4      = sy-msgv4
            CHANGING
              return_tab = return_tab.
        ELSE.
*      Operation completed successuflly
          CALL METHOD zabsf_pp_cl_log=>add_message
            EXPORTING
              msgty      = 'S'
              msgno      = '013'
            CHANGING
              return_tab = return_tab.
        ENDIF.
      ENDIF.
    ENDIF.

    IF lf_fm_name_otr IS NOT INITIAL.
*    Delivered quantity
      ld_gwemg = ware_print_st-lmnga.

      IF ld_gwemg IS NOT INITIAL.
        IF ld_print IS NOT INITIAL.
          ld_output_opt-tddest = ld_print.
        ELSE.
          ld_output_opt-tddest = 'LOCL'.
        ENDIF.

        ld_output_opt-tdnewid = 'X'.
        ld_output_opt-tdimmed = space.

        ls_control_param-no_dialog = 'X'.

        CALL FUNCTION lf_fm_name_otr
          EXPORTING
            control_parameters = ls_control_param
            output_options     = ld_output_opt
            user_settings      = space
            wareid             = ware_print_st-wareid
            matnr              = ware_print_st-matnr
            gwemg              = ld_gwemg
            pstng_date         = refdt
          TABLES
            gt_defects         = gt_defects
          EXCEPTIONS
            formatting_error   = 1
            internal_error     = 2
            send_error         = 3
            user_canceled      = 4
            OTHERS             = 5.

        IF sy-subrc <> 0.
*        Standard error
          CALL METHOD zabsf_pp_cl_log=>add_message
            EXPORTING
              msgid      = sy-msgid
              msgty      = sy-msgty
              msgno      = sy-msgno
              msgv1      = sy-msgv1
              msgv2      = sy-msgv2
              msgv3      = sy-msgv3
              msgv4      = sy-msgv4
            CHANGING
              return_tab = return_tab.
        ELSE.
*        Operation completed successuflly
          CALL METHOD zabsf_pp_cl_log=>add_message
            EXPORTING
              msgty      = 'S'
              msgno      = '013'
            CHANGING
              return_tab = return_tab.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
ENDMETHOD.


METHOD zif_absf_pp_print~print_first_cycle.
**  Structures
*    DATA: ls_r_areaid TYPE /iwbep/s_sel_opt.
*
**  Range
*    DATA: r_areaid TYPE TABLE OF /iwbep/s_sel_opt.
*
**  Variables
*    DATA: l_first_cycle       TYPE boole_d,
*          l_second_cycle      TYPE boole_d,
*          l_molde_id          TYPE equnr,
*          l_molde_desc        TYPE ktx01,
*          l_aufnr             TYPE aufnr,
*          l_sysubrc           LIKE sy-subrc,
*          l_langu             TYPE spras,
*          l_date_external(10).
*
**  Constants
*    CONSTANTS: c_objty      TYPE cr_objty       VALUE 'A', "Work center
*               c_userfields TYPE slwid          VALUE 'ZELAST',
*               c_param_name TYPE zabsf_pp_e_parid VALUE 'PP_LABEL'.
*
**  Translate to upper case
*    TRANSLATE  inputobj-oprid TO UPPER CASE.
*
**  Set local language for user
*    l_langu = sy-langu.
*
*    SET LOCALE LANGUAGE l_langu.
*
**  Convert date to external
*    CALL FUNCTION 'CONVERT_DATE_TO_EXTERNAL'
*      EXPORTING
*        date_internal            = sy-datum
*      IMPORTING
*        date_external            = l_date_external
*      EXCEPTIONS
*        date_internal_is_invalid = 1
*        OTHERS                   = 2.
*    IF sy-subrc <> 0.
*    ENDIF.
*
**  Fields for first or second cycle
*    IF arbpl_print_st IS NOT INITIAL.
*      IF arbpl_print_st-first_cycle EQ abap_true.
*        l_first_cycle = abap_true.
*        l_second_cycle = abap_false.
*      ELSE.
*        l_first_cycle = abap_false.
*        l_second_cycle = abap_false.
*      ENDIF.
*
**    Get PP Label ID
*      SELECT SINGLE parva
*        FROM zabsf_pp032
*        INTO (@DATA(l_pp_label))
*       WHERE werks EQ @inputobj-werks
*         AND parid EQ @c_param_name.
*
*      IF l_pp_label IS INITIAL.
**      Send message erro: Missing customization
*        CALL METHOD zcl_lp_pp_sf_log=>add_message
*          EXPORTING
*            msgty      = 'E'
*            msgno      = '077'
*          CHANGING
*            return_tab = return_tab.
*
*        EXIT.
*      ENDIF.
*
**    Get form
*      SELECT SINGLE formname_label
*        FROM zabsf_pplabels
*        INTO (@DATA(l_formname))
*       WHERE code_label EQ @l_pp_label.
*
**>>PAP 10.10.2016 14:30:47
*      IF inputobj-areaid IS INITIAL.
**      Get hierarchy of Work center
*        SELECT crhs~objty_hy, crhs~objid_hy
*          FROM crhs AS crhs
*         INNER JOIN crhd AS crhd
*            ON crhd~objty EQ crhs~objty_ho
*           AND crhd~objid EQ crhs~objid_ho
*         WHERE crhd~objty EQ @c_objty
*           AND crhd~arbpl EQ @arbpl_print_st-arbpl
*           AND crhd~begda LT @sy-datum
*           AND crhd~endda GT @sy-datum
*           AND crhd~werks EQ @inputobj-werks
*          INTO TABLE @DATA(lt_crhs).
*
*        IF lt_crhs[] IS NOT INITIAL.
**        Get hierarchy name
*          SELECT name
*            FROM crhh
*            INTO TABLE @DATA(lt_crhh)
*             FOR ALL ENTRIES IN @lt_crhs
*           WHERE objty EQ @lt_crhs-objty_hy
*             AND objid EQ @lt_crhs-objid_hy.
*
*          IF lt_crhh[] IS NOT INITIAL.
**          Get area ID
*            SELECT DISTINCT areaid
*              FROM zabsf_pp002
*              INTO TABLE @DATA(lt_pp_sf002)
*               FOR ALL ENTRIES IN @lt_crhh
*             WHERE werks   EQ @inputobj-werks
*               AND hname   EQ @lt_crhh-name
*               AND endda   GT @sy-datum
*               AND begda   LT @sy-datum.
*
*            LOOP AT lt_pp_sf002 INTO DATA(ls_pp_sf002).
*              CLEAR ls_r_areaid.
*              ls_r_areaid-sign = 'I'.
*              ls_r_areaid-opt = 'EQ'.
*              ls_r_areaid-low = ls_pp_sf002-areaid.
*
*              APPEND ls_r_areaid TO r_areaid.
*            ENDLOOP.
*          ENDIF.
*        ENDIF.
*      ELSE.
*        CLEAR ls_r_areaid.
*        ls_r_areaid-sign = 'I'.
*        ls_r_areaid-opt = 'EQ'.
*        ls_r_areaid-low = inputobj-areaid.
*
*        APPEND ls_r_areaid TO r_areaid.
*      ENDIF.
**<<PAP 10.10.2016 14:30:47
*
**    Get printer
*      SELECT SINGLE impr_out
*        FROM zabsf_pp033
*        INTO (@DATA(l_printer))
*       WHERE areaid IN @r_areaid
*         AND werks  EQ @inputobj-werks
*         AND arbpl  EQ @arbpl_print_st-arbpl
*         AND sform  EQ @l_formname.
*
*      IF sy-subrc NE 0.
**      Send message error: Missing printer customization
*        CALL METHOD zabsf_pp_cl_log=>add_message
*          EXPORTING
*            msgty      = 'E'
*            msgno      = '078'
*            msgv1      = arbpl_print_st-arbpl
*          CHANGING
*            return_tab = return_tab.
*
*        EXIT.
*      ENDIF.
*
***    Check if batch is initial
**      IF batch IS INITIAL.
***      Get batch
**        SELECT SINGLE batch
**          FROM ZABSF_PP066
**          INTO (@DATA(l_charg))
**         WHERE werks EQ @inputobj-werks
**           AND aufnr EQ @arbpl_print_st-aufnr
**           AND vornr EQ @arbpl_print_st-vornr.
**
**      ELSE.
***      Convert to internal format: Batch
**        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
**          EXPORTING
**            input  = batch
**          IMPORTING
**            output = l_charg.
**      ENDIF.
*
***    Get quantity for box
**      IF l_charg IS NOT INITIAL.
**        SELECT SINGLE *
**          FROM afpo
**          INTO @DATA(ls_afpo)
**         WHERE aufnr EQ @arbpl_print_st-aufnr.
**
**        IF ls_afpo IS NOT INITIAL.
***        Get stock quantity
**          SELECT SINGLE clabs, cinsm
**            FROM mchb
**            INTO (@DATA(l_clabs), @DATA(l_cinsm))
**           WHERE matnr EQ @arbpl_print_st-matnr
**             AND werks EQ @inputobj-werks
**             AND lgort EQ @ls_afpo-lgort
**             AND charg EQ @l_charg.
**
***        Stock quantity
**          DATA(l_box_qtt) = l_clabs + l_cinsm + erfmg.
**        ENDIF.
**
**        IF l_box_qtt IS INITIAL.
***        Stock - Quantity in movement
**          ADD erfmg TO l_box_qtt.
**        ENDIF.
**      ENDIF.
*
**    Get routing number
*      SELECT SINGLE aufpl
*        FROM afko
*        INTO (@DATA(l_aufpl))
*       WHERE aufnr EQ @arbpl_print_st-aufnr.
*
**    Get routing operation
*      SELECT SINGLE aplzl
*        FROM afvc
*        INTO (@DATA(l_aplzl))
*       WHERE aufpl EQ @l_aufpl
*         AND vornr EQ @arbpl_print_st-vornr.
*
**    Get molde
*      CALL FUNCTION 'Z_PP02_GET_MOULD'
*        EXPORTING
*          iv_aufpl = l_aufpl
*          iv_aplzl = l_aplzl
*          iv_werks = inputobj-werks
*        IMPORTING
*          ev_equnr = l_molde_id
*          ev_eqktx = l_molde_desc.
*
**    Get next operation
*      SELECT  SINGLE usr00
*        FROM afvu
*        INTO (@DATA(l_next_operation))
*       WHERE aufpl EQ @l_aufpl
*         AND aplzl EQ @l_aplzl
*         AND slwid EQ @c_userfields.
*
**    Get shift from z table
*      SELECT SINGLE shiftid
*        FROM zabsf_pp052
*        INTO (@DATA(l_shift))
*       WHERE areaid EQ @inputobj-areaid
*         AND oprid  EQ @inputobj-oprid.
*
**    Get order type.
*      SELECT SINGLE auart
*        FROM aufk
*        INTO (@DATA(l_auart))
*       WHERE aufnr EQ @arbpl_print_st-aufnr.
*
**    Convert to output format
*      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
*        EXPORTING
*          input  = arbpl_print_st-aufnr
*        IMPORTING
*          output = l_aufnr.
*
**    Submit print program
*      SUBMIT  zge02_print_labels
*        WITH p_codlab = l_pp_label
*        WITH p_prewin = abap_true
*        WITH p_printr = l_printer
**        WITH p_charg  = l_charg
*        WITH p_first  = l_first_cycle
*        WITH p_second = l_second_cycle
*        WITH p_matnr  = arbpl_print_st-matnr
**        WITH p_menge  = l_box_qtt
*        WITH p_mould  = l_molde_id
*        WITH p_manudt = l_date_external
*        WITH p_oefnum = arbpl_print_st-aufnr "PP order number
*        WITH p_shift  = l_shift
*        WITH p_operat = inputobj-oprid
*        WITH p_oeftyp = l_auart "PP order type
*        WITH p_nextop = l_next_operation
*      AND RETURN.
*
**    Import to memory
*      IMPORT lv_sysubrc = l_sysubrc FROM MEMORY ID 'zprint_sy-subrc'.
*
*      IF l_sysubrc NE 0.
**      Send error message
*        CALL METHOD zabsf_pp_cl_log=>add_message
*          EXPORTING
*            msgty      = 'E'
*            msgno      = '074'
*          CHANGING
*            return_tab = return_tab.
*
*      ELSE.
**      Send success message
*        CALL METHOD zabsf_pp_cl_log=>add_message
*          EXPORTING
*            msgty      = 'S'
*            msgno      = '013'
*          CHANGING
*            return_tab = return_tab.
*      ENDIF.
*    ELSE.
**    Send message error: Mandatory fields submit
*      CALL METHOD zabsf_pp_cl_log=>add_message
*        EXPORTING
*          msgty      = 'E'
*          msgno      = '076'
*        CHANGING
*          return_tab = return_tab.
*    ENDIF.
  ENDMETHOD.


method zif_absf_pp_print~print_pp_label.


  endmethod.
ENDCLASS.
