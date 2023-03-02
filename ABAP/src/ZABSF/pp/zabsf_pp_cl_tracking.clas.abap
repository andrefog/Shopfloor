CLASS zabsf_pp_cl_tracking DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS calculate_number_of_batches
      IMPORTING
        !im_quantity_var       TYPE menge_d
        !im_qttyunit_var       TYPE meins
        !im_bacthnum_var       TYPE charg_d
        !im_material_var       TYPE matnr
      EXPORTING
        !et_return_tab         TYPE bapiret2_t
        !ex_number_batches_var TYPE int4 .
    CLASS-METHODS get_next_batch_numbers
      IMPORTING
        !im_quantity_var  TYPE nrquan
        !im_skipseq_var   TYPE flag OPTIONAL
      EXPORTING
        !ex_batchnum_tab  TYPE zabsf_pp_tt_new_batch
        !ex_errorflag_var TYPE flag
        !et_return_tab    TYPE bapiret2_t .
    CLASS-METHODS get_next_sequence_number
      EXPORTING
        !ex_errorflag_var TYPE flag
        !ex_sequencer_var TYPE zabsf_pp_e_seq
        !et_return_tab    TYPE bapiret2_t .
    CLASS-METHODS update_sequence_table
      IMPORTING
        !im_newbatch_tab TYPE zabsf_pp_tt_new_batch
        !im_opridval_var TYPE zabsf_pp_e_oprid
        !im_document_var TYPE mblnr
        !im_retbatch_var TYPE charg_d OPTIONAL
        !im_seqlantk_var TYPE zabsf_pp_e_seq_lantek OPTIONAL .
    CLASS-METHODS create_batch
      IMPORTING
        !im_refbatch_var TYPE charg_d
        !im_refmatnr_var TYPE matnr
        !im_refwerks_var TYPE werks_d
        !it_characts_tab TYPE zabsf_pp_tt_batch_charact
      EXPORTING
        !et_return_tab   TYPE bapiret2_t
        !ex_newbatch_var TYPE charg_d
        !ex_error_var    TYPE flag .
    CLASS-METHODS convert_char_value_to_internal
      IMPORTING
        !im_atnam_var       TYPE atnam
        VALUE(im_atwrt_var) TYPE atwrt
      EXPORTING
        !ex_valfrom_var     TYPE atflv
        !ex_valueto_var     TYPE atflb
        !ex_valuerl_var     TYPE atcod
        !et_return_tab      TYPE bapiret2_t .
    CLASS-METHODS convert_to_units
      IMPORTING
        !im_quantity_var    TYPE menge_d
        !im_qttyunit_var    TYPE meins
        !im_material_var    TYPE matnr
        !im_batchnum_var    TYPE charg_d
        !im_raise_error_var TYPE boole_d OPTIONAL
      EXPORTING
        !ex_units_var       TYPE int4
        !et_return_tab      TYPE bapiret2_t .
    CLASS-METHODS copy_chars_to_new_batch
      IMPORTING
        !it_charstab_tab TYPE zabsf_pp_tt_batch_charact
        !im_newbatch_var TYPE charg_d
        !im_material_var TYPE matnr
      EXPORTING
        !ex_return_tab   TYPE bapiret2_t .
    CLASS-METHODS convert_to_meins
      IMPORTING
        !im_qttyunit_var TYPE int4
        !im_meins_var    TYPE meins
        !im_material_var TYPE matnr
        !im_batchnum_var TYPE charg_d
      EXPORTING
        !ex_quantity_var TYPE menge_d
        !et_return_tab   TYPE bapiret2_t .
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
      call method zabsf_pp_cl_log=>add_message
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
        call method zabsf_pp_cl_log=>add_message
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

      catch zcx_pp_exceptions into data(lo_bcexceptions_obj).
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
        call method zabsf_pp_cl_log=>add_message
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
      call method zabsf_pp_cl_log=>add_message
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

      catch zcx_pp_exceptions into data(lo_bcexceptions_obj).
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
              call method zabsf_pp_cl_log=>add_message
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
              call method zabsf_pp_cl_log=>add_message
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
              call method zabsf_pp_cl_log=>add_message
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
        call method zabsf_pp_cl_log=>add_message
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
        call method zabsf_pp_cl_log=>add_message
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
        call method zabsf_pp_cl_log=>add_message
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
      call method zabsf_pp_cl_log=>add_message
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
