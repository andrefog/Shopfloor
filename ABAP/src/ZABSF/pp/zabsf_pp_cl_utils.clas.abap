class ZABSF_PP_CL_UTILS definition
  public
  final
  create public .

public section.

  types:
    ty_r_date TYPE RANGE OF sy-datum .

  class-methods ADJUST_RANGE_DATE
    changing
      !CR_DATE type TY_R_DATE .
  class-methods CONVERT_DATE_TO_TIMESTAMP
    importing
      value(IV_DATE) type DATUM
      value(IV_TIME) type UZEIT optional
    returning
      value(RV_TIMESTAMP) type TZNTSTMPS .
  class-methods CONVERT_TIMESTAMP_TO_DATE
    importing
      value(IV_TIMESTAMP) type TZNTSTMPS
    exporting
      value(EV_TIME) type UZEIT
    returning
      value(RV_DATE) type DATUM .
  class-methods CONVERT_TO_TIMESTAMP
    importing
      value(IV_INPUT) type STRING
    returning
      value(RV_TIMESTAMP) type TZNTSTMPS .
  class-methods COPY_DATA_TO_REF
    importing
      !IS_DATA type ANY
    returning
      value(RR_DATA) type ref to DATA .
  class-methods GET_METHOD_NAME
    importing
      !IV_CALLSTACK type I optional
    returning
      value(RV_METHOD_NAME) type STRING .
  class-methods GET_PRINTER
    importing
      !IV_AREAID type ZABSF_PP_E_AREAID optional
      !IV_WERKS type WERKS_D optional
      !IV_ARBPL type ARBPL optional
      !IV_SFORM type NA_FNAME optional
    returning
      value(RV_IMPR_OUT) type RSPOPNAME .
  class-methods GET_USER_HRCHY_WRKCNTR_AUTH
    importing
      !IV_OPRID type ZABSF_PP_E_OPRID
    exporting
      !ER_HIERARCHIES type ZABSF_RANGE_HIERARCHIES
      !ER_WORKCENTERS type ZABSF_RANGE_WORKCENTER .
  class-methods VALIDATESAPRESPONSE
    importing
      !IT_RESULT type BAPIRET2_T
    changing
      !CO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  class-methods ZABSF_PP_ORDERS_TIME
    importing
      !INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IV_PF_VAR type STRING optional
      !IV_ARBPL_VAR type ARBPL
    exporting
      !ET_ORDERS_TAB type ZABSF_PP_ORDER_TIME_TT
      !RETURN_TAB type BAPIRET2_T .
  class-methods ZABSF_PP_STOCKS
    importing
      !INPUTOBJ type ZABSF_PP_S_INPUTOBJECT
      !IV_MATNR_VAR type MATNR optional
      !IV_WERKS_VAR type WERKS_D optional
      !IV_PF_VAR type STRING optional
      !IV_MAT_DESC_VAR type STRING optional
      !IV_SEMIFIN_VAR type BOOLE_D optional
      !IV_FINISHED_VAR type BOOLE_D optional
    exporting
      !ET_DATA_OUT_TAB type ZPS_STOCKS_TT
      !RETURN_TAB type BAPIRET2_T .
  class-methods GET_DEFAULT_WORKCENTER
    returning
      value(RV_WORKCENTER) type STRING .
  PROTECTED SECTION.
private section.
ENDCLASS.



