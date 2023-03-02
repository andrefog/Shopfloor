class ZABSF_PP_CL_CONSUMPTIONS definition
  public
  final
  create public .

public section.

  interfaces ZIF_ABSF_PP_CONSUMPTIONS .

  aliases CREATE_CONSUM_MATNR
    for ZIF_ABSF_PP_CONSUMPTIONS~CREATE_CONSUM_MATNR .
  aliases CREATE_CONSUM_ORDER
    for ZIF_ABSF_PP_CONSUMPTIONS~CREATE_CONSUM_ORDER .
  aliases GET_BATCH_CONSUMED
    for ZIF_ABSF_PP_CONSUMPTIONS~GET_BATCH_CONSUMED .
  aliases GET_COMPONENTS_MATNR
    for ZIF_ABSF_PP_CONSUMPTIONS~GET_COMPONENTS_MATNR .
  aliases GET_COMPONENTS_ORDER
    for ZIF_ABSF_PP_CONSUMPTIONS~GET_COMPONENTS_ORDER .
  aliases REM_COMPONENTS_ORDER
    for ZIF_ABSF_PP_CONSUMPTIONS~REM_COMPONENTS_ORDER .

  methods CONSTRUCTOR
    importing
      !INITIAL_REFDT type VVDATUM
      !INPUT_OBJECT type ZABSF_PP_S_INPUTOBJECT .
  methods CREATE_CONSUM_ORDER_SUBPRODUCT
    importing
      !AUFNR type AUFNR
      !COMPONENTS_ST type ZABSF_PP_S_COMPONENTS optional
      !ARBPL type ARBPL optional
      !VENDOR type LIFNR optional
    changing
      !RETURN_TAB type BAPIRET2_T .
  methods GET_HU_COMPONENTS
    importing
      !HU type EXIDV
      !AUFNR type AUFNR
    changing
      !COMPONENTS_TAB type ZABSF_PP_T_COMPONENTS
      !RETURN_TAB type BAPIRET2_T .
  methods GET_POSSIBLE_DEVOLUTIONS
    importing
      !AUFNR type AUFNR
      !VORNR type VORNR optional
    changing
      !COMPONENTS_TAB type ZABSF_PP_T_COMPONENTS
      !RETURN_TAB type BAPIRET2_T .
  methods SET_DEVOLUTIONS
    importing
      value(AUFNR) type AUFNR
      value(COMPONENTS_ST) type ZABSF_PP_S_COMPONENTS
      value(DEVOLUTION_DESTINATION) type CHAR1 optional
      !WERKS type WERKS_D
      !ARBPL type ARBPL
    changing
      !RETURN_TAB type BAPIRET2_T .
  class-methods GET_MULITMATERIAL_COMPONENTS
    importing
      !AUFNR type AUFNR
      !VORNR type VORNR
      !INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
    changing
      !CH_PRODUCED_VAR type MENGE_D optional
      !COMPONENTS_TAB type ZABSF_PP_T_COMPONENTS
      !RETURN_TAB type BAPIRET2_T optional
      !CH_ORDERQTT_VAR type MENGE_D optional
      !CH_MISSING_VAR type MENGE_D optional .
  class-methods CREATE_DEVOLUTION_BATCH
    importing
      !IM_REFBATCH_VAR type CHARG_D
      !IM_REFMATNR_VAR type MATNR
      !IM_REFWERKS_VAR type WERKS_D
      !IT_CHARACTS_TAB type ZABSF_PP_TT_BATCH_CHARACT optional
    exporting
      !ET_RETURN_TAB type BAPIRET2_T
      !EX_NEWBATCH_VAR type CHARG_D
      !EX_ERROR_VAR type FLAG .
  class-methods CALCULATE_CHAR_VALUE_FROM_TEXT
    importing
      !IT_LINES_TAB type EXPD_LINES_T
      !IM_CHAPAS_VAR type BOOLE_D
    changing
      !CH_CHARACTS_TAB type ZABSF_PP_TT_BATCH_CHARACT .
  class-methods CONVERT_CHAR_VALUE_TO_EXTERNAL
    importing
      !IM_ATNAM_VAR type ATNAM
      !IM_ATFLV_VAR type ATFLV
    exporting
      !ET_RETURN_TAB type BAPIRET2_T
      !EX_ATWRT_VAR type ATWRT .
  class-methods SET_DEVOLUTION_CHARACT
    importing
      !IM_MATERIAL_VAR type MATNR
      !IM_WERKS_VAR type WERKS_D
      !IM_BATCH_VAR type CHARG_D
      !IM_CHARACTS_TAB type ZABSF_PP_TT_BATCH_CHARACT
    exporting
      !ET_RETURN_TAB type BAPIRET2_T
      !EX_CHARACTS_TAB type ZABSF_PP_TT_BATCH_CHARACT .
  class-methods CHECK_CONSUMPTION
    importing
      !IM_AUFNR_VAR type AUFNR
    exporting
      !ET_RETURN_TAB type BAPIRET2_T
      !ET_RESB_TAB type RESB_T .
protected section.
private section.

  data REFDT type VVDATUM .
  data INPUTOBJ type ZABSF_PP_S_INPUTOBJECT .
ENDCLASS.



CLASS ZABSF_PP_CL_CONSUMPTIONS IMPLEMENTATION.


method calculate_char_value_from_text.
    "constantes
    constants: lc_compriment_cst type atnam value 'MET_COMPRIMENTO',
               lc_largura_cst    type atnam value 'MET_LARGURA',
               lc_units_prkg_cst type atnam value 'L_KG_P_UN',
               lc_m_to_unit      type atnam value 'L_ME_P_UN',
               lc_m2_to_unit     type atnam value 'L_M2_P_UN_2'.

    "variáveis locais
    data: lv_textvalue_var type atflv,
          lv_text1_var     type char30,
          lv_text2_var     type char30,
          lv_charvalue_var type atflv,
          lv_move2num_var  type p decimals 3,
          lt_characts_tab  type zabsf_pp_tt_batch_charact,
          lv_newlength_var type atflv.

    "cópia local
    lt_characts_tab = ch_characts_tab.
    "limpar valor das caracteristicas
    if im_chapas_var eq abap_true.
      loop at ch_characts_tab assigning field-symbol(<fs_charact_str>)
        where atnam eq lc_units_prkg_cst.
        clear <fs_charact_str>-atwrt.
        clear <fs_charact_str>-atflv.
      endloop.
    else.
      loop at ch_characts_tab assigning <fs_charact_str>
             where atnam eq lc_compriment_cst or atnam eq lc_units_prkg_cst
             or atnam eq lc_m_to_unit or atnam eq lc_m2_to_unit.
        clear <fs_charact_str>-atwrt.
        clear <fs_charact_str>-atflv.
      endloop.
    endif.

    if it_lines_tab is initial.
      "sair do processamento
      return.
    endif.
    "contagem de linhas
    data(lv_lines_var) = lines( it_lines_tab ).
    read table it_lines_tab into data(ls_textvalue_str) index lv_lines_var.
    "obter parte númerica do texto
    call function 'MOVE_CHAR_TO_NUM'
      exporting
        chr             = ls_textvalue_str-tdline
      importing
        num             = lv_move2num_var "lv_textvalue_var
      exceptions
        convt_no_number = 1
        convt_overflow  = 2
        others          = 3.
    if sy-subrc <> 0.
      return.
    endif.
    lv_textvalue_var = lv_move2num_var.
    "chapas
    if im_chapas_var eq abap_true.
      read table ch_characts_tab assigning <fs_charact_str> with key atnam = lc_units_prkg_cst.
      if <fs_charact_str> is not assigned.
        "sair do processamento
        return.
      endif.
      "valor original
      read table lt_characts_tab into data(ls_characts_str) with key atnam = lc_units_prkg_cst.
      "subtracção
      data(lv_sub_var) = ls_characts_str-atflv - lv_textvalue_var.
      "formato externo da caracteristica L_KG_P_UN
      call method zabsf_pp_cl_consumptions=>convert_char_value_to_external
        exporting
          im_atnam_var = ls_characts_str-atnam
          im_atflv_var = lv_sub_var
        importing
          ex_atwrt_var = <fs_charact_str>-atwrt.
    else.
      "perfis
      "comprimento
      read table ch_characts_tab assigning <fs_charact_str> with key atnam = lc_compriment_cst.
      if <fs_charact_str> is not assigned.
        "sair do processamento
        return.
      endif.
      "valor original
      read table lt_characts_tab into ls_characts_str with key atnam = lc_compriment_cst.
      "obter parte númerica do texto
      call function 'MOVE_CHAR_TO_NUM'
        exporting
          chr             = ls_textvalue_str-tdline
        importing
          num             = lv_move2num_var
        exceptions
          convt_no_number = 1
          convt_overflow  = 2
          others          = 3.
      if sy-subrc <> 0.
        return.
      endif.
      lv_textvalue_var = lv_move2num_var.

      lv_newlength_var = lv_textvalue_var / 1000. "em metros

      "formato externo da caracteristica MET_COMPRIMENTO
      call method zabsf_pp_cl_consumptions=>convert_char_value_to_external
        exporting
          im_atnam_var = ls_characts_str-atnam
          im_atflv_var = lv_textvalue_var
        importing
          ex_atwrt_var = <fs_charact_str>-atwrt.

      "regra 3 simples
      clear lv_charvalue_var.

      read table ch_characts_tab assigning <fs_charact_str> with key atnam = lc_units_prkg_cst.
      if <fs_charact_str> is not assigned.
        "sair do processamento
        return.
      endif.
      "valor original das unidades por kg
      read table lt_characts_tab into ls_characts_str with key atnam = lc_units_prkg_cst.
      "valor original do comprimento
      read table lt_characts_tab into data(ls_charact2_str) with key atnam = lc_compriment_cst.
      if ls_characts_str-atflv is not initial.
        data(lv_new_kgun_var) =  ( lv_textvalue_var * ls_characts_str-atflv ) / ls_charact2_str-atflv.
      endif.
      "formato externo da caracteristica L_KG_P_UN
      call method zabsf_pp_cl_consumptions=>convert_char_value_to_external
        exporting
          im_atnam_var = ls_characts_str-atnam
          im_atflv_var = lv_new_kgun_var
        importing
          ex_atwrt_var = <fs_charact_str>-atwrt.


      read table ch_characts_tab assigning <fs_charact_str> with key atnam = lc_m2_to_unit.
      if <fs_charact_str> is assigned and sy-subrc eq 0.
        "cálculo valor em m2
        "valor original do comprimento
        read table lt_characts_tab into data(ls_charact3_str) with key atnam = lc_compriment_cst.
        read table lt_characts_tab into data(ls_charact4_str) with key atnam = lc_largura_cst.

        lv_newlength_var = ( ls_charact3_str-atflv / 1000 ) * ( ls_charact4_str-atflv / 1000 ).
        "formato externo da caracteristica L_M2_P_UN_2
        call method zabsf_pp_cl_consumptions=>convert_char_value_to_external
          exporting
            im_atnam_var = <fs_charact_str>-atnam
            im_atflv_var = lv_newlength_var
          importing
            ex_atwrt_var = <fs_charact_str>-atwrt.
      endif.
      "ordenar
      read table ch_characts_tab assigning <fs_charact_str> with key atnam = lc_m_to_unit.
      if <fs_charact_str> is assigned and sy-subrc eq 0.
        "formato externo da caracteristica L_ME_P_UN
        call method zabsf_pp_cl_consumptions=>convert_char_value_to_external
          exporting
            im_atnam_var = <fs_charact_str>-atnam
            im_atflv_var = lv_newlength_var
          importing
            ex_atwrt_var = <fs_charact_str>-atwrt.
      endif.

    endif.
  endmethod.


METHOD check_consumption.
  "constantes
  CONSTANTS: lc_consumptions_cst TYPE bwart VALUE '261',
             lc_devolutions_cst  TYPE bwaer VALUE '262'.
  "variávies locais
  DATA: lr_atnam_rng    TYPE RANGE OF atnam,
        lv_error_var    TYPE boole_d,
        lv_matchfnd_var TYPE boole_d,
        lv_batchmgm_var TYPE boole_d,
        lv_parent_var   TYPE boole_d.
  "limpar variávies de exportação
  REFRESH et_return_tab.

  TRY.
      "caracteristicas nome
      CALL METHOD zcl_bc_fixed_values=>get_ranges_value
        EXPORTING
          im_paramter_var = zcl_bc_fixed_values=>gc_charname_cst
          im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
        IMPORTING
          ex_valrange_tab = lr_atnam_rng.

    CATCH zcx_pp_exceptions INTO DATA(lo_excpetions_obj).
      "enviar mensagem de erro
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = lo_excpetions_obj->msgty
          msgid      = lo_excpetions_obj->msgid
          msgno      = lo_excpetions_obj->msgno
          msgv1      = lo_excpetions_obj->msgv1
          msgv2      = lo_excpetions_obj->msgv2
          msgv3      = lo_excpetions_obj->msgv3
          msgv4      = lo_excpetions_obj->msgv4
        CHANGING
          return_tab = et_return_tab.
      RETURN.
  ENDTRY.

  "obter componentes
  SELECT *
    FROM resb
    INTO TABLE @DATA(lt_resb_tab)
      WHERE aufnr EQ @im_aufnr_var
        AND xloek EQ @abap_false
    %_HINTS ORACLE 'index(resb"Z01")'..
  "remover os items 'pais' dos splits de lote
  LOOP AT lt_resb_tab ASSIGNING FIELD-SYMBOL(<fs_resb_str>)
    WHERE charg IS INITIAL.
    "verificar se existem filhos
    LOOP AT lt_resb_tab INTO DATA(ls_resb2_str)
      WHERE posnr EQ <fs_resb_str>-posnr
       AND charg IS NOT INITIAL.
      "item pai contem filhos com lote. não considerar item pai.
      lv_parent_var = abap_true.
    ENDLOOP.
    IF lv_parent_var EQ abap_true.
      "maraca para eliminar - remover item pai
      <fs_resb_str>-xloek = abap_true.
    ENDIF.
    CLEAR: lv_parent_var.
  ENDLOOP.
  "eliminar items pais
  DELETE lt_resb_tab
    WHERE xloek EQ abap_true.

  "obter os consumos
  SELECT *
    FROM mseg
    INTO TABLE @DATA(lt_consumptions_tab)
      WHERE aufnr EQ @im_aufnr_var
        AND bwart EQ @lc_consumptions_cst.
  IF lt_consumptions_tab IS NOT INITIAL.
    "obter documentos estornados
    SELECT *
      FROM mseg INTO TABLE @DATA(lt_devolutions_tab)
      FOR ALL ENTRIES IN @lt_consumptions_tab
      WHERE aufnr EQ @im_aufnr_var
        AND bwart EQ @lc_devolutions_cst
        AND smbln EQ @lt_consumptions_tab-mblnr
        AND smblp EQ @lt_consumptions_tab-zeile.
    IF sy-subrc EQ 0.
      "remover os estornados
      LOOP AT lt_consumptions_tab INTO DATA(ls_consumo_str).
        IF line_exists( lt_devolutions_tab[ smbln = ls_consumo_str-mblnr
                                            smblp = ls_consumo_str-zeile ] ).
          DELETE lt_consumptions_tab.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDIF.

  IF lt_consumptions_tab IS INITIAL.
    "Ordem sem consumos! Não é possível lançar produção
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'E'
        msgno      = 161
      CHANGING
        return_tab = et_return_tab.
    RETURN.
  ENDIF.

  "obter materiais geridos a lote
  SELECT *
    FROM mara
    INTO TABLE @DATA(lt_mara_tab)
    FOR ALL ENTRIES IN @lt_resb_tab
      WHERE matnr EQ @lt_resb_tab-matnr
        AND xchpf EQ @abap_true.
  "percorrer todos os componentes
  LOOP AT lt_resb_tab ASSIGNING <fs_resb_str>.
    "limpar variável de erro
    CLEAR: lv_error_var, lv_matchfnd_var.
    "verificar se material é gerido a lote
    READ TABLE lt_mara_tab TRANSPORTING NO FIELDS WITH KEY matnr = <fs_resb_str>-matnr.
    IF sy-subrc EQ 0.
      "material gerido a lote
      lv_batchmgm_var = abap_true.
      "obter nome
      zcl_mm_classification=>get_desc_as_co02( EXPORTING
                                                 im_resb_str        = <fs_resb_str>
                                               IMPORTING
                                                 ex_description_var = DATA(lv_description_var) ).
      "percorrer todos os consumos
      LOOP AT lt_consumptions_tab ASSIGNING FIELD-SYMBOL(<fs_comsumptions_str>)
          WHERE matnr EQ <fs_resb_str>-matnr
            AND charg IS NOT INITIAL.
        "obter material do lote
        zcl_mm_classification=>get_material_desc_by_batch( EXPORTING
                                                             im_material_var    = <fs_comsumptions_str>-matnr
                                                             im_batch_var       = <fs_comsumptions_str>-charg
                                                           IMPORTING
                                                             ex_description_var = DATA(lv_batchdesc_var) ).
        IF lv_batchdesc_var EQ lv_description_var.
          "match encontrado
          lv_matchfnd_var = abap_true.
          "sair do loop
          EXIT.
        ENDIF.
        CLEAR: lv_batchdesc_var.
      ENDLOOP.
      "verificar se encontrou match
      IF lv_matchfnd_var NE abap_true.
        "activar flag de erro
        lv_error_var = abap_true.
      ENDIF.
    ELSE.
      READ TABLE lt_consumptions_tab TRANSPORTING NO FIELDS WITH KEY matnr = <fs_resb_str>-matnr.
      IF sy-subrc NE 0.
        "activar flag de erro
        lv_error_var = abap_true.
      ENDIF.
    ENDIF.

    IF lv_error_var EQ abap_true.
      "sair do loop
      EXIT.
    ENDIF.
    IF lv_batchmgm_var EQ abap_true.
      "verificar se lote não está preenchido
      IF <fs_resb_str>-charg IS INITIAL.
        "lote consumido
        <fs_resb_str>-charg = <fs_comsumptions_str>-charg.
        "adicionar linha para alterar
        APPEND <fs_resb_str> TO et_resb_tab.
      ENDIF.
    ENDIF.
    "limpar variáveis
    CLEAR: lv_description_var, lv_batchmgm_var.
  ENDLOOP.
  IF lv_error_var EQ abap_true.
    "Material &1 &2 não foi consumido
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'E'
        msgno      = 160
        msgv1      = <fs_resb_str>-matnr
        msgv2      = lv_description_var
      CHANGING
        return_tab = et_return_tab.
    RETURN.
  ENDIF.
ENDMETHOD.


METHOD CONSTRUCTOR.
*Ref. Date
  refdt = initial_refdt.

*App input data
  inputobj = input_object.
ENDMETHOD.


method convert_char_value_to_external.
    "limpar variáveis de exportação
    clear ex_atwrt_var.

    data: charactname    type  bapicharactkey-charactname,
          value_from     type  atflv,
          value_to       type  atflb,
          value_relation type  atcod,
          charactdetail  type  bapicharactdetail,
          external       type charactname,
          l_ret          type table of bapiret2.

    call function 'BAPI_CHARACT_GETDETAIL'
      exporting
        charactname   = im_atnam_var
        language      = sy-langu
      importing
        charactdetail = charactdetail
      tables
        return        = l_ret.

    if charactdetail is initial.
      return.
    endif.

    call function 'CTBP_CONVERT_VALUE_INT_TO_EXT'
      exporting
        value_from        = im_atflv_var
        value_to          = im_atflv_var
        value_relation    = '1'
        charactdetail     = charactdetail
      importing
        value_external    = ex_atwrt_var
      exceptions
        charact_not_found = 1
        no_authority      = 2
        wrong_data_type   = 3
        internal_error    = 4
        wrong_input       = 5
        wrong_format      = 6
        others            = 7.
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

  endmethod.


method create_consum_order_subproduct.
    "constantes locais
    constants: lc_coproduct_var type bwart value '531',
               lc_revesercp_var type bwart value '532',
               lc_giprodord_var type bwart value '101'.
*Internal tables
    data: lt_goodsmvt_item     type table of bapi2017_gm_item_create,
          lt_goodsmvt_item_cwm type table of /cwm/bapi2017_gm_item_create.

*Structures
    data: ls_goodsmvt_header   type bapi2017_gm_head_01,
          ls_goodsmvt_code     type bapi2017_gm_code,
          ls_goodsmvt_item     type bapi2017_gm_item_create,
          ls_goodsmvt_headret  type bapi2017_gm_head_ret,
          ls_goodsmvt_item_cwm type /cwm/bapi2017_gm_item_create.

