*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lcl_odata_utils DEFINITION
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS get_method_name
      IMPORTING
        !iv_callstack         TYPE i OPTIONAL
      RETURNING
        VALUE(rv_method_name) TYPE string .
    CLASS-METHODS raise_http_error
      IMPORTING
        !iv_error_code      TYPE /iwbep/mgw_http_status_code
      RETURNING
        VALUE(eo_exception) TYPE REF TO /iwbep/cx_mgw_tech_exception.
    CLASS-METHODS    get_url_params
      RETURNING
        VALUE(rv_values) TYPE tihttpnvp .
    CLASS-METHODS copy_user_keys
      IMPORTING
        !it_keys      TYPE /iwbep/t_mgw_tech_pairs
        !it_params    TYPE tihttpnvp
      CHANGING
        !ct_user_keys TYPE /iwbep/t_mgw_tech_pairs .
    CLASS-METHODS copy_all_keys
      IMPORTING
        !it_keys            TYPE /iwbep/t_mgw_tech_pairs
        !it_params          TYPE tihttpnvp
      RETURNING
        VALUE(rt_user_keys) TYPE /iwbep/t_mgw_tech_pairs .
    CLASS-METHODS set_expanded
      IMPORTING
        !ir_entity_ctx                  TYPE REF TO /iwbep/if_mgw_req_entity OPTIONAL
        !ir_entityset_ctx               TYPE REF TO /iwbep/if_mgw_req_entityset OPTIONAL
      RETURNING
        VALUE(rt_expanded_tech_clauses) TYPE string_table .
    CLASS-METHODS get_header
      IMPORTING
        !io_facade      TYPE REF TO /iwbep/if_mgw_dp_facade
        !iv_header_name TYPE string
      RETURNING
        VALUE(rv_value) TYPE string .
    CLASS-METHODS check_csrf_fetch
      RETURNING
        VALUE(rv_isfetch) TYPE abap_bool .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS lcl_odata_error_logging DEFINITION
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS log_cx_error
      IMPORTING
        !ir_error           TYPE REF TO cx_root
      RETURNING
        VALUE(ro_exception) TYPE REF TO /iwbep/cx_mgw_tech_exception.

    CLASS-METHODS log_busi_error
      IMPORTING
        !io_msg             TYPE REF TO /iwbep/if_message_container
      RETURNING
        VALUE(eo_exception) TYPE REF TO /iwbep/cx_mgw_tech_exception.
  PROTECTED SECTION.
  PRIVATE SECTION.

    CLASS-METHODS log_error
      IMPORTING
        !iv_sfuser     TYPE string
        !iv_sapuser    TYPE uname
        !iv_origin     TYPE string
        !iv_message    TYPE string
        !iv_error_type TYPE char1 DEFAULT 'E' .
ENDCLASS.

CLASS lcl_odata_routing DEFINITION
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS handle_get_set
      IMPORTING
        !is_inputobj         TYPE zabsf_pp_s_inputobject
        !it_keys             TYPE /iwbep/t_mgw_tech_pairs
        !iv_jwt_token        TYPE string
        !iv_entity_type_name TYPE /iwbep/mgw_tech_name
      EXPORTING
        !er_entityset        TYPE REF TO data
      CHANGING
        !co_msg              TYPE REF TO /iwbep/if_message_container
      RAISING
        /iwbep/cx_mgw_tech_exception .
    CLASS-METHODS handle_get
      IMPORTING
        !is_inputobj         TYPE zabsf_pp_s_inputobject
        !it_keys             TYPE /iwbep/t_mgw_tech_pairs
        !iv_jwt_token        TYPE string
        !iv_entity_type_name TYPE /iwbep/mgw_tech_name
      EXPORTING
        !er_entity           TYPE REF TO data
      CHANGING
        !co_msg              TYPE REF TO /iwbep/if_message_container
      RAISING
        /iwbep/cx_mgw_tech_exception .
    CLASS-METHODS handle_create
      IMPORTING
        !is_inputobj         TYPE zabsf_pp_s_inputobject
        !iv_jwt_token        TYPE string
        !iv_entity_type_name TYPE /iwbep/mgw_tech_name
        !io_data_provider    TYPE REF TO /iwbep/if_mgw_entry_provider
      EXPORTING
        !er_entity           TYPE REF TO data
      CHANGING
        !co_msg              TYPE REF TO /iwbep/if_message_container
      RAISING
        /iwbep/cx_mgw_tech_exception .
    CLASS-METHODS handle_update
      IMPORTING
        !is_inputobj         TYPE zabsf_pp_s_inputobject
        !it_keys             TYPE /iwbep/t_mgw_tech_pairs
        !iv_jwt_token        TYPE string
        !iv_entity_type_name TYPE /iwbep/mgw_tech_name
        !io_data_provider    TYPE REF TO /iwbep/if_mgw_entry_provider
      EXPORTING
        !er_entity           TYPE REF TO data
      CHANGING
        !co_msg              TYPE REF TO /iwbep/if_message_container
      RAISING
        /iwbep/cx_mgw_tech_exception .
    CLASS-METHODS handle_delete
      IMPORTING
        !is_inputobj         TYPE zabsf_pp_s_inputobject
        !it_keys             TYPE /iwbep/t_mgw_tech_pairs
        !iv_jwt_token        TYPE string
        !iv_entity_type_name TYPE /iwbep/mgw_tech_name
      CHANGING
        !co_msg              TYPE REF TO /iwbep/if_message_container
      RAISING
        /iwbep/cx_mgw_tech_exception .
    CLASS-METHODS handle_get_stream
      IMPORTING
        !is_inputobj         TYPE zabsf_pp_s_inputobject
        !it_keys             TYPE /iwbep/t_mgw_tech_pairs
        !iv_jwt_token        TYPE string
        !iv_entity_type_name TYPE /iwbep/mgw_tech_name
      EXPORTING
        !er_stream           TYPE REF TO data
      CHANGING
        !co_msg              TYPE REF TO /iwbep/if_message_container
      RAISING
        /iwbep/cx_mgw_tech_exception .
  PROTECTED SECTION.
  PRIVATE SECTION.

    CLASS-DATA gv_controller_class TYPE string VALUE `ZABSF_CL_ODATA`.
ENDCLASS.

