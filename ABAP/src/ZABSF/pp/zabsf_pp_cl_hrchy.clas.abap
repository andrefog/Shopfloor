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
      !OPRID type ZABSF_PP_E_OPRID optional
      !NO_SHIFT_CHECK type BOOLE_D optional
    changing
      !HRCHY_DETAIL type ZABSF_PP_S_HRCHY_DETAIL
      !RETURN_TAB type BAPIRET2_T .
  methods GET_HIERARCHIES
    importing
      !AREAID type ZABSF_PP_E_AREAID
      !WERKS type WERKS_D
      !OPRID type ZABSF_PP_E_OPRID optional
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

  IF oprid IS SUPPLIED.
    zabsf_pp_cl_utils=>get_user_hrchy_wrkcntr_auth(
      EXPORTING iv_oprid       = oprid       " Shopfloor - Shopfloor Operator ID
      IMPORTING er_hierarchies = DATA(lr_hierarchies) " Range For Hierarchies
    ).
  ENDIF.


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
   WHERE sft002~hname   IN lr_hierarchies
     AND sft002~areaid  EQ areaid
     AND sft002~werks   EQ werks
     AND sft002~shiftid EQ shiftid
     AND sft002~begda   LE refdt
     AND sft002~endda   GE refdt
     AND crhh~objty     EQ 'H'.

  IF hrchy_tab[] IS NOT INITIAL.
    SORT hrchy_tab BY hname.

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
       AND crtx~spras EQ sy-langu.

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


METHOD get_hierarchy_detail.
*Reference
  DATA lref_sf_wrkctr TYPE REF TO zabsf_pp_cl_wrkctr.

*Get hierarchies and corresponding workcenters
  SELECT SINGLE *
    FROM zabsf_pp002
    INTO CORRESPONDING FIELDS OF hrchy_detail
   WHERE shiftid EQ shiftid
     AND areaid  EQ areaid
     AND werks   EQ werks
     AND begda   LE refdt
     AND endda   GE refdt.

  IF sy-subrc = 0.
*  Creta object workcenters
    CREATE OBJECT lref_sf_wrkctr
      EXPORTING
        initial_refdt = refdt
        input_object  = inputobj.

*  Get workcenters
    CALL METHOD lref_sf_wrkctr->get_workcenters
      EXPORTING
        hname          = hname
        werks          = werks
        oprid          = oprid
        no_shift_check = no_shift_check
      IMPORTING
        parent         = hrchy_detail-parent
        ktext          = hrchy_detail-ktext
      CHANGING
        wrkctr_tab     = hrchy_detail-wrkctr_tab
        return_tab     = return_tab.

* BEG - João Lopes - 17.11.2022
* Areas: OPT e MTG - sort hierarchies and work centers by "KTEXT" field
*        MEC - sort hierarchies and work centers by "ARBPL" field
    IF areaid <> 'MEC'.
      SORT hrchy_detail-wrkctr_tab BY ktext.
    ELSE.
      SORT hrchy_detail-wrkctr_tab BY arbpl.
    ENDIF.
* END - João Lopes
  ELSE.
*  No hierarchies found for the input data
    CALL METHOD zabsf_pp_cl_log=>add_message
      EXPORTING
        msgty      = 'E'
        msgno      = '005'
      CHANGING
        return_tab = return_tab.
  ENDIF.
ENDMETHOD.


METHOD SET_REFDT.

*Set new reference date
  refdt = new_refdt.

  ENDMETHOD.
ENDCLASS.
