*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lcl_utils DEFINITION
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CLASS-METHODS convert_from_base64_url
      IMPORTING
        !iv_base64       TYPE string
      RETURNING
        VALUE(rv_string) TYPE string .
    CLASS-METHODS convert_to_base64_url
      IMPORTING
        !iv_string       TYPE string OPTIONAL
        !iv_base64       TYPE string OPTIONAL
      RETURNING
        VALUE(rv_string) TYPE string .
    CLASS-METHODS encrypt
      IMPORTING
        !iv_data       TYPE string
        !iv_key        TYPE string
      RETURNING
        VALUE(rv_data) TYPE string .
    CLASS-METHODS decrypt
      IMPORTING
        !iv_data       TYPE string
        !iv_key        TYPE string
      RETURNING
        VALUE(rv_data) TYPE string .
    CLASS-METHODS calculate_hash
      IMPORTING
        !iv_data       TYPE string
        !iv_key        TYPE string
      RETURNING
        VALUE(rv_hash) TYPE string .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS lcl_utils IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_UTILS=>CONVERT_FROM_BASE64_URL
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_BASE64                      TYPE        STRING
* | [<-()] RV_STRING                      TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD convert_from_base64_url.
    rv_string = replace( val = iv_base64 sub = `-` with = `+` ).
    rv_string = replace( val = rv_string sub = `_` with = `/` ).
    rv_string = |{ rv_string }==|.
    rv_string = cl_http_utility=>decode_base64( encoded = rv_string ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_UTILS=>CONVERT_TO_BASE64_URL
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_STRING                      TYPE        STRING(optional)
* | [--->] IV_BASE64                      TYPE        STRING(optional)
* | [<-()] RV_STRING                      TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD convert_to_base64_url.
    rv_string = COND #( WHEN iv_string IS NOT INITIAL
                            THEN cl_http_utility=>encode_base64( unencoded = iv_string )
                        ELSE iv_base64 ).
    rv_string = replace( val = rv_string sub = `=` with = `` ).
    rv_string = replace( val = rv_string sub = `+` with = `-` ).
    rv_string = replace( val = rv_string sub = `/` with = `_` ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_UTILS=>ENCRYPT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DATA                        TYPE        STRING
* | [--->] IV_KEY                         TYPE        STRING
* | [<-()] RV_DATA                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD encrypt.
    DATA lv_encrypted_data TYPE xstring.

    cl_sec_sxml_writer=>encrypt(
        EXPORTING
            plaintext  = cl_bcs_convert=>string_to_xstring( iv_string = iv_data )
            key        = cl_bcs_convert=>string_to_xstring( iv_string = iv_key )
            algorithm  = cl_sec_sxml_writer=>co_aes128_algorithm_pem
        IMPORTING
            ciphertext = lv_encrypted_data ).

    rv_data = CONV string( lv_encrypted_data ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_UTILS=>DECRYPT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DATA                        TYPE        STRING
* | [--->] IV_KEY                         TYPE        STRING
* | [<-()] RV_DATA                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD decrypt.
    DATA lv_decrypted_data TYPE xstring.

    cl_sec_sxml_writer=>decrypt(
        EXPORTING
            ciphertext = CONV xstring( iv_data )
            key        = cl_bcs_convert=>string_to_xstring( iv_string = iv_key )
            algorithm  = cl_sec_sxml_writer=>co_aes128_algorithm_pem
        IMPORTING
            plaintext  = lv_decrypted_data ).

    rv_data = cl_bcs_convert=>xstring_to_string( EXPORTING iv_xstr = lv_decrypted_data
                                                           iv_cp   = 1100 ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_UTILS=>CALCULATE_HASH
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DATA                        TYPE        STRING
* | [--->] IV_KEY                         TYPE        STRING
* | [<-()] RV_HASH                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD calculate_hash.
    DATA(lv_binary_secret) = cl_abap_hmac=>string_to_xstring( iv_key ).

    cl_abap_hmac=>calculate_hmac_for_char(
        EXPORTING
            if_algorithm = 'SHA256'
            if_key       = lv_binary_secret "cl_bcs_convert=>string_to_xstring( iv_string = iv_key )
            if_data      = iv_data
        IMPORTING
            ef_hmacstring = rv_hash
    ).
  ENDMETHOD.
ENDCLASS.

CLASS lcl_jwt_token DEFINITION
    FINAL
    CREATE PUBLIC .

  PUBLIC SECTION.
    CLASS-METHODS create_token
      IMPORTING
        !iv_username       TYPE string
        !iv_name           TYPE string
        !iv_role           TYPE string
        !iv_center         TYPE string
        !iv_area           TYPE string
        !iv_language       TYPE string
        !iv_usererpid      TYPE string
        !iv_issuedat       TYPE timestamp OPTIONAL
        !iv_duration       TYPE i
        !iv_unit           TYPE t006-msehi
        !iv_signing_key    TYPE string
        !iv_encryption_key TYPE string OPTIONAL
      RETURNING
        VALUE(rv_token)    TYPE string .
    CLASS-METHODS validate_token
      IMPORTING
        !iv_token          TYPE string
        !iv_duration       TYPE i
        !iv_unit           TYPE t006-msehi
        !iv_encryption_key TYPE string OPTIONAL
        !iv_signing_key    TYPE string
      RETURNING
        VALUE(rv_valid)    TYPE abap_bool .
    CLASS-METHODS get_claims
      IMPORTING
        !iv_token          TYPE string
        !iv_encryption_key TYPE string OPTIONAL
      RETURNING
        VALUE(rt_values)   TYPE tihttpnvp .
    CLASS-METHODS get_claim
      IMPORTING
        !iv_token       TYPE string
        !iv_claim       TYPE string
        !iv_encryption_key TYPE string OPTIONAL
      RETURNING
        VALUE(rv_value) TYPE string .
  PROTECTED SECTION.
    TYPES:
      BEGIN OF ty_header,
        alg TYPE string,
        typ TYPE string,
      END OF ty_header .
    TYPES:
      BEGIN OF ty_payload,
        username  TYPE string,
        name      TYPE string,
        role      TYPE string,
        center    TYPE string,
        area      TYPE string,
        language  TYPE string,
        usererpid TYPE string,
        iat       TYPE string,
        exp       TYPE string,
      END OF ty_payload .
    CLASS-METHODS generate_header
      RETURNING
        VALUE(rv_header) TYPE string .
    CLASS-METHODS generate_payload
      IMPORTING
        !iv_username      TYPE string
        !iv_name          TYPE string
        !iv_role          TYPE string
        !iv_center        TYPE string
        !iv_area          TYPE string
        !iv_language      TYPE string
        !iv_usererpid     TYPE string
        !iv_iat           TYPE timestamp OPTIONAL
        !iv_duration      TYPE i
        !iv_unit          TYPE t006-msehi
      RETURNING
        VALUE(rv_payload) TYPE string .
    CLASS-METHODS generate_payload_iat_exp
      IMPORTING
        !iv_iat      TYPE timestamp OPTIONAL
        !iv_duration TYPE i
        !iv_unit     TYPE t006-msehi
      EXPORTING
        !ev_iat      TYPE string
        !ev_exp      TYPE string .
    CLASS-METHODS generate_signature
      IMPORTING
        !iv_header          TYPE string
        !iv_payload         TYPE string
        !iv_signing_key     TYPE string
      RETURNING
        VALUE(rv_signature) TYPE string .
  PRIVATE SECTION.
ENDCLASS.

CLASS lcl_jwt_token IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_JWT_TOKEN=>CREATE_TOKEN
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_USERNAME                    TYPE        STRING
* | [--->] IV_NAME                        TYPE        STRING
* | [--->] IV_ROLE                        TYPE        STRING
* | [--->] IV_CENTER                      TYPE        STRING
* | [--->] IV_AREA                        TYPE        STRING
* | [--->] IV_LANGUAGE                    TYPE        STRING
* | [--->] IV_USERERPID                   TYPE        STRING
* | [--->] IV_ISSUEDAT                    TYPE        TIMESTAMP(optional)
* | [--->] IV_DURATION                    TYPE        I
* | [--->] IV_UNIT                        TYPE        T006-MSEHI
* | [--->] IV_SIGNING_KEY                 TYPE        STRING
* | [--->] IV_ENCRYPTION_KEY              TYPE        STRING(optional)
* | [<-()] RV_TOKEN                       TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD create_token.
    DATA(lv_header) = generate_header( ).
    DATA(lv_payload) = generate_payload(
        EXPORTING
            iv_username  = iv_username
            iv_name      = iv_name
            iv_role      = iv_role
            iv_center    = iv_center
            iv_area      = iv_area
            iv_language  = iv_language
            iv_usererpid = iv_usererpid
            iv_iat       = iv_issuedat
            iv_duration  = iv_duration
            iv_unit      = iv_unit ).

    DATA(lv_encoded_header) = lcl_utils=>convert_to_base64_url( iv_string = lv_header ).
    DATA(lv_encoded_payload) = lcl_utils=>convert_to_base64_url( iv_string = lv_payload ).

    DATA(lv_signature) = generate_signature( EXPORTING iv_header      = lv_encoded_header
                                                           iv_payload     = lv_encoded_payload
                                                           iv_signing_key = iv_signing_key ).

    DATA(lv_encoded_signature) = lcl_utils=>convert_to_base64_url( iv_base64 = lv_signature ).

    rv_token = |{ lv_encoded_header }.{ lv_encoded_payload }.{ lv_encoded_signature }|.

    IF strlen( iv_encryption_key ) GT 0.
      rv_token = lcl_utils=>encrypt( iv_data = rv_token
                                     iv_key  = iv_encryption_key ).
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_JWT_TOKEN=>GENERATE_HEADER
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_HEADER                      TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD generate_header.
    DATA(ls_header) = VALUE ty_header( alg = `HS256`
                                       typ = `JWT` ).
    rv_header = /ui2/cl_json=>serialize( data = ls_header
                                         compress = abap_true
                                         pretty_name = /ui2/cl_json=>pretty_mode-low_case ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_JWT_TOKEN=>GENERATE_PAYLOAD
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_USERNAME                    TYPE        STRING
* | [--->] IV_NAME                        TYPE        STRING
* | [--->] IV_ROLE                        TYPE        STRING
* | [--->] IV_CENTER                      TYPE        STRING
* | [--->] IV_AREA                        TYPE        STRING
* | [--->] IV_LANGUAGE                    TYPE        STRING
* | [--->] IV_USERERPID                   TYPE        STRING
* | [--->] IV_DURATION                    TYPE        I
* | [--->] IV_UNIT                        TYPE        T006-MSEHI
* | [<-()] RV_PAYLOAD                     TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD generate_payload.
    DATA(ls_payload) =
        VALUE ty_payload( username = iv_username
                          name = iv_name
                          role = iv_role
                          center = iv_center
                          area = iv_area
                          language = iv_language
                          usererpid = iv_usererpid ).
    generate_payload_iat_exp( EXPORTING iv_duration = iv_duration
                                            iv_unit = iv_unit
                                  IMPORTING ev_iat = ls_payload-iat
                                            ev_exp = ls_payload-exp ).

    rv_payload = /ui2/cl_json=>serialize( data = ls_payload
                                          compress = abap_true
                                          pretty_name = /ui2/cl_json=>pretty_mode-low_case ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_JWT_TOKEN=>GENERATE_PAYLOAD_IAT_EXP
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_IAT                         TYPE        TIMESTAMP(optional)
* | [--->] IV_DURATION                    TYPE        I
* | [--->] IV_UNIT                        TYPE        T006-MSEHI
* | [<---] EV_IAT                         TYPE        STRING
* | [<---] EV_EXP                         TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD generate_payload_iat_exp.
    DATA: lv_iat TYPE timestamp,
          lv_exp TYPE timestamp.

    lv_iat = COND #( WHEN iv_iat IS NOT INITIAL
                        THEN iv_iat
                     ELSE |{ sy-datum }{ sy-uzeit }| ).

    " Set token expiry
    CALL FUNCTION 'TIMESTAMP_DURATION_ADD'
      EXPORTING
        timestamp_in  = lv_iat
        timezone      = sy-zonlo
        duration      = iv_duration
        unit          = iv_unit
      IMPORTING
        timestamp_out = lv_exp.

    ev_iat = |{ lv_iat TIMESTAMP = ISO }Z|.
    ev_exp = |{ lv_exp TIMESTAMP = ISO }Z|.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_JWT_TOKEN=>GENERATE_SIGNATURE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_HEADER                      TYPE        STRING
* | [--->] IV_PAYLOAD                     TYPE        STRING
* | [--->] IV_SIGNING_KEY                 TYPE        STRING
* | [<-()] RV_SIGNATURE                   TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD generate_signature.
    rv_signature = lcl_utils=>calculate_hash( EXPORTING iv_data = |{ iv_header }.{ iv_payload }|
                                                        iv_key  = iv_signing_key ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_JWT_TOKEN=>VALIDATE_TOKEN
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_TOKEN                       TYPE        STRING
* | [--->] IV_DURATION                    TYPE        I
* | [--->] IV_UNIT                        TYPE        T006-MSEHI
* | [--->] IV_ENCRYPTION_KEY              TYPE        STRING(optional)
* | [--->] IV_SIGNING_KEY                 TYPE        STRING
* | [<-()] RV_VALID                       TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD validate_token.
    " Decrypt the token if necessary
    DATA(lv_token) = iv_token.
    IF strlen( iv_encryption_key ) GT 0.
      TRY.
          lv_token = lcl_utils=>decrypt( iv_data = iv_token
                                         iv_key  = iv_encryption_key ).
        CATCH cx_root.
          RETURN.
      ENDTRY.
    ENDIF.

    " Check if it has 3 parts (header, payload and signature)
    SPLIT lv_token AT '.' INTO TABLE DATA(lt_partials).
    CHECK lines( lt_partials ) EQ 3.

    " Check header
    DATA(lv_header_json) = lcl_utils=>convert_from_base64_url( lt_partials[ 1 ] ).
    DATA ls_header TYPE ty_header.
    /ui2/cl_json=>deserialize( EXPORTING json = lv_header_json
                                         pretty_name = /ui2/cl_json=>pretty_mode-low_case
                               CHANGING  data = ls_header ).

    CHECK ( ls_header-typ EQ 'JWT' )
    AND ( ls_header-alg EQ 'HS256' ).

    " Check signature
*    DATA(lv_signature) = generate_signature( EXPORTING iv_header             = lt_partials[ 1 ]
*                                                           iv_payload        = lt_partials[ 2 ]
*                                                           iv_signing_key    = iv_signing_key ).
*    DATA(lv_encoded_signature) = lcl_utils=>convert_to_base64_url( iv_base64 = lv_signature ).
*    CHECK lv_encoded_signature EQ lt_partials[ 3 ].

    " Get the payload
    DATA(lv_payload_json) = lcl_utils=>convert_from_base64_url( lt_partials[ 2 ] ).
    DATA ls_payload TYPE ty_payload.
    /ui2/cl_json=>deserialize( EXPORTING json = lv_payload_json
                                         pretty_name = /ui2/cl_json=>pretty_mode-low_case
                               CHANGING  data = ls_payload ).

    " Check the token's expiry
    TRY.
        DATA(lv_issuedat) = cl_xlf_date_time=>parse( EXPORTING iso8601 = ls_payload-iat ).
      CATCH cx_root.
        RETURN.
    ENDTRY.
    generate_payload_iat_exp( EXPORTING iv_iat = lv_issuedat
                                            iv_duration = iv_duration
                                            iv_unit = iv_unit
                                  IMPORTING ev_exp = DATA(lv_calculated_expiry) ).
    TRY.
        DATA(lv_expiredat) = cl_xlf_date_time=>parse( EXPORTING iso8601 = lv_calculated_expiry ).
      CATCH cx_root.
        RETURN.
    ENDTRY.
    GET TIME STAMP FIELD DATA(lv_current_datetime).

    CHECK ( lv_current_datetime GT lv_issuedat )
    AND ( lv_calculated_expiry EQ ls_payload-exp )
    AND ( lv_current_datetime LT lv_expiredat ).

    rv_valid = abap_true.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_JWT_TOKEN=>GET_CLAIMS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_TOKEN                       TYPE        STRING
* | [--->] IV_ENCRYPTION_KEY              TYPE        STRING(optional)
* | [<-()] RT_VALUES                      TYPE        TIHTTPNVP
* +--------------------------------------------------------------------------------------</SIGNATURE>
*  METHOD get_claims.
*    SPLIT iv_token AT '.' INTO TABLE DATA(lv_partials).
*    DATA(lv_payload_json) = lcl_utils=>convert_from_base64_url( lv_partials[ 2 ] ).
*
*    DATA ls_payload TYPE ty_payload.
*    /ui2/cl_json=>deserialize( EXPORTING json = lv_payload_json
*                                         pretty_name = /ui2/cl_json=>pretty_mode-low_case
*                               CHANGING data = ls_payload ).
*
*    DATA: lt_jwt_claims TYPE STANDARD TABLE OF ty_payload.
*    APPEND ls_payload TO lt_jwt_claims.
*    rt_values = VALUE #( ( name = `username` value = ls_payload-username )
*                        ( name = `name` value = ls_payload-name )
*                        ( name = `role` value = ls_payload-role )
*                        ( name = `center` value = ls_payload-center )
*                        ( name = `area` value = ls_payload-area )
*                        ( name = `language` value = ls_payload-language )
*                        ( name = `usererpid` value = ls_payload-usererpid ) ).
*  ENDMETHOD.
  METHOD get_claims.
    DATA(lv_token) = iv_token.
    IF strlen( iv_encryption_key ) GT 0.
      TRY.
          lv_token = lcl_utils=>decrypt( iv_data = iv_token
                                         iv_key  = iv_encryption_key ).
        CATCH cx_root.
          RETURN.
      ENDTRY.
    ENDIF.

    SPLIT lv_token AT '.' INTO TABLE DATA(lt_partials).
    DATA(lv_payload_json) = lcl_utils=>convert_from_base64_url( lt_partials[ 2 ] ).

    DATA ls_payload TYPE ty_payload.
    /ui2/cl_json=>deserialize( EXPORTING json = lv_payload_json
                                         pretty_name = /ui2/cl_json=>pretty_mode-low_case
                               CHANGING data = ls_payload ).

    DATA: lt_jwt_claims TYPE STANDARD TABLE OF ty_payload.
    APPEND ls_payload TO lt_jwt_claims.
    rt_values = VALUE #( ( name = `username` value = ls_payload-username )
                        ( name = `name` value = ls_payload-name )
                        ( name = `role` value = ls_payload-role )
                        ( name = `center` value = ls_payload-center )
                        ( name = `area` value = ls_payload-area )
                        ( name = `language` value = ls_payload-language )
                        ( name = `usererpid` value = ls_payload-usererpid ) ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_JWT_TOKEN=>GET_CLAIM
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_TOKEN                       TYPE        STRING
* | [--->] IV_CLAIM                       TYPE        STRING
* | [--->] IV_ENCRYPTION_KEY              TYPE        STRING(optional)
* | [<-()] RT_VALUES                      TYPE        TIHTTPNVP
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_claim.
    DATA(lv_token) = iv_token.
    IF strlen( iv_encryption_key ) GT 0.
      TRY.
          lv_token = lcl_utils=>decrypt( iv_data = iv_token
                                         iv_key  = iv_encryption_key ).
        CATCH cx_root.
          RETURN.
      ENDTRY.
    ENDIF.

    SPLIT lv_token AT '.' INTO TABLE DATA(lt_partials).
    DATA(lv_payload_json) = lcl_utils=>convert_from_base64_url( lt_partials[ 2 ] ).

    DATA ls_payload TYPE ty_payload.
    /ui2/cl_json=>deserialize( EXPORTING json = lv_payload_json
                                         pretty_name = /ui2/cl_json=>pretty_mode-low_case
                               CHANGING data = ls_payload ).

    DATA: lt_jwt_claims TYPE STANDARD TABLE OF ty_payload.
    APPEND ls_payload TO lt_jwt_claims.
    " Get desired claim and return it
    FIELD-SYMBOLS <comp> TYPE any.
    ASSIGN COMPONENT iv_claim OF STRUCTURE ls_payload TO <comp>.
    READ TABLE lt_jwt_claims TRANSPORTING NO FIELDS WITH KEY (iv_claim) = <comp>.
    rv_value = <comp>.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_icf DEFINITION
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CLASS-METHODS update_sicf_login
      IMPORTING
        !iv_url      TYPE string
        !iv_username TYPE syuname
        !iv_password TYPE icfpasswd .
    CLASS-METHODS check_if_sicf_user
      IMPORTING
        !iv_url           TYPE string
        !iv_username      TYPE syuname
      RETURNING
        VALUE(rv_is_user) TYPE abap_bool .
  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-METHODS set_sicf_credentials
      IMPORTING
        !iv_url      TYPE string
        !iv_username TYPE syuname
        !iv_password TYPE icfpasswd .
ENDCLASS.

CLASS lcl_icf IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_ICF=>UPDATE_SICF_LOGIN
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_URL                         TYPE        STRING
* | [--->] IV_USERNAME                    TYPE        SYUNAME
* | [--->] IV_PASSWORD                    TYPE        ICFPASSWD
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD update_sicf_login.
    CHECK check_if_sicf_user( EXPORTING iv_url = iv_url iv_username = iv_username ).

    set_sicf_credentials( EXPORTING iv_url = iv_url
                                    iv_username = iv_username
                                    iv_password = iv_password ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_ICF=>CHECK_IF_SICF_USER
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_URL                         TYPE        STRING
* | [--->] IV_USERNAME                    TYPE        SYUNAME
* | [<-()] RV_IS_USER                     TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD check_if_sicf_user.
    DATA lv_username TYPE syuname.
    CALL FUNCTION 'HTTP_SERVICE_GET_LOGON_DATA'
      EXPORTING
        url                  = iv_url
      IMPORTING
        icf_user             = lv_username
      EXCEPTIONS
        invalid_url          = 1
        empty_nodguid_or_url = 2
        OTHERS               = 3.

    rv_is_user = COND #( WHEN iv_username EQ lv_username
                            THEN abap_true
                        ELSE abap_false ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_ICF=>SET_SICF_CREDENTIALS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_URL                         TYPE        STRING
* | [--->] IV_USERNAME                    TYPE        SYUNAME
* | [--->] IV_PASSWORD                    TYPE        ICFPASSWD
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_sicf_credentials.
    CALL FUNCTION 'HTTP_SERVICE_SET_LOGON_DATA'
      EXPORTING
        url                  = iv_url
        icf_mandt            = sy-mandt
        icf_user             = iv_username
        icf_passwd           = iv_password
        icf_langu            = sy-langu
      EXCEPTIONS
        invalid_url          = 1
        error_change_node    = 2
        empty_nodguid_or_url = 3
        OTHERS               = 4.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_http DEFINITION
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CLASS-METHODS set_cookie
      IMPORTING
        !iv_domain  TYPE string OPTIONAL
        !iv_expires TYPE string OPTIONAL
        !iv_name    TYPE string
        !iv_path    TYPE string OPTIONAL
        !iv_secure  TYPE i
        !iv_value   TYPE string .
    CLASS-METHODS get_cookie
      IMPORTING
        !iv_name        TYPE string
      RETURNING
        VALUE(rv_value) TYPE string .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS lcl_http IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_HTTP=>SET_COOKIE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DOMAIN                      TYPE        STRING(optional)
* | [--->] IV_EXPIRES                     TYPE        STRING(optional)
* | [--->] IV_NAME                        TYPE        STRING
* | [--->] IV_PATH                        TYPE        STRING(optional)
* | [--->] IV_SECURE                      TYPE        STRING
* | [--->] IV_VALUE                       TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_cookie.
    DATA: lo_server TYPE REF TO cl_http_server_net.
    FIELD-SYMBOLS: <server> TYPE any.
    ASSIGN ('(SAPLHTTP_RUNTIME)server_accepted') TO <server>.
    CHECK: <server> IS ASSIGNED.
    lo_server ?= <server>.
    lo_server->response->set_cookie(
    EXPORTING
        domain     = iv_domain
        expires    = iv_expires
        name       = iv_name
        path       = iv_path
        secure     = iv_secure
        value      = iv_value
    ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_HTTP=>GET_COOKIE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_NAME                        TYPE        STRING
* | [<-()] RV_VALUE                       TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_cookie.
    DATA: lo_server TYPE REF TO cl_http_server_net.
    FIELD-SYMBOLS: <server> TYPE any.
    ASSIGN ('(SAPLHTTP_RUNTIME)server_accepted') TO <server>.
    CHECK: <server> IS ASSIGNED.
    lo_server ?= <server>.
    lo_server->request->get_cookie( EXPORTING name  = iv_name
                                    IMPORTING value = rv_value ).
  ENDMETHOD.
ENDCLASS.

CLASS lcl_shopfloor DEFINITION
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CLASS-METHODS get_backend_url
      RETURNING
        VALUE(rv_url) TYPE string .
    CLASS-METHODS get_frontend_url
      RETURNING
        VALUE(rv_url) TYPE string .
    CLASS-METHODS get_password_signing_key
      RETURNING
        VALUE(rv_key) TYPE string .
    CLASS-METHODS get_password_encryption_key
      RETURNING
        VALUE(rv_key) TYPE string .
    CLASS-METHODS get_token_signing_key
      RETURNING
        VALUE(rv_key) TYPE string .
    CLASS-METHODS get_token_encryption_key
      RETURNING
        VALUE(rv_key) TYPE string .
    CLASS-METHODS get_token_duration_value
      RETURNING
        VALUE(rv_duration_value) TYPE i .
    CLASS-METHODS get_token_duration_unit
      RETURNING
        VALUE(rv_duration_unit) TYPE t006-msehi .
    CLASS-METHODS is_https_enabled
      RETURNING
        VALUE(rv_enabled) TYPE i .
    CLASS-METHODS update_bsp
      IMPORTING
        !iv_basicauthdetails TYPE string .
    CLASS-METHODS modify_manifest_token
      IMPORTING
        !iv_app_name    TYPE string
        !iv_app_key     TYPE string
        !iv_new_token   TYPE string
        !iv_token_regex TYPE string.
    CLASS-METHODS get_default_sap_user_token
      RETURNING
        VALUE(rv_default_token) TYPE string .
    CLASS-METHODS update_default_sap_user_token
      IMPORTING
        VALUE(iv_default_token) TYPE string .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS lcl_shopfloor IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_SHOPFLOOR=>GET_BACKEND_URL
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_URL                         TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_backend_url.
    SELECT SINGLE value
      FROM zsf_odata_config
      WHERE name = `BACKEND_URL`
      INTO @rv_url.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_SHOPFLOOR=>GET_FRONTEND_URL
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_URL                         TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_frontend_url.
    SELECT SINGLE value
      FROM zsf_odata_config
      WHERE name = `FRONTEND_URL`
      INTO @rv_url.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_SHOPFLOOR=>GET_PASSWORD_SIGNING_KEY
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_KEY                         TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_password_signing_key.
    SELECT SINGLE value
      FROM zsf_odata_config
      WHERE name = `PASSWORD_SIGNING_KEY`
      INTO @rv_key.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_SHOPFLOOR=>GET_PASSWORD_ENCRYPTION_KEY
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_KEY                         TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_password_encryption_key.
    SELECT SINGLE value
      FROM zsf_odata_config
      WHERE name = `PASSWORD_ENCRYPTION_KEY`
      INTO @rv_key.
  ENDMETHOD.

* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_SHOPFLOOR=>GET_TOKEN_SIGNING_KEY
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_KEY                         TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_token_signing_key.
    SELECT SINGLE value
      FROM zsf_odata_config
      WHERE name = `TOKEN_SIGNING_KEY`
      INTO @rv_key.
  ENDMETHOD.

* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_SHOPFLOOR=>GET_TOKEN_ENCRYPTION_KEY
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_KEY                         TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_token_encryption_key.
    SELECT SINGLE value
      FROM zsf_odata_config
      WHERE name = `TOKEN_ENCRYPTION_KEY`
      INTO @rv_key.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_SHOPFLOOR=>GET_TOKEN_DURATION_VALUE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_DURATION_VALUE              TYPE        I
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_token_duration_value.
    SELECT SINGLE value
      FROM zsf_odata_config
      WHERE name = `TOKEN_DURATION_VALUE`
      INTO @DATA(lv_duration).

    rv_duration_value = CONV i( lv_duration ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_SHOPFLOOR=>GET_TOKEN_DURATION_UNIT
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_DURATION_UNIT               TYPE        T006-MSEHI
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_token_duration_unit.
    SELECT SINGLE value
      FROM zsf_odata_config
      WHERE name = `TOKEN_DURATION_UNIT`
      INTO @DATA(lv_unit).

    rv_duration_unit = CONV t006-msehi( lv_unit ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_SHOPFLOOR=>IS_HTTPS_ENABLED
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_ENABLED                     TYPE        I
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD is_https_enabled.
    "SELECT FROM sicf INTO rv_enabled
    rv_enabled = 0.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_SHOPFLOOR=>UPDATE_BSP
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_BASICAUTHDETAILS            TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD update_bsp.
    DATA:
      lt_content TYPE o2pageline_table,
      lv_content TYPE string.

    "ZSHOPF_SAPUI5
    SELECT sign, so_option AS option, low, high
      FROM zbc_fixval_t
      INTO TABLE @DATA(lr_applname)
      WHERE module_sap   EQ 'PP'
        AND parameter_id EQ 'SHOPFLOOR_APPL_NAME'.
    CHECK lr_applname[] IS NOT INITIAL.

    SELECT applname, pagekey
      FROM o2pagdir
      INTO TABLE @DATA(lt_pages)
      WHERE applname IN @lr_applname.

    DATA(lv_basicauthdetail) = |("basicAuthDetails","Basic { iv_basicauthdetails }")|.

    LOOP AT lt_pages ASSIGNING FIELD-SYMBOL(<ls_page>).
      DATA(ls_key) =
        VALUE o2pconkey(
          applname = <ls_page>-applname
          pagekey  = <ls_page>-pagekey
          objtype  = 'PD'
          version  = 'A'
        ).

      IMPORT content TO lt_content
        FROM DATABASE o2pagcon(tr) ID ls_key.
      CHECK sy-subrc IS INITIAL.

      FIND FIRST OCCURRENCE OF
        REGEX '\("basicAuthDetails","Basic[[:space:][:alnum:][:punct:]]+"\)'
        IN TABLE lt_content
        IN CHARACTER MODE.
      CHECK sy-subrc IS INITIAL.

      CLEAR lv_content.
      LOOP AT lt_content ASSIGNING FIELD-SYMBOL(<ls_content>).
        lv_content = |{ lv_content }{ <ls_content>-line(254) }|.
      ENDLOOP.

      REPLACE FIRST OCCURRENCE OF
        REGEX '\("basicAuthDetails","Basic[[:space:][:alnum:][:punct:]]+"\)'
        IN lv_content
        WITH |("basicAuthDetails","Basic { iv_basicauthdetails }")|
        IN CHARACTER MODE.
      CHECK sy-subrc IS INITIAL.

      DATA(lv_strlen) = strlen( lv_content ).

      CLEAR lt_content[].
      DO.
        DATA(lv_offset) = ( sy-index - 1 ) * 254.
        IF lv_offset GT lv_strlen.
          EXIT.
        ENDIF.

        DATA(lv_size) = lv_strlen - lv_offset.
        IF lv_size GT 254.
          APPEND |{ lv_content+lv_offset(254) }+| TO lt_content.
        ELSE.
          APPEND lv_content+lv_offset(lv_size) TO lt_content.
        ENDIF.
      ENDDO.

      EXPORT content = lt_content
        TO DATABASE o2pagcon(tr) ID ls_key.
    ENDLOOP.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_SHOPFLOOR=>MODIFY_MANIFEST_TOKEN
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_APP_NAME                    TYPE        STRING
* | [--->] IV_APP_KEY                     TYPE        STRING
* | [--->] IV_NEW_TOKEN                   TYPE        STRING
* | [--->] IV_TOKEN_REGEX                 TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD modify_manifest_token.
    DATA: ls_pageattr   TYPE o2pagattr,
          lt_source     TYPE o2pageline_table,
          lt_ev_handler TYPE o2pagevh_tabletype,
          lt_attributes TYPE o2pagpar_tabletype,
          lv_typesource TYPE rswsourcet.

    DATA(ls_pagekey) = VALUE o2pagkey( applname = iv_app_name
                                       pagekey = `MANIFEST.JSON` ).

    " Get current page
    cl_bsp_api_generate=>bsp_api_get_page(
      EXPORTING
        p_pagekey          = ls_pagekey
      IMPORTING
        p_pageattr         = ls_pageattr
        p_source           = lt_source
        p_ev_handler       = lt_ev_handler
        p_attributes       = lt_attributes
        p_typesource       = lv_typesource
      EXCEPTIONS
        permission_failure = 1
        page_not_existing  = 2
        error_occured      = 3
        OTHERS             = 4 ).

    " Modify the Authorization token
    DATA lt_lines TYPE string_table.
    LOOP AT lt_source ASSIGNING FIELD-SYMBOL(<fs_source_line>).
      <fs_source_line> = CONV #( replace( val   = CONV string( <fs_source_line> )
                                          regex = iv_token_regex
                                          with  = iv_new_token
                                          occ   = 0 ) ).
    ENDLOOP.

    " Regenerate the file
    cl_bsp_api_generate=>bsp_api_generate_page(
      EXPORTING
        p_pageattr               = ls_pageattr
        p_source                 = lt_source
        p_ev_handler             = lt_ev_handler
        p_attributes             = lt_attributes
        p_typesource             = lv_typesource
        p_modify                 = 'X'
      EXCEPTIONS
        permission_failure       = 1
        page_locked              = 2
        page_existing            = 3
        inactive_page_existing   = 4
        application_not_existing = 5
        invalid_name             = 6
        error_in_page            = 7
        error_occured            = 8
        OTHERS                   = 9 ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_SHOPFLOOR=>GET_DEFAULT_SAP_USER_TOKEN
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_DEFAULT_TOKEN               TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_default_sap_user_token.
    SELECT SINGLE value
      FROM zsf_odata_config
      WHERE name = `DEFAULT_BASIC_TOKEN`
      INTO @rv_default_token.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_SHOPFLOOR=>UPDATE_DEFAULT_SAP_USER_TOKEN
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DEFAULT_TOKEN               TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD update_default_sap_user_token.
    UPDATE zsf_odata_config
      SET value = @iv_default_token
      WHERE name = `DEFAULT_BASIC_TOKEN`.
  ENDMETHOD.
ENDCLASS.
