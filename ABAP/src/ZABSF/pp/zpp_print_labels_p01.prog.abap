*&---------------------------------------------------------------------*
*& Report ZPP_PRINT_LABELS_P01
*&---------------------------------------------------------------------*
*&Criado por: Bruno Ribeiro @ Abaco Consulting
*&DATA:       31.03.2020
*&Descrição: Impressão de etiquetas
*&---------------------------------------------------------------------*~
class gcl_print_label implementation.
  method constructor.
    "limpar variáveis globais
    clear: gv_ppreview_var, gv_language_var,
           gv_oprinter_var, gv_nmcopies_var.
    "mapear variáveis de entrada
    gv_language_var = im_p_langug_var.
    gv_ppreview_var = im_p_previw_var.
    gv_oprinter_var = im_p_printr_var.
    gv_nmcopies_var = im_p_copies_var.
  endmethod.
  method process_execute.
    try.
        "verficar se label existe
        check_label_existence( exporting
                                 im_aufnrval_var = im_aufnrval_var
                                 im_batchval_var = im_batchval_var
                                 im_material_var = im_material_var
                                 im_projtpep_var = im_projtpep_var
                                 im_qtt_unit_var = im_qtt_unit_var
                                 im_so_numbr_tab = im_so_numbr_tab ).

        "criar tabela de etiquetas
        zabsf_pp_cl_print=>get_production_labels_data( exporting
                                                         im_aufnrval_var = im_aufnrval_var
                                                         im_batchval_var = im_batchval_var
                                                         im_material_var = im_material_var
                                                         im_matndesc_var = im_matndesc_var
                                                         im_projtpep_var = im_projtpep_var
                                                         im_quantity_var = im_quantity_var
                                                         im_qtt_unit_var = im_qtt_unit_var
                                                         im_confirmt_var = im_confirmt_var
                                                         im_confcont_var = im_confcont_var
                                                         im_sequence_var = im_sequence_var
                                                         im_so_numbr_tab = im_so_numbr_tab
                                                         im_shopflor_var = im_shopflor_var
                                                       importing
                                                         ex_tblabels_tab = data(lt_tblabels_tab) ).
*
        "imprimir etiqueta
        print_labels( exporting
                        im_tblabels_tab = lt_tblabels_tab
                        im_aufnrval_var = im_aufnrval_var ).
      catch zcx_bc_exceptions into data(lo_excption_obj).
        "lançar exceção
        raise exception type zcx_bc_exceptions
          exporting
            msgty = lo_excption_obj->msgty
            msgid = lo_excption_obj->msgid
            msgno = lo_excption_obj->msgno
            msgv1 = lo_excption_obj->msgv1
            msgv2 = lo_excption_obj->msgv2
            msgv3 = lo_excption_obj->msgv3
            msgv4 = lo_excption_obj->msgv4.
    endtry.
  endmethod.
  method print_labels.
    "constantes locais
    constants: lc_finshgod_cst type tdsfname value 'ZPP_PROD_LABEL',
               lc_semifinh_cst type tdsfname value 'ZPP_PROD_LABEL_SA',
               lc_ordrzpp3_cst type auart    value 'ZPP3',
               lc_ordrzpp2_cst type auart    value 'ZPP2'.

    "variáveis locais
    data: lv_funcname_var type rs38l_fnam,
          ls_ctrparam_str type ssfctrlop,
          ls_soutputs_str type ssfcompop,
          lv_formname_var type tdsfname.

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
      raise exception type zcx_bc_exceptions
        exporting
          msgty = sy-abcde+4(1)
          msgid = 'ZABSF_PP'
          msgno = '153'
          msgv1 = conv #( im_aufnrval_var ).
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
      raise exception type zcx_bc_exceptions
        exporting
          msgty = sy-abcde+4(1)
          msgid = 'ZABSF_PP'
          msgno = '131'.
    endif.

    "opções de output
    ls_soutputs_str-tddest   = gv_oprinter_var.
    ls_soutputs_str-tdnewid  = abap_true.
    ls_soutputs_str-tdimmed  = abap_true.
    ls_soutputs_str-tdnoprev = cond #( when gv_ppreview_var ne abap_true
                                       then abap_true ).
    ls_soutputs_str-tdcopies = gv_nmcopies_var.

    if sy-batch eq abap_true.
      ls_ctrparam_str-no_dialog = abap_true.
    endif.
    ls_ctrparam_str-no_open   = abap_true.
    ls_ctrparam_str-no_close  = abap_true.
    ls_ctrparam_str-langu     = gv_language_var.
    ls_ctrparam_str-replangu1 = gv_language_var.
    ls_soutputs_str-tdnewid   = abap_true.

