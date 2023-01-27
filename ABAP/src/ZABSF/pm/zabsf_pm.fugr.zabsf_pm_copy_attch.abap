FUNCTION zabsf_pm_copy_attch.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(I_AUFNR) TYPE  AUFNR
*"     VALUE(I_BANFN) TYPE  BANFN
*"     VALUE(ATTACH_LIST) TYPE  ZABSF_PM_T_ATTCH
*"  EXPORTING
*"     VALUE(R_COPY_OK) TYPE  FLAG
*"----------------------------------------------------------------------
  DATA: o_absf_pm TYPE REF TO zcl_absf_pm.

  DATA ls_object TYPE sibflporb.
  DATA lt_attach_list TYPE zabsf_pm_t_attachment_list.
  DATA ls_attach_list TYPE LINE OF zabsf_pm_t_attachment_list.
  DATA et_attach_list TYPE zabsf_pm_t_attachment_list.

  DATA lt_services TYPE tgos_sels.
  DATA ls_service TYPE sgos_sels.
  DATA ls_source TYPE sibflporb.
  DATA ls_target TYPE sibflporb.

  IF NOT i_aufnr IS INITIAL AND NOT i_banfn IS INITIAL.

    CLEAR ls_object.
    CLEAR ls_attach_list.
    CLEAR lt_attach_list[].

    ls_object-typeid    = 'BUS2007'.
    ls_object-instid    = i_aufnr.
    ls_object-catid     = 'BO'.

    CREATE OBJECT o_absf_pm.

    CALL METHOD o_absf_pm->get_attachments_list
      EXPORTING
        i_gos_obj      = ls_object
      IMPORTING
        et_attachments = lt_attach_list.


    IF lt_attach_list IS NOT INITIAL.

      LOOP AT lt_attach_list INTO ls_attach_list.

        READ TABLE attach_list ASSIGNING FIELD-SYMBOL(<attach>) WITH KEY brelguid = ls_attach_list-brelguid
                                                                         atta_id = ls_attach_list-atta_id
                                                                         atta_cat = ls_attach_list-atta_cat.
        IF <attach> IS ASSIGNED.
          APPEND  ls_attach_list TO et_attach_list.
          UNASSIGN <attach>.
        ENDIF.
      ENDLOOP.

    ENDIF.
  ENDIF.

  LOOP AT et_attach_list INTO ls_attach_list.

* Source
    ls_source-instid = i_aufnr.
    ls_source-typeid = 'BUS2007'.
    ls_source-catid  = 'BO'.
*
* Target
    ls_target-instid = i_banfn.
    ls_target-typeid = 'BUS2105'.
    ls_target-catid  = 'BO'.
*
* Copy the objects between Source and Target
    cl_gos_service_tools=>copy_linked_objects(
    is_source            = ls_source
    is_target            = ls_target ).

  ENDLOOP.

  COMMIT WORK AND WAIT.
  IF sy-subrc EQ 0.
    r_copy_ok = abap_true.
  ENDIF.

ENDFUNCTION.
