class ZCL_Z_SF_ODATA_SERVICE_DPC_EXT definition
  public
  inheriting from ZCL_Z_SF_ODATA_SERVICE_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CREATE_DEEP_ENTITY
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~DELETE_ENTITY
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_ENTITY
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_ENTITYSET
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_EXPANDED_ENTITY
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_EXPANDED_ENTITYSET
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~PATCH_ENTITY
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~UPDATE_ENTITY
    redefinition .
  methods /IWBEP/IF_MGW_CORE_SRV_RUNTIME~CREATE_ENTITY
    redefinition .
  methods /IWBEP/IF_MGW_CORE_SRV_RUNTIME~INIT
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_STREAM
    redefinition .
protected section.
private section.

  class-data GV_JWT_TOKEN type STRING .
  class-data GS_INPUTOBJ type ZABSF_PP_S_INPUTOBJECT .
  class-data GV_SFUSERNAME type STRING .
ENDCLASS.



CLASS ZCL_Z_SF_ODATA_SERVICE_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~create_deep_entity.
**TRY.
*CALL METHOD SUPER->/IWBEP/IF_MGW_APPL_SRV_RUNTIME~CREATE_DEEP_ENTITY
*  EXPORTING
**    iv_entity_name          =
**    iv_entity_set_name      =
**    iv_source_name          =
*    IO_DATA_PROVIDER        =
**    it_key_tab              =
**    it_navigation_path      =
*    IO_EXPAND               =
**    io_tech_request_context =
**  IMPORTING
**    er_deep_entity          =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
    DATA: lt_keys             TYPE /iwbep/t_mgw_tech_pairs,
          lv_entity_type_name TYPE /iwbep/mgw_tech_name,
          lo_msg              TYPE REF TO /iwbep/if_message_container,
          lv_header           TYPE string,
          lr_busi_exception   TYPE REF TO /iwbep/cx_mgw_tech_exception.

    lt_keys = io_tech_request_context->get_source_keys( ).
    lv_entity_type_name = to_upper( val = io_tech_request_context->get_entity_type_name( ) ).
    lo_msg = me->/iwbep/if_mgw_conv_srv_runtime~get_message_container( ).
    lv_header = to_upper( val = lcl_odata_utils=>get_header( EXPORTING io_facade = /iwbep/if_mgw_conv_srv_runtime~get_dp_facade( ) iv_header_name = 'x-zabsf-method' ) ).

    IF gs_inputobj IS NOT INITIAL.
      IF lv_header EQ 'UPDATE'.
        TRY.
            CALL METHOD lcl_odata_routing=>handle_update
              EXPORTING
                is_inputobj         = gs_inputobj
                it_keys             = lt_keys
                iv_jwt_token        = gv_jwt_token
                iv_entity_type_name = lv_entity_type_name
                io_data_provider    = io_data_provider
              IMPORTING
                er_entity = er_deep_entity
              CHANGING
                co_msg              = lo_msg.
          CATCH /iwbep/cx_mgw_tech_exception INTO lr_busi_exception.
            RAISE EXCEPTION lr_busi_exception.
          CATCH cx_root INTO DATA(lr_cx_exception).
            RAISE EXCEPTION lr_cx_exception.
        ENDTRY.
      ELSE.
        TRY.
            CALL METHOD lcl_odata_routing=>handle_create
              EXPORTING
                is_inputobj         = gs_inputobj
                iv_jwt_token        = gv_jwt_token
                iv_entity_type_name = lv_entity_type_name
                io_data_provider    = io_data_provider
              IMPORTING
                er_entity = er_deep_entity
              CHANGING
                co_msg              = lo_msg.
          CATCH /iwbep/cx_mgw_tech_exception INTO lr_busi_exception.
            RAISE EXCEPTION lr_busi_exception.
        ENDTRY.
      ENDIF.
    ELSE.
      DATA(lr_http_exception) = lcl_odata_utils=>raise_http_error( '403' ).
      RAISE EXCEPTION lr_http_exception.
    ENDIF.
  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~delete_entity.
