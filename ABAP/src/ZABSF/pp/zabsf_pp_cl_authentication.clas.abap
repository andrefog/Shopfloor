class ZABSF_PP_CL_AUTHENTICATION definition
  public
  final
  create public .

public section.

  class-methods CHANGE_SAP_USER
    importing
      !IV_USERNAME type STRING
    exporting
      value(RV_USER_CHANGED) type ABAP_BOOL
      !RV_ACCESS_TOKEN type STRING .
  class-methods CHECK_SICF_USER
    importing
      !IV_USERNAME type SYUNAME
    returning
      value(RV_VALID) type BOOLEAN .
  class-methods CREATE_TOKEN
    importing
      !IV_USERNAME type STRING
      !IV_NAME type STRING
      !IV_ROLE type STRING
      !IV_CENTER type STRING
      !IV_AREA type STRING
      !IV_LANGUAGE type STRING
      !IV_USERERPID type STRING
    returning
      value(RV_TOKEN) type STRING .
  class-methods DECRYPT_TOKEN
    importing
      !IV_TOKEN type STRING
    returning
      value(RV_TOKEN) type STRING .
  class-methods GET_ACTIONS
    importing
      !IV_USERNAME type ZABSF_E_USERNAME
    exporting
      !EV_ACTIONS type STRING .
  class-methods GET_ACTIVITYOFOBJECTS
    importing
      !IV_USERNAME type ZABSF_E_USERNAME
    exporting
      !EV_AUTHACTOBJ type STRING .
  class-methods GET_AUTHORIZATIONROLESUSER
    importing
      !IV_SERIALIZEJSON type FLAG
      !IV_USERNAME type ZABSF_E_USERNAME
    exporting
      !EV_AUTHROLEUSER type STRING
      !ES_AUTHROLE type STRING .
  class-methods GET_CLAIM
    importing
      !IV_TOKEN type STRING
      !IV_CLAIM type STRING
    returning
      value(RV_VALUE) type STRING .
  class-methods GET_CLAIMS
    importing
      !IV_TOKEN type STRING
    returning
      value(RT_VALUES) type TIHTTPNVP .
  class-methods GET_HASHED_PASSWORD
    importing
      !IV_PASSWORD type STRING
    returning
      value(RV_HASHED_PASSWORD) type STRING .
  class-methods GET_JWT_FROM_COOKIE
    returning
      value(RV_TOKEN) type STRING .
  class-methods GET_SHOPFLOOR_SICF_USER
    returning
      value(RT_USERS) type SPERS_ULST .
  class-methods GET_SHOPFLOOR_USERS
    returning
      value(RT_USERS) type SPERS_ULST .
  class-methods IS_SHOPFLOOR_USER
    importing
      !IV_USERNAME type UNAME
    returning
      value(RV_RETURN) type BOOLEAN .
  class-methods NEW_CHANGE_SAP_USER
    importing
      !IV_USERNAME type UNAME
    returning
      value(RV_USER_CHANGED) type ABAP_BOOL .
  class-methods NEW_CREATE_TOKEN
    importing
      !IV_USERNAME type STRING
      !IV_NAME type STRING
      !IV_ROLE type STRING
      !IV_CENTER type STRING
      !IV_AREA type STRING
      !IV_LANGUAGE type STRING
      !IV_USERERPID type STRING
    returning
      value(RV_TOKEN) type STRING .
  class-methods NEW_GET_CLAIM
    importing
      !IV_TOKEN type STRING
      !IV_CLAIM type STRING
    returning
      value(RV_VALUE) type STRING .
  class-methods NEW_GET_CLAIMS
    importing
      !IV_TOKEN type STRING
    returning
      value(RT_VALUES) type TIHTTPNVP .
  class-methods NEW_GET_DEFAULT_SAP_USER_TOKEN
    returning
      value(RV_DEFAULT_TOKEN) type STRING .
  class-methods NEW_GET_HASHED_PASSWORD
    importing
      !IV_PASSWORD type STRING
    returning
      value(RV_HASHED_PASSWORD) type STRING .
  class-methods NEW_GET_TOKEN_COOKIE
    returning
      value(RV_VALUE) type STRING .
  class-methods NEW_SET_TOKEN_COOKIE
    importing
      !IV_VALUE type STRING .
  class-methods NEW_UPDATE_SAP_USER_PWD
    importing
      !IV_USERNAME type UNAME
      !IV_PASSWORD type XUNCODE
      !IV_HASHED_PASSWORD type PWD_HASH_STRING optional .
  class-methods NEW_VALIDATE_TOKEN
    importing
      !IV_TOKEN type STRING
    returning
      value(RV_VALID) type ABAP_BOOL .
  class-methods SET_TOKEN_COOKIE
    importing
      !IV_TOKEN type STRING .
  class-methods UPDATE_SAP_USER_PWD
    importing
      !IV_USERNAME type STRING
      !IV_PASSWORD type STRING .
  class-methods UPD_SHOPFLOOR_USER_PASSWORD
    importing
      !IV_USERNAME type UNAME
      !IV_PASSWORD type ICFPASSWD
      !IV_PWD_HASH type PWD_HASH_STRING .
  class-methods VALIDATE_TOKEN
    importing
      !IV_TOKEN type STRING
    returning
      value(RV_VALID) type ABAP_BOOL .