CLASS ZABSF_PP_CL_UTILS IMPLEMENTATION.


  METHOD adjust_range_date.
    DATA(lr_date) = cr_date[].
    CLEAR cr_date[].

    CONSTANTS:
      lc_begda TYPE datum VALUE '19000101',
      lc_endda TYPE datum VALUE '99991231'.

    LOOP AT lr_date ASSIGNING FIELD-SYMBOL(<ls_date>).
      CASE <ls_date>-sign.
        WHEN 'I'.
          CASE <ls_date>-option.
            WHEN 'EQ'.
              APPEND VALUE #( sign = 'I' option = 'BT' low = <ls_date>-low high = <ls_date>-low ) TO cr_date.
            WHEN 'NE'.
              APPEND VALUE #( sign = 'I' option = 'BT' low = lc_begda high = <ls_date>-low - 1 ) TO cr_date.
              APPEND VALUE #( sign = 'I' option = 'BT' low = <ls_date>-low + 1 high = lc_endda ) TO cr_date.
            WHEN 'LT'.
              APPEND VALUE #( sign = 'I' option = 'BT' low = lc_begda high = <ls_date>-low - 1 ) TO cr_date.
            WHEN 'LE'.
              APPEND VALUE #( sign = 'I' option = 'BT' low = lc_begda high = <ls_date>-low ) TO cr_date.
            WHEN 'GT'.
              APPEND VALUE #( sign = 'I' option = 'BT' low = <ls_date>-low + 1 high = lc_endda ) TO cr_date.
            WHEN 'GE'.
              APPEND VALUE #( sign = 'I' option = 'BT' low = <ls_date>-low high = lc_endda ) TO cr_date.
            WHEN OTHERS.
              APPEND <ls_date> TO cr_date.
          ENDCASE.
        WHEN 'E'.
          CASE <ls_date>-option.
            WHEN 'EQ'.
              APPEND VALUE #( sign = 'I' option = 'BT' low = lc_begda high = <ls_date>-low - 1 ) TO cr_date.
              APPEND VALUE #( sign = 'I' option = 'BT' low = <ls_date>-low + 1 high = lc_endda ) TO cr_date.
            WHEN 'NE'.
              APPEND VALUE #( sign = 'I' option = 'BT' low = <ls_date>-low high = <ls_date>-low ) TO cr_date.
            WHEN 'LT'.
              APPEND VALUE #( sign = 'I' option = 'BT' low = <ls_date>-low high = lc_endda ) TO cr_date.
            WHEN 'LE'.
              APPEND VALUE #( sign = 'I' option = 'BT' low = <ls_date>-low + 1 high = lc_endda ) TO cr_date.
            WHEN 'GT'.
              APPEND VALUE #( sign = 'I' option = 'BT' low = lc_begda high = <ls_date>-low ) TO cr_date.
            WHEN 'GE'.
              APPEND VALUE #( sign = 'I' option = 'BT' low = lc_begda high = <ls_date>-low - 1 ) TO cr_date.
            WHEN 'BT'.
              APPEND VALUE #( sign = 'I' option = 'BT' low = lc_begda high = <ls_date>-low - 1 ) TO cr_date.
              APPEND VALUE #( sign = 'I' option = 'BT' low = <ls_date>-low + 1  high = lc_endda ) TO cr_date.
            WHEN OTHERS.
              APPEND <ls_date> TO cr_date.
          ENDCASE.
      ENDCASE.
    ENDLOOP.
  ENDMETHOD.


  METHOD CONVERT_DATE_TO_TIMESTAMP.
    CONVERT DATE iv_date TIME iv_time
        INTO TIME STAMP rv_timestamp TIME ZONE ''.
  ENDMETHOD.


  METHOD convert_timestamp_to_date.
    CONVERT TIME STAMP iv_timestamp TIME ZONE ''
        INTO DATE rv_date
             TIME ev_time.
  ENDMETHOD.


  METHOD convert_to_timestamp.
    " DD/MM/YYYY, HH:mm:SS
    TRANSLATE iv_input USING '/ . : , '.
    CONDENSE iv_input NO-GAPS.

    DATA(lv_date) = CONV sy-datum( iv_input+4(4) && iv_input+2(2) && iv_input(2) ).
    DATA(lv_time) = CONV sy-uzeit( iv_input+8(2) && iv_input+10(2) && iv_input+12(2) ).

    CONVERT DATE lv_date TIME lv_time
        INTO TIME STAMP rv_timestamp TIME ZONE ''.
  ENDMETHOD.


  METHOD copy_data_to_ref.
    FIELD-SYMBOLS <fs_entity> TYPE any.

    CREATE DATA rr_data LIKE is_data.
    ASSIGN rr_data->* TO <fs_entity>.

    <fs_entity> = is_data.
  ENDMETHOD.


  method GET_DEFAULT_WORKCENTER.
    zcl_bc_fixed_values=>get_single_value( EXPORTING
                                            im_paramter_var = zcl_bc_fixed_values=>gc_default_werks_cst
                                            im_modulesp_var = zcl_bc_fixed_values=>gc_productn_cst
                                          IMPORTING
                                            ex_prmvalue_var = DATA(lv_default_workcenter) ).
    rv_workcenter = CONV #( lv_default_workcenter ).
  endmethod.


  METHOD get_method_name.
    DATA lt_callstack TYPE abap_callstack.

    DATA(lv_callstack) = COND #( WHEN iv_callstack IS NOT INITIAL AND iv_callstack GE 2
                                 THEN iv_callstack
                                 ELSE 2 ).

    CALL FUNCTION 'SYSTEM_CALLSTACK'
      EXPORTING
        max_level = lv_callstack
      IMPORTING
        callstack = lt_callstack.

    rv_method_name = lt_callstack[ lv_callstack ]-blockname.
  ENDMETHOD.


  METHOD get_printer.
    SELECT *
      FROM zabsf_pp133
      INTO TABLE @DATA(lt_pp133).

    rv_impr_out = VALUE #( lt_pp133[ areaid = iv_areaid werks = iv_werks arbpl = iv_arbpl sform = iv_sform ]-impr_out OPTIONAL ).
    CHECK rv_impr_out IS INITIAL.

    rv_impr_out = VALUE #( lt_pp133[ areaid = iv_areaid werks = iv_werks arbpl = iv_arbpl sform = space ]-impr_out OPTIONAL ).
    CHECK rv_impr_out IS INITIAL.

    rv_impr_out = VALUE #( lt_pp133[ areaid = iv_areaid werks = iv_werks arbpl = space sform = space ]-impr_out OPTIONAL ).
    CHECK rv_impr_out IS INITIAL.

    rv_impr_out = VALUE #( lt_pp133[ areaid = iv_areaid werks = space arbpl = space sform = space ]-impr_out OPTIONAL ).
    CHECK rv_impr_out IS INITIAL.

    rv_impr_out = VALUE #( lt_pp133[ areaid = space werks = space arbpl = space sform = space ]-impr_out OPTIONAL ).
    CHECK rv_impr_out IS INITIAL.
  ENDMETHOD.


  METHOD get_user_hrchy_wrkcntr_auth.
    SELECT hname, arbpl
      FROM zabsf_pprhfncwrk
      INTO TABLE @DATA(lt_authorizations)
      WHERE username EQ @iv_oprid
        AND begda    LE @sy-datum
        AND endda    GE @sy-datum.

    er_hierarchies =
      VALUE #( FOR h IN lt_authorizations ( sign = 'I' option = 'EQ' low = h-hname ) ).

    er_workcenters =
      VALUE #( FOR w IN lt_authorizations ( sign = 'I' option = 'EQ' low = w-arbpl ) ).

    SORT: er_hierarchies, er_workcenters.
    DELETE ADJACENT DUPLICATES FROM: er_hierarchies, er_workcenters.
  ENDMETHOD.


  METHOD validatesapresponse.
    DATA(lv_method_name) = zabsf_pp_cl_utils=>get_method_name( 3 ).

    LOOP AT it_result INTO DATA(ls_result).
      DATA: lv_error_msg  TYPE string,
            lv_error_type TYPE symsgty.

      IF ( ls_result-type EQ 'E' ) OR ( ls_result-type EQ 'A' ).
        lv_error_msg = |{ `Error in validateSAPResponse` } { ls_result-number }{ `:` }{ ls_result-message }|.
        lv_error_type = /iwbep/cl_cos_logger=>error.
      ELSEIF ( ls_result-type EQ 'W' ).
        lv_error_msg = |{ `Warning in validateSAPResponse` } { ls_result-number }{ `:` }{ ls_result-message }|.
        lv_error_type = /iwbep/cl_cos_logger=>warning.
      ENDIF.

      IF lv_error_msg IS NOT INITIAL.
        CALL METHOD co_msg->add_message_text_only
        EXPORTING
          iv_entity_type = lv_method_name
          iv_msg_type    = lv_error_type
          iv_msg_text    = CONV #( lv_error_msg ).

        " Raising Exception
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            message_container = co_msg.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD zabsf_pp_orders_time.
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
    DATA l_date_get TYPE xuvalue VALUE '12'.

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
       AND afpo~xloek EQ @abap_false.

    "eliminar concluidas
    DELETE lt_prdord_tab WHERE stat = 'I0009'.
    "ordena tabela
    SORT lt_prdord_tab BY aufnr posnr ASCENDING.
    "eliminar duplicados
    DELETE ADJACENT DUPLICATES FROM lt_prdord_tab COMPARING aufnr.

    LOOP AT lt_prdord_tab ASSIGNING FIELD-SYMBOL(<fs_prdord_str>).
      "verificar se PF é o mesmo
      IF iv_pf_var IS NOT INITIAL.
        "adicionar ordem tabela de saida
        APPEND VALUE #( aufnr = <fs_prdord_str>-aufnr
                        pf    = iv_pf_var ) TO et_orders_tab.
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
                AND bwart = '101'.                      "#EC CI_NOFIRST
            IF sy-subrc <> 0.
              CLEAR lv_menge_101.
            ENDIF.
            SELECT SUM( menge )
              INTO @DATA(lv_menge_102)
              FROM mseg
              WHERE aufnr = @<fs_orders_str>-aufnr
                AND bwart = '102'.                      "#EC CI_NOFIRST
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
                  WHERE aufnr = @<fs_orders_str>-aufnr.
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
  ENDMETHOD.


  METHOD zabsf_pp_stocks.
    DATA: ls_stocks_str   LIKE LINE OF et_data_out_tab,
          ex_data_aux_tab LIKE et_data_out_tab,