*Variables
    data: l_aufnr            type aufnr,
          l_materialdocument type bapi2017_gm_head_ret-mat_doc,
          l_matdocumentyear  type bapi2017_gm_head_ret-doc_year.

    data: lref_sf_parameters type ref to zabsf_pp_cl_parameters,
          lv_use_cwm         type flag,
          lv_cwm_active      type /cwm/xcwmat,
          lv_lgort           type lgort_d,
          lv_matnr40         type matnr,
          lv_produced_var    type bdmng.

    data: lv_rastro_var       type atnam,
          lv_sequenciador_var type atnam,
          lt_change_chasr_tab type zabsf_pp_tt_batch_charact.


    data: lr_zpp3_101_rng type range of steus,
          lr_zpp3_531_rng type range of steus,
          lv_531matnr_var type matnr,
          lv_531lgort_var type lgort_d.

    refresh lt_goodsmvt_item.

    clear: ls_goodsmvt_item,
           ls_goodsmvt_header,
           ls_goodsmvt_code.

    call function 'CONVERSION_EXIT_ALPHA_INPUT'
      exporting
        input  = aufnr
      importing
        output = l_aufnr.

    try.
        "rastreabiliadade
        call method zcl_bc_fixed_values=>get_single_value
          exporting
            im_paramter_var = zcl_bc_fixed_values=>gc_charrastro_cst
            im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
          importing
            ex_prmvalue_var = data(lv_val_var).
        lv_rastro_var = lv_val_var.

        "sequenciador
        call method zcl_bc_fixed_values=>get_single_value
          exporting
            im_paramter_var = zcl_bc_fixed_values=>gc_charseq_cst
            im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
          importing
            ex_prmvalue_var = lv_val_var.
        lv_sequenciador_var = lv_val_var.
        "obter chaves de controlo geram movimento 101
        zcl_bc_fixed_values=>get_ranges_value( exporting
                                                 im_paramter_var = zcl_bc_fixed_values=>gc_zpp3_101_cst
                                                 im_modulesp_var = zcl_bc_fixed_values=>gc_productn_cst
                                                 im_werksval_var = inputobj-werks
                                               importing
                                                 ex_valrange_tab = lr_zpp3_101_rng  ).
        "obter chaves de controlo geram movimento 531
        zcl_bc_fixed_values=>get_ranges_value( exporting
                                                 im_paramter_var = zcl_bc_fixed_values=>gc_zpp3_531_cst
                                                 im_modulesp_var = zcl_bc_fixed_values=>gc_productn_cst
                                                 im_werksval_var = inputobj-werks
                                               importing
                                                 ex_valrange_tab = lr_zpp3_531_rng  ).
        "material 531
        zcl_bc_fixed_values=>get_single_value( exporting
                                         im_paramter_var = zcl_bc_fixed_values=>gc_zpp3lmatnr_cst
                                         im_modulesp_var = zcl_bc_fixed_values=>gc_productn_cst
                                         im_werksval_var = inputobj-werks
                                       importing
                                         ex_prmvalue_var = data(lv_valuechr_var) ).
        lv_531matnr_var = lv_valuechr_var.
        "depósito 531
        zcl_bc_fixed_values=>get_single_value( exporting
                                 im_paramter_var = zcl_bc_fixed_values=>gc_zpp3lgort_cst
                                 im_modulesp_var = zcl_bc_fixed_values=>gc_productn_cst
                                 im_werksval_var = inputobj-werks
                               importing
                                 ex_prmvalue_var = lv_valuechr_var ).
        lv_531lgort_var = lv_valuechr_var.
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

    "conversão de formatos
    call function 'CONVERSION_EXIT_MATN1_INPUT'
      exporting
        input        = lv_531matnr_var
      importing
        output       = lv_531matnr_var
      exceptions
        length_error = 1
        others       = 2.
    if sy-subrc <> 0.
* Implement suitable error handling here
    endif.

    "obter posto de trabalho
    select single kapid
      from zabsf_pp014
      into @data(lv_workstation_id_var)
        where aufnr eq @l_aufnr
          and vornr eq @components_st-vornr
          and arbpl eq @arbpl
          and oprid eq @inputobj-oprid
          and kapid ne @space
          and status eq 'A'.
    if sy-subrc eq 0.
      select single name
        from kako
        into @data(lv_workstation_var)
          where kapid eq @lv_workstation_id_var.
    endif.

    "obter classificação do lote consumido
    if components_st-consumed_matnr is not initial and
       components_st-consumed_batch is not initial.
      zcl_mm_classification=>get_classification_by_batch( exporting
                                                            im_material_var       = components_st-consumed_matnr
                                                            im_lote_var           = components_st-consumed_batch
                                                          importing
                                                            ex_classification_tab = data(lt_characts_tab) ).
      "caracteristica sequenciador do lote a ser consumido
      read table lt_characts_tab into data(ls_characts_str) with key atnam = lv_sequenciador_var.
      if sy-subrc ne 0.
        "Lote &1 sem valor na caracteristica Rastreabilidade
        call method zabsf_pp_cl_log=>add_message
          exporting
            msgty      = 'E'
            msgno      = '141'
            msgv1      = components_st-consumed_batch
          changing
            return_tab = return_tab.
        "sair do processamento
        return.
      endif.
    endif.

    "verificar qual o movimento que deve ser feito
    select single afko~aufnr, afko~aufpl, afvc~vornr, afvc~steus
      from afko as afko
      inner join afvc as afvc
      on afvc~aufpl eq afko~aufpl
      into @data(ls_operation_str)
      where afko~aufnr eq @l_aufnr
        and afvc~vornr eq @components_st-vornr.
    if ls_operation_str-steus in lr_zpp3_531_rng.
      "activar flag movimento 531
      data(lv_movmt531_var) = abap_true.
    endif.

    "se não for movimento 531, imprime etiqueta
    if lv_movmt531_var ne abap_true.
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
    endif.

*>> SETUP
    create object lref_sf_parameters
      exporting
        initial_refdt = refdt
        input_object  = inputobj.

    call method lref_sf_parameters->get_output_settings
      exporting
        parid           = lref_sf_parameters->c_use_cwm
      importing
        parameter_value = lv_use_cwm
      changing
        return_tab      = return_tab.

    select single *
      from afpo
      into @data(ls_consumed_str)
        where krsnr eq @components_st-rsnum
          and krsps eq @components_st-rspos
          and aufnr eq @aufnr.
    if sy-subrc ne 0.
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgty      = 'E'
          msgno      = '165'
          msgv1      = conv symsgv( components_st-maktx )
        changing
          return_tab = return_tab.
      "sair do processamento
      return.
    endif.

    "verificar se é possivel efectuar 101
    if lv_movmt531_var eq abap_false.
      if components_st-consqty gt ( ls_consumed_str-psmng - ls_consumed_str-wemng ).
        call method zabsf_pp_cl_log=>add_message
          exporting
            msgty      = 'E'
            msgno      = '135'
            msgv1      = conv symsgv( ls_consumed_str-psmng - ls_consumed_str-wemng )
          changing
            return_tab = return_tab.
        "sair do processamento
        return.
      endif.
    else.
      "verificar se é possivel efectuar 531
      select aufm~mblnr, aufm~mjahr, aufm~zeile, aufm~matnr,
             mseg~erfmg, mseg~sgtxt
        from aufm as aufm
        inner join mseg as mseg
          on mseg~mblnr eq aufm~mblnr
         and mseg~mjahr eq aufm~mjahr
         and mseg~zeile eq aufm~zeile
        into table @data(lt_mov531_tab)
          where aufm~aufnr eq @l_aufnr
            and aufm~matnr eq @lv_531matnr_var
            and aufm~lgort eq @lv_531lgort_var
            and aufm~bwart eq @lc_coproduct_var.

      "obter documentos estornados
      if lt_mov531_tab is not initial.
        select *
          from mseg into table @data(lt_mov532_tab)
          for all entries in @lt_mov531_tab
          where aufnr eq @l_aufnr
            and werks eq @inputobj-werks
            and bwart eq @lc_revesercp_var
            and sjahr eq @lt_mov531_tab-mjahr
            and smbln eq @lt_mov531_tab-mblnr
            and smblp eq @lt_mov531_tab-zeile.
        if sy-subrc eq 0.
          "remover os estornados
          loop at lt_mov532_tab into data(ls_mov531_str).
            if line_exists( lt_mov532_tab[ smbln = ls_mov531_str-mblnr
                                           smblp = ls_mov531_str-zeile
                                           sjahr = ls_mov531_str-mjahr ] ).
              "remover documento
              delete lt_mov531_tab.
            endif.
          endloop.
        endif.
      endif.
      "quantidade produzida
*      data(lv_produced_var) =  reduce #( init x type bdmng
*                                         for ls in lt_mov531_tab
*                                         where ( sgtxt = components_st-maktx )
*                                            next x = x + ls-erfmg ).
      clear lv_produced_var.
      loop at lt_mov531_tab into data(ls_mov531_tab)
        where sgtxt = components_st-maktx.
        lv_produced_var = lv_produced_var + ls_mov531_tab-erfmg.
      endloop.

      if components_st-consqty gt ( ls_consumed_str-psmng - lv_produced_var ).
        call method zabsf_pp_cl_log=>add_message
          exporting
            msgty      = 'E'
            msgno      = '135'
            msgv1      = conv symsgv( ls_consumed_str-psmng - lv_produced_var )
          changing
            return_tab = return_tab.
        "sair do processamento
        return.
      endif.
    endif.

*Header of material document
    ls_goodsmvt_header-pstng_date = sy-datlo.
    ls_goodsmvt_header-doc_date = sy-datlo.
    "ls_goodsmvt_header-ref_doc_no = components_st-rsnum.
*Production date
    ls_goodsmvt_item-prod_date = sy-datlo.
*Plant
    ls_goodsmvt_item-plant = inputobj-werks.
*Movement Type
    ls_goodsmvt_item-move_type = cond #( when lv_movmt531_var eq abap_true
                                         then lc_coproduct_var
                                         else lc_giprodord_var ).
    "texto item com ID da peça
    ls_goodsmvt_item-item_text = cond #( when lv_movmt531_var eq abap_true
                                         then components_st-maktx ).
*Production Order
    ls_goodsmvt_item-orderid = l_aufnr.

    if components_st is not initial.
      if components_st-matnr na sy-abcde.
*    Material - Component
        call function 'CONVERSION_EXIT_MATN1_INPUT'
          exporting
            input        = components_st-matnr
          importing
            output       = ls_goodsmvt_item-material
          exceptions
            length_error = 1
            others       = 2.
      else.
        ls_goodsmvt_item-material = components_st-matnr.
      endif.
      "depósito
      select single lgpro from marc into lv_lgort
        where werks eq ls_goodsmvt_item-plant
        and matnr eq ls_goodsmvt_item-material.

      "material
      ls_goodsmvt_item-material = cond #( when lv_movmt531_var eq abap_true
                                          then lv_531matnr_var
                                          else ls_goodsmvt_item-material ).

*  Quantity
      ls_goodsmvt_item-entry_qnt = components_st-consqty.
*  Unit
      ls_goodsmvt_item-entry_uom = components_st-meins.
* Special stock type
      ls_goodsmvt_item-spec_stock = components_st-sobkz.
*  Storage Location
      if components_st-lgort is initial.
        ls_goodsmvt_item-stge_loc = lv_lgort.
      else.
        ls_goodsmvt_item-stge_loc = components_st-lgort.
      endif.
      "depósito
      ls_goodsmvt_item-stge_loc = cond #( when lv_movmt531_var eq abap_true
                                          then lv_531lgort_var
                                          else ls_goodsmvt_item-stge_loc ).

      "nº de lote
      if components_st-batch is initial and lv_movmt531_var eq abap_false.
        "obter próximo nº de lote
        zabsf_pp_cl_tracking=>get_next_batch_numbers( exporting
                                                        im_quantity_var  = 1
                                                        im_skipseq_var   = abap_true
                                                      importing
                                                        ex_batchnum_tab  = data(lt_new_batch_tab)
                                                        ex_errorflag_var = data(lv_errorflg_var)
                                                        et_return_tab    = return_tab ).
        "verificar se ocorreram erros
        if lv_errorflg_var eq abap_true.
          "sair do processamento
          return.
        endif.
        "atribuir novo lote
        ls_goodsmvt_item-batch = lt_new_batch_tab[ 1 ].
      endif.

      "tipo de movimento
      ls_goodsmvt_item-mvt_ind = cond #( when lv_movmt531_var eq abap_false
                                         then 'F' ).

      "nº do item na ordem se for um 101
      if ls_goodsmvt_item-move_type eq lc_giprodord_var.
        select single posnr
          from afpo
          into @ls_goodsmvt_item-order_itno
          where krsnr eq @components_st-rsnum
            and krsps eq @components_st-rspos
            and aufnr eq @aufnr.
      else.
        "preencher elemento PEP
        select single *
          from afpo
          into @data(ls_afpo_str)
            where aufnr eq @l_aufnr
              and projn ne @abap_false
              and xloek eq @abap_false.
        if ls_afpo_str-projn is not initial.
          "conversão de formatos
          call function 'CONVERSION_EXIT_ABPSP_OUTPUT'
            exporting
              input  = ls_afpo_str-projn
            importing
              output = ls_goodsmvt_item-wbs_elem.
          "preencher PEP
          ls_goodsmvt_item-val_wbs_elem = ls_goodsmvt_item-wbs_elem.
        endif.
      endif.

      ls_goodsmvt_code-gm_code = cond #( when lv_movmt531_var eq abap_true
                                         then '05'
                                         else '02' ). "'02 para 101, 05 para 538'
      "BMR FIX tipo de avaliação
      ls_goodsmvt_item-val_type = ls_goodsmvt_item-batch.
      append ls_goodsmvt_item to lt_goodsmvt_item.
    endif.

*Create consumption of the Production Order
    call function 'BAPI_GOODSMVT_CREATE'
      exporting
        goodsmvt_header  = ls_goodsmvt_header
        goodsmvt_code    = ls_goodsmvt_code
      importing
        goodsmvt_headret = ls_goodsmvt_headret
        materialdocument = l_materialdocument
        matdocumentyear  = l_matdocumentyear
      tables
        goodsmvt_item    = lt_goodsmvt_item
        return           = return_tab.

    if return_tab[] is initial.
      "dados adicionais
      data(ls_addinfo_str) = value zabsf_pp083( mblnr       = l_materialdocument
                                                mjahr       = l_matdocumentyear
                                                aufnr       = l_aufnr
                                                arbpl       = arbpl
                                                vornr       = components_st-vornr
                                                workstation = lv_workstation_var ).
      "inserir registo na BD
      insert zabsf_pp083 from ls_addinfo_str.
      "commit da operação
      call function 'BAPI_TRANSACTION_COMMIT'
        exporting
          wait = 'X'.
      "se for movimento 531 não executa mais etapas do processo
      if lv_movmt531_var eq abap_true.
        "sair do processamento
        return.
      endif.
      "aguardar pelo registo na mseg
      do 20 times.
        "obter dados do item do documento
        select single *
          from mseg
          into @data(ls_mseg_str)
            where mblnr eq @l_materialdocument
              and mjahr eq @l_matdocumentyear
              and charg ne @space.
        if sy-subrc ne 0.
          wait up to '0.2' seconds.
        else.
          "sair do DO
          exit.
        endif.
      enddo.
      if ls_mseg_str-charg is not initial.
        "lista de caracteristicas a alterar
        append value #( atnam = lv_rastro_var
                        atwrt = ls_characts_str-ausp1 ) to lt_change_chasr_tab.
        "copiar caracteristicas para o novo lote
        zabsf_pp_cl_tracking=>copy_chars_to_new_batch( exporting
                                                         it_charstab_tab = lt_change_chasr_tab
                                                         im_newbatch_var = ls_mseg_str-charg
                                                         im_material_var = ls_mseg_str-matnr
                                                       importing
                                                         ex_return_tab   = return_tab ).
      endif.
*  Send message sucess.
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgty      = 'S'
          msgno      = '034'
          msgv1      = l_materialdocument
        changing
          return_tab = return_tab.

      "obter a descrição do material
      zcl_mm_classification=>get_material_desc_by_batch( exporting
                                                           im_material_var    = components_st-matnr
                                                           im_batch_var       = ls_mseg_str-charg
                                                         importing
                                                           ex_description_var = data(lv_matrdesc_var) ).
      read table lt_goodsmvt_item into data(ls_goodmvmt_str) index 1.
      "dados da etiqueta
      data(ls_newlabel_str) = value zpp_labels_t( rueck = space
                                                  rmzhl = space
                                                  mblnr = l_materialdocument
                                                  mjahr = l_matdocumentyear
                                                  aufnr = aufnr
                                                  arbpl = space
                                                  werks = ls_goodmvmt_str-plant
                                                  charg = ls_mseg_str-charg
                                                  matnr = ls_goodmvmt_str-material
                                                  maktx = lv_matrdesc_var
                                                  pspnr = ls_goodmvmt_str-wbs_elem
                                                  menge = ls_goodmvmt_str-entry_qnt
                                                  meins = 'UN' "ls_goodmvmt_str-entry_uom
                                                  uname = inputobj-oprid
                                                  aedat = sy-datum
                                                  tims  = sy-uzeit
                                                  lifnr = |{ vendor alpha = in }|
                                                  label_from  = components_st-confirmed_qtt + 1
                                                  label_to    = components_st-required_qtt ).
      modify zpp_labels_t from ls_newlabel_str.
      "lançar impressão
      if vendor is not initial.
        "impressão fornecedor
        zabsf_pp_cl_print=>vendor_pp_label_process( exporting
                                                      im_newlabel_str = ls_newlabel_str
                                                      im_aufnrval_var = |{ ls_newlabel_str-aufnr alpha = in }|
                                                      im_quantity_var = conv #( ls_newlabel_str-menge )
                                                    changing
                                                      ch_return_tab   = return_tab ).
      else.
        "impressão normal
        zabsf_pp_cl_print=>dst_print_pp_label( exporting
                                                 im_soldador_var = inputobj-oprid
                                                 im_workcent_var = arbpl
                                                 im_newlabel_str = ls_newlabel_str
                                               changing
                                                 ch_return_tab   = return_tab ).
      endif.
    endif.
  endmethod.


method create_devolution_batch.
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
    "tipo de avaliação
    select SINGLE bwtar
      from mcha
      into @ls_batch_create-bwtar
        where charg eq @im_refbatch_var.
    " ls_batch_create-bwtar = im_refbatch_var.
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
*  Send message sucess.

  endmethod.


method get_hu_components.
* Funcionamento:
* Leitura de dados da Palete na LQUA. A Storage Unit que
* é lida no shopfloor, identifica de forma univoca a palete no sistema.
* A numeração das SU é diferente para os armazens, garantindo que não
* existem nºs de SU repetidos.

    data lref_sf_consum type ref to zabsf_pp_cl_consumptions.

    data: lv_hu           type exidv,
          lv_vornr        type vornr,
          lv_langu        type spras,
          ls_component    like line of components_tab,
          lv_consume_mvmt type bwart,
          lt_consumptions type zabsf_pp_t_components,
          ls_aux          like line of components_tab.


    data: lv_lgtyp type lgtyp,
          lv_lgpla type lgpla.

    data: lt_consumos  type zabsf_pp_t_components.

    data: val_erfmg      type erfmg,
          val_erfme      type erfme value 'KI',
          val_/cwm/erfmg type /cwm/erfmg,
          val_/cwm/erfme type /cwm/erfme value 'KG',
          lv_matnr       type matnr.
*    data: peso_medio type ref to /cwm/cl_quan_prpsl.

*Get class of interface
    select single imp_clname, methodname
        from zabsf_pp003
        into (@data(l_class), @data(l_method))
       where werks    eq @inputobj-werks
         and id_class eq '8'
         and endda    ge @refdt
         and begda    le @refdt.

    create object lref_sf_consum
      exporting
        initial_refdt = refdt
        input_object  = inputobj.

    call function 'CONVERSION_EXIT_ALPHA_INPUT'
      exporting
        input  = hu
      importing
        output = lv_hu.

    select single parva from zabsf_pp032 into lv_consume_mvmt
      where werks eq inputobj-werks
      and parid = 'CONSUME_MVMT'.

    if sy-subrc ne 0.

      call method zabsf_pp_cl_log=>add_message
        exporting
          msgty      = 'E'
          msgno      = '108'
        changing
          return_tab = return_tab.
      exit.
    endif.


    select single parva from zabsf_pp032 into lv_lgtyp
      where werks eq inputobj-werks
      and parid = 'SUPPLYMENT_LGTYP'.

    if sy-subrc ne 0.

      call method zabsf_pp_cl_log=>add_message
        exporting
          msgty      = 'E'
          msgno      = '118'
        changing
          return_tab = return_tab.
      exit.
    endif.


    select single parva from zabsf_pp032 into lv_lgpla
      where werks eq inputobj-werks
      and parid = 'SUPPLYMENT_LGPLA'.

    if sy-subrc ne 0.

      call method zabsf_pp_cl_log=>add_message
        exporting
          msgty      = 'E'
          msgno      = '119'
        changing
          return_tab = return_tab.
      exit.
    endif.

*Leitura de dados no LQUA
    select * from lqua into table  @data(lt_lqua)
      where lenum eq @lv_hu
      and werks eq @inputobj-werks
      and lgtyp eq @lv_lgtyp
      and lgpla eq @lv_lgpla.

    if sy-subrc ne 0.

      call method zabsf_pp_cl_log=>add_message
        exporting
          msgty      = 'E'
          msgno      = '110'
        changing
          return_tab = return_tab.

      exit.
    endif.

    check lt_lqua is not initial.

    call method lref_sf_consum->(l_method)
      exporting
        aufnr           = aufnr
        vornr           = lv_vornr
        for_subproducts = abap_false
      changing
        components_tab  = lt_consumos
        return_tab      = return_tab.

*Descrição do material
    move sy-langu to lv_langu.

    select * from makt into table @data(lt_makt)
      for all entries in @lt_lqua
      where matnr eq @lt_lqua-matnr
      and spras eq @lv_langu.

    loop at lt_lqua into data(ls_lqua).

      ls_component-matnr = ls_lqua-matnr.
      ls_component-lgort = ls_lqua-lgort.
      ls_component-batch = ls_lqua-charg.
      if ls_lqua-meins ne 'KG'.
*      ls_component-meins = ls_lqua-meins.
*      ls_component-bdmng = ls_lqua-verme.
*
*        select single /cwm/xcwmat from mara into @data(lv_xcwmat)
*          where matnr = @ls_lqua-matnr.

        "ajustes DST 04.03.2020
        data lv_xcwmat(1).

        select single * from marm into @data(ls_marm)
          where matnr = @ls_lqua-matnr
            and meinh = 'KG'.

        if lv_xcwmat eq 'X'.
*          CLEAR val_erfmg.
          val_erfmg = ls_lqua-verme.
*          val_/cwm/erfme = ls_lqua-MEINS.

*          create object peso_medio.
*
*          lv_matnr = ls_lqua-matnr.
*          call method peso_medio->propose_from_stock_for_batch
*            exporting
*              iv_matnr                     = lv_matnr
*              iv_plant                     = ls_lqua-werks
*              iv_storage_location          = ls_lqua-lgort
*              iv_batch                     = ls_lqua-charg
*              iv_cwm_q_fields_changed      = space
*              iv_logistic_q_fields_changed = space
*            changing
*              cv_erfmg                     = val_erfmg
*              cv_erfme                     = val_erfme
*              cv_/cwm/erfmg                = val_/cwm/erfmg
*              cv_/cwm/erfme                = val_/cwm/erfme.