protected section.
private section.

  types:
    BEGIN OF ty_header,
      alg TYPE string,
      typ TYPE string,
    END OF ty_header .
  types:
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

  class-data GV_JWT_TOKEN_SIGNING_KEY type STRING value 'leica-shopfloor-demo-key' ##NO_TEXT.
  class-data GV_PASSWORD_SIGNING_KEY type STRING value 'leica-shopfloor-demo' ##NO_TEXT.
  class-data GV_PASSWORD_ENCRYPTION_KEY type STRING value 'eica-shopfloor-demo-key' ##NO_TEXT.
  class-data GV_JWT_TOKEN_ENCRYPTION_KEY type STRING value 'leica-shopfloor-demo-key' ##NO_TEXT.

  class-methods CONVERT_FROM_BASE64_URL
    importing
      !IV_BASE64 type STRING
    returning
      value(RV_STRING) type STRING .
  class-methods CONVERT_TO_BASE64_URL
    importing
      !IV_STRING type STRING optional
      !IV_BASE64 type STRING optional
    returning
      value(RV_ENCODED) type STRING .
  class-methods ENCRYPT_TOKEN
    importing
      !IV_TOKEN type STRING
    returning
      value(RV_TOKEN) type STRING .
  class-methods GENERATE_HEADER
    returning
      value(RV_JSON) type STRING .
  class-methods GENERATE_PAYLOAD
    importing
      !IV_USERNAME type STRING
      !IV_NAME type STRING
      !IV_ROLE type STRING
      !IV_CENTER type STRING
      !IV_AREA type STRING
      !IV_LANGUAGE type STRING
      !IV_USERERPID type STRING
    returning
      value(RV_JSON) type STRING .
  class-methods GENERATE_PAYLOAD_IAT_EXP
    importing
      !IV_IAT type TIMESTAMP optional
    exporting
      !EV_IAT type STRING
      !EV_EXP type STRING .
  class-methods GENERATE_SIGNATURE
    importing
      !IV_HEADER type STRING
      !IV_PAYLOAD type STRING
    exporting
      !EV_HMACSTRING type STRING
      !EV_HMACXSTRING type STRING
      !EV_HMACB64STRING type STRING
    returning
      value(RV_SIGNATURE) type STRING .
  class-methods UPD_LOGIN_CONTROLLER
    importing
      !IV_BASICAUTHDETAILS type STRING .
  class-methods UPD_SICF_LOGIN
    importing
      !IV_USERNAME type UNAME
      !IV_PASSWORD type ICFPASSWD .
ENDCLASS.



