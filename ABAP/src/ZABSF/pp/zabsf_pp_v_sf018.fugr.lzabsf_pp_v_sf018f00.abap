*---------------------------------------------------------------------*
*    view related FORM routines
*---------------------------------------------------------------------*
*...processing: ZABSF_PP_V_SF018................................*
FORM GET_DATA_ZABSF_PP_V_SF018.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZABSF_PP024 WHERE
(VIM_WHERETAB) .
    CLEAR ZABSF_PP_V_SF018 .
ZABSF_PP_V_SF018-MANDT =
ZABSF_PP024-MANDT .
ZABSF_PP_V_SF018-ACTV =
ZABSF_PP024-ACTV .
ZABSF_PP_V_SF018-STATUS_ACTV =
ZABSF_PP024-STATUS_ACTV .
    SELECT SINGLE * FROM ZABSF_PP018 WHERE
ACTV = ZABSF_PP024-ACTV .
    IF SY-SUBRC EQ 0.
      SELECT SINGLE * FROM ZABSF_PP018_T WHERE
ACTV = ZABSF_PP018-ACTV AND
SPRAS = SY-LANGU .
      IF SY-SUBRC EQ 0.
ZABSF_PP_V_SF018-DESC_ACTV =
ZABSF_PP018_T-DESC_ACTV .
      ENDIF.
    ENDIF.
    SELECT SINGLE * FROM ZABSF_PP023 WHERE
STATUS_ACTV = ZABSF_PP024-STATUS_ACTV .
    IF SY-SUBRC EQ 0.
      SELECT SINGLE * FROM ZABSF_PP023_T WHERE
STATUS_ACTV = ZABSF_PP023-STATUS_ACTV AND
SPRAS = SY-LANGU .
      IF SY-SUBRC EQ 0.
ZABSF_PP_V_SF018-STATUS_DESC =
ZABSF_PP023_T-STATUS_DESC .
      ENDIF.
    ENDIF.
<VIM_TOTAL_STRUC> = ZABSF_PP_V_SF018.
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
FORM DB_UPD_ZABSF_PP_V_SF018 .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZABSF_PP_V_SF018.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZABSF_PP_V_SF018-ST_DELETE EQ GELOESCHT.
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
  SELECT SINGLE FOR UPDATE * FROM ZABSF_PP024 WHERE
  ACTV = ZABSF_PP_V_SF018-ACTV AND
  STATUS_ACTV = ZABSF_PP_V_SF018-STATUS_ACTV .
    IF SY-SUBRC = 0.
    DELETE ZABSF_PP024 .
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
  SELECT SINGLE FOR UPDATE * FROM ZABSF_PP024 WHERE
  ACTV = ZABSF_PP_V_SF018-ACTV AND
  STATUS_ACTV = ZABSF_PP_V_SF018-STATUS_ACTV .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZABSF_PP024.
    ENDIF.
ZABSF_PP024-MANDT =
ZABSF_PP_V_SF018-MANDT .
ZABSF_PP024-ACTV =
ZABSF_PP_V_SF018-ACTV .
ZABSF_PP024-STATUS_ACTV =
ZABSF_PP_V_SF018-STATUS_ACTV .
    IF SY-SUBRC = 0.
    UPDATE ZABSF_PP024 ##WARN_OK.
    ELSE.
    INSERT ZABSF_PP024 .
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
CLEAR: STATUS_ZABSF_PP_V_SF018-UPD_FLAG,
STATUS_ZABSF_PP_V_SF018-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ZABSF_PP_V_SF018.
  SELECT SINGLE * FROM ZABSF_PP024 WHERE
ACTV = ZABSF_PP_V_SF018-ACTV AND
STATUS_ACTV = ZABSF_PP_V_SF018-STATUS_ACTV .
ZABSF_PP_V_SF018-MANDT =
ZABSF_PP024-MANDT .
ZABSF_PP_V_SF018-ACTV =
ZABSF_PP024-ACTV .
ZABSF_PP_V_SF018-STATUS_ACTV =
ZABSF_PP024-STATUS_ACTV .
    SELECT SINGLE * FROM ZABSF_PP018 WHERE