CLASS lcl_authorization DEFINITION
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS check
      IMPORTING
        !iv_username         TYPE string
        !iv_endpoint         TYPE string
        !iv_activity         TYPE string
      RETURNING
        VALUE(rv_authorized) TYPE abap_bool .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS lcl_odata_router DEFINITION
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        !iv_path              TYPE string
        !iv_operation_type    TYPE /iwbep/sbdsp_operation_type OPTIONAL
        !it_entity_keys       TYPE /iwbep/t_mgw_tech_pairs
        !it_query_string_keys TYPE /iwbep/t_mgw_tech_pairs .
    METHODS get_endpoint
      EXPORTING
        !ev_class_name  TYPE string
        !ev_method_name TYPE string
        !et_keys        TYPE /iwbep/t_mgw_tech_pairs .
  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES:
      BEGIN OF ty_key.
        INCLUDE TYPE zsf_orouter_key.
        TYPES:  value TYPE string.
    TYPES: END OF ty_key .
    TYPES:
      tt_keys TYPE STANDARD TABLE OF ty_key WITH NON-UNIQUE DEFAULT KEY .
    TYPES:
      BEGIN OF ty_endpoint,
        keys TYPE tt_keys.
        INCLUDE TYPE zsf_orouter_end.
      TYPES: END OF ty_endpoint .
    TYPES:
      tt_endpoints TYPE STANDARD TABLE OF ty_endpoint WITH NON-UNIQUE DEFAULT KEY .

    CLASS-DATA gs_endpoint TYPE ty_endpoint .

    CLASS-METHODS copy_user_to_endpoint_keys
      IMPORTING
        !it_user_keys  TYPE /iwbep/t_mgw_tech_pairs
      CHANGING
        !ct_odata_keys TYPE tt_keys .
    CLASS-METHODS update_key_table
      IMPORTING
        !it_filled_keys TYPE tt_keys
      CHANGING
        !ct_path_keys   TYPE tt_keys .
    CLASS-METHODS check_missing_required_key
      IMPORTING
        !it_path_keys         TYPE tt_keys
      RETURNING
        VALUE(rv_missing_key) TYPE abap_bool .
    CLASS-METHODS copy_keys
      IMPORTING
        !iv_entity_value  TYPE abap_bool
        !lt_user_keys     TYPE /iwbep/t_mgw_tech_pairs
      CHANGING
        !ct_endpoint_keys TYPE tt_keys .
    CLASS-METHODS get_endpoint_keys
      IMPORTING
        !iv_endpoint        TYPE /iwbep/sbdm_node_name
        !iv_operation_type  TYPE /iwbep/sbdsp_operation_type
      RETURNING
        VALUE(rt_endpoints) TYPE tt_endpoints .
    CLASS-METHODS get_desired_endpoint
      IMPORTING
        !it_endpoints      TYPE tt_endpoints
      RETURNING
        VALUE(rs_endpoint) TYPE ty_endpoint .
ENDCLASS.

CLASS lcl_odata_utils IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_ODATA_UTILS=>COPY_USER_KEYS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_KEYS                        TYPE        /IWBEP/T_MGW_TECH_PAIRS
* | [--->] IT_PARAMS                      TYPE        TIHTTPNVP
* | [<-->] CT_USER_KEYS                   TYPE        /IWBEP/T_MGW_TECH_PAIRS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD copy_user_keys.
    FIELD-SYMBOLS <fs_user_key> TYPE /iwbep/s_mgw_tech_pair.
    DATA: ls_param TYPE ihttpnvp,
          ls_key   TYPE /iwbep/s_mgw_tech_pair.

    DATA lv_component_name TYPE string.

    LOOP AT ct_user_keys ASSIGNING <fs_user_key>.
      LOOP AT it_params INTO ls_param.
        lv_component_name = to_upper( val = ls_param-name ).
        IF lv_component_name EQ to_upper( val = <fs_user_key>-name ).
          <fs_user_key>-value = ls_param-value.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

    LOOP AT ct_user_keys ASSIGNING <fs_user_key>.
      LOOP AT it_keys INTO ls_key.
        lv_component_name = to_upper( val = ls_key-name ).
        IF lv_component_name EQ to_upper( val = <fs_user_key>-name ).
          <fs_user_key>-value = ls_key-value.
        ENDIF.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_ODATA_UTILS=>COPY_ALL_KEYS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_KEYS                        TYPE        /IWBEP/T_MGW_TECH_PAIRS
* | [--->] IT_PARAMS                      TYPE        TIHTTPNVP
* | [<-()] RT_USER_KEYS                   TYPE        /IWBEP/T_MGW_TECH_PAIRS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD copy_all_keys.
    rt_user_keys = VALUE #( FOR ls_param IN it_params ( name = to_upper( ls_param-name ) value = ls_param-value ) ).
    rt_user_keys = VALUE #( BASE rt_user_keys FOR ls_key IN it_keys ( name = to_upper( ls_key-name ) value = ls_key-value ) ).
    SORT rt_user_keys.
    DELETE ADJACENT DUPLICATES FROM rt_user_keys.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_ODATA_UTILS=>GET_HEADER
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_FACADE                      TYPE REF TO /IWBEP/IF_MGW_DP_FACADE
* | [--->] IV_HEADER_NAME                 TYPE        STRING
* | [<-()] RV_VALUE                       TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_header.
    DATA lt_headers TYPE tihttpnvp.

    lt_headers = io_facade->get_request_header( ).
    READ TABLE lt_headers INTO DATA(ls_headers) WITH KEY name = iv_header_name.

    rv_value = ls_headers-value.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_ODATA_UTILS=>GET_METHOD_NAME
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_CALLSTACK                   TYPE        I(optional)
* | [<-()] RV_METHOD_NAME                 TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
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


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_ODATA_UTILS=>GET_URL_PARAMS
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_VALUES                      TYPE        TIHTTPNVP
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_url_params.
    DATA: lo_server TYPE REF TO cl_http_server_net.
    FIELD-SYMBOLS: <server> TYPE any.
    ASSIGN ('(SAPLHTTP_RUNTIME)server_accepted') TO <server>.
    CHECK: <server> IS ASSIGNED.
    lo_server ?= <server>.
    lo_server->request->get_form_fields( CHANGING fields = rv_values ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_ODATA_UTILS=>RAISE_HTTP_ERROR
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ERROR_CODE                  TYPE        /iwbep/mgw_http_status_code
* | [<-()] EO_EXCEPTION                   TYPE REF TO /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD raise_http_error.
    " HTTP Status Code
    DATA lv_message TYPE scx_t100key.

    " Get http error status
    IF iv_error_code EQ `403`.
      lv_message = VALUE scx_t100key(
        msgid = /iwbep/cx_mgw_tech_exception=>missing_authorization-msgid
        msgno = /iwbep/cx_mgw_tech_exception=>missing_authorization-msgno
      ).
    ELSE.
      lv_message = VALUE scx_t100key(
          msgid = /iwbep/cx_mgw_tech_exception=>internal_error-msgid
          msgno = /iwbep/cx_mgw_tech_exception=>internal_error-msgno
      ).
    ENDIF.

    " Raise exception
    TRY.
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception
          EXPORTING
            http_status_code = iv_error_code
            textid           = lv_message.
      CATCH /iwbep/cx_mgw_tech_exception INTO eo_exception.
    ENDTRY.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_ODATA_UTILS=>SET_EXPANDED
* +-------------------------------------------------------------------------------------------------+
* | [--->] IR_ENTITY_CTX                  TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITY(optional)
* | [--->] IR_ENTITYSET_CTX               TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITYSET(optional)
* | [<-()] RT_EXPANDED_TECH_CLAUSES       TYPE        STRING_TABLE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_expanded.
    DATA: lo_tech_request TYPE REF TO /iwbep/cl_mgw_request.

    IF ir_entity_ctx IS NOT INITIAL.
      lo_tech_request ?= ir_entity_ctx.
    ELSE.
      lo_tech_request ?= ir_entityset_ctx.
    ENDIF.

    DATA(lv_expand) = to_upper( val = lo_tech_request->/iwbep/if_mgw_req_entityset~get_expand( ) ).
    SPLIT lv_expand AT ',' INTO TABLE rt_expanded_tech_clauses.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_ODATA_UTILS=>CHECK_CSRF_FETCH
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_ISFETCH                     TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD check_csrf_fetch.
    DATA: lo_server TYPE REF TO cl_http_server_net.
    FIELD-SYMBOLS: <server> TYPE any.
    ASSIGN ('(SAPLHTTP_RUNTIME)server_accepted') TO <server>.
    CHECK: <server> IS ASSIGNED.
    lo_server ?= <server>.
    DATA(lv_header) = lo_server->request->get_header_field( EXPORTING name = 'x-csrf-token' ).

    rv_isfetch = COND #( WHEN to_lower( lv_header ) EQ 'fetch'
                              THEN abap_true
                              ELSE abap_false ).
  ENDMETHOD.
