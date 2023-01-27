class ZCL_MM_CLASSIFICATION definition
  public
  final
  create public .

public section.

  constants CST_CLASSTYPE_LOTE type BAPI1003_KEY-CLASSTYPE value '023' ##NO_TEXT.
  constants CST_CLASSTYPE_CONF type BAPI1003_KEY-CLASSTYPE value '300' ##NO_TEXT.
  constants CST_OBJECT_TABLE type BAPI1003_KEY-OBJECTTABLE value 'RESB' ##NO_TEXT.
  constants CST_CHAR_NAME_BF type ATNAM value 'ZBY_NAME' ##NO_TEXT.
  constants CST_CHAR_NAME_BY type ATNAM value 'ZBF_NAME' ##NO_TEXT.
  constants CST_CHAR_NOME_BY type ATNAM value 'ZBY_NOME' ##NO_TEXT.
  constants CST_CHAR_NOME_BF type ATNAM value 'ZBF_NOME' ##NO_TEXT.

  class-methods SWITCH_MATERIAL_DESCRIPTION
    importing
      !IM_AUFNR_VAR type AUFK-AUFNR
      !IM_MISSING_MATS_TAB type ZBAPI_ORDER_RETURN_TT
    exporting
      !EX_MSSING_MATS_DESCRIPT_TAB type ZBAPI_ORDER_RETURN_TT .
  class-methods GET_CLASSIFICATION_BY_BATCH
    importing
      !IM_MATERIAL_VAR type MATNR
      !IM_LOTE_VAR type CHARG_D
      !IM_SHOWNULL_VAR type BOOLE_D optional
    exporting
      !EX_CLASS_TAB type ZMM_SCLASS_TAB
      !EX_CLASSIFICATION_TAB type ZMM_CLOBJDAT_TAB .
  class-methods GET_CLASSIFICATION_CONFIG
    importing
      !IM_INSTANCE_CUOBJ_VAR type INOB-CUOBJ
    exporting
      !EX_CLASSFICATION_TAB type ZCONF_OUT_TT
    exceptions
      INSTANCE_NOT_FOUND .
  class-methods GET_MATERIAL_CLASS_CONFIGURAT
    importing
      !IM_MATNR_VAR type BAPI1003_KEY-OBJECT
    exporting
      !EX_CLASSLIST_VAR type KLASSE_D
    returning
      value(RETURN) type ZBAPIRET2 .
  class-methods GET_MATERIAL_CLASS_LOT
    importing
      !IM_MATNR_VAR type BAPI1003_KEY-OBJECT
    exporting
      !EX_CLASSLIST_VAR type KLASSE_D
    returning
      value(RETURN) type ZBAPIRET2 .
  class-methods GET_CHARACTERISTICS_LIST
    importing
      !IM_CLASS_VAR type KLASSE_D
      !IM_CLASSTYPE_VAR type KLASSENART
    exporting
      !EX_CHARACT_STR type ZKSML_TAB .
  class-methods GET_MATERIAL_DESC_BY_BATCH
    importing
      !IM_MATERIAL_VAR type MATNR
      !IM_BATCH_VAR type CHARG_D
    exporting
      !EX_DESCRIPTION_VAR type ATWRT
      !EX_PF_VAR type ATWRT .
  class-methods GET_MATERIAL_DESC_BY_OBJECT
    importing
      !IM_CUOBJ_VAR type INOB-CUOBJ
    exporting
      !EX_PF_VAR type ATWRT
      !EX_DESCRIPTION_VAR type ATWRT .
  class-methods GET_CLASSIFICATION_BY_ITEMID
    importing
      !IM_ITEM_ID_VAR type STPO-ITMID
    exporting
      !EX_CLASSF_TAB type ZTT_AUSP_TAB .
  class-methods GET_DESC_AS_CO02
    importing
      !IM_RESB_STR type RESB
    exporting
      !EX_DESCRIPTION_VAR type CHAR50
      !EX_PF_VAR type ATWRT .
  class-methods COPY_1_OF_GET_MATERIAL_DESC_BY
    importing
      !IM_CUOBJ_VAR type INOB-CUOBJ
    exporting
      !EX_PF_VAR type ATWRT
      !EX_DESCRIPTION_VAR type ATWRT .
  class-methods COPY_1_OF_GET_DESC_AS_CO02
    importing
      !IM_RESB_STR type RESB
    exporting
      !EX_DESCRIPTION_VAR type CHAR50
      !EX_PF_VAR type ATWRT .
protected section.
private section.

  types:
    ty_atinn_range TYPE RANGE OF atinn .

  class-data CT_CHARNAME_RNG type TY_ATINN_RANGE .
  class-data CT_CHARPF_RNG type TY_ATINN_RANGE .
ENDCLASS.