ACTV = ZABSF_PP024-ACTV .
    IF SY-SUBRC EQ 0.
      SELECT SINGLE * FROM ZABSF_PP018_T WHERE
ACTV = ZABSF_PP018-ACTV AND
SPRAS = SY-LANGU .
      IF SY-SUBRC EQ 0.
ZABSF_PP_V_SF018-DESC_ACTV =
ZABSF_PP018_T-DESC_ACTV .
      ELSE.
        CLEAR SY-SUBRC.
        CLEAR ZABSF_PP_V_SF018-DESC_ACTV .
      ENDIF.
    ELSE.
      CLEAR SY-SUBRC.
      CLEAR ZABSF_PP_V_SF018-DESC_ACTV .
    ENDIF.
    SELECT SINGLE * FROM ZABSF_PP023 WHERE
STATUS_ACTV = ZABSF_PP024-STATUS_ACTV .
    IF SY-SUBRC EQ 0.
      SELECT SINGLE * FROM ZABSF_PP023_T WHERE
STATUS_ACTV = ZABSF_PP023-STATUS_ACTV AND
SPRAS = SY-LANGU .
      IF SY-SUBRC EQ 0.
ZABSF_PP_V_SF018-STATUS_DESC =
ZABSF_PP023_T-STATUS_DESC .
      ELSE.
        CLEAR SY-SUBRC.
        CLEAR ZABSF_PP_V_SF018-STATUS_DESC .
      ENDIF.
    ELSE.
      CLEAR SY-SUBRC.
      CLEAR ZABSF_PP_V_SF018-STATUS_DESC .
    ENDIF.
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZABSF_PP_V_SF018 USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZABSF_PP_V_SF018-ACTV TO
ZABSF_PP024-ACTV .
MOVE ZABSF_PP_V_SF018-STATUS_ACTV TO
ZABSF_PP024-STATUS_ACTV .
MOVE ZABSF_PP_V_SF018-MANDT TO
ZABSF_PP024-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZABSF_PP024'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZABSF_PP024 TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZABSF_PP024'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*
FORM COMPL_ZABSF_PP_V_SF018 USING WORKAREA.
*      provides (read-only) fields from secondary tables related
*      to primary tables by foreignkey relationships
ZABSF_PP024-MANDT =
ZABSF_PP_V_SF018-MANDT .
ZABSF_PP024-ACTV =
ZABSF_PP_V_SF018-ACTV .
ZABSF_PP024-STATUS_ACTV =
ZABSF_PP_V_SF018-STATUS_ACTV .
    SELECT SINGLE * FROM ZABSF_PP018 WHERE
ACTV = ZABSF_PP024-ACTV .
    IF SY-SUBRC EQ 0.
      SELECT SINGLE * FROM ZABSF_PP018_T WHERE
ACTV = ZABSF_PP018-ACTV AND
SPRAS = SY-LANGU .
      IF SY-SUBRC EQ 0.
ZABSF_PP_V_SF018-DESC_ACTV =
ZABSF_PP018_T-DESC_ACTV .
      ELSE.
        CLEAR SY-SUBRC.
        CLEAR ZABSF_PP_V_SF018-DESC_ACTV .
      ENDIF.
    ELSE.
      CLEAR SY-SUBRC.
      CLEAR ZABSF_PP_V_SF018-DESC_ACTV .
    ENDIF.
    SELECT SINGLE * FROM ZABSF_PP023 WHERE
STATUS_ACTV = ZABSF_PP024-STATUS_ACTV .
    IF SY-SUBRC EQ 0.
      SELECT SINGLE * FROM ZABSF_PP023_T WHERE
STATUS_ACTV = ZABSF_PP023-STATUS_ACTV AND
SPRAS = SY-LANGU .
      IF SY-SUBRC EQ 0.
ZABSF_PP_V_SF018-STATUS_DESC =
ZABSF_PP023_T-STATUS_DESC .
      ELSE.
        CLEAR SY-SUBRC.
        CLEAR ZABSF_PP_V_SF018-STATUS_DESC .
      ENDIF.
    ELSE.
      CLEAR SY-SUBRC.
      CLEAR ZABSF_PP_V_SF018-STATUS_DESC .
    ENDIF.
ENDFORM.