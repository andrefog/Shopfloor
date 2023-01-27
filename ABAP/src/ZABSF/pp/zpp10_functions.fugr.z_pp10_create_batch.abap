FUNCTION Z_PP10_CREATE_BATCH.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(IS_BATCH) TYPE  ZABSF_BATCH
*"  EXPORTING
*"     REFERENCE(EV_NEW_CHARG) TYPE  CHARG_D
*"  TABLES
*"      RETURN_TAB STRUCTURE  BAPIRET2
*"----------------------------------------------------------------------

*Variables
  DATA: l_batch_nr  TYPE charg_d,
        l_batch_new TYPE charg_d.

*Constants
  CONSTANTS: c_objty     TYPE cr_objty VALUE 'A',   "Work Center
             c_veran_100 TYPE ap_veran VALUE '100', "Vulcanization
             c_veran_200 TYPE ap_veran VALUE '200'. "Thermoplastic

*Refresh global internal tables
  PERFORM init_variables.

*Create Batch
  PERFORM create_batch USING    is_batch
                       CHANGING l_batch_new.

  IF l_batch_new IS NOT INITIAL.
*  Check workcenter
    SELECT SINGLE *
      FROM crhd
      INTO @DATA(ls_crhd)
     WHERE arbpl EQ @is_batch-arbpl
       AND objty EQ @c_objty
       AND begda LE @sy-datum
       AND endda GE @sy-datum
       AND veran IN ( @c_veran_100, @c_veran_200 ).

    IF sy-subrc EQ 0.
*    Change batch characteristics
      PERFORM change_batch USING is_batch l_batch_new.
    ELSE.
*    Update production date
      PERFORM update_prod_date_batch USING is_batch l_batch_new.
    ENDIF.
  ENDIF.

*Message error
  IF gt_return[] IS NOT INITIAL.
    return_tab[] = gt_return[].
  ENDIF.

*Batch created
  ev_new_charg = l_batch_new.



ENDFUNCTION.