*          IF val_erfmg < 1.
*            val_erfmg = 1.
*          ELSE.
*            CALL FUNCTION 'ROUND'
*              EXPORTING
*                decimals      = 0
*                input         = val_erfmg
*                sign          = '+'
*              IMPORTING
*                output        = val_erfmg
*              EXCEPTIONS
*                input_invalid = 1
*                overflow      = 2
*                type_invalid  = 3
*                OTHERS        = 4.
*            IF sy-subrc <> 0.
** Implement suitable error handling here
*            ENDIF.
*          ENDIF.

          ls_component-meins = val_/cwm/erfme. "val_erfme.
          ls_component-bdmng = val_/cwm/erfmg. "val_erfmg.

        else.
          ls_component-meins = ls_marm-meinh.
          ls_component-bdmng = ls_lqua-verme * ls_marm-umren / ls_marm-umrez.

        endif.
      else.
        ls_component-meins = ls_lqua-meins.
        ls_component-bdmng = ls_lqua-verme.
      endif.
* Descrião do material
      read table lt_makt into data(ls_makt) with key matnr = ls_lqua-matnr.
      if sy-subrc eq 0.
        ls_component-maktx = ls_makt-maktx.
      endif.

      read table lt_consumos transporting no fields with key matnr = ls_lqua-matnr.
      if sy-subrc eq 0.
        append ls_component to components_tab.
      endif.

      clear ls_component.
    endloop.

    if lt_lqua is not initial and components_tab is initial.
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgty      = 'E'
          msgno      = '121'
        changing
          return_tab = return_tab.
      exit.
    endif.

  endmethod.


METHOD get_mulitmaterial_components.
  "constantes locais
  CONSTANTS: lc_coproduct_var TYPE bwart VALUE '531',
             lc_revesercp_var TYPE bwart VALUE '532'.
*Structures
  DATA: ls_components TYPE zabsf_pp_s_components,
        lr_text_rng   TYPE RANGE OF sgtxt.

*Variables
  DATA: l_aufnr         TYPE aufnr,
        l_vornr         TYPE vornr,
        lv_531matnr_var TYPE matnr,
        lv_531lgort_var TYPE lgort_d.

  DATA: lr_zpp3_101_rng TYPE RANGE OF steus,
        lr_zpp3_531_rng TYPE RANGE OF steus.



  TRY.
      "obter chaves de controlo geram movimento 101
      zcl_bc_fixed_values=>get_ranges_value( EXPORTING
                                               im_paramter_var = zcl_bc_fixed_values=>gc_zpp3_101_cst
                                               im_modulesp_var = zcl_bc_fixed_values=>gc_productn_cst
                                               im_werksval_var = inputobj-werks
                                             IMPORTING
                                               ex_valrange_tab = lr_zpp3_101_rng  ).
      "obter chaves de controlo geram movimento 531
      zcl_bc_fixed_values=>get_ranges_value( EXPORTING
                                               im_paramter_var = zcl_bc_fixed_values=>gc_zpp3_531_cst
                                               im_modulesp_var = zcl_bc_fixed_values=>gc_productn_cst
                                               im_werksval_var = inputobj-werks
                                             IMPORTING
                                               ex_valrange_tab = lr_zpp3_531_rng  ).
      "material 531
      zcl_bc_fixed_values=>get_single_value( EXPORTING
                                       im_paramter_var = zcl_bc_fixed_values=>gc_zpp3lmatnr_cst
                                       im_modulesp_var = zcl_bc_fixed_values=>gc_productn_cst
                                       im_werksval_var = inputobj-werks
                                     IMPORTING
                                       ex_prmvalue_var = DATA(lv_valuechr_var) ).
      lv_531matnr_var = lv_valuechr_var.
      "depósito 531
      zcl_bc_fixed_values=>get_single_value( EXPORTING
                               im_paramter_var = zcl_bc_fixed_values=>gc_zpp3lgort_cst
                               im_modulesp_var = zcl_bc_fixed_values=>gc_productn_cst
                               im_werksval_var = inputobj-werks
                             IMPORTING
                               ex_prmvalue_var = lv_valuechr_var ).
      lv_531lgort_var = lv_valuechr_var.

    CATCH zcx_pp_exceptions INTO DATA(lo_bcexceptions_obj).
      "falta configuração
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = lo_bcexceptions_obj->msgty
          msgno      = lo_bcexceptions_obj->msgno
          msgid      = lo_bcexceptions_obj->msgid
          msgv1      = lo_bcexceptions_obj->msgv1
          msgv2      = lo_bcexceptions_obj->msgv2
          msgv3      = lo_bcexceptions_obj->msgv3
          msgv4      = lo_bcexceptions_obj->msgv4
        CHANGING
          return_tab = return_tab.
      RETURN.
  ENDTRY.
  "conversão de formatos
  CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
    EXPORTING
      input        = lv_531matnr_var
    IMPORTING
      output       = lv_531matnr_var
    EXCEPTIONS
      length_error = 1
      OTHERS       = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

*Convert to input format
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = aufnr
    IMPORTING
      output = l_aufnr.

*Convert to INPUT FORMAT
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = vornr
    IMPORTING
      output = l_vornr.

*  Get work center
  SELECT SINGLE crhd~arbpl
    FROM afko AS afko
   INNER JOIN afvc AS afvc
      ON afvc~aufpl EQ afko~aufpl
   INNER JOIN crhd AS crhd
      ON crhd~objty EQ 'A'
     AND crhd~objid EQ afvc~arbid
   WHERE afko~aufnr EQ @l_aufnr
     AND afvc~vornr EQ @l_vornr
     AND afvc~werks EQ @inputobj-werks
    INTO (@DATA(lv_arbpl)).

* Get data from Order
  SELECT SINGLE *
    FROM aufk
    INTO @DATA(ls_aufk)
    WHERE aufnr EQ @l_aufnr.

* Get Work center type
  SELECT SINGLE arbpl_type
    FROM zabsf_pp013
    INTO (@DATA(l_arbplty))
   WHERE areaid EQ @inputobj-areaid
     AND werks  EQ @ls_aufk-werks
     AND arbpl  EQ @lv_arbpl.

* Not Repacking
  IF ( l_arbplty <> 'R' ).

*Get reserv number
    SELECT SINGLE rsnum, plnbez
      FROM afko
      INTO ( @DATA(l_rsnum), @DATA(lv_mathead_var) )
     WHERE aufnr EQ @l_aufnr.

    IF l_vornr IS INITIAL.
*  Get Reservation/dependent requirements
      SELECT *
        FROM resb
        INTO TABLE @DATA(lt_resb)
       WHERE rsnum EQ @l_rsnum
         AND aufnr EQ @l_aufnr
         AND werks EQ @inputobj-werks
         AND xloek EQ @space
         AND shkzg EQ 'S' "sinal negativo
         AND matnr NE @lv_mathead_var.
*       AND rgekz NE @space.
    ELSE.
      REFRESH lt_resb.

*  Get Reservation/dependent requirements
      SELECT *
        FROM resb
        INTO TABLE @lt_resb
       WHERE rsnum EQ @l_rsnum
         AND aufnr EQ @l_aufnr
         AND vornr EQ @l_vornr
         AND werks EQ @inputobj-werks
         AND xloek EQ @space
         AND shkzg EQ 'S' "sinal negativo
         AND matnr NE @lv_mathead_var.
      "      AND rgekz NE @space "BMR COMMENT 07.04.2020
    ENDIF.

    "verificar se não existem items n reserva
    IF lt_resb IS INITIAL.
      "obter a operação de entrada de mercadoria
      SELECT SINGLE afko~aufnr, afvc~vornr, afvc~steus
        FROM afko AS afko
        INNER JOIN afvc AS afvc
        ON afvc~aufpl EQ afko~aufpl
            INTO @DATA(ls_operation_str)
        WHERE afko~aufnr EQ @aufnr
          AND afvc~loekz EQ @space
          AND afvc~steus IN @lr_zpp3_101_rng .
      IF sy-subrc EQ 0.
        "obter os items reservados para a operação de entrada de mercadoria
        SELECT *
          FROM resb
          INTO TABLE @lt_resb
         WHERE rsnum EQ @l_rsnum
           AND aufnr EQ @l_aufnr
           AND vornr EQ @ls_operation_str-vornr
           AND werks EQ @inputobj-werks
           AND xloek EQ @space
           AND shkzg EQ 'S'. "sinal negativo
      ENDIF.
    ENDIF.

    IF lt_resb IS NOT INITIAL.
      "dados da operação
      SELECT SINGLE afko~aufnr, afvc~vornr, afvc~steus
        FROM afko AS afko
        INNER JOIN afvc AS afvc
        ON afvc~aufpl EQ afko~aufpl
            INTO @ls_operation_str
        WHERE afko~aufnr EQ @aufnr
          AND afvc~vornr EQ @vornr
          AND afvc~loekz EQ @space.
      "verificar chave de operação
      IF ls_operation_str-steus IN lr_zpp3_531_rng.
        "activar flag quantidade dos 531
        DATA(lv_sum531_var) = abap_true.
        "obter material do configurador
        LOOP AT lt_resb ASSIGNING FIELD-SYMBOL(<fs_resb>).
          "material
          zcl_mm_classification=>get_desc_as_co02( EXPORTING
                                                     im_resb_str        = <fs_resb>
                                                   IMPORTING
                                                     ex_description_var = DATA(lv_material_var) ).
          "adicionar material ao range
          IF lv_material_var IS NOT INITIAL.
            APPEND VALUE #( sign   = 'I'
                            option = 'EQ'
                            low    = lv_material_var
                            high   = space )  TO lr_text_rng.
          ENDIF.
          "limpar variáveis
          CLEAR lv_material_var.
        ENDLOOP.

        "obter os movimentos 531
        SELECT aufm~mblnr, aufm~mjahr, aufm~zeile, aufm~matnr,
               mseg~erfmg, mseg~sgtxt
          FROM aufm AS aufm
          INNER JOIN mseg AS mseg
            ON mseg~mblnr EQ aufm~mblnr
           AND mseg~mjahr EQ aufm~mjahr
           AND mseg~zeile EQ aufm~zeile
          INTO TABLE @DATA(lt_mov531_tab)
            WHERE aufm~aufnr EQ @l_aufnr
              AND aufm~matnr EQ @lv_531matnr_var
              AND aufm~lgort EQ @lv_531lgort_var
              AND aufm~bwart EQ @lc_coproduct_var
              AND mseg~sgtxt IN @lr_text_rng.

        "obter documentos estornados
        IF lt_mov531_tab IS NOT INITIAL.
          SELECT *
            FROM mseg INTO TABLE @DATA(lt_mov532_tab)
            FOR ALL ENTRIES IN @lt_mov531_tab
            WHERE aufnr EQ @l_aufnr
              AND werks EQ @inputobj-werks
              AND bwart EQ @lc_revesercp_var
              AND sjahr EQ @lt_mov531_tab-mjahr
              AND smbln EQ @lt_mov531_tab-mblnr
              AND smblp EQ @lt_mov531_tab-zeile.
          IF sy-subrc EQ 0.
            "remover os estornados
            LOOP AT lt_mov532_tab INTO DATA(ls_mov531_str).
              IF line_exists( lt_mov532_tab[ smbln = ls_mov531_str-mblnr
                                             smblp = ls_mov531_str-zeile
                                             sjahr = ls_mov531_str-mjahr ] ).
                "remover documento
                DELETE lt_mov531_tab.
              ENDIF.
            ENDLOOP.
          ENDIF.
        ENDIF.
      ENDIF.

*  Get material with Batch management requirement indicator
      SELECT matnr, xchpf
        FROM mara
        INTO TABLE @DATA(lt_mara)
         FOR ALL ENTRIES IN @lt_resb
       WHERE matnr EQ @lt_resb-matnr.
*       AND xchpf EQ @abap_true.

*  Get material description for all components
      SELECT *
        FROM makt
        INTO TABLE @DATA(lt_makt)
         FOR ALL ENTRIES IN @lt_resb
       WHERE matnr EQ @lt_resb-matnr
         AND spras EQ @sy-langu.

*  Fill data to shopfloor
      LOOP AT lt_resb ASSIGNING <fs_resb>.
        "material
        zcl_mm_classification=>get_desc_as_co02( EXPORTING
                                                   im_resb_str        = <fs_resb>
                                                 IMPORTING
                                                   ex_description_var = lv_material_var ).
        CLEAR ls_components.
*  Reservation number
        ls_components-rsnum = <fs_resb>-rsnum.
*  Reservation item
        ls_components-rspos = <fs_resb>-rspos.
*  Special stock type
        ls_components-sobkz = <fs_resb>-sobkz.
* object id
        ls_components-cuobj = <fs_resb>-cuobj.
*    Check Batch management requirement indicator
        READ TABLE lt_mara INTO DATA(ls_mara) WITH KEY matnr = <fs_resb>-matnr.

        IF sy-subrc EQ 0.
*      Material
          ls_components-matnr = <fs_resb>-matnr.
*      Material description
          READ TABLE lt_makt INTO DATA(ls_makt) WITH KEY matnr = <fs_resb>-matnr.

          IF sy-subrc EQ 0.
            ls_components-maktx = ls_makt-maktx.
          ENDIF.
          IF lv_sum531_var EQ abap_true.
            "quantidade a produzir
            ls_components-bdmng = <fs_resb>-bdmng.
            "quantidade produzida
            ls_components-enmng = REDUCE #( INIT x TYPE bdmng
                                            FOR ls IN lt_mov531_tab
                                            WHERE ( sgtxt = lv_material_var )
                                            NEXT x = x + ls-erfmg ).
            IF <fs_resb>-shkzg EQ 'S'.
              ls_components-bdmng = ls_components-bdmng * -1.
            ENDIF.

            "quantidade em falta
            ls_components-consqty = <fs_resb>-bdmng - ls_components-enmng.
          ELSE.

*    Quantity produced
            ls_components-bdmng = <fs_resb>-erfmg.
*    Negative quantity
            IF <fs_resb>-shkzg EQ 'S'.
              ls_components-bdmng = ls_components-bdmng * -1.
            ENDIF.

*      Quantity missing
            ls_components-consqty = <fs_resb>-erfmg - <fs_resb>-enmng.
*      Unit
          ENDIF.

*          ls_components-meins = ls_resb-meins.
          ls_components-meins = <fs_resb>-erfme.
*      Storage Location
          ls_components-lgort = <fs_resb>-lgort.

*      Operation number
          ls_components-vornr = <fs_resb>-vornr.


          IF l_vornr IS NOT INITIAL AND ls_mara-xchpf EQ abap_true.
            APPEND ls_components TO components_tab.
          ENDIF.

          IF l_vornr IS INITIAL.
*        Batch management requirement indicator
            ls_components-xchpf = ls_mara-xchpf.

            APPEND ls_components TO components_tab.
          ENDIF.
        ENDIF.
        "limpar variáveis
        CLEAR lv_material_var.
      ENDLOOP.

*  Get work center
      SELECT SINGLE crhd~arbpl
        FROM afko AS afko
       INNER JOIN afvc AS afvc
          ON afvc~aufpl EQ afko~aufpl
       INNER JOIN crhd AS crhd
          ON crhd~objty EQ 'A'
         AND crhd~objid EQ afvc~arbid
       WHERE afko~aufnr EQ @l_aufnr
         AND afvc~vornr EQ @l_vornr
         AND afvc~werks EQ @inputobj-werks
        INTO (@DATA(l_arbpl)).

    ELSE.
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'I'
          msgno      = '018'
        CHANGING
          return_tab = return_tab.

    ENDIF.
  ENDIF.
  CLEAR ch_orderqtt_var.

  "obter items da ordem
  IF components_tab IS NOT INITIAL.
    SELECT *
      FROM afpo
      INTO TABLE @DATA(lt_afpo_tab)
      FOR ALL ENTRIES IN @components_tab
      WHERE krsnr EQ @components_tab-rsnum
        AND krsps EQ @components_tab-rspos
        AND aufnr EQ @aufnr.
  ENDIF.
  LOOP AT components_tab ASSIGNING FIELD-SYMBOL(<fs_components>).
    "obter descrição do componente
    zcl_mm_classification=>get_material_desc_by_object( EXPORTING
                                                          im_cuobj_var       = <fs_components>-cuobj
                                                        IMPORTING
                                                          ex_description_var = DATA(lv_descript_var) ).
    "descrição
    IF lv_descript_var IS NOT INITIAL.
      <fs_components>-maktx = lv_descript_var.
    ENDIF.
    "obter item da ordem
    READ TABLE lt_afpo_tab INTO DATA(ls_afpo_str) WITH KEY krsnr = <fs_components>-rsnum
                                                           krsps = <fs_components>-rspos.
    IF sy-subrc EQ 0 AND lv_sum531_var EQ abap_false.
      <fs_components>-consqty = abs( ls_afpo_str-psmng - ls_afpo_str-wemng ).
      "a produzir
      ch_orderqtt_var = ch_orderqtt_var + abs( ls_afpo_str-psmng ).
      "produzida
      ch_produced_var = ch_produced_var + abs( ls_afpo_str-wemng ).
    ELSE.
      "a produzir
      ch_orderqtt_var = ch_orderqtt_var + abs( ls_afpo_str-psmng ).
      "produzida
      ch_produced_var = ch_produced_var + abs( <fs_components>-enmng ).
      "limpar variável
      CLEAR <fs_components>-enmng.
    ENDIF.
  ENDLOOP.
  "qtd em falta
  ch_missing_var = ch_orderqtt_var - ch_produced_var.
ENDMETHOD.


method get_possible_devolutions.
      types: begin of ty_dev,
               matnr        type  matnr,
               maktx        type  maktx,
               bdmng        type  bdmng,
               enmng        type  enmng,
               consqty      type  zabsf_pp_e_consqty,
               meins        type  meins,
               lgort        type  lgort_d,
               rsnum        type  rsnum,
               rspos        type  rspos,
               vornr        type  vornr,
               batch        type  charg_d,
               xchpf        type  xchpf,
               verme        type  lqua_verme,
               processed    type  zabsf_pp_e_consproc,
               meins_output type  meins,
               cuobj        type  cuobj,
               stck_type    type  mb_insmk,
               sobkz        type  sobkz,
             end of ty_dev.

      data: lt_components_tab type table of ty_dev,
            lt_lines          type table of tline.

*Variables
      data: l_aufnr            type aufnr,
            lv_consume_mvmt    type bwart,
            lv_devolution_mvmt type bwart.

*Internal tables
      data: lt_consumptions type table of aufm,
            lt_devolutions  type table of mseg,
            ls_aux          type ty_dev,
            lr_charac_tab   type range of atnam.
*Variables
      data: lv_spras          type spras,
            lv_xcwmat         type /cwm/xcwmat,
            lv_xchpf          type xchpf,
            lv_charcomp_var   type atnam,
            lv_charkgun_var   type atnam,
            lv_classchapa_var type klasse_d.
*Range
      data: lr_mov type range of bwart,
            ls_mov like line of lr_mov.

*      data: lr_rsnum_rng type range of rsnum,
*            lr_rspos_rng type range of rspos.

      data: lr_matnr_rng type range of matnr.

      move sy-langu to lv_spras.
      set locale language lv_spras.
*Convert to input format
      call function 'CONVERSION_EXIT_ALPHA_INPUT'
        exporting
          input  = aufnr
        importing
          output = l_aufnr.

      select single parva from zabsf_pp032 into lv_consume_mvmt
        where werks eq inputobj-werks
        and parid = 'CONSUME_MVMT'.

      if sy-subrc ne 0.

        call method zabsf_pp_cl_log=>add_message
          exporting
            msgty      = 'E'
            msgno      = '108'
          changing
            return_tab = return_tab.
        exit.
      endif.

      select single parva from zabsf_pp032 into lv_devolution_mvmt
        where werks eq inputobj-werks
        and parid = 'DEVOLUTION_MVMT'.

      if sy-subrc ne 0.

        call method zabsf_pp_cl_log=>add_message
          exporting
            msgty      = 'E'
            msgno      = '116'
          changing
            return_tab = return_tab.
        exit.
      endif.

      "obter reservas da operação
      select *
        from resb
        into table @data(lt_resb_tab)
          where aufnr eq @aufnr
            and vornr eq @vornr
            and matnr ne @space.
      if sy-subrc ne 0.
        return.
      endif.

      loop at lt_resb_tab into data(ls_resb).
        append value #( sign   = 'I'
                        option = 'EQ'
                        low    = ls_resb-matnr ) to lr_matnr_rng.

      endloop.
* get consumptions
      select * from aufm into table lt_consumptions
        where aufnr eq l_aufnr
        and werks eq inputobj-werks
        and bwart eq lv_consume_mvmt
        and matnr in lr_matnr_rng.

* get devolutions
*      select *
*        from aufm into table lt_devolutions
*        where aufnr eq l_aufnr
*        and werks eq inputobj-werks
*        and bwart eq lv_devolution_mvmt
*        and matnr in lr_matnr_rng.

      "obter documentos estornados
      if lt_consumptions is not initial.
        select *
          from mseg into table lt_devolutions
          for all entries in lt_consumptions
          where aufnr eq l_aufnr
          and werks eq inputobj-werks
          and bwart eq lv_devolution_mvmt
          and smbln eq lt_consumptions-mblnr
          and smblp eq lt_consumptions-zeile.
        if sy-subrc eq 0.
          "remover os estornados
          loop at lt_consumptions into data(ls_consumo_str).
            if line_exists( lt_devolutions[ smbln = ls_consumo_str-mblnr
                                            smblp = ls_consumo_str-zeile ] ).
              delete lt_consumptions.
            endif.
          endloop.
        endif.
      endif.

* Collect data
      loop at lt_consumptions into data(ls_com).
        move-corresponding ls_com to ls_aux.
        ls_aux-batch = ls_com-charg.

*      SELECT SINGLE /cwm/xcwmat FROM mara INTO @DATA(lv_xcwmat)
*        WHERE matnr = @ls_com-matnr.
        select single xchpf  from mara into (lv_xchpf)
          where matnr = ls_com-matnr.
        if lv_xcwmat = 'X'.
*        ls_aux-consqty = ls_com-/cwm/menge.
*        ls_aux-meins = ls_com-/cwm/meins.
        else.
          ls_aux-consqty = ls_com-erfmg. "ls_com-menge.
          ls_aux-meins = ls_com-erfme.
        endif.
        ls_aux-xchpf = lv_xchpf.
        collect ls_aux into lt_components_tab.
        clear: ls_com, ls_aux.
      endloop.

