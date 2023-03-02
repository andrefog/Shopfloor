*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lcl_utils DEFINITION
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS get_method_name
      IMPORTING
        !iv_callstack         TYPE i OPTIONAL
      RETURNING
        VALUE(rv_method_name) TYPE string .
    CLASS-METHODS copy_data_to_ref
      IMPORTING
        !is_data       TYPE any
      RETURNING
        VALUE(rr_data) TYPE REF TO data .
    CLASS-METHODS validatesapresponse
      IMPORTING
        !it_result TYPE bapiret2_t
      CHANGING
        !co_msg    TYPE REF TO /iwbep/if_message_container
      RAISING
        /iwbep/cx_mgw_busi_exception .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS lcl_utils IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_UTILS=>COPY_DATA_TO_REF
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_DATA                        TYPE        ANY
* | [<-()] RR_DATA                        TYPE REF TO DATA
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD copy_data_to_ref.
    FIELD-SYMBOLS <fs_entity> TYPE any.

    CREATE DATA rr_data LIKE is_data.
    ASSIGN rr_data->* TO <fs_entity>.

    <fs_entity> = is_data.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_UTILS=>GET_METHOD_NAME
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
* | Static Public Method LCL_UTILS=>VALIDATESAPRESPONSE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_RESULT                      TYPE        BAPIRET2_T
* | [<-->] CO_MSG                         TYPE REF TO /IWBEP/IF_MESSAGE_CONTAINER
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD validatesapresponse.
    DATA(lv_method_name) = get_method_name( 3 ).

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
*            IV_ADD_TO_RESPONSE_HEADER = abap_true
*            IV_IS_LEADING_MESSAGE = CONV #( lv_error_msg ).

        " Raising Exception
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            message_container = co_msg.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_helper_authprofile DEFINITION
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS get_authorizationobjects
      IMPORTING
        !is_inputobj   TYPE zabsf_pp_s_inputobject
        !it_keys       TYPE /iwbep/t_mgw_tech_pairs
        !iv_jwt_token  TYPE string
      EXPORTING
        !et_entity_set TYPE zabsf_cl_odata=>tt_authorizationobject.

    CLASS-METHODS get_authorizationactivityofobs
      IMPORTING
        !is_inputobj   TYPE zabsf_pp_s_inputobject
        !it_keys       TYPE /iwbep/t_mgw_tech_pairs
        !iv_jwt_token  TYPE string
      EXPORTING
        !et_entity_set TYPE zabsf_cl_odata=>tt_authorizationactivityofobje.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS lcl_helper_authprofile IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_HELPER_AUTHPROFILE=>GET_AUTHORIZATIONOBJECTS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_INPUTOBJ                    TYPE        ZABSF_PP_S_INPUTOBJECT
* | [--->] IT_KEYS                        TYPE        /IWBEP/T_MGW_TECH_PAIRS
* | [--->] IV_JWT_TOKEN                   TYPE        STRING
* | [<---] ET_ENTITY_SET                  TYPE        ZABSF_CL_ODATA=>TT_AUTHORIZATIONOBJECT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_authorizationobjects.
    DATA: ls_result TYPE zabsf_cl_odata=>ty_authorizationobject,
          lt_result TYPE zabsf_cl_odata=>tt_authorizationobject.

    READ TABLE it_keys INTO DATA(ls_profileid) WITH KEY name = 'AUTHORIZATIONPROFILEID'.
    READ TABLE it_keys INTO DATA(ls_objectid) WITH KEY name = 'AUTHORIZATIONOBJECTID'.

    SELECT *
      FROM zsf_authobj
    WHERE profileid EQ @ls_profileid-value
    INTO TABLE @DATA(lt_authobj).

    LOOP AT lt_authobj INTO DATA(ls_authobj).
      CLEAR ls_result.
      DATA(lt_keys) = it_keys.
      APPEND VALUE #( name = 'AUTHORIZATIONOBJECTID' value = ls_authobj-objectid ) TO lt_keys.

      CALL METHOD lcl_helper_authprofile=>get_authorizationactivityofobs
        EXPORTING
          is_inputobj   = is_inputobj
          it_keys       = lt_keys
          iv_jwt_token  = iv_jwt_token
        IMPORTING
          et_entity_set = ls_result-authorizationactivitiesofobje.

      ls_result-authorizationprofileid = ls_authobj-profileid.
      ls_result-authorizationobjectid = ls_authobj-objectid.

      APPEND ls_result TO lt_result.
    ENDLOOP.

    et_entity_set = lt_result.
  ENDMETHOD.

* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_HELPER_AUTHPROFILE=>GET_AUTHORIZATIONACTIVITYOFOBS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_INPUTOBJ                    TYPE        ZABSF_PP_S_INPUTOBJECT
* | [--->] IT_KEYS                        TYPE        /IWBEP/T_MGW_TECH_PAIRS
* | [--->] IV_JWT_TOKEN                   TYPE        STRING
* | [<---] ET_ENTITY_SET                  TYPE        ZABSF_CL_ODATA=>TT_AUTHORIZATIONACTIVITYOFOBJE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_authorizationactivityofobs.
    READ TABLE it_keys INTO DATA(ls_profileid) WITH KEY name = 'AUTHORIZATIONPROFILEID'.
    READ TABLE it_keys INTO DATA(ls_objectid) WITH KEY name = 'AUTHORIZATIONOBJECTID'.
    READ TABLE it_keys INTO DATA(ls_activitytypeid) WITH KEY name = 'AUTHORIZATIONACTIVITYTYPEID'.

    SELECT * FROM zsf_authactobj
      WHERE profileid EQ @ls_profileid-value
        AND objectid EQ @ls_objectid-value
      INTO TABLE @DATA(lt_authactobj).

    IF ls_activitytypeid-value IS NOT INITIAL.
      DELETE lt_authactobj WHERE activitytypeid NE ls_activitytypeid-value.
    ENDIF.

    et_entity_set = VALUE #( FOR ls_authactobj IN lt_authactobj ( authorizationprofileid = ls_authactobj-profileid
                                                                  authorizationobjectid = ls_authactobj-objectid
                                                                  authorizationactivitytypeid = ls_authactobj-activitytypeid
                                                                  checked = ls_authactobj-checked ) ).
  ENDMETHOD.
ENDCLASS.


CLASS lcl_workday DEFINITION
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    DATA:
      gt_return      TYPE bapiret2_t,
      gs_inputobj    TYPE zabsf_pp_s_inputobject,
      gt_pp001       TYPE STANDARD TABLE OF zabsf_pp001 WITH DEFAULT KEY,
      gt_pp010       TYPE STANDARD TABLE OF zabsf_pp010 WITH DEFAULT KEY,
      gt_hierarchies TYPE zabsf_pp_t_wrkctr,
      gt_aufk        TYPE STANDARD TABLE OF aufk WITH DEFAULT KEY,
      gv_tabix       TYPE sy-tabix,
      gv_shiftid     TYPE zabsf_pp_e_shiftid.

    METHODS constructor
      IMPORTING is_inputobj TYPE zabsf_pp_s_inputobject.

    METHODS parse_file
      IMPORTING it_content TYPE zabsf_cl_odata=>tt_contentcsv
      EXPORTING et_workday TYPE zabsf_pp_t_workday.

    METHODS get_order_type
      IMPORTING it_workday TYPE zabsf_pp_t_workday.

    METHODS set_tabix
      IMPORTING iv_tabix TYPE sy-tabix.

    METHODS check_required_field
      IMPORTING iv_field        TYPE text50
                iv_value        TYPE any
      RETURNING VALUE(rv_valid) TYPE boolean.

    METHODS set_shiftid
      IMPORTING is_workday      TYPE zabsf_pp_s_workday
      RETURNING VALUE(rv_valid) TYPE boolean.

    METHODS add_stop
      IMPORTING VALUE(is_workday) TYPE zabsf_pp_s_workday.

    METHODS add_good_quantity
      IMPORTING VALUE(is_workday) TYPE zabsf_pp_s_workday.

    METHODS add_rework_scrap_quantity
      IMPORTING VALUE(is_workday) TYPE zabsf_pp_s_workday.

    METHODS get_hierarchy_for_workcenter
      IMPORTING iv_arbpl        TYPE arbpl
      RETURNING VALUE(rv_hname) TYPE cr_hname.

    METHODS save_stops.

    METHODS convert_time
      CHANGING cv_time TYPE string.

    METHODS convert_date
      CHANGING cv_date TYPE string.
ENDCLASS.

