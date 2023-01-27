function zabsf_mob_get_pos.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(INPUTOBJ) TYPE  ZABSF_MOB_S_INPUTOBJECT
*"     VALUE(IV_GET_ITEMS) TYPE  FLAG OPTIONAL
*"     VALUE(IV_EBELN) TYPE  EBELN OPTIONAL
*"     VALUE(IV_LIFNR) TYPE  LIFNR OPTIONAL
*"  EXPORTING
*"     VALUE(ET_POS) TYPE  ZABSF_MOB_T_POS_LIST
*"----------------------------------------------------------------------
  "tipos
  types: begin of ty_marm_str,
           matnr  type matnr,
           meins  type lrmei,
           output type meins,
         end of ty_marm_str.
  "variáveis locais
  data: lr_ebeln           type rsis_t_range,
        lr_lifnr           type rsis_t_range,
        lv_parent_id_var   type  mb_parent_id,
        lv_line_id_var     type  mb_line_id,
        lt_components_tab  type table of resb,
        lt_items_tab       type zabsf_mob_t_item_detail,
        lt_marm_tab        type table of ty_marm_str,
        lv_largura_var     type atnam,
        lv_comprimento_var type atnam,
        lv_referencia_var  type atnam.

  try.
      "caracteristica comprimento
      call method zcl_bc_fixed_values=>get_single_value
        exporting
          im_paramter_var = zcl_bc_fixed_values=>gc_charcomp_cst
          im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
          im_paramlin_var = 1
        importing
          ex_prmvalue_var = data(lv_charvalue_var).
      "conversão de campos
      lv_comprimento_var = lv_charvalue_var.
    catch zcx_bc_exceptions into data(lo_excption_obj).
  endtry.
  try.
      "caracteristica largura
      call method zcl_bc_fixed_values=>get_single_value
        exporting
          im_paramter_var = zcl_bc_fixed_values=>gc_charlarg_cst
          im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
          im_paramlin_var = 1
        importing
          ex_prmvalue_var = lv_charvalue_var.
      "conversão de campos
      lv_largura_var = lv_charvalue_var.
    catch zcx_bc_exceptions into lo_excption_obj.
  endtry.
  try.
      "caracteristica referencia
      call method zcl_bc_fixed_values=>get_single_value
        exporting
          im_paramter_var = zcl_bc_fixed_values=>gc_charrefer_cst
          im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
          im_paramlin_var = 1
        importing
          ex_prmvalue_var = lv_charvalue_var.
      "conversão de campos
      lv_referencia_var = lv_charvalue_var.
    catch zcx_bc_exceptions into lo_excption_obj.
  endtry.

  "criar range de nº do documento de compras
  if iv_ebeln is not initial.
    append value #( sign = 'I'
                    option = 'CP'
                    low = |{ '*' }{ iv_ebeln }{ '*' }| ) to lr_ebeln.
  endif.
  "criar range para nº conta do fornecedor
  if iv_lifnr is not initial.
    append value #( sign = 'I'
                    option = 'CP'
                    low = |{ '*' }{ iv_lifnr }{ '*' }| ) to lr_lifnr.
  endif.
  "obter caracteristicas que podem ser alteradas
  select *
    from zabsf_mob_charac
    into table @data(lt_confchar_tab)
      where werks eq @inputobj-werks.

  "obter dados Cabeçalho do documento de compra - limite 100 POs
  select ebeln, lifnr, bsart, aedat, waers
    from ekko
    up to 100 rows
    into corresponding fields of table @et_pos
  where ebeln in @lr_ebeln
    and lifnr in @lr_lifnr
    and bukrs eq @inputobj-werks
    and loekz eq @abap_false.

  "verficar se é para obter os items
  if iv_get_items eq abap_true
    and et_pos is not initial.
    "obter dados items do documento de compra
    select ekpo~ebeln, ekpo~ebelp, ekpo~pstyp, ekpo~aedat, ekpo~matnr, ekpo~lgort, ekpo~menge, ekpo~meins, ekpo~netwr, ekpo~werks, eket~charg, makt~maktx
      from ekpo
      inner join eket
      on ( eket~ebeln eq ekpo~ebeln and eket~ebelp eq ekpo~ebelp )
      left join makt
        on ( ekpo~matnr eq makt~matnr
       and makt~spras eq @sy-langu )
      into table @data(lt_ekpo)
      for all entries in @et_pos
        where ekpo~ebeln eq @et_pos-ebeln
          and ekpo~loekz eq @abap_false
          and ekpo~elikz eq @abap_false
          and eket~etenr eq '0001'.

    "obter BOM dos items de subcontratação
    if lt_ekpo is not initial.
      select *
        from resb
        into table @data(lt_resb_tab)
        for all entries in @lt_ekpo
          where ebeln eq @lt_ekpo-ebeln
            and ebelp eq @lt_ekpo-ebelp.
      if sy-subrc eq 0.
        "descrição dos materiais
        select marc~matnr, marc~xchpf, makt~maktx
          from marc as marc
          left join makt as makt
          on makt~matnr eq marc~matnr
          into table @data(lt_matsdesc_tab)
          for all entries in @lt_resb_tab
           where marc~matnr eq @lt_resb_tab-matnr
             and marc~werks eq @inputobj-werks
             and makt~spras eq @sy-langu.
        "unidades de medida alternativa dos sub items
        select matnr, meinh as meins
          from marm
          into corresponding fields of table @lt_marm_tab
          for all entries in @lt_resb_tab
            where matnr eq @lt_resb_tab-matnr.
      endif.
      "obter unidades de medida alternativa dos items
      select matnr, meinh as meins
        from marm
        appending corresponding fields of table @lt_marm_tab
        for all entries in @lt_ekpo
          where matnr eq @lt_ekpo-matnr.
      "ordenar tabela de unidades
      sort lt_marm_tab by matnr meins.
      "eliminar duplicados
      delete adjacent duplicates from lt_marm_tab comparing matnr meins.
      "conversão de formatos
      loop at lt_marm_tab assigning field-symbol(<fs_marm_str>).
        call function 'CONVERSION_EXIT_CUNIT_OUTPUT'
          exporting
            input          = <fs_marm_str>-meins
          importing
            output         = <fs_marm_str>-output
          exceptions
            unit_not_found = 1
            others         = 2.
        if sy-subrc <> 0.
        endif.
      endloop.
    endif.
    "percorrer todos os pedidos de compras
    loop at et_pos assigning field-symbol(<fs_pos>).
      "obter tabela de items da PO
      <fs_pos>-item_tab = value #( for ls_ekpoitem_str in lt_ekpo
                                   where ( ebeln eq <fs_pos>-ebeln )
                                    ( corresponding #( ls_ekpoitem_str ) ) ).
      "obter subitems
      loop at <fs_pos>-item_tab assigning field-symbol(<fs_itemline_str>).
        "contador de linha
        add 1 to lv_line_id_var.
        <fs_itemline_str>-line_id = lv_line_id_var.
        "unidades de medida alternativa
        <fs_itemline_str>-units = value #( for ls_marm_str in lt_marm_tab
                                           where ( matnr eq <fs_itemline_str>-matnr )
                                            ( corresponding #( ls_marm_str  ) ) ).
        if <fs_itemline_str>-meins eq 'UN'.
          <fs_itemline_str>-menge_unit = <fs_itemline_str>-menge.
        endif.
        "obter quantidade a recepcionada
        zcl_absf_mob=>get_received_quantity( exporting
                                               im_valebeln_var = <fs_itemline_str>-ebeln
                                               im_valebelp_var = <fs_itemline_str>-ebelp
                                             importing
                                               ex_quantity_var = data(lv_quantity_var) ).
        "subtrair à quantidade do pedido
        <fs_itemline_str>-menge = <fs_itemline_str>-menge - lv_quantity_var.
        "verficar se lote está preenchido
        if <fs_itemline_str>-charg is not initial.

          "obter caracteristicas do lote
          zcl_mm_classification=>get_classification_by_batch( exporting
                                                                im_material_var       = <fs_itemline_str>-matnr
                                                                im_lote_var           = <fs_itemline_str>-charg
                                                                im_shownull_var       = abap_true
                                                              importing
                                                                ex_classification_tab = data(lt_characts_tab)
                                                                ex_class_tab          = data(lt_classfic_tab) ).
          "comprimento
          if line_exists( lt_characts_tab[ atnam = lv_comprimento_var ] ).
            <fs_itemline_str>-length = lt_characts_tab[ atnam = lv_comprimento_var ]-ausp1.
          endif.
          "largura
          if line_exists( lt_characts_tab[ atnam = lv_largura_var ] ).
            <fs_itemline_str>-width = lt_characts_tab[ atnam = lv_largura_var ]-ausp1.
          endif.
          "referência
          if line_exists( lt_characts_tab[ atnam = lv_referencia_var ] ).
            <fs_itemline_str>-reference = lt_characts_tab[ atnam = lv_referencia_var ]-ausp1.
          endif.

          if lt_confchar_tab is not initial.
            "converter unidade do pedido em unidades
            zabsf_pp_cl_tracking=>convert_to_units( exporting
                                                      im_quantity_var = <fs_itemline_str>-menge
                                                      im_qttyunit_var = <fs_itemline_str>-meins
                                                      im_material_var = <fs_itemline_str>-matnr
                                                      im_batchnum_var = <fs_itemline_str>-charg
                                                    importing
                                                      ex_units_var    =  <fs_itemline_str>-menge_unit ).

            "obter classe de avaliação
            read table lt_classfic_tab into data(ls_classfic_str) index 1.
            if sy-subrc eq 0.
              "percorrer todas as caracteristicas configuradas
              loop at lt_confchar_tab into data(ls_confchar_str)
                where classnum eq ls_classfic_str-class.
                "verificar se caracterisita está no lote
                read table lt_characts_tab into data(ls_char) with key atnam = ls_confchar_str-charact.
                if sy-subrc eq 0.
                  "exportar caracteristica
                  append value #( atnam     = ls_char-atnam
                                  atwrt     = ls_char-ausp1
                                  smbez     = ls_char-smbez
                                  atflv     = ls_char-atflv
                                  dime1     = ls_char-dime2
                                  mandatory = ls_confchar_str-mandatory ) to  <fs_itemline_str>-characteristics.
                endif.
              endloop.
            endif.
          endif.
        endif.
        "items de subcontratação
        if <fs_itemline_str>-pstyp eq '3'.
          "https://answers.sap.com/questions/10202722/bapigoodsmvtcreate-for-subcontracting-po.html
          lt_components_tab = value #( for ls_resb in lt_resb_tab
                                          where ( ebeln eq <fs_itemline_str>-ebeln
                                           and    ebelp eq <fs_itemline_str>-ebelp )
                                           ( ls_resb ) ).
          data(lv_parent_id) = <fs_itemline_str>-line_id.
          loop at lt_components_tab into data(ls_components_str).
            "incrementar uma unidade
            add 1 to lv_line_id_var.
            "adicionar linha de subitems
            append value #( ebeln     = <fs_itemline_str>-ebeln
                            ebelp     = <fs_itemline_str>-ebelp
                            pstyp     = <fs_itemline_str>-pstyp
                            matnr     = ls_components_str-matnr
                            charg     = ls_components_str-charg
                            lgort     = ls_components_str-lgort
                            meins     = ls_components_str-erfme
                            maktx     = cond #( when line_exists( lt_matsdesc_tab[ matnr = ls_components_str-matnr ] )
                                                then lt_matsdesc_tab[ matnr = ls_components_str-matnr ]-maktx )
                            xchpf     = cond #( when line_exists( lt_matsdesc_tab[ matnr = ls_components_str-matnr ] )
                                                then lt_matsdesc_tab[ matnr = ls_components_str-matnr ]-xchpf )
                            menge     = ls_components_str-erfmg
                            parent_id = lv_parent_id
                            units     = value #( for ls_marm_str in lt_marm_tab
                                           where ( matnr eq ls_components_str-matnr )
                                            ( corresponding #( ls_marm_str  ) ) )
                            line_id   = lv_line_id_var ) to <fs_itemline_str>-subitems.
          endloop.
        endif.
        "limpar variáveis
        clear lv_parent_id.
        refresh: lt_components_tab, lt_characts_tab, lt_classfic_tab.
      endloop.
    endloop.
  endif.
  "elmiminar pedidos sem items
  delete et_pos
     where item_tab is initial.
endfunction.