*      loop at lt_devolutions into data(ls_dev).
*
*        move-corresponding ls_dev to ls_aux.
*        ls_aux-batch = ls_dev-charg.
*        select single xchpf from mara into (lv_xchpf)
*    where matnr = ls_dev-matnr.
*        if lv_xcwmat = 'X'.
**        ls_aux-bdmng = ls_dev-/cwm/menge.
**        ls_aux-meins = ls_dev-/cwm/meins.
*        else.
*          ls_aux-bdmng = ls_dev-erfmg. "ls_dev-menge.
*          ls_aux-meins = ls_dev-erfme.
*        endif.
*        ls_aux-xchpf = lv_xchpf.
*        collect ls_aux into lt_components_tab.
*        clear: ls_dev, ls_aux.
*      endloop.

      if lt_components_tab is initial.
*send Error message?
        call method zabsf_pp_cl_log=>add_message
          exporting
            msgty      = 'E'
            msgno      = '117'
          changing
            return_tab = return_tab.
        exit.
      endif.

      components_tab = corresponding #( lt_components_tab ).

* Material description
      select * from makt into table @data(lt_makt)
        for all entries in @components_tab
        where matnr eq @components_tab-matnr
        and spras eq @sy-langu.

      "obter configuração de caracteristicas a alterar
      try.
          call method zcl_bc_fixed_values=>get_ranges_value
            exporting
              im_paramter_var = zcl_bc_fixed_values=>gc_develct_cst
              im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
            importing
              ex_valrange_tab = lr_charac_tab.

          "obter classe chapas
          call method zcl_bc_fixed_values=>get_single_value
            exporting
              im_paramter_var = zcl_bc_fixed_values=>gc_chapadevl_cst
              im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
            importing
              ex_prmvalue_var = data(lv_charname_var).

          lv_classchapa_var = lv_charname_var.
        catch zcx_pp_exceptions .
      endtry.

      loop at components_tab assigning field-symbol(<fs_tab>).
        <fs_tab>-vornr = vornr.
        read table lt_makt into data(ls_makt) with key matnr = <fs_tab>-matnr.
        if sy-subrc eq 0.
          <fs_tab>-maktx = ls_makt-maktx.
        endif.
* material comsumption
        <fs_tab>-consqty = abs( <fs_tab>-consqty ) - abs( <fs_tab>-bdmng ).
        <fs_tab>-consqty = abs( <fs_tab>-consqty ).

        "obter caracteristicas do lote
        if <fs_tab>-batch is not initial
          and lr_charac_tab is not initial.
          "obter classificação do lote
          zcl_mm_classification=>get_classification_by_batch( exporting
                                                                im_material_var       = <fs_tab>-matnr
                                                                im_lote_var           = <fs_tab>-batch
                                                                im_shownull_var       = abap_true
                                                              importing
                                                                ex_classification_tab = data(lt_charact_tab)
                                                                ex_class_tab          = data(lt_class_tab) ).
          "mapear tabela
          <fs_tab>-characteristics  = value #( for ls_char in lt_charact_tab
                                                where ( atnam in lr_charac_tab )
                                                ( atnam = ls_char-atnam
                                                  atwrt = ls_char-ausp1
                                                  smbez = ls_char-smbez
                                                  atflv = ls_char-atflv
                                                  dime1 = ls_char-dime2 ) ).
*          "obter item da ordem
*          select single *
*            from resb
*            into @data(ls_resb_str)
*              where matnr eq @<fs_tab>-matnr
*                and aufnr eq @aufnr.
*
*          data lv_textname_var type tdobname.
*          lv_textname_var = |{ sy-mandt }{ ls_resb_str-rsnum }{ ls_resb_str-rspos }|.
*          "obter texto do item
*          call function 'READ_TEXT'
*            exporting
*              id                      = 'MATK'
*              language                = sy-langu
*              name                    = lv_textname_var
*              object                  = 'AUFK'
*            tables
*              lines                   = lt_lines
*            exceptions
*              id                      = 1
*              language                = 2
*              name                    = 3
*              not_found               = 4
*              object                  = 5
*              reference_check         = 6
*              wrong_access_to_archive = 7
*              others                  = 8.
*          if sy-subrc <> 0.
** Implement suitable error handling here
*          endif.
*
*          "remover linhas em branco
*          delete lt_lines where tdline eq space.
*
*          read table lt_class_tab into data(ls_class_str) with key klart = '023'.
*          if sy-subrc eq 0.
*            call method zabsf_pp_cl_consumptions=>calculate_char_value_from_text
*              exporting
*                it_lines_tab    = lt_lines
*                im_chapas_var   = cond #( when ls_class_str-class eq lv_classchapa_var
*                                          then abap_true
*                                          else abap_false )
*              changing
*                ch_characts_tab = <fs_tab>-characteristics.
*          endif.
        endif.
        refresh lt_lines.
      endloop.
    endmethod.


method set_devolutions.
*Internal tables
    data: lt_goodsmvt_item     type table of bapi2017_gm_item_create,
          lt_goodsmvt_item_cwm type table of /cwm/bapi2017_gm_item_create.

*Structures
    data: ls_goodsmvt_header   type bapi2017_gm_head_01,
          ls_goodsmvt_code     type bapi2017_gm_code,
          ls_goodsmvt_item     type bapi2017_gm_item_create,
          ls_goodsmvt_headret  type bapi2017_gm_head_ret,
          ls_goodsmvt_item_cwm type /cwm/bapi2017_gm_item_create.

*Variables
    data: l_aufnr            type aufnr,
          l_materialdocument type bapi2017_gm_head_ret-mat_doc,
          l_matdocumentyear  type bapi2017_gm_head_ret-doc_year.

    data: lref_sf_parameters type ref to zabsf_pp_cl_parameters,
          lv_use_cwm         type flag,
          lv_cwm_active      type /cwm/xcwmat,
          lv_lgort           type lgort_d,
          lv_matnr40         type matnr,
          lr_lbacthes_rng    type range of charg_d,
          lv_round1dec_var   type p length 15 decimals 1,
          lr_atnam_rng       type range of atnam,
          lt_newbatchs_tab   type table of  zabsf_pp_s_new_batch.

*se for cwm
    data: val_erfmg type erfmg,
          val_erfme type erfme value 'KI',
          lv_matnr  type matnr.
    data: lv_pepout_var     type char20,
          lv_charseqn_var   type atnam,
          lv_sequenci_var   type atwrt,
          lr_sequencopy_rng type range of klasse_d.

    refresh lt_goodsmvt_item.

    clear: ls_goodsmvt_item,
           ls_goodsmvt_header,
           ls_goodsmvt_code.

    try.
        "obter caracteristica para arredondar uma casa decimal
        call method zcl_bc_fixed_values=>get_ranges_value
          exporting
            im_paramter_var = zcl_bc_fixed_values=>gc_devel_1_dec_cst
            im_modulesp_var = zcl_bc_fixed_values=>gc_productn_cst
          importing
            ex_valrange_tab = lr_atnam_rng.

        "obter caracteristica sequenciador
        call method zcl_bc_fixed_values=>get_single_value
          exporting
            im_paramter_var = zcl_bc_fixed_values=>gc_charseq_cst
            im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
          importing
            ex_prmvalue_var = data(lv_charseq_var).
        lv_charseqn_var = lv_charseq_var.

        "classes para inserir na tabela o nº do sequenciador
        call method zcl_bc_fixed_values=>get_ranges_value
          exporting
            im_paramter_var = zcl_bc_fixed_values=>gc_updatesequence_cst
            im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
          importing
            ex_valrange_tab = lr_sequencopy_rng.

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
        where werks eq @werks
          and arbpl eq @arbpl.
    if sy-subrc ne 0.
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgid      = 'ZABSF_PP'
          msgty      = 'E'
          msgno      = '134'
          msgv1      = arbpl
          msgv2      = werks
        changing
          return_tab = return_tab.
      "sair do processamento
      return.
    endif.

    call function 'CONVERSION_EXIT_ALPHA_INPUT'
      exporting
        input  = aufnr
      importing
        output = l_aufnr.

*>> SETUP.
    create object lref_sf_parameters
      exporting
        initial_refdt = refdt
        input_object  = inputobj.

    call method lref_sf_parameters->get_output_settings
      exporting
        parid           = lref_sf_parameters->c_use_cwm
      importing
        parameter_value = lv_use_cwm
      changing
        return_tab      = return_tab.
*
*    select single /cwm/xcwmat from mara into @data(lv_xcwmat)
*    where matnr = @components_st-matnr.
    "04.03.2020 - ajustes DST
    data lv_xcwmat(1).

    select * from aufm into table @data(lt_aufm)
      where aufnr = @aufnr
        and matnr = @components_st-matnr
        and charg = @components_st-batch
        and bwart in ('261', '262').

    clear val_erfmg.
    loop at lt_aufm into data(ls_aufm).
      if ls_aufm-bwart eq '261'.
        if lv_xcwmat = 'X'.
          "add ls_aufm-/cwm/erfmg to val_erfmg.
        else.
          add ls_aufm-erfmg to val_erfmg.
        endif.
      elseif ls_aufm-bwart eq '262'.
        if lv_xcwmat = 'X'.
          "subtract ls_aufm-/cwm/erfmg from val_erfmg.
        else.
          subtract ls_aufm-erfmg from val_erfmg.
        endif.
      endif.
    endloop.

    if components_st-consqty > val_erfmg.
      clear val_erfmg.
*  Send error sucess.
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgty      = 'E'
          msgno      = '124'
*         msgv1      = components_st-
        changing
          return_tab = return_tab.

    else.

*Header of material document
      ls_goodsmvt_header-pstng_date = sy-datlo.
      ls_goodsmvt_header-doc_date = sy-datlo.

*Movement type
      ls_goodsmvt_code-gm_code = '03'.

*Data to create movement
*Plant
      ls_goodsmvt_item-plant = inputobj-werks.
*Movement Type
      select single parva from zabsf_pp032 into ls_goodsmvt_item-move_type
        where werks eq ls_goodsmvt_item-plant
        and parid = 'CONSUME_MVMT'.

      if sy-subrc ne 0.

        call method zabsf_pp_cl_log=>add_message
          exporting
            msgty      = 'E'
            msgno      = '109'
          changing
            return_tab = return_tab.
        exit.
      endif.

*Production Order
      ls_goodsmvt_item-orderid = l_aufnr.

      if components_st is not initial.

        if components_st-matnr na sy-abcde.
*    Material - Component
          call function 'CONVERSION_EXIT_MATN1_INPUT'
            exporting
              input        = components_st-matnr
            importing
              output       = ls_goodsmvt_item-material
            exceptions
              length_error = 1
              others       = 2.
        else.
          ls_goodsmvt_item-material = components_st-matnr.
        endif.

        select single lgpro from marc into lv_lgort
          where werks eq ls_goodsmvt_item-plant
          and matnr eq ls_goodsmvt_item-material.

*    ls_goodsmvt_item-material = components_st-matnr.
*  Quantity
        ls_goodsmvt_item-entry_qnt = components_st-consqty.
*  Unit
        ls_goodsmvt_item-entry_uom = components_st-meins.
        " reserva
        "  ls_goodsmvt_item-res_item = components_st-rspos.
        "item reserva
        "   ls_goodsmvt_item-reserv_no = components_st-rsnum.
        "indicador de estorno
        ls_goodsmvt_item-xstob = abap_true.
        "ls_goodsmvt_item-move_type = '262'.
        ls_goodsmvt_item-spec_stock = 'Q'.

        "obter PEP da ordem
        select single projn
          from afpo
          into @data(lv_pepelemt_var)
            where aufnr eq @l_aufnr
              and projn ne @abap_false.
        if sy-subrc eq 0.
          call function 'CONVERSION_EXIT_ABPSP_OUTPUT'
            exporting
              input  = lv_pepelemt_var
            importing
              output = lv_pepout_var.
        endif.
        ls_goodsmvt_item-val_wbs_elem = lv_pepout_var.

        "depósito da devolução
        if devolution_destination = 'D'.
          try.
              "obter configuração
              call method zcl_bc_fixed_values=>get_single_value
                exporting
                  im_paramter_var = zcl_bc_fixed_values=>gc_devware_cst
                  im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
                  im_werksval_var = inputobj-werks
                importing
                  ex_prmvalue_var = data(lv_devware_var).
              "depósito de devoluções
              ls_goodsmvt_item-stge_loc = lv_devware_var.
            catch zcx_pp_exceptions .
          endtry.
        endif.
        "depósito da produção
        if devolution_destination = 'P'.
          try.
              "obter configuração
              call method zcl_bc_fixed_values=>get_single_value
                exporting
                  im_paramter_var = zcl_bc_fixed_values=>gc_devprod_cst
                  im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
                  im_werksval_var = inputobj-werks
                importing
                  ex_prmvalue_var = data(lv_devprod_var).
              "depósito devolução da produção
              ls_goodsmvt_item-stge_loc = lv_devprod_var.
            catch zcx_pp_exceptions .
          endtry.
        endif.

*  Batch
        call function 'CONVERSION_EXIT_ALPHA_INPUT'
          exporting
            input  = components_st-batch
          importing
            output = ls_goodsmvt_item-batch.

        "obter caracteristicas do lote
        call method zcl_mm_classification=>get_classification_by_batch
          exporting
            im_material_var       = ls_goodsmvt_item-material
            im_lote_var           = ls_goodsmvt_item-batch
          importing
            ex_classification_tab = data(lt_charact_tab)
            ex_class_tab          = data(lt_classes_tab).

        "obter classe 23
        read table lt_classes_tab into data(ls_classes_str) index 1.
        if ls_classes_str-class in lr_sequencopy_rng.
          "flag de actualização da tabela de sequenciadores
          data(lv_updseqtab_var) = abap_true.
          "obter sequenciador do lote a devolver
          loop at lt_charact_tab into data(ls_charact_str)
            where atnam eq lv_charseqn_var.
            "valor sequenciador
            lv_sequenci_var = ls_charact_str-ausp1.
            "sair do loop
            exit.
          endloop.
        endif.
        "cálcular caracteristica para a devolução
        zabsf_pp_cl_consumptions=>set_devolution_charact( exporting
                                                            im_material_var = |{ components_st-matnr alpha = in }|
                                                            im_werks_var    = werks
                                                            im_batch_var    = |{ components_st-batch alpha = in }|
                                                            im_characts_tab = components_st-characteristics
                                                          importing
                                                            et_return_tab   = return_tab
                                                            ex_characts_tab = data(lt_develchar_tab) ).

        if return_tab is not initial.
          "sair do processamento
          return.
        endif.
        "tabela auxiliar
        data(lt_char_aux) = components_st-characteristics.

        loop at lt_develchar_tab into data(ls_new_char_str).
          "verificar se caracteristica foi enviada pelo SF
          read table lt_char_aux assigning field-symbol(<fs_char_aux_str>) with key atnam = ls_new_char_str-atnam.
          if sy-subrc eq 0.
            "actualizar valor da caracteriticas com o valor cálculado
            <fs_char_aux_str>-atwrt = ls_new_char_str-atwrt.
          else.
            "adicionar caracteristica
            append lines of lt_develchar_tab to lt_char_aux.
          endif.
        endloop.

        "gerar novo sequenciaodor
         zabsf_pp_cl_tracking=>get_next_sequence_number( importing
                                                           ex_sequencer_var = data(lv_newsequence_var)
                                                           et_return_tab    = return_tab ).
         if return_tab is not initial.
          "sair do processamento
          return.
        endif.

        "percorrer as caracteristicas enviadas pelo SF com a nova determinada
        loop at lt_char_aux assigning <fs_char_aux_str>.
          "verificar se é para arredondar para 1 casa decimal
          if <fs_char_aux_str>-atnam in lr_atnam_rng.
            "converter para formato interno
            zabsf_pp_cl_tracking=>convert_char_value_to_internal( exporting
                                                                    im_atnam_var   = <fs_char_aux_str>-atnam
                                                                    im_atwrt_var   = <fs_char_aux_str>-atwrt
                                                                  importing
                                                                    ex_valfrom_var = data(lv_value_from)
                                                                    ex_valueto_var = data(lv_value_to)
                                                                    ex_valuerl_var = data(lv_value_relation) ).
            "conversão de formatos para 1 decimal
            move lv_value_from to lv_round1dec_var.
            "conversão para virgula flutuante
            move lv_round1dec_var to lv_value_from.
            "conversão para formato externo da caracteristica
            zabsf_pp_cl_consumptions=>convert_char_value_to_external( exporting
                                                                        im_atnam_var = <fs_char_aux_str>-atnam
                                                                        im_atflv_var = lv_value_from
                                                                      importing
                                                                        ex_atwrt_var = <fs_char_aux_str>-atwrt ).
          endif.
          "limpar variáveis
          clear: lv_value_from, lv_value_to, lv_value_from, lv_round1dec_var.
        endloop.

        "adicionar característica sequenciador
        append value #( atnam = lv_charseqn_var
                        atwrt = lv_newsequence_var ) to lt_char_aux.
        "criar lote de devolução
        call method zabsf_pp_cl_consumptions=>create_devolution_batch
          exporting
            im_refbatch_var = ls_goodsmvt_item-batch
            im_refmatnr_var = ls_goodsmvt_item-material
            im_refwerks_var = ls_goodsmvt_item-plant
            it_characts_tab = lt_char_aux
          importing
            et_return_tab   = return_tab
            ex_error_var    = data(lv_error)
            ex_newbatch_var = data(lv_new_batch).

        if lv_error eq abap_true.
          "sair do processamento
          return.
        endif.

        ls_goodsmvt_item-batch = lv_new_batch.
************************
        append ls_goodsmvt_item to lt_goodsmvt_item.
      endif.

      "impressão de mensagens
*      ls_goodsmvt_header-pr_uname = sy-uname.
*      ls_goodsmvt_header-ver_gr_gi_slip = '3'.
*      ls_goodsmvt_header-ver_gr_gi_slipx = abap_true.

      "criar movimento de devolução
      call function 'BAPI_GOODSMVT_CREATE'
        exporting
          goodsmvt_header  = ls_goodsmvt_header
          goodsmvt_code    = ls_goodsmvt_code
        importing
          goodsmvt_headret = ls_goodsmvt_headret
          materialdocument = l_materialdocument
          matdocumentyear  = l_matdocumentyear
        tables
          goodsmvt_item    = lt_goodsmvt_item
          return           = return_tab.

      if return_tab[] is initial.
        "commit da operação
        call function 'BAPI_TRANSACTION_COMMIT'
          exporting
            wait = 'X'.

        if lv_updseqtab_var eq abap_true
          and lv_sequenci_var is not initial.
          "obter sequenciador lantek do lote a devolver
          select single seq_lantek
            from zabsf_sequence_t
            into @data(lv_seqlantk_var)
              where charg        eq @components_st-batch
                and sequenciador eq @lv_sequenci_var.
          "estrutura com novo lote
          append value #( charg        = lv_new_batch
                          sequenciador = lv_newsequence_var ) to lt_newbatchs_tab.

          "actualizar tabela de sequenciadores
          zabsf_pp_cl_tracking=>update_sequence_table( exporting
                                                         im_retbatch_var = |{ components_st-batch alpha = in }|
                                                         im_document_var = l_materialdocument
                                                         im_newbatch_tab = lt_newbatchs_tab
                                                         im_seqlantk_var = lv_seqlantk_var
                                                         im_opridval_var = inputobj-oprid ).
        endif.
*  Send message sucess.
        call method zabsf_pp_cl_log=>add_message
          exporting
            msgty      = 'S'
            msgno      = '034'
            msgv1      = l_materialdocument
          changing
            return_tab = return_tab.

        "criar range de lotes a imprimir
        append value #( sign   = 'I'
                        option = 'EQ'
                        low    = lv_new_batch ) to lr_lbacthes_rng.

*        "imprimir etiqueta do 311
*        zcl_absf_mob=>print_movements_label( exporting
*                                                im_devolucao_var = abap_true
*                                                im_docnumber_var = l_materialdocument
*                                                im_docyear_var   = l_matdocumentyear
*                                                im_batch_rng     = lr_lbacthes_rng[]
*                                                im_printer_var   = lv_printer_var
*                                              changing
*                                                ch_return_tab    = return_tab ).
      endif.
    endif.
  endmethod.