CLASS lcl_workday IMPLEMENTATION.
  METHOD constructor.
    gs_inputobj = is_inputobj.

    SELECT *
      FROM zabsf_pp001
      INTO TABLE gt_pp001
      WHERE werks  EQ is_inputobj-werks
        AND areaid EQ is_inputobj-areaid.
  ENDMETHOD.

  METHOD parse_file.
    " Parse CSV file into SAP table fields
    LOOP AT it_content ASSIGNING FIELD-SYMBOL(<ls_content>).
      SPLIT <ls_content>-content AT cl_abap_char_utilities=>cr_lf INTO TABLE DATA(lt_content).

      LOOP AT lt_content ASSIGNING FIELD-SYMBOL(<ls_content_>).
        APPEND INITIAL LINE TO et_workday ASSIGNING FIELD-SYMBOL(<ls_workday>).
        SPLIT <ls_content_> AT ';' INTO TABLE DATA(lt_values).

        LOOP AT lt_values ASSIGNING FIELD-SYMBOL(<lv_value>).
          ASSIGN COMPONENT sy-tabix OF STRUCTURE <ls_workday> TO FIELD-SYMBOL(<ls_field>).
          CHECK sy-subrc IS INITIAL.
          <ls_field> = <lv_value>.
        ENDLOOP.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_order_type.
    DATA(lt_fae) =
      VALUE tt_aufk(
        FOR w IN it_workday
        WHERE ( aufnr IS NOT INITIAL )
        ( aufnr = |{ w-aufnr ALPHA = IN }| ) ).

    CHECK lt_fae IS NOT INITIAL.
    SORT lt_fae BY aufnr.
    DELETE ADJACENT DUPLICATES FROM lt_fae COMPARING aufnr.

    SELECT aufnr auart
      FROM aufk
      INTO TABLE gt_aufk
      FOR ALL ENTRIES IN lt_fae
      WHERE aufnr EQ lt_fae-aufnr.
  ENDMETHOD.

  METHOD set_tabix.
    gv_tabix = sy-tabix.
  ENDMETHOD.

  METHOD check_required_field.
    rv_valid = abap_true.

    CHECK iv_value IS INITIAL.

    IF 1 EQ 2. MESSAGE e170(zabsf_pp). ENDIF.
    "Field &1 in line &2 is not filled in and is required.
    zabsf_pp_cl_log=>add_message(
      EXPORTING msgty      = 'E'
                msgno      = '170'
                msgv1      = iv_field
                msgv2      = gv_tabix
      CHANGING  return_tab = gt_return ).

    rv_valid = abap_false.
  ENDMETHOD.

  METHOD set_shiftid.
    rv_valid = abap_false.
    DATA(lv_isdd)    = CONV ru_isdd( is_workday-isdd ).
    DATA(lv_isbz)    = CONV ru_isbz( is_workday-isbz ).
    DATA(lv_iebz)    = CONV ru_iebz( is_workday-iebz ).

    LOOP AT gt_pp001 ASSIGNING FIELD-SYMBOL(<ls_pp001>)
      WHERE endda       GE lv_isdd
        AND begda       LE lv_isdd
        AND shift_start LE lv_iebz
        AND shift_end   GE lv_isbz.

      gv_shiftid = <ls_pp001>-shiftid.
      rv_valid = abap_true.
      EXIT.
    ENDLOOP.
  ENDMETHOD.

  METHOD add_stop.
    " Check if any field that trigger the confirmation was filled
    CHECK is_workday-begstop  IS NOT INITIAL
      OR  is_workday-endstop  IS NOT INITIAL
      OR  is_workday-stprsnid IS NOT INITIAL.

    " Check all fields filled
    CHECK check_required_field( iv_field = TEXT-f08 iv_value = is_workday-begstop )
      AND check_required_field( iv_field = TEXT-f09 iv_value = is_workday-endstop )
      AND check_required_field( iv_field = TEXT-f10 iv_value = is_workday-stprsnid ).

    convert_time( CHANGING cv_time = is_workday-begstop ).
    convert_time( CHANGING cv_time = is_workday-endstop ).

    APPEND
      VALUE #(
        areaid   = gs_inputobj-areaid
        hname    = get_hierarchy_for_workcenter( is_workday-arbpl )
        werks    = gs_inputobj-werks
        arbpl    = is_workday-arbpl
        stprsnid = is_workday-stprsnid
        operador = is_workday-oprid
        datesr   = is_workday-isdd
        shiftid  = gv_shiftid
        time     = is_workday-begstop
        endda    = is_workday-isdd
        timeend  = is_workday-endstop
        stoptime = ( CONV t( is_workday-endstop ) - CONV t( is_workday-begstop ) ) / 60
        stopunit = 'MIN'
      ) TO gt_pp010.
  ENDMETHOD.

  METHOD add_good_quantity.
    " Confirm goods
    CHECK is_workday-lmnga IS NOT INITIAL
      AND check_required_field( iv_field = TEXT-f01 iv_value = is_workday-aufnr )
      AND check_required_field( iv_field = TEXT-f02 iv_value = is_workday-vornr ).

    DATA(lt_conf_tab) =
      VALUE zabsf_pp_t_qty_conf(
        ( aufnr = |{ is_workday-aufnr ALPHA = IN }|
          vornr = is_workday-vornr
          matnr = is_workday-matnr
          lmnga = is_workday-lmnga
          gmein = is_workday-gmein
        ) ).

    DATA(lv_tpord) = VALUE #( gt_aufk[ aufnr = is_workday-aufnr ]-auart OPTIONAL ).

    DATA(lv_refdt) = CONV datum( is_workday-isdd ).

    DATA lt_return TYPE bapiret2_t.
    CALL FUNCTION 'ZABSF_PP_SET_QUANTITY'
      EXPORTING
        arbpl        = is_workday-arbpl
        qty_conf_tab = lt_conf_tab
        tipord       = lv_tpord
        refdt        = lv_refdt
        inputobj     = gs_inputobj
        shiftid      = gv_shiftid
      IMPORTING
        return_tab   = lt_return.
    APPEND LINES OF lt_return TO gt_return.
  ENDMETHOD.

  METHOD add_rework_scrap_quantity.
    " Confirm Scrap/Rework
    CHECK is_workday-xmnga IS NOT INITIAL OR is_workday-rmnga IS NOT INITIAL
      AND check_required_field( iv_field = TEXT-f01 iv_value = is_workday-aufnr )
      AND check_required_field( iv_field = TEXT-f02 iv_value = is_workday-vornr ).

    DATA(lv_refdt) = CONV datum( is_workday-isdd ).

    DATA lt_return TYPE bapiret2_t.
    CALL FUNCTION 'ZABSF_PP_SETQUANTITY_REWORK'
      EXPORTING
        arbpl      = is_workday-arbpl
        aufnr      = |{ is_workday-aufnr ALPHA = IN }|
        vornr      = is_workday-vornr
        matnr      = is_workday-matnr
        rework_qty = is_workday-rmnga
        scrap_qty  = is_workday-xmnga
        defectid   = is_workday-defectid
        grund      = is_workday-grund
        shiftid    = gv_shiftid
        refdt      = lv_refdt
        inputobj   = gs_inputobj
      IMPORTING
        return_tab = lt_return.
    APPEND LINES OF lt_return TO gt_return.
  ENDMETHOD.

  METHOD save_stops.
    CHECK gt_pp010[] IS NOT INITIAL.

    MODIFY zabsf_pp010 FROM TABLE gt_pp010.

    IF 1 EQ 2. MESSAGE s171(zabsf_pp). ENDIF.
    "Stop entries successfully updated.
    zabsf_pp_cl_log=>add_message(
      EXPORTING msgty      = 'S'
                msgno      = '171'
      CHANGING  return_tab = gt_return ).
  ENDMETHOD.

  METHOD get_hierarchy_for_workcenter.
    IF gt_hierarchies[] IS INITIAL.
      DATA(ls_inputobj) = VALUE zabsf_pp_s_inputobject( werks = '0070' ).

      CALL FUNCTION 'ZABSF_ADM_GET_HIERARCHIES'
        EXPORTING
          inputobj                = ls_inputobj
        IMPORTING
          hierarchies_and_workcts = gt_hierarchies.
    ENDIF.

    rv_hname = VALUE #( gt_hierarchies[ arbpl = iv_arbpl ]-parent OPTIONAL ).
  ENDMETHOD.

  METHOD convert_time.
    REPLACE ALL OCCURRENCES OF ':'
      IN cv_time WITH '' IN CHARACTER MODE.
  ENDMETHOD.

  METHOD convert_date.
    CHECK cv_date CA './-'.

    IF cv_date+2(1) CA './-'.  " DD/MM/AAAA
      cv_date = cv_date+6(4) && cv_date+3(2) && cv_date(2).
    ELSE.  " AAAA/MM/DD
      cv_date = cv_date(4) && cv_date+5(2) && cv_date+8(2).
    ENDIF.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_helper_operation DEFINITION
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS helper_12
      IMPORTING
        !is_inputobj      TYPE zabsf_pp_s_inputobject
        !iv_num           TYPE i
      CHANGING
        !cs_upd_operation TYPE zabsf_cl_odata=>ty_operation
        !co_msg           TYPE REF TO /iwbep/if_message_container
      RAISING
        /iwbep/cx_mgw_busi_exception .
    CLASS-METHODS helper_81
      IMPORTING
        !is_inputobj      TYPE zabsf_pp_s_inputobject
      CHANGING
        !cs_upd_operation TYPE zabsf_cl_odata=>ty_operation
        !co_msg           TYPE REF TO /iwbep/if_message_container
      RAISING
        /iwbep/cx_mgw_busi_exception .
    CLASS-METHODS get_stopreason
      IMPORTING
        !iv_arbpl           TYPE arbpl
        !iv_aufnr           TYPE aufnr
        !iv_vornr           TYPE vornr
        !iv_status_oper     TYPE j_status
        !iv_spras           TYPE spras
      EXPORTING
        !ev_stopreason_id   TYPE string
        !ev_stopreason_desc TYPE string.
    CLASS-METHODS set_quantity_stor_location
      IMPORTING
        VALUE(arbpl)            TYPE arbpl OPTIONAL
        VALUE(qty_conf_tab)     TYPE zabsf_pp_t_qty_conf
        VALUE(tipord)           TYPE zabsf_pp_e_tipord DEFAULT 'N'
        VALUE(refdt)            TYPE vvdatum DEFAULT sy-datum
        VALUE(inputobj)         TYPE zabsf_pp_s_inputobject
        VALUE(check_stock)      TYPE flag OPTIONAL
        VALUE(first_cycle)      TYPE flag OPTIONAL
        VALUE(backoffice)       TYPE flag OPTIONAL
        VALUE(shiftid)          TYPE zabsf_pp_e_shiftid OPTIONAL
        VALUE(supervisor)       TYPE flag OPTIONAL
        VALUE(vendor)           TYPE lifnr OPTIONAL
        VALUE(materialbatch)    TYPE zabsf_pp_t_materialbatch OPTIONAL
        VALUE(materialserial)   TYPE zabsf_pp_t_materialserial OPTIONAL
        VALUE(storage_location) TYPE string OPTIONAL
      EXPORTING
        VALUE(conf_tab)         TYPE  zabsf_pp_t_confirmation
        VALUE(return_tab)       TYPE  bapiret2_t.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS lcl_helper_operation IMPLEMENTATION .


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_HELPER_OPERATION=>HELPER_12
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_INPUTOBJ                    TYPE        ZABSF_PP_S_INPUTOBJECT
* | [--->] IV_NUM                         TYPE        I
* | [<-->] CS_UPD_OPERATION               TYPE        ZABSF_CL_ODATA=>TY_OPERATION
* | [<-->] CO_MSG                         TYPE REF TO /IWBEP/IF_MESSAGE_CONTAINER
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD helper_12.
    DATA: lt_return_tab   TYPE bapiret2_t,
          lt_qty_conf_tab TYPE zabsf_pp_t_qty_conf,
          lt_conf_tab     TYPE zabsf_pp_t_confirmation.

    DATA ls_inputobj TYPE zabsf_pp_s_inputobject.
    ls_inputobj = is_inputobj.

    IF iv_num EQ 0.
      ls_inputobj-dateconf = sy-datum.
      ls_inputobj-timeconf = sy-uzeit.

      DATA(lv_first_cycle) = condense( val = cs_upd_operation-firstcycle from = `` ).

      APPEND VALUE #( aufnr = cs_upd_operation-productionorderid
                      vornr = cs_upd_operation-id
                      matnr = cs_upd_operation-oinfo-matnr
                      lmnga = cs_upd_operation-goodquantity
                      wareid = cs_upd_operation-oinfo-wareid
                      scrap_qty = cs_upd_operation-adjustmentquantity
                      numb_cycle = COND #( WHEN cs_upd_operation-goodnrcycles NE 0 THEN cs_upd_operation-goodnrcycles ) ) TO lt_qty_conf_tab.

      CALL FUNCTION 'ZABSF_PP_SET_QUANTITY_RPACK'
        EXPORTING
          arbpl        = cs_upd_operation-workcenterid
          qty_conf_tab = lt_qty_conf_tab
          tipord       = cs_upd_operation-oinfo-tipord
          refdt        = sy-datum
          inputobj     = ls_inputobj
          first_cycle  = lv_first_cycle
          supervisor   = cs_upd_operation-areaadminvalidated
        IMPORTING
          conf_tab     = lt_conf_tab
          return_tab   = lt_return_tab.

      lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return_tab CHANGING co_msg = co_msg ).

    ELSEIF cs_upd_operation-scrapquantity GT 0 OR cs_upd_operation-defectids IS NOT INITIAL.

      DATA lv_rework_qtyspecified TYPE ru_rmnga.
      IF cs_upd_operation-defectids IS NOT INITIAL.
        DATA(lv_defectid) = cs_upd_operation-defectids.
        DATA(lv_rework_qty) = cs_upd_operation-defectquantities.
        lv_rework_qtyspecified = abap_true.
      ENDIF.
      IF cs_upd_operation-scrapquantity GT 0.
        DATA(lv_scrap_qty) = cs_upd_operation-scrapquantity.
        lv_rework_qtyspecified = abap_true.
      ENDIF.

      CALL FUNCTION 'ZABSF_PP_SETQUANTITY_REWORK'
        EXPORTING
          arbpl      = cs_upd_operation-workcenterid
          aufnr      = cs_upd_operation-productionorderid
          vornr      = cs_upd_operation-id
          matnr      = cs_upd_operation-oinfo-matnr
          rework_qty = lv_rework_qty
          scrap_qty  = lv_scrap_qty
          defectid   = lv_defectid
          refdt      = sy-datum
          inputobj   = ls_inputobj
        IMPORTING
          conf_tab   = lt_conf_tab
          return_tab = lt_return_tab.

      lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return_tab CHANGING co_msg = co_msg ).
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_HELPER_OPERATION=>HELPER_81
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_INPUTOBJ                    TYPE        ZABSF_PP_S_INPUTOBJECT
* | [<-->] CS_UPD_OPERATION               TYPE        ZABSF_CL_ODATA=>TY_OPERATION
* | [<-->] CO_MSG                         TYPE REF TO /IWBEP/IF_MESSAGE_CONTAINER
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD helper_81.
    DATA: lt_return_tab         TYPE bapiret2_t.

    DATA ls_inputobj TYPE zabsf_pp_s_inputobject.
    ls_inputobj = is_inputobj.

    IF cs_upd_operation-bundlevalue GT 0.
      CALL FUNCTION 'ZABSF_PP_SET_BOX_QUANTITY'
        EXPORTING
          aufnr      = CONV arbpl( cs_upd_operation-workcenterid )
          vornr      = cs_upd_operation-id
          aufpl      = cs_upd_operation-oinfo-aufpl
          aplzl      = cs_upd_operation-oinfo-aplzl
          boxqty     = cs_upd_operation-bundlevalue
          refdt      = sy-datum
          inputobj   = ls_inputobj
        IMPORTING
          return_tab = lt_return_tab.

      lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return_tab CHANGING co_msg = co_msg ).

    ELSEIF cs_upd_operation-printbox EQ 'P' OR cs_upd_operation-printbox EQ 'F'.

      DATA(ls_print) = VALUE zabsf_pp_s_arbpl_print( arbpl = cs_upd_operation-workcenterid
                                                     aufnr = cs_upd_operation-productionorderid
                                                     matnr = cs_upd_operation-oinfo-matnr
                                                     vornr = cs_upd_operation-id
                                                     first_cycle = COND #( WHEN cs_upd_operation-printbox EQ 'F' THEN 'X' ) ).

      CALL FUNCTION 'ZABSF_PP_PRINT'
        EXPORTING
          arbpl_print_st = ls_print
          refdt          = sy-datum
          inputobj       = ls_inputobj
        IMPORTING
          return_tab     = lt_return_tab.

      lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return_tab CHANGING co_msg = co_msg ).