*    "teste email
*    ls_ctrparam_str-getotf = abap_true.
*    ls_ctrparam_str-no_dialog = abap_true.
*    ls_soutputs_str-tdnoprev = abap_true.

    data: gv_binfilesize     type so_obj_len,
          gv_pdf_xstring     type xstring,
          st_job_output_info type ssfcrescl,
          gt_otfdata         type table of itcoo,
          gt_pdftab          type table of tline.

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
      raise exception type zcx_bc_exceptions
        exporting
          msgty = sy-abcde+4(1)
          msgid = 'ZABSF_PP'
          msgno = '130'.
    endif.
    "percorrer todas as labels
    loop at im_tblabels_tab into data(ls_strlabel_str).

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
      append lines of st_job_output_info-otfdata[] to  gt_otfdata[].
      refresh st_job_output_info-otfdata[].

      ls_soutputs_str-tdnewid = abap_false.
    endloop.

    "encerrar formulário
    call function 'SSF_CLOSE'
      exceptions
        formatting_error = 1
        internal_error   = 2
        send_error       = 3
        others           = 4.
    if sy-subrc ne 0.
      "Erro ao encerrar o formulário
      raise exception type zcx_bc_exceptions
        exporting
          msgty = sy-abcde+4(1)
          msgid = 'ZABSF_PP'
          msgno = '132'.
    endif.
  endmethod.
  "obter configuração
  method check_label_existence.
    data: lv_raiserrr_var type flag,
          lt_etiqrang_rng type range of int4.

    "conversão de valores
    lt_etiqrang_rng = im_so_numbr_tab[].

    if line_exists( lt_etiqrang_rng[ 1 ] ).
      data(ls_so_numbr_str) = lt_etiqrang_rng[ 1 ].
      if ls_so_numbr_str-low is initial
        or ls_so_numbr_str-high is initial.
        lv_raiserrr_var = abap_true.
      endif.
    else.
      lv_raiserrr_var = abap_true.
    endif.
    if lv_raiserrr_var eq abap_true.
      "Obrigatório indicar numeração da etiqueta
      raise exception type zcx_bc_exceptions
        exporting
          msgty = sy-abcde+4(1)
          msgid = 'ZABSF_PP'
          msgno = '136'.
    endif.

    "verificar se etiqueta existe
*    select single *
*      from zpp_labels_t
*      into @data(ls_labelchc_str)
*        where aufnr eq @im_aufnrval_var
*          and matnr eq @im_material_var
*          and charg eq @im_batchval_var
*          and menge eq @im_quantity_var.
*    if sy-subrc ne 0.
*      "Nenhuma etiqueta encontrada para os critérios indicados
*      raise exception type zcx_bc_exceptions
*        exporting
*          msgty = sy-abcde+4(1)
*          msgid = 'ZABSF_PP'
*          msgno = '133'.
*    endif.
  endmethod.
  "criar tabela de labels
  method create_labels_table.
    "constantes locais
