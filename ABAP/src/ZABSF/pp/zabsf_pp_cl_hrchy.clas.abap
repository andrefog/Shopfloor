class ZABSF_PP_CL_HRCHY definition
  public
  final
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !INITIAL_REFDT type VVDATUM
      !INPUT_OBJECT type ZABSF_PP_S_INPUTOBJECT .
  methods GET_HIERARCHY_DETAIL
    importing
      !AREAID type ZABSF_PP_E_AREAID
      !WERKS type WERKS_D
      !SHIFTID type ZABSF_PP_E_SHIFTID
      !HNAME type CR_HNAME
      !NO_SHIFT_CHECK type BOOLE_D optional
    changing
      !HRCHY_DETAIL type ZABSF_PP_S_HRCHY_DETAIL
      !RETURN_TAB type BAPIRET2_T .
  methods GET_HIERARCHIES
    importing
      !AREAID type ZABSF_PP_E_AREAID
      !WERKS type WERKS_D
      !SHIFTID type ZABSF_PP_E_SHIFTID
    changing
      !HRCHY_TAB type ZABSF_PP_T_HRCHY
      !RETURN_TAB type BAPIRET2_T .
  methods SET_REFDT
    importing
      !NEW_REFDT type VVDATUM .
protected section.
private section.

  data REFDT type VVDATUM .
  data INPUTOBJ type ZABSF_PP_S_INPUTOBJECT .
ENDCLASS.



CLASS ZABSF_PP_CL_HRCHY IMPLEMENTATION.


METHOD CONSTRUCTOR.

*Ref. Date
  refdt    = initial_refdt.

*App input data
  inputobj = input_object.

ENDMETHOD.


METHOD get_hierarchies.
*Types
  TYPES: BEGIN OF ty_crtx,
           name  TYPE cr_hname,
           ktext TYPE cr_ktext,
         END OF ty_crtx.

*Internl tables
  DATA: lt_crtx TYPE TABLE OF ty_crtx.

*Structures
  DATA: ls_crtx TYPE ty_crtx.

*Variables
  DATA: l_langu TYPE sy-langu.

*Field symbols
  FIELD-SYMBOLS: <fs_hrchy> TYPE zabsf_pp_s_hrchy.

**Select basic hierarchy data with a reference date and logon language
*  SELECT sft002~areaid sft002~shiftid sft002~werks crhh~name AS hname crtx~ktext
*    INTO CORRESPONDING FIELDS OF TABLE hrchy_tab
*    FROM ZABSF_PP002 AS sft002
*   INNER JOIN crhh AS crhh
*      ON crhh~name EQ sft002~hname
*   INNER JOIN crtx AS crtx
*      ON crtx~objty EQ crhh~objty
*     AND crtx~objid EQ crhh~objid
*   WHERE sft002~areaid  EQ areaid
*     AND sft002~werks   EQ werks
*     AND sft002~shiftid EQ shiftid
*     AND sft002~begda   LE refdt
*     AND sft002~endda   GE refdt
*     AND crhh~objty     EQ 'H'
*     AND crtx~spras     EQ sy-langu.

*Select basic hierarchy data with a reference date and logon language
  SELECT sft002~areaid sft002~shiftid sft002~werks crhh~name AS hname
    INTO CORRESPONDING FIELDS OF TABLE hrchy_tab
    FROM zabsf_pp002 AS sft002
   INNER JOIN crhh AS crhh
      ON crhh~name EQ sft002~hname
   WHERE sft002~areaid  EQ areaid
     AND sft002~werks   EQ werks
     AND sft002~shiftid EQ shiftid
     AND sft002~begda   LE refdt
     AND sft002~endda   GE refdt
     AND crhh~objty     EQ 'H'.

  IF hrchy_tab[] IS NOT INITIAL.
*  Get hierarchy description
    SELECT crhh~name crtx~ktext
      INTO CORRESPONDING FIELDS OF TABLE lt_crtx
      FROM crtx AS crtx
     INNER JOIN crhh AS crhh
        ON crhh~objty EQ crtx~objty
       AND crhh~objid EQ crtx~objid
       FOR ALL ENTRIES IN hrchy_tab
     WHERE crhh~name  EQ hrchy_tab-hname
       AND crhh~werks EQ hrchy_tab-werks
       AND crhh~objty EQ 'H'
       AND crtx~spras EQ inputobj-language.

    IF lt_crtx[] IS INITIAL.
*    Get alternative language
      SELECT SINGLE spras
        FROM zabsf_pp061
        INTO l_langu
       WHERE werks      EQ inputobj-werks
         AND is_default NE space.

*    Get hierarchy description
      SELECT crhh~name crtx~ktext
        INTO CORRESPONDING FIELDS OF TABLE lt_crtx
        FROM crtx AS crtx
       INNER JOIN crhh AS crhh
          ON crhh~objty EQ crtx~objty
         AND crhh~objid EQ crtx~objid
         FOR ALL ENTRIES IN hrchy_tab
       WHERE crhh~name  EQ hrchy_tab-hname
         AND crhh~werks EQ hrchy_tab-werks
         AND crhh~objty EQ 'H'
         AND crtx~spras EQ l_langu.
    ENDIF.

    LOOP AT hrchy_tab ASSIGNING <fs_hrchy>.
*    Read hierarchy description
      READ TABLE lt_crtx INTO ls_crtx WITH KEY name = <fs_hrchy>-hname.

      IF sy-subrc EQ 0.
*      Hierarchy description
        <fs_hrchy>-ktext = ls_crtx-ktext.
      ENDIF.
    ENDLOOP.
  ELSE.
*  No active shifts found
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'W'
        msgno      = '004'
      CHANGING
        return_tab = return_tab.
  ENDIF.
ENDMETHOD.


method get_hierarchy_detail.
*Reference
  data lref_sf_wrkctr type ref to zabsf_pp_cl_wrkctr.

*Get hierarchies and corresponding workcenters
  select single *
    from zabsf_pp002
    into corresponding fields of hrchy_detail
   where shiftid eq shiftid
     and areaid  eq areaid
     and werks   eq werks
     and begda   le refdt
     and endda   ge refdt.

  if sy-subrc = 0.
*  Creta object workcenters
    create object lref_sf_wrkctr
      exporting
        initial_refdt = refdt
        input_object  = inputobj.

*  Get workcenters
    call method lref_sf_wrkctr->get_workcenters
      exporting
        hname          = hname
        werks          = werks
        no_shift_check = no_shift_check
      importing
        parent         = hrchy_detail-parent
        ktext          = hrchy_detail-ktext
      changing
        wrkctr_tab     = hrchy_detail-wrkctr_tab
        return_tab     = return_tab.

  else.
*  No hierarchies found for the input data
    call method zabsf_pp_cl_log=>add_message
      exporting
        msgty      = 'E'
        msgno      = '005'
      changing
        return_tab = return_tab.
  endif.
endmethod.


METHOD SET_REFDT.

*Set new reference date
  refdt = new_refdt.

  ENDMETHOD.
ENDCLASS.