*ELSEIF cs_upd_operation-availabilityoverride EQ 'X' OR cs_upd_operation-availabilityoverride EQ ''.
    ELSEIF cs_upd_operation-availabilityoverride EQ 'X'.

      ls_inputobj-dateconf = COND #( WHEN cs_upd_operation-confday IS NOT INITIAL
                                     THEN cs_upd_operation-confday
                                     ELSE sy-datum ).

      ls_inputobj-timeconf = COND #( WHEN cs_upd_operation-conftime IS NOT INITIAL
                                     THEN COND #( WHEN strlen( cs_upd_operation-conftime ) EQ 8
                                                  THEN replace( val = cs_upd_operation-conftime sub = `:` with = `` )
                                                  ELSE replace( val = |{ cs_upd_operation-conftime }{ `00` }| sub = `:` with = `` ) )
                                     ELSE sy-uzeit ).

      CALL FUNCTION 'ZABSF_PP_SET_OVERRIDE_STATUS'
        EXPORTING
          inputobj   = ls_inputobj
          aufnr      = CONV aufnr( cs_upd_operation-productionorderid )
          status     = COND #( WHEN cs_upd_operation-availabilityoverride EQ 'X' THEN abap_true ELSE abap_false )
        IMPORTING
          return_tab = lt_return_tab.

      lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return_tab CHANGING co_msg = co_msg ).

    ELSEIF cs_upd_operation-tableordersequence IS NOT INITIAL.

      DATA lt_tableordersequence TYPE STANDARD TABLE OF zabsf_pp_order_seq_s.

      IF cs_upd_operation-tableordersequence IS NOT INITIAL.
        /ui2/cl_json=>deserialize( EXPORTING json = cs_upd_operation-tableordersequence pretty_name = /ui2/cl_json=>pretty_mode-low_case CHANGING data = lt_tableordersequence ).
      ENDIF.

      LOOP AT lt_tableordersequence ASSIGNING FIELD-SYMBOL(<fs_sequence>).
        <fs_sequence>-werks = ls_inputobj-werks.
      ENDLOOP.

      CALL FUNCTION 'ZABSF_PP_ORDERS_SEQUENCE'
        EXPORTING
          it_orders_tab = lt_tableordersequence
          inputobj      = ls_inputobj
        IMPORTING
          return_tab    = lt_return_tab.

      lcl_utils=>validatesapresponse( EXPORTING it_result = lt_return_tab CHANGING co_msg = co_msg ).
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_HELPER_OPERATION=>GET_STOPREASON
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ARBPL                       TYPE        ARBPL
* | [--->] IV_AUFNR                       TYPE        AUFNR
* | [--->] IV_VORNR                       TYPE        VORNR
* | [--->] IV_STATUS_OPER                 TYPE        J_STATUS
* | [<---] EV_STOPREASON_ID               TYPE        STRING
* | [<---] EV_STOPREASON_DESC             TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_stopreason.
    DATA: lv_arbpl       TYPE arbpl,
          lv_aufnr       TYPE aufnr,
          lv_vornr       TYPE vornr,
          lv_status_oper TYPE j_status.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = iv_arbpl
      IMPORTING
        output = lv_arbpl.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = iv_aufnr
      IMPORTING
        output = lv_aufnr.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = iv_vornr
      IMPORTING
        output = lv_vornr.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = iv_status_oper
      IMPORTING
        output = lv_status_oper.

    SELECT SINGLE b~stprsnid AS id, b~stprsn_desc AS desc
        FROM zabsf_pp021 AS a
        LEFT JOIN zabsf_pp015_t AS b
          ON a~arbpl = b~arbpl
          AND a~stprsnid = b~stprsnid
        INTO @DATA(ls_stopreason)
         WHERE a~arbpl EQ @lv_arbpl
           AND a~aufnr EQ @lv_aufnr
           AND a~vornr EQ @lv_vornr
           AND a~status_oper EQ @lv_status_oper
           AND b~spras EQ @iv_spras.

    ev_stopreason_id = ls_stopreason-id.
    ev_stopreason_desc = ls_stopreason-desc.
  ENDMETHOD.


* <signature>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_HELPER_OPERATION=>SET_QUANTITY_STOR_LOCATION
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_INPUTOBJ                    TYPE        ZABSF_PP_S_INPUTOBJECT
* | [<-->] CS_UPD_OPERATION               TYPE        ZABSF_CL_ODATA=>TY_OPERATION
* | [<-->] CO_MSG                         TYPE REF TO /IWBEP/IF_MESSAGE_CONTAINER
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_quantity_stor_location.
*reference
    DATA: lref_sf_prdord  TYPE REF TO zabsf_pp_cl_prdord.

*Variables
    DATA: l_gname  TYPE seqg3-gname,
          l_garg   TYPE seqg3-garg,
          l_guname TYPE seqg3-guname,
          l_subrc  TYPE sy-subrc,
          l_wait   TYPE i.

*Constants
    CONSTANTS: c_wait TYPE zabsf_pp_e_parid VALUE 'WAIT'.

*Get time wait
    SELECT SINGLE parva
      FROM zabsf_pp032
      INTO (@DATA(l_wait_param))
     WHERE parid EQ @c_wait.

    IF l_wait_param IS NOT INITIAL.
      l_wait = l_wait_param.
    ENDIF.


*Create object of class
    CREATE OBJECT lref_sf_prdord
      EXPORTING
        initial_refdt = refdt
        input_object  = inputobj.

*Get method of class to set quantity
    SELECT SINGLE methodname
      FROM zabsf_pp003
      INTO (@DATA(l_method))
     WHERE werks    EQ @inputobj-werks
       AND id_class EQ '12'
       AND endda    GE @refdt
       AND begda    LE @refdt.

    CLEAR l_subrc.

    LOOP AT qty_conf_tab INTO DATA(ls_qty_conf_tab).
      CLEAR: l_gname,
             l_garg,
             l_guname,
             l_subrc.

*  Check blocks for Prodcution Order
      CALL METHOD zabsf_pp_cl_wait_enqueue=>wait_for_dequeue_ord
        EXPORTING
          i_aufnr    = ls_qty_conf_tab-aufnr
          i_max_time = l_wait
        IMPORTING
          e_gname    = l_gname
          e_garg     = l_garg
          e_guname   = l_guname
          e_return   = l_subrc.

      IF l_subrc NE 0.
        EXIT.
      ENDIF.

      CLEAR: l_gname,
             l_garg,
             l_guname,
             l_subrc.

*  Check blocks for prodcution Order
      CALL METHOD zabsf_pp_cl_wait_enqueue=>wait_for_dequeue_res
        EXPORTING
          i_aufnr    = ls_qty_conf_tab-aufnr
          i_max_time = l_wait
        IMPORTING
          e_gname    = l_gname
          e_garg     = l_garg
          e_guname   = l_guname
          e_return   = l_subrc.

      IF l_subrc NE 0.
        EXIT.
      ENDIF.

      LOOP AT ls_qty_conf_tab-charg_t ASSIGNING FIELD-SYMBOL(<fs_charg_t>).
*    Add left zeros
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = <fs_charg_t>-charg
          IMPORTING
            output = <fs_charg_t>-charg.

*    Check blocks
        CALL METHOD zabsf_pp_cl_wait_enqueue=>wait_for_dequeue_mat
          EXPORTING
            i_matnr    = <fs_charg_t>-matnr
            i_werks    = <fs_charg_t>-werks
            i_charg    = <fs_charg_t>-charg
            i_max_time = l_wait
          IMPORTING
            e_gname    = l_gname
            e_garg     = l_garg
            e_guname   = l_guname
            e_return   = l_subrc.

        IF l_subrc NE 0.
          EXIT.
        ENDIF.
      ENDLOOP.

      IF sy-subrc NE 0.
        CALL METHOD zabsf_pp_cl_wait_enqueue=>wait_for_dequeue_mat
          EXPORTING
            i_matnr  = ls_qty_conf_tab-matnr
            i_werks  = inputobj-werks
          IMPORTING
            e_gname  = l_gname
            e_garg   = l_garg
            e_guname = l_guname
            e_return = l_subrc.

        IF l_subrc NE 0.
          EXIT.
        ENDIF.
      ENDIF.

      IF l_subrc NE 0.
        EXIT.
      ENDIF.
    ENDLOOP.

    IF l_subrc NE 0.
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'E'
          msgno      = '093'
          msgv1      = l_guname
          msgv2      = l_gname
          msgv3      = l_guname
        CHANGING
          return_tab = return_tab.
      EXIT.
    ENDIF.

    DATA lv_storage_location TYPE lgort_d.
    IF storage_location IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = storage_location
        IMPORTING
          output = lv_storage_location.
    ENDIF.


