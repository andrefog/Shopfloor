class ZABSF_PP_CL_TRACKING definition
  public
  final
  create public .

public section.

  class-methods CALCULATE_NUMBER_OF_BATCHES
    importing
      !IM_QUANTITY_VAR type MENGE_D
      !IM_QTTYUNIT_VAR type MEINS
      !IM_BACTHNUM_VAR type CHARG_D
      !IM_MATERIAL_VAR type MATNR
    exporting
      !ET_RETURN_TAB type BAPIRET2_T
      !EX_NUMBER_BATCHES_VAR type INT4 .
  class-methods GET_NEXT_BATCH_NUMBERS
    importing
      !IM_QUANTITY_VAR type NRQUAN
      !IM_SKIPSEQ_VAR type FLAG optional
    exporting
      !EX_BATCHNUM_TAB type ZABSF_MOB_TT_NEW_BATCH
      !EX_ERRORFLAG_VAR type FLAG
      !ET_RETURN_TAB type BAPIRET2_T .
  class-methods GET_NEXT_SEQUENCE_NUMBER
    exporting
      !EX_ERRORFLAG_VAR type FLAG
      !EX_SEQUENCER_VAR type ZABSF_PP_E_SEQ
      !ET_RETURN_TAB type BAPIRET2_T .
  class-methods UPDATE_SEQUENCE_TABLE
    importing
      !IM_NEWBATCH_TAB type ZABSF_MOB_TT_NEW_BATCH
      !IM_OPRIDVAL_VAR type ZABSF_MOB_E_OPRID
      !IM_DOCUMENT_VAR type MBLNR
      !IM_RETBATCH_VAR type CHARG_D optional
      !IM_SEQLANTK_VAR type ZABSF_PP_E_SEQ_LANTEK optional .
  class-methods CREATE_BATCH
    importing
      !IM_REFBATCH_VAR type CHARG_D
      !IM_REFMATNR_VAR type MATNR
      !IM_REFWERKS_VAR type WERKS_D
      !IT_CHARACTS_TAB type ZABSF_MOB_TT_BATCH_CHARACT
    exporting
      !ET_RETURN_TAB type BAPIRET2_T
      !EX_NEWBATCH_VAR type CHARG_D
      !EX_ERROR_VAR type FLAG .
  class-methods CONVERT_CHAR_VALUE_TO_INTERNAL
    importing
      !IM_ATNAM_VAR type ATNAM
      value(IM_ATWRT_VAR) type ATWRT
    exporting
      !EX_VALFROM_VAR type ATFLV
      !EX_VALUETO_VAR type ATFLB
      !EX_VALUERL_VAR type ATCOD
      !ET_RETURN_TAB type BAPIRET2_T .
  class-methods CONVERT_TO_UNITS
    importing
      !IM_QUANTITY_VAR type MENGE_D
      !IM_QTTYUNIT_VAR type MEINS
      !IM_MATERIAL_VAR type MATNR
      !IM_BATCHNUM_VAR type CHARG_D
      !IM_RAISE_ERROR_VAR type BOOLE_D optional
    exporting
      !EX_UNITS_VAR type INT4
      !ET_RETURN_TAB type BAPIRET2_T .
  class-methods COPY_CHARS_TO_NEW_BATCH
    importing
      !IT_CHARSTAB_TAB type ZABSF_PP_TT_BATCH_CHARACT
      !IM_NEWBATCH_VAR type CHARG_D
      !IM_MATERIAL_VAR type MATNR
    exporting
      !EX_RETURN_TAB type BAPIRET2_T .
  class-methods CONVERT_TO_MEINS
    importing
      !IM_QTTYUNIT_VAR type INT4
      !IM_MEINS_VAR type MEINS
      !IM_MATERIAL_VAR type MATNR
      !IM_BATCHNUM_VAR type CHARG_D
    exporting
      !EX_QUANTITY_VAR type MENGE_D
      !ET_RETURN_TAB type BAPIRET2_T .
protected section.
private section.
ENDCLASS.