ENDCLASS.

CLASS lcl_odata_error_logging IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_ODATA_ERROR_LOGGING=>LOG_CX_ERROR
* +-------------------------------------------------------------------------------------------------+
* | [<-->] IR_ERROR                       TYPE REF TO CX_ROOT
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD log_cx_error.
    CALL METHOD ir_error->get_source_position
      IMPORTING
        program_name = DATA(lv_method_name)
        "include_name = DATA(lv_include)
        source_line  = DATA(lv_line).

    DATA(lv_error_message) = ir_error->get_longtext( ).

    CALL METHOD log_error
      EXPORTING
        iv_sfuser     = `1` "gv_sfusername
        iv_sapuser    = sy-uname
        iv_origin     = lv_method_name && lv_line
        iv_message    = lv_error_message
        iv_error_type = 'E'.

*    lcl_odata_utils=>raise_http_error( '500' ).
    DATA(lr_http_exception) = lcl_odata_utils=>raise_http_error( '500' ).
    ro_exception = lr_http_exception.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_ODATA_ERROR_LOGGING=>LOG_BUSI_ERROR
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_MSG                         TYPE REF TO /IWBEP/IF_MESSAGE_CONTAINER
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD log_busi_error.
    DATA lt_msgs TYPE /iwbep/t_message_container.
    CALL METHOD io_msg->get_messages
      RECEIVING
        rt_messages = lt_msgs.

    CALL METHOD log_error
      EXPORTING
        "iv_sfuser     = gv_sfusername
        iv_sfuser     = `1`
        iv_sapuser    = sy-uname
        iv_origin     = lt_msgs[ 1 ]-entity_type
        iv_message    = CONV #( lt_msgs[ 1 ]-message )
        iv_error_type = lt_msgs[ 1 ]-type.

    DATA(lr_http_exception) = lcl_odata_utils=>raise_http_error( '500' ).
    eo_exception = lr_http_exception.
  ENDMETHOD.

* <signature>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_ODATA_ERROR_LOGGING=>=>LOG_ERROR
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_SFUSER                      TYPE        STRING
* | [--->] IV_SAPUSER                     TYPE        UNAME
* | [--->] IV_ORIGIN                      TYPE        STRING
* | [--->] IV_MESSAGE                     TYPE        STRING
* | [--->] IV_ERROR_TYPE                  TYPE        CHAR1 (default ='E')
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD log_error.
    DATA(lo_logger) = /iwfnd/cl_logger=>init_logger( iv_userid = sy-uname
                                                 iv_object = 'ZABSF'
                                                 iv_subobject = 'LOGS' ).

    DATA lv_agent TYPE /iwbep/sup_iw_agent VALUE 'ODATA'.

    DATA(lv_sfuser) = |{ `Shopfloor User:` } { iv_sfuser }|.
    DATA(lv_sapuser) = |{ `SAP User:` } { iv_sapuser }|.
    DATA(lv_origin) = |{ `Origin:` } { iv_origin }|.

    lo_logger->log_message( iv_msg_type = iv_error_type
                        iv_msg_text = CONV /iwfnd/sup_msg_longtext( lv_sfuser )
                        iv_agent = lv_agent ).

    lo_logger->log_message( iv_msg_type = iv_error_type
                            iv_msg_text = CONV /iwfnd/sup_msg_longtext( lv_sapuser )
                            iv_agent = lv_agent ).

    lo_logger->log_message( iv_msg_type = iv_error_type
                            iv_msg_text = CONV /iwfnd/sup_msg_longtext( lv_origin )
                            iv_agent = lv_agent ).

    lo_logger->log_message( iv_msg_type = iv_error_type
                            iv_msg_text = CONV /iwfnd/sup_msg_longtext( `Message(s):` )
                            iv_agent = lv_agent ).

    DATA lt_messages TYPE trtexts.

    IF strlen( iv_message ) GT 250.
      CALL FUNCTION 'TR_SPLIT_TEXT'
        EXPORTING
          iv_text  = iv_message
          iv_len   = 250
        IMPORTING
          et_lines = lt_messages.
    ELSE.
      lt_messages = VALUE #( ( CONV trtext( iv_message ) ) ).
    ENDIF.

    LOOP AT lt_messages ASSIGNING FIELD-SYMBOL(<fs_message>).
      lo_logger->log_message( iv_msg_type = iv_error_type
                            iv_msg_text = CONV /iwfnd/sup_msg_longtext( <fs_message> )
                            iv_agent = lv_agent ).
    ENDLOOP.

    lo_logger->close_logger( ).
  ENDMETHOD.
ENDCLASS.

CLASS lcl_odata_routing IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_ODATA_ROUTING=>HANDLE_CREATE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_INPUTOBJ                    TYPE        ZABSF_PP_S_INPUTOBJECT
* | [--->] IV_JWT_TOKEN                   TYPE        STRING
* | [--->] IV_ENTITY_TYPE_NAME            TYPE        /IWBEP/MGW_TECH_NAME
* | [--->] IO_DATA_PROVIDER               TYPE REF TO /IWBEP/IF_MGW_ENTRY_PROVIDER
* | [<---] ER_ENTITY                      TYPE REF TO DATA
* | [<-->] CO_MSG                         TYPE REF TO /IWBEP/IF_MESSAGE_CONTAINER
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD handle_create.
    DATA: lt_params TYPE tihttpnvp,
          lv_method TYPE c LENGTH 29,
          lt_keys   TYPE /iwbep/t_mgw_tech_pairs.

    lt_params = lcl_odata_utils=>get_url_params( ).

    lv_method = COND #( WHEN strlen( iv_entity_type_name ) GT 25
                             THEN substring( val = iv_entity_type_name len = 25 )
                             ELSE iv_entity_type_name ).
    lv_method = |{ 'CRE_' }{ lv_method }|.

    lt_keys = lcl_odata_utils=>copy_all_keys( it_keys = lt_keys it_params = lt_params ).

    TRY.
        CALL METHOD (gv_controller_class)=>(lv_method)
          EXPORTING
            is_inputobj      = is_inputobj
            it_keys          = lt_keys
            iv_jwt_token     = iv_jwt_token
            io_data_provider = io_data_provider
          IMPORTING
            er_entity        = er_entity
          CHANGING
            co_msg           = co_msg.
      CATCH /iwbep/cx_mgw_busi_exception INTO DATA(lr_busi_error).
        DATA(eo_busi) = lcl_odata_error_logging=>log_busi_error( co_msg ).
        RAISE EXCEPTION eo_busi.
      CATCH cx_root INTO DATA(lr_root_error).
        lcl_odata_error_logging=>log_cx_error( lr_root_error ).
    ENDTRY.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_ODATA_ROUTING=>HANDLE_DELETE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_INPUTOBJ                    TYPE        ZABSF_PP_S_INPUTOBJECT