*Confirmation of good quantity
    CALL METHOD lref_sf_prdord->(l_method)
      EXPORTING
        areaid              = inputobj-areaid
        werks               = inputobj-werks
        inputobj            = inputobj
        arbpl               = arbpl
        qty_conf_tab        = qty_conf_tab
        tipord              = tipord
        check_stock         = check_stock
        first_cycle         = first_cycle
        backoffice          = backoffice
        shiftid             = shiftid
        supervisor          = supervisor
        vendor              = |{ vendor ALPHA = IN }|
        materialbatch       = materialbatch[]
        materialserial      = materialserial[]
        iv_storage_location = lv_storage_location
      IMPORTING
        conf_tab            = conf_tab
      CHANGING
        return_tab          = return_tab.

    DELETE ADJACENT DUPLICATES FROM return_tab.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_helper_timereportcenter DEFINITION
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS zabsf_pp_orders_time
      IMPORTING
        !inputobj      TYPE zabsf_pp_s_inputobject
        !iv_pf_var     TYPE string OPTIONAL
        !iv_arbpl_var  TYPE arbpl
      EXPORTING
        !et_orders_tab TYPE zabsf_pp_order_time_tt
        !return_tab    TYPE bapiret2_t .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS lcl_helper_timereportcenter IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_HELPER_TIMEREPORTCENTER=>ZABSF_PP_ORDERS_TIME
* +-------------------------------------------------------------------------------------------------+
* | [--->] INPUTOBJ                       TYPE        ZABSF_PP_S_INPUTOBJECT
* | [--->] IV_PF_VAR                      TYPE        STRING(optional)
* | [--->] IV_ARBPL_VAR                   TYPE        ARBPL
* | [<---] ET_ORDERS_TAB                  TYPE        ZABSF_PP_ORDER_TIME_TT
* | [<---] RETURN_TAB                     TYPE        BAPIRET2_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
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
          "Qtd confirmada
          SELECT SUM( menge )
            INTO @DATA(lv_menge_101)
            FROM mseg
            WHERE aufnr = @<fs_orders_str>-aufnr
              AND bwart = '101'                         "#EC CI_NOFIRST
            %_HINTS ORACLE 'index(mseg"z02")'.
          IF sy-subrc <> 0.
            CLEAR lv_menge_101.
          ENDIF.
          SELECT SUM( menge )
            INTO @DATA(lv_menge_102)
            FROM mseg
            WHERE aufnr = @<fs_orders_str>-aufnr
              AND bwart = '102'                         "#EC CI_NOFIRST
            %_HINTS ORACLE 'index(mseg"z02")'.
          IF sy-subrc <> 0.
            CLEAR lv_menge_102.
          ENDIF.

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
ENDCLASS.

CLASS lcl_helper_stockreportcenter DEFINITION
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS zabsf_pp_stocks
      IMPORTING
        !inputobj        TYPE zabsf_pp_s_inputobject
        !iv_matnr_var    TYPE matnr OPTIONAL
        !iv_werks_var    TYPE werks_d OPTIONAL
        !iv_pf_var       TYPE string OPTIONAL
        !iv_mat_desc_var TYPE string OPTIONAL
        !iv_semifin_var  TYPE boole_d OPTIONAL
        !iv_finished_var TYPE boole_d OPTIONAL
      EXPORTING
        !et_data_out_tab TYPE zps_stocks_tt
        !return_tab      TYPE bapiret2_t .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS lcl_helper_stockreportcenter IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_HELPER_STOCKREPORTCENTER=>ZABSF_PP_STOCKS
* +-------------------------------------------------------------------------------------------------+
* | [--->] INPUTOBJ                       TYPE        ZABSF_PP_S_INPUTOBJECT
* | [--->] IV_MATNR_VAR                   TYPE        MATNR(optional)
* | [--->] IV_WERKS_VAR                   TYPE        WERKS_D(optional)
* | [--->] IV_PF_VAR                      TYPE        STRING(optional)
* | [--->] IV_MAT_DESC_VAR                TYPE        STRING(optional)
* | [--->] IV_SEMIFIN_VAR                 TYPE        BOOLE_D(optional)
* | [--->] IV_FINISHED_VAR                TYPE        BOOLE_D(optional)
* | [<---] ET_DATA_OUT_TAB                TYPE        ZPS_STOCKS_TT
* | [<---] RETURN_TAB                     TYPE        BAPIRET2_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
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

      CATCH zcx_pp_exceptions INTO DATA(lo_excpetion_obj).
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

      CATCH zcx_pp_exceptions INTO lo_excpetion_obj.
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

CLASS lcl_helper_operationconsumptio DEFINITION
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS zabsf_pp_setgoodsmvt
      IMPORTING
        !inputobj         TYPE zabsf_pp_s_inputobject
        !refdt            TYPE vvdatum
        !aufnr            TYPE aufnr
        !components_st    TYPE zabsf_pp_s_components OPTIONAL
        !adit_matnr_st    TYPE zabsf_pp_s_adit_matnr OPTIONAL
        !lenum            TYPE lenum OPTIONAL
      RETURNING
        VALUE(return_tab) TYPE bapiret2_t .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS lcl_helper_operationconsumptio IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method LCL_HELPER_OPERATIONCONSUMPTIO=>ZABSF_PP_SETGOODSMVT
* +-------------------------------------------------------------------------------------------------+
* | [--->] INPUTOBJ                       TYPE        ZABSF_PP_S_INPUTOBJECT
* | [--->] REFDT                          TYPE        VVDATUM
* | [--->] AUFNR                          TYPE        AUFNR
* | [--->] COMPONENTS_ST                  TYPE        ZABSF_PP_S_COMPONENTS(optional)
* | [--->] ADIT_MATNR_ST                  TYPE        ZABSF_PP_S_ADIT_MATNR(optional)
* | [--->] LENUM                          TYPE        LENUM(optional)
* | [<---] RETURN_TAB                     TYPE        BAPIRET2_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD zabsf_pp_setgoodsmvt.
    "constantes
    CONSTANTS: lc_multimat_cst  TYPE aufart VALUE 'ZPP3',
               lc_one_matr_cst  TYPE aufart VALUE 'ZPP2',
               lc_lantekmat_cst TYPE matnr VALUE 'LANTEK'.
*Internal tables
    DATA: lt_goodsmvt_item     TYPE TABLE OF bapi2017_gm_item_create,
          lt_goodsmvt_item_cwm TYPE TABLE OF /cwm/bapi2017_gm_item_create.

*Structures
    DATA: ls_goodsmvt_header   TYPE bapi2017_gm_head_01,
          ls_goodsmvt_code     TYPE bapi2017_gm_code,
          ls_goodsmvt_item     TYPE bapi2017_gm_item_create,
          ls_goodsmvt_headret  TYPE bapi2017_gm_head_ret,
          ls_goodsmvt_item_cwm TYPE /cwm/bapi2017_gm_item_create.

*Variables
    DATA: l_aufnr            TYPE aufnr,
          l_materialdocument TYPE bapi2017_gm_head_ret-mat_doc,
          l_matdocumentyear  TYPE bapi2017_gm_head_ret-doc_year,
          lref_sf_parameters TYPE REF TO zabsf_pp_cl_parameters,
          lv_use_cwm         TYPE flag,
          lv_cwm_active      TYPE /cwm/xcwmat,
          lv_lgort           TYPE lgort_d,
          lv_matnr40         TYPE matnr,
          lv_umb             TYPE meins.

*se for cwm
    DATA: val_erfmg TYPE erfmg,
          val_erfme TYPE erfme VALUE 'KI',
          lv_matnr  TYPE matnr.
*  data: peso_medio type ref to /cwm/cl_quan_prpsl.
    DATA: wa_indx TYPE indx.
    DATA: flag_nao_imprime TYPE c.

    DATA: trash_num(15) TYPE c,
          trash_dec(15) TYPE c,
          l_verme_      TYPE lqua-verme,
          l_verme_c     TYPE char20,
          l_meins       TYPE lqua-meins,
          l_verme_cx    TYPE bstmg,
          ls_matnr      TYPE mara-matnr.

    REFRESH lt_goodsmvt_item.

    CLEAR: ls_goodsmvt_item,
           ls_goodsmvt_header,
           ls_goodsmvt_code.

    CREATE OBJECT lref_sf_parameters
      EXPORTING
        initial_refdt = refdt
        input_object  = inputobj.

    CALL METHOD lref_sf_parameters->get_output_settings
      EXPORTING
        parid           = lref_sf_parameters->c_use_cwm
      IMPORTING
        parameter_value = lv_use_cwm
      CHANGING
        return_tab      = return_tab.

    REFRESH return_tab.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = aufnr
      IMPORTING
        output = l_aufnr.

    "obter tipo de ordem
    SELECT SINGLE auart
      FROM aufk
      INTO @DATA(lv_ordertype)
        WHERE aufnr EQ @l_aufnr.

    TRY.
        "obter depósito configuração
        CALL METHOD zcl_bc_fixed_values=>get_single_value
          EXPORTING
            im_paramter_var = zcl_bc_fixed_values=>gc_shp_consmpt_strg_cst
            im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
            im_werksval_var = inputobj-werks
          IMPORTING
            ex_prmvalue_var = DATA(lv_conslgort_var).

        "obter depósito configuração
        CALL METHOD zcl_bc_fixed_values=>get_single_value
          EXPORTING
            im_paramter_var = zcl_bc_fixed_values=>gc_shop_add_csmt_cst
            im_modulesp_var = zcl_bc_fixed_values=>gc_material_cst
            im_werksval_var = inputobj-werks
          IMPORTING
            ex_prmvalue_var = DATA(lv_cons_add_var).

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
            return_tab = return_tab.
        RETURN.
    ENDTRY.

*Header of material document
    ls_goodsmvt_header-pstng_date = sy-datlo.
    ls_goodsmvt_header-doc_date = sy-datlo.

*Movement type
    ls_goodsmvt_code-gm_code = '03'.
*Data to create movement
*Plant
    ls_goodsmvt_item-plant = inputobj-werks.
*Movement Type
    SELECT SINGLE parva FROM zabsf_pp032 INTO ls_goodsmvt_item-move_type
      WHERE werks EQ ls_goodsmvt_item-plant
      AND parid = 'CONSUME_MVMT'.
    IF sy-subrc NE 0.
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'E'
          msgno      = '108'
        CHANGING
          return_tab = return_tab.
      EXIT.
    ENDIF.

*Production Order
    ls_goodsmvt_item-orderid = l_aufnr.
    "*PEP element
    SELECT SINGLE projn
      FROM afpo
      INTO @ls_goodsmvt_item-wbs_elem
        WHERE aufnr EQ @l_aufnr.

    ls_goodsmvt_item-wbs_elem = ``.

    IF ls_goodsmvt_item-wbs_elem IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_ABPSP_OUTPUT'
        EXPORTING
          input  = ls_goodsmvt_item-wbs_elem
        IMPORTING
          output = ls_goodsmvt_item-wbs_elem.

      ls_goodsmvt_item-val_wbs_elem = ls_goodsmvt_item-wbs_elem.
      ls_goodsmvt_item-spec_stock = 'Q'.
    ENDIF.

    IF components_st IS NOT INITIAL.

      lv_umb = components_st-meins.

      IF components_st-matnr NA sy-abcde.