**TRY.
*CALL METHOD SUPER->/IWBEP/IF_MGW_APPL_SRV_RUNTIME~DELETE_ENTITY
**  EXPORTING
**    iv_entity_name          =
**    iv_entity_set_name      =
**    iv_source_name          =
**    it_key_tab              =
**    it_navigation_path      =
**    io_tech_request_context =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
    DATA: lt_keys             TYPE /iwbep/t_mgw_tech_pairs,
          lv_entity_type_name TYPE /iwbep/mgw_tech_name,
          lo_msg              TYPE REF TO /iwbep/if_message_container.

    lt_keys = io_tech_request_context->get_keys( ).
    lv_entity_type_name = to_upper( val = io_tech_request_context->get_entity_type_name( ) ).
    lo_msg = me->/iwbep/if_mgw_conv_srv_runtime~get_message_container( ).

    IF gs_inputobj IS NOT INITIAL.
      TRY.
          CALL METHOD lcl_odata_routing=>handle_delete
            EXPORTING
              is_inputobj         = gs_inputobj
              it_keys             = lt_keys
              iv_jwt_token        = gv_jwt_token
              iv_entity_type_name = lv_entity_type_name
            CHANGING
              co_msg              = lo_msg.
        CATCH /iwbep/cx_mgw_tech_exception INTO DATA(lr_busi_exception).
          RAISE EXCEPTION lr_busi_exception.
        CATCH cx_root INTO DATA(lr_cx_exception).
          RAISE EXCEPTION lr_cx_exception.
      ENDTRY.
    ELSE.
      DATA(lr_http_exception) = lcl_odata_utils=>raise_http_error( '403' ).
      RAISE EXCEPTION lr_http_exception.
    ENDIF.
  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~get_entity.
**TRY.
*CALL METHOD SUPER->/IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_ENTITY
**  EXPORTING
**    iv_entity_name          =
**    iv_entity_set_name      =
**    iv_source_name          =
**    it_key_tab              =
**    it_navigation_path      =
**    io_tech_request_context =
**  IMPORTING
**    er_entity               =
**    es_response_context     =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
    DATA: lt_keys             TYPE /iwbep/t_mgw_tech_pairs,
          lv_entity_type_name TYPE /iwbep/mgw_tech_name,
          lo_msg              TYPE REF TO /iwbep/if_message_container.

    lt_keys = io_tech_request_context->get_keys( ).
    lv_entity_type_name = to_upper( val = io_tech_request_context->get_entity_type_name( ) ).
    lo_msg = me->/iwbep/if_mgw_conv_srv_runtime~get_message_container( ).

    IF ( gv_jwt_token IS NOT INITIAL )
        OR ( lv_entity_type_name EQ 'PARAMETER' ).

*      DATA(lv_authorized) = LCL_AUTHORIZATION=>CHECK( EXPORTING IV_USERNAME = gv_sfusername "gs_inputobj-oprid
*                                          IV_ENDPOINT = iv_entity_name
*                                          IV_ACTIVITY = `G` ).

*      DATA: lr_router TYPE REF TO lcl_odata_router.
*      CREATE OBJECT lr_router
*        EXPORTING
*          iv_path              = lv_endpoint
*          iv_operation_type    = lv_operation_type
*          it_entity_keys       = lt_entity_keys
*          it_query_string_keys = lt_query_keys.
*
*      CALL METHOD lr_router->get_class_method
*        IMPORTING
*          ev_class_name  = DATA(lv_class_name)
*          ev_method_name = DATA(lv_method_name).

      TRY.
          CALL METHOD lcl_odata_routing=>handle_get
            EXPORTING
              is_inputobj         = gs_inputobj
              it_keys             = lt_keys
              iv_jwt_token        = gv_jwt_token
              iv_entity_type_name = lv_entity_type_name
            IMPORTING
              er_entity           = er_entity
            CHANGING
              co_msg              = lo_msg.
        CATCH /iwbep/cx_mgw_tech_exception INTO DATA(lr_busi_exception).
          RAISE EXCEPTION lr_busi_exception.
        CATCH cx_root INTO DATA(lr_cx_exception).
          RAISE EXCEPTION lr_cx_exception.
      ENDTRY.
    ELSE.
      DATA(lr_http_exception) = lcl_odata_utils=>raise_http_error( '403' ).
      RAISE EXCEPTION lr_http_exception.
    ENDIF.
  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~get_entityset.
