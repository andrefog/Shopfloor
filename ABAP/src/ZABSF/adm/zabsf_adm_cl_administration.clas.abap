class ZABSF_ADM_CL_ADMINISTRATION definition
  public
  final
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !INITIAL_REFDT type VVDATUM
      !INPUT_OBJECT type ZABSF_PP_S_INPUTOBJECT .
  methods SET_REFDT
    importing
      !NEW_REFDT type VVDATUM .
  methods GET_PLANTS
    changing
      !WERKS_TAB type ZABSF_PP_T_WERKS
      !RETURN_TAB type BAPIRET2_T .
  methods GET_AREA_WITH_TYPE_AREA
    changing
      !AREA_TAB type ZABSF_PP_T_AREA_TYPE_A
      !RETURN_TAB type BAPIRET2_T .
  methods GET_LANGUAGES
    changing
      !LANGUAGES_TAB type ZABSF_PP_T_LANGUAGES
      !RETURN_TAB type BAPIRET2_T .
  methods GET_PARAMETER
    importing
      !I_PARAMETER type PARAM_ID
    exporting
      !ET_RANGE type TABLE .
protected section.
private section.

  data REFDT type VVDATUM .
  data INPUTOBJ type ZABSF_PP_S_INPUTOBJECT .
ENDCLASS.



CLASS ZABSF_ADM_CL_ADMINISTRATION IMPLEMENTATION.


  METHOD CONSTRUCTOR.
*  Ref. Date
    refdt = initial_refdt.

*  App input data
    inputobj = input_object.
  ENDMETHOD.


  METHOD GET_AREA_WITH_TYPE_AREA.
*  Variables
    DATA: lv_tarea_desc TYPE zabsf_pp_e_tarea_desc,
          lv_area_desc  TYPE zabsf_pp_e_areadesc.

*  Ranges
    DATA: r_werks   TYPE RANGE OF werks_d,
          ls_werks  LIKE LINE OF r_werks,
          r_areaid  TYPE RANGE OF zabsf_pp_e_areaid,
          ls_areaid LIKE LINE OF r_areaid.

*  Field symbols
    FIELD-SYMBOLS: <fs_area> TYPE zabsf_pp_s_area_type_a.

    REFRESH area_tab.

*  Create range
*  Plant
    IF inputobj-werks IS NOT INITIAL.
      CLEAR ls_werks.
      ls_werks-sign = 'I'.
      ls_werks-option = 'EQ'.
      ls_werks-low = inputobj-werks.

      APPEND ls_werks TO r_werks.
    ENDIF.

*  Area ID
    IF inputobj-areaid IS NOT INITIAL.
      CLEAR ls_areaid.
      ls_areaid-sign = 'I'.
      ls_areaid-option = 'EQ'.
      ls_areaid-low = inputobj-areaid.

      APPEND ls_areaid TO r_areaid.
    ENDIF.

*  Get all types of area for plant
    SELECT *
      FROM zabsf_pp008
      INTO CORRESPONDING FIELDS OF TABLE area_tab
     WHERE areaid IN r_areaid
       AND werks  IN r_werks.

    IF sy-subrc EQ 0.
*    Get types of area description
      LOOP AT area_tab ASSIGNING <fs_area>.
        CLEAR: lv_tarea_desc,
               lv_area_desc.

*      Get description of area
        SELECT SINGLE area_desc
          FROM zabsf_pp000_t
          INTO lv_area_desc
         WHERE areaid EQ <fs_area>-areaid
           AND spras  EQ sy-langu.

        IF sy-subrc EQ 0.
          <fs_area>-area_desc = lv_area_desc.
        ENDIF.

*      Get description fo type of area
        SELECT SINGLE tarea_desc
          FROM zabsf_pp059_t
          INTO lv_tarea_desc
         WHERE tarea_id EQ <fs_area>-tarea_id
           AND spras    EQ sy-langu.

        IF sy-subrc EQ 0.
          <fs_area>-tarea_desc = lv_tarea_desc.
        ENDIF.
      ENDLOOP.
    ELSE.
*    No data found for inputs
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'I'
          msgno      = '018'
        CHANGING
          return_tab = return_tab.
    ENDIF.
  ENDMETHOD.


  METHOD GET_LANGUAGES.