*          lv_pspnr_conv_var TYPE mspr-pspnr,
          ls_deposito_str TYPE zps_deposito_str,
          lt_deposito_str TYPE STANDARD TABLE OF zps_deposito_str,
          lr_matnr_var    TYPE RANGE OF matnr,
          ls_matnr_str    LIKE LINE OF lr_matnr_var,
          lr_pspnr_var    TYPE RANGE OF mspr-pspnr,
          ls_pspnr_str    LIKE LINE OF lr_pspnr_var,
          lr_werks_var    TYPE RANGE OF werks_d,
          ls_werks_str    LIKE LINE OF lr_werks_var,
          lr_pf_rng       TYPE RANGE OF atwrt,
          lr_name_rng     TYPE RANGE OF atwrt,
          lv_pspnr_var    TYPE string.

    DATA: lr_mart_rng TYPE RANGE OF mtart,
          lr_fert_rng TYPE RANGE OF mtart,
          lr_halb_rng TYPE RANGE OF mtart.


    "criar range tipos de materiais
    TRY.
        "semi-acabados
        IF iv_semifin_var EQ abap_true.
          CALL METHOD zcl_bc_fixed_values=>get_ranges_value
            EXPORTING
              im_paramter_var = zcl_bc_fixed_values=>gc_semiacab_cst
              im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
            IMPORTING
              ex_valrange_tab = lr_halb_rng.
        ENDIF.

        "produto acabado
        IF iv_finished_var EQ abap_true.
          CALL METHOD zcl_bc_fixed_values=>get_ranges_value
            EXPORTING
              im_paramter_var = zcl_bc_fixed_values=>gc_prodacab_cst
              im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
            IMPORTING
              ex_valrange_tab = lr_fert_rng.
        ENDIF.
        "criar range final
        APPEND LINES OF lr_halb_rng TO lr_mart_rng.
        APPEND LINES OF lr_fert_rng TO lr_mart_rng.

      CATCH zcx_pp_exceptions INTO DATA(lo_bcexceptions_obj).
        "mostrar mensagem de erro
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


    REFRESH et_data_out_tab.