* | [--->] IT_KEYS                        TYPE        /IWBEP/T_MGW_TECH_PAIRS
* | [--->] IV_JWT_TOKEN                   TYPE        STRING
* | [--->] IV_ENTITY_TYPE_NAME            TYPE        /IWBEP/MGW_TECH_NAME
* | [<-->] CO_MSG                         TYPE REF TO /IWBEP/IF_MESSAGE_CONTAINER
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD handle_delete.
    DATA: lt_params TYPE tihttpnvp,
          lv_method TYPE c LENGTH 29,
          lt_keys   TYPE /iwbep/t_mgw_tech_pairs.

    lt_params = lcl_odata_utils=>get_url_params( ).

    lv_method = COND #( WHEN strlen( iv_entity_type_name ) GT 25
                             THEN substring( val = iv_entity_type_name len = 25 )
                             ELSE iv_entity_type_name ).
    lv_method = |{ 'DEL_' }{ lv_method }|.

    lt_keys = lcl_odata_utils=>copy_all_keys( it_keys = it_keys it_params = lt_params ).

    TRY.
        CALL METHOD (gv_controller_class)=>(lv_method)
          EXPORTING
            is_inputobj  = is_inputobj
            it_keys      = lt_keys
            iv_jwt_token = iv_jwt_token
          CHANGING
            co_msg       = co_msg.
      CATCH /iwbep/cx_mgw_busi_exception INTO DATA(lr_busi_error).
        DATA(eo_busi) = lcl_odata_error_logging=>log_busi_error( co_msg ).
        RAISE EXCEPTION eo_busi.
      CATCH cx_root INTO DATA(lr_root_error).
        lcl_odata_error_logging=>log_cx_error( lr_root_error ).
    ENDTRY.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_ODATA_ROUTING=>HANDLE_GET
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_INPUTOBJ                    TYPE        ZABSF_PP_S_INPUTOBJECT
* | [--->] IT_KEYS                        TYPE        /IWBEP/T_MGW_TECH_PAIRS
* | [--->] IV_JWT_TOKEN                   TYPE        STRING
* | [--->] IV_ENTITY_TYPE_NAME            TYPE        /IWBEP/MGW_TECH_NAME
* | [<---] ER_ENTITY                      TYPE REF TO DATA
* | [<-->] CO_MSG                         TYPE REF TO /IWBEP/IF_MESSAGE_CONTAINER
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD handle_get.
    DATA: lt_params TYPE tihttpnvp,
          lv_method TYPE c LENGTH 29,
          lt_keys   TYPE /iwbep/t_mgw_tech_pairs.

    lt_params = lcl_odata_utils=>get_url_params( ).

    lv_method = COND #( WHEN strlen( iv_entity_type_name ) GT 25
                             THEN substring( val = iv_entity_type_name len = 25 )
                             ELSE iv_entity_type_name ).
    lv_method = |{ 'GET_' }{ lv_method }|.

    CASE iv_entity_type_name.
      WHEN 'OPERATIONCONSUMPTIONHISTORYINFORMATION'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'WORKCENTERID' )
                                                 ( name = 'PRODUCTIONORDERID' )
                                                 ( name = 'OPERATIONID' )
                                                 ( name = 'MATERIALID' ) ).

      WHEN 'STOCKREPORTCENTER'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'PROJECT' )
                                                 ( name = 'SCHEMATIC' )
                                                 ( name = 'PF' )
                                                 ( name = 'MATERIAL' )
                                                 ( name = 'FILTERPAS' )
                                                 ( name = 'FILTERSAS' ) ).

      WHEN 'TIMEREPORTCENTER'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'WORKCENTER' )
                                                 ( name = 'PROJECT' )
                                                 ( name = 'SCHEMATIC' )
                                                 ( name = 'MATERIAL' )
                                                 ( name = 'FILTERPAS' )
                                                 ( name = 'FILTERSAS' )
                                                 ( name = 'ORDERID' ) ).

      WHEN 'WORKCENTER'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'SHIFTID' )
                                                 ( name = 'HIERARCHYID' )
                                                 ( name = 'WORKCENTERID' )
                                                 ( name = 'OPERATIONID' )
                                                 ( name = 'PRODUCTIONORDERID' )
                                                 ( name = 'CURRENTTIME' )
                                                 ( name = 'CURRENTDAY' )
                                                 ( name = 'HEADERONLY' ) ).

      WHEN 'WORKCENTEROEE'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'SHIFTID' )
                                                 ( name = 'HIERARCHYID' )
                                                 ( name = 'SELECTEDHIERARCHIES' ) ).

      WHEN 'OPERATIONCONSUMPTIONDEVOLUTION'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'WORKCENTERID' )
                                                 ( name = 'PRODUCTIONORDERID' )
                                                 ( name = 'OPERATIONID' ) ).

      WHEN 'OPERATIONCONSUMPTION'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'WORKCENTERID' )
                                                 ( name = 'PRODUCTIONORDERID' )
                                                 ( name = 'OPERATIONID' )
                                                 ( name = 'PALLETORDERID' )
                                                 ( name = 'DEVOLUTION' ) ).

      WHEN 'OPERATION'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'WORKCENTERID' ) ).

      WHEN 'WORKCENTERPOSITION'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'WORKCENTERID' ) ).

      WHEN 'STOPREASON'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'WORKCENTERID' ) ).

      WHEN 'SHIFT'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'SHIFTID' ) ).

      WHEN 'AUTHORIZATIONPROFILEOFROLE'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'AUTHORIZATIONROLEID' )
                                                 ( name = 'AUTHORIZATIONPROFILEID' ) ).

      WHEN 'AUTHORIZATIONPROFILE'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'AUTHORIZATIONPROFILEID' ) ).

      WHEN 'AUTHORIZATIONROLE'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'AUTHORIZATIONROLEID' ) ).

      WHEN 'AUTHORIZATIONACTIVITYOFOBJECT'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'AUTHORIZATIONPROFILEID' )
                                                 ( name = 'AUTHORIZATIONOBJECTID' )
                                                 ( name = 'AUTHORIZATIONACTIVITYTYPEID' ) ).
      WHEN 'USERSAP'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'USERSAP' ) ).

      WHEN 'USER'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'USERNAME' ) ).


      WHEN 'ADMTREEHIERARCHY'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'AREAID' )
                                                 ( name = 'CENTERID' ) ).
      WHEN 'REPORTPOINTPASSAGE'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'HNAME' )
                                                 ( name = 'RPOINT' )
                                                 ( name = 'MATNR' )
                                                 ( name = 'GERNR' )
                                                 ( name = 'REFDT' ) ).
      WHEN 'LABEL'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'MATERIAL' )
                                                 ( name = 'ORDER' )
                                                 ( name = 'OPERATION' )
                                                 ( name = 'WORKCENTER' )
                                                 ( name = 'TYPE' )
                                                 ( name = 'QTYPARC' ) ).
      WHEN 'MOVIMENTSLABEL'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'MATERIALID' )
                                                 ( name = 'MATERIALDESC' )
                                                 ( name = 'BATCH' )
                                                 ( name = 'SOURCELGORT' )
                                                 ( name = 'DESTINATIONLGORT' ) ).
      WHEN 'WORKCENTEROPERATION'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'OPERATIONID' )
                                                 ( name = 'PRODUCTIONORDERID' ) ).
      WHEN 'DASHBOARD1'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'REFDT' ) ).

      WHEN 'DASHBOARD2'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'REFDT' ) ).

      WHEN 'FORM'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'MATERIALID' )
                                                 ( name = 'OPERATIONID' ) ).
    ENDCASE.

    CALL METHOD lcl_odata_utils=>copy_user_keys
      EXPORTING
        it_keys      = it_keys
        it_params    = lt_params
      CHANGING
        ct_user_keys = lt_keys.

    TRY.
        CALL METHOD (gv_controller_class)=>(lv_method)
          EXPORTING
            is_inputobj  = is_inputobj
            it_keys      = lt_keys
            iv_jwt_token = iv_jwt_token
          IMPORTING
            er_entity    = er_entity
          CHANGING
            co_msg       = co_msg.
      CATCH /iwbep/cx_mgw_busi_exception INTO DATA(lr_busi_error).
        DATA(eo_busi) = lcl_odata_error_logging=>log_busi_error( co_msg ).
        RAISE EXCEPTION eo_busi.
      CATCH cx_root INTO DATA(lr_root_error).
        lcl_odata_error_logging=>log_cx_error( lr_root_error ).
    ENDTRY.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_ODATA_ROUTING=>HANDLE_GET_SET
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_INPUTOBJ                    TYPE        ZABSF_PP_S_INPUTOBJECT
* | [--->] IT_KEYS                        TYPE        /IWBEP/T_MGW_TECH_PAIRS
* | [--->] IV_JWT_TOKEN                   TYPE        STRING
* | [--->] IV_ENTITY_TYPE_NAME            TYPE        /IWBEP/MGW_TECH_NAME
* | [<---] ER_ENTITYSET                   TYPE REF TO DATA
* | [<-->] CO_MSG                         TYPE REF TO /IWBEP/IF_MESSAGE_CONTAINER
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD handle_get_set.
    DATA: lt_params          TYPE tihttpnvp,
          lv_method          TYPE c LENGTH 30,
          lt_keys            TYPE /iwbep/t_mgw_tech_pairs,
          lv_method_override TYPE c LENGTH 30.

    lt_params = lcl_odata_utils=>get_url_params( ).

    lv_method = COND #( WHEN strlen( iv_entity_type_name ) GT 25
                             THEN substring( val = iv_entity_type_name len = 25 )
                             ELSE iv_entity_type_name ).
    lv_method = |{ 'GET_' }{ lv_method }{ 'S' }|.

    CASE iv_entity_type_name.
      WHEN 'HIERARCHY'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'HIERARCHYID' )
                                                 ( name = 'SHIFTID' ) ).
      WHEN 'OPERATIONCONSUMPTIONHISTORYINFORMATION'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'WORKCENTERID' )
                                                 ( name = 'PRODUCTIONORDERID' )
                                                 ( name = 'OPERATIONID' )
                                                 ( name = 'MATERIALID' ) ).
      WHEN 'WORKCENTER'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'SHIFTID' )
                                                 ( name = 'HIERARCHYID' )
                                                 ( name = 'WORKCENTERID' )
                                                 ( name = 'OPERATIONID' )
                                                 ( name = 'PRODUCTIONORDERID' )
                                                 ( name = 'CURRENTTIME' )
                                                 ( name = 'CURRENTDAY' )
                                                 ( name = 'HEADERONLY' ) ).
      WHEN 'OPERATIONCONSUMPTION'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'WORKCENTERID' )
                                                 ( name = 'PRODUCTIONORDERID' )
                                                 ( name = 'OPERATIONID' )
                                                 ( name = 'PALLETORDERID' )
                                                 ( name = 'DEVOLUTION' ) ).
      WHEN 'SHIFT'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'GETALL' )
                                                 ( name = 'STARTDAY' )
                                                 ( name = 'STARTHOUR' ) ).
      WHEN 'USERAREA'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'CENTERID' )
                                                 ( name = 'AREAID' ) ).
      WHEN 'STOPREASON'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'WORKCENTERID' ) ).
      WHEN 'WORKCENTEROEE'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'SHIFTIDID' )
                                                 ( name = 'HIERARCHYID' )
                                                 ( name = 'SELECTEDHIERARCHIES' ) ).
      WHEN 'OPERATIONSTOPREASON'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'WORKCENTERID' ) ).
      WHEN 'OPERATION'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'WORKCENTERID' ) ).
      WHEN 'AUTHORIZATIONPROFILESOFROLE'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'AUTHORIZATIONROLEID' )
                                                 ( name = 'AUTHORIZATIONPROFILEID' ) ).
      WHEN 'AUTHORIZATIONPROFILE'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'AUTHORIZATIONPROFILEID' ) ).
      WHEN 'AUTHORIZATIONROLE'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'AUTHORIZATIONROLEID' ) ).
      WHEN 'AUTHORIZATIONACTIVITYOFOBJECT'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'AUTHORIZATIONPROFILEID' )
                                                 ( name = 'AUTHORIZATIONOBJECTID' )
                                                 ( name = 'AUTHORIZATIONACTIVITYTYPEID' ) ).
      WHEN 'TREEHIERARCHY'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'CENTERID' ) ).
      WHEN 'ADMTREEHIERARCHY'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'AREAID' )
                                                 ( name = 'CENTERID' ) ).
      WHEN 'USERLANGUAGE'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'CENTERID' ) ).
      WHEN 'USERSAP'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'USERID' ) ).
      WHEN 'WORKCENTERPOSITION'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'WORKCENTERID' ) ).
      WHEN 'REPORTPOINT'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'HNAME' )
                                                 ( name = 'RPOINT' )
                                                 ( name = 'REFDT' ) ).
      WHEN 'REPORTPOINTCOMPONENT'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'MATNR' )
                                                 ( name = 'VORNR' )
                                                 ( name = 'LMNGA' )
                                                 ( name = 'MEINS' )
                                                 ( name = 'REFDT' ) ).
      WHEN 'REPORTPOINTDEFECT'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'RPOINT' )
                                                 ( name = 'REFDT' )
                                                 ( name = 'REASONTYPE' ) ).
      WHEN 'MATERIALBATCH'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'MATERIAL' )
                                                 ( name = 'PLANT' ) ).
      WHEN 'STOCKREPORTCENTER'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'MATERIAL' )
                                                 ( name = 'PLANT' )
                                                 ( name = 'DEPOSIT' )
                                                 ( name = 'LGPBE' ) ).
      WHEN 'DEPOSITSAREA'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'AREA' ) ).

      WHEN 'MATERIALSERIAL'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'MATERIAL' )
                                                 ( name = 'PLANT' )
                                                 ( name = 'ORDER' ) ).
      WHEN 'EQUIPMENT'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'WORKCENTERID' ) ).
      WHEN 'ORDEROPERATION'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'ORDER' ) ).
      WHEN 'OPERATIONALERT'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'MATERIALID' )
                                                 ( name = 'MATERIALDESC' )
                                                 ( name = 'OPERATION' )
                                                 ( name = 'ALERTDESC' )
                                                 ( name = 'FLAG' ) ).
      WHEN 'DEFECT'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'WORKCENTERID' ) ).

      WHEN 'OPERATIONNUMBER'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'MATNR' )
                                                 ( name = 'WERKS' ) ).

      WHEN 'MATERIAL'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'CENTER' )
                                                 ( name = 'MATERIALID' )
                                                 ( name = 'MATERIALDESC' ) ).
      WHEN 'DEPOSITSPOSITION'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'AREA' )
                                                 ( name = 'PLANT' )
                                                 ( name = 'LGORT' ) ).

      WHEN 'DASHBOARD1'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'REFDT' )
                                                 ( name = 'HIERARCHYID' )
                                                 ( name = 'WORKCENTERID' ) ).

      WHEN 'DASHBOARD2'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'REFDT' )
                                                 ( name = 'HIERARCHYID' )
                                                 ( name = 'WORKCENTERID' ) ).

      WHEN 'DASHBOARDCOLORS'.