CLASS ZABSF_PP_CL_AUTHENTICATION IMPLEMENTATION.


  METHOD change_sap_user.
    rv_user_changed = abap_false.

    SELECT SINGLE b~usersap, b~password
      INTO @DATA(ls_usersap)
      FROM zsf_users AS a
      LEFT JOIN zsf_userssap AS b
      ON a~usersap EQ b~usersap
      WHERE a~username EQ @iv_username.

    IF ls_usersap IS INITIAL.
      RETURN.
    ENDIF.

    DATA: lv_key            TYPE xstring,
          lv_decrypted_xpwd TYPE xstring,
          lv_data           TYPE xstring.

    lv_key = cl_bcs_convert=>string_to_xstring( iv_string = gv_password_encryption_key ).

    lv_data = CONV xstring( ls_usersap-password ).

    cl_sec_sxml_writer=>decrypt(
                 EXPORTING
                   ciphertext  = lv_data
                   key        = lv_key
                   algorithm  = cl_sec_sxml_writer=>co_aes128_algorithm_pem
                 IMPORTING
                   plaintext = lv_decrypted_xpwd ).

    cl_bcs_convert=>xstring_to_string(
        EXPORTING
          iv_xstr   = lv_decrypted_xpwd
          iv_cp     =  1100
        RECEIVING
          rv_string = DATA(lv_decrypted_pwd)
      ).

    DATA: lv_username TYPE bapibname-bapibname,
          lv_password TYPE bapipwd.

    lv_username = ls_usersap-usersap.
    lv_password = lv_decrypted_pwd.

    CALL FUNCTION 'SUSR_INTERNET_USERSWITCH'
      EXPORTING
        USERNAME                          = lv_username
        PASSWORD                          = lv_password
     EXCEPTIONS
       CURRENT_USER_NOT_SERVICETYP       = 0
       MORE_THAN_ONE_MODE                = 2
       INTERNAL_ERROR                    = 3
       OTHERS                            = 4 .

    IF sy-subrc EQ 0.
      rv_user_changed = abap_true.
    ENDIF.

    DATA(lv_access_token) = |{ lv_username }:{ lv_decrypted_pwd }|.

    CALL METHOD cl_http_utility=>if_http_utility~encode_base64(
      EXPORTING
        unencoded = lv_access_token
      RECEIVING
        encoded   = rv_access_token
                    ).
  ENDMETHOD.


  METHOD check_sicf_user.
    CHECK lcl_icf=>check_if_sicf_user( EXPORTING iv_url = lcl_shopfloor=>get_frontend_url( ) iv_username = iv_username )
      OR  lcl_icf=>check_if_sicf_user( EXPORTING iv_url = lcl_shopfloor=>get_backend_url( ) iv_username = iv_username ).

    rv_valid = abap_true.
  ENDMETHOD.


  METHOD CONVERT_FROM_BASE64_URL.
    DATA lv_value TYPE string.

    lv_value = iv_base64.

    REPLACE ALL OCCURRENCES OF '-' IN lv_value WITH '+'.
    REPLACE ALL OCCURRENCES OF '_' IN lv_value WITH '/'.

    lv_value = |{ lv_value }{ '==' }|.

    lv_value = cl_http_utility=>decode_base64( encoded = lv_value ).

    rv_string = lv_value.
  ENDMETHOD.


  METHOD convert_to_base64_url.
    DATA lv_value TYPE string.

    IF iv_string IS NOT INITIAL.
      lv_value = iv_string.

      lv_value = cl_http_utility=>encode_base64( unencoded = lv_value ).
    ELSE.
      lv_value = iv_base64.
    ENDIF.

    REPLACE ALL OCCURRENCES OF '=' IN lv_value WITH ''.
    REPLACE ALL OCCURRENCES OF '+' IN lv_value WITH '-'.
    REPLACE ALL OCCURRENCES OF '/' IN lv_value WITH '_'.

    rv_encoded = lv_value.
  ENDMETHOD.


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
    ).

    DATA(lv_encoded_header) = convert_to_base64_url( iv_string = lv_header ).

    DATA(lv_encoded_payload) = convert_to_base64_url( iv_string = lv_payload ).

    DATA(lv_signature) = generate_signature( EXPORTING iv_header = lv_encoded_header iv_payload = lv_encoded_payload ).

    DATA(lv_encoded_signature) = convert_to_base64_url( iv_base64 = lv_signature ).

    rv_token = |{ lv_encoded_header }.{ lv_encoded_payload }.{ lv_encoded_signature }|.

    rv_token = encrypt_token( iv_token = rv_token ).
  ENDMETHOD.


  METHOD decrypt_token.
    DATA: lv_key  TYPE xstring,
          lv_data TYPE xstring.

    lv_key = cl_bcs_convert=>string_to_xstring( iv_string = gv_jwt_token_encryption_key ).

    lv_data = CONV xstring( iv_token ).

    DATA lv_decrypted_token TYPE xstring.
    DATA lv_decrypted_tokenv TYPE string.

    cl_sec_sxml_writer=>decrypt(
                 EXPORTING
                   ciphertext  = lv_data
                   key        = lv_key
                   algorithm  = cl_sec_sxml_writer=>co_aes128_algorithm_pem
                 IMPORTING
                   plaintext = lv_decrypted_token ).

    cl_bcs_convert=>xstring_to_string(
        EXPORTING
          iv_xstr   = lv_decrypted_token
          iv_cp     =  1100
        RECEIVING
          rv_string = lv_decrypted_tokenv
      ).

    rv_token = CONV string( lv_decrypted_tokenv ).
  ENDMETHOD.


  METHOD encrypt_token.
    DATA: lv_key  TYPE xstring,
          lv_data TYPE xstring.

    lv_key = cl_bcs_convert=>string_to_xstring( iv_string = gv_jwt_token_encryption_key ).

    lv_data = cl_bcs_convert=>string_to_xstring( iv_string = iv_token ).

    DATA lv_encrypted_token TYPE xstring.

    cl_sec_sxml_writer=>encrypt(
             EXPORTING
               plaintext  = lv_data
               key        = lv_key
               algorithm  = cl_sec_sxml_writer=>co_aes128_algorithm_pem
             IMPORTING
               ciphertext = lv_encrypted_token  ).

    rv_token = CONV string( lv_encrypted_token ).
  ENDMETHOD.


  METHOD generate_header.
    DATA: ls_jwt  TYPE ty_header,
          lv_json TYPE string.

    ls_jwt-alg = 'HS256'.
    ls_jwt-typ = 'JWT'.

    lv_json = /ui2/cl_json=>serialize( data = ls_jwt compress = abap_true pretty_name = /ui2/cl_json=>pretty_mode-low_case ).

    rv_json = lv_json.
  ENDMETHOD.


  METHOD generate_payload.
    DATA: ls_jwt  TYPE ty_payload,
          lv_json TYPE string.

    " Set Claims
    ls_jwt-username = iv_username.
    ls_jwt-name = iv_name.
    ls_jwt-role = iv_role.
    ls_jwt-center = iv_center.
    ls_jwt-area = iv_area.
    ls_jwt-language = iv_language.
    ls_jwt-usererpid = iv_usererpid.

    generate_payload_iat_exp( IMPORTING ev_iat = ls_jwt-iat ev_exp = ls_jwt-exp ).

    lv_json = /ui2/cl_json=>serialize( data = ls_jwt compress = abap_true pretty_name = /ui2/cl_json=>pretty_mode-low_case ).

    rv_json = lv_json.
  ENDMETHOD.


  METHOD generate_payload_iat_exp.
    DATA: lv_systemtz TYPE timezone,
          lv_iat      TYPE timestamp,
          lv_exp      TYPE timestamp.

    IF iv_iat IS INITIAL.
      lv_iat = sy-datum.
      GET TIME STAMP FIELD lv_iat.
    ELSE.
      lv_iat = iv_iat.
    ENDIF.

    CALL FUNCTION 'GET_SYSTEM_TIMEZONE'
      IMPORTING
        timezone = lv_systemtz.

    " Set expiry time to 24 hours later
    CALL FUNCTION 'TIMESTAMP_DURATION_ADD'
      EXPORTING
        timestamp_in  = lv_iat
        timezone      = lv_systemtz
        duration      = '24'
        unit          = 'H'
      IMPORTING
        timestamp_out = lv_exp.

    ev_iat = |{ lv_iat TIMESTAMP = ISO }Z|.
    ev_exp = |{ lv_exp TIMESTAMP = ISO }Z|.
  ENDMETHOD.


  METHOD generate_signature.
    DATA(lv_data) = |{ iv_header }.{ iv_payload }|.

    cl_abap_hmac=>calculate_hmac_for_char(
           EXPORTING
             if_algorithm     = 'SHA256'
             if_key           = cl_abap_hmac=>string_to_xstring( 'leica-shopfloor-demo-key' )
             if_data          = lv_data
           IMPORTING
             ef_hmacb64string = DATA(lv_hmacb64string) ).

    rv_signature = lv_hmacb64string.
  ENDMETHOD.