method set_devolution_charact.
    "constantes
    constants: lc_compriment_cst    type atnam   value 'MET_COMPRIMENTO',
               lc_largura_cst       type atnam   value 'MET_LARGURA',
               lc_espessura_cst     type atnam   value 'MET_ESPESSURA',
               lc_units_prkg_cst    type atnam   value 'L_KG_P_UN', "1, 2  e 3a condição da dependencia
               lc_m_to_unit_cst     type atnam   value 'L_ME_P_UN', "comprimento / 1000  . em metros
               lc_m2_to_unit_cst    type atnam   value 'L_M2_P_UN_2', " [( comprimento ) * (largura)] / 1000000. em metros^2
               lc_tipologia_cst     type atnam   value 'MET_TIPOLOGIA',
               lc_tablename_cst     type apitabl value 'MET_CONV',
               lc_espess_chapas_cst type atnam   value 'MET_ESPESSURA_CHAPAS'.

    "ranges cenários
    data: lr_cenario1_rng type range of atwrt,
          lr_cenario2_rng type range of atwrt,
          lr_cenario3_rng type range of atwrt.

    "variáveis locais
    data: lt_met_conv_tab type table of vtentries,
          lv_mts_kg_var   type boole_d,
          lv_mts2_un2_var type boole_d,
          lv_mt_un_var    type boole_d,
          lv_factconv_var type p length 15 decimals 3.

    "limpar variáveis de exportação
    refresh: et_return_tab, ex_characts_tab.
    "ler caracteristicas lotes
    zcl_mm_classification=>get_classification_by_batch( exporting
                                                          im_material_var      = im_material_var
                                                          im_lote_var          = im_batch_var
                                                          im_shownull_var      = abap_true
                                                        importing
                                                          ex_class_tab          = data(lt_class_tab)
                                                          ex_classification_tab = data(lt_characts_tab) ).
    "actualizar valor da caracteristica com o valor enviado pelo SF
    loop at lt_characts_tab assigning field-symbol(<fs_charact_str>).
      read table im_characts_tab into data(ls_editedchar_str) with key atnam = <fs_charact_str>-atnam.
      if sy-subrc eq 0.
        "actualizar valor da caracteristica com o valor enviado pelo SF
        <fs_charact_str>-ausp1 = ls_editedchar_str-atwrt.
      endif.
      "limpar caracteristica a cálcular
      if <fs_charact_str>-atnam eq lc_m_to_unit_cst.
        clear <fs_charact_str>-ausp1.
        "flag metros por unidade
        lv_mt_un_var = abap_true.
      endif.
      if <fs_charact_str>-atnam eq lc_m2_to_unit_cst.
        clear <fs_charact_str>-ausp1.
        "flag metros 2 por unidade
        lv_mts2_un2_var = abap_true.
      endif.
      if <fs_charact_str>-atnam eq lc_units_prkg_cst.
        clear <fs_charact_str>-ausp1.
        "flag kgs por unidade
        lv_mts_kg_var = abap_true.
      endif.
      clear: ls_editedchar_str.
    endloop.

    "verificar se só determinou uma caracteristica para calcular
    if ( lv_mts2_un2_var eq abap_true and lv_mt_un_var eq abap_true )
      or ( lv_mts2_un2_var eq abap_true and lv_mts_kg_var eq abap_true )
      or ( lv_mts_kg_var eq abap_true and lv_mt_un_var eq abap_true ).

      "Lote com múltiplas características para calcular
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgty      = 'E'
          msgno      = '154'
        changing
          return_tab = et_return_tab.
      "sair do processamento
      return.
    endif.

    "metros por unidade
    if lv_mt_un_var eq abap_true.
      "ler valor da caracteritica
      read table lt_characts_tab assigning <fs_charact_str> with key atnam = lc_compriment_cst.
      if sy-subrc eq 0.
        "verificar se está em milimetros
        if not <fs_charact_str>-ausp1 cs 'mm'.
          "Inserir valores em mm ( milímetros )
          call method zabsf_pp_cl_log=>add_message
            exporting
              msgty      = 'E'
              msgno      = '155'
              msgv1      = lc_compriment_cst
            changing
              return_tab = et_return_tab.
          "sair do processamento
          return.
        endif.
        "copiar
        read table lt_characts_tab assigning field-symbol(<fs_newvalue_str>) with key atnam = lc_m_to_unit_cst.
        if sy-subrc eq 0.
          "converter para formato interno
          zabsf_pp_cl_tracking=>convert_char_value_to_internal( exporting
                                                                  im_atnam_var   = <fs_charact_str>-atnam
                                                                  im_atwrt_var   = <fs_charact_str>-ausp1
                                                                importing
                                                                  ex_valfrom_var = data(lv_value_from)
                                                                  ex_valueto_var = data(lv_value_to)
                                                                  ex_valuerl_var = data(lv_value_relation) ).
          "conversão para metros
          lv_value_from = lv_value_from / 1000.
          "conversão para formato externo da caracteristica
          zabsf_pp_cl_consumptions=>convert_char_value_to_external( exporting
                                                                      im_atnam_var = lc_m_to_unit_cst
                                                                      im_atflv_var = lv_value_from
                                                                    importing
                                                                      ex_atwrt_var = <fs_newvalue_str>-ausp1
                                                                      et_return_tab = et_return_tab ).
          if et_return_tab is not initial.
            return.
          endif.
          "adicionar caracteritica à tabela de saida
          append value #( atnam = lc_m_to_unit_cst
                          atflv = lv_value_from
                          atwrt =  <fs_newvalue_str>-ausp1 ) to ex_characts_tab.
        endif.
      else.
        "Lote não tem característica &1
        call method zabsf_pp_cl_log=>add_message
          exporting
            msgty      = 'E'
            msgno      = '156'
            msgv1      = lc_compriment_cst
          changing
            return_tab = et_return_tab.
        return.
      endif.
    endif.

    "metros quadrados por unidade
    if lv_mts2_un2_var eq abap_true.
      "ler comprimento
      read table lt_characts_tab assigning <fs_charact_str> with key atnam = lc_compriment_cst.
      if sy-subrc eq 0.
        "verificar se está em milimetros
        if not <fs_charact_str>-ausp1 cs 'mm'.
          "Inserir valores em mm ( milímetros )
          call method zabsf_pp_cl_log=>add_message
            exporting
              msgty      = 'E'
              msgno      = '155'
              msgv1      = lc_compriment_cst
            changing
              return_tab = et_return_tab.
          "sair do processamento
          return.
        endif.
      else.
        "Lote não tem característica &1
        call method zabsf_pp_cl_log=>add_message
          exporting
            msgty      = 'E'
            msgno      = '156'
            msgv1      = lc_compriment_cst
          changing
            return_tab = et_return_tab.
        return.
      endif.
      "COMPRIMENTO - converter para formato interno
      zabsf_pp_cl_tracking=>convert_char_value_to_internal( exporting
                                                              im_atnam_var   = <fs_charact_str>-atnam
                                                              im_atwrt_var   = <fs_charact_str>-ausp1
                                                            importing
                                                              ex_valfrom_var = data(lv_comprimento_value_from)
                                                              ex_valueto_var = data(lv_comprimento_value_to)
                                                              ex_valuerl_var = data(lv_comprimento_value_relation) ).

      "Obter valor LARGURA
      read table lt_characts_tab assigning <fs_charact_str> with key atnam = lc_largura_cst.
      if sy-subrc eq 0.
        "verificar se está em milimetros
        if not <fs_charact_str>-ausp1 cs 'mm'.
          "Inserir valores em mm ( milímetros )
          call method zabsf_pp_cl_log=>add_message
            exporting
              msgty      = 'E'
              msgno      = '155'
              msgv1      = lc_largura_cst
            changing
              return_tab = et_return_tab.
          "sair do processamento
          return.
        endif.
      else.
        "Lote não tem característica &1
        call method zabsf_pp_cl_log=>add_message
          exporting
            msgty      = 'E'
            msgno      = '156'
            msgv1      = lc_largura_cst
          changing
            return_tab = et_return_tab.
        "sair do processamento
        return.
      endif.
      "LARGURA - converter para formato interno
      zabsf_pp_cl_tracking=>convert_char_value_to_internal( exporting
                                                        im_atnam_var   = <fs_charact_str>-atnam
                                                        im_atwrt_var   = <fs_charact_str>-ausp1
                                                      importing
                                                        ex_valfrom_var = data(lv_largura_value_from)
                                                        ex_valueto_var = data(lv_largura_value_to)
                                                        ex_valuerl_var = data(lv_largura_value_relation) ).
      "cálculoa da área metros
      data(lv_aux_var) = ( ( lv_comprimento_value_from / 1000 ) * ( lv_largura_value_from / 1000 ) ) .
      read table lt_characts_tab assigning <fs_newvalue_str> with key atnam = lc_m2_to_unit_cst.
      if sy-subrc eq 0.
        "conversão para formato externo da caracteristica
        zabsf_pp_cl_consumptions=>convert_char_value_to_external( exporting
                                                                    im_atnam_var = lc_m2_to_unit_cst
                                                                    im_atflv_var = lv_aux_var
                                                                  importing
                                                                    ex_atwrt_var = <fs_newvalue_str>-ausp1
                                                                    et_return_tab = et_return_tab  ).
        if et_return_tab is not initial.
          return.
        endif.
        "adicionar caracteritica à tabela de saida
        append value #( atnam = lc_m2_to_unit_cst
                        atflv = lv_aux_var
                        atwrt = <fs_newvalue_str>-ausp1 ) to ex_characts_tab.
      endif.
    endif.

    "Kgs por unidade
    if lv_mts_kg_var eq abap_true.
      "obter valor da caracteristica Tipologia
      read table lt_characts_tab into data(ls_tipochar_str) with key atnam = lc_tipologia_cst.
      "verificar se caracterisitica está preenchida
      if sy-subrc ne 0 or ls_tipochar_str-ausp1 is initial.
        "Característica &1 sem valor
        call method zabsf_pp_cl_log=>add_message
          exporting
            msgty      = 'E'
            msgno      = '157'
            msgv1      = lc_tipologia_cst
          changing
            return_tab = et_return_tab.
        "sair do processamento
        return.
      endif.

      "obter o id do valor a partir da descrição
      select single cawn~atwrt
        from cabn as cabn
        inner join cawn as cawn
        on cawn~atinn eq cabn~atinn
        inner join cawnt as cawnt
        on cawnt~atinn eq cawn~atinn
         and cawnt~atzhl eq cawn~atzhl
        into @data(lv_id_tipologia_var)
          where cabn~atnam  eq @lc_tipologia_cst
            and cawnt~atwtb eq @ls_tipochar_str-ausp1.

      "obter tabela do configurador
      call function 'CARD_TABLE_READ_ENTRIES'
        exporting
          var_table       = lc_tablename_cst
        tables
          var_tab_entries = lt_met_conv_tab
        exceptions
          error           = 1
          others          = 2.
      if sy-subrc <> 0.
        "mensagem de erro
        call method zabsf_pp_cl_log=>add_message
          exporting
            msgty      = sy-msgty
            msgno      = sy-msgno
            msgv1      = sy-msgv1
            msgv2      = sy-msgv2
            msgv3      = sy-msgv3
            msgv4      = sy-msgv4
            msgid      = sy-msgid
          changing
            return_tab = et_return_tab.
        return.
      endif.
      "obter factor de conversão para o material
      read table lt_met_conv_tab into data(ls_met_conv_str) with key vtcharact = 'REF_VBAP_MATNR'
                                                                     vtvalue   = im_material_var.
      if sy-subrc eq 0.
        read table lt_met_conv_tab into ls_met_conv_str with key vtcharact = 'F_CONV_METAL'
                                                                 vtlineno  = ls_met_conv_str-vtlineno.
        if sy-subrc eq 0.
          "converter char para número"
          call function 'MOVE_CHAR_TO_NUM'
            exporting
              chr             = ls_met_conv_str-vtvalue
            importing
              num             = lv_factconv_var
            exceptions
              convt_no_number = 1
              convt_overflow  = 2
              others          = 3.
          if sy-subrc <> 0.
            "mensagem de erro
            call method zabsf_pp_cl_log=>add_message
              exporting
                msgty      = sy-msgty
                msgno      = sy-msgno
                msgv1      = sy-msgv1
                msgv2      = sy-msgv2
                msgv3      = sy-msgv3
                msgv4      = sy-msgv4
                msgid      = sy-msgid
              changing
                return_tab = et_return_tab.
            "sair do processamento
            return.
          endif.
        endif.
      endif.
      "verificar se factor de conversão foi cálculado
      if lv_factconv_var is initial.
        "Erro ao calcular o factor de conversão para o material &
        call method zabsf_pp_cl_log=>add_message
          exporting
            msgty      = 'E'
            msgno      = '158'
            msgv1      = im_material_var
          changing
            return_tab = et_return_tab.
        "sair do processamento
        return.
      endif.

      "obter ranges da tipologia na configuração
      try.
          "tipologias para regra 1
          call method zcl_bc_fixed_values=>get_ranges_value
            exporting
              im_paramter_var = zcl_bc_fixed_values=>gc_devel_tipologia_1_cst
              im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
            importing
              ex_valrange_tab = lr_cenario1_rng.

          "tipologias para regra 2
          call method zcl_bc_fixed_values=>get_ranges_value
            exporting
              im_paramter_var = zcl_bc_fixed_values=>gc_devel_tipologia_2_cst
              im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
            importing
              ex_valrange_tab = lr_cenario2_rng.

          "tipologias para regra 3
          call method zcl_bc_fixed_values=>get_ranges_value
            exporting
              im_paramter_var = zcl_bc_fixed_values=>gc_devel_tipologia_3_cst
              im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
            importing
              ex_valrange_tab = lr_cenario3_rng.

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
              return_tab = et_return_tab.
          "sair do processamento
          return.
      endtry.
      "verificar qual o cenário/regra
      if lv_id_tipologia_var in lr_cenario1_rng.
        "comprimento x factor de conversão

        "ler valor da caracteritica
        read table lt_characts_tab assigning <fs_charact_str> with key atnam = lc_compriment_cst.
        if sy-subrc eq 0.
          "verificar se está em milimetros
          if not <fs_charact_str>-ausp1 cs 'mm'.
            "Inserir valores em mm ( milímetros )
            call method zabsf_pp_cl_log=>add_message
              exporting
                msgty      = 'E'
                msgno      = '155'
                msgv1      = lc_compriment_cst
              changing
                return_tab = et_return_tab.
            "sair do processamento
            return.
          endif.
          "copiar
          read table lt_characts_tab assigning <fs_newvalue_str> with key atnam = lc_units_prkg_cst.
          if sy-subrc eq 0.
            "converter COMPRIMENTO para formato interno
            zabsf_pp_cl_tracking=>convert_char_value_to_internal( exporting
                                                                    im_atnam_var   = <fs_charact_str>-atnam
                                                                    im_atwrt_var   = <fs_charact_str>-ausp1
                                                                  importing
                                                                    ex_valfrom_var = lv_value_from
                                                                    ex_valueto_var = lv_value_to
                                                                    ex_valuerl_var = lv_value_relation ).

            "fórmula da regra com conversão para metros
            lv_value_from = ( lv_value_from  * lv_factconv_var ) / 1000.
            "conversão para formato externo da caracteristica
            zabsf_pp_cl_consumptions=>convert_char_value_to_external( exporting
                                                                        im_atnam_var = lc_units_prkg_cst
                                                                        im_atflv_var = lv_value_from
                                                                      importing
                                                                        ex_atwrt_var = <fs_newvalue_str>-ausp1
                                                                        et_return_tab = et_return_tab  ).
            if et_return_tab is not initial.
              return.
            endif.
            "adicionar caracteritica à tabela de saida
            append value #( atnam = lc_units_prkg_cst
                            atflv = lv_value_from
                            atwrt = <fs_newvalue_str>-ausp1 ) to ex_characts_tab.

          endif.
        endif.
      endif.
      if lv_id_tipologia_var in lr_cenario2_rng.
        "ler valor da caracteristica COMPRIMENTO
        read table lt_characts_tab assigning <fs_charact_str> with key atnam = lc_compriment_cst.
        if sy-subrc eq 0.
          "verificar se está em milimetros
          if not <fs_charact_str>-ausp1 cs 'mm'.
            "Inserir valores em mm ( milímetros )
            call method zabsf_pp_cl_log=>add_message
              exporting
                msgty      = 'E'
                msgno      = '155'
                msgv1      = lc_compriment_cst
              changing
                return_tab = et_return_tab.
            "sair do processamento
            return.
          endif.
        else.
          "Lote não tem característica &1
          call method zabsf_pp_cl_log=>add_message
            exporting
              msgty      = 'E'
              msgno      = '156'
              msgv1      = lc_compriment_cst
            changing
              return_tab = et_return_tab.
          "sair do processamento
          return.
        endif.
        "COMPRIMENTO - converter para formato interno
        zabsf_pp_cl_tracking=>convert_char_value_to_internal( exporting
                                                                im_atnam_var   = <fs_charact_str>-atnam
                                                                im_atwrt_var   = <fs_charact_str>-ausp1
                                                              importing
                                                                ex_valfrom_var = lv_comprimento_value_from
                                                                ex_valueto_var = lv_comprimento_value_to
                                                                ex_valuerl_var = lv_comprimento_value_relation ).
        "LARGURA - Obter valor
        read table lt_characts_tab assigning <fs_charact_str> with key atnam = lc_largura_cst.
        if sy-subrc eq 0.
          "verificar se está em milimetros
          if not <fs_charact_str>-ausp1 cs 'mm'.
            "Inserir valores em mm ( milímetros )
            call method zabsf_pp_cl_log=>add_message
              exporting
                msgty      = 'E'
                msgno      = '155'
                msgv1      = lc_largura_cst
              changing
                return_tab = et_return_tab.
            "sair do processamento
            return.
          endif.
        else.
          "Lote não tem característica &1
          call method zabsf_pp_cl_log=>add_message
            exporting
              msgty      = 'E'
              msgno      = '156'
              msgv1      = lc_largura_cst
            changing
              return_tab = et_return_tab.
          "sair do processamento
          return.
        endif.
        "LARGURA - converter para formato interno
        zabsf_pp_cl_tracking=>convert_char_value_to_internal( exporting
                                                          im_atnam_var   = <fs_charact_str>-atnam
                                                          im_atwrt_var   = <fs_charact_str>-ausp1
                                                        importing
                                                          ex_valfrom_var = lv_largura_value_from
                                                          ex_valueto_var = lv_largura_value_to
                                                          ex_valuerl_var = lv_largura_value_relation ).
        "ESPESSURA CHAPAS - Obter valor
        read table lt_characts_tab assigning <fs_charact_str> with key atnam = lc_espess_chapas_cst.
        if sy-subrc eq 0.
          "verificar se está em milimetros
          if not <fs_charact_str>-ausp1 cs 'mm'.
            "Inserir valores em mm ( milímetros )
            call method zabsf_pp_cl_log=>add_message
              exporting
                msgty      = 'E'
                msgno      = '155'
                msgv1      = lc_espess_chapas_cst
              changing
                return_tab = et_return_tab.
            "sair do processamento
            return.
          endif.
        else.
          "Lote não tem característica &1
          call method zabsf_pp_cl_log=>add_message
            exporting
              msgty      = 'E'
              msgno      = '156'
              msgv1      = lc_largura_cst
            changing
              return_tab = et_return_tab.
          "sair do processamento
          return.
        endif.
        "ESPESSURA - converter para formato interno
        zabsf_pp_cl_tracking=>convert_char_value_to_internal( exporting
                                                          im_atnam_var   = <fs_charact_str>-atnam
                                                          im_atwrt_var   = <fs_charact_str>-ausp1
                                                        importing
                                                          ex_valfrom_var = data(lv_espchapa_value_from)
                                                          ex_valueto_var = data(lv_espchapa_value_to)
                                                          ex_valuerl_var = data(lv_espchapa_value_relation) ).
        "fórmula da regra 2
        lv_aux_var = ( lv_comprimento_value_from   * lv_largura_value_from  *  lv_espchapa_value_from * lv_factconv_var ) / 1000000000 .

        read table lt_characts_tab assigning <fs_newvalue_str> with key atnam = lc_units_prkg_cst.
        if sy-subrc eq 0.
          "conversão para formato externo da caracteristica
          zabsf_pp_cl_consumptions=>convert_char_value_to_external( exporting
                                                                      im_atnam_var = lc_units_prkg_cst
                                                                      im_atflv_var = lv_aux_var
                                                                    importing
                                                                      ex_atwrt_var = <fs_newvalue_str>-ausp1
                                                                      et_return_tab = et_return_tab ).
          if et_return_tab is not initial.
            return.
          endif.
          "adicionar caracteritica à tabela de saida
          append value #( atnam = lc_units_prkg_cst
                          atflv = lv_value_from
                          atwrt = <fs_newvalue_str>-ausp1 ) to ex_characts_tab.
        endif.
      endif.
      if lv_id_tipologia_var in lr_cenario3_rng.
        "ler valor da caracteristica COMPRIMENTO
        read table lt_characts_tab assigning <fs_charact_str> with key atnam = lc_compriment_cst.
        if sy-subrc eq 0.
          "verificar se está em milimetros
          if not <fs_charact_str>-ausp1 cs 'mm'.
            "Inserir valores em mm ( milímetros )
            call method zabsf_pp_cl_log=>add_message
              exporting
                msgty      = 'E'
                msgno      = '155'
                msgv1      = lc_compriment_cst
              changing
                return_tab = et_return_tab.
            "sair do processamento
            return.
          endif.
        else.
          "Lote não tem característica &1
          call method zabsf_pp_cl_log=>add_message
            exporting
              msgty      = 'E'
              msgno      = '156'
              msgv1      = lc_compriment_cst
            changing
              return_tab = et_return_tab.
          "sair do processamento
          return.
        endif.
        "COMPRIMENTO - converter para formato interno
        zabsf_pp_cl_tracking=>convert_char_value_to_internal( exporting
                                                                im_atnam_var   = <fs_charact_str>-atnam
                                                                im_atwrt_var   = <fs_charact_str>-ausp1
                                                              importing
                                                                ex_valfrom_var = lv_comprimento_value_from
                                                                ex_valueto_var = lv_comprimento_value_to
                                                                ex_valuerl_var = lv_comprimento_value_relation ).
        "LARGURA - Obter valor
        read table lt_characts_tab assigning <fs_charact_str> with key atnam = lc_largura_cst.
        if sy-subrc eq 0.
          "verificar se está em milimetros
          if not <fs_charact_str>-ausp1 cs 'mm'.
            "Inserir valores em mm ( milímetros )
            call method zabsf_pp_cl_log=>add_message
              exporting
                msgty      = 'E'
                msgno      = '155'
                msgv1      = lc_largura_cst
              changing
                return_tab = et_return_tab.
            "sair do processamento
            return.
          endif.
        else.
          "Lote não tem característica &1
          call method zabsf_pp_cl_log=>add_message
            exporting
              msgty      = 'E'
              msgno      = '156'
              msgv1      = lc_largura_cst
            changing
              return_tab = et_return_tab.
          "sair do processamento
          return.
        endif.
        "LARGURA - converter para formato interno
        zabsf_pp_cl_tracking=>convert_char_value_to_internal( exporting
                                                                im_atnam_var   = <fs_charact_str>-atnam
                                                                im_atwrt_var   = <fs_charact_str>-ausp1
                                                              importing
                                                                ex_valfrom_var = lv_largura_value_from
                                                                ex_valueto_var = lv_largura_value_to
                                                                ex_valuerl_var = lv_largura_value_relation ).
        "ESPESSURA - Obter valor
        read table lt_characts_tab assigning <fs_charact_str> with key atnam = lc_espessura_cst.
        if sy-subrc eq 0.
          "verificar se está em milimetros
          if not <fs_charact_str>-ausp1 cs 'mm'.
            "Inserir valores em mm ( milímetros )
            call method zabsf_pp_cl_log=>add_message
              exporting
                msgty      = 'E'
                msgno      = '155'
                msgv1      = lc_espessura_cst
              changing
                return_tab = et_return_tab.
            "sair do processamento
            return.
          endif.
        else.
          "Lote não tem característica &1
          call method zabsf_pp_cl_log=>add_message
            exporting
              msgty      = 'E'
              msgno      = '156'
              msgv1      = lc_largura_cst
            changing
              return_tab = et_return_tab.
          "sair do processamento
          return.
        endif.
        "ESPESSURA - converter para formato interno
        zabsf_pp_cl_tracking=>convert_char_value_to_internal( exporting
                                                          im_atnam_var   = <fs_charact_str>-atnam
                                                          im_atwrt_var   = <fs_charact_str>-ausp1
                                                        importing
                                                          ex_valfrom_var = data(lv_espessura_value_from)
                                                          ex_valueto_var = data(lv_espessura_value_to)
                                                          ex_valuerl_var = data(lv_espessura_value_relation) ).
        "fórmula da regra 2
        lv_aux_var = ( lv_comprimento_value_from / 1000 ) * ( lv_largura_value_from / 1000 ) * ( lv_espessura_value_from / 1000 ) * lv_factconv_var.

        read table lt_characts_tab assigning <fs_newvalue_str> with key atnam = lc_units_prkg_cst.
        if sy-subrc eq 0.
          "conversão para formato externo da caracteristica
          zabsf_pp_cl_consumptions=>convert_char_value_to_external( exporting
                                                                      im_atnam_var = lc_units_prkg_cst
                                                                      im_atflv_var = lv_aux_var
                                                                    importing
                                                                      ex_atwrt_var = <fs_newvalue_str>-ausp1
                                                                      et_return_tab = et_return_tab ).
          if et_return_tab is not initial.
            return.
          endif.
          "adicionar caracteritica à tabela de saida
          append value #( atnam = lc_units_prkg_cst
                          atflv = lv_value_from
                          atwrt = <fs_newvalue_str>-ausp1 ) to ex_characts_tab.
        endif.
      endif.
    endif.
    "verificar se determinou caracteristica
    if ex_characts_tab is initial.
      "Erro ao determinar valor para a característica na devolução
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgty      = 'E'
          msgno      = '159'
        changing
          return_tab = et_return_tab.
      "sair do processamento
      return.
    endif.
  endmethod.