**TRY.
*CALL METHOD SUPER->/IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_ENTITYSET
**  EXPORTING
**    iv_entity_name           =
**    iv_entity_set_name       =
**    iv_source_name           =
**    it_filter_select_options =
**    it_order                 =
**    is_paging                =
**    it_navigation_path       =
**    it_key_tab               =
**    iv_filter_string         =
**    iv_search_string         =
**    io_tech_request_context  =
**  IMPORTING
**    er_entityset             =
**    es_response_context      =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
    DATA: lt_keys             TYPE /iwbep/t_mgw_tech_pairs,
          lv_entity_type_name TYPE /iwbep/mgw_tech_name,
          lo_msg              TYPE REF TO /iwbep/if_message_container.

    lt_keys = io_tech_request_context->get_source_keys( ).
    lv_entity_type_name = to_upper( val = io_tech_request_context->get_entity_type_name( ) ).
    lo_msg = me->/iwbep/if_mgw_conv_srv_runtime~get_message_container( ).

    IF ( gs_inputobj IS NOT INITIAL )
        OR ( lv_entity_type_name EQ 'PARAMETER' )
        OR ( lv_entity_type_name EQ 'TOKEN' )
        OR ( lv_entity_type_name EQ 'SYSTEMINFO' ).

      DATA(lv_is_csrf_fetch) = lcl_odata_utils=>check_csrf_fetch( ).
      IF lv_is_csrf_fetch EQ abap_true.
        RETURN.
      ENDIF.

      IF lv_entity_type_name EQ 'TOKEN'.
        RETURN.
      ENDIF.

      TRY.
          CALL METHOD lcl_odata_routing=>handle_get_set
            EXPORTING
              is_inputobj         = gs_inputobj
              it_keys             = lt_keys
              iv_jwt_token        = gv_jwt_token
              iv_entity_type_name = lv_entity_type_name
            IMPORTING
              er_entityset        = er_entityset
            CHANGING
              co_msg              = lo_msg.
        CATCH /iwbep/cx_mgw_tech_exception INTO DATA(lr_busi_exception).
          RAISE EXCEPTION lr_busi_exception.
        CATCH cx_root INTO DATA(lr_cx_exception).
          RAISE EXCEPTION lr_cx_exception.
      ENDTRY.
    ELSE.
      DATA(lr_http_exception) = lcl_odata_utils=>raise_http_error( '403' ).
      RAISE EXCEPTION lr_http_exception.
    ENDIF.
  ENDMETHOD.


METHOD /iwbep/if_mgw_appl_srv_runtime~get_expanded_entity.
**TRY.
*CALL METHOD SUPER->/IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_EXPANDED_ENTITY
**  EXPORTING
**    iv_entity_name           =
**    iv_entity_set_name       =
**    iv_source_name           =
**    it_key_tab               =
**    it_navigation_path       =
**    io_expand                =
**    io_tech_request_context  =
**  IMPORTING
**    er_entity                =
**    es_response_context      =
**    et_expanded_clauses      =
**    et_expanded_tech_clauses =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
  DATA: lt_keys             TYPE /iwbep/t_mgw_tech_pairs,
        lv_entity_type_name TYPE /iwbep/mgw_tech_name,
        lo_msg              TYPE REF TO /iwbep/if_message_container.

  lt_keys = io_tech_request_context->get_keys( ).
  lv_entity_type_name = to_upper( val = io_tech_request_context->get_entity_type_name( ) ).
  lo_msg = me->/iwbep/if_mgw_conv_srv_runtime~get_message_container( ).

  IF ( gs_inputobj IS NOT INITIAL )
      OR ( lv_entity_type_name EQ 'PARAMETER' ).

    TRY.
        CALL METHOD lcl_odata_routing=>handle_get
          EXPORTING
            is_inputobj         = gs_inputobj
            it_keys             = lt_keys
            iv_jwt_token        = gv_jwt_token
            iv_entity_type_name = lv_entity_type_name
          IMPORTING
            er_entity           = er_entity
          CHANGING
            co_msg              = lo_msg.
      CATCH /iwbep/cx_mgw_tech_exception INTO DATA(lr_busi_exception).
        RAISE EXCEPTION lr_busi_exception.
      CATCH cx_root INTO DATA(lr_cx_exception).
        RAISE EXCEPTION lr_cx_exception.
    ENDTRY.

    et_expanded_tech_clauses = lcl_odata_utils=>set_expanded( ir_entity_ctx = io_tech_request_context ).
  ELSE.
    DATA(lr_http_exception) = lcl_odata_utils=>raise_http_error( '403' ).
    RAISE EXCEPTION lr_http_exception.
  ENDIF.