*        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'REFDT' ) ).

      WHEN 'WORKCENTERSAREA'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'AREAID' ) ).

      WHEN 'AREA'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'AREAID' ) ).

      WHEN 'DEPOSITSPLANT'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'WERKS' ) ).

      WHEN 'AUTHOBJPRO'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'PROFILEID' )
                                                 ( name = 'AUTHOBJECTID' ) ).

        WHEN 'CONFIRMEDSTOCK'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'TEST' ) ).

    ENDCASE.

    CALL METHOD lcl_odata_utils=>copy_user_keys
      EXPORTING
        it_keys      = it_keys
        it_params    = lt_params
      CHANGING
        ct_user_keys = lt_keys.

    " Custom paths
    CASE iv_entity_type_name.
      WHEN 'WORKCENTER'.
        lv_method_override = COND #( WHEN lt_keys[ name = 'SHIFTID' ]-value IS NOT INITIAL AND
                                          lt_keys[ name = 'HIERARCHYID' ]-value IS NOT INITIAL AND
                                          lt_keys[ name = 'WORKCENTERID' ]-value IS NOT INITIAL AND
                                          lt_keys[ name = 'CURRENTTIME' ]-value IS NOT INITIAL AND
                                          lt_keys[ name = 'CURRENTDAY' ]-value IS NOT INITIAL AND
                                          lt_keys[ name = 'HEADERONLY' ]-value IS NOT INITIAL
                                     THEN 'GET_GETWORKCENTERS_1'
                                     WHEN lt_keys[ name = 'SHIFTID' ]-value IS NOT INITIAL AND
                                          lt_keys[ name = 'HIERARCHYID' ]-value IS NOT INITIAL
                                     THEN 'GET_GETWORKCENTERS_2' ).
        WHEN 'CONFIRMEDSTOCK'.
          lv_method_override = COND #( WHEN lt_keys[ name = 'TEST' ]-value EQ 'AON' THEN 'GET_CONFIRMEDSTOCKS_AON' ).
    ENDCASE.

    lv_method = COND #( WHEN lv_method_override IS INITIAL
                        THEN lv_method
                        ELSE lv_method_override ).

    TRY.
        CALL METHOD (gv_controller_class)=>(lv_method)
          EXPORTING
            is_inputobj   = is_inputobj
            it_keys       = lt_keys
            iv_jwt_token  = iv_jwt_token
          IMPORTING
            er_entity_set = er_entityset
          CHANGING
            co_msg        = co_msg.
      CATCH /iwbep/cx_mgw_busi_exception INTO DATA(lr_busi_error).
        DATA(eo_busi) = lcl_odata_error_logging=>log_busi_error( co_msg ).
        RAISE EXCEPTION eo_busi.
      CATCH cx_root INTO DATA(lr_root_error).
        lcl_odata_error_logging=>log_cx_error( lr_root_error ).
    ENDTRY.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_ODATA_ROUTING=>HANDLE_UPDATE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_INPUTOBJ                    TYPE        ZABSF_PP_S_INPUTOBJECT
