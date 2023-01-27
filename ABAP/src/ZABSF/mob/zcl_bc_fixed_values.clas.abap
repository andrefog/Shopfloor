class ZCL_BC_FIXED_VALUES definition
  public
  final
  create public .

public section.

  constants GC_MESSAGID_CST type ARBGB value 'ZDS_CA_SHP' ##NO_TEXT.
  constants GC_PRODUCTN_CST type ZBC_MODULE_SAP_E value 'PP' ##NO_TEXT.
  constants GC_FINANTIL_CST type ZBC_MODULE_SAP_E value 'FI' ##NO_TEXT.
  constants GC_MATERIAL_CST type ZBC_MODULE_SAP_E value 'MM' ##NO_TEXT.
  constants GC_CROSSAPP_CST type ZBC_MODULE_SAP_E value 'BC' ##NO_TEXT.
  constants GC_PROJECTS_CST type ZBC_MODULE_SAP_E value 'PS' ##NO_TEXT.
  constants GC_SALESMOD_CST type ZBC_MODULE_SAP_E value 'SD' ##NO_TEXT.
  constants GC_CO10NORD_CST type ZBC_PARAM_ID_E value 'CO10_ORDER_TYPE' ##NO_TEXT.
  constants GC_MATNPACK_CST type ZBC_PARAM_ID_E value 'PACK_MAT_TYPE' ##NO_TEXT.
  constants GC_STATSATP_CST type ZBC_PARAM_ID_E value 'STATUS_ATP_CHECKED' ##NO_TEXT.
  constants GC_MISSINGM_CST type ZBC_PARAM_ID_E value 'MISSING_MATERIALS' ##NO_TEXT.
  constants GC_SHOWHUST_CST type ZBC_PARAM_ID_E value 'SHOW_HU_TABLE' ##NO_TEXT.
  constants GC_CHAR_SOLD_CST type ZBC_PARAM_ID_E value 'CHAR_RAST_SOLD' ##NO_TEXT.
  constants GC_CHARNAME_CST type ZBC_PARAM_ID_E value 'CHAR_MATERIAL_NAME' ##NO_TEXT.
  constants GC_CHARCOMP_CST type ZBC_PARAM_ID_E value 'CHAR_COMPRIMENTO' ##NO_TEXT.
  constants GC_CHAR_ID_CST type ZBC_PARAM_ID_E value 'CHAR_ID' ##NO_TEXT.
  constants GC_CHAR_ARMA_CST type ZBC_PARAM_ID_E value 'CHAR_RAST_ARMACAO' ##NO_TEXT.
  constants GC_CHARLARG_CST type ZBC_PARAM_ID_E value 'CHAR_LARGURA' ##NO_TEXT.
  constants GC_CHARACAB_CST type ZBC_PARAM_ID_E value 'CHAR_ACABAMENTO' ##NO_TEXT.
  constants GC_CHARTIPO_CST type ZBC_PARAM_ID_E value 'CHAR_TIPOLOGIA' ##NO_TEXT.
  constants GC_CHARDIM1_CST type ZBC_PARAM_ID_E value 'CHAR_DIM1' ##NO_TEXT.
  constants GC_CHARPLAN_CST type ZBC_PARAM_ID_E value 'CHAR_PLAN_FAB' ##NO_TEXT.
  constants GC_MAT_CONV_CST type ZBC_PARAM_ID_E value 'CONV_MATERIAIS' ##NO_TEXT.
  constants GC_CONFIGUR_CST type ZBC_PARAM_ID_E value 'CONFIGURAVEIS_MTAT' ##NO_TEXT.
  constants GC_PRINTPRD_CST type ZBC_PARAM_ID_E value 'PRINT_PROD_STEUS' ##NO_TEXT.
  constants GC_CHARVAZA_CST type ZBC_PARAM_ID_E value 'CHAR_VAZAMENTO' ##NO_TEXT.
  constants GC_CHARSEQ_CST type ZBC_PARAM_ID_E value 'CHAR_SEQUENCIA' ##NO_TEXT.
  constants GC_CHARESP_CST type ZBC_PARAM_ID_E value 'CHAR_ESPESSURA' ##NO_TEXT.
  constants GC_DEVELCT_CST type ZBC_PARAM_ID_E value 'DEVOLUTION_CHARAT' ##NO_TEXT.
  constants GC_CHAR_UND_CONV_CST type ZBC_PARAM_ID_E value 'CHAR_UND_CONV' ##NO_TEXT.
  constants GC_DEVWARE_CST type ZBC_PARAM_ID_E value 'WAREHOUSE_DEV' ##NO_TEXT.
  constants GC_DEVPROD_CST type ZBC_PARAM_ID_E value 'PRODUCTION_DEV' ##NO_TEXT.
  constants GC_DELIVCHARS_CST type ZBC_PARAM_ID_E value 'DELIVERY_CHAR_CLASS' ##NO_TEXT.
  constants GC_PRINTSHORT_CST type ZBC_PARAM_ID_E value 'WORKCT_PP_LITE' ##NO_TEXT.
  constants GC_HUSTORAGE_CST type ZBC_PARAM_ID_E value 'CREATE_HU_STORAGE' ##NO_TEXT.
  constants GC_COOIS_TP_MAT_CST type ZBC_PARAM_ID_E value 'TIPO_MATERIAL' ##NO_TEXT.
  constants GC_COOIS_ESPESS_CST type ZBC_PARAM_ID_E value 'ESPESSURA' ##NO_TEXT.
  constants GC_COOIS_COMPRI_CST type ZBC_PARAM_ID_E value 'COMPRIMENTO' ##NO_TEXT.
  constants GC_COOIS_LARGUR_CST type ZBC_PARAM_ID_E value 'LARGURA' ##NO_TEXT.
  constants GC_COOIS_ALTURA_CST type ZBC_PARAM_ID_E value 'ALTURA' ##NO_TEXT.
  constants GC_COOIS_PF_CST type ZBC_PARAM_ID_E value 'PF' ##NO_TEXT.
  constants GC_SHP_CONSMPT_STRG_CST type ZBC_PARAM_ID_E value 'SHP_LGORT_COSUMPT' ##NO_TEXT.
  constants GC_SHOP_ADD_CSMT_CST type ZBC_PARAM_ID_E value 'SHP_LGORT_ADD_COSMT' ##NO_TEXT.
  constants GC_CHAPADEVL_CST type ZBC_PARAM_ID_E value 'CLASSE_CHAPAS_DEVOL' ##NO_TEXT.
  constants GC_CHARORGBATCH_CST type ZBC_PARAM_ID_E value 'CHAR_ORIGINAL_BATCH' ##NO_TEXT.
  constants GC_UPDATESEQUENCE_CST type ZBC_PARAM_ID_E value 'INSERT_SEQUENCE' ##NO_TEXT.
  constants GC_METER2UNIT_CST type ZBC_PARAM_ID_E value 'CHAR_METER_UNIT' ##NO_TEXT.
  constants GC_CHARRASTRO_CST type ZBC_PARAM_ID_E value 'CHAR_RASTREABILIDADE' ##NO_TEXT.
  constants GC_PP_READ_LABEL_CST type ZBC_PARAM_ID_E value 'PP_READ_PREVLABEL' ##NO_TEXT.
  constants GC_CHARSQUARE_CST type ZBC_PARAM_ID_E value 'CHAR_METER_SQUARE' ##NO_TEXT.
  constants GC_CHAROPERS_CST type ZBC_PARAM_ID_E value 'CHAR_OPERATORS' ##NO_TEXT.
  constants GC_EXPEDMATS_CST type ZBC_PARAM_ID_E value 'EXPEDIT_MATERIALS' ##NO_TEXT.
  constants GC_EXP_DOC_PROJ type ZBC_PARAM_ID_E value 'EXPEDIT_DOC_PROJ' ##NO_TEXT.
  constants GC_EXPED_BACTH_STRG_CST type ZBC_PARAM_ID_E value 'XPEDIT_BATCH_STORAGE' ##NO_TEXT.
  constants GC_EXP_DOC_SALE type ZBC_PARAM_ID_E value 'EXPEDIT_DOC_SALE' ##NO_TEXT.
  constants GC_EXP_DOC_TRANSF type ZBC_PARAM_ID_E value 'EXPEDIT_DOC_TRANSF' ##NO_TEXT.
  constants GC_MOB_HU_LGORT_CST type ZBC_PARAM_ID_E value 'MOB_NEW_HU_LGORT' ##NO_TEXT.
  constants GC_DEVEL_1_DEC_CST type ZBC_PARAM_ID_E value 'DEVEL_1_DECIMAL' ##NO_TEXT.
  constants GC_CHARPESO_CST type ZBC_PARAM_ID_E value 'CHAR_PESO' ##NO_TEXT.
  constants GC_DEP_DESTINO type ZBC_PARAM_ID_E value 'DEP_DESTINO' ##NO_TEXT.
  constants GC_DEP_ORIGEM type ZBC_PARAM_ID_E value 'DEP_ORIGEM' ##NO_TEXT.
  constants GC_GRP_COMPRA type ZBC_PARAM_ID_E value 'GRP_COMPRA' ##NO_TEXT.
  constants GC_CHARAMACAO_CST type ZBC_PARAM_ID_E value 'CHAR_COPY_OPERATORS' ##NO_TEXT.
  constants GC_VIDRO_CLASSF_ALT type ZBC_PARAM_ID_E value 'ALTURA_VIDRO' ##NO_TEXT.
  constants GC_VIDRO_CLASSF_REF type ZBC_PARAM_ID_E value 'REFERENCIA_VIDRO' ##NO_TEXT.
  constants GC_VIDRO_CLASSF_LARG type ZBC_PARAM_ID_E value 'LARGURA_VIDRO' ##NO_TEXT.
  constants GC_CHARREFER_CST type ZBC_PARAM_ID_E value 'CHAR_REFERENCIA' ##NO_TEXT.
  constants GC_ZPP2_CHAR_COPY_CST type ZBC_PARAM_ID_E value 'CHAR_ZPP2_COPY' ##NO_TEXT.
  constants GC_DEVEL_TIPOLOGIA_1_CST type ZBC_PARAM_ID_E value 'DEVEL_TIPOLOGIA_1' ##NO_TEXT.
  constants GC_DEVEL_TIPOLOGIA_2_CST type ZBC_PARAM_ID_E value 'DEVEL_TIPOLOGIA_2' ##NO_TEXT.
  constants GC_DEVEL_TIPOLOGIA_3_CST type ZBC_PARAM_ID_E value 'DEVEL_TIPOLOGIA_3' ##NO_TEXT.
  constants GC_SEMIACAB_CST type ZBC_PARAM_ID_E value 'HALB' ##NO_TEXT.
  constants GC_PRODACAB_CST type ZBC_PARAM_ID_E value 'FERT' ##NO_TEXT.
  constants GC_CHARAREA_CST type ZBC_PARAM_ID_E value 'CHAR_AREA' ##NO_TEXT.
  constants GC_CHARELEM_CST type ZBC_PARAM_ID_E value 'CHAR_ELEMENTOS' ##NO_TEXT.
  constants GC_CHARDIM2_CST type ZBC_PARAM_ID_E value 'CHAR_DIM2' ##NO_TEXT.
  constants GC_CHARDIM3_CST type ZBC_PARAM_ID_E value 'CHAR_DIM3' ##NO_TEXT.
  constants GC_ZPP3_101_CST type ZBC_PARAM_ID_E value 'ZPP3_STEUS_101' ##NO_TEXT.
  constants GC_ZPP3_531_CST type ZBC_PARAM_ID_E value 'ZPP3_STEUS_531' ##NO_TEXT.
  constants GC_ZPP3LGORT_CST type ZBC_PARAM_ID_E value 'ZPP3_531_LGORT' ##NO_TEXT.
  constants GC_ZPP3LMATNR_CST type ZBC_PARAM_ID_E value 'ZPP3_531_MATNR' ##NO_TEXT.

  class-methods GET_SINGLE_VALUE
    importing
      !IM_PARAMTER_VAR type ZBC_PARAM_ID_E
      !IM_PARAMLIN_VAR type ZBC_INDEX_ID_E optional
      !IM_MODULESP_VAR type ZBC_MODULE_SAP_E
      !IM_WERKSVAL_VAR type WERKS_D optional
    exporting
      !EX_PRMVALUE_VAR type RVARI_VAL
    raising
      ZCX_BC_EXCEPTIONS .
  class-methods GET_RANGES_VALUE
    importing
      !IM_PARAMTER_VAR type ZBC_PARAM_ID_E
      !IM_MODULESP_VAR type ZBC_MODULE_SAP_E
      !IM_WERKSVAL_VAR type WERKS_D optional
    exporting
      !EX_VALRANGE_TAB type TABLE
    raising
      ZCX_BC_EXCEPTIONS .