*    CALL FUNCTION 'CONVERSION_EXIT_ABPSP_INPUT'
*      EXPORTING
*        input  = iv_pspnr_var
*      IMPORTING
*        output = lv_pspnr_conv_var.

******Obter caracteristicas para    =>       PF
    TRY.
        "obter valores da configuração
        zcl_bc_fixed_values=>get_ranges_value( EXPORTING
                                                 im_paramter_var = zcl_bc_fixed_values=>gc_coois_pf_cst
                                                 im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
                                               IMPORTING
                                                 ex_valrange_tab = lr_pf_rng ).

      CATCH zcx_pp_exceptions INTO DATA(lo_excpetion_obj).  ##NEEDED
        "falta configuração
        CALL METHOD zabsf_pp_cl_log=>add_message
          EXPORTING
            msgty      = lo_excpetion_obj->msgty
            msgno      = lo_excpetion_obj->msgno
            msgid      = lo_excpetion_obj->msgid
            msgv1      = lo_excpetion_obj->msgv1
            msgv2      = lo_excpetion_obj->msgv2
            msgv3      = lo_excpetion_obj->msgv3
            msgv4      = lo_excpetion_obj->msgv4
          CHANGING
            return_tab = return_tab.
        RETURN.
    ENDTRY.


    TRY.
        "obter valores da configuração descritivo de material
        zcl_bc_fixed_values=>get_ranges_value( EXPORTING
                                                 im_paramter_var = zcl_bc_fixed_values=>gc_charname_cst
                                                 im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
                                               IMPORTING
                                                 ex_valrange_tab = lr_name_rng ).

      CATCH zcx_pp_exceptions INTO lo_excpetion_obj.  ##NEEDED
        "falta configuração
        CALL METHOD zabsf_pp_cl_log=>add_message
          EXPORTING
            msgty      = lo_excpetion_obj->msgty
            msgno      = lo_excpetion_obj->msgno
            msgid      = lo_excpetion_obj->msgid
            msgv1      = lo_excpetion_obj->msgv1
            msgv2      = lo_excpetion_obj->msgv2
            msgv3      = lo_excpetion_obj->msgv3
            msgv4      = lo_excpetion_obj->msgv4
          CHANGING
            return_tab = return_tab.
        RETURN.
    ENDTRY.


    IF iv_matnr_var IS NOT INITIAL.
      ls_matnr_str-low = iv_matnr_var.
      ls_matnr_str-option = 'EQ'.
      ls_matnr_str-sign = 'I'.
      APPEND ls_matnr_str TO lr_matnr_var.
    ENDIF.