CLASS ZCL_MM_CLASSIFICATION IMPLEMENTATION.


  method COPY_1_OF_GET_DESC_AS_CO02.

    "constantes locais
    constants: lc_obtable_resb_cst type tabelle value 'RESB',
               lc_obtable_stpo_cst type tabelle value 'STPO'.
    "variáveis locais
    data: lv_objnr_resbd_var     type resbd-objnr,
          lv_objnr_resbd_aux_var type string,
          lv_cuobj_var           type inob-objek,
          lv_objek_var           type ausp-objek,
          lv_char_value_var      type atwrt.
*          lt_classification_tab  TYPE zconf_out_tt.
    "objectos locais
    data: lo_classf_obj  type ref to zcl_mm_classification,
          lr_atnam_rng   type range of atnam,
          lr_pf_char_rng type range of atnam.

    "limpar variávies de exportação
    clear: ex_description_var, ex_pf_var.

    "copiar variável
    lv_objnr_resbd_aux_var = im_resb_str-objnr.

    if lv_objnr_resbd_aux_var is not initial and
        ( im_resb_str-werks = '2100' or im_resb_str-werks = '2110') .

*****Leitura de valores de nome das caracteristicas para o nome do material
      try.
          "obter valores da configuração
          zcl_bc_fixed_values=>get_ranges_value( exporting
                                                   im_paramter_var = zcl_bc_fixed_values=>gc_charname_cst
                                                   im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
                                                 importing
                                                   ex_valrange_tab = lr_atnam_rng ).

          "obter caracteristica para o PF
          zcl_bc_fixed_values=>get_ranges_value( exporting
                                           im_paramter_var = zcl_bc_fixed_values=>gc_charplan_cst
                                           im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
                                         importing
                                           ex_valrange_tab = lr_pf_char_rng ).
        catch zcx_bc_exceptions into data(lo_excpetion_obj) ##NEEDED
          .
          "sair do processamento
          return.
      endtry.

      "remover "OK" do valor (primeiros 2 digitos)
      lv_objnr_resbd_aux_var = lv_objnr_resbd_aux_var+2.
      "remover 4 ultimos digitos do valor => correspondem ao valor do item em processamento
      lv_objnr_resbd_var = lv_objnr_resbd_aux_var.

****Converter nome das caracteristicas para número
      loop at lr_atnam_rng assigning field-symbol(<fs_atnam_rng>).

        "conversão de formatos de nome para numerico
        call function 'CONVERSION_EXIT_ATINN_INPUT'
          exporting
            input  = <fs_atnam_rng>-low
          importing
            output = <fs_atnam_rng>-low.

      endloop.

      loop at lr_pf_char_rng assigning <fs_atnam_rng>.

        "conversão de formatos de nome para numerico
        call function 'CONVERSION_EXIT_ATINN_INPUT'
          exporting
            input  = <fs_atnam_rng>-low
          importing
            output = <fs_atnam_rng>-low.

      endloop.

      if sy-subrc ne 0.
        "sair do processamento
        return.
      endif.

      "obter valor do objecto
      select single cuobj
        from inob
        into @data(lv_cuobj_inob_var)
          where objek eq @lv_objnr_resbd_var
            and obtab eq @lc_obtable_resb_cst ##WARN_OK . "RESB table

******    Valores das caracteristicas podem estar na tabela RESB
      if sy-subrc = 0.
        "obter valor da caracteristica
        select single atwrt
          from ausp
            where objek = @lv_cuobj_inob_var
*          AND ( atinn = @lv_carbf_numb_var OR atinn = @lv_carby_numb_var )
              and ( atinn in @lr_atnam_rng )
          into @data(lv_car_ausp_var). ##WARN_OK

        if sy-subrc = 0.
          "copiar valor da caracteristica para descrição do material
          ex_description_var = lv_car_ausp_var.
        endif.
        "08.09.2020 - obter PF
        select single atwrt
         from ausp
           where objek = @lv_cuobj_inob_var
*          AND ( atinn = @lv_carbf_numb_var OR atinn = @lv_carby_numb_var )
             and ( atinn in @lr_pf_char_rng )
         into @lv_car_ausp_var. ##WARN_OK
        if sy-subrc = 0.
          "copiar valor da caracteristica para descrição do material
          ex_pf_var = lv_car_ausp_var.
        endif.


*****   Valores das caracteristicas podem ainda estar na tabela STPO
      else.
        concatenate im_resb_str-stlty im_resb_str-stlnr im_resb_str-stlkn  into data(lv_cuobj_str_var).

        lv_cuobj_var = lv_cuobj_str_var.
        "obter valor do objecto
        select single cuobj
          from inob
          into @data(lv_cuobj_inob_var2)
            where objek eq @lv_cuobj_var
              and obtab eq @lc_obtable_stpo_cst
          ##WARN_OK
          . "RESB table

        if sy-subrc = 0.
          "objecto
          lv_objek_var =  lv_cuobj_inob_var2.