protected section.
private section.
ENDCLASS.



CLASS ZCL_BC_FIXED_VALUES IMPLEMENTATION.


  method get_ranges_value.
    "variáveis locais
    data: ls_valrange_str type ref to data.
    "limpar variáveis
    refresh ex_valrange_tab.
    "criar estrutura genérica
    create data ls_valrange_str like line of ex_valrange_tab.
    "atribuir field symbol
    assign ls_valrange_str->* to field-symbol(<fs_valrange_str>).

    "obter configuração
    select *
      from zbc_fixval_t
      into table @data(lt_fixedval_tab)
      where werks         eq '3000'
        and module_sap    eq @im_modulesp_var
        and parameter_id  eq @im_paramter_var.
    if sy-subrc is not initial.
      "Falta configuração na tabela ZBC_FIXVAL_T (&1 &2)
      raise exception type zcx_bc_exceptions
        exporting
          msgty = sy-abcde+4(1)
          msgid = gc_messagid_cst
          msgno = '000'
          msgv1 = conv #( im_paramter_var ).
    endif.

    "percorrer tabela
    loop at lt_fixedval_tab assigning field-symbol(<fs_fixedval_str>).
      "atribuir campo SIGN
      assign component 'SIGN' of structure <fs_valrange_str> to field-symbol(<fs_val_sign_var>).
      if <fs_val_sign_var> is assigned.
        "mapear SIGN na estrutura de retorno
        <fs_val_sign_var> = <fs_fixedval_str>-sign.
      endif.
      "mapear OPTION
      assign component 'OPTION' of structure <fs_valrange_str> to field-symbol(<fs_val_optn_var>).
      if <fs_val_optn_var> is assigned.
        "mapear OPTION na estrutura de retorno
        <fs_val_optn_var> = <fs_fixedval_str>-so_option.
      endif.
      "atribuir campo LOW
      assign component 'LOW' of structure <fs_valrange_str> to field-symbol(<fs_val_lows_var>).
      if <fs_val_lows_var> is assigned.
        "mapear LOW na estrutura de retorno
        <fs_val_lows_var> = <fs_fixedval_str>-low.
      endif.
      "atribuir campo HIGH
      assign component 'HIGH' of structure <fs_valrange_str> to field-symbol(<fs_val_high_var>).
      if <fs_val_high_var> is assigned.
        "mapear HIGH na estrutura de retorno
       <fs_val_high_var> = <fs_fixedval_str>-high.
      endif.
      "adicionar estrutura à tabela de retorno
      append <fs_valrange_str> to ex_valrange_tab.
    endloop.
  endmethod.


  method get_single_value.
    "variáveis locais
    data: lr_value_id_rng type range of zbc_fixval_t-line.
    "limpar variáveis de exportação
    clear ex_prmvalue_var.
    "verificar se o parâmetro está preenchido
    if im_paramlin_var is not initial.
      "criar range
      append value #( sign   = sy-abcde+8(1)
                      option = |{ sy-abcde+4(1) }{ sy-abcde+16(1) }|
                      low    = im_paramlin_var )
                to lr_value_id_rng.
    endif.
    "obter configuração
    select *
      from zbc_fixval_t
      into table @data(lt_fixedval_tab)
      up to 1 rows
      where parameter_id eq @im_paramter_var
        and line         in @lr_value_id_rng
        and module_sap   eq @im_modulesp_var
        and werks        eq @im_werksval_var.
    if sy-subrc is not initial.
      "Falta configuração na tabela ZBC_FIXVAL_T (&1 &2)
      raise exception type zcx_bc_exceptions
        exporting
          msgty = sy-abcde+4(1)
          msgid = gc_messagid_cst
          msgno = '000'
          msgv1 = conv #( im_paramter_var )
          msgv2 = conv #( im_paramlin_var ).
    endif.
    "retornar a 1º linha
    ex_prmvalue_var = lt_fixedval_tab[ 1 ]-low.
  endmethod.
ENDCLASS.