* | [--->] IT_KEYS                        TYPE        /IWBEP/T_MGW_TECH_PAIRS
* | [--->] IV_JWT_TOKEN                   TYPE        STRING
* | [--->] IV_ENTITY_TYPE_NAME            TYPE        /IWBEP/MGW_TECH_NAME
* | [--->] IO_DATA_PROVIDER               TYPE REF TO /IWBEP/IF_MGW_ENTRY_PROVIDER
* | [<---] ER_ENTITY                      TYPE REF TO DATA
* | [<-->] CO_MSG                         TYPE REF TO /IWBEP/IF_MESSAGE_CONTAINER
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD handle_update.
    DATA: lt_params TYPE tihttpnvp,
          lv_method TYPE c LENGTH 29,
          lt_keys   TYPE /iwbep/t_mgw_tech_pairs.

    lt_params = lcl_odata_utils=>get_url_params( ).

    lv_method = COND #( WHEN strlen( iv_entity_type_name ) GT 25
                             THEN substring( val = iv_entity_type_name len = 25 )
                             ELSE iv_entity_type_name ).
    lv_method = |{ 'UPD_' }{ lv_method }|.

    CASE iv_entity_type_name.
      WHEN 'OPERATIONCONSUMPTION'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'PRODUCTIONORDERID' )
                                                 ( name = 'MATERIALID' )
                                                 ( name = 'OPERATIONCONSUMPTIONTYPE' )
                                                 ( name = 'RESERVENUMBER' )
                                                 ( name = 'RESERVEITEM' )
                                                 ( name = 'BATCHID' )
                                                 ( name = 'UNITID' )
                                                 ( name = 'MATERIALDESCRIPTION' )
                                                 ( name = 'ILGORT' ) ).

      WHEN 'WORKCENTER'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'SHIFTID' )
                                                 ( name = 'HIERARCHYID' ) ).

      WHEN 'USER'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'USERNAME' ) ).

      WHEN 'SHIFT'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'SHIFTID' ) ).

      WHEN 'USERSAP'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'USERSAP' ) ).

      WHEN 'OPERATION'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'ID' )
                                                 ( name = 'PRODUCTIONORDERID' )
                                                 ( name = 'HIERARCHYID' )
                                                 ( name = 'WORKCENTERID' )
                                                 ( name = 'OFFLINEVERSION' )
                                                 ( name = 'SHIFTID' ) ).

      WHEN 'OPERATIONREWORK'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'ID' )
                                                 ( name = 'PRODUCTIONORDERID' )
                                                 ( name = 'HIERARCHYID' )
                                                 ( name = 'WORKCENTERID' )
                                                 ( name = 'OFFLINEVERSION' )
                                                 ( name = 'SHIFTID' )
                                                 ( name = 'DEFECTID' ) ).

      WHEN 'AUTHORIZATIONACTIVITYOFOBJECT'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'AUTHORIZATIONPROFILEID' )
                                                 ( name = 'AUTHORIZATIONOBJECTID' )
                                                 ( name = 'AUTHORIZATIONACTIVITYTYPEID' ) ).

      WHEN 'OPERATIONOPERATOR'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'OPERATIONID' )
                                                 ( name = 'PRODUCTIONORDERID' )
                                                 ( name = 'WORKCENTERID' )
                                                 ( name = 'OPERATORID' )
                                                 ( name = 'SHIFTID' ) ).

      WHEN 'SCRAPMISSING'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'ID' )
                                                 ( name = 'OPERATIONID' )
                                                 ( name = 'PRODUCTIONORDERID' )
                                                 ( name = 'HIERARCHYID' )
                                                 ( name = 'WORKCENTERID' )
                                                 ( name = 'OFFLINEVERSION' )
                                                 ( name = 'MATERIAL' )
                                                 ( name = 'UNIT' )
                                                 ( name = 'SHIFTID' ) ).
      WHEN 'REPORTPOINTOPERATION'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'RPOINT' )
                                                 ( name = 'MATNR' )
                                                 ( name = 'VORNR' ) ).
      WHEN 'REPORTPOINTSETOPERATOR'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'RPOINT' )
                                                 ( name = 'TIME' )
                                                 ( name = 'REFDT' )
                                                 ( name = 'VORNR' )
                                                 ( name = 'SHIFTID' ) ).
      WHEN 'REPORTPOINTGOODSMVT'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'MATNR' )
                                                 ( name = 'VORNE' )
                                                 ( name = 'REFDT' )
                                                 ( name = 'SHIFTID' ) ).
      WHEN 'REPORTPOINTQUALITY'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'RPOINT' )
                                                 ( name = 'MATNR' )
                                                 ( name = 'REFDT' ) ).
      WHEN 'REPORTPOINTPASSAGE'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'HNAME' )
                                                 ( name = 'RPOINT' )
                                                 ( name = 'MATNR' )
                                                 ( name = 'GERNR' )
                                                 ( name = 'REFDT' ) ).
      WHEN 'ADDITIONALTIME'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'ORDERNUMBER' )
                                                 ( name = 'OPERATION' )
                                                 ( name = 'WORKCENTER' )
                                                 ( name = 'SHIFTID' )
                                                 ( name = 'OPERATORID' )
                                                 ( name = 'BEGINTIMESTAMP' )
                                                 ( name = 'ENDTIMESTAMP' )
                                                 ( name = 'QUANTITY' )
                                                 ( name = 'UNIT' ) ).
      WHEN 'OPERATIONALERT'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'MATERIALID' )
                                                 ( name = 'OPERATION' )
                                                 ( name = 'ALERTID' ) ).
      WHEN 'EQUIPMENT'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'WORKCENTERID' )
                                                 ( name = 'EQUIPMENTID' ) ).
      WHEN 'WORKDAY'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'REFDT' ) ).

    ENDCASE.

    CALL METHOD lcl_odata_utils=>copy_user_keys
      EXPORTING
        it_keys      = it_keys
        it_params    = lt_params
      CHANGING
        ct_user_keys = lt_keys.

    TRY.
        CALL METHOD (gv_controller_class)=>(lv_method)
          EXPORTING
            is_inputobj      = is_inputobj
            it_keys          = lt_keys
            iv_jwt_token     = iv_jwt_token
            io_data_provider = io_data_provider
          IMPORTING
            er_entity        = er_entity
          CHANGING
            co_msg           = co_msg.
      CATCH /iwbep/cx_mgw_busi_exception INTO DATA(lr_busi_error).
        DATA(eo_busi) = lcl_odata_error_logging=>log_busi_error( co_msg ).
        RAISE EXCEPTION eo_busi.
      CATCH cx_root INTO DATA(lr_root_error).