ENDMETHOD.


METHOD /iwbep/if_mgw_appl_srv_runtime~get_expanded_entityset.
**TRY.
*CALL METHOD SUPER->/IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_EXPANDED_ENTITYSET
**  EXPORTING
**    iv_entity_name           =
**    iv_entity_set_name       =
**    iv_source_name           =
**    it_filter_select_options =
**    it_order                 =
**    is_paging                =
**    it_navigation_path       =
**    it_key_tab               =
**    iv_filter_string         =
**    iv_search_string         =
**    io_expand                =
**    io_tech_request_context  =
**  IMPORTING
**    er_entityset             =
**    et_expanded_clauses      =
**    et_expanded_tech_clauses =
**    es_response_context      =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
    DATA: lt_keys             TYPE /iwbep/t_mgw_tech_pairs,
            lv_entity_type_name TYPE /iwbep/mgw_tech_name,
            lo_msg              TYPE REF TO /iwbep/if_message_container.

    lt_keys = io_tech_request_context->get_source_keys( ).
    lv_entity_type_name = to_upper( val = io_tech_request_context->get_entity_type_name( ) ).
    lo_msg = me->/iwbep/if_mgw_conv_srv_runtime~get_message_container( ).

    IF gs_inputobj IS NOT INITIAL.
        TRY.
            CALL METHOD lcl_odata_routing=>handle_get_set
            EXPORTING
                is_inputobj         = gs_inputobj
                it_keys             = lt_keys
                iv_jwt_token        = gv_jwt_token
                iv_entity_type_name = lv_entity_type_name
            IMPORTING
                er_entityset        = er_entityset
            CHANGING
                co_msg              = lo_msg.
        CATCH /iwbep/cx_mgw_tech_exception INTO DATA(lr_busi_exception).
            RAISE EXCEPTION lr_busi_exception.
        CATCH cx_root INTO DATA(lr_cx_exception).
            RAISE EXCEPTION lr_cx_exception.
        ENDTRY.

        et_expanded_tech_clauses = lcl_odata_utils=>set_expanded( ir_entityset_ctx = io_tech_request_context ).
    ELSE.
        DATA(lr_http_exception) = lcl_odata_utils=>raise_http_error( '403' ).
        RAISE EXCEPTION lr_http_exception.
    ENDIF.
    ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~get_stream.
**TRY.
*CALL METHOD SUPER->/IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_STREAM
**  EXPORTING
**    iv_entity_name          = iv_entity_name
**    iv_entity_set_name      = iv_entity_set_name
**    iv_source_name          = iv_source_name
**    it_key_tab              = it_key_tab
**    it_navigation_path      = it_navigation_path
**    io_tech_request_context = io_tech_request_context
**  IMPORTING
**    er_stream               = er_stream
**    es_response_context     = es_response_context
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
    DATA: lt_keys             TYPE /iwbep/t_mgw_tech_pairs,
          lv_entity_type_name TYPE /iwbep/mgw_tech_name,
          lo_msg              TYPE REF TO /iwbep/if_message_container.

    lt_keys = io_tech_request_context->get_keys( ).
    lv_entity_type_name = to_upper( val = io_tech_request_context->get_entity_type_name( ) ).
    lo_msg = me->/iwbep/if_mgw_conv_srv_runtime~get_message_container( ).

    IF gs_inputobj IS NOT INITIAL.
      TRY.
          CALL METHOD lcl_odata_routing=>handle_get_stream
            EXPORTING
              is_inputobj         = gs_inputobj
              it_keys             = lt_keys
              iv_jwt_token        = gv_jwt_token
              iv_entity_type_name = lv_entity_type_name
            IMPORTING
              er_stream           = er_stream
            CHANGING
              co_msg              = lo_msg.
        CATCH /iwbep/cx_mgw_tech_exception INTO DATA(lr_busi_exception).
          RAISE EXCEPTION lr_busi_exception.
        CATCH cx_root INTO DATA(lr_cx_exception).
          RAISE EXCEPTION lr_cx_exception.
      ENDTRY.
    ELSE.
      DATA(lr_http_exception) = lcl_odata_utils=>raise_http_error( '403' ).
      RAISE EXCEPTION lr_http_exception.
    ENDIF.
  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~patch_entity.