****      obter valor da caracteristica nome
          select single atwrt
            from ausp
              where objek = @lv_objek_var
                and ( atinn in @lr_atnam_rng )
            into @data(lv_car_ausp_var2)
            ##WARN_OK
            .
          if sy-subrc = 0.
            "copiar valor da caracteristica para descrição do material
            ex_description_var =  lv_car_ausp_var2.
          endif.

          "obter valor da caracteristica PF
          select single atwrt
            from ausp
              where objek = @lv_objek_var
                and ( atinn in @lr_pf_char_rng )
            into @lv_car_ausp_var2.
          ##WARN_OK
          if sy-subrc = 0.
            "copiar valor da caracteristica PF
            ex_pf_var =  lv_car_ausp_var2. "BMR 08.09.2020
          endif.


*****Se não encontrou o valor das caracteristicas nas 2 tentativas anteriores,
*****Irá tentar pesquisar nas caracteristicas de configurador
        else.
          "instanciar objecto
          create object lo_classf_obj.
          "obter classificação do configurador
          try.

              zcl_mm_classification=>get_material_desc_by_object( exporting
                                                                    im_cuobj_var       = im_resb_str-cuobj
                                                                  importing
                                                                    ex_description_var = lv_char_value_var
                                                                    ex_pf_var          = ex_pf_var ). "BMR 08.09.2020

              if lv_char_value_var is not initial.
                ex_description_var = lv_char_value_var.
              endif.

          endtry.

        endif.
      endif.
    endif.

  endmethod.


  method COPY_1_OF_GET_MATERIAL_DESC_BY.
*****Leitura de classificação e class através de objecto de reserva
***** Objecto de REserva (Tabela RESB ) => CUOBJ
*****Exporta o valor encontrado na caracteristica do nome
**IM_CUOBJ_VAR CUOBJ obtido a partir de RESB
*EX_DESCRIPTION_VAR
**EX_CLASS_TAB           => class de classificação atribuida a material
**EX_CLASSIFICATION_TAB  => Valores de caracteristicas atribuidos a material

    "varíáveis locais
    data: lt_configuration_tab type standard table of conf_out,
          lv_cuobj_var         type inob-cuobj,
          lr_atnam_rng         type range of atnam,
          lr_pf_char_rng       type range of atnam.

    "limpar variáveis de exportação
    clear: ex_description_var, ex_pf_var.
    try.
        "obter caracteriticas com o nome do material
        zcl_bc_fixed_values=>get_ranges_value( exporting
                                                 im_paramter_var = zcl_bc_fixed_values=>gc_charname_cst
                                                 im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
                                               importing
                                                 ex_valrange_tab = lr_atnam_rng ).
        "obter caracteristica para o PF
        zcl_bc_fixed_values=>get_ranges_value( exporting
                                         im_paramter_var = zcl_bc_fixed_values=>gc_charplan_cst
                                         im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
                                       importing
                                         ex_valrange_tab = lr_pf_char_rng ).
      catch zcx_bc_exceptions into data(lo_excpetion_obj).  ##NEEDED
    endtry.
    "conversão de formatos
    lv_cuobj_var = |{ im_cuobj_var alpha = in }|.
    "ler configuração 300
    call function 'VC_I_GET_CONFIGURATION'
      exporting
        instance            = lv_cuobj_var
      tables
        configuration       = lt_configuration_tab
      exceptions
        instance_not_found  = 1
        internal_error      = 2
        no_class_allocation = 3
        instance_not_valid  = 4
        others              = 5.
    if sy-subrc <> 0.
      "sair do processamento
      return.
    endif.


    loop at lt_configuration_tab into data(ls_configuration_str)
      where atnam in lr_atnam_rng.
****     Se a caracteristica existir mas estiver vazia, tem o valor de " ? "
      if sy-subrc = 0 and ls_configuration_str-atwrt ne '?'.
        "mapear valor de saida
        ex_description_var = ls_configuration_str-atwrt.
      endif.
    endloop.

    "valor do PF - 08.09.2020
    loop at lt_configuration_tab into ls_configuration_str
      where atnam in lr_pf_char_rng.
****     Se a caracteristica existir mas estiver vazia, tem o valor de " ? "
      if sy-subrc = 0 and ls_configuration_str-atwrt ne '?'.
        "mapear valor de saida
        ex_pf_var = ls_configuration_str-atwrt.
      endif.
    endloop.
  endmethod.


  METHOD get_characteristics_list.
*    IM_CLASS_VAR      " Class de classificação dos materiais
*    EX_CHARACT_STR´   "Lista de caracteristicas
***CLASSTYPE

    clear ex_charact_str.

    SELECT SINGLE clint FROM klah WHERE class = @im_class_var and
                                        klart =  @IM_CLASSTYPE_VAR
      INTO @DATA(lv_clint_var) ##WARN_OK
      .
    IF sy-subrc = 0.
      SELECT * FROM ksml INTO TABLE @DATA(lt_caract_tab) WHERE clint = @lv_clint_var.
      IF sy-subrc = 0.
        ex_charact_str = lt_caract_tab.
      ENDIF.


    ENDIF.

  ENDMETHOD.


  method get_classification_by_batch.

