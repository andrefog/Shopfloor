*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZABSF_MOB_SM30
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZABSF_MOB_SM30     .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