*    IF lv_pspnr_conv_var IS NOT INITIAL.
*      ls_pspnr_str-low = lv_pspnr_conv_var.
*      ls_pspnr_str-option = 'EQ'.
*      ls_pspnr_str-sign = 'I'.
*      APPEND ls_pspnr_str TO lr_pspnr_var.
*    ENDIF.

    IF iv_werks_var IS NOT INITIAL.
      ls_werks_str-low = iv_werks_var.
      ls_werks_str-option = 'EQ'.
      ls_werks_str-sign = 'I'.
      APPEND ls_werks_str TO lr_werks_var.
    ENDIF.


    SELECT mspr~charg, mspr~lgort, mspr~matnr, mspr~prlab, mspr~pspnr,
           mara~meins
      FROM mspr AS mspr
      INNER JOIN mara AS mara
      ON mara~matnr EQ mspr~matnr
      INTO TABLE @DATA(lt_mspr_tab)
      WHERE       "mspr~matnr IN @lr_matnr_var AND
*                  mspr~pspnr IN @lr_pspnr_var AND
                  mspr~werks IN @lr_werks_var AND
                  mara~mtart IN @lr_mart_rng AND
                  mspr~prlab GT 0.
    .
    IF sy-subrc = 0.


*****Seleccionar depósitos a processar a partir do centro
      SELECT lgort FROM zpp_deposit_tab INTO TABLE @DATA(lt_lgort_tab)
        WHERE werks IN @lr_werks_var.
      IF sy-subrc = 0.

        LOOP AT lt_mspr_tab     INTO DATA(ls_mspr_str).

****Validação de deposito
          READ TABLE lt_lgort_tab WITH KEY lgort = ls_mspr_str-lgort TRANSPORTING NO FIELDS.
          IF sy-subrc = 0.

*****Obter e validar PEP
            IF ls_mspr_str-charg IS NOT INITIAL
              AND ls_mspr_str-matnr IS NOT INITIAL.

              "obter classificação do lote
              zcl_mm_classification=>get_classification_by_batch( EXPORTING
                                                                    im_material_var       = ls_mspr_str-matnr
                                                                    im_lote_var           = ls_mspr_str-charg
                                                                    im_shownull_var       = abap_true
                                                                  IMPORTING
                                                                    ex_classification_tab = DATA(lt_charact_tab)
                                                                    ex_class_tab          = DATA(lt_class_tab) ).

              LOOP AT lt_charact_tab INTO DATA(ls_characct_str)
                                        WHERE atnam IN lr_pf_rng.
              ENDLOOP.