CLASS ZABSF_PP_CL_TRACKING IMPLEMENTATION.


  method calculate_number_of_batches.
    "converter para unidades
    zabsf_pp_cl_tracking=>convert_to_units( exporting
                                              im_quantity_var    = im_quantity_var
                                              im_qttyunit_var    = im_qttyunit_var
                                              im_material_var    = im_material_var
                                              im_batchnum_var    = im_bacthnum_var
                                              im_raise_error_var = abap_true
                                            importing
                                              ex_units_var       = ex_number_batches_var
                                              et_return_tab      = et_return_tab ).
    "verificar se determinou nº de lotes
    if ex_number_batches_var is initial.
      "Erro ao converter &1 para nº de lotes
      call method zabsf_mob_cl_log=>add_message
        exporting
          msgty      = 'E'
          msgno      = '007'
*         msgv1      = conv #( im_qttyunit_var )
          msgv1      = im_qttyunit_var
        changing
          return_tab = et_return_tab.
    endif.
  endmethod.


  method convert_char_value_to_internal.
    "variáveis locais
    data: charactname    type  bapicharactkey-charactname,
          value_from     type  atflv,
          value_to       type  atflb,
          value_relation type  atcod,
          charactdetail  type  bapicharactdetail,
          external       type charactname,
          l_ret          type table of bapiret2.

    "limpar variáveis de exportação
    clear: ex_valfrom_var, ex_valueto_var, ex_valuerl_var.
    refresh: et_return_tab.
    "obter detalhe
    call function 'BAPI_CHARACT_GETDETAIL'
      exporting
        charactname   = im_atnam_var
        language      = sy-langu
      importing
        charactdetail = charactdetail
      tables
        return        = l_ret.
    if charactdetail is initial.
      "sair do processamento
      return.
    endif.

    if charactdetail-data_type eq 'NUM'
    or charactdetail-data_type eq 'CURR'.
      "converter para valor externo
      call function 'CTBP_CONVERT_VALUE_EXT_TO_INT'
        exporting
          value_external    = im_atwrt_var
          charactdetail     = charactdetail
        importing
          value_from        = ex_valfrom_var
          value_to          = ex_valueto_var
          value_relation    = ex_valuerl_var
        exceptions
          no_authority      = 1
          charact_not_found = 2
          wrong_data_type   = 3
          wrong_value       = 4
          wrong_input       = 5
          others            = 6.
      if sy-subrc <> 0.
        "mensagem de erro
        call method zabsf_mob_cl_log=>add_message
          exporting
            msgid      = sy-msgid
            msgty      = sy-msgty
            msgno      = sy-msgno
            msgv1      = sy-msgv1
            msgv2      = sy-msgv1
            msgv3      = sy-msgv1
            msgv4      = sy-msgv1
          changing
            return_tab = et_return_tab.
      endif.
    endif.
  endmethod.


  method convert_to_meins.
    "variáveis locais
    data: lr_charmetr_rng  type range of atnam,
          lr_charconv_rng  type range of atnam,
          lr_char_m2_rng   type range of atnam,
          lv_conv_aux      type p decimals 3,
          lv_remaining_var type i.
    "limpar variáveis de exportação
    clear ex_quantity_var.
    refresh et_return_tab.
    "obter configuração
    try.
        "conversão KG para unidade
        zcl_bc_fixed_values=>get_ranges_value( exporting
                                                 im_paramter_var = zcl_bc_fixed_values=>gc_char_und_conv_cst
                                                 im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
                                               importing
                                                 ex_valrange_tab = lr_charconv_rng ).
        "conversão M para unidade
        zcl_bc_fixed_values=>get_ranges_value( exporting
                                                 im_paramter_var = zcl_bc_fixed_values=>gc_meter2unit_cst
                                                 im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
                                               importing
                                                 ex_valrange_tab = lr_charmetr_rng  ).
        "conversão m2 para unidade
        zcl_bc_fixed_values=>get_ranges_value( exporting
                                                 im_paramter_var = zcl_bc_fixed_values=>gc_charsquare_cst
                                                 im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
                                               importing
                                                 ex_valrange_tab = lr_char_m2_rng   ).

      catch zcx_bc_exceptions into data(lo_bcexceptions_obj).
        call method zabsf_mob_cl_log=>add_message
          exporting
            msgty      = lo_bcexceptions_obj->msgty
            msgno      = lo_bcexceptions_obj->msgno
            msgid      = lo_bcexceptions_obj->msgid
            msgv1      = lo_bcexceptions_obj->msgv1
            msgv2      = lo_bcexceptions_obj->msgv2
            msgv3      = lo_bcexceptions_obj->msgv3
            msgv4      = lo_bcexceptions_obj->msgv4
          changing
            return_tab = et_return_tab.
        return.
    endtry.

    "obter classificação do lote original
    zcl_mm_classification=>get_classification_by_batch( exporting
                                                          im_material_var       = im_material_var
                                                          im_lote_var           = im_batchnum_var
                                                        importing
                                                          ex_classification_tab = data(lt_characts_tab) ).

    "obter conversão unidades/ Kgs
    loop at lt_characts_tab into data(ls_characts_str)
      where atnam in lr_charconv_rng
        and ausp1 is not initial.
      "conversão de unidades
      data(lv_char_conv_var) = ls_characts_str-atflv.
      "sair do loop
      exit.
    endloop.

    "obter conversão unidades/ metros
    loop at lt_characts_tab into ls_characts_str
      where atnam in lr_charmetr_rng
        and ausp1 is not initial.
      "conversão de unidades
      data(lv_char_meter_var) = ls_characts_str-atflv.
      "sair do loop
      exit.
    endloop.

    "obter conversão unidades/ m2
    loop at lt_characts_tab into ls_characts_str
      where atnam in lr_char_m2_rng
        and ausp1 is not initial.
      "conversão de unidades
      data(lv_char_square_var) = ls_characts_str-atflv.
      "sair do loop
      exit.
    endloop.

    case im_meins_var.
      when 'UN'.
        ex_quantity_var = conv #( im_qttyunit_var ).
      when 'KG'.
        "conversão de formatos
        lv_conv_aux = lv_char_conv_var.
        ex_quantity_var  = im_qttyunit_var * lv_conv_aux.
      when 'M'.
        "conversão de formatos
        lv_conv_aux = lv_char_meter_var.
        ex_quantity_var  = im_qttyunit_var * lv_conv_aux.
      when 'M2'.
        "conversão de formatos
        lv_conv_aux = lv_char_square_var.
        ex_quantity_var  = im_qttyunit_var * lv_conv_aux.
      when  others.
        "Unidade &1 sem conversão para unidades
        call method zabsf_mob_cl_log=>add_message
          exporting
            msgty      = 'E'
            msgno      = '006'