METHOD get_actions.

  DATA(lv_username) = iv_username.
*  TRANSLATE lv_username TO UPPER CASE.

  SELECT routename, actionid, parentid
  FROM zsf_actions
  INTO TABLE @DATA(lt_actions)
  WHERE username EQ @lv_username
  ORDER BY id ASCENDING.

  ev_actions = /ui2/cl_json=>serialize( data = lt_actions compress = abap_false pretty_name = /ui2/cl_json=>pretty_mode-camel_case ).

ENDMETHOD.


METHOD get_activityofobjects.
  DATA(lv_username) = iv_username.
*  TRANSLATE lv_username TO UPPER CASE.

  SELECT objects~profileid AS authorizationprofileid,
         objects~objectid AS authorizationobjectid,
         objects~activitytypeid AS authorizationactivitytypeid,
         activities~description AS authorizationactivitytypedesc,
         objects~checked AS checked
    FROM zsf_authroleuser AS roles
    LEFT JOIN zsf_authprofrole AS profiles
      ON roles~roleid EQ profiles~roleid
    LEFT JOIN zsf_authactobj AS objects
    ON profiles~profileid EQ objects~profileid
    LEFT OUTER JOIN zsf_authact AS activities
    ON objects~activitytypeid EQ activities~id
    INTO TABLE @DATA(lt_authactobj)
    WHERE roles~username EQ @lv_username
    AND objects~checked EQ 'X'.


*  SELECT objects~profileid AS authorizationprofileid,
*         objects~objectid AS authorizationobjectid,
*         objects~activitytypeid AS authorizationactivitytypeid,
*         activities~description AS authorizationactivitytypedesc,
*         objects~checked AS checked
*  FROM zsf_authroleuser AS roles
*  LEFT OUTER JOIN zsf_authprofrole AS profiles
*    ON roles~roleid EQ profiles~roleid
*  LEFT OUTER JOIN zsf_authactobj AS objects
*    ON profiles~profileid EQ objects~profileid
*  LEFT OUTER JOIN zsf_authact AS activities
*    ON objects~activitytypeid EQ activities~id
*  INTO TABLE @DATA(lt_authactobj)
*  WHERE roles~username EQ @lv_username
*  AND objects~checked EQ 'X'.
*
*  " Overwrite authorizationactivitytypeid for user 1
*  IF lv_username EQ '1'.
*    LOOP AT lt_authactobj TRANSPORTING NO FIELDS WHERE authorizationobjectid EQ 'PMMain'.
*      lt_authactobj[ sy-tabix ]-authorizationactivitytypeid = 0.
*    ENDLOOP.
*  ENDIF.
*
*  LOOP AT lt_authactobj ASSIGNING FIELD-SYMBOL(<fs_authactobj>).
*    CALL FUNCTION 'ISP_CONVERT_FIRSTCHARS_TOUPPER'
*      EXPORTING
*        input_string  = <fs_authactobj>-authorizationactivitytypedesc
**       SEPARATORS    = ' -.,;:'
*      IMPORTING
*        output_string = <fs_authactobj>-authorizationactivitytypedesc.
*
*  ENDLOOP.

  ev_authactobj = /ui2/cl_json=>serialize( data = lt_authactobj compress = abap_false pretty_name = /ui2/cl_json=>pretty_mode-camel_case ).