******Validação por valor de PF
*            IF ls_characct_str-ausp1 EQ iv_pf_var
              IF ls_characct_str-ausp1 CS iv_pf_var
                OR iv_pf_var IS INITIAL.

*****PF
                ls_stocks_str-pf = ls_characct_str-ausp1.


*****Validação para a descrição do material
*****descrição do material

                CLEAR ls_characct_str-ausp1.
                LOOP AT lt_charact_tab INTO ls_characct_str
                                          WHERE atnam IN lr_name_rng.


                  ls_stocks_str-descricao = ls_characct_str-ausp1.

                ENDLOOP.

*        if ls_characct_str-ausp1 EQ IV_MAT_DESC_VAR
                IF ls_characct_str-ausp1 CS iv_mat_desc_var
                      OR iv_mat_desc_var IS INITIAL.




*****MATERIAL
                  ls_stocks_str-material = ls_mspr_str-matnr.

*****Unidade de medida

                  ls_stocks_str-meins = ls_mspr_str-meins.

******Deposito

                  ls_deposito_str-quantidade    = ls_mspr_str-prlab.
                  ls_deposito_str-lote          = ls_mspr_str-charg.
                  ls_deposito_str-deposito      = ls_mspr_str-lgort.

                  SELECT SINGLE lgobe FROM t001l INTO @DATA(lv_lgobe_var)
                    WHERE werks = @iv_werks_var AND
                          lgort = @ls_mspr_str-lgort.
                  IF sy-subrc = 0.
                    ls_deposito_str-deposito_desc = lv_lgobe_var.
                  ENDIF.
                  APPEND ls_deposito_str TO ls_stocks_str-deposito.
*****quantidade
****lote



***Projecto + PEP
                  IF ls_mspr_str-pspnr IS NOT INITIAL.
                    SELECT SINGLE psphi FROM prps WHERE pspnr = @ls_mspr_str-pspnr INTO @DATA(lv_psphi_var).
                    IF sy-subrc = 0.
                      ls_stocks_str-projecto = lv_psphi_var.
                      "projecto
                      CALL FUNCTION 'CONVERSION_EXIT_KONPD_OUTPUT'
                        EXPORTING
                          input  = lv_psphi_var
                        IMPORTING
                          output = ls_stocks_str-out_projecto.

                    ENDIF.

******PEP de entrada
                    CLEAR lv_pspnr_var.
                    CALL FUNCTION 'CONVERSION_EXIT_ABPSP_OUTPUT'
                      EXPORTING
                        input  = ls_mspr_str-pspnr
                      IMPORTING
                        output = ls_stocks_str-out_pep.

                    ls_stocks_str-pep = ls_mspr_str-pspnr.

*****Se não foi inserido pep como parametro, é necessário converter os 2 valores


                  ENDIF.

                  APPEND ls_stocks_str TO et_data_out_tab.

                  CLEAR ls_stocks_str.
                  REFRESH ls_stocks_str-deposito.


*****VAlidação por descrição do material
                ENDIF.

****Validação por PF
              ENDIF.

*****Se tivermos lote e material
            ENDIF.

*****Validação de deposito
          ENDIF.

****Loop aos dados da mspr
        ENDLOOP.

***zpp_deposit_tab => Selecção de depositos
      ENDIF.



***    mspr
    ENDIF.



******Junção de deposito para o mesmo header (Projecto, PEP, PF, MAT, descrição)
    REFRESH ex_data_aux_tab.
    LOOP AT et_data_out_tab INTO DATA(ls_data_str).

      READ TABLE ex_data_aux_tab WITH KEY projecto  =  ls_data_str-projecto
                                          pep       = ls_data_str-pep
                                          pf        = ls_data_str-pf
                                          material  = ls_data_str-material
                                          descricao = ls_data_str-descricao
                          ASSIGNING FIELD-SYMBOL(<fs_data_aux_str>).
      IF sy-subrc = 0.
****adicionar nova linha de deposito
        APPEND LINES OF ls_data_str-deposito TO <fs_data_aux_str>-deposito.

      ELSE.
**  adicionar nova linha total
        APPEND ls_data_str TO ex_data_aux_tab.

      ENDIF.

    ENDLOOP.

    et_data_out_tab[] = ex_data_aux_tab[].
  ENDMETHOD.
ENDCLASS.