*           msgv1      = conv #( im_qttyunit_var )
            msgv1      = im_qttyunit_var
          changing
            return_tab = et_return_tab.
        "sair do processamento
        return.
    endcase.

    if ex_quantity_var is initial.
      "Erro ao converter unidades para &1
      call method zabsf_mob_cl_log=>add_message
        exporting
          msgty      = 'E'
          msgno      = '021'
*         msgv1      = conv #( im_meins_var )
          msgv1      = im_meins_var
        changing
          return_tab = et_return_tab.
    endif.
  endmethod.


  method convert_to_units.
    "variáveis locias
    data: lr_charmetr_rng  type range of atnam,
          lr_charconv_rng  type range of atnam,
          lr_char_m2_rng   type range of atnam,
          lv_conv_aux      type p decimals 3,
          lv_remaining_var type i.
    "limpar variáveis de exportação
    clear ex_units_var.
    "obter configuração
    try.
        "conversão KG para unidade
        zcl_bc_fixed_values=>get_ranges_value( exporting
                                                 im_paramter_var = zcl_bc_fixed_values=>gc_char_und_conv_cst
                                                 im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
                                               importing
                                                 ex_valrange_tab = lr_charconv_rng ).
        "conversão M para unidade
        zcl_bc_fixed_values=>get_ranges_value( exporting
                                                 im_paramter_var = zcl_bc_fixed_values=>gc_meter2unit_cst
                                                 im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
                                               importing
                                                 ex_valrange_tab = lr_charmetr_rng  ).
        "conversão m2 para unidade
        zcl_bc_fixed_values=>get_ranges_value( exporting
                                                 im_paramter_var = zcl_bc_fixed_values=>gc_charsquare_cst
                                                 im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
                                               importing
                                                 ex_valrange_tab = lr_char_m2_rng   ).

      catch zcx_bc_exceptions into data(lo_bcexceptions_obj).
        call method zabsf_mob_cl_log=>add_message
          exporting
            msgty      = lo_bcexceptions_obj->msgty
            msgno      = lo_bcexceptions_obj->msgno
            msgid      = lo_bcexceptions_obj->msgid
            msgv1      = lo_bcexceptions_obj->msgv1
            msgv2      = lo_bcexceptions_obj->msgv2
            msgv3      = lo_bcexceptions_obj->msgv3
            msgv4      = lo_bcexceptions_obj->msgv4
          changing
            return_tab = et_return_tab.
        return.
    endtry.

    "obter classificação do lote original
    zcl_mm_classification=>get_classification_by_batch( exporting
                                                          im_material_var       = im_material_var
                                                          im_lote_var           = im_batchnum_var
                                                        importing
                                                          ex_classification_tab = data(lt_characts_tab) ).

    "obter conversão unidades/ Kgs
    loop at lt_characts_tab into data(ls_characts_str)
      where atnam in lr_charconv_rng
        and ausp1 is not initial.
      "conversão de unidades
      data(lv_char_conv_var) = ls_characts_str-atflv.
      "sair do loop
      exit.
    endloop.

    "obter conversão unidades/ metros
    loop at lt_characts_tab into ls_characts_str
      where atnam in lr_charmetr_rng
        and ausp1 is not initial.
      "conversão de unidades
      data(lv_char_meter_var) = ls_characts_str-atflv.
      "sair do loop
      exit.
    endloop.

    "obter conversão unidades/ m2
    loop at lt_characts_tab into ls_characts_str
      where atnam in lr_char_m2_rng
        and ausp1 is not initial.
      "conversão de unidades
      data(lv_char_square_var) = ls_characts_str-atflv.
      "sair do loop
      exit.
    endloop.

    case im_qttyunit_var.
      when 'UN'.
        ex_units_var  = conv #( im_quantity_var ).
      when 'KG'.
        "conversão de formatos
        lv_conv_aux = lv_char_conv_var.
        "divisão
        if lv_conv_aux is not initial.
          lv_remaining_var = im_quantity_var mod lv_conv_aux.
          "resto da divisão
          if  lv_remaining_var = 0 .
            ex_units_var   = im_quantity_var / lv_conv_aux.
          else.
            if im_raise_error_var eq abap_true.
              "Não é possível dar entrada de unidades parciais
              call method zabsf_mob_cl_log=>add_message
                exporting
                  msgty      = 'E'
                  msgno      = '008'
                changing
                  return_tab = et_return_tab.
              "sair do processamento
              return.
            endif.
            "arredondamento por excesso
            ex_units_var   = ceil( im_quantity_var / lv_conv_aux ).
          endif.
        endif.
      when 'M'.
        "conversão de formatos
        lv_conv_aux = lv_char_meter_var.
        "divisão
        if lv_conv_aux is not initial.
          lv_remaining_var = im_quantity_var mod lv_conv_aux.
          "resto da divisão
          if  lv_remaining_var = 0 .
            ex_units_var   = im_quantity_var / lv_conv_aux.
          else.
            if im_raise_error_var eq abap_true.
              "Não é possível dar entrada de unidades parciais
              call method zabsf_mob_cl_log=>add_message
                exporting
                  msgty      = 'E'
                  msgno      = '008'
                changing
                  return_tab = et_return_tab.
              "sair do processamento
              return.
            endif.
            "arredondamento por excesso
            ex_units_var   = ceil( im_quantity_var / lv_conv_aux ).
          endif.
        endif.
      when 'M2'.
        "conversão de formatos
        lv_conv_aux = lv_char_square_var.
        "divisão
        if lv_conv_aux is not initial.
          lv_remaining_var = im_quantity_var mod lv_conv_aux.
          "resto da divisão
          if  lv_remaining_var = 0 .
            ex_units_var   = im_quantity_var / lv_conv_aux.
          else.
            if im_raise_error_var eq abap_true.
              "Não é possível dar entrada de unidades parciais
              call method zabsf_mob_cl_log=>add_message
                exporting
                  msgty      = 'E'
                  msgno      = '008'
                changing
                  return_tab = et_return_tab.
              "sair do processamento
              return.
            endif.
            "arredondamento por excesso
            ex_units_var   = ceil( im_quantity_var / lv_conv_aux ).
          endif.
        endif.
      when  others.
        "Unidade &1 sem conversão para unidades
        call method zabsf_mob_cl_log=>add_message
          exporting
            msgty      = 'E'
            msgno      = '006'