*    Material - Component
        CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
          EXPORTING
            input        = components_st-matnr
          IMPORTING
            output       = ls_goodsmvt_item-material
          EXCEPTIONS
            length_error = 1
            OTHERS       = 2.
      ELSE.
        ls_goodsmvt_item-material = components_st-matnr.
      ENDIF.

*  Quantity
      ls_goodsmvt_item-entry_qnt = components_st-consqty.
*  Unit
      ls_goodsmvt_item-entry_uom = components_st-meins.

*  Storage Location
      IF lv_ordertype EQ lc_multimat_cst.
        ls_goodsmvt_item-stge_loc = lv_conslgort_var.
      ELSE.
        ls_goodsmvt_item-stge_loc = components_st-lgort.
      ENDIF.
      IF lv_ordertype EQ lc_multimat_cst.
        "verificar se é material lantek
        SELECT SINGLE plnbez
          INTO @DATA(lv_lantek_var)
          FROM afko
            WHERE aufnr EQ @aufnr
              AND plnbez EQ @lc_lantekmat_cst.
        IF sy-subrc EQ 0.
          "obter item da ordem
          SELECT SINGLE *
            FROM resb
            INTO @DATA(ls_resb_str)
              WHERE matnr EQ @components_st-matnr
                AND aufnr EQ @aufnr.


          DATA: lv_textname_var      TYPE tdobname,
                lv_seqlantek_var     TYPE zabsf_pp_e_seq_lantek,
                lt_lines_tab         TYPE TABLE OF tline,
                lv_batchconsumed_var TYPE charg_d.
          "lote a consumir
          lv_batchconsumed_var = components_st-batch.

          lv_textname_var = |{ sy-mandt }{ ls_resb_str-rsnum }{ ls_resb_str-rspos }|.
          "obter texto do item
          CALL FUNCTION 'READ_TEXT'
            EXPORTING
              id                      = 'MATK'
              language                = sy-langu
              name                    = lv_textname_var
              object                  = 'AUFK'
            TABLES
              lines                   = lt_lines_tab
            EXCEPTIONS
              id                      = 1
              language                = 2
              name                    = 3
              not_found               = 4
              object                  = 5
              reference_check         = 6
              wrong_access_to_archive = 7
              OTHERS                  = 8.
          IF sy-subrc <> 0.
* Implement suitable error handling here
          ENDIF.
          "remover linhas em branco
          DELETE lt_lines_tab WHERE tdline EQ space.
          READ TABLE lt_lines_tab INTO DATA(ls_textvalue_str) INDEX 1.
          "sequenciador lantek
          lv_seqlantek_var = ls_textvalue_str-tdline.
        ENDIF.
      ENDIF.


**  Reservation
      "EDIT 27.08.2020 - SF envia o nº da reserva
      "EDIT 11.11.2020 - se na reserva não tiver lote, considerar como adhoc puro
      SELECT SINGLE charg
        FROM resb
        INTO @DATA(lv_resbcharg_var)
          WHERE rsnum EQ @components_st-rsnum
            AND rspos EQ @components_st-rspos
            AND charg NE @space.
      IF sy-subrc EQ 0.
        "verificar se o lote é igual
        IF lv_resbcharg_var EQ components_st-batch.
          ls_goodsmvt_item-reserv_no = components_st-rsnum.
          ls_goodsmvt_item-res_item = components_st-rspos.
        ENDIF.
      ENDIF.
      ">>BMR 27.08.2020 - Erro Lote sem Tipo de avaliação
      SELECT SINGLE bwtar
        FROM mcha
        INTO @ls_goodsmvt_item-val_type
          WHERE charg EQ @components_st-batch
            AND matnr EQ @ls_goodsmvt_item-material
            AND werks EQ @inputobj-werks.
      "<<BMR 27.08.2020 - Erro Lote sem Tipo de avaliação
      ls_goodsmvt_item-batch = components_st-batch.
      APPEND ls_goodsmvt_item TO lt_goodsmvt_item.
    ENDIF.

*Check if structure of aditional material was filled
    IF adit_matnr_st IS NOT INITIAL.

      lv_umb = adit_matnr_st-meins.

      IF adit_matnr_st-matnr NA sy-abcde.
*    Material
        CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
          EXPORTING
            input        = adit_matnr_st-matnr
          IMPORTING
            output       = ls_goodsmvt_item-material
          EXCEPTIONS
            length_error = 1
            OTHERS       = 2.
      ELSE.
        ls_goodsmvt_item-material = adit_matnr_st-matnr.
      ENDIF.

      TRANSLATE ls_goodsmvt_item-material TO UPPER CASE.

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
      SELECT SINGLE bwtar
        FROM mcha
        INTO @ls_goodsmvt_item-val_type
          WHERE charg EQ @ls_goodsmvt_item-batch
            AND matnr EQ @ls_goodsmvt_item-material
            AND werks EQ @inputobj-werks.
      "<<BMR 27.08.2020 - Erro Lote sem Tipo de avaliação
      APPEND ls_goodsmvt_item TO lt_goodsmvt_item.
    ENDIF.

*********************
    CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
      EXPORTING
        goodsmvt_header  = ls_goodsmvt_header
        goodsmvt_code    = ls_goodsmvt_code
      IMPORTING
        goodsmvt_headret = ls_goodsmvt_headret
        materialdocument = l_materialdocument
        matdocumentyear  = l_matdocumentyear
      TABLES
        goodsmvt_item    = lt_goodsmvt_item
        return           = return_tab.

    IF return_tab[] IS INITIAL.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = 'X'.
      "actualizar tabela de sequenciadores
      IF lv_batchconsumed_var IS NOT INITIAL.
        SELECT SINGLE *
          FROM zabsf_sequence_t
          INTO @DATA(ls_sequence_str)
            WHERE charg EQ @lv_batchconsumed_var
              AND seq_lantek EQ @space.
        IF sy-subrc EQ 0.
          "actualizar sequenciador do lantek
          ls_sequence_str-seq_lantek = lv_seqlantek_var.
          "actualizar tabela
          UPDATE zabsf_sequence_t FROM ls_sequence_str.
          COMMIT WORK AND WAIT.
        ENDIF.
      ENDIF.
*  Send message sucess.
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'S'
          msgno      = '034'
          msgv1      = l_materialdocument
        CHANGING
          return_tab = return_tab.
    ENDIF.
  ENDMETHOD.
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

CLASS lcl_authorization IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method LCL_AUTHORIZATION=>CHECK
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_USERNAME                    TYPE        STRING
* | [--->] IV_ENDPOINT                    TYPE        STRING
* | [--->] IV_ACTIVITY                    TYPE        STRING
* | [<---] RETURN_TAB                     TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD check.
    DATA: lv_username TYPE string,
          lv_authobj  TYPE string,
          lv_activity TYPE string.

    lv_username = to_upper( val = iv_username ).

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
          AND e~endpoint = @iv_endpoint.

    rv_authorized = REDUCE #( INIT val TYPE string
                              FOR wa IN lt_authorizations
                              WHERE ( desc CS to_upper( lv_activity ) )
                              NEXT val = abap_true ).
  ENDMETHOD.
ENDCLASS.

CLASS lcl_helper_workcenter DEFINITION
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS get_rework
      IMPORTING
        !iv_rueck           TYPE co_rueck
        !iv_aufnr           TYPE aufnr
        !iv_vornr           TYPE vornr
      RETURNING
        VALUE(rv_reworkqty) TYPE ru_rmnga .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS lcl_helper_workcenter IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_HELPER_WORKCENTER=>GET_REWORK
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_RUECK                       TYPE        STRING
* | [--->] IV_AUFNR                       TYPE        STRING
* | [--->] IV_VORNR                       TYPE        STRING
* | [<---] RV_REWORKQTY                   TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_rework.
    "DATA(lv_rueck) = CONV CO_RUECK( iv_rueck ).

*    Confirmed yield
    SELECT SUM( rmnga )
      FROM afru
      INTO @rv_reworkqty
     WHERE rueck EQ @iv_rueck
       AND aufnr EQ @iv_aufnr
       AND vornr EQ @iv_vornr
       AND stokz EQ @space
       AND stzhl EQ @space.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_helper_operationrework DEFINITION
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS get_seqid
      RETURNING
        VALUE(rv_seqid) TYPE zabsf_pp_e_seqid .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS lcl_helper_operationrework IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_HELPER_OPERATIONREWORK=>GET_SEQID
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_SEQID                       TYPE ZABSF_PP_E_SEQID
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_seqid.
    DATA: lv_num TYPE zabsf_pp_e_seqid.

    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr             = '01'
        object                  = 'ZSF_ID004'
      IMPORTING
        number                  = lv_num
      EXCEPTIONS
        interval_not_found      = 1
        number_range_not_intern = 2
        object_not_found        = 3
        quantity_is_0           = 4
        quantity_is_not_1       = 5
        interval_overflow       = 6
        buffer_overflow         = 7
        OTHERS                  = 8.

    rv_seqid = COND #( WHEN sy-subrc EQ 0
                                        THEN lv_num
                                    ELSE 0 ).
  ENDMETHOD.
ENDCLASS.

CLASS lcl_helper_confirmedstocks DEFINITION
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS get_active_orders
      IMPORTING
        is_inputobj    TYPE zabsf_pp_s_inputobject
      EXPORTING
        et_workcenters TYPE string_table
        et_orders      TYPE string_table .
    CLASS-METHODS get_inactive_orders
      IMPORTING
        is_inputobj    TYPE zabsf_pp_s_inputobject
        it_workcenters TYPE string_table
      EXPORTING
        et_orders      TYPE string_table .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS lcl_helper_confirmedstocks IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_HELPER_CONFIRMEDSTOCKS=>GET_ACTIVE_ORDERS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_INPUTOBJ                    TYPE        ZABSF_PP_S_INPUTOBJECT