**TRY.
*CALL METHOD SUPER->/IWBEP/IF_MGW_APPL_SRV_RUNTIME~PATCH_ENTITY
*  EXPORTING
**    iv_entity_name          =
**    iv_entity_set_name      =
**    iv_source_name          =
*    IO_DATA_PROVIDER        =
**    it_key_tab              =
**    it_navigation_path      =
**    io_tech_request_context =
**  IMPORTING
**    er_entity               =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
    DATA: lt_keys             TYPE /iwbep/t_mgw_tech_pairs,
          lv_entity_type_name TYPE /iwbep/mgw_tech_name,
          lo_msg              TYPE REF TO /iwbep/if_message_container.

    lt_keys = io_tech_request_context->get_keys( ).
    lv_entity_type_name = to_upper( val = io_tech_request_context->get_entity_type_name( ) ).
    lo_msg = me->/iwbep/if_mgw_conv_srv_runtime~get_message_container( ).

    IF ( gs_inputobj IS NOT INITIAL )
        OR ( lv_entity_type_name EQ 'PARAMETER' ).
      TRY.
          CALL METHOD lcl_odata_routing=>handle_update
            EXPORTING
              is_inputobj         = gs_inputobj
              it_keys             = lt_keys
              iv_jwt_token        = gv_jwt_token
              iv_entity_type_name = lv_entity_type_name
              io_data_provider    = io_data_provider
              IMPORTING
                er_entity = er_entity
            CHANGING
              co_msg              = lo_msg.
        CATCH /iwbep/cx_mgw_tech_exception INTO DATA(lr_busi_exception).
          RAISE EXCEPTION lr_busi_exception.
        CATCH cx_root INTO DATA(lr_cx_exception).
          RAISE EXCEPTION lr_cx_exception.
      ENDTRY.
    ELSE.
      DATA(lr_http_exception) = lcl_odata_utils=>raise_http_error( '403' ).
      RAISE EXCEPTION lr_http_exception.
    ENDIF.
  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~update_entity.
**TRY.
*CALL METHOD SUPER->/IWBEP/IF_MGW_APPL_SRV_RUNTIME~UPDATE_ENTITY
*  EXPORTING
**    iv_entity_name          =
**    iv_entity_set_name      =
**    iv_source_name          =
*    IO_DATA_PROVIDER        =
**    it_key_tab              =
**    it_navigation_path      =
**    io_tech_request_context =
**  IMPORTING
**    er_entity               =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
    DATA: lt_keys             TYPE /iwbep/t_mgw_tech_pairs,
          lv_entity_type_name TYPE /iwbep/mgw_tech_name,
          lo_msg              TYPE REF TO /iwbep/if_message_container.

    lt_keys = io_tech_request_context->get_keys( ).
    lv_entity_type_name = to_upper( val = io_tech_request_context->get_entity_type_name( ) ).
    lo_msg = me->/iwbep/if_mgw_conv_srv_runtime~get_message_container( ).

    IF ( gs_inputobj IS NOT INITIAL )
        OR ( lv_entity_type_name EQ 'PARAMETER' ).
      TRY.
          CALL METHOD lcl_odata_routing=>handle_update
            EXPORTING
              is_inputobj         = gs_inputobj
              it_keys             = lt_keys
              iv_jwt_token        = gv_jwt_token
              iv_entity_type_name = lv_entity_type_name
              io_data_provider    = io_data_provider
              IMPORTING
                er_entity = er_entity
            CHANGING
              co_msg              = lo_msg.
        CATCH /iwbep/cx_mgw_tech_exception INTO DATA(lr_busi_exception).
          RAISE EXCEPTION lr_busi_exception.
        CATCH cx_root INTO DATA(lr_cx_exception).
          RAISE EXCEPTION lr_cx_exception.
      ENDTRY.
    ELSE.
      DATA(lr_http_exception) = lcl_odata_utils=>raise_http_error( '403' ).
      RAISE EXCEPTION lr_http_exception.
    ENDIF.
  ENDMETHOD.


  METHOD /iwbep/if_mgw_core_srv_runtime~create_entity.