*           msgv1      = conv #( im_qttyunit_var )
            msgv1      =  im_qttyunit_var
          changing
            return_tab = et_return_tab.
    endcase.
  endmethod.


  method copy_chars_to_new_batch.
    "variáveis locais
    data:lt_allocchar       type table of bapi1003_alloc_values_char,
         ls_allocchar       type bapi1003_alloc_values_char,
         lt_tbobject_tab    type table of  bapi1003_object_keys,
         lt_aloclist_tab    type table of  bapi1003_alloc_list,
         lt_tbreturn_tab    type table of bapiret2,
         lv_objeckey_var    type objnum,
         lt_allocvaluesnum  type table of  bapi1003_alloc_values_num,
         lt_allocvaluescurr type table of  bapi1003_alloc_values_curr.

    "limpar variáveis de exportação
    refresh ex_return_tab.
    "criar chave do objecto
    append value #( key_field = 'MATNR'
                    value_int = im_material_var ) to lt_tbobject_tab.
    "criar chave do objecto
    append value #( key_field = 'CHARG'
                    value_int = im_newbatch_var ) to lt_tbobject_tab.
    "obter chave do objecto
    call function 'BAPI_OBJCL_CONCATENATEKEY'
      exporting
        objecttable    = 'MCH1'
      importing
        objectkey_conc = lv_objeckey_var
      tables
        objectkeytable = lt_tbobject_tab
        return         = lt_tbreturn_tab.
    "obter classe 23 do objecto
    call function 'BAPI_OBJCL_GETCLASSES'
      exporting
        objectkey_imp   = lv_objeckey_var
        objecttable_imp = 'MCH1'
        classtype_imp   = '023'
        read_valuations = abap_true
      tables
        alloclist       = lt_aloclist_tab
        return          = lt_tbreturn_tab.
    if lt_aloclist_tab is initial.
      " Lote &1 sem classe de classificação 023
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgty      = 'E'
          msgno      = '140'
          msgv1      = im_newbatch_var
        changing
          return_tab = ex_return_tab.
      "sair do processamento
      return.
    endif.
    "ler primeira linha da tabela
    read table lt_aloclist_tab into data(ls_aloclist_str) index 1.
    "ler caracteristicas
    call function 'BAPI_OBJCL_GETDETAIL'
      exporting
        objectkey        = lv_objeckey_var
        objecttable      = 'MCH1'
        classnum         = ls_aloclist_str-classnum
        classtype        = '023'
        unvaluated_chars = abap_true
      tables
        allocvaluesnum   = lt_allocvaluesnum
        allocvalueschar  = lt_allocchar
        allocvaluescurr  = lt_allocvaluescurr
        return           = lt_tbreturn_tab.

    loop at it_charstab_tab into data(ls_charcteristic_str).
      "caracteristicas alfanuméricas
      read table lt_allocchar assigning field-symbol(<fs_allochar>) with key charact = ls_charcteristic_str-atnam.
      if <fs_allochar> is assigned.
        <fs_allochar>-value_char = ls_charcteristic_str-atwrt.
      endif.
      "caracteristicas númericas
      read table lt_allocvaluesnum assigning field-symbol(<fs_allocharnum>) with key charact = ls_charcteristic_str-atnam.
      if <fs_allocharnum> is assigned.
        "converter para formato interno
        zabsf_pp_cl_tracking=>convert_char_value_to_internal( exporting
                                                                im_atnam_var   = <fs_allochar>-charact
                                                                im_atwrt_var   = ls_charcteristic_str-atwrt
                                                              importing
                                                                ex_valfrom_var = <fs_allocharnum>-value_from
                                                                ex_valueto_var = <fs_allocharnum>-value_to
                                                                ex_valuerl_var = <fs_allocharnum>-value_relation ).
      endif.
    endloop.
    "actualizar caracteristicas do lote
    call function 'BAPI_OBJCL_CHANGE'
      exporting
        objectkey          = lv_objeckey_var
        objecttable        = 'MCH1'
        classnum           = ls_aloclist_str-classnum
        classtype          = '023'
      tables
        return             = lt_tbreturn_tab
        allocvaluesnumnew  = lt_allocvaluesnum
        allocvaluescharnew = lt_allocchar
        allocvaluescurrnew = lt_allocvaluescurr.
    loop at lt_tbreturn_tab into data(ls_return_str)
      where type ca 'AEX'.
      append ls_return_str to lt_tbreturn_tab.
      "rollback
      call function 'BAPI_TRANSACTION_ROLLBACK'.
      "sair do processamento
      return.
    endloop.
    if sy-subrc ne 0.
      "commit da operação
      call function 'BAPI_TRANSACTION_COMMIT'.
    endif.
  endmethod.


  method create_batch.
    "constantes
    constants: c_kzcla type t156-kzcla value '1', "Option to classify batches
               c_xkcfc type t156-xkcfc value 'X'. "Extended classification via CFC
    "variáveis locais
    data: ls_batch_create  type mcha,
          ls_newbatch_str  type mcha,
          lt_char_of_batch type table of clbatch,
          lt_newbatch_tab  type table of mcha.

    "limpar variáveis exportação
    clear: et_return_tab, ex_newbatch_var, ex_error_var.
    "percorrer todas as caracteristicas
    loop at it_characts_tab into data(ls_characts_str).
      append value #( atnam = ls_characts_str-atnam
                      atwtb = ls_characts_str-atwrt ) to lt_char_of_batch.
    endloop.
    "material
    ls_batch_create-matnr = im_refmatnr_var.
    "centro
    ls_batch_create-werks = im_refwerks_var.
    "data de produção
    ls_batch_create-hsdat = sy-datum.
    "criar lote
    call function 'VB_CREATE_BATCH'
      exporting
        ymcha                        = ls_batch_create
        ref_matnr                    = im_refmatnr_var
        ref_charg                    = im_refbatch_var
        ref_werks                    = im_refwerks_var
        kzcla                        = c_kzcla
        xkcfc                        = c_xkcfc
      importing
        ymcha                        = ls_newbatch_str
      tables
        char_of_batch                = lt_char_of_batch
        new_batch                    = lt_newbatch_tab
        return                       = et_return_tab
      exceptions
        no_material                  = 1
        no_batch                     = 2
        no_plant                     = 3
        material_not_found           = 4
        plant_not_found              = 5
        stoloc_not_found             = 6
        lock_on_material             = 7
        lock_on_plant                = 8
        lock_on_batch                = 9
        lock_system_error            = 10
        no_authority                 = 11
        batch_exist                  = 12
        stoloc_exist                 = 13
        illegal_batch_number         = 14
        no_batch_handling            = 15
        no_valuation_area            = 16
        valuation_type_not_found     = 17
        no_valuation_found           = 18
        error_automatic_batch_number = 19
        cancelled                    = 20
        wrong_status                 = 21
        interval_not_found           = 22
        number_range_not_extern      = 23
        object_not_found             = 24
        error_check_batch_number     = 25
        no_external_number           = 26
        no_customer_number           = 27
        no_class                     = 28
        error_in_classification      = 29
        inconsistency_in_key         = 30
        region_of_origin_not_found   = 31
        country_of_origin_not_found  = 32
        others                       = 33.
    if sy-subrc ne 0.
    endif.

    loop at et_return_tab transporting no fields
      where type ca 'AEX'.
      "exportação de erro
      ex_error_var = abap_true.
      "sair do processo
      return.
    endloop.

    ex_newbatch_var = ls_newbatch_str-charg.
    call function 'BAPI_TRANSACTION_COMMIT'
      exporting
        wait = 'X'.

  endmethod.


  method get_next_batch_numbers.
    "variáveis locais
    data: lv_nextnumb_var type charg_d.
    "limpar variáveis de exportação
    clear: ex_errorflag_var.
    refresh: ex_batchnum_tab, et_return_tab.
    "n lotes
    do im_quantity_var times.
      "verificar se é para obter nº de sequenciador
      if im_skipseq_var ne abap_true.
        "nº de sequenciador
        zabsf_pp_cl_tracking=>get_next_sequence_number( importing
                                                          ex_errorflag_var = ex_errorflag_var
                                                          ex_sequencer_var = data(lv_sequencer_var)
                                                          et_return_tab    = data(lt_return_tab) ).
      endif.
      if ex_errorflag_var eq abap_true.
        "mensagem de erro
        call method zabsf_mob_cl_log=>add_message
          exporting
            msgid      = sy-msgid
            msgty      = sy-msgty
            msgno      = sy-msgno
            msgv1      = sy-msgv1
            msgv2      = sy-msgv1
            msgv3      = sy-msgv1
            msgv4      = sy-msgv1
          changing
            return_tab = et_return_tab.
        "limpar variávies
        refresh ex_batchnum_tab.
        "sair do processamento
        return.
      endif.
      "sequeciador
      append value #( charg        = space
                      sequenciador = lv_sequencer_var ) to ex_batchnum_tab.
      "limpar variávies
      clear: lv_sequencer_var.
    enddo.

    data(lt_batchnum_tab) =  ex_batchnum_tab.
    refresh ex_batchnum_tab.
    loop at lt_batchnum_tab assigning field-symbol(<fs_batchnum_str>).
      "obter próximo nº de lote
      call function 'NUMBER_GET_NEXT'
        exporting
          nr_range_nr             = '01'
          object                  = 'BATCH_CLT'
          ignore_buffer           = 'X'
          quantity                = 1
        importing
          number                  = lv_nextnumb_var
        exceptions
          interval_not_found      = 1
          number_range_not_intern = 2
          object_not_found        = 3
          quantity_is_0           = 4
          quantity_is_not_1       = 5
          interval_overflow       = 6
          buffer_overflow         = 7
          others                  = 8.
      if sy-subrc <> 0.
        "flag de erro
        ex_errorflag_var = abap_true.
      endif.
      "commmit base de dados
      commit work and wait.
      if ex_errorflag_var is not initial.
        "mensagem de erro
        call method zabsf_mob_cl_log=>add_message
          exporting
            msgid      = sy-msgid
            msgty      = sy-msgty
            msgno      = sy-msgno
            msgv1      = sy-msgv1
            msgv2      = sy-msgv1
            msgv3      = sy-msgv1
            msgv4      = sy-msgv1
          changing
            return_tab = et_return_tab.
        "sair do processamento
        return.
      endif.
      "novo nº de lote
      <fs_batchnum_str>-charg  = lv_nextnumb_var.
    endloop.
    "tabela de saida
    ex_batchnum_tab = lt_batchnum_tab.
  endmethod.


  method get_next_sequence_number.
    "variáveis locais
    data: lv_nextnumb_var type zabsf_pp_e_seq_range.
    refresh: et_return_tab.
    "limpar variáveis de exportação
    clear: ex_errorflag_var, ex_sequencer_var.
    "obter próximo nº de sequenciador
    call function 'NUMBER_GET_NEXT'
      exporting
        nr_range_nr             = '01'
        object                  = 'ZSEQUENCE'
        ignore_buffer           = 'X'
      importing
        number                  = lv_nextnumb_var
      exceptions
        interval_not_found      = 1
        number_range_not_intern = 2
        object_not_found        = 3
        quantity_is_0           = 4
        quantity_is_not_1       = 5
        interval_overflow       = 6
        buffer_overflow         = 7
        others                  = 8.
    if sy-subrc <> 0.