****Leitura de classificação e class atribuido a MATERIAL+LOTE

*IM_MATERIAL_VAR        => Material
*IM_LOTE_VAR            => Lote
*EX_CLASS_TAB           => class de classificação atribuida a material
*EX_CLASSIFICATION_TAB  => Valores de caracteristicas atribuidos a material


    data: lo_object_var type ausp-objek,
          lv_lot_aux    type char10,
          lv_matnr_aux  type char18.

    refresh: ex_class_tab, ex_classification_tab.

    lv_lot_aux      = im_lote_var.
    lv_matnr_aux    = im_material_var.

    write lv_matnr_aux to lo_object_var.
    write  lv_lot_aux to lo_object_var+18.

    call function 'CLAF_CLASSIFICATION_OF_OBJECTS'
      exporting
        classtype          = '023'
        object             = lo_object_var
        objecttable        = 'MCH1'
        initial_charact    = im_shownull_var
      tables
        t_class            = ex_class_tab
        t_objectdata       = ex_classification_tab
      exceptions
        no_classification  = 1
        no_classtypes      = 2
        invalid_class_type = 3
        others             = 4
        ##FM_SUBRC_OK.
*    IF sy-subrc <> 0.
** Implement suitable error handling here
*    ENDIF.
    "remover os '?'
    if im_shownull_var eq abap_true.
     loop at ex_classification_tab ASSIGNING FIELD-SYMBOL(<fs_classifc_str>)
       where ausp1 = '?'.
       "limpar '?'
       clear <fs_classifc_str>-ausp1.
     ENDLOOP.
    endif.
  endmethod.


  METHOD get_classification_by_itemid.

*IM_ITEM_ID_VAR
*EX_CLASSF_TAB

    REFRESH ex_classf_tab.

    DATA lv_inob_key_var TYPE string.

    SELECT SINGLE * FROM stpo WHERE itmid = @im_item_id_var INTO @DATA(ls_stpo_str) ##WARN_OK
      .
    IF sy-subrc = 0.
      CONCATENATE ls_stpo_str-stlty ls_stpo_str-stlnr  ls_stpo_str-clszu INTO lv_inob_key_var.

      SELECT SINGLE cuobj FROM inob WHERE objek = @lv_inob_key_var INTO @DATA(lv_ausp_key_var)
        ##WARN_OK
        .
      IF sy-subrc = 0.

        SELECT * FROM ausp INTO TABLE @DATA(lt_ausp_tab) WHERE objek = @lv_ausp_key_var.
        IF sy-subrc = 0.
          ex_classf_tab = lt_ausp_tab.

        ENDIF.

      ENDIF.


    ENDIF.



  ENDMETHOD.


  method get_classification_config.

    data lv_cuobj_var type inob-cuobj.

    refresh ex_classfication_tab.

    lv_cuobj_var = |{ im_instance_cuobj_var alpha = in }|.



    call function 'VC_I_GET_CONFIGURATION'
      exporting
        instance           = lv_cuobj_var
*       BUSINESS_OBJECT    =
*       LANGUAGE           = SY-LANGU
*       IV_INVALID_POSSIBLE       = ' '
*       IV_NEUTRAL         = ' '
      tables
        configuration      = ex_classfication_tab
*       ET_CONF_WITH_AUTHOR       =
      exceptions
        instance_not_found = 1
        others             = 2
        ##FM_SUBRC_OK.
*    IF sy-subrc <> 0.
**      instance_not_found.
** Implement suitable error handling here
*    ENDIF.



  endmethod.


  METHOD get_desc_as_co02.

    "constantes locais
    CONSTANTS: lc_obtable_resb_cst TYPE tabelle VALUE 'RESB',
               lc_obtable_stpo_cst TYPE tabelle VALUE 'STPO'.
    "variáveis locais
    DATA: lv_objnr_resbd_var     TYPE resbd-objnr,
          lv_objnr_resbd_aux_var TYPE string,
          lv_cuobj_var           TYPE inob-objek,
          lv_objek_var           TYPE ausp-objek,
          lv_char_value_var      TYPE atwrt.
*          lt_classification_tab  TYPE zconf_out_tt.
    "objectos locais
    DATA: lo_classf_obj  TYPE REF TO zcl_mm_classification,
          lr_atnam_rng   TYPE RANGE OF atnam,
          lr_pf_char_rng TYPE RANGE OF atnam.

    DATA: ls_charname_rng LIKE LINE OF ct_charname_rng,
          ls_charpf_rng   LIKE LINE OF ct_charpf_rng.

    "limpar variávies de exportação
    CLEAR: ex_description_var, ex_pf_var.

    "copiar variável
    lv_objnr_resbd_aux_var = im_resb_str-objnr.

    IF lv_objnr_resbd_aux_var IS NOT INITIAL AND
        ( im_resb_str-werks = '2100' OR im_resb_str-werks = '2110') .

