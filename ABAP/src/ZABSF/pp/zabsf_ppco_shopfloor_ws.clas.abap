class ZABSF_PPCO_SHOPFLOOR_WS definition
  public
  inheriting from CL_PROXY_CLIENT
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !LOGICAL_PORT_NAME type PRX_LOGICAL_PORT_NAME optional
    raising
      CX_AI_SYSTEM_FAULT .
  methods GET_PDF
    importing
      !INPUT type ZABSF_PPGET_PDFSOAP_IN
    exporting
      !OUTPUT type ZABSF_PPGET_PDFSOAP_OUT
    raising
      CX_AI_SYSTEM_FAULT .
  methods SAVE_REPORTS
    importing
      !INPUT type ZABSF_PPSAVE_REPORTS_SOAP_IN
    exporting
      !OUTPUT type ZABSF_PPSAVE_REPORTS_SOAP_OUT
    raising
      CX_AI_SYSTEM_FAULT .
protected section.
private section.
ENDCLASS.



CLASS ZABSF_PPCO_SHOPFLOOR_WS IMPLEMENTATION.


  method CONSTRUCTOR.

  super->constructor(
    class_name          = 'ZABSF_PPCO_SHOPFLOOR_WS'
    logical_port_name   = logical_port_name
  ).

  endmethod.


  method GET_PDF.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'INPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of INPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'GET_PDF'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method SAVE_REPORTS.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'INPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of INPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'SAVE_REPORTS'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.
ENDCLASS.