*  Internal tables
    DATA: lt_pp_sf061 TYPE TABLE OF zabsf_pp061.

*  Structures
    DATA: ls_pp_sf061  TYPE zabsf_pp061,
          ls_languages TYPE zabsf_pp_s_languages.

    REFRESH lt_pp_sf061.

*  Get languages for shopfloor
    SELECT *
      FROM zabsf_pp061
      INTO CORRESPONDING FIELDS OF TABLE lt_pp_sf061
     WHERE werks EQ inputobj-werks.

    IF lt_pp_sf061[] IS NOT INITIAL.
      LOOP AT lt_pp_sf061 INTO ls_pp_sf061.
        CLEAR ls_languages.

*      Get ISO code for language
        SELECT SINGLE laiso
          FROM t002
          INTO ls_languages-laiso
         WHERE spras EQ ls_pp_sf061-spras.

*      Default language
        ls_languages-is_default = ls_pp_sf061-is_default.

        APPEND ls_languages TO languages_tab.
      ENDLOOP.
    ELSE.
*    No data found for inputs
      CALL METHOD zabsf_pp_cl_log=>add_message
        EXPORTING
          msgty      = 'I'
          msgno      = '018'
        CHANGING
          return_tab = return_tab.
    ENDIF.
  ENDMETHOD.


 method GET_PARAMETER.

    DATA: lv_ref TYPE REF TO data.

    CHECK i_parameter IS NOT INITIAL.

    CREATE DATA lv_ref LIKE LINE OF et_range.
    ASSIGN lv_ref->* TO FIELD-SYMBOL(<range>).
    CHECK sy-subrc = 0.

    ASSIGN COMPONENT 'SIGN' OF STRUCTURE <range> TO FIELD-SYMBOL(<sign>).
    CHECK sy-subrc = 0.

    ASSIGN COMPONENT 'OPTION' OF STRUCTURE <range> TO FIELD-SYMBOL(<option>).
    CHECK sy-subrc = 0.

    ASSIGN COMPONENT 'LOW' OF STRUCTURE <range> TO FIELD-SYMBOL(<low>).
    CHECK sy-subrc = 0.

    SELECT SINGLE *
      FROM zabsf_adm_param
      INTO @DATA(ls_param)
     WHERE parid = @i_parameter.

    CHECK sy-subrc = 0.

    <sign> = ls_param-sign.
    <option> = 'EQ'.

    SPLIT ls_param-parva AT ';' INTO TABLE DATA(lt_split).

    LOOP AT lt_split INTO DATA(ls_split).
      <low> = ls_split.
      INSERT <range> INTO et_range INDEX sy-tabix.
    ENDLOOP.
  endmethod.


  method get_plants.
*  Get all plants
    select t001w~werks t001w~name1 zsf_008~areaid
      from t001w as t001w
      inner join zabsf_pp008 as zsf_008
      on zsf_008~werks eq t001w~werks
      into corresponding fields of table werks_tab
        where adrnr ne space.
*  If no value found
    if werks_tab[] is initial.
*    No data found for inputs
      call method zabsf_pp_cl_log=>add_message
        exporting
          msgty      = 'I'
          msgno      = '018'
        changing
          return_tab = return_tab.
      "leave process
      return.
    endif.

    "get inital shift
    select *
      from zabsf_pp002
      into table @data(lt_shifts_tab)
      for all entries in @werks_tab
        where werks  eq @werks_tab-werks
          and areaid eq @werks_tab-areaid.
    if sy-subrc eq 0.
      loop at werks_tab assigning field-symbol(<fs_werks_str>).
        <fs_werks_str>-first_shift = cond #( when line_exists( lt_shifts_tab[ werks  = <fs_werks_str>-werks
                                                                              areaid = <fs_werks_str>-areaid ] )
                                             then lt_shifts_tab[ werks = <fs_werks_str>-werks
                                                                 areaid = <fs_werks_str>-areaid ]-shiftid ).
      endloop.
    endif.
  endmethod.


  METHOD SET_REFDT.
*  Set new reference date
    refdt = new_refdt.
  ENDMETHOD.
ENDCLASS.