*        lcl_odata_error_logging=>log_cx_error( lr_root_error ).
        DATA(ro_tech) = lcl_odata_error_logging=>log_cx_error( lr_root_error ).
        RAISE EXCEPTION ro_tech.
    ENDTRY.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_ODATA_ROUTING=>HANDLE_GET_STREAM
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_INPUTOBJ                    TYPE        ZABSF_PP_S_INPUTOBJECT
* | [--->] IT_KEYS                        TYPE        /IWBEP/T_MGW_TECH_PAIRS
* | [--->] IV_JWT_TOKEN                   TYPE        STRING
* | [--->] IV_ENTITY_TYPE_NAME            TYPE        /IWBEP/MGW_TECH_NAME
* | [<---] ER_STREAM                      TYPE REF TO DATA
* | [<-->] CO_MSG                         TYPE REF TO /IWBEP/IF_MESSAGE_CONTAINER
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD handle_get_stream.
    DATA: lt_params          TYPE tihttpnvp,
          lv_method          TYPE c LENGTH 30,
          lt_keys            TYPE /iwbep/t_mgw_tech_pairs,
          lv_method_override TYPE c LENGTH 30.

    lt_params = lcl_odata_utils=>get_url_params( ).

    lv_method = COND #( WHEN strlen( iv_entity_type_name ) GT 25
                             THEN substring( val = iv_entity_type_name len = 25 )
                             ELSE iv_entity_type_name ).
    lv_method = |{ 'GST_' }{ lv_method }|.

    CASE iv_entity_type_name.
      WHEN 'GETFORM'.
        lt_keys = VALUE /iwbep/t_mgw_tech_pairs( ( name = 'MATERIALID' )
                                                 ( name = 'OPERATIONID' ) ).
    ENDCASE.

    CALL METHOD lcl_odata_utils=>copy_user_keys
      EXPORTING
        it_keys      = it_keys
        it_params    = lt_params
      CHANGING
        ct_user_keys = lt_keys.

    lv_method = COND #( WHEN lv_method_override IS INITIAL
                        THEN lv_method
                        ELSE lv_method_override ).

    TRY.
        CALL METHOD (gv_controller_class)=>(lv_method)
          EXPORTING
            is_inputobj  = is_inputobj
            it_keys      = lt_keys
            iv_jwt_token = iv_jwt_token
          IMPORTING
            er_stream    = er_stream
          CHANGING
            co_msg       = co_msg.
      CATCH /iwbep/cx_mgw_busi_exception INTO DATA(lr_busi_error).
        DATA(eo_busi) = lcl_odata_error_logging=>log_busi_error( co_msg ).
        RAISE EXCEPTION eo_busi.
      CATCH cx_root INTO DATA(lr_root_error).
        lcl_odata_error_logging=>log_cx_error( lr_root_error ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_authorization IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method LCL_AUTHORIZATION=>CHECK
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_USERNAME                    TYPE        STRING
* | [--->] IV_ENDPOINT                    TYPE        STRING
* | [--->] IV_ACTIVITY                    TYPE        STRING
* | [<---] RV_AUTHORIZED                  TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD check.
    DATA: lv_username TYPE string,
          lv_endpoint TYPE string,
          lv_authobj  TYPE string,
          lv_activity TYPE string.

    lv_username = to_upper( val = iv_username ).
    lv_endpoint = to_upper( val = iv_endpoint ).

    SELECT d~description AS desc
          FROM zsf_authroleuser AS a
          LEFT JOIN zsf_authprofrole AS b
            ON a~roleid = b~roleid
          LEFT JOIN zsf_authactobj AS c
            ON b~profileid = c~profileid
          LEFT JOIN zsf_authact AS d
            ON c~activitytypeid = d~id
          INNER JOIN zsf_permissions AS e
            ON c~objectid = e~authobj
          INTO TABLE @DATA(lt_authorizations)
          WHERE a~username = @lv_username
          AND c~checked = @abap_true
          AND e~endpoint = @lv_endpoint.

    rv_authorized = REDUCE #( INIT val TYPE string
                              FOR wa IN lt_authorizations
                              WHERE ( desc CS to_upper( lv_activity ) )
                              NEXT val = abap_true ).
  ENDMETHOD.
ENDCLASS.

CLASS lcl_odata_router IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method LCL_ODATA_ROUTER=>CHECK_MISSING_REQUIRED_KEY
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_PATH_KEYS                   TYPE        TT_KEYS
* | [<-()] RV_MISSING_KEY                 TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD check_missing_required_key.
    READ TABLE it_path_keys TRANSPORTING NO FIELDS WITH KEY required = abap_true value = ''.
    rv_missing_key = COND #( WHEN sy-subrc EQ 0
                             THEN abap_true
                             ELSE abap_false ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method LCL_ODATA_ROUTER->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_PATH                        TYPE        STRING