**TRY.
*CALL METHOD SUPER->/IWBEP/IF_MGW_CORE_SRV_RUNTIME~CREATE_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME     =
*    IV_SOURCE_NAME     =
*    IO_DATA_PROVIDER   =
*    IS_REQUEST_DETAILS =
*  CHANGING
*    CT_HEADERS         =
*    CR_ENTITY          =
**    ct_inline_info     =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
    DATA: lv_entity_type_name TYPE /iwbep/mgw_tech_name,
          lo_msg              TYPE REF TO /iwbep/if_message_container.

    lv_entity_type_name = to_upper( val = iv_entity_name ).
    lo_msg = me->/iwbep/if_mgw_conv_srv_runtime~get_message_container( ).

    IF ( gs_inputobj IS NOT INITIAL )
        OR ( gv_jwt_token IS INITIAL AND lv_entity_type_name EQ 'TOKEN' ).
      " If deep insert/update
      IF is_request_details-technical_request-expand IS NOT INITIAL.
        CALL METHOD super->/iwbep/if_mgw_core_srv_runtime~create_entity
          EXPORTING
            iv_entity_name     = iv_entity_name
            iv_source_name     = iv_source_name
            io_data_provider   = io_data_provider
            is_request_details = is_request_details
          CHANGING
            ct_headers         = ct_headers
            cr_entity          = cr_entity
            ct_inline_info     = ct_inline_info.
      ELSE.
        TRY.
            CALL METHOD lcl_odata_routing=>handle_create
              EXPORTING
                is_inputobj         = gs_inputobj
                iv_jwt_token        = gv_jwt_token
                iv_entity_type_name = lv_entity_type_name
                io_data_provider    = io_data_provider
              IMPORTING
                er_entity           = cr_entity
              CHANGING
                co_msg              = lo_msg.
          CATCH /iwbep/cx_mgw_tech_exception INTO DATA(lr_busi_exception).
            RAISE EXCEPTION lr_busi_exception.
          CATCH cx_root INTO DATA(lr_cx_exception).
            RAISE EXCEPTION lr_cx_exception.
        ENDTRY.
      ENDIF.
    ELSE.
      DATA(lr_http_exception) = lcl_odata_utils=>raise_http_error( '403' ).
      RAISE EXCEPTION lr_http_exception.
    ENDIF.
  ENDMETHOD.


  METHOD /iwbep/if_mgw_core_srv_runtime~init.