ENDMETHOD.


METHOD get_authorizationrolesuser.
  DATA(lv_username) = iv_username.
*  TRANSLATE lv_username TO UPPER CASE.

  SELECT username, roleid AS authorizationroleid
    FROM zsf_authroleuser
    INTO table @DATA(lt_authroleuser)
    WHERE username EQ @lv_username.

  IF iv_serializejson EQ 'X'.
    ev_authroleuser = /ui2/cl_json=>serialize( data = lt_authroleuser compress = abap_false pretty_name = /ui2/cl_json=>pretty_mode-camel_case ).
  ELSE.

    READ TABLE lt_authroleuser INDEX 1 INTO data(ls_authroleuser).
    es_authrole = ls_authroleuser-authorizationroleid.
  ENDIF.
ENDMETHOD.


  METHOD get_claim.
    SPLIT iv_token AT '.' INTO TABLE DATA(lv_partials).

    DATA(lv_payload_json) = convert_from_base64_url( lv_partials[ 2 ] ).

    DATA ls_payload TYPE ty_payload.

    /ui2/cl_json=>deserialize( EXPORTING json = lv_payload_json pretty_name = /ui2/cl_json=>pretty_mode-low_case CHANGING data = ls_payload ).

    DATA: lt_jwt_claims TYPE STANDARD TABLE OF ty_payload.

    APPEND ls_payload TO lt_jwt_claims.

    " Get desired claim and return it
    FIELD-SYMBOLS <comp> TYPE any.
    ASSIGN COMPONENT iv_claim OF STRUCTURE ls_payload TO <comp>.

    READ TABLE lt_jwt_claims TRANSPORTING NO FIELDS WITH KEY (iv_claim) = <comp>.

    rv_value = <comp>.
  ENDMETHOD.


  METHOD GET_CLAIMS.
    SPLIT iv_token AT '.' INTO TABLE DATA(lv_partials).

    DATA(lv_payload_json) = convert_from_base64_url( lv_partials[ 2 ] ).

    DATA ls_payload TYPE ty_payload.

    /ui2/cl_json=>deserialize( EXPORTING json = lv_payload_json pretty_name = /ui2/cl_json=>pretty_mode-low_case CHANGING data = ls_payload ).

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


  METHOD get_hashed_password.
    DATA(lv_binary_secret) = cl_abap_hmac=>string_to_xstring( gv_password_signing_key ).

    cl_abap_hmac=>calculate_hmac_for_char(
        EXPORTING
            if_algorithm = 'SHA256'
            if_key       = lv_binary_secret
            if_data      = iv_password
        IMPORTING
            ef_hmacstring = rv_hashed_password
    ).
  ENDMETHOD.


  METHOD get_jwt_from_cookie.
    DATA: lo_server TYPE REF TO cl_http_server_net.
    FIELD-SYMBOLS: <server> TYPE any.
    ASSIGN ('(SAPLHTTP_RUNTIME)server_accepted') TO <server>.
    CHECK: <server> IS ASSIGNED.
    lo_server ?= <server>.
    lo_server->request->get_cookie( EXPORTING name = 'token' IMPORTING value = rv_token ).
  ENDMETHOD.


  METHOD get_shopfloor_sicf_user.
    " URLs:
    "   /sap/bc/ui5_ui5/sap/zshopf_sapui5
    "   /sap/opu/odata/sap/z_sf_odata_service_srv

    SELECT low
      FROM zbc_fixval_t
      INTO TABLE @DATA(lt_url)
      WHERE module_sap   EQ 'PP'
        AND parameter_id EQ 'SICF_URL'.

    DATA lv_user TYPE syuname.
    LOOP AT lt_url ASSIGNING FIELD-SYMBOL(<lv_url>).
      DATA(lv_url) = CONV string( <lv_url> ).

      CALL FUNCTION 'HTTP_SERVICE_GET_LOGON_DATA'
        EXPORTING
          url                  = lv_url
        IMPORTING
          icf_user             = lv_user
        EXCEPTIONS
          invalid_url          = 1
          empty_nodguid_or_url = 2
          OTHERS               = 3.
      CHECK sy-subrc IS INITIAL.

      APPEND lv_user TO rt_users.
    ENDLOOP.

    CHECK rt_users[] IS NOT INITIAL.

    DATA(lr_users) = VALUE rsjobruser( FOR u IN rt_users ( sign = 'I' option = 'EQ' low = u ) ).

    SELECT bname
      FROM usr01
      INTO TABLE rt_users
      WHERE bname IN lr_users.
  ENDMETHOD.


  METHOD get_shopfloor_users.
    SELECT 'I' AS sign, 'EQ' AS option, usersap AS low, '            ' as high
      FROM zsf_userssap
      INTO TABLE @DATA(lr_users).

    CHECK lr_users[] IS NOT INITIAL.

    SELECT bname
      FROM usr01
      INTO TABLE rt_users
      WHERE bname IN lr_users.
  ENDMETHOD.


  METHOD is_shopfloor_user.
    DATA(lt_users) = get_shopfloor_users( ).
    APPEND LINES OF get_shopfloor_sicf_user( ) TO lt_users.

    CHECK line_exists( lt_users[ table_line = iv_username ] ).
    rv_return = abap_true.
  ENDMETHOD.


  method NEW_CHANGE_SAP_USER.
    SELECT SINGLE b~usersap AS username, b~password AS password
      INTO @DATA(ls_usersap)
      FROM zsf_users AS a
      LEFT JOIN zsf_userssap AS b
      ON a~usersap EQ b~usersap
      WHERE a~username EQ @iv_username.

    CHECK ls_usersap IS NOT INITIAL.

    IF ls_usersap-username EQ sy-uname.
      rv_user_changed = abap_true.
      RETURN.
    ENDIF.

    DATA(lv_decrypted_pwd) = lcl_utils=>decrypt( iv_data = CONV string( ls_usersap-password )
                                                 iv_key  = |{ lcl_shopfloor=>get_password_encryption_key( ) }| ).

    DATA ls_bname TYPE ususername.
    CALL FUNCTION 'SUSR_INTERNET_USERSWITCH'
      EXPORTING
        username           = CONV bapibname-bapibname( ls_usersap-username )
        password           = CONV bapipwd( lv_decrypted_pwd )
      IMPORTING
        bname_after_switch = ls_bname
     EXCEPTIONS
       CURRENT_USER_NOT_SERVICETYP       = 0
       OTHERS                            = 4.

    CHECK sy-subrc EQ 0.
    rv_user_changed = abap_true.
  endmethod.


  method NEW_CREATE_TOKEN.
    rv_token = lcl_jwt_token=>create_token(
        EXPORTING
            iv_username  = iv_username
            iv_name      = iv_name
            iv_role      = iv_role
            iv_center    = iv_center
            iv_area      = iv_area
            iv_language  = iv_language
            iv_usererpid = iv_usererpid
            iv_duration  = CONV i( |{ lcl_shopfloor=>get_token_duration_value( ) }| )
            iv_unit      = |{ lcl_shopfloor=>get_token_duration_unit( ) }|
            iv_signing_key = |{ lcl_shopfloor=>get_token_signing_key( ) }|
            iv_encryption_key = |{ lcl_shopfloor=>get_token_encryption_key( ) }| ).
  endmethod.


  method NEW_GET_CLAIM.
    rv_value = lcl_jwt_token=>get_claim( EXPORTING iv_token = iv_token
                                                   iv_claim = iv_claim
                                                   iv_encryption_key = |{ lcl_shopfloor=>get_token_encryption_key( ) }| ).
  endmethod.


  method NEW_GET_CLAIMS.
    rt_values = lcl_jwt_token=>get_claims( EXPORTING iv_token = iv_token
                                                     iv_encryption_key = |{ lcl_shopfloor=>get_token_encryption_key( ) }| ).
  endmethod.


  method NEW_GET_DEFAULT_SAP_USER_TOKEN.
    rv_default_token = |{ lcl_shopfloor=>get_DEFAULT_SAP_USER_TOKEN( ) }|.
  endmethod.


  method NEW_GET_HASHED_PASSWORD.
    rv_hashed_password = lcl_utils=>calculate_hash( EXPORTING iv_data = iv_password
                                                              iv_key  = |{ lcl_shopfloor=>get_password_signing_key( ) }| ).
  endmethod.


  method NEW_GET_TOKEN_COOKIE.
    rv_value = lcl_http=>get_cookie( `token` ).
  endmethod.


  method NEW_SET_TOKEN_COOKIE.
    lcl_http=>set_cookie( iv_name = `token`
                        iv_secure = CONV #( |{ lcl_shopfloor=>is_https_enabled( ) }| )
                        iv_value = iv_value ).
  endmethod.


  METHOD new_update_sap_user_pwd.
    DATA(LV_USERNAME) = to_upper( val = iv_username ).

    " Update user for the OData service
    lcl_icf=>update_sicf_login(
      iv_url      = CONV string( |{ lcl_shopfloor=>get_backend_url( ) }| )
      iv_username = CONV syuname( LV_USERNAME )
      iv_password = CONV icfpasswd( iv_password ) ).

    " Update the user for the UI5 BSP repository
    lcl_icf=>update_sicf_login(
      iv_url      = CONV string( |{ lcl_shopfloor=>get_frontend_url( ) }| )
      iv_username = CONV syuname( lv_username )
      iv_password = CONV icfpasswd( iv_password ) ).

    " Update the default user in the shopfloor OData config table
    IF lcl_icf=>check_if_sicf_user( EXPORTING iv_url = |{ lcl_shopfloor=>get_backend_url( ) }| iv_username = CONV syuname( lv_username ) ) EQ abap_true.
        LCL_SHOPFLOOR=>UPDATE_DEFAULT_SAP_USER_TOKEN( |Basic { cl_http_utility=>encode_base64( |{ lv_username }:{ iv_password }| ) }| ).
    ENDIF.

    " Update the SAP users table for the shopfloor service
    DATA(lv_encrypted_pwd) = lcl_utils=>encrypt( iv_data = CONV string( iv_password )
                                                 iv_key  = |{ lcl_shopfloor=>get_password_encryption_key( ) }| ).

    UPDATE zsf_userssap SET password  = lv_encrypted_pwd
                        WHERE usersap = lv_username.
  ENDMETHOD.


  method NEW_VALIDATE_TOKEN.
    IF strlen( iv_token ) GT 0.
      rv_valid = lcl_jwt_token=>validate_token( iv_token = iv_token
                                                iv_duration = CONV i( |{ lcl_shopfloor=>get_token_duration_value( ) }| )
                                                iv_unit = |{ lcl_shopfloor=>get_token_duration_unit( ) }|
                                                iv_encryption_key = |{ lcl_shopfloor=>get_token_encryption_key( ) }|
                                                iv_signing_key = |{ lcl_shopfloor=>get_token_signing_key( ) }| ).
    ENDIF.
  endmethod.


  METHOD set_token_cookie.
    DATA: lo_server TYPE REF TO cl_http_server_net.
    FIELD-SYMBOLS: <server> TYPE any.
    ASSIGN ('(SAPLHTTP_RUNTIME)server_accepted') TO <server>.
    CHECK: <server> IS ASSIGNED.
    lo_server ?= <server>.
    lo_server->response->set_cookie(
      EXPORTING
        "domain       = 'token'
        "expires       = 'token'
        name       = 'token'
        path       = '/'
        secure     = 0  " 0 = HTTP || 1 = HTTPS
        value      = iv_token
    ).
  ENDMETHOD.


  METHOD update_sap_user_pwd.
    DATA: lv_data          TYPE xstring,
          lv_key           TYPE xstring,
          lv_encrypted_pwd TYPE xstring.

    lv_key = cl_bcs_convert=>string_to_xstring( iv_string = gv_password_encryption_key ).

    lv_data = cl_bcs_convert=>string_to_xstring( iv_string = iv_password ).

    cl_sec_sxml_writer=>encrypt(
             EXPORTING
               plaintext  = lv_data
               key        = lv_key
               algorithm  = cl_sec_sxml_writer=>co_aes128_algorithm_pem
             IMPORTING
               ciphertext = lv_encrypted_pwd  ).

    UPDATE zsf_userssap SET password = lv_encrypted_pwd
                         WHERE usersap = iv_username.
  ENDMETHOD.


  METHOD upd_login_controller.
    DATA lt_content TYPE o2pageline_table.

    SELECT line, low
      FROM zbc_fixval_t
      INTO TABLE @DATA(lt_fixval)
      WHERE module_sap   EQ 'PP'
        AND parameter_id EQ 'LOGIN_CONTROLLER'.

    DATA(ls_key) =
      VALUE o2pconkey(
        applname = |{ lt_fixval[ line = 1 ]-low CASE = UPPER }| "ZSHOPF_SAPUI5
        pagekey  = |{ lt_fixval[ line = 2 ]-low CASE = UPPER }| "CONTROLLER/LOGIN.CONTROLLER.JS
        objtype  = 'PD'
        version  = 'I'
      ).

    IMPORT content = lt_content
      FROM DATABASE o2pagcon(tr) ID ls_key.

    DATA(lv_basicauthdetail) = |("basicAuthDetails","Basic { iv_basicauthdetails }")|.

    REPLACE FIRST OCCURRENCE OF
      REGEX '\("basicAuthDetails","Basic[[:space:][:alnum:]]+"\)'
      IN TABLE lt_content
      WITH |("basicAuthDetails","Basic { iv_basicauthdetails }")|
      IN CHARACTER MODE.

    EXPORT content = lt_content
      TO DATABASE o2pagcon(tr) ID ls_key.
  ENDMETHOD.


  METHOD upd_shopfloor_user_password.
    DATA(lt_users) = get_shopfloor_users( ).

    IF line_exists( lt_users[ table_line = iv_username ] ).
      update_sap_user_pwd(
        iv_username = CONV #( iv_username )
        iv_password = CONV #( iv_password ) ).
    ENDIF.

    lt_users = get_shopfloor_sicf_user( ).
    IF line_exists( lt_users[ table_line = iv_username ] ).
      upd_login_controller( cl_http_utility=>if_http_utility~encode_base64( |{ iv_username }:{ iv_pwd_hash }| ) ).

      upd_sicf_login(
        iv_username = iv_username
        iv_password = iv_password ).
    ENDIF.

    COMMIT WORK AND WAIT.
  ENDMETHOD.


  METHOD upd_sicf_login.
    " URLs:
    "   /sap/bc/ui5_ui5/sap/zshopf_sapui5
    "   /sap/opu/odata/sap/z_sf_odata_service_srv

    SELECT low
      FROM zbc_fixval_t
      INTO TABLE @DATA(lt_url)
      WHERE module_sap   EQ 'PP'
        AND parameter_id EQ 'SICF_URL'.

    DATA lv_user TYPE syuname.
    LOOP AT lt_url ASSIGNING FIELD-SYMBOL(<lv_url>).
      DATA(lv_url) = CONV string( <lv_url> ).

      CALL FUNCTION 'HTTP_SERVICE_GET_LOGON_DATA'
        EXPORTING
          url                  = lv_url
        IMPORTING
          icf_user             = lv_user
        EXCEPTIONS
          invalid_url          = 1
          empty_nodguid_or_url = 2
          OTHERS               = 3.
      CHECK sy-subrc IS INITIAL
        AND lv_user EQ iv_username.

      CALL FUNCTION 'HTTP_SERVICE_SET_LOGON_DATA'
        EXPORTING
          url                  = lv_url
          icf_user             = lv_user
          icf_passwd           = iv_password
        EXCEPTIONS
          invalid_url          = 1
          error_change_node    = 2
          empty_nodguid_or_url = 3
          OTHERS               = 4.
    ENDLOOP.
  ENDMETHOD.


  METHOD validate_token.
    TRY.
        DATA(lv_token) = decrypt_token( iv_token = iv_token ).
      CATCH cx_root INTO DATA(lr_token_err).
        rv_valid = abap_false.
        RETURN.
    ENDTRY.

    SPLIT lv_token AT '.' INTO TABLE DATA(lv_partials).

    " The token HAS ro have 3 parts: header, payload and signature
    IF lines( lv_partials ) NE 3.
      rv_valid = abap_false.
      RETURN.
    ENDIF.

    " Check header
    DATA(lv_header_json) = convert_from_base64_url( lv_partials[ 1 ] ).

    DATA ls_header TYPE ty_header.

    /ui2/cl_json=>deserialize( EXPORTING json = lv_header_json pretty_name = /ui2/cl_json=>pretty_mode-low_case CHANGING data = ls_header ).

    IF ls_header-typ NE 'JWT'.
      rv_valid = abap_false.
      RETURN.
    ENDIF.

    IF ls_header-alg NE 'HS256'.
      rv_valid = abap_false.
      RETURN.
    ENDIF.

    " Check signature
    DATA(lv_signature) = generate_signature( EXPORTING iv_header = lv_partials[ 1 ] iv_payload = lv_partials[ 2 ] ).

    DATA(lv_encoded_signature) = convert_to_base64_url( iv_base64 = lv_signature ).

    IF lv_encoded_signature NE lv_partials[ 3 ].
      rv_valid = abap_false.
      RETURN.
    ENDIF.

    " Check payload
    DATA(lv_payload_json) = convert_from_base64_url( lv_partials[ 2 ] ).

    DATA ls_payload TYPE ty_payload.

    /ui2/cl_json=>deserialize( EXPORTING json = lv_payload_json pretty_name = /ui2/cl_json=>pretty_mode-low_case CHANGING data = ls_payload ).

    " Additional payload verification
    " Check if expiry is before current datetime
    GET TIME STAMP FIELD DATA(lv_current_datetime).

    TRY.
        DATA(lv_jwt_iat) = cl_xlf_date_time=>parse( EXPORTING iso8601 = ls_payload-iat ).
        DATA(lv_jwt_exp) = cl_xlf_date_time=>parse( EXPORTING iso8601 = ls_payload-exp ).
      CATCH cx_root.
        rv_valid = abap_false.
        RETURN.
    ENDTRY.

    IF lv_current_datetime LT lv_jwt_iat.
      rv_valid = abap_false.
      RETURN.
    ENDIF.

    generate_payload_iat_exp( EXPORTING iv_iat = lv_jwt_iat IMPORTING ev_exp = DATA(lv_desired_expiry) ).

    IF ls_payload-exp NE lv_desired_expiry.
      rv_valid = abap_false.
      RETURN.
    ENDIF.

    IF lv_current_datetime GT lv_jwt_exp.
      rv_valid = abap_false.
      RETURN.
    ENDIF.

    rv_valid = abap_true.
  ENDMETHOD.
ENDCLASS.