METHOD zif_absf_pp_consumptions~create_consum_matnr.
  DATA: lt_goodsmovements TYPE TABLE OF bapi2017_gm_item_create.

  DATA: ls_bflushflags    TYPE bapi_rm_flg,
        ls_bflushdatagen  TYPE bapi_rm_datgen,
        ls_bflushdatamts  TYPE bapi_rm_datstock,
        wa_goodsmovements TYPE bapi2017_gm_item_create,
        confirmation      TYPE bapi_rm_datkey-confirmation,
        ls_mkal           TYPE mkal,
        ls_components     TYPE zabsf_pp_s_components,
        ld_belnr          TYPE belnr_d,
        ls_plaf           TYPE plaf,
        ld_plnum          TYPE plnum,
        return            TYPE bapiret2,
        ld_shiftid        TYPE zabsf_pp_e_shiftid,
        lv_qty_av         TYPE bapicm61v-wkbst,
        lv_stock_fail(1),
        lt_wmdvs          TYPE TABLE OF bapiwmdvs,
        lt_wmdve          TYPE TABLE OF bapiwmdve,
        lv_material       TYPE string,
        lt_serialnr       TYPE STANDARD TABLE OF bapi_rm_datserial.

  CONSTANTS:
    c_bwart_261 TYPE bwart VALUE '261',
    c_bwart_131 TYPE bwart VALUE '131'.

  REFRESH lt_goodsmovements.

  CLEAR: ls_bflushflags,
         ls_bflushdatagen,
         ls_bflushdatamts,
         wa_goodsmovements,
         confirmation,
         ls_mkal,
         ls_components,
         ld_belnr,
         ls_plaf,
         ld_shiftid,
         return.

  TRANSLATE inputobj-oprid TO UPPER CASE. "CLS 16.06.2015
*Get shift witch operator is associated
  SELECT SINGLE shiftid
    FROM zabsf_pp052
    INTO ld_shiftid
   WHERE areaid EQ inputobj-areaid
     AND oprid EQ inputobj-oprid.

  IF sy-subrc NE 0.
    IF 1 = 2. MESSAGE e061(zabsf_pp) . ENDIF.
*  Operator is not associated with shift
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'E'
        msgno      = '061'
        msgv1      = inputobj-oprid
      CHANGING
        return_tab = return_tab.

    EXIT.
  ENDIF.

*Control parameter for confirmation
*Backflush type
  ls_bflushflags-bckfltype = '02'.
*Scope of activity backflush
  ls_bflushflags-activities_type = '1'.
*Scope of GI posting
  ls_bflushflags-components_type = '1'.

*Backflush Parameters Independent of Process
*Material
  ls_bflushdatagen-materialnr = matnr.
*Plant
  ls_bflushdatagen-prodplant = inputobj-werks.
*Planning plant
  ls_bflushdatagen-planplant = inputobj-werks.

  CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
    EXPORTING
      input  = matnr
    IMPORTING
      output = lv_material.

  IF line_exists( materialbatch[ material = lv_material ] ).
    ls_bflushdatagen-batch = materialbatch[ material = lv_material ]-batch.
  ENDIF.

  IF line_exists( materialserial[ material = lv_material ] ).
    APPEND VALUE #(
        serialnr =  materialserial[ material = lv_material ]-serial
      ) TO lt_serialnr.
  ENDIF.

*Production Versions of Material
  SELECT SINGLE *
    FROM mkal
    INTO CORRESPONDING FIELDS OF ls_mkal
   WHERE matnr EQ matnr
     AND werks EQ inputobj-werks
     AND adatu LE refdt
     AND bdatu GE refdt.

  IF sy-subrc EQ 0.
*  Storage Location
    ls_bflushdatagen-storageloc = ls_mkal-alort.
*  Production Version
    ls_bflushdatagen-prodversion = ls_mkal-verid.
*  Production line
    ls_bflushdatagen-prodline = ls_mkal-mdv01.
  ENDIF.

*Posting date
  ls_bflushdatagen-postdate = refdt.
*Document date
  ls_bflushdatagen-docdate = refdt.
*Quantity in Unit of Entry
  ls_bflushdatagen-backflquant = lmnga.
*Unit of measure
  ls_bflushdatagen-unitofmeasure = meins.
*Shift
  ls_bflushdatagen-docheadertxt = ld_shiftid.

  IF planorder IS NOT INITIAL.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = planorder
      IMPORTING
        output = ld_plnum.

*  Check if plan order exist in system
    SELECT SINGLE *
      FROM plaf
      INTO CORRESPONDING FIELDS OF ls_plaf
      WHERE plnum EQ ld_plnum.

    IF sy-subrc NE 0.
*
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'E'
          msgno      = '048'
          msgv1      = planorder
        CHANGING
          return_tab = return_tab.

      EXIT.
    ELSE.
*    Plan order
      ls_bflushdatagen-planorder = ld_plnum.
    ENDIF.
  ENDIF.

*Report point
  ls_bflushdatamts-reppoint = vorne.

  IF components_tab[] IS NOT INITIAL.
    LOOP AT components_tab INTO ls_components.
      CLEAR wa_goodsmovements.

*    Material - Component
      wa_goodsmovements-material = ls_components-matnr.
*    Quantity
      wa_goodsmovements-entry_qnt = ls_components-consqty.
*    Unit
      wa_goodsmovements-entry_uom = ls_components-meins.
*    Storage Location
      wa_goodsmovements-stge_loc = ls_components-lgort.
*    Plant
      wa_goodsmovements-plant = inputobj-werks.
*    Movement Type
      wa_goodsmovements-move_type = c_bwart_261.
*    Reservation
      wa_goodsmovements-reserv_no = ls_components-rsnum.
      wa_goodsmovements-res_item = ls_components-rspos.

      APPEND wa_goodsmovements TO lt_goodsmovements.

*Check material availability
      CALL FUNCTION 'BAPI_MATERIAL_AVAILABILITY'
        EXPORTING
          plant      = inputobj-werks
          material   = ls_components-matnr
          unit       = ls_components-meins
          stge_loc   = ls_components-lgort
        IMPORTING
          av_qty_plt = lv_qty_av
        TABLES
          wmdvsx     = lt_wmdvs
          wmdvex     = lt_wmdve.

      IF lv_qty_av <  ls_components-consqty.
        lv_stock_fail = 'X'.
        EXIT.
      ENDIF.
    ENDLOOP.
  ENDIF.

  IF lv_stock_fail IS INITIAL.
    LOOP AT lt_goodsmovements ASSIGNING FIELD-SYMBOL(<ls_goodsmvt>).
      CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
        EXPORTING
          input  = <ls_goodsmvt>-material
        IMPORTING
          output = lv_material.

      IF line_exists( materialbatch[ material = lv_material ] ).
        <ls_goodsmvt>-batch = materialbatch[ material = lv_material ]-batch.
      ENDIF.

      IF line_exists( materialserial[ material = lv_material ] ).
        APPEND VALUE #(
            serialnr =  materialserial[ material = lv_material ]-serial
          ) TO lt_serialnr.
      ENDIF.
    ENDLOOP.

    CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
      EXPORTING
        input  = matnr
      IMPORTING
        output = lv_material.

    IF line_exists( materialserial[ material = lv_material ] ).
      APPEND VALUE #(
          serialnr =  materialserial[ material = lv_material ]-serial
        ) TO lt_serialnr.
    ENDIF.

    DO 50 TIMES.
      CALL FUNCTION 'BAPI_REPMANCONF1_CREATE_MTS'
        EXPORTING
          bflushflags    = ls_bflushflags
          bflushdatagen  = ls_bflushdatagen
          bflushdatamts  = ls_bflushdatamts
        IMPORTING
          confirmation   = confirmation
          return         = return
        TABLES
          serialnr       = lt_serialnr
          goodsmovements = lt_goodsmovements.

      IF return-type = 'E' AND return-id = 'M3'.
        WAIT UP TO 1 SECONDS.
      ELSE.
        EXIT.
      ENDIF.
    ENDDO.

*    IF return IS INITIAL AND lv_materialdocument IS NOT INITIAL.
    IF return IS INITIAL AND confirmation IS NOT INITIAL.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = 'X'.

*  Get number od document created
      SELECT SINGLE belnr
        FROM blpp
        INTO ld_belnr
        WHERE prtnr EQ confirmation
          AND belnr NE space.

      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'S'
          msgno      = '034'
          msgv1      = ld_belnr
        CHANGING
          return_tab = return_tab.

    ELSE.
      IF return-type = 'A'.
        return-type = 'E'.
      ENDIF.

      APPEND return TO return_tab.
    ENDIF.
  ELSE.
    CALL METHOD zcl_lp_pp_sf_log=>add_message
      EXPORTING
        msgty      = 'E'
        msgno      = '064'
        msgv1      = ls_components-matnr
        msgv2      = inputobj-werks
        msgv3      = ls_components-lgort
        msgv4      = lv_qty_av
      CHANGING
        return_tab = return_tab.
  ENDIF.

  DELETE ADJACENT DUPLICATES FROM return_tab.
ENDMETHOD.


method zif_absf_pp_consumptions~create_consum_order.
  "constantes
  constants: lc_multimat_cst  type aufart value 'ZPP3',
             lc_one_matr_cst  type aufart value 'ZPP2',
             lc_lantekmat_cst type matnr value 'LANTEK'.
*Internal tables
  data: lt_goodsmvt_item     type table of bapi2017_gm_item_create,
        lt_goodsmvt_item_cwm type table of /cwm/bapi2017_gm_item_create.

*Structures
  data: ls_goodsmvt_header   type bapi2017_gm_head_01,
        ls_goodsmvt_code     type bapi2017_gm_code,
        ls_goodsmvt_item     type bapi2017_gm_item_create,
        ls_goodsmvt_headret  type bapi2017_gm_head_ret,
        ls_goodsmvt_item_cwm type /cwm/bapi2017_gm_item_create.

*Variables
  data: l_aufnr            type aufnr,
        l_materialdocument type bapi2017_gm_head_ret-mat_doc,
        l_matdocumentyear  type bapi2017_gm_head_ret-doc_year,
        lref_sf_parameters type ref to zabsf_pp_cl_parameters,
        lv_use_cwm         type flag,
        lv_cwm_active      type /cwm/xcwmat,
        lv_lgort           type lgort_d,
        lv_matnr40         type matnr,
        lv_umb             type meins.

*se for cwm
  data: val_erfmg type erfmg,
        val_erfme type erfme value 'KI',
        lv_matnr  type matnr.
*  data: peso_medio type ref to /cwm/cl_quan_prpsl.
  data: wa_indx type indx.
  data: flag_nao_imprime type c.

  data: trash_num(15) type c,
        trash_dec(15) type c,
        l_verme_      type lqua-verme,
        l_verme_c     type char20,
        l_meins       type lqua-meins,
        l_verme_cx    type bstmg,
        ls_matnr      type mara-matnr.

  refresh lt_goodsmvt_item.

  clear: ls_goodsmvt_item,
         ls_goodsmvt_header,
         ls_goodsmvt_code.

  create object lref_sf_parameters
    exporting
      initial_refdt = refdt
      input_object  = inputobj.

  call method lref_sf_parameters->get_output_settings
    exporting
      parid           = lref_sf_parameters->c_use_cwm
    importing
      parameter_value = lv_use_cwm
    changing
      return_tab      = return_tab.

  refresh return_tab.

  call function 'CONVERSION_EXIT_ALPHA_INPUT'
    exporting
      input  = aufnr
    importing
      output = l_aufnr.

  "obter tipo de ordem
  select single auart
    from aufk
    into @data(lv_ordertype)
      where aufnr eq @l_aufnr.

  try.
      "obter depósito configuração
      call method zcl_bc_fixed_values=>get_single_value
        exporting
          im_paramter_var = zcl_bc_fixed_values=>gc_shp_consmpt_strg_cst
          im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
          im_werksval_var = inputobj-werks
        importing
          ex_prmvalue_var = data(lv_conslgort_var).

      "obter depósito configuração
      call method zcl_bc_fixed_values=>get_single_value
        exporting
          im_paramter_var = zcl_bc_fixed_values=>gc_shop_add_csmt_cst
          im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
          im_werksval_var = inputobj-werks
        importing
          ex_prmvalue_var = data(lv_cons_add_var).

    catch zcx_pp_exceptions into data(lo_excpetions_obj).
      "enviar mensagem de erro
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgty      = lo_excpetions_obj->msgty
          msgid      = lo_excpetions_obj->msgid
          msgno      = lo_excpetions_obj->msgno
          msgv1      = lo_excpetions_obj->msgv1
          msgv2      = lo_excpetions_obj->msgv2
          msgv3      = lo_excpetions_obj->msgv3
          msgv4      = lo_excpetions_obj->msgv4
        changing
          return_tab = return_tab.
      return.
  endtry.

*Header of material document
  ls_goodsmvt_header-pstng_date = sy-datlo.
  ls_goodsmvt_header-doc_date = sy-datlo.

*Movement type
  ls_goodsmvt_code-gm_code = '03'.
*Data to create movement
*Plant
  ls_goodsmvt_item-plant = inputobj-werks.
*Movement Type
  select single parva from zabsf_pp032 into ls_goodsmvt_item-move_type
    where werks eq ls_goodsmvt_item-plant
    and parid = 'CONSUME_MVMT'.
  if sy-subrc ne 0.
    call method zabsf_pp_cl_log=>add_message
      exporting
        msgty      = 'E'
        msgno      = '108'
      changing
        return_tab = return_tab.
    exit.
  endif.

*Production Order
  ls_goodsmvt_item-orderid = l_aufnr.
  "*PEP element
  select single projn
    from afpo
    into @ls_goodsmvt_item-wbs_elem
      where aufnr eq @l_aufnr.

  if ls_goodsmvt_item-wbs_elem is not initial.
    call function 'CONVERSION_EXIT_ABPSP_OUTPUT'
      exporting
        input  = ls_goodsmvt_item-wbs_elem
      importing
        output = ls_goodsmvt_item-wbs_elem.

    ls_goodsmvt_item-val_wbs_elem = ls_goodsmvt_item-wbs_elem.
    ls_goodsmvt_item-spec_stock = 'Q'.
  endif.

  if components_st is not initial.

    lv_umb = components_st-meins.

    if components_st-matnr na sy-abcde.
*    Material - Component
      call function 'CONVERSION_EXIT_MATN1_INPUT'
        exporting
          input        = components_st-matnr
        importing
          output       = ls_goodsmvt_item-material
        exceptions
          length_error = 1
          others       = 2.
    else.
      ls_goodsmvt_item-material = components_st-matnr.
    endif.

*  Quantity
    ls_goodsmvt_item-entry_qnt = components_st-consqty.
*  Unit
    ls_goodsmvt_item-entry_uom = components_st-meins.

*  Storage Location
    if lv_ordertype eq lc_multimat_cst.
      ls_goodsmvt_item-stge_loc = lv_conslgort_var.
    else.
      ls_goodsmvt_item-stge_loc = components_st-lgort.
    endif.
    if lv_ordertype eq lc_multimat_cst.
      "verificar se é material lantek
      select single plnbez
        into @data(lv_lantek_var)
        from afko
          where aufnr eq @aufnr
            and plnbez eq @lc_lantekmat_cst.
      if sy-subrc eq 0.
        "obter item da ordem
        select single *
          from resb
          into @data(ls_resb_str)
            where matnr eq @components_st-matnr
              and aufnr eq @aufnr.


        data: lv_textname_var      type tdobname,
              lv_seqlantek_var     type zabsf_pp_e_seq_lantek,
              lt_lines_tab         type table of tline,
              lv_batchconsumed_var type charg_d.
        "lote a consumir
        lv_batchconsumed_var = components_st-batch.

        lv_textname_var = |{ sy-mandt }{ ls_resb_str-rsnum }{ ls_resb_str-rspos }|.
        "obter texto do item
        call function 'READ_TEXT'
          exporting
            id                      = 'MATK'
            language                = sy-langu
            name                    = lv_textname_var
            object                  = 'AUFK'
          tables
            lines                   = lt_lines_tab
          exceptions
            id                      = 1
            language                = 2
            name                    = 3
            not_found               = 4
            object                  = 5
            reference_check         = 6
            wrong_access_to_archive = 7
            others                  = 8.
        if sy-subrc <> 0.
* Implement suitable error handling here
        endif.
        "remover linhas em branco
        delete lt_lines_tab where tdline eq space.
        read table lt_lines_tab into data(ls_textvalue_str) index 1.
        "sequenciador lantek
        lv_seqlantek_var = ls_textvalue_str-tdline.
      endif.
    endif.


**  Reservation
    "EDIT 27.08.2020 - SF envia o nº da reserva
    "EDIT 11.11.2020 - se na reserva não tiver lote, considerar como adhoc puro
    select single charg
      from resb
      into @data(lv_resbcharg_var)
        where rsnum eq @components_st-rsnum
          and rspos eq @components_st-rspos
          and charg ne @space.
    if sy-subrc eq 0.
      "verificar se o lote é igual
      if lv_resbcharg_var eq components_st-batch.
        ls_goodsmvt_item-reserv_no = components_st-rsnum.
        ls_goodsmvt_item-res_item = components_st-rspos.
      endif.
    endif.
    ">>BMR 27.08.2020 - Erro Lote sem Tipo de avaliação
    select single bwtar
      from mcha
      into @ls_goodsmvt_item-val_type
        where charg eq @components_st-batch
          and matnr eq @ls_goodsmvt_item-material
          and werks eq @inputobj-werks.
    "<<BMR 27.08.2020 - Erro Lote sem Tipo de avaliação
    ls_goodsmvt_item-batch = components_st-batch.
    append ls_goodsmvt_item to lt_goodsmvt_item.
  endif.

*Check if structure of aditional material was filled
  if adit_matnr_st is not initial.

    lv_umb = adit_matnr_st-meins.

    if adit_matnr_st-matnr na sy-abcde.
*    Material
      call function 'CONVERSION_EXIT_MATN1_INPUT'
        exporting
          input        = adit_matnr_st-matnr
        importing
          output       = ls_goodsmvt_item-material
        exceptions
          length_error = 1
          others       = 2.
    else.
      ls_goodsmvt_item-material = adit_matnr_st-matnr.
    endif.

    translate ls_goodsmvt_item-material to upper case.

*    ls_goodsmvt_item-material = adit_matnr_st-matnr.
*  Quantity
    ls_goodsmvt_item-entry_qnt = adit_matnr_st-consqty.
*  Unit
    ls_goodsmvt_item-entry_uom = adit_matnr_st-meins.

**  Storage Location
ls_goodsmvt_item-stge_loc = lv_conslgort_var.
*    if lv_ordertype eq lc_multimat_cst.
*      ls_goodsmvt_item-stge_loc = lv_conslgort_var.
*    endif.
*    if lv_ordertype eq lc_one_matr_cst.
*      if adit_matnr_st-lgort is initial.
*        "consumos adicionais
*        ls_goodsmvt_item-stge_loc = lv_cons_add_var.
*      else.
*        "consumos previstos mas com lote diferente
*        ls_goodsmvt_item-stge_loc = adit_matnr_st-lgort.
*      endif.
*    endif.

    ls_goodsmvt_item-batch = adit_matnr_st-batch.
    ">>BMR 27.08.2020 - Erro Lote sem Tipo de avaliação
    select single bwtar
      from mcha
      into @ls_goodsmvt_item-val_type
        where charg eq @ls_goodsmvt_item-batch
          and matnr eq @ls_goodsmvt_item-material
          and werks eq @inputobj-werks.
    "<<BMR 27.08.2020 - Erro Lote sem Tipo de avaliação
    append ls_goodsmvt_item to lt_goodsmvt_item.
  endif.

*********************
  call function 'BAPI_GOODSMVT_CREATE'
    exporting
      goodsmvt_header  = ls_goodsmvt_header
      goodsmvt_code    = ls_goodsmvt_code
    importing
      goodsmvt_headret = ls_goodsmvt_headret
      materialdocument = l_materialdocument
      matdocumentyear  = l_matdocumentyear
    tables
      goodsmvt_item    = lt_goodsmvt_item
      return           = return_tab.

  if return_tab[] is initial.
    call function 'BAPI_TRANSACTION_COMMIT'
      exporting
        wait = 'X'.
    "actualizar tabela de sequenciadores
    if lv_batchconsumed_var is not initial.
      select single *
        from zabsf_sequence_t
        into @data(ls_sequence_str)
          where charg eq @lv_batchconsumed_var
            and seq_lantek eq @space.
      if sy-subrc eq 0.
        "actualizar sequenciador do lantek
        ls_sequence_str-seq_lantek = lv_seqlantek_var.
        "actualizar tabela
        update zabsf_sequence_t from ls_sequence_str.
        commit work and wait.
      endif.
    endif.
