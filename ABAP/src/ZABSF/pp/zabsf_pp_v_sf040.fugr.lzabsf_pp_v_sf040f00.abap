*---------------------------------------------------------------------*
*    view related FORM routines
*---------------------------------------------------------------------*
*...processing: ZABSF_PP_V_SF040................................*
FORM GET_DATA_ZABSF_PP_V_SF040.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZABSF_PP061 WHERE
(VIM_WHERETAB) .
    CLEAR ZABSF_PP_V_SF040 .
ZABSF_PP_V_SF040-MANDT =
ZABSF_PP061-MANDT .
ZABSF_PP_V_SF040-WERKS =
ZABSF_PP061-WERKS .
ZABSF_PP_V_SF040-SPRAS =
ZABSF_PP061-SPRAS .
ZABSF_PP_V_SF040-IS_DEFAULT =
ZABSF_PP061-IS_DEFAULT .
<VIM_TOTAL_STRUC> = ZABSF_PP_V_SF040.
    APPEND TOTAL.
  ENDSELECT.
  SORT TOTAL BY <VIM_XTOTAL_KEY>.
  <STATUS>-ALR_SORTED = 'R'.
*.check dynamic selectoptions (not in DDIC)...........................*
  IF X_HEADER-SELECTION NE SPACE.
    PERFORM CHECK_DYNAMIC_SELECT_OPTIONS.
  ELSEIF X_HEADER-DELMDTFLAG NE SPACE.
    PERFORM BUILD_MAINKEY_TAB.
  ENDIF.
  REFRESH EXTRACT.
ENDFORM.
*---------------------------------------------------------------------*
FORM DB_UPD_ZABSF_PP_V_SF040 .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZABSF_PP_V_SF040.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZABSF_PP_V_SF040-ST_DELETE EQ GELOESCHT.
     READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
     IF SY-SUBRC EQ 0.
       DELETE EXTRACT INDEX SY-TABIX.
     ENDIF.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN GELOESCHT.
  SELECT SINGLE FOR UPDATE * FROM ZABSF_PP061 WHERE
  WERKS = ZABSF_PP_V_SF040-WERKS AND
  SPRAS = ZABSF_PP_V_SF040-SPRAS .
    IF SY-SUBRC = 0.
    DELETE ZABSF_PP061 .
    ENDIF.
    IF STATUS-DELETE EQ GELOESCHT.
      READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY> BINARY SEARCH.
      DELETE EXTRACT INDEX SY-TABIX.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN OTHERS.
  SELECT SINGLE FOR UPDATE * FROM ZABSF_PP061 WHERE
  WERKS = ZABSF_PP_V_SF040-WERKS AND
  SPRAS = ZABSF_PP_V_SF040-SPRAS .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZABSF_PP061.
    ENDIF.
ZABSF_PP061-MANDT =
ZABSF_PP_V_SF040-MANDT .
ZABSF_PP061-WERKS =
ZABSF_PP_V_SF040-WERKS .
ZABSF_PP061-SPRAS =
ZABSF_PP_V_SF040-SPRAS .
ZABSF_PP061-IS_DEFAULT =
ZABSF_PP_V_SF040-IS_DEFAULT .
    IF SY-SUBRC = 0.
    UPDATE ZABSF_PP061 ##WARN_OK.
    ELSE.
    INSERT ZABSF_PP061 .
    ENDIF.
    READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
    IF SY-SUBRC EQ 0.
      <XACT> = ORIGINAL.
      MODIFY EXTRACT INDEX SY-TABIX.
    ENDIF.
    <ACTION> = ORIGINAL.
    MODIFY TOTAL.
  ENDCASE.
ENDLOOP.
CLEAR: STATUS_ZABSF_PP_V_SF040-UPD_FLAG,
STATUS_ZABSF_PP_V_SF040-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ZABSF_PP_V_SF040.
  SELECT SINGLE * FROM ZABSF_PP061 WHERE
WERKS = ZABSF_PP_V_SF040-WERKS AND
SPRAS = ZABSF_PP_V_SF040-SPRAS .
ZABSF_PP_V_SF040-MANDT =
ZABSF_PP061-MANDT .
ZABSF_PP_V_SF040-WERKS =
ZABSF_PP061-WERKS .
ZABSF_PP_V_SF040-SPRAS =
ZABSF_PP061-SPRAS .
ZABSF_PP_V_SF040-IS_DEFAULT =
ZABSF_PP061-IS_DEFAULT .
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZABSF_PP_V_SF040 USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZABSF_PP_V_SF040-WERKS TO
ZABSF_PP061-WERKS .
MOVE ZABSF_PP_V_SF040-SPRAS TO
ZABSF_PP061-SPRAS .
MOVE ZABSF_PP_V_SF040-MANDT TO
ZABSF_PP061-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZABSF_PP061'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZABSF_PP061 TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZABSF_PP061'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*