*****Leitura de valores de nome das caracteristicas para o nome do material
      IF ct_charname_rng IS INITIAL.
        TRY.
            "obter valores da configuração
            zcl_bc_fixed_values=>get_ranges_value( EXPORTING
                                                     im_paramter_var = zcl_bc_fixed_values=>gc_charname_cst
                                                     im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
                                                   IMPORTING
                                                     ex_valrange_tab = lr_atnam_rng ).
            " Converter nome das caracteristicas para número interno
            CLEAR ls_charname_rng.
            ls_charname_rng-sign   = 'I'.
            ls_charname_rng-option = 'EQ'.
            LOOP AT lr_atnam_rng ASSIGNING FIELD-SYMBOL(<fs_atnam_rng>).
              CALL FUNCTION 'CONVERSION_EXIT_ATINN_INPUT'
                EXPORTING
                  input  = <fs_atnam_rng>-low
                IMPORTING
                  output = ls_charname_rng-low.
              APPEND ls_charname_rng TO ct_charname_rng.
            ENDLOOP.
          CATCH zcx_bc_exceptions INTO DATA(lo_excpetion_obj) ##NEEDED.
            "sair do processamento
            RETURN.
        ENDTRY.
      ENDIF.

      IF ct_charpf_rng IS INITIAL.
        TRY.
            "obter caracteristica para o PF
            zcl_bc_fixed_values=>get_ranges_value( EXPORTING
                                                     im_paramter_var = zcl_bc_fixed_values=>gc_charplan_cst
                                                     im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
                                                   IMPORTING
                                                     ex_valrange_tab = lr_pf_char_rng ).
            " Converter nome das caracteristicas para número interno
            CLEAR ls_charpf_rng.
            ls_charpf_rng-sign   = 'I'.
            ls_charpf_rng-option = 'EQ'.
            LOOP AT lr_pf_char_rng ASSIGNING <fs_atnam_rng>.
              CALL FUNCTION 'CONVERSION_EXIT_ATINN_INPUT'
                EXPORTING
                  input  = <fs_atnam_rng>-low
                IMPORTING
                  output = ls_charpf_rng-low.
            ENDLOOP.
            APPEND ls_charpf_rng TO ct_charpf_rng.
          CATCH zcx_bc_exceptions INTO lo_excpetion_obj ##NEEDED .
            "sair do processamento
            RETURN.
        ENDTRY.
      ENDIF.

      IF ct_charname_rng IS INITIAL AND ct_charpf_rng IS INITIAL.
        "sair do processamento
        RETURN.
      ENDIF.

      "remover "OK" do valor (primeiros 2 digitos)
      lv_objnr_resbd_aux_var = lv_objnr_resbd_aux_var+2.
      "remover 4 ultimos digitos do valor => correspondem ao valor do item em processamento
      lv_objnr_resbd_var = lv_objnr_resbd_aux_var.

      "obter valor do objecto
      SELECT SINGLE cuobj
        FROM inob
        INTO @DATA(lv_cuobj_inob_var)
          WHERE objek EQ @lv_objnr_resbd_var
            AND obtab EQ @lc_obtable_resb_cst ##WARN_OK . "RESB table

******    Valores das caracteristicas podem estar na tabela RESB
      IF sy-subrc = 0.
        "obter valor da caracteristica
        SELECT SINGLE atwrt
          FROM ausp
            WHERE objek = @lv_cuobj_inob_var
*          AND ( atinn = @lv_carbf_numb_var OR atinn = @lv_carby_numb_var )
              AND ( atinn IN @ct_charname_rng )
          INTO @DATA(lv_car_ausp_var). ##WARN_OK

        IF sy-subrc = 0.
          "copiar valor da caracteristica para descrição do material
          ex_description_var = lv_car_ausp_var.
        ENDIF.
        "08.09.2020 - obter PF
        SELECT SINGLE atwrt
         FROM ausp
           WHERE objek = @lv_cuobj_inob_var
*          AND ( atinn = @lv_carbf_numb_var OR atinn = @lv_carby_numb_var )
             AND ( atinn IN @ct_charpf_rng )
         INTO @lv_car_ausp_var. ##WARN_OK
        IF sy-subrc = 0.
          "copiar valor da caracteristica para descrição do material
          ex_pf_var = lv_car_ausp_var.
        ENDIF.


*****   Valores das caracteristicas podem ainda estar na tabela STPO
      ELSE.
        CONCATENATE im_resb_str-stlty im_resb_str-stlnr im_resb_str-stlkn  INTO DATA(lv_cuobj_str_var).

        lv_cuobj_var = lv_cuobj_str_var.
        "obter valor do objecto
        SELECT SINGLE cuobj
          FROM inob
          INTO @DATA(lv_cuobj_inob_var2)
            WHERE objek EQ @lv_cuobj_var
              AND obtab EQ @lc_obtable_stpo_cst
          ##WARN_OK
          . "RESB table

        IF sy-subrc = 0.
          "objecto
          lv_objek_var =  lv_cuobj_inob_var2.