*  Send message sucess.
    call method zabsf_pp_cl_log=>add_message
      exporting
        msgty      = 'S'
        msgno      = '034'
        msgv1      = l_materialdocument
      changing
        return_tab = return_tab.
  endif.
endmethod.


  METHOD zif_absf_pp_consumptions~create_transf_post.
    DATA:
      lv_materialdocument TYPE bapi2017_gm_head_ret-mat_doc.

*Movement type
    CONSTANTS:
      lc_goodsmvt_code TYPE bapi2017_gm_code VALUE '04'. "MB1B – Transfer Posting

    TRANSLATE inputobj-oprid TO UPPER CASE.

*Header of material document
    DATA(ls_header) =
      VALUE bapi2017_gm_head_01(
        pstng_date = sy-datum
        doc_date   = sy-datum
        pr_uname   = inputobj-oprid ).

*Data to create movement
    DATA(lt_items) =
      VALUE bapi2017_gm_item_create_t( (
        plant = inputobj-werks "Plant
        move_type  = '311' "Movement Type
        material   = iv_matnr
        entry_qnt  = iv_lmnga
        entry_uom  = iv_meins
        stge_loc   = iv_slgort
        move_stloc = iv_dlgort ) ).

*Create consumption of the Production Order
    CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
      EXPORTING
        goodsmvt_header  = ls_header
        goodsmvt_code    = lc_goodsmvt_code
      IMPORTING
        materialdocument = lv_materialdocument
      TABLES
        goodsmvt_item    = lt_items
        return           = ct_return.

    IF ct_return[] IS INITIAL.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = 'X'.

      CALL METHOD zcl_lp_pp_sf_log=>add_message
        EXPORTING
          msgty      = 'S'
          msgno      = '034'
          msgv1      = lv_materialdocument
        CHANGING
          return_tab = ct_return.
    ENDIF.
  ENDMETHOD.


method zif_absf_pp_consumptions~get_batch_consumed.
    "variáveis locais
    data: ls_batch_consumed type zabsf_pp_s_batch_consumed,
          l_matnr           type matnr,
          l_charg           type charg_d,
          l_erfmg           type erfmg,
          l_erfme           type erfme.
    "obter movimentos da ordem
    select * from aufm
     into table @data(lt_afwi)
      where aufnr eq @aufnr
      and bwart eq '261'.

    if lt_afwi[] is not initial.
      loop at lt_afwi into data(ls_afwi).
**              Get consumed quantity
*        select single matnr, charg, erfmg, erfme
*          from aufm
*          into (@data(l_matnr),@data(l_charg),@data(l_erfmg),@data(l_erfme))
*         where mblnr eq @ls_afwi-mblnr
*           and mjahr eq @ls_afwi-mjahr
*           "and zeile eq @ls_afwi-mblpo
*           and aufnr eq @aufnr
*           and werks eq @inputobj-werks
*           and bwart eq '261'.

        l_matnr = ls_afwi-matnr.
        l_charg = ls_afwi-charg.
        l_erfmg = ls_afwi-erfmg.
        l_erfme = ls_afwi-erfme.

        if sy-subrc eq 0.
*                Check if exist record for material and batch
          read table batch_consumed_tab assigning field-symbol(<fs_batch_consumed>) with key matnr = l_matnr
                                                                                             batch = l_charg.
          if sy-subrc eq 0.
*                  Sum consumed quantity
            add l_erfmg to <fs_batch_consumed>-ivbsu.
          else.
            clear ls_batch_consumed.

*                  Material
            ls_batch_consumed-matnr = l_matnr.

*                  Get material description
            select single maktx
              from makt
              into @ls_batch_consumed-maktx
             where matnr eq @l_matnr
               and spras eq @sy-langu.

*                  Batch
            ls_batch_consumed-batch = l_charg.

*                  Consumed quantity
            ls_batch_consumed-ivbsu = l_erfmg.

*                  Unit of measurement
            ls_batch_consumed-meins = l_erfme.

            append ls_batch_consumed to batch_consumed_tab.
          endif.
        endif.
      endloop.
    endif.
    "obter descrição dos materiais
    loop at batch_consumed_tab assigning field-symbol(<fs_consumed_str>).
      zcl_mm_classification=>get_material_desc_by_batch( exporting
                                                           im_material_var    = <fs_consumed_str>-matnr
                                                           im_batch_var       = <fs_consumed_str>-batch
                                                         importing
                                                           ex_description_var = data(lv_descript_var) ).
      "verificar se caracteristica está preenchida
      if lv_descript_var is not initial.
        "descrição da caracterização
        <fs_consumed_str>-maktx = lv_descript_var.
      endif.
    endloop.
  endmethod.


METHOD zif_absf_pp_consumptions~get_components_matnr.
  DATA: it_stlnr      TYPE TABLE OF ty_stlnr,
        it_mdpmx      TYPE TABLE OF mdpm,
        it_mdpmx_aux  TYPE TABLE OF mdpm,
        it_pzpsx      TYPE TABLE OF pzps,
        it_rplmz      TYPE TABLE OF rplmz,
        it_rplmz_aux  TYPE TABLE OF rplmz,
        it_rplmz_new  TYPE TABLE OF rplmz,
        it_plmz_stlnr TYPE TABLE OF ty_range_comp, "Components of BOM List assigned reporting point(Operation)
        it_makt       TYPE TABLE OF makt,
        it_afko       TYPE TABLE OF afko,
        it_aufk       TYPE TABLE OF aufk.

  DATA: wa_stlnr       TYPE ty_stlnr,
        wa_mdpmx       TYPE mdpm,
        wa_pzpsx       TYPE pzps,
        wa_rplmz       TYPE rplmz,
        wa_makt        TYPE makt,
        wa_components  TYPE zabsf_pp_s_components,
        wa_plmz_stlnr  TYPE ty_range_comp, "Components of BOM List assigned reporting point(Operation)
        wa_afko        TYPE afko,
        wa_aufk        TYPE aufk,
        ls_mtcom       TYPE mtcom,
        ls_mt61d       TYPE mt61d,
        ls_mtcor       TYPE mtcor,
        ls_mkal        TYPE mkal,
        ls_t399d       TYPE t399d,
        ls_t438m       TYPE t438m,
        ls_ecm61m      TYPE cm61m,
        ls_emt61d      TYPE mt61d,
        ls_eplaf       TYPE plaf,
        ld_pkosa       TYPE aufnr,
        ld_stlkn       TYPE stlkn,
        ls_am61b       TYPE barm_type_am61b,
        ld_objnr       TYPE jest-objnr,
        ls_t437d       TYPE t437d,
        ld_rsnum       TYPE sesta-rsnum,
        ld_flag_create TYPE c VALUE 'X',
        ld_procnr      TYPE ckml_f_procnr,
        ld_aufnr       TYPE aufnr.

  CONSTANTS c_objty(2) TYPE c VALUE 'OR'.

  REFRESH: it_stlnr,
           it_mdpmx,
           it_pzpsx,
           it_rplmz,
           it_plmz_stlnr,
           it_makt,
           it_afko,
           it_aufk.

  CLEAR: wa_stlnr,
         wa_mdpmx,
         wa_pzpsx,
         wa_rplmz,
         wa_makt,
         wa_components,
         wa_plmz_stlnr,
         wa_afko,
         wa_aufk,
         ls_mtcom,
         ls_mt61d,
         ls_mtcor,
         ls_mkal,
         ls_t399d,
         ls_t438m,
         ls_ecm61m,
         ls_emt61d,
         ls_eplaf,
         ld_pkosa,
         ld_stlkn,
         ls_am61b,
         ld_objnr,
         ls_t437d,
         ld_rsnum,
         ld_procnr,
         ld_aufnr.

*Master data Material - Communication
*View ID
  MOVE 'MT61D'        TO ls_mtcom-kenng.
*Language
  MOVE sy-langu       TO ls_mtcom-spras.
*Material
  MOVE matnr          TO ls_mtcom-matnr.
*Plant
  MOVE inputobj-werks TO ls_mtcom-werks.
*Rest buffer
  MOVE 'X'            TO ls_mtcom-kzrfb.

*Read master data of material
  CALL FUNCTION 'MATERIAL_READ'
    EXPORTING
      schluessel         = ls_mtcom
    IMPORTING
      matdaten           = ls_mt61d
      return             = ls_mtcor
    EXCEPTIONS
      material_not_found = 04
      plant_not_found    = 04.

* Get data from mkal
  SELECT SINGLE *
    FROM mkal
    INTO CORRESPONDING FIELDS OF ls_mkal
   WHERE matnr EQ matnr
     AND werks EQ inputobj-werks
     AND serkz EQ 'X'
     AND adatu LE refdt
     AND bdatu GE refdt.

*Filled data in eplaf
*Material
  ls_eplaf-matnr = matnr.
*Plant
  ls_eplaf-plwrk = inputobj-werks.
*Production plant
  ls_eplaf-pwwrk = inputobj-werks.
*Order type
  ls_eplaf-paart = 'LA'.
*Procurement Type
  ls_eplaf-beskz = 'E'.
*Quantity
  ls_eplaf-gsmng = lmnga.
*Date
  ls_eplaf-psttr = refdt.
  ls_eplaf-pedtr = refdt.
  ls_eplaf-pertr = refdt.
*Storage location
  ls_eplaf-lgort = ls_mkal-alort.
*Date
  ls_eplaf-paltr = refdt.
*BOM Usage
  ls_eplaf-stlan = ls_mkal-stlan.
*BOM list alternative
  ls_eplaf-stalt = ls_mkal-stlal.
*Production Version
  ls_eplaf-verid = ls_mkal-verid.
*Unit
  ls_eplaf-meins = meins.

*Control parameters for MRP
  SELECT SINGLE cslid prreg kzdrb
    FROM t399d
    INTO CORRESPONDING FIELDS OF ls_t399d
    WHERE werks EQ inputobj-werks.

*Control parameters for MRP - Material
  SELECT SINGLE prreg kzdrb plsel
    FROM t438m
    INTO CORRESPONDING FIELDS OF ls_t438m
    WHERE werks EQ inputobj-werks
      AND mtart EQ ls_mt61d-disgr.


*Code for control MRP - Material
  IF ls_t438m-prreg IS NOT INITIAL.
*  Checking Rule
    ls_ecm61m-prreg = ls_t438m-prreg.
  ELSE.
*  Checking Rule
    ls_ecm61m-prreg = ls_t399d-prreg.
  ENDIF.

*Direct procurement/production
  IF ls_t438m-kzdrb IS NOT INITIAL.
    ls_ecm61m-kzdrb = ls_t438m-kzdrb.
  ELSE.
    ls_ecm61m-kzdrb = ls_t399d-kzdrb.
  ENDIF.

*Issue Storage Location Selection
  IF ls_t438m-plsel IS NOT INITIAL.
    ls_ecm61m-plsel = ls_t438m-plsel.
  ENDIF.

*Get component of planned order
  CALL FUNCTION 'MD_AUFLOESUNG_PLANAUFTRAG'
    EXPORTING
      ecm61m    = ls_ecm61m
      emt61d    = ls_mt61d
      eplaf     = ls_eplaf
      eselid    = ls_t399d-cslid
      eno_scrap = 'X'
    TABLES
      mdpmx     = it_mdpmx.

  IF it_mdpmx[] IS NOT INITIAL.
    MOVE it_mdpmx[] TO it_mdpmx_aux[].

    CLEAR wa_mdpmx.

    LOOP AT it_mdpmx_aux INTO wa_mdpmx WHERE dbskz NE space " falls Direktbesch.
                                      OR sgtps NE space " falls Schüttgut
                                      OR inpos NE space " note 332009: Intra materials
                                      OR txtps NE space.

      IF wa_mdpmx-dumps IS NOT INITIAL.
        IF wa_mdpmx-sgtps NE space.
          CALL METHOD zabsf_pp_cl_log=>add_message
            EXPORTING
              msgid      = 'RM'
              msgty      = 'E'
              msgno      = '228'
            CHANGING
              return_tab = return_tab.
        ELSE.
          CONTINUE.
        ENDIF.
      ENDIF.

      DELETE TABLE it_mdpmx FROM wa_mdpmx.
    ENDLOOP.

*  Get description for all material in planned order
    SELECT *
      FROM makt
      INTO CORRESPONDING FIELDS OF TABLE it_makt
      FOR ALL ENTRIES IN it_mdpmx
     WHERE matnr EQ it_mdpmx-matnr
       AND spras EQ sy-langu.

*  Get bill material
    LOOP AT it_mdpmx INTO wa_mdpmx.
      CLEAR wa_stlnr.

      MOVE: wa_mdpmx-stlnr TO wa_stlnr-stlnr,
            wa_mdpmx-stlty TO wa_stlnr-stlty.

      READ TABLE it_stlnr INTO wa_stlnr WITH KEY stlnr = wa_stlnr-stlnr
                                                 stlty = wa_stlnr-stlty.

      IF sy-subrc NE 0.
        APPEND wa_stlnr TO it_stlnr.
      ENDIF.
    ENDLOOP.

*  Bill material
    LOOP AT it_stlnr INTO wa_stlnr.
      REFRESH it_rplmz_aux.

      CALL FUNCTION 'RM_PLMZ_READ_BY_BOM'
        EXPORTING
          plnal             = ls_mkal-alnal
          plnnr             = ls_mkal-plnnr
          plnty             = ls_mkal-plnty
*         STLAL             = STLAL
          stlnr             = wa_stlnr-stlnr
          stlty             = wa_stlnr-stlty
          sttag             = refdt
        TABLES
          rplmz_exp         = it_rplmz_aux
        EXCEPTIONS
          routing_not_found = 1
          OTHERS            = 2.

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
        APPEND LINES OF it_rplmz_aux TO it_rplmz.
      ENDIF.
    ENDLOOP.

*  Get Production Process
    SELECT SINGLE procnr
      FROM pkosa_proc_a
      INTO ld_procnr
     WHERE werks EQ inputobj-werks
       AND matnr EQ matnr
       AND verid_nd EQ ls_mkal-verid.

*  Get Production Process
    SELECT SINGLE aufnr
      FROM aufk
      INTO ld_aufnr
     WHERE werks  EQ inputobj-werks
       AND procnr EQ ld_procnr.

    ld_pkosa = ld_aufnr.

*  Create abject fo cost collector
    CONCATENATE c_objty ld_pkosa INTO ld_objnr.

*  Create Number of Reservation
    CALL FUNCTION 'RM_CHECK_RESCO'
      EXPORTING
        i_am61b         = ls_am61b
        i_objnr         = ld_objnr
        i_t437d         = ls_t437d
        i_flag_create   = ld_flag_create
      IMPORTING
        e_rsnum         = ld_rsnum
      EXCEPTIONS
        create_error    = 1
        lock_error      = 2
        transfer_error  = 3
        inconsist_error = 4.

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
    ENDIF.

*  Get reporting point of Cost Collector
    CALL FUNCTION 'RM_CPZP_READ'
      EXPORTING
        i_pkosa      = ld_pkosa
        i_verid      = ls_mkal-verid
        i_datum      = refdt
      TABLES
        e_pzps       = it_pzpsx
      EXCEPTIONS
        data_in_pzpp = 1
        not_found    = 2
        wrong_input  = 3
        date_error   = 4
        OTHERS       = 5.

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
    ENDIF.

    READ TABLE it_pzpsx INTO wa_pzpsx WITH KEY vorne = vornr.

    REFRESH it_rplmz_new.

    CALL FUNCTION 'RM_RPLMZ_ENRICH_FOR_DUMMIES'
      TABLES
        i_rplmzx = it_rplmz
        i_mdpmx  = it_mdpmx
        e_rplmzx = it_rplmz_new.

    REFRESH it_rplmz.

    MOVE it_rplmz_new[] TO it_rplmz[].

*  Get BOM item node number assigned to reporting point
    LOOP AT it_rplmz INTO wa_rplmz WHERE plnkn EQ wa_pzpsx-plnkn.
      CLEAR wa_plmz_stlnr.

*    BOM category
      MOVE wa_rplmz-stlty TO wa_plmz_stlnr-stlty.
*    BOM list
      MOVE wa_rplmz-stlnr TO wa_plmz_stlnr-stlnr.
*    BOM item node number
      MOVE wa_rplmz-stlkn TO wa_plmz_stlnr-stknr.

      APPEND wa_plmz_stlnr TO it_plmz_stlnr.
    ENDLOOP.

    CLEAR wa_mdpmx.

*  Get components assigned to reporting point
    LOOP AT it_mdpmx INTO wa_mdpmx.
      CLEAR: wa_components,
             wa_plmz_stlnr,
             wa_makt,
             ld_stlkn.

*    BOM item node number
      IF NOT wa_mdpmx-stvkn IS INITIAL.
        MOVE wa_mdpmx-stvkn TO ld_stlkn.
      ELSE.
        MOVE wa_mdpmx-stknr TO ld_stlkn.
      ENDIF.

*    Check if exist this component assigned to reporting point
      READ TABLE it_plmz_stlnr INTO wa_plmz_stlnr WITH KEY stlty = wa_mdpmx-stlty
                                                           stlnr = wa_mdpmx-stlnr
                                                           stknr = ld_stlkn.

      IF sy-subrc EQ 0.
*      Component
        wa_components-matnr = wa_mdpmx-matnr.
*      Description component
        READ TABLE it_makt INTO wa_makt WITH KEY matnr = wa_components-matnr.

        IF sy-subrc EQ 0.
          wa_components-maktx = wa_makt-maktx.
        ENDIF.

*      Quantity
        wa_components-bdmng = wa_mdpmx-erfmg.
*      Quantity withdrawn
        wa_components-enmng = wa_mdpmx-enmng.
*      Quantity to consume
** BEGIN JOL: 16/12/2022 - integer consqty value
        wa_components-consqty = CONV i( wa_mdpmx-erfmg - wa_mdpmx-enmng ).
** END JOL: 16/12/2022
*      Unit
        wa_components-meins = wa_mdpmx-lagme.
*      Storage Location
        wa_components-lgort = wa_mdpmx-lgpro.
*      Number of Reservation
        wa_components-rsnum = ld_rsnum.
*      Item Number of Reservation
        wa_components-rspos = wa_mdpmx-rspos.

        APPEND wa_components TO components_tab.
      ENDIF.
    ENDLOOP.
  ELSE.
*  Operation not completed successfully
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'E'
        msgno      = '012'
      CHANGING
        return_tab = return_tab.
  ENDIF.
ENDMETHOD.


METHOD zif_absf_pp_consumptions~get_components_order.
*Internal tables
  DATA: lt_mov_261 TYPE TABLE OF aufm,
        lt_mov_262 TYPE TABLE OF aufm.

*Structures
  DATA: ls_components       TYPE zabsf_pp_s_components,
        ls_mov_261          TYPE aufm,
        ls_mov_262          TYPE aufm,
        lr_charseq_rng      TYPE RANGE OF atnam,
        lv_sequenciador_var TYPE zabsf_pp_e_seq.

*Variables
  DATA: l_aufnr TYPE aufnr,
        l_vornr TYPE vornr.

  DATA: lr_largura_rng     TYPE RANGE OF atnam,
        lr_comprimento_rng TYPE RANGE OF atnam,
        lr_referencia_rng  TYPE RANGE OF atnam.

*Convert to input format
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = aufnr
    IMPORTING
      output = l_aufnr.

*Convert to INPUT FORMAT
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = vornr
    IMPORTING
      output = l_vornr.


*  try.
*      "caracteristica comprimento
*      zcl_bc_fixed_values=>get_ranges_value( exporting
*                                               im_paramter_var = zcl_bc_fixed_values=>gc_charcomp_cst
*                                               im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
*                                             importing
*                                               ex_valrange_tab = lr_comprimento_rng ).
*      "caracteristica largura
*      zcl_bc_fixed_values=>get_ranges_value( exporting
*                                               im_paramter_var = zcl_bc_fixed_values=>gc_charlarg_cst
*                                               im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
*                                             importing
*                                               ex_valrange_tab = lr_largura_rng ).
*      "caracteristica referência
*      zcl_bc_fixed_values=>get_ranges_value( exporting
*                                               im_paramter_var = zcl_bc_fixed_values=>gc_charrefer_cst
*                                               im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
*                                             importing
*                                               ex_valrange_tab = lr_referencia_rng )..
*    catch zcx_bc_exceptions into data(lo_bcexceptions_obj).
*      "falta configuração
*      call method zabsf_pp_cl_log=>add_message
*        exporting
*          msgty      = lo_bcexceptions_obj->msgty
*          msgno      = lo_bcexceptions_obj->msgno
*          msgid      = lo_bcexceptions_obj->msgid
*          msgv1      = lo_bcexceptions_obj->msgv1
*          msgv2      = lo_bcexceptions_obj->msgv2
*          msgv3      = lo_bcexceptions_obj->msgv3
*          msgv4      = lo_bcexceptions_obj->msgv4
*        changing
*          return_tab = return_tab.
*      return.
*  endtry.

  "order type
  SELECT SINGLE auart, werks
    FROM aufk
    INTO ( @DATA(lv_ordettyp_var), @DATA(lv_plant_var) )
      WHERE aufnr EQ @aufnr.

********** REPACKING 10.05.2017
*  Get work center
  SELECT SINGLE crhd~arbpl
    FROM afko AS afko
   INNER JOIN afvc AS afvc
      ON afvc~aufpl EQ afko~aufpl
   INNER JOIN crhd AS crhd
      ON crhd~objty EQ 'A'
     AND crhd~objid EQ afvc~arbid
   WHERE afko~aufnr EQ @l_aufnr
     AND afvc~vornr EQ @l_vornr
     AND afvc~werks EQ @inputobj-werks
    INTO (@DATA(lv_arbpl)).

* Get data from Order
  SELECT SINGLE *
    FROM aufk
    INTO @DATA(ls_aufk)
    WHERE aufnr EQ @l_aufnr.

* Get Work center type
  SELECT SINGLE arbpl_type
    FROM zabsf_pp013
    INTO (@DATA(l_arbplty))
   WHERE areaid EQ @areaid
     AND werks  EQ @ls_aufk-werks
     AND arbpl  EQ @lv_arbpl.