* | [<---] ET_WORKCENTERS                 TYPE        STRING_TABLE
* | [<---] ET_ORDERS                      TYPE        STRING_TABLE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_active_orders.
    " Set production orders istat filter
    DATA(lt_istat_filters) = VALUE string_table( ( CONV #( 'I0009' ) ) ( CONV #( 'I0045' ) ) ).

    " Get all hierarchies and the respective shift ids
    SELECT pp002~shiftid, pp002~hname
  FROM zabsf_pp002 AS pp002
  INTO TABLE @DATA(lt_hierarchies_shifts)
      WHERE areaid EQ @is_inputobj-areaid
      AND werks EQ @is_inputobj-werks.

    " Get workcenters for the desired hierarchy and shift
    LOOP AT lt_hierarchies_shifts ASSIGNING FIELD-SYMBOL(<fs_hierarchy_shift>).
      DATA ls_hrchy_detail TYPE zabsf_pp_s_hrchy_detail.

      CALL FUNCTION 'ZABSF_PP_GETHRCHY_DETAIL'
        EXPORTING
          areaid         = is_inputobj-areaid
          shiftid        = <fs_hierarchy_shift>-shiftid
          hname          = <fs_hierarchy_shift>-hname
          refdt          = sy-datum
          inputobj       = is_inputobj
          no_shift_check = abap_true
        IMPORTING
          hrchy_detail   = ls_hrchy_detail.

*      et_workcenters = VALUE string_table( BASE et_workcenters FOR ls_workcenter IN ls_hrchy_detail-wrkctr_tab WHERE ( objty EQ 'A' ) ( CONV #( ls_workcenter-arbpl ) ) ).

      " Get orders listing for desired workcenter
      LOOP AT ls_hrchy_detail-wrkctr_tab ASSIGNING FIELD-SYMBOL(<fs_workcenter>) WHERE objty EQ 'A'.
*      LOOP AT et_workcenters ASSIGNING FIELD-SYMBOL(<fs_workcenter>).
        DATA ls_wrkctr_detail TYPE zabsf_pp_s_wrkctr_detail.

        CALL FUNCTION 'ZABSF_PP_GETWRKCENTER_DETAIL'
          EXPORTING
            areadid          = is_inputobj-areaid
            werks            = is_inputobj-werks
            hname            = <fs_hierarchy_shift>-hname
            arbpl            = CONV arbpl( <fs_workcenter>-arbpl )
            refdt            = sy-datum
            inputobj         = is_inputobj
            it_istat_filters = lt_istat_filters
          IMPORTING
            wrkctr_detail    = ls_wrkctr_detail.

*        LOOP AT ls_wrkctr_detail-prord_tab ASSIGNING FIELD-SYMBOL(<fs_order>).
*          rt_orders = VALUE string_table( BASE rt_orders ( CONV #( <fs_order>-aufnr ) ) ).
*        ENDLOOP.
        et_workcenters = VALUE string_table( BASE et_workcenters ( CONV #( <fs_workcenter>-arbpl ) ) ).

        et_orders = VALUE string_table( BASE et_orders FOR ls_order IN ls_wrkctr_detail-prord_tab ( CONV #( ls_order-aufnr ) ) ).
      ENDLOOP.
    ENDLOOP.

    " Remove duplicate workcenters
    SORT et_workcenters BY table_line ASCENDING.
    DELETE ADJACENT DUPLICATES FROM et_workcenters COMPARING table_line.

    " Remove duplicate orders
    SORT et_orders BY table_line ASCENDING.
    DELETE ADJACENT DUPLICATES FROM et_orders COMPARING table_line.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_HELPER_CONFIRMEDSTOCKS=>GET_INACTIVE_ORDERS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_INPUTOBJ                    TYPE        ZABSF_PP_S_INPUTOBJECT
* | [--->] IT_WORKCENTERS                 TYPE        STRING_TABLE
* | [<---] ET_ORDERS                      TYPE        STRING_TABLE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_inactive_orders.
    DATA lt_prdord_unassign TYPE STANDARD TABLE OF zabsf_pp_s_prodord_unassign.

    DATA(lt_steus_filters) = VALUE string_table( ( CONV #( 'PP01' ) ) ).

    LOOP AT it_workcenters ASSIGNING FIELD-SYMBOL(<fs_workcenter>).
      CALL FUNCTION 'ZABSF_PP_GET_PRDORD_UNASSIGN'
        EXPORTING
          arbpl            = CONV arbpl( <fs_workcenter> )
          refdt            = sy-datum
          inputobj         = is_inputobj
          it_steus_filters = lt_steus_filters
        IMPORTING
          prdord_unassign  = lt_prdord_unassign.

      et_orders = VALUE string_table( BASE et_orders FOR ls_productionobj IN lt_prdord_unassign ( CONV #( ls_productionobj-aufnr ) ) ).
    ENDLOOP.

    " Remove duplicate orders
    SORT et_orders BY table_line ASCENDING.
    DELETE ADJACENT DUPLICATES FROM et_orders COMPARING table_line.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_helper_confirmedstocks2 DEFINITION
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      tt_hierarchy TYPE STANDARD TABLE OF cr_hname WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_workcenter,
        arbpl TYPE arbpl,
        objid TYPE cr_objid,
      END OF ty_workcenter .
    TYPES:
      tt_workcenter TYPE STANDARD TABLE OF ty_workcenter WITH DEFAULT KEY .
    TYPES:
      ty_r_auart TYPE RANGE OF auart .
    TYPES:
      tt_order TYPE STANDARD TABLE OF aufnr WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_order2,
        aufnr TYPE aufnr,
        vornr TYPE vornr,
        "aufpl TYPE co_aufpl,
      END OF ty_order2 .
    TYPES:
      tt_order2 TYPE STANDARD TABLE OF ty_order2 WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_movement,
        aufnr TYPE aufnr,
        mgvrg TYPE mgvrg,
        lmnga TYPE lmnga,
        xmnga TYPE xmnga,
        ltxa1 TYPE ltxa1,
        name  TYPE char10,
        vornr TYPE vornr,
        matnr TYPE co_matnr,
        fica  TYPE i,
        passa TYPE i,
      END OF ty_movement .
    TYPES:
      tt_standard_movements TYPE STANDARD TABLE OF ty_movement .
    TYPES:
      tt_sorted_movements TYPE SORTED TABLE OF ty_movement WITH NON-UNIQUE KEY primary_key COMPONENTS vornr aufnr matnr ltxa1 .
    TYPES:
      BEGIN OF ty_confirmedstock,
        material     TYPE string,
        operation    TYPE string,
        ltxa1        TYPE string,
        remainingqty TYPE i,
      END OF ty_confirmedstock .
    TYPES:
      tt_confirmedstocks TYPE SORTED TABLE OF ty_confirmedstock WITH NON-UNIQUE KEY material .

    CLASS-METHODS get_hierarchies
      IMPORTING
        !iv_oprid             TYPE zabsf_pp_e_oprid
        !iv_areaid            TYPE zabsf_pp_e_areaid
        !iv_werks             TYPE werks_d
      RETURNING
        VALUE(rt_hierarchies) TYPE tt_hierarchy .
    CLASS-METHODS get_movements
      IMPORTING
        !iv_werks           TYPE werks_d
        !it_orders          TYPE tt_order2
      RETURNING
        VALUE(rt_movements) TYPE tt_sorted_movements .
    CLASS-METHODS get_orders
      IMPORTING
        !iv_areaid       TYPE zabsf_pp_e_areaid
        !iv_werks        TYPE werks_d
        !it_workcenters  TYPE tt_workcenter
      RETURNING
        VALUE(rt_orders) TYPE tt_order2 .
    CLASS-METHODS get_workcenter_objid
      IMPORTING
        !iv_hname            TYPE crhh-name
        !iv_werks            TYPE crhh-werks
      RETURNING
        VALUE(rt_workcenter) TYPE tt_workcenter .
    CLASS-METHODS get_workcenters
      IMPORTING
        !iv_oprid             TYPE zabsf_pp_e_oprid
        !it_hierarchies       TYPE tt_hierarchy
        !iv_werks             TYPE crhh-werks
      RETURNING
        VALUE(rt_workcenters) TYPE tt_workcenter .
    CLASS-METHODS get_order_type
      IMPORTING
        !iv_areaid        TYPE zabsf_pp_e_areaid
      RETURNING
        VALUE(rt_r_auart) TYPE ty_r_auart .
    CLASS-METHODS get_dates
      IMPORTING
        !iv_areaid      TYPE zabsf_pp_e_areaid
        !iv_werks       TYPE werks_d
        !iv_refdt       TYPE datum
      EXPORTING
        !ev_date_past   TYPE begda
        !ev_date_future TYPE begda .
    CLASS-METHODS calculate_remaining_stock_alt
      CHANGING
        !ct_filtered_movements TYPE tt_sorted_movements .
    CLASS-METHODS calculate_remaining_stock
      CHANGING
        !ct_filtered_movements TYPE tt_sorted_movements .
    CLASS-METHODS sum_and_group
      IMPORTING
        !it_unique_movements   TYPE tt_standard_movements
        !it_filtered_movements TYPE tt_sorted_movements
        !iv_aufnr              TYPE aufnr
      CHANGING
        !ct_results            TYPE tt_confirmedstocks .
ENDCLASS.



CLASS lcl_helper_confirmedstocks2 IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_HELPER_CONFIRMEDSTOCKS2=>GET_HIERARCHIES
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_OPRID                       TYPE        ZABSF_PP_E_OPRID
* | [--->] IV_AREAID                      TYPE        ZABSF_PP_E_AREAID
* | [--->] IV_WERKS                       TYPE        WERKS_D
* | [<-()] RT_HIERARCHIES                 TYPE        TT_HIERARCHY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_hierarchies.
    zabsf_pp_cl_utils=>get_user_hrchy_wrkcntr_auth(
      EXPORTING iv_oprid       = iv_oprid             " Shopfloor - Shopfloor Operator ID
      IMPORTING er_hierarchies = DATA(lr_hierarchies) " Range For Hierarchies
    ).

    SELECT DISTINCT pp002~hname
      FROM zabsf_pp002 AS pp002
      INTO TABLE @rt_hierarchies
      WHERE areaid EQ @iv_areaid
        AND werks EQ @iv_werks
        AND begda LE @sy-datum
        AND endda GE @sy-datum.

    "DELETE rt_hierarchies WHERE table_line NOT IN lr_hierarchies.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_HELPER_CONFIRMEDSTOCKS2=>CALCULATE_REMAINING_STOCK
* +-------------------------------------------------------------------------------------------------+
* | [<-->] CT_FILTERED_MOVEMENTS          TYPE        TT_SORTED_MOVEMENTS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD calculate_remaining_stock.
    FIELD-SYMBOLS <fs_prev_value> TYPE i.
    LOOP AT ct_filtered_movements ASSIGNING FIELD-SYMBOL(<fs_movement>).
      DATA lv_prev_value TYPE i.
      IF <fs_prev_value> IS NOT ASSIGNED.
        lv_prev_value = CONV i( <fs_movement>-mgvrg ).
        ASSIGN lv_prev_value TO <fs_prev_value>.
      ENDIF.
      <fs_movement>-fica = COND #( WHEN <fs_prev_value> IS ASSIGNED THEN <fs_prev_value> ELSE <fs_movement>-mgvrg ) - ( <fs_movement>-lmnga + <fs_movement>-xmnga ).
      <fs_movement>-fica = COND #( WHEN <fs_movement>-fica LT 0 THEN 0 ELSE <fs_movement>-fica ).
      <fs_movement>-passa = <fs_movement>-lmnga.

      lv_prev_value = <fs_movement>-passa.
      ASSIGN lv_prev_value TO <fs_prev_value>.
    ENDLOOP.
    UNASSIGN <fs_prev_value>.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_HELPER_CONFIRMEDSTOCKS2=>CALCULATE_REMAINING_STOCK_ALT
* +-------------------------------------------------------------------------------------------------+
* | [<-->] CT_FILTERED_MOVEMENTS          TYPE        TT_SORTED_MOVEMENTS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD calculate_remaining_stock_alt.
*    FIELD-SYMBOLS <fs_prev_value> TYPE i.
*    LOOP AT ct_filtered_movements ASSIGNING FIELD-SYMBOL(<fs_movement>).
*      DATA lv_prev_value TYPE i.
*      IF <fs_prev_value> IS NOT ASSIGNED.
*        lv_prev_value = CONV i( <fs_movement>-mgvrg ).
*        ASSIGN lv_prev_value TO <fs_prev_value>.
*      ENDIF.
*      "<fs_prev_value> = COND #( WHEN <fs_prev_value> IS NOT ASSIGNED THEN CONV i( <fs_movement>-mgvrg ) ).
*      <fs_movement>-fica = COND #( WHEN <fs_prev_value> IS ASSIGNED THEN <fs_prev_value> ELSE <fs_movement>-mgvrg ) - ( <fs_movement>-lmnga + <fs_movement>-xmnga ).
*      <fs_movement>-fica = COND #( WHEN <fs_movement>-fica LT 0 THEN 0 ELSE <fs_movement>-fica ).
*      <fs_movement>-passa = <fs_movement>-lmnga.
*
*      <fs_prev_value> = <fs_movement>-passa.
*    ENDLOOP.
*    UNASSIGN <fs_prev_value>.

    DATA lv_prev_value TYPE i.
    LOOP AT ct_filtered_movements ASSIGNING FIELD-SYMBOL(<fs_movement>).
      lv_prev_value = COND #( WHEN lv_prev_value IS INITIAL THEN CONV i( <fs_movement>-mgvrg ) ).
      <fs_movement>-fica = COND #( WHEN lv_prev_value IS NOT INITIAL THEN lv_prev_value ELSE <fs_movement>-mgvrg ) - ( <fs_movement>-lmnga + <fs_movement>-xmnga ).
      <fs_movement>-fica = COND #( WHEN <fs_movement>-fica LT 0 THEN 0 ELSE <fs_movement>-fica ).
      <fs_movement>-passa = <fs_movement>-lmnga.

      lv_prev_value = <fs_movement>-passa.
    ENDLOOP.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_HELPER_CONFIRMEDSTOCKS2=>GET_DATES
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_AREAID                      TYPE        ZABSF_PP_E_AREAID
* | [--->] IV_WERKS                       TYPE        WERKS_D
* | [--->] IV_REFDT                       TYPE        DATUM
* | [<---] EV_DATE_PAST                   TYPE        BEGDA
* | [<---] EV_DATE_FUTURE                 TYPE        BEGDA
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_dates.
    CONSTANTS: lc_parid      TYPE zabsf_pp_e_parid VALUE 'DATA_GET',
               lc_parid_at01 TYPE zabsf_pp_e_parid VALUE 'DATA_GET_AT01'.

    DATA: lv_tarea_id TYPE zabsf_pp_e_tarea_id,
          lv_parid    TYPE zabsf_pp_e_parid,
          lc_days     TYPE t5a4a-dlydy,
          lv_months   TYPE xuvalue,
          lc_years    TYPE t5a4a-dlyyr.

    " Get type area
    SELECT SINGLE tarea_id
    FROM zabsf_pp008
    INTO @lv_tarea_id
    WHERE areaid EQ @iv_areaid
        AND werks  EQ @iv_werks
        AND endda  GE @iv_refdt
        AND begda  LE @iv_refdt.

    " Get number of year to get orders
    lv_parid = COND #( WHEN lv_tarea_id EQ 'AT01'
                            THEN lc_parid_at01
                        ELSE lc_parid ).

    SELECT SINGLE parva
    FROM zabsf_pp032
    INTO @lv_months
    WHERE parid EQ @lv_parid.

    " Date in past
    CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
      EXPORTING
        date      = sy-datum
        days      = lc_days
        months    = CONV t5a4a-dlymo( lv_months )
        signum    = '-'
        years     = lc_years
      IMPORTING
        calc_date = ev_date_past.

    " Date in future
    CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
      EXPORTING
        date      = sy-datum
        days      = lc_days
        months    = CONV t5a4a-dlymo( lv_months )
        signum    = '+'
        years     = lc_years
      IMPORTING
        calc_date = ev_date_future.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_HELPER_CONFIRMEDSTOCKS2=>GET_MOVEMENTS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_WERKS                       TYPE        WERKS_D
* | [--->] IT_ORDERS                      TYPE        TT_ORDER2
* | [<-()] RT_MOVEMENTS                   TYPE        TT_SORTED_MOVEMENTS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_movements.
    CHECK it_orders IS NOT INITIAL.

    " Filtering support to delete matching steus
    DATA: lt_r_steus TYPE RANGE OF steus.
    lt_r_steus = VALUE #(
      ( sign = 'E' option = 'EQ' low = 'PP01' )
    ).

    " Get all movements
    SELECT afko~aufnr, afvv~mgvrg, afvv~lmnga, afvv~xmnga, afvc~ltxa1, crhh~name, afvc~vornr, afpo~matnr
    FROM afko AS afko
    INNER JOIN afvv AS afvv ON afvv~aufpl EQ afko~aufpl
    INNER JOIN afvc AS afvc ON afvc~aufpl EQ afvv~aufpl AND afvc~aplzl EQ afvv~aplzl
    INNER JOIN afpo AS afpo ON afpo~aufnr EQ afko~aufnr
    INNER JOIN crhs AS crhs ON crhs~objid_ho EQ afvc~arbid AND crhs~objid_up EQ ''
    INNER JOIN crhh AS crhh ON crhh~objid EQ crhs~objid_hy
    FOR ALL ENTRIES IN @it_orders
    WHERE afko~aufnr = @it_orders-aufnr
      AND afvc~steus IN @lt_r_steus
      AND afvc~werks = @iv_werks
    INTO CORRESPONDING FIELDS OF TABLE @rt_movements.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_HELPER_CONFIRMEDSTOCKS2=>GET_ORDERS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_AREAID                      TYPE        ZABSF_PP_E_AREAID
* | [--->] IV_WERKS                       TYPE        WERKS_D
* | [--->] IT_WORKCENTERS                 TYPE        TT_WORKCENTER
* | [<-()] RT_ORDERS                      TYPE        TT_ORDER2
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_orders.
    CHECK it_workcenters IS NOT INITIAL.

    TYPES:
      BEGIN OF ty_prod_order,
        aufnr TYPE aufnr,
        vornr TYPE vornr,
      END OF ty_prod_order .
    DATA lt_prod_orders TYPE TABLE OF ty_prod_order.

    " Set order type range
    DATA: lt_r_auart TYPE RANGE OF auart.
    lt_r_auart = get_order_type( iv_areaid ).

    " Get dates
    DATA: lv_date_past   TYPE begda,
          lv_date_future TYPE begda.

    get_dates( EXPORTING iv_areaid = iv_areaid
                         iv_werks = iv_werks
                         iv_refdt = sy-datum
               IMPORTING ev_date_past = lv_date_past
                         ev_date_future = lv_date_future ).

*Get all orders in workcenter
    DATA: lt_r_aufnr_rng TYPE RANGE OF aufnr,
          lt_r_vornr_rng TYPE RANGE OF vornr,
          lt_r_ruek      TYPE RANGE OF ruek.

*    DATA: lt_r_stat_rng TYPE RANGE OF j_status.
*    lt_r_stat_rng = VALUE #( ( sign = 'I' option = 'EQ' low = 'I0002' )
*                          ( sign = 'I' option = 'EQ' low = 'I0009' ) ).

    " Get the orders
*    SELECT aufk~aufnr, afvc~vornr
*    INTO CORRESPONDING FIELDS OF TABLE @lt_prod_orders
*    FROM afvc AS afvc
*    INNER JOIN t430 AS t430
*      ON t430~steus EQ afvc~steus
*    INNER JOIN afko AS afko
*      ON afko~aufpl EQ afvc~aufpl
*    INNER JOIN aufk AS aufk
*      ON afko~aufnr EQ aufk~aufnr
*    INNER JOIN jest AS jest
*      ON jest~objnr EQ aufk~objnr AND
*        jest~stat  EQ 'I0002' AND
*        jest~inact EQ @space
*    LEFT OUTER JOIN jest AS jest1
*      ON jest1~objnr EQ afvc~objnr AND
*        jest1~stat  EQ 'I0009' AND
*        jest1~inact EQ @space
*    FOR ALL ENTRIES IN @it_workcenters
*    WHERE afvc~arbid EQ @it_workcenters-objid
*      AND ( afko~gstrp GE @lv_date_past AND
*        afko~gstrp LE @lv_date_future )
*      AND aufk~auart IN @lt_r_auart
**      AND aufk~aufnr IN @lt_r_aufnr_rng
**      AND afvc~vornr IN @lt_r_vornr_rng
*      AND t430~ruek IN @lt_r_ruek.

    " Get the orders
*    SELECT aufk~aufnr, afvc~vornr, afvc~steus
*        INTO CORRESPONDING FIELDS OF TABLE @DATA(lt_test_prod_orders)
*        FROM afvc AS afvc
**        INNER JOIN t430 AS t430
**          ON t430~steus EQ afvc~steus
*        INNER JOIN afko AS afko
*          ON afko~aufpl EQ afvc~aufpl
*        INNER JOIN aufk AS aufk
*          ON afko~aufnr EQ aufk~aufnr
*        INNER JOIN jest AS jest
*          ON jest~objnr EQ aufk~objnr AND
*            jest~stat  EQ 'I0002' AND
*            jest~inact EQ @space
*        LEFT OUTER JOIN jest AS jest1
*          ON jest1~objnr EQ afvc~objnr AND
*            jest1~stat  EQ 'I0009' AND
*            jest1~inact EQ @space
*        FOR ALL ENTRIES IN @it_workcenters
*        WHERE afvc~arbid EQ @it_workcenters-objid
*          AND ( afko~gstrp GE @lv_date_past AND
*            afko~gstrp LE @lv_date_future )
*          AND aufk~auart IN @lt_r_auart
*          AND aufk~aufnr IN @lt_r_aufnr_rng
*          AND afvc~vornr IN @lt_r_vornr_rng
*          AND t430~ruek IN @lt_r_ruek.

"DATA(lt_wrkctr) = VALUE tt_workcenter( ( arbpl = `174MIZ00` objid = `10002456` ) ).
*BREAK-POINT.
SELECT DISTINCT aufk~aufnr, afvc~vornr",sf021~arbpl
      INTO TABLE @DATA(lt_prdord_temp)
      FROM afvc AS afvc
      INNER JOIN t430 AS t430
        ON t430~steus EQ afvc~steus
      INNER JOIN afko AS afko
        ON afko~aufpl EQ afvc~aufpl
      INNER JOIN aufk AS aufk
        ON afko~aufnr EQ aufk~aufnr
*      INNER JOIN zabsf_pp021 AS sf021
*      LEFT OUTER JOIN zabsf_pp021 AS sf021
*        ON sf021~aufnr EQ aufk~aufnr AND
*           sf021~vornr EQ afvc~vornr
      INNER JOIN jest AS jest
        ON jest~objnr EQ aufk~objnr AND
           jest~stat  EQ 'I0002' AND
           jest~inact EQ @space
      LEFT OUTER JOIN jest AS jest1
        ON jest1~objnr EQ afvc~objnr AND
           jest1~stat  EQ 'I0009' AND
           jest1~inact EQ @space
  FOR ALL ENTRIES IN @it_workcenters"lt_wrkctr
      WHERE afvc~arbid EQ @it_workcenters-objid"lt_wrkctr-objid
        AND ( afko~gstrp GE @lv_date_past AND
              afko~gstrp LE @lv_date_future )
*        AND sf021~arbpl EQ @it_workcenters-arbpl"lt_wrkctr-arbpl
*        AND sf021~status_oper IN lr_status_oper
        AND aufk~auart IN @lt_r_auart
*        AND aufk~aufnr IN lt_aufnr_rng
*        AND afvc~vornr IN lt_vornr_rng
        AND t430~ruek IN @lt_r_ruek.

*  BREAK-POINT.

*DATA: lt_ORDER_NUMBER_RANGE TYPE BAPI_PP_ORDERRANGE,
*      lt_PRODPLANT_RANGE TYPE TABLE OF BAPI_ORDER_PRODPLANT_RANGE,
*      lt_ORDER_HEADER TYPE TABLE OF BAPI_ORDER_HEADER1.
*
*lt_PRODPLANT_RANGE = VALUE #( ( sign = 'I' option = 'EQ' low = iv_werks ) ).
*
*    CALL FUNCTION 'BAPI_PRODORD_GET_LIST'
**     EXPORTING
**       COLLECTIVE_ORDER          =
**     IMPORTING
**       RETURN                    =
*     TABLES
**       ORDER_NUMBER_RANGE        =
**       MATERIAL_RANGE            =
*       PRODPLANT_RANGE           = lt_PRODPLANT_RANGE
**       PLANPLANT_RANGE           =
**       ORDER_TYPE_RANGE          =
**       MRP_CNTRL_RANGE           =
**       PROD_SCHED_RANGE          =
**       SALES_ORD_RANGE           =
**       SALES_ORD_ITM_RANGE       =
**       WBS_ELEMENT_RANGE         =
**       SEQ_NO_RANGE              =
**       ORDER_PRIO_RANGE          =
*       ORDER_HEADER              = lt_ORDER_HEADER
*              .

lt_prod_orders = CORRESPONDING #( lt_prdord_temp ).
    " Remove duplicate orders
    SORT lt_prod_orders BY aufnr vornr ASCENDING.
    DELETE ADJACENT DUPLICATES FROM lt_prod_orders COMPARING aufnr vornr.

    rt_orders = CORRESPONDING #( lt_prod_orders ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_HELPER_CONFIRMEDSTOCKS2=>GET_ORDER_TYPE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_AREAID                      TYPE        ZABSF_PP_E_AREAID
* | [<-()] RT_R_AUART                     TYPE        TY_R_AUART
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_order_type.
    DATA lt_r_auart TYPE RANGE OF auart.

    " Get all order type
    SELECT auart
    FROM zabsf_pp019
    INTO TABLE @DATA(lt_zabsf_pp019)
    WHERE areaid EQ @iv_areaid.

    rt_r_auart = VALUE #( FOR <fs_pp019> IN lt_zabsf_pp019 ( sign = 'I' option = 'EQ' low = <fs_pp019>-auart ) ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_HELPER_CONFIRMEDSTOCKS2=>GET_WORKCENTER_OBJID
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_HNAME                       TYPE        CRHH-NAME
* | [--->] IV_WERKS                       TYPE        CRHH-WERKS
* | [<-()] RT_WORKCENTER                  TYPE        TT_WORKCENTER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_workcenter_objid.
    DATA: lv_hrchy_objid TYPE cr_objid,
          lt_crhs        TYPE TABLE OF crhs,
          lv_crhd_objid  TYPE cr_objid,
          lt_hierarquies TYPE STANDARD TABLE OF arbpl,
          lt_crhd        TYPE TABLE OF crhd.

    " Get Hierarchy Object ID
    CALL FUNCTION 'CR_HIERARCHY_READ_NAME'
      EXPORTING
        name                = iv_hname
        werks               = iv_werks
      IMPORTING
        objid               = lv_hrchy_objid
      EXCEPTIONS
        hierarchy_not_found = 1
        OTHERS              = 2.

    IF sy-subrc EQ 0.
      "  Get hierarchy object relations
      CALL FUNCTION 'CR_HIERARCHY_OBJECTS'
        EXPORTING
          objid               = lv_hrchy_objid
        TABLES
          t_crhs              = lt_crhs
        EXCEPTIONS
          hierarchy_not_found = 1
          OTHERS              = 2.

      IF sy-subrc EQ 0.
        "remover CTS que tem pais
        DELETE lt_crhs WHERE objid_up IS NOT INITIAL.
      ENDIF.
    ELSE.
      "obter id do centro de trabalho
      SELECT SINGLE objid
          FROM crhd
          INTO @lv_crhd_objid
          WHERE arbpl EQ @iv_hname
              AND werks EQ @iv_werks
              AND objty EQ 'A'.
      IF sy-subrc EQ 0.
        "obter filhos od CT
        SELECT objty_ho, objid_ho
        FROM crhs
        INTO CORRESPONDING FIELDS OF TABLE @lt_crhs
            WHERE objty_up EQ 'A'
            AND objid_up EQ @lv_crhd_objid.
      ENDIF.
    ENDIF.

    IF lt_crhs[] IS NOT INITIAL.
      " Get workcenter ID and description
      SELECT arbpl, objid, objty
          FROM crhd
          INTO CORRESPONDING FIELDS OF TABLE @lt_crhd
          FOR ALL ENTRIES IN @lt_crhs
          WHERE objty EQ @lt_crhs-objty_ho
              AND objid EQ @lt_crhs-objid_ho.
    ELSE.
      " Get workcenter ID and description
      SELECT arbpl, objid, objty
          FROM crhd
          INTO CORRESPONDING FIELDS OF TABLE @lt_crhd
          WHERE werks EQ @iv_werks.
    ENDIF.

    DELETE lt_crhd WHERE objty NE 'A'.
    IF lines( lt_crhd ) GE 1.
      rt_workcenter = CORRESPONDING #( lt_crhd ).
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_HELPER_CONFIRMEDSTOCKS2=>GET_WORKCENTERS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_OPRID                       TYPE        ZABSF_PP_E_OPRID
* | [--->] IT_HIERARCHIES                 TYPE        TT_HIERARCHY
* | [--->] IV_WERKS                       TYPE        CRHH-WERKS
* | [<-()] RT_WORKCENTERS                 TYPE        TT_WORKCENTER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_workcenters.
    CHECK it_hierarchies IS NOT INITIAL.

    zabsf_pp_cl_utils=>get_user_hrchy_wrkcntr_auth(
      EXPORTING iv_oprid       = iv_oprid             " Shopfloor - Shopfloor Operator ID
      IMPORTING er_workcenters = DATA(lr_workcenters) " Range for Workcenter
    ).

    rt_workcenters = VALUE #( FOR <fs_hierarchy> IN it_hierarchies ( LINES OF get_workcenter_objid( EXPORTING iv_hname = <fs_hierarchy> iv_werks = iv_werks ) ) ).

    DELETE rt_workcenters WHERE arbpl NOT IN lr_workcenters.

    SORT rt_workcenters BY arbpl objid ASCENDING.
    DELETE ADJACENT DUPLICATES FROM rt_workcenters.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_HELPER_CONFIRMEDSTOCKS2=>SUM_AND_GROUP
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_UNIQUE_MOVEMENTS            TYPE        TT_STANDARD_MOVEMENTS
* | [--->] IT_FILTERED_MOVEMENTS          TYPE        TT_SORTED_MOVEMENTS
* | [--->] IV_AUFNR                       TYPE        AUFNR
* | [<-->] CT_RESULTS                     TYPE        TT_CONFIRMEDSTOCKS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD sum_and_group.
    LOOP AT it_unique_movements ASSIGNING FIELD-SYMBOL(<fs_operation>).
      " Add the current order/material to the results table if it doesn't already exist
      IF NOT line_exists( ct_results[ material = <fs_operation>-matnr operation = <fs_operation>-name ] ).
        ct_results = VALUE #( BASE ct_results ( material = <fs_operation>-matnr
                                                operation = <fs_operation>-name
                                              ) ).
      ENDIF.

      " Sum the remaining stock
      ct_results[ material = <fs_operation>-matnr operation = <fs_operation>-name ]-remainingqty = REDUCE i(
                                  INIT val = ct_results[ material = <fs_operation>-matnr operation = <fs_operation>-name ]-remainingqty
                                  FOR wa IN
                                  FILTER #( it_filtered_movements
                                            WHERE aufnr EQ iv_aufnr
                                              AND vornr NE CONV vornr( `` )
                                              AND matnr EQ <fs_operation>-matnr
                                              AND ltxa1 EQ <fs_operation>-ltxa1 )
                                  NEXT val = val + wa-fica ).
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_helper_scrapmissing DEFINITION
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS get_seqid
      RETURNING
        VALUE(rv_seqid) TYPE zabsf_pp_e_seqid .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS lcl_helper_scrapmissing IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_HELPER_SCRAPMISSING=>GET_SEQID
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_SEQID                       TYPE ZABSF_PP_E_SEQID
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_seqid.
    DATA: lv_num TYPE zabsf_pp_e_seqid.

    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr             = '01'
        object                  = 'ZSF_ID034'
      IMPORTING
        number                  = lv_num
      EXCEPTIONS
        interval_not_found      = 1
        number_range_not_intern = 2
        object_not_found        = 3
        quantity_is_0           = 4
        quantity_is_not_1       = 5
        interval_overflow       = 6
        buffer_overflow         = 7
        OTHERS                  = 8.

    rv_seqid = COND #( WHEN sy-subrc EQ 0
                                        THEN lv_num
                                    ELSE 0 ).
  ENDMETHOD.
ENDCLASS.

CLASS lcl_helper_token DEFINITION
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS authenticate
      IMPORTING
        iv_username     TYPE string
        iv_password     TYPE string
      RETURNING
        VALUE(rv_valid) TYPE abap_bool .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS lcl_helper_token IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_HELPER_TOKEN=>AUTHENTICATE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_USERNAME                    TYPE        STRING
* | [--->] IV_PASSWORD                    TYPE        STRING
* | [<-()] RV_VALID                       TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD authenticate.
    " Hash input password
    DATA(lv_hashed_password) = zabsf_pp_cl_authentication=>new_get_hashed_password( EXPORTING iv_password = iv_password ).

    SELECT COUNT(*)
      FROM zsf_auth
      INTO @DATA(lv_count)
      WHERE username EQ @iv_username
      AND passwordhash EQ @lv_hashed_password.

    CHECK sy-subrc EQ 0.

    rv_valid = abap_true.
  ENDMETHOD.
ENDCLASS.


CLASS lcl_helper_user DEFINITION
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS get_userid
      RETURNING
        VALUE(rv_userid) TYPE int2 .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS lcl_helper_user IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method LCL_HELPER_USER=>GET_USERID
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_USERID                      TYPE INT2
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_userid.
    DATA: lv_num TYPE int2.

    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr             = '01'
        object                  = 'ZSF_USRID'
      IMPORTING
        number                  = lv_num
      EXCEPTIONS
        interval_not_found      = 1
        number_range_not_intern = 2
        object_not_found        = 3
        quantity_is_0           = 4
        quantity_is_not_1       = 5
        interval_overflow       = 6
        buffer_overflow         = 7
        OTHERS                  = 8.

    rv_userid = COND int2( WHEN sy-subrc EQ 0
                            THEN lv_num
                            ELSE 0 ).
  ENDMETHOD.
ENDCLASS.