****      obter valor da caracteristica nome
          SELECT SINGLE atwrt
            FROM ausp
              WHERE objek = @lv_objek_var
                AND ( atinn IN @ct_charname_rng )
            INTO @DATA(lv_car_ausp_var2)
            ##WARN_OK
            .
          IF sy-subrc = 0.
            "copiar valor da caracteristica para descrição do material
            ex_description_var =  lv_car_ausp_var2.
          ENDIF.

          "obter valor da caracteristica PF
          SELECT SINGLE atwrt
            FROM ausp
              WHERE objek = @lv_objek_var
                AND ( atinn IN @ct_charpf_rng )
            INTO @lv_car_ausp_var2.
          ##WARN_OK
          IF sy-subrc = 0.
            "copiar valor da caracteristica PF
            ex_pf_var =  lv_car_ausp_var2. "BMR 08.09.2020
          ENDIF.


*****Se não encontrou o valor das caracteristicas nas 2 tentativas anteriores,
*****Irá tentar pesquisar nas caracteristicas de configurador
        ELSE.
          "instanciar objecto
          CREATE OBJECT lo_classf_obj.
          "obter classificação do configurador
          TRY.

              zcl_mm_classification=>get_material_desc_by_object( EXPORTING
                                                                    im_cuobj_var       = im_resb_str-cuobj
                                                                  IMPORTING
                                                                    ex_description_var = lv_char_value_var
                                                                    ex_pf_var          = ex_pf_var ). "BMR 08.09.2020

              IF lv_char_value_var IS NOT INITIAL.
                ex_description_var = lv_char_value_var.
              ENDIF.

          ENDTRY.

        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  method get_material_class_configurat.
*************************************************************************************************
*********************   Permite a leitura da class de classificação por Material*****************
*                                        Configurador
*************************************************************************************************
*****    PARAMETERS     *****
*IM_MATNR_VAR             CPM
*  objecttable_imp        MARA
*IM_CLASSTYPE_VAR         300 "Classificação por lote
*EX_CLASSLIST_VAR         Class Classificação

    constants: lc_mara_cst      type bapi1003_key-objecttable value 'MARA',
               lc_classtype_cst type bapi1003_key-classtype value '300'.


    clear ex_classlist_var.
    data : lt_alloclist_tab type standard table of bapi1003_alloc_list.


    call function 'BAPI_OBJCL_GETCLASSES'
      exporting
        objectkey_imp   = im_matnr_var
        objecttable_imp = lc_mara_cst
        classtype_imp   = lc_classtype_cst
      tables
        alloclist       = lt_alloclist_tab
        return          = return.

    if lt_alloclist_tab is not initial.
      read table lt_alloclist_tab  index 1 into data(ls_alloclist_str).
      if sy-subrc = 0.
        ex_classlist_var =  ls_alloclist_str-classnum.
      endif.
    endif.


  endmethod.


  METHOD GET_MATERIAL_CLASS_LOT.
*************************************************************************************************
*********************   Permite a leitura da class de classificação por Material*****************
*************************************************************************************************
*****    PARAMETERS     *****
*IM_MATNR_VAR             CPM
*  objecttable_imp        MARA
*IM_CLASSTYPE_VAR         023 "Classificação por lote
*EX_CLASSLIST_VAR         Class Classificação

    CONSTANTS: lc_mara_cst      TYPE bapi1003_key-objecttable VALUE 'MARA',
               lc_classtype_cst TYPE bapi1003_key-classtype VALUE '023'.

    DATA : lt_alloclist_tab TYPE STANDARD TABLE OF bapi1003_alloc_list.


    CALL FUNCTION 'BAPI_OBJCL_GETCLASSES'
      EXPORTING
        objectkey_imp   = im_matnr_var
        objecttable_imp = lc_mara_cst
        classtype_imp   = lc_classtype_cst
      TABLES
        alloclist       = lt_alloclist_tab
        return          = return.

    IF lt_alloclist_tab IS NOT INITIAL.
      READ TABLE lt_alloclist_tab  INDEX 1 INTO DATA(ls_alloclist_str).
      IF sy-subrc = 0.
        ex_classlist_var =  ls_alloclist_str-classnum.
      ENDIF.
    ENDIF.
*    DATA(ls_alloclist_str) = lt_alloclist_tab[ 1 ] .





  ENDMETHOD.


  method get_material_desc_by_batch.
****Leitura de classificação e class atribuido a MATERIAL+LOTE
****Exporta o valor encontrado na caracteristica do nome


*IM_MATERIAL_VAR        => Material
*IM_LOTE_VAR            => Lote
*EX_CLASS_TAB           => class de classificação atribuida a material
*EX_CLASSIFICATION_TAB  => Valores de caracteristicas atribuidos a material

    data: lo_object_var         type ausp-objek,