* Not Repacking
  IF ( l_arbplty <> 'R' ).
********** REPACKING 10.05.2017

*Get reserv number
    SELECT SINGLE rsnum
      FROM afko
      INTO (@DATA(l_rsnum))
     WHERE aufnr EQ @l_aufnr.

    SELECT *
      FROM resb
      INTO TABLE @DATA(lt_resb)
     WHERE rsnum EQ @l_rsnum
       AND aufnr EQ @l_aufnr
    "   and vornr eq @l_vornr
       AND werks EQ @inputobj-werks
       AND xloek EQ @space.


    IF sy-subrc EQ 0.
*  Get material with Batch management requirement indicator
      SELECT matnr, xchpf
        FROM mara
        INTO TABLE @DATA(lt_mara)
         FOR ALL ENTRIES IN @lt_resb
       WHERE matnr EQ @lt_resb-matnr.
*       AND xchpf EQ @abap_true.

      REFRESH: lt_mov_261,
               lt_mov_262.

      "todos os consumos com referência à reserva
      SELECT *
        FROM aufm
        INTO TABLE @DATA(lt_resb261_tab)
        FOR ALL ENTRIES IN @lt_resb
          WHERE aufnr EQ @aufnr
            AND bwart EQ '261'
            AND werks EQ @inputobj-werks
            AND rsnum EQ @lt_resb-rsnum
            AND rspos EQ @lt_resb-rspos.

      "consumos sem referencia à reserva
      DATA ls_resb TYPE resb.
      SELECT *
        FROM aufm
        INTO TABLE @DATA(lt_adhoc261_tab)
          WHERE aufnr EQ @aufnr
            AND bwart EQ '261'
            AND werks EQ @inputobj-werks
            AND rsnum EQ @ls_resb-rsnum
            AND rspos EQ @ls_resb-rspos.

*  Get material description for all components
      SELECT *
        FROM makt
        INTO TABLE @DATA(lt_makt)
         FOR ALL ENTRIES IN @lt_resb
       WHERE matnr EQ @lt_resb-matnr
         AND spras EQ @sy-langu.

*  Get material description for all components
      IF lt_adhoc261_tab[] IS NOT INITIAL.
        SELECT *
          FROM makt
          APPENDING TABLE @lt_makt
           FOR ALL ENTRIES IN @lt_adhoc261_tab
         WHERE matnr EQ @lt_adhoc261_tab-matnr
           AND spras EQ @sy-langu.

        "---consumos adicionais
        "obter documento estornados
        DATA: lt_devolutions TYPE TABLE OF mseg.
        SELECT *
          FROM mseg INTO TABLE lt_devolutions
          FOR ALL ENTRIES IN lt_adhoc261_tab
          WHERE aufnr EQ l_aufnr
          AND werks EQ inputobj-werks
          AND bwart EQ '262'
          AND smbln EQ lt_adhoc261_tab-mblnr
          AND smblp EQ lt_adhoc261_tab-zeile.
        IF sy-subrc EQ 0.
          "remover os estornados
          LOOP AT lt_adhoc261_tab INTO DATA(ls_consumo_str).
            IF line_exists( lt_devolutions[ smbln = ls_consumo_str-mblnr
                                            smblp = ls_consumo_str-zeile ] ).
              "remover documento da lista
              DELETE lt_adhoc261_tab.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDIF.

      "obter documento estornados
      IF lt_resb261_tab IS NOT INITIAL.
        REFRESH lt_devolutions.
        SELECT *
          FROM mseg INTO TABLE lt_devolutions
          FOR ALL ENTRIES IN lt_resb261_tab
          WHERE aufnr EQ l_aufnr
          AND werks EQ inputobj-werks
          AND bwart EQ '262'
          AND smbln EQ lt_resb261_tab-mblnr
          AND smblp EQ lt_resb261_tab-zeile.
        IF sy-subrc EQ 0.
          "remover os estornados
          LOOP AT lt_resb261_tab INTO ls_consumo_str.
            IF line_exists( lt_devolutions[ smbln = ls_consumo_str-mblnr
                                            smblp = ls_consumo_str-zeile ] ).
              "remover documento da lista
              DELETE lt_resb261_tab.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDIF.

      "------

      "materiais da reserva
      LOOP AT lt_resb INTO ls_resb.
        CLEAR ls_components.

        ls_components-rsnum = ls_resb-rsnum.
        ls_components-rspos = ls_resb-rspos.

* object id
        ls_components-cuobj = ls_resb-cuobj.
*    Check Batch management requirement indicator
        READ TABLE lt_mara INTO DATA(ls_mara) WITH KEY matnr = ls_resb-matnr.

        IF sy-subrc EQ 0.
*      Material
          ls_components-matnr = ls_resb-matnr.
*      Material description
          READ TABLE lt_makt INTO DATA(ls_makt) WITH KEY matnr = ls_resb-matnr.

          IF sy-subrc EQ 0.
            ls_components-maktx = ls_makt-maktx.
          ENDIF.

          "quantidade necessária
          ls_components-bdmng = ls_resb-erfmg.
*    Negative quantity
          IF ls_resb-shkzg EQ 'S'.
            ls_components-bdmng = ls_components-bdmng * -1.
          ENDIF.

          "quantidade consumida
          IF ls_resb-meins NE ls_resb-erfme.
            IF ls_resb-bdmng IS NOT INITIAL.
              ls_components-consqty = ls_resb-enmng / ls_resb-bdmng.
            ENDIF.
          ELSE.
            "quantidade retirada
            ls_components-consqty = ls_resb-enmng.
          ENDIF.

*      Unit
*          ls_components-meins = ls_resb-meins.
          ls_components-meins = ls_resb-erfme.
*      Storage Location
          ls_components-lgort = ls_resb-lgort.

*      Operation number
          ls_components-vornr = ls_resb-vornr.

          IF lv_ordettyp_var EQ 'ZPP2'.
            READ TABLE lt_resb INTO ls_resb WITH KEY rspos = ls_components-rspos
                                                     rsnum = ls_components-rsnum.
            "get description as CO02
            zcl_mm_classification=>get_desc_as_co02( EXPORTING
                                                       im_resb_str = ls_resb
                                                     IMPORTING
                                                       ex_description_var = DATA(lv_desctpt2_var) ).
            "decrição
            IF lv_desctpt2_var IS NOT INITIAL.
              ls_components-maktx = lv_desctpt2_var.
            ENDIF.
          ELSE.
            "obter descrição do componente
            zcl_mm_classification=>get_material_desc_by_object( EXPORTING
                                                                  im_cuobj_var       = ls_components-cuobj
                                                                IMPORTING
                                                                  ex_description_var = DATA(lv_descript_var) ).
            "descrição
            IF lv_descript_var IS NOT INITIAL.
              ls_components-maktx = lv_descript_var.
            ENDIF.
          ENDIF.

          DATA(lv_matname_var) =  COND #( WHEN lv_desctpt2_var IS NOT INITIAL
                                          THEN lv_desctpt2_var
                                          ELSE lv_descript_var ).
          "verificar se material é gerido a unidades
          SELECT SINGLE *
            FROM marm
            INTO @DATA(ls_marm_str)
              WHERE matnr EQ @ls_components-matnr
                AND meinh EQ 'UN'.
          IF sy-subrc EQ 0.
            ls_components-meins_unit = 'UN'.
          ENDIF.

          IF ls_components-meins EQ 'UN'.
            ls_components-menge_unit = ls_components-bdmng.
          ELSE.
            "quantidade em unidades
            IF ls_components-meins_unit EQ 'UN'.
              zabsf_pp_cl_tracking=>convert_to_units( EXPORTING
                                         im_quantity_var = abs( ls_components-bdmng )
                                         im_qttyunit_var = ls_components-meins
                                         im_material_var = ls_components-matnr
                                         im_batchnum_var = ls_components-batch
                                       IMPORTING
                                         ex_units_var    = ls_components-menge_unit ).
            ENDIF.
          ENDIF.

          IF ls_components-batch IS INITIAL.
            ls_components-batch = ls_resb-charg.
          ENDIF.

          IF l_vornr IS NOT INITIAL AND ls_mara-xchpf EQ abap_true.
            APPEND ls_components TO components_tab.
          ENDIF.

*          if l_vornr is initial.
*        Batch management requirement indicator
          ls_components-xchpf = ls_mara-xchpf.

          APPEND ls_components TO components_tab.
        ENDIF.
*       endif.
        CLEAR: lv_desctpt2_var, lv_descript_var, ls_components.
      ENDLOOP.

*>>PAP 21.03.2017 17:32:01 - Available stock
*  Get work center
      SELECT SINGLE crhd~arbpl
        FROM afko AS afko
       INNER JOIN afvc AS afvc
          ON afvc~aufpl EQ afko~aufpl
       INNER JOIN crhd AS crhd
          ON crhd~objty EQ 'A'
         AND crhd~objid EQ afvc~arbid
       WHERE afko~aufnr EQ @l_aufnr
         AND afvc~vornr EQ @l_vornr
         AND afvc~werks EQ @inputobj-werks
        INTO (@DATA(l_arbpl)).
*<<PAP 21.03.2017 17:32:01 - Available stock
    ELSE.
      IF l_vornr IS INITIAL.
*    No data found
        CALL METHOD zabsf_pp_cl_log=>add_message
          EXPORTING
            msgty      = 'E'
            msgno      = '018'
          CHANGING
            return_tab = return_tab.
      ELSE.
*    No data found
        CALL METHOD zabsf_pp_cl_log=>add_message
          EXPORTING
            msgty      = 'I'
            msgno      = '018'
          CHANGING
            return_tab = return_tab.
      ENDIF.
    ENDIF.
  ENDIF.

*>>BMR 16.04.2018 - remover os subprodutos da listagem = linhas com qtd a negativo.
  IF for_subproducts EQ abap_true.
    DELETE components_tab
      WHERE bdmng GE 0.
    "trocar o sinal das quantidades
    LOOP AT components_tab ASSIGNING FIELD-SYMBOL(<fs_components>).
      <fs_components>-bdmng = <fs_components>-bdmng * -1.
    ENDLOOP.
  ELSE.
    "remover
    DELETE components_tab
      WHERE bdmng LE 0
        AND rsnum IS NOT INITIAL
        AND rspos IS NOT INITIAL.
  ENDIF.

  IF components_tab IS NOT INITIAL.
    SELECT *
      FROM marc
      INTO TABLE @DATA(lt_marc_tab)
      FOR ALL ENTRIES IN @components_tab
      WHERE matnr EQ @components_tab-matnr
        AND werks EQ @lv_plant_var
        AND xchpf EQ @abap_true.
  ENDIF.

  "agrupar linhas por material lote
  CLEAR ls_resb.
  DATA(lt_comm_tab) = components_tab.

  "linhas da reserva para consumir
  LOOP AT lt_comm_tab INTO DATA(ls_com_str)
    WHERE rsnum NE ls_resb-rsnum.
    "verificar se material é gerido a lotes
    IF line_exists( lt_marc_tab[ matnr = ls_com_str-matnr
                                 werks = lv_plant_var ] ) AND ls_com_str-batch IS INITIAL.
      "se for gerido a lote e não tive lote preenchido, não deve passar para o SF
      CONTINUE.
    ENDIF.
    "qtt consumida
    ls_com_str-enmng = ls_com_str-consqty.
    "limpar nº da reserva
    CLEAR: ls_com_str-rsnum, ls_com_str-rspos, ls_com_str-consqty.
    "adicionar linha
    APPEND ls_com_str TO components_tab.
  ENDLOOP.


  DATA(lt_auxadhoc_tab) = lt_adhoc261_tab.
  SORT lt_auxadhoc_tab BY matnr charg erfme.
  DELETE ADJACENT DUPLICATES FROM lt_auxadhoc_tab COMPARING matnr charg erfme.

  "percorrer todos os consumos ad-hoc
  LOOP AT lt_auxadhoc_tab ASSIGNING FIELD-SYMBOL(<fs_adhoc_st>).
*      Material
    ls_components-matnr = <fs_adhoc_st>-matnr.
*      Material description
    READ TABLE lt_makt INTO DATA(ls_makt2) WITH KEY matnr = <fs_adhoc_st>-matnr.

    IF sy-subrc EQ 0.
      ls_components-maktx = ls_makt2-maktx.
    ENDIF.

    LOOP AT lt_adhoc261_tab ASSIGNING FIELD-SYMBOL(<fs_adhoc261>)
      WHERE matnr EQ <fs_adhoc_st>-matnr
        AND charg EQ <fs_adhoc_st>-charg
        AND erfme EQ <fs_adhoc_st>-erfme.
      "quantidade consumida
      ls_components-enmng = ls_components-enmng + <fs_adhoc261>-erfmg.
    ENDLOOP.


    ls_components-meins = <fs_adhoc_st>-erfme.
*      Storage Location
    ls_components-lgort = <fs_adhoc_st>-lgort.

    "decrição do lote
    zcl_mm_classification=>get_material_desc_by_batch( EXPORTING
                                                         im_material_var    = <fs_adhoc_st>-matnr
                                                         im_batch_var       = <fs_adhoc_st>-charg
                                                       IMPORTING
                                                         ex_description_var = DATA(lv_matdesc_var) ).

    "descrição
    IF lv_matdesc_var IS NOT INITIAL.
      ls_components-maktx = lv_matdesc_var.
    ENDIF.
    "lotes
    ls_components-batch = <fs_adhoc_st>-charg.
    "verificar se já foi considerado este lote na reserva
    LOOP AT components_tab INTO DATA(ls_comp)
      WHERE matnr = ls_components-matnr
        AND maktx = ls_components-maktx
        AND batch = ls_components-batch
        AND rsnum <> ls_resb-rsnum.
      EXIT.
    ENDLOOP.

    IF ls_comp IS NOT INITIAL.
      "verificar se lote já foi adicionado previamente à tabela
      READ TABLE components_tab ASSIGNING FIELD-SYMBOL(<fs_comp>) WITH KEY matnr = <fs_adhoc_st>-matnr
                                                                           maktx = lv_matdesc_var
                                                                           batch = <fs_adhoc_st>-charg
                                                                           rsnum = ls_resb-rsnum.
      IF <fs_comp> IS ASSIGNED.
        <fs_comp>-enmng = <fs_comp>-enmng +  ls_components-enmng.
      ELSE.
        "adicionar linha de consumos fora da reserva
        APPEND ls_components TO components_tab.
      ENDIF.
    ELSE.
      "adicionar linha de consumos fora da reserva
      APPEND ls_components TO components_tab.
    ENDIF.


    "limpar variáveis
    CLEAR: lv_matdesc_var, ls_makt2, ls_components, ls_comp.
  ENDLOOP.


***  "sequenciador
  TRY.
      zcl_bc_fixed_values=>get_ranges_value( EXPORTING
                                               im_paramter_var = zcl_bc_fixed_values=>gc_charseq_cst
                                               im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
                                             IMPORTING
                                               ex_valrange_tab = lr_charseq_rng ).
    CATCH zcx_pp_exceptions.
  ENDTRY.

  "sequenciador lantek
  IF lr_charseq_rng IS INITIAL.
    "sair do processamento
    RETURN.
  ENDIF.


  "obter o sequenciador lantek de cada lote consumido
  LOOP AT components_tab ASSIGNING FIELD-SYMBOL(<fs_component_str>)
    WHERE batch IS NOT INITIAL.
    "obter nº do sequenciador
    zcl_mm_classification=>get_classification_by_batch( EXPORTING
                                                          im_material_var       = <fs_component_str>-matnr
                                                          im_lote_var           = <fs_component_str>-batch
                                                        IMPORTING
                                                          ex_classification_tab = DATA(lt_classific_tab) ).
    LOOP AT lt_classific_tab INTO DATA(ls_classific_str)
      WHERE atnam IN lr_charseq_rng.
      "valor do sequenciador
      lv_sequenciador_var = ls_classific_str-ausp1.
      "sair do loop
      EXIT.
    ENDLOOP.


    "comprimento
    LOOP AT lt_classific_tab INTO ls_classific_str
      WHERE atnam IN lr_comprimento_rng.
      <fs_component_str>-length = ls_classific_str-ausp1.
      "sair do loop
      EXIT.
    ENDLOOP.
    "largura
    LOOP AT lt_classific_tab INTO ls_classific_str
      WHERE atnam IN lr_largura_rng.
      <fs_component_str>-width = ls_classific_str-ausp1.
      "sair do loop
      EXIT.
    ENDLOOP.

    "referência
    LOOP AT lt_classific_tab INTO ls_classific_str
      WHERE atnam IN lr_referencia_rng.
      <fs_component_str>-reference = ls_classific_str-ausp1.
      "sair do loop
      EXIT.
    ENDLOOP.

    "ler sequenciador da tabela
    SELECT SINGLE seq_lantek
      FROM zabsf_sequence_t
      INTO <fs_component_str>-seq_lantek
        WHERE charg EQ  <fs_component_str>-batch
         AND sequenciador EQ lv_sequenciador_var.
    "limpar variáveis
    CLEAR: lv_sequenciador_var, ls_classific_str.
  ENDLOOP.
ENDMETHOD.


METHOD zif_absf_pp_consumptions~rem_components_order.

*Internal tables
    DATA: lt_mov_261 TYPE TABLE OF aufm,
          lt_mov_262 TYPE TABLE OF aufm.

*Structures
    DATA: ls_components TYPE zabsf_pp_s_components,
          ls_mov_261    TYPE aufm,
          ls_mov_262    TYPE aufm.

*Variables
    DATA: l_aufnr TYPE aufnr,
          l_vornr TYPE vornr.

*Convert to input format
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = aufnr
      IMPORTING
        output = l_aufnr.

*Convert to INPUT FORMAT
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = vornr
      IMPORTING
        output = l_vornr.


*  Get work center
    SELECT SINGLE crhd~arbpl
      FROM afko AS afko
     INNER JOIN afvc AS afvc
        ON afvc~aufpl EQ afko~aufpl
     INNER JOIN crhd AS crhd
        ON crhd~objty EQ 'A'
       AND crhd~objid EQ afvc~arbid
     WHERE afko~aufnr EQ @l_aufnr
       AND afvc~vornr EQ @l_vornr
       AND afvc~werks EQ @inputobj-werks
      INTO (@DATA(l_arbpl)).


* Get data from Order
    SELECT SINGLE *
      FROM aufk
      INTO @DATA(ls_aufk)
      WHERE aufnr EQ @l_aufnr.

* Get Work center type
    SELECT SINGLE arbpl_type
      FROM zabsf_pp013
      INTO (@DATA(l_arbplty))
     WHERE areaid EQ 'PP01' "@areaid
       AND werks  EQ @ls_aufk-werks
       AND arbpl  EQ @l_arbpl.

* Not Repacking
    IF ( l_arbplty <> 'R' ).
*Get reserv number
      SELECT SINGLE rsnum
        FROM afko
        INTO (@DATA(l_rsnum))
       WHERE aufnr EQ @l_aufnr.

      IF l_vornr IS INITIAL.
*  Get Reservation/dependent requirements
        SELECT *
          FROM resb
          INTO TABLE @DATA(lt_resb)
         WHERE rsnum EQ @l_rsnum
           AND aufnr EQ @l_aufnr
           AND werks EQ @inputobj-werks
           AND xloek EQ @space.
*       AND rgekz NE @space.
      ELSE.
        REFRESH lt_resb.

*  Get Reservation/dependent requirements
        SELECT *
          FROM resb
          INTO TABLE @lt_resb
         WHERE rsnum EQ @l_rsnum
           AND aufnr EQ @l_aufnr
           AND vornr EQ @l_vornr
           AND werks EQ @inputobj-werks
           AND xloek EQ @space
           AND rgekz NE @space.
      ENDIF.

      IF sy-subrc EQ 0.
*  Get material with Batch management requirement indicator
        SELECT matnr, xchpf
          FROM mara
          INTO TABLE @DATA(lt_mara)
           FOR ALL ENTRIES IN @lt_resb
         WHERE matnr EQ @lt_resb-matnr.
*       AND xchpf EQ @abap_true.

*  Fill data to shopfloor
        LOOP AT lt_resb INTO DATA(ls_resb).
          CLEAR ls_components.

*    Check Batch management requirement indicator
          READ TABLE lt_mara INTO DATA(ls_mara) WITH KEY matnr = ls_resb-matnr.

          IF sy-subrc EQ 0.
*      Material
            ls_components-matnr = ls_resb-matnr.

*      Operation number
            ls_components-vornr = ls_resb-vornr.

*      Batch consumption
            SELECT SINGLE *
              FROM zabsf_pp069
              INTO @DATA(ls_lp_pp_sf069)
             WHERE werks EQ @inputobj-werks
               AND aufnr EQ @l_aufnr
               AND vornr EQ @l_vornr
               AND matnr EQ @ls_components-matnr.

            IF ( sy-subrc = 0 AND ls_mara-xchpf EQ abap_true ).
              DELETE ZABSF_PP069 FROM ls_lp_pp_sf069.
              IF ( sy-subrc = 0 ).
                COMMIT WORK AND WAIT.
              ENDIF.
            ENDIF.

          ENDIF.
        ENDLOOP.


      ELSE.
        IF l_vornr IS INITIAL.
*    No data found
          CALL METHOD zabsf_pp_cl_log=>add_message
            EXPORTING
              msgty      = 'E'
              msgno      = '018'
            CHANGING
              return_tab = return_tab.
        ELSE.
*    No data found
          CALL METHOD zabsf_pp_cl_log=>add_message
            EXPORTING
              msgty      = 'I'
              msgno      = '018'
            CHANGING
              return_tab = return_tab.
        ENDIF.
      ENDIF.

    ELSE.


*  Remove from component shopfloor
      LOOP AT components_tab INTO ls_components.

*      Batch consumption
        SELECT SINGLE *
          FROM zabsf_pp077
          INTO @DATA(ls_pp_sf077)
         WHERE werks EQ @inputobj-werks
           AND aufnr EQ @l_aufnr
           AND vornr EQ @l_vornr
           AND batch EQ @ls_components-batch.
        IF ( sy-subrc = 0 ).
          DELETE ZABSF_PP077 FROM ls_pp_sf077.
          IF ( sy-subrc = 0 ).
            COMMIT WORK AND WAIT.
          ENDIF.
        ENDIF.
      ENDLOOP.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