* | [--->] IV_OPERATION_TYPE              TYPE        /IWBEP/SBDSP_OPERATION_TYPE(optional)
* | [--->] IT_ENTITY_KEYS                 TYPE        /IWBEP/T_MGW_TECH_PAIRS
* | [--->] IT_QUERY_STRING_KEYS           TYPE        /IWBEP/T_MGW_TECH_PAIRS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD constructor.
    " Gets all posible paths and their respective keys
*    DATA(lt_endpoints) = get_path_keys( iv_path ).
    DATA(lt_endpoints) = get_endpoint_keys( EXPORTING iv_endpoint = CONV /iwbep/sbdm_node_name( iv_path )
                                                      iv_operation_type = iv_operation_type ).

    DATA lv_missing_key TYPE abap_bool VALUE abap_false.

    " Loop through them
    LOOP AT lt_endpoints ASSIGNING FIELD-SYMBOL(<fs_endpoint>).
      DATA(lt_all_keys) = it_entity_keys.
      APPEND LINES OF it_query_string_keys TO lt_all_keys.

      " Copy the user submitted keys and update the path keys with the new values
      CALL METHOD lcl_odata_router=>copy_keys
        EXPORTING
          iv_entity_value  = abap_undefined
          lt_user_keys     = lt_all_keys
        CHANGING
          ct_endpoint_keys = <fs_endpoint>-keys.

      CALL METHOD lcl_odata_router=>copy_keys
        EXPORTING
          iv_entity_value  = abap_false
          lt_user_keys     = it_query_string_keys
        CHANGING
          ct_endpoint_keys = <fs_endpoint>-keys.

      CALL METHOD lcl_odata_router=>copy_keys
        EXPORTING
          iv_entity_value  = abap_true
          lt_user_keys     = it_entity_keys
        CHANGING
          ct_endpoint_keys = <fs_endpoint>-keys.

      " Check for missing required keys
      lv_missing_key = lcl_odata_router=>check_missing_required_key( <fs_endpoint>-keys ).
      IF lv_missing_key EQ abap_true.
        DELETE lt_endpoints INDEX sy-tabix.
      ENDIF.
    ENDLOOP.

    " Get the endpoint with the most filled keys
    gs_endpoint = lcl_odata_router=>get_desired_endpoint( lt_endpoints ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method LCL_ODATA_ROUTER=>COPY_KEYS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ENTITY_VALUE                TYPE        ABAP_BOOL
* | [--->] LT_USER_KEYS                   TYPE        /IWBEP/T_MGW_TECH_PAIRS
* | [<-->] CT_ENDPOINT_KEYS               TYPE        TT_KEYS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD copy_keys.
    " Filter to get only the desired keys
    DATA(lt_filtered_keys) = VALUE tt_keys(
                   FOR ls_key IN ct_endpoint_keys WHERE ( entity_key EQ iv_entity_value )
                   (  ls_key ) ).

    " Copy keys to our filtered key table
    CALL METHOD lcl_odata_router=>copy_user_to_endpoint_keys
      EXPORTING
        it_user_keys  = lt_user_keys
      CHANGING
        ct_odata_keys = lt_filtered_keys.

    " Update the path keys table with the new key values
    CALL METHOD lcl_odata_router=>update_key_table
      EXPORTING
        it_filled_keys = lt_filtered_keys
      CHANGING
        ct_path_keys   = ct_endpoint_keys.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method LCL_ODATA_ROUTER=>COPY_USER_TO_ENDPOINT_KEYS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_USER_KEYS                   TYPE        /IWBEP/T_MGW_TECH_PAIRS
* | [<-->] CT_ODATA_KEYS                  TYPE        TT_KEYS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD copy_user_to_endpoint_keys.
    LOOP AT ct_odata_keys ASSIGNING FIELD-SYMBOL(<fs_odata_key>).
      LOOP AT it_user_keys INTO DATA(ls_user_key).
        IF to_upper( val = <fs_odata_key>-name ) EQ to_upper( val = ls_user_key-name ).
          <fs_odata_key>-value = ls_user_key-value.
        ENDIF.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method LCL_ODATA_ROUTER->GET_ENDPOINT
* +-------------------------------------------------------------------------------------------------+
* | [<---] EV_CLASS_NAME                  TYPE        STRING
* | [<---] EV_METHOD_NAME                 TYPE        STRING
* | [<---] ET_KEYS                        TYPE        /IWBEP/T_MGW_TECH_PAIRS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_endpoint.
    ev_class_name = gs_endpoint-class_name.
    ev_method_name = gs_endpoint-method_name.
    et_keys = VALUE /iwbep/t_mgw_tech_pairs( FOR ls_key IN gs_endpoint-keys ( name = ls_key-name
                                                                              value = ls_key-value ) ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method LCL_ODATA_ROUTER=>GET_DESIRED_ENDPOINT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_ENDPOINTS                   TYPE        TT_ENDPOINTS
* | [<-()] RS_ENDPOINT                    TYPE        TY_ENDPOINT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_desired_endpoint.
    DATA: lt_key_usage TYPE /iwbep/t_mgw_tech_pairs,
          ls_key_usage TYPE /iwbep/s_mgw_tech_pair.

    LOOP AT it_endpoints ASSIGNING FIELD-SYMBOL(<fs_endpoint>).
      DATA(lt_keys) = VALUE tt_keys( FOR ls_key IN <fs_endpoint>-keys
                      WHERE ( value NE '' )
                      ( ls_key ) ).

      ls_key_usage = VALUE #( name = CONV string( <fs_endpoint>-id ) value = lines( lt_keys ) ).
      APPEND ls_key_usage TO lt_key_usage.
    ENDLOOP.

    SORT lt_key_usage BY value DESCENDING.
    IF lines( lt_key_usage ) GT 0.
      rs_endpoint = it_endpoints[ id = lt_key_usage[ 1 ]-name ].
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method LCL_ODATA_ROUTER=>GET_ENDPOINT_KEYS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ENDPOINT                    TYPE        /IWBEP/SBDM_NODE_NAME
* | [--->] IV_OPERATION_TYPE              TYPE        /IWBEP/SBDSP_OPERATION_TYPE
* | [<-()] RT_ENDPOINTS                   TYPE        TT_ENDPOINTS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_endpoint_keys.
    SELECT id, method_name, class_name
      FROM zsf_orouter_end
      INTO CORRESPONDING FIELDS OF TABLE @rt_endpoints
      WHERE endpoint = @iv_endpoint
      AND operation_type = @iv_operation_type.

    LOOP AT rt_endpoints ASSIGNING FIELD-SYMBOL(<fs_endpoint>).
      SELECT name, entity_key, required
      FROM zsf_orouter_key
      INTO CORRESPONDING FIELDS OF TABLE @<fs_endpoint>-keys
      WHERE endpoint_id = @<fs_endpoint>-id.
    ENDLOOP.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method LCL_ODATA_ROUTER=>UPDATE_KEY_TABLE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_FILLED_KEYS                 TYPE        TT_KEYS
* | [<-->] CT_PATH_KEYS                   TYPE        TT_KEYS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD update_key_table.
    LOOP AT it_filled_keys ASSIGNING FIELD-SYMBOL(<fs_filled_key>).
      DATA(lv_index) = line_index( ct_path_keys[ "id = <fs_filled_key>-id
                                                 name = <fs_filled_key>-name
                                                 entity_key = <fs_filled_key>-entity_key
                                                 required = <fs_filled_key>-required ] ).
      MODIFY ct_path_keys FROM <fs_filled_key> INDEX lv_index TRANSPORTING value.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