*          lv_conc_obj_var       type char50,
          lv_lot_aux            type char10,
          lv_matnr_aux          type char18,
          lt_class_tab          type standard table of  sclass,
          lt_classification_tab type standard table of clobjdat.

    data: lr_pf_char_rng type range of atnam,
          lr_names_rng   type range of atnam.

    "limpar variáveis de exportação
    clear: ex_description_var, ex_pf_var.

    try.
        "obter caracteriticas com o nome do material
        zcl_bc_fixed_values=>get_ranges_value( exporting
                                                 im_paramter_var = zcl_bc_fixed_values=>gc_charname_cst
                                                 im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
                                               importing
                                                 ex_valrange_tab =  lr_names_rng  ).
        "obter caracteristica para o PF
        zcl_bc_fixed_values=>get_ranges_value( exporting
                                         im_paramter_var = zcl_bc_fixed_values=>gc_charplan_cst
                                         im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
                                       importing
                                         ex_valrange_tab = lr_pf_char_rng ).
      catch zcx_bc_exceptions into data(lo_excpetion_obj).  ##NEEDED
    endtry.

    lv_lot_aux      = im_batch_var.
    lv_matnr_aux    = im_material_var.

    write lv_matnr_aux to lo_object_var.
    write  lv_lot_aux to lo_object_var+18.

    call function 'CLAF_CLASSIFICATION_OF_OBJECTS'
      exporting
        classtype          = '023'
        object             = lo_object_var
        objecttable        = 'MCH1'
      tables
        t_class            = lt_class_tab
        t_objectdata       = lt_classification_tab
      exceptions
        no_classification  = 1
        no_classtypes      = 2
        invalid_class_type = 3
        others             = 4.
    if sy-subrc = 0.
      "BMR ajuste 08.09.2020
      loop at lt_classification_tab into data(ls_classification_str) where atnam  in lr_names_rng

        .
****     Se a caracteristica existir mas estiver vazia, tem o valor de " ? "
        if sy-subrc = 0 and ls_classification_str-ausp1 ne '?'.
          ex_description_var = ls_classification_str-ausp1.
        endif.
      endloop.

      "08.09.2020 - PF
      loop at lt_classification_tab into ls_classification_str where atnam in lr_pf_char_rng
        .
****     Se a caracteristica existir mas estiver vazia, tem o valor de " ? "
        if sy-subrc = 0 and ls_classification_str-ausp1 ne '?'.
          ex_pf_var = ls_classification_str-ausp1.
        endif.
      endloop.
    endif.

  endmethod.


  METHOD get_material_desc_by_object.
*****Leitura de classificação e class através de objecto de reserva
***** Objecto de REserva (Tabela RESB ) => CUOBJ
*****Exporta o valor encontrado na caracteristica do nome
**IM_CUOBJ_VAR CUOBJ obtido a partir de RESB

    "varíáveis locais
    DATA: lv_instance     TYPE ibin-instance,
          lr_atnam_rng    TYPE RANGE OF atnam,
          lr_pf_char_rng  TYPE RANGE OF atnam,
          ls_charname_rng LIKE LINE OF ct_charname_rng,
          ls_charpf_rng   LIKE LINE OF ct_charpf_rng.

    "limpar variáveis de exportação
    CLEAR: ex_description_var, ex_pf_var.

    " Validar valor de entrada
    IF im_cuobj_var IS INITIAL.
      RETURN.
    ENDIF.

    " Obter parâmetros de configuração
    IF ct_charname_rng IS INITIAL.
      TRY.
          "obter valores da configuração
          zcl_bc_fixed_values=>get_ranges_value( EXPORTING
                                                   im_paramter_var = zcl_bc_fixed_values=>gc_charname_cst
                                                   im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
                                                 IMPORTING
                                                   ex_valrange_tab = lr_atnam_rng ).
          " Converter nome das caracteristicas para número interno
          CLEAR ls_charname_rng.
          ls_charname_rng-sign   = 'I'.
          ls_charname_rng-option = 'EQ'.
          LOOP AT lr_atnam_rng ASSIGNING FIELD-SYMBOL(<fs_atnam_rng>).
            CALL FUNCTION 'CONVERSION_EXIT_ATINN_INPUT'
              EXPORTING
                input  = <fs_atnam_rng>-low
              IMPORTING
                output = ls_charname_rng-low.
            APPEND ls_charname_rng TO ct_charname_rng.
          ENDLOOP.
        CATCH zcx_bc_exceptions INTO DATA(lo_excpetion_obj) ##NEEDED.
          "sair do processamento
          RETURN.
      ENDTRY.
    ENDIF.

    IF ct_charpf_rng IS INITIAL.
      TRY.
          "obter caracteristica para o PF
          zcl_bc_fixed_values=>get_ranges_value( EXPORTING
                                                   im_paramter_var = zcl_bc_fixed_values=>gc_charplan_cst
                                                   im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
                                                 IMPORTING
                                                   ex_valrange_tab = lr_pf_char_rng ).
          " Converter nome das caracteristicas para número interno
          CLEAR ls_charpf_rng.
          ls_charpf_rng-sign   = 'I'.
          ls_charpf_rng-option = 'EQ'.
          LOOP AT lr_pf_char_rng ASSIGNING <fs_atnam_rng>.
            CALL FUNCTION 'CONVERSION_EXIT_ATINN_INPUT'
              EXPORTING
                input  = <fs_atnam_rng>-low
              IMPORTING
                output = ls_charpf_rng-low.
          ENDLOOP.
          APPEND ls_charpf_rng TO ct_charpf_rng.
        CATCH zcx_bc_exceptions INTO lo_excpetion_obj ##NEEDED .
          "sair do processamento
          RETURN.
      ENDTRY.
    ENDIF.

    IF ct_charname_rng IS INITIAL AND ct_charpf_rng IS INITIAL.
      "sair do processamento
      RETURN.
    ENDIF.

    " Leitura das características e seus valores
    lv_instance = |{ im_cuobj_var ALPHA = IN }|.
    SELECT ibsymbol~atinn, ibsymbol~atwrt
      INTO TABLE @DATA(lt_ibsymbol)
      FROM ibsymbol INNER JOIN ibinvalues
                       ON ibinvalues~symbol_id = ibsymbol~symbol_id
                    INNER JOIN ibin
                       ON ibin~in_recno = ibinvalues~in_recno AND
                          ibin~instance = @lv_instance
      WHERE ibsymbol~atinn IN @ct_charname_rng
         OR ibsymbol~atinn IN @ct_charpf_rng
      ORDER BY ibin~valto DESCENDING, ibsymbol~atinn ASCENDING.
    IF sy-subrc <> 0 OR lt_ibsymbol IS INITIAL.
      RETURN.
    ENDIF.
