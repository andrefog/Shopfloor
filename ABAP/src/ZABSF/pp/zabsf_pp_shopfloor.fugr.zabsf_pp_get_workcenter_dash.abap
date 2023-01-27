FUNCTION zabsf_pp_get_workcenter_dash.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"     VALUE(ARBPL) TYPE  ARBPL OPTIONAL
*"     VALUE(REFDT) TYPE  VVDATUM OPTIONAL
*"     VALUE(HIERARCHIES) TYPE  ZABSF_PP_T_HRCHY OPTIONAL
*"     VALUE(AUFNR) TYPE  AUFNR OPTIONAL
*"     VALUE(VORNR) TYPE  VORNR OPTIONAL
*"     VALUE(HNAME) TYPE  CR_HNAME OPTIONAL
*"  EXPORTING
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"     VALUE(WORKCENTER_DASHBOARD) TYPE  ZABSF_PP_T_WORKCENTER_DASHBOAR
*"----------------------------------------------------------------------

*Local references
  DATA: lref_sf_dashboard TYPE REF TO zabsf_pp_cl_dashboard.

*Get class of interface
  SELECT SINGLE methodname
      FROM zabsf_pp003
      INTO (@DATA(l_method))
     WHERE werks    EQ @inputobj-werks
       AND id_class EQ '18'
       AND endda    GE @refdt
       AND begda    LE @refdt.

*Create object of class
  CREATE OBJECT lref_sf_dashboard
    EXPORTING
      input_refdt    = refdt
      input_inputobj = inputobj.

*Get aditional data of Work center (LCD)
  CALL METHOD lref_sf_dashboard->(l_method)
    EXPORTING
      arbpl                = arbpl
      aufnr                = aufnr
      vornr                = vornr
      hname                = hname
      hierarchies          = hierarchies
      refdt                = refdt
      inputobj             = inputobj
    IMPORTING
      workcenter_dashboard = workcenter_dashboard
      return_tab           = return_tab.

ENDFUNCTION.
