FUNCTION zabsf_pp_orders_time.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"     VALUE(IV_PSPNR_VAR) TYPE  STRING
*"     VALUE(IV_PF_VAR) TYPE  STRING OPTIONAL
*"     VALUE(IV_ARBPL_VAR) TYPE  ARBPL
*"  EXPORTING
*"     VALUE(ET_ORDERS_TAB) TYPE  ZABSF_PP_ORDER_TIME_TT
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
  "constantes locais
  CONSTANTS: c_parid      TYPE zabsf_pp_e_parid VALUE 'DATA_GET',
             c_parid_at01 TYPE zabsf_pp_e_parid VALUE 'DATA_GET_AT01'.
  "variáveis locais
  DATA: l_date_past     TYPE begda,
        l_date_future   TYPE begda,
        l_days          TYPE t5a4a-dlydy,
        l_months        TYPE t5a4a-dlymo,
        l_years         TYPE t5a4a-dlyyr,
        lv_pepelemt_var TYPE ps_psp_ele,
        lv_pepinput_var TYPE ps_posnr.
  "ranges
  DATA: lr_auart_rng TYPE RANGE OF auart.
  "conversão de formatos
  CALL FUNCTION 'CONVERSION_EXIT_ABPSP_INPUT'
    EXPORTING
      input     = iv_pspnr_var
    IMPORTING
      output    = lv_pepelemt_var
    EXCEPTIONS
      not_found = 1
      OTHERS    = 2.
  IF sy-subrc <> 0.
    "PEP não é válido
    zabsf_pp_cl_log=>add_message( EXPORTING
                                    msgty      = 'E'
                                    msgno      = 164
                                  CHANGING
                                    return_tab = return_tab ).
    "sair do processamento
    RETURN.
  ENDIF.

  "obter valores da configuração
  TRY.
      zcl_bc_fixed_values=>get_single_value( EXPORTING
                                               im_paramter_var = zcl_bc_fixed_values=>gc_charplan_cst
                                               im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
                                               im_werksval_var = inputobj-werks
                                             IMPORTING
                                               ex_prmvalue_var = DATA(lv_charplan_var) ).
      zcl_bc_fixed_values=>get_single_value( EXPORTING
                                               im_paramter_var = zcl_bc_fixed_values=>gc_co10nord_cst
                                               im_modulesp_var = zcl_bc_fixed_values=>gc_productn_cst
                                               im_werksval_var = inputobj-werks
                                             IMPORTING
                                               ex_prmvalue_var = DATA(lv_co10_ot_var) ).

    CATCH zcx_pp_exceptions INTO DATA(lo_bcexceptions_obj).
      " falta configuração
      zabsf_pp_cl_log=>add_message( EXPORTING
                                      msgty      = lo_bcexceptions_obj->msgty
                                      msgno      = lo_bcexceptions_obj->msgno
                                      msgid      = lo_bcexceptions_obj->msgid
                                      msgv1      = lo_bcexceptions_obj->msgv1
                                      msgv2      = lo_bcexceptions_obj->msgv2
                                      msgv3      = lo_bcexceptions_obj->msgv3
                                      msgv4      = lo_bcexceptions_obj->msgv4
                                    CHANGING
                                      return_tab = return_tab ).
      "sair do processamento
      RETURN.
  ENDTRY.


  "obter id o centro de trabalho
  SELECT SINGLE objid
    FROM crhd
    INTO (@DATA(l_objid))
      WHERE arbpl EQ @iv_arbpl_var
      AND werks EQ @inputobj-werks.

  "obter tipo de área
  SELECT SINGLE tarea_id
    FROM zabsf_pp008
    INTO (@DATA(l_tarea_id))
   WHERE areaid EQ @inputobj-areaid
     AND werks  EQ @inputobj-werks
     AND endda  GE @sy-datum
     AND begda  LE @sy-datum.

  "range temporal
  IF l_tarea_id EQ 'AT01'.
    SELECT SINGLE parva
      FROM zabsf_pp032
      INTO (@DATA(l_date_get))
     WHERE parid EQ @c_parid_at01.
  ELSE.
    SELECT SINGLE parva
      FROM zabsf_pp032
      INTO (@l_date_get)
     WHERE parid EQ @c_parid.
  ENDIF.

  "obter tipos de ordem
  SELECT *
    FROM zabsf_pp019
    INTO TABLE @DATA(lt_zabsf_pp019)
   WHERE areaid EQ @inputobj-areaid.

  IF sy-subrc EQ 0.
    "criar range de tipos de ordem
    LOOP AT lt_zabsf_pp019 INTO DATA(ls_zabsf_pp019).
      APPEND VALUE #( sign   = 'I'
                      option = 'EQ'
                      low    = ls_zabsf_pp019-auart
                      high   = space ) TO lr_auart_rng.
    ENDLOOP.
  ENDIF.

  l_months = l_date_get.

  "data ano atrás
  CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
    EXPORTING
      date      = sy-datum
      days      = l_days
      months    = l_months
      signum    = '-'
      years     = l_years
    IMPORTING
      calc_date = l_date_past.

  "data futuro
  CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
    EXPORTING
      date      = sy-datum
      days      = l_days
      months    = l_months
      signum    = '+'
      years     = l_years
    IMPORTING
      calc_date = l_date_future.

  "obter as ordens do centro de trabalho
  SELECT aufk~aufnr, aufk~objnr, aufk~auart, afko~gstrp,  afko~gltrp, afko~gstrs, afko~gsuzs,    afko~gltrs, afko~cuobj AS order_cuobj,
         afko~ftrmi, afko~gamng, afko~gmein, afko~plnbez, afko~plnty, afko~plnnr, afko~cy_seqnr, afko~stlbez,
         afko~aufpl, afko~trmdt, afvc~aplzl, afvc~vornr,  afvc~ltxa1, afvc~steus, afvc~rueck,
         afvc~rmzhl, jest1~stat, afvc~zerma, afpo~posnr,  afpo~projn, afpo~cuobj
    INTO TABLE @DATA(lt_prdord_tab)
    FROM afvc AS afvc
   INNER JOIN t430 AS t430
      ON t430~steus EQ afvc~steus
   INNER JOIN afko AS afko
      ON afko~aufpl EQ afvc~aufpl
   INNER JOIN aufk AS aufk
      ON afko~aufnr EQ aufk~aufnr
   INNER JOIN zabsf_pp021 AS sf021
      ON sf021~aufnr EQ aufk~aufnr
     AND sf021~vornr EQ afvc~vornr
    INNER JOIN afpo AS afpo
    ON afpo~aufnr EQ aufk~aufnr
   INNER JOIN jest AS jest
      ON jest~objnr EQ aufk~objnr
     AND jest~stat  EQ 'I0002'
     AND jest~inact EQ @space
    LEFT OUTER JOIN jest AS jest1
      ON jest1~objnr EQ afvc~objnr
     AND jest1~stat  EQ 'I0009' " CONF
     AND jest1~inact EQ @space
   WHERE afvc~arbid EQ @l_objid
     AND ( afko~gstrp GE @l_date_past AND
           afko~gstrp LE @l_date_future )
     AND sf021~arbpl EQ @iv_arbpl_var
     AND sf021~status_oper IN ('AGU', 'PREP', 'PROC', 'STOP')
     AND aufk~auart IN @lr_auart_rng
     AND afpo~projn EQ @lv_pepelemt_var
     AND afpo~xloek EQ @abap_false.

  "eliminar concluidas
  DELETE lt_prdord_tab WHERE stat = 'I0009'.
  "ordena tabela
  SORT lt_prdord_tab BY aufnr posnr ASCENDING.
  "eliminar duplicados
  DELETE ADJACENT DUPLICATES FROM lt_prdord_tab COMPARING aufnr.

  "pecorrer todas as ordens e pesquisar por PF
  LOOP AT lt_prdord_tab ASSIGNING FIELD-SYMBOL(<fs_prdord_str>).
    "obter configuração
    zcl_mm_classification=>get_classification_config( EXPORTING
                                                        im_instance_cuobj_var = <fs_prdord_str>-cuobj
                                                      IMPORTING
                                                        ex_classfication_tab  = DATA(lt_classfic_tab)
                                                      EXCEPTIONS
                                                        instance_not_found    = 1
                                                        OTHERS                = 2 ).
    IF sy-subrc <> 0.
      "continuar loop
      CONTINUE.
    ENDIF.
    "plano de fabrico
    DATA(lv_planfabr_var) = COND #( WHEN line_exists( lt_classfic_tab[ atnam = lv_charplan_var ] )
                                    THEN lt_classfic_tab[ atnam = lv_charplan_var ]-atwrt ).

    "verificar se PF é o mesmo
    IF iv_pf_var IS NOT INITIAL.
      IF lv_planfabr_var EQ iv_pf_var.
        "adicionar ordem tabela de saida
        APPEND VALUE #( aufnr = <fs_prdord_str>-aufnr
                        pf    = lv_planfabr_var ) TO et_orders_tab.
      ENDIF.
    ELSE.
      "adicionar ordem tabela de saida
      APPEND VALUE #( aufnr =  <fs_prdord_str>-aufnr
                      pf    = lv_planfabr_var ) TO et_orders_tab.
    ENDIF.
  ENDLOOP.

  "ordenar tabela
  SORT et_orders_tab BY aufnr.
  "eliminar duplicados
  DELETE ADJACENT DUPLICATES FROM et_orders_tab COMPARING aufnr.
  IF et_orders_tab IS INITIAL.
    "sair do processamento
    RETURN.
  ENDIF.
  "obter projecto das ordens
  SELECT *
    FROM afpo
    INTO TABLE @DATA(lt_afpotabl_tab)
     FOR ALL ENTRIES IN @et_orders_tab
      WHERE aufnr EQ @et_orders_tab-aufnr
        AND projn NE @abap_false.
  IF sy-subrc EQ 0.
    "get project PEP
    SELECT *
      FROM prps
      INTO TABLE @DATA(lt_projects_tab)
      FOR ALL ENTRIES IN @lt_afpotabl_tab
        WHERE pspnr EQ @lt_afpotabl_tab-projn.
  ENDIF.

  "obter confirmação de tempos
  IF et_orders_tab IS NOT INITIAL.
    SELECT *
      FROM afru
      INTO TABLE @DATA(lt_confirms_tab)
      FOR ALL ENTRIES IN @et_orders_tab
        WHERE aufnr EQ @et_orders_tab-aufnr
          AND stokz EQ @space
          AND stzhl EQ @space.
    IF sy-subrc EQ 0.
      LOOP AT et_orders_tab ASSIGNING FIELD-SYMBOL(<fs_orders_str>).
        "PEP
        <fs_orders_str>-pep = iv_pspnr_var.
        "conversão maíusculas
        TRANSLATE <fs_orders_str>-pep TO UPPER CASE.
        "conversão de formatos
        CALL FUNCTION 'CONVERSION_EXIT_ABPSP_INPUT'
          EXPORTING
            input  = <fs_orders_str>-pep
          IMPORTING
            output = lv_pepinput_var.
        "obter projecto
        <fs_orders_str>-projecto = COND #( WHEN line_exists( lt_projects_tab[ pspnr = lv_pepinput_var ] )
                                           THEN lt_projects_tab[ pspnr = lv_pepinput_var ]-psphi ).
        "conversão de formatos
        CALL FUNCTION 'CONVERSION_EXIT_KONPD_OUTPUT'
          EXPORTING
            input  = <fs_orders_str>-projecto
          IMPORTING
            output = <fs_orders_str>-projecto.

        "confirmações da ordem
        DATA(lt_orderconf_tab) = VALUE ccrctt_afru( FOR ls_orderconf_str IN lt_confirms_tab
                                                     WHERE ( aufnr EQ <fs_orders_str>-aufnr )
                                                             ( ls_orderconf_str ) ).
        LOOP AT lt_orderconf_tab ASSIGNING FIELD-SYMBOL(<fs_orderconf_str>).
          "tempo de máquina
          IF <fs_orderconf_str>-ile01 NE 'H'.
            CALL FUNCTION 'UNIT_CONVERSION_SIMPLE'
              EXPORTING
                input                = <fs_orderconf_str>-ism01
                unit_in              = <fs_orderconf_str>-ile01
                unit_out             = 'H'
              IMPORTING
                output               = <fs_orderconf_str>-ism01
              EXCEPTIONS
                conversion_not_found = 1
                division_by_zero     = 2
                input_invalid        = 3
                output_invalid       = 4
                overflow             = 5
                type_invalid         = 6
                units_missing        = 7
                unit_in_not_found    = 8
                unit_out_not_found   = 9
                OTHERS               = 10.
            IF sy-subrc <> 0.
            ENDIF.
          ENDIF.
          "tempo de máquina
          <fs_orders_str>-machine_time = <fs_orders_str>-machine_time + <fs_orderconf_str>-ism01.
          IF <fs_orderconf_str>-ile02 NE 'H'.
            CALL FUNCTION 'UNIT_CONVERSION_SIMPLE'
              EXPORTING
                input                = <fs_orderconf_str>-ism02
                unit_in              = <fs_orderconf_str>-ile02
                unit_out             = 'H'
              IMPORTING
                output               = <fs_orderconf_str>-ism02
              EXCEPTIONS
                conversion_not_found = 1
                division_by_zero     = 2
                input_invalid        = 3
                output_invalid       = 4
                overflow             = 5
                type_invalid         = 6
                units_missing        = 7
                unit_in_not_found    = 8
                unit_out_not_found   = 9
                OTHERS               = 10.
            IF sy-subrc <> 0.
            ENDIF.
          ENDIF.
          "mão de obra
          <fs_orders_str>-labor_time = <fs_orders_str>-labor_time + <fs_orderconf_str>-ism02.

          "Qtd confirmada
          SELECT SUM( menge )
            INTO @DATA(lv_menge_101)
            FROM mseg
            WHERE aufnr = @<fs_orders_str>-aufnr
              AND bwart = '101'.                        "#EC CI_NOFIRST
          IF sy-subrc <> 0.
            CLEAR lv_menge_101.
          ENDIF.
          SELECT SUM( menge )
            INTO @DATA(lv_menge_102)
            FROM mseg
            WHERE aufnr = @<fs_orders_str>-aufnr
              AND bwart = '102'.                        "#EC CI_NOFIRST
          IF sy-subrc <> 0.
            CLEAR lv_menge_102.
          ENDIF.
          <fs_orders_str>-qty_confirmed = lv_menge_101 - lv_menge_102.

          "Qtd prevista
          SELECT SINGLE auart
            INTO @DATA(lv_auart)
            FROM aufk
            WHERE aufnr = @<fs_orders_str>-aufnr.
          IF sy-subrc = 0.
            IF lv_auart = lv_co10_ot_var.
              SELECT SINGLE gamng
                INTO @DATA(lv_gamng)
                FROM afko
                WHERE aufnr = @<fs_orders_str>-aufnr.
              IF sy-subrc = 0.
                <fs_orders_str>-qty_expected = lv_gamng.
              ENDIF.
            ELSE.
              SELECT SUM( psmng )
                INTO @DATA(lv_psmng)
                FROM afpo
                WHERE aufnr = @<fs_orders_str>-aufnr
                  AND fxpru = 'X'.
              IF sy-subrc = 0.
                <fs_orders_str>-qty_expected = lv_psmng.
              ENDIF.
            ENDIF.
          ENDIF.

        ENDLOOP.
        "limpar tabela
        REFRESH lt_orderconf_tab.
      ENDLOOP.
    ENDIF.
  ENDIF.
ENDFUNCTION.