*    SELECT in_recno
*      INTO @DATA(lv_in_recno)
*      FROM ibin
*      UP TO 1 ROWS
*      WHERE instance = @lv_instance
*      ORDER BY valto DESCENDING.
*    ENDSELECT.
*    IF sy-subrc <> 0 OR lv_in_recno IS INITIAL.
*      RETURN.
*    ENDIF.
*    SELECT ibsymbol~atinn, ibsymbol~atwrt
*      INTO TABLE @DATA(lt_ibsymbol)
*      FROM ibinvalues INNER JOIN ibsymbol
*                      ON ibsymbol~symbol_id = ibinvalues~symbol_id
*      WHERE ibinvalues~in_recno = @lv_in_recno.
*    IF sy-subrc <> 0 OR lt_ibsymbol IS INITIAL.
*      RETURN.
*    ENDIF.
    LOOP AT lt_ibsymbol ASSIGNING FIELD-SYMBOL(<ibsymbol>)
                        WHERE atinn IN ct_charname_rng
                          AND atwrt <> '?'.
      ex_description_var = <ibsymbol>-atwrt.
      EXIT.
    ENDLOOP.
    LOOP AT lt_ibsymbol ASSIGNING <ibsymbol>
                        WHERE atinn IN ct_charpf_rng
                          AND atwrt <> '?'.
      ex_pf_var = <ibsymbol>-atwrt.
      EXIT.
    ENDLOOP.

  ENDMETHOD.


  method switch_material_description.

    data: lv_aufnr_var        type aufk-aufnr,
          lv_description_var  type char50,
          lt_missing_mats_tab type zbapi_order_return_tt.

    lt_missing_mats_tab = im_missing_mats_tab.
    lv_aufnr_var = im_aufnr_var.

    loop at lt_missing_mats_tab assigning field-symbol(<fs_missing_mats>) where id = 'CO' and number = '397'.
      "obter caracteres constituem nº item do material na mensagem
      data(lv_item) = <fs_missing_mats>-message+5(4).
      "obter caracteres que constituem o nome do material

      select single *
        from resb
        into @data(ls_resb)
       where aufnr = @lv_aufnr_var
         and posnr = @lv_item
        ##WARN_OK
        .

      if sy-subrc = 0.
        "obter valor da caracteristica para descrição do material
        call method zcl_mm_classification=>get_desc_as_co02
          exporting
            im_resb_str        = ls_resb
          importing
            ex_description_var = lv_description_var.
        "verificar se encontrou descrição no configurador
        if lv_description_var is not initial.
          "alterar na mensagem o valor do material pelo valor da descrição do material
          <fs_missing_mats>-message = <fs_missing_mats>-message(10) && | | && lv_description_var && <fs_missing_mats>-message+29.
        endif.
      endif.
      ex_mssing_mats_descript_tab = lt_missing_mats_tab.
    endloop.

  endmethod.
ENDCLASS.