*    constants: lc_multimat_cst type aufart value 'ZPP3'.
*    "variáveis locais
*    data: lv_etiqcout_var type int4 value 1,
*          lv_totaletq_var type int4,
*          lv_cycleint_var type int4,
*          lt_etiqrang_rng type range of int4,
*          lt_aufktext_tab type table of tline,
*          lr_charname_rng type range of atnam,
*          lv_chartipo_var type atnam,
*          lv_chardim1_var type atnam,
*          lv_characab_var type atnam,
*          lv_matdescr_var type atwrt,
*          lv_charplan_var type atnam,
*          lv_operador_var type atnam,
*          lv_operlist_var type string,
*          lv_operlabl_var type zpp_prod_label_s-soldador.
*    "limpara variáveis locais
*    refresh: ex_tblabels_tab.
*    "obter centro da ordem de produção
*    select single werks, auart
*      from aufk
*      into ( @data(lv_werksval_var), @data(lv_ordertyp_var) )
*        where aufnr eq @im_aufnrval_var.
*    if sy-subrc  ne 0.
*      "sair do processamento
*      return.
*    endif.
*    "obter caracteristicas relevantes
*    try.
*        "nome
*        zcl_bc_fixed_values=>get_ranges_value( exporting
*                                                 im_paramter_var = zcl_bc_fixed_values=>gc_charname_cst
*                                                 im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
*                                               importing
*                                                 ex_valrange_tab = lr_charname_rng ).
*        "tipologia
*        zcl_bc_fixed_values=>get_single_value( exporting
*                                                 im_paramter_var = zcl_bc_fixed_values=>gc_chartipo_cst
*                                                 im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
*                                               importing
*                                                 ex_prmvalue_var = data(lv_valuechr_var) ).
*        "conversão de formatos
*        lv_chartipo_var = lv_valuechr_var.
*
*        "dim1
*        zcl_bc_fixed_values=>get_single_value( exporting
*                                                 im_paramter_var = zcl_bc_fixed_values=>gc_chardim1_cst
*                                                 im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
*                                               importing
*                                                 ex_prmvalue_var = lv_valuechr_var ).
*        "conversão de formatos
*        lv_chardim1_var = lv_valuechr_var.
*
*        "acabamento
*        zcl_bc_fixed_values=>get_single_value( exporting
*                                                 im_paramter_var = zcl_bc_fixed_values=>gc_characab_cst
*                                                 im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
*                                               importing
*                                                 ex_prmvalue_var = lv_valuechr_var ).
*        "conversão de formatos
*        lv_characab_var = lv_valuechr_var.
*
*        "caracteristica plano de fabrico
*        zcl_bc_fixed_values=>get_single_value( exporting
*                                                 im_paramter_var = zcl_bc_fixed_values=>gc_charplan_cst
*                                                 im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
*                                                 im_werksval_var = lv_werksval_var
*                                               importing
*                                                 ex_prmvalue_var = lv_valuechr_var ).
*        lv_charplan_var = lv_valuechr_var.
*
*        "carcateristica com os operadores
*        zcl_bc_fixed_values=>get_single_value( exporting
*                                         im_paramter_var = zcl_bc_fixed_values=>gc_charopers_cst
*                                         im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
*                                       importing
*                                         ex_prmvalue_var = lv_valuechr_var ).
*
*        lv_operador_var = lv_valuechr_var.
*      catch zcx_bc_exceptions into data(lo_excprtion_obj).
*        "lançar excepção
*        raise exception type zcx_bc_exceptions
*          exporting
*            msgty = lo_excprtion_obj->msgty
*            msgid = lo_excprtion_obj->msgid
*            msgno = lo_excprtion_obj->msgno
*            msgv1 = lo_excprtion_obj->msgv1
*            msgv2 = lo_excprtion_obj->msgv2
*            msgv3 = lo_excprtion_obj->msgv3
*            msgv4 = lo_excprtion_obj->msgv4.
*    endtry.
*
*    "conversão de valores
*    lt_etiqrang_rng = im_so_numbr_tab.
*    "etiqueta incial
*    lv_etiqcout_var = lt_etiqrang_rng[ 1 ]-low.
*    "etiqueta final
*    lv_totaletq_var = lt_etiqrang_rng[ 1 ]-high.
*    "contador de cycle
*    if im_sequence_var eq abap_true.
*      if im_quantity_var is not initial.
*        "imprime n etiquetas
*        lv_cycleint_var = im_quantity_var.
*      else.
*        lv_cycleint_var = 1 + ( lv_totaletq_var - lv_etiqcout_var ).
*      endif.
*    else.
*      lv_cycleint_var = 1.
*    endif.
*    "obter PEP da ordem
*    select single projn
*      from afpo
*      into @data(lv_pepelemt_var)
*        where aufnr eq @im_aufnrval_var
*          and projn ne @abap_false.
*    "criar n etiquetas
*    do lv_cycleint_var times.
*      "obter caracteristicas do lote
*      if im_batchval_var is not initial.
*        "obter material do lote
*        select single matnr
*          from mcha
*          into @data(lv_material_var)
*            where charg eq @im_batchval_var
*              and werks eq @lv_werksval_var.
*        "ler caracteristicas do lote
*        zcl_mm_classification=>get_classification_by_batch( exporting
*                                                              im_material_var       = lv_material_var
*                                                              im_lote_var           = im_batchval_var
*                                                              importing
*                                                              ex_classification_tab = data(lt_characts_tab) ).
*        "obter operadores da ordem
*        loop at lt_characts_tab into data(ls_characts_str)
*          where atnam eq lv_operador_var.
*          "concatenar operadores
*          lv_operlist_var = |{ lv_operlist_var } { ls_characts_str-ausp1 }|.
*          clear ls_characts_str.
*        endloop.
*        condense lv_operlist_var.
*        move lv_operlist_var to lv_operlabl_var.
*        clear lv_operlist_var.
*      endif.
*      "descrição material a partir do lote
*      loop at lt_characts_tab into ls_characts_str
*        where atnam in lr_charname_rng
*          and ausp1 is not initial.
*        "descrição do material
*        lv_matdescr_var = ls_characts_str-ausp1.
*        "sair do loop
*        exit.
*      endloop.
*      "descrição o material a partir da ordem
*      if lv_matdescr_var is initial.
*        select single cuobj
*          from afpo
*          into @data(lv_cuobj_var)
*           where aufnr eq @im_aufnrval_var.
*        "read data from classification
*        zcl_mm_classification=>get_material_desc_by_object( exporting
*                                                              im_cuobj_var       = lv_cuobj_var
*                                                            importing
*                                                              ex_description_var = lv_matdescr_var ).
*      endif.
*      "impressão via shopfloor
*      if p_shopf ne abap_true and im_matndesc_var is not initial.
*        "validar material
*        if lv_matdescr_var ne im_matndesc_var.
*          "Material &1 não associado à ordem de produção &2
*          raise exception type zcx_bc_exceptions
*            exporting
*              msgty = sy-abcde+4(1)
*              msgid = 'ZABSF_PP'
*              msgv1 = conv #( lv_matdescr_var )
*              msgv2 = conv #( im_aufnrval_var )
*              msgno = '137'.
*        endif.
*      endif.
*      if lv_ordertyp_var eq lc_multimat_cst.
*        "obter plano de fabrico
*        read table lt_characts_tab into data(ls_charact_str) with key atnam = lv_charplan_var.
*        if sy-subrc eq 0.
*          data(lv_prodplan_var) = ls_charact_str-ausp1.
*        endif.
*      else.
*        if im_batchval_var is initial.
*          "obter operadores a partir da confirmação
*          select *
*            from zabsf_pp065
*            into table @data(lt_operators_tab)
*              where conf_no  eq @im_confirmt_var
*                and conf_cnt eq @im_confcont_var.
*          "percorrer lista de operadores
*          loop at lt_operators_tab into data(ls_operators_str).
*            "concatenar operadores
*            lv_operlist_var = |{ lv_operlist_var } { ls_operators_str-oprid }|.
*            clear ls_characts_str.
*          endloop.
*          condense lv_operlist_var.
*          "truncar a 40
*          move lv_operlist_var to lv_operlabl_var.
*        endif.
*        "plano fabrico
*        call method zcl_mm_classification=>get_classification_config
*          exporting
*            im_instance_cuobj_var = lv_cuobj_var
*          importing
*            ex_classfication_tab  = data(lt_classfic_tab)
*          exceptions
*            instance_not_found    = 1
*            others                = 2.
*        if sy-subrc <> 0.
*        endif.
*        "plano de fabrico
*        lv_prodplan_var = cond #( when line_exists( lt_classfic_tab[ atnam = lv_charplan_var ] )
*                                  then lt_classfic_tab[ atnam = lv_charplan_var ]-atwrt ).
*      endif.
*      "dados da etiqueta
*      append value #( aufnr   = im_aufnrval_var
*                      batch   = |{ im_batchval_var alpha = out }|
*                      matnr   = lv_material_var
*                      maktx   = lv_matdescr_var
*                      pspnr   = lv_pepelemt_var
*                      counter = lv_etiqcout_var
*                      total   = lv_totaletq_var
*                      meins   = im_qtt_unit_var
*                      bzy_pf  = lv_prodplan_var
*                      rueck   = im_confirmt_var
*                      menge   = '1' "uma unidade
*                      rmzhl   = im_confcont_var
*                      zbyaca  = cond #( when line_exists( lt_characts_tab[ atnam = lv_characab_var ] )
*                                        then lt_characts_tab[ atnam = lv_characab_var ]-ausp1 )
*                      werks   = lv_werksval_var
*                      tipologia = cond #( when line_exists( lt_characts_tab[ atnam = lv_chartipo_var ] )
*                                          then lt_characts_tab[ atnam = lv_chartipo_var ]-ausp1 )
*                      dim1     = cond #( when line_exists( lt_characts_tab[ atnam = lv_chardim1_var ] )
*                                         then lt_characts_tab[ atnam = lv_chardim1_var ]-ausp1 )
*                      soldador = lv_operlabl_var ) to ex_tblabels_tab.
*      "incrementar contador
*      lv_etiqcout_var = 1 + lv_etiqcout_var.
*      "limpar variáveis
*      clear lv_operlabl_var.
*    enddo.
  endmethod.
endclass.