**TRY.
*CALL METHOD SUPER->/IWBEP/IF_MGW_CORE_SRV_RUNTIME~INIT
*  EXPORTING
*    IV_SERVICE_DOCUMENT_NAME =
*    IV_NAMESPACE             =
*    IV_VERSION               =
**    io_context               =
*    .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
*    " Get the token and verify its authenticity
*    DATA(lv_jwt_token) = zabsf_pp_cl_authentication=>get_jwt_from_cookie( ).
*    DATA lv_jwt_valid TYPE abap_bool VALUE abap_false.
*    IF strlen( lv_jwt_token ) GT 0.
*      lv_jwt_valid = zabsf_pp_cl_authentication=>validate_token( EXPORTING iv_token = lv_jwt_token ).
*    ENDIF.
*
*    "DATA(lv_jwt_valid) = zabsf_pp_cl_authentication=>validate_token( EXPORTING iv_token = lv_jwt_token ).
*    IF ( lv_jwt_valid EQ abap_true ).
*      " Save the token to a globally accessible variable
*      gv_jwt_token = zabsf_pp_cl_authentication=>decrypt_token( lv_jwt_token ).
*
*      TRY.
*          " Change the running user from the default to the desired one
*          DATA(lv_username) = zabsf_pp_cl_authentication=>get_claim( EXPORTING iv_token = gv_jwt_token iv_claim = 'username' ).
*          "DATA(lv_suser_changed) = zabsf_pp_cl_authentication=>change_sap_user( lv_username ).
*          zabsf_pp_cl_authentication=>change_sap_user( EXPORTING iv_username = lv_username
*                                                       IMPORTING rv_user_changed = DATA(lv_suser_changed) ).
*
*          IF lv_suser_changed EQ abap_true.
*            " Copy the token claims to our inputobj
*            gv_sfusername = lv_username.
*            gs_inputobj-oprid = lv_username.
*            gs_inputobj-pernr = zabsf_pp_cl_authentication=>get_claim( EXPORTING iv_token = gv_jwt_token iv_claim = 'userERPId' ).
*            gs_inputobj-areaid = zabsf_pp_cl_authentication=>get_claim( EXPORTING iv_token = gv_jwt_token iv_claim = 'area' ).
*            gs_inputobj-language = zabsf_pp_cl_authentication=>get_claim( EXPORTING iv_token = gv_jwt_token iv_claim = 'language' ).
*
*            gs_inputobj-werks = zabsf_pp_cl_authentication=>get_claim( EXPORTING iv_token = gv_jwt_token iv_claim = 'center' ).
*            IF gs_inputobj-werks IS INITIAL.
*              zcl_bc_fixed_values=>get_single_value( EXPORTING
*                                            im_paramter_var = zcl_bc_fixed_values=>gc_default_werks_cst
*                                            im_modulesp_var = zcl_bc_fixed_values=>gc_productn_cst
*                                          IMPORTING
*                                            ex_prmvalue_var = DATA(lv_default_workcenter) ).
*
*              gs_inputobj-werks = lv_default_workcenter.
*            ENDIF.
*          ENDIF.
*        CATCH cx_root INTO DATA(lr_error).
*          CLEAR gs_inputobj.
*          lcl_odata_error_logging=>log_cx_error( lr_error ).
*      ENDTRY.
*    ENDIF.
*
*    CALL METHOD super->/iwbep/if_mgw_core_srv_runtime~init
*      EXPORTING
*        iv_service_document_name = iv_service_document_name
*        iv_namespace             = iv_namespace
*        iv_version               = iv_version
*        io_context               = io_context.

    """"""""""""""

    " Get the token and verify its validity
    DATA(lv_jwt_token) = zabsf_pp_cl_authentication=>new_get_token_cookie( ).
    IF zabsf_pp_cl_authentication=>new_validate_token( lv_jwt_token ).

      " Copy the token claims to our inputobj
      DATA(lt_claims) = zabsf_pp_cl_authentication=>new_get_claims( lv_jwt_token ).

      IF zabsf_pp_cl_authentication=>new_change_sap_user( VALUE #( lt_claims[ name = 'username' ]-value OPTIONAL ) ) EQ abap_true .
        gs_inputobj = VALUE #( oprid = VALUE #( lt_claims[ name = 'username' ]-value OPTIONAL )
                               pernr = VALUE #( lt_claims[ name = 'usererpid' ]-value OPTIONAL )
                               areaid = VALUE #( lt_claims[ name = 'area' ]-value OPTIONAL )
                               language = VALUE #( lt_claims[ name = 'language' ]-value OPTIONAL )
                               werks = COND #( WHEN VALUE #( lt_claims[ name = 'center' ]-value OPTIONAL ) IS NOT INITIAL
                                                    THEN VALUE #( lt_claims[ name = 'center' ]-value OPTIONAL )
                                               ELSE |{ zabsf_pp_cl_utils=>get_default_workcenter( ) }| ) ).
      ENDIF.
    ENDIF.

    CALL METHOD super->/iwbep/if_mgw_core_srv_runtime~init
      EXPORTING
        iv_service_document_name = iv_service_document_name
        iv_namespace             = iv_namespace
        iv_version               = iv_version
        io_context               = io_context.
  ENDMETHOD.
ENDCLASS.