* Implement suitable error handling here
      ex_errorflag_var = abap_true.
    endif.
    "commmit base de dados
    commit work and wait.
    if ex_errorflag_var is not initial.
      "mensagem de erro
      call method zabsf_mob_cl_log=>add_message
        exporting
          msgid      = sy-msgid
          msgty      = sy-msgty
          msgno      = sy-msgno
          msgv1      = sy-msgv1
          msgv2      = sy-msgv1
          msgv3      = sy-msgv1
          msgv4      = sy-msgv1
        changing
          return_tab = et_return_tab.
      "sair do processamento
      return.
    endif.
    "sequenciador
    ex_sequencer_var = |{ 'B' }{ lv_nextnumb_var }|.
  endmethod.


  method update_sequence_table.
    loop at im_newbatch_tab into data(ls_newbatch_str).
      data(ls_newnetry_str) = value zabsf_sequence_t( sequenciador = ls_newbatch_str-sequenciador
                                                      mblnr        = im_document_var
                                                      charg        = ls_newbatch_str-charg
                                                      seq_lantek   = im_seqlantk_var
                                                      oprid        = im_opridval_var
                                                      erdat        = sy-datum
                                                      uzeit        = sy-uzeit
                                                      return_batch = im_retbatch_var ).
      "actualizar tabela
      modify zabsf_sequence_t from ls_newnetry_str.
      clear ls_newnetry_str.
    endloop.
    "commit da operação
    commit work and wait.
  endmethod.
ENDCLASS.
