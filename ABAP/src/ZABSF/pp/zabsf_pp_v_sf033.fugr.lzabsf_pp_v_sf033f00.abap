*---------------------------------------------------------------------*
*    view related FORM routines
*---------------------------------------------------------------------*
*...processing: ZABSF_PP_V_SF033................................*
FORM GET_DATA_ZABSF_PP_V_SF033.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZABSF_PP042 WHERE
(VIM_WHERETAB) .
    CLEAR ZABSF_PP_V_SF033 .
ZABSF_PP_V_SF033-MANDT =
ZABSF_PP042-MANDT .
ZABSF_PP_V_SF033-AREAID =
ZABSF_PP042-AREAID .
ZABSF_PP_V_SF033-WERKS =
ZABSF_PP042-WERKS .
ZABSF_PP_V_SF033-HNAME =
ZABSF_PP042-HNAME .
ZABSF_PP_V_SF033-MATNR =
ZABSF_PP042-MATNR .
ZABSF_PP_V_SF033-TAKT =
ZABSF_PP042-TAKT .
ZABSF_PP_V_SF033-GMEIN =
ZABSF_PP042-GMEIN .
ZABSF_PP_V_SF033-PASSAGE =
ZABSF_PP042-PASSAGE .
<VIM_TOTAL_STRUC> = ZABSF_PP_V_SF033.
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
FORM DB_UPD_ZABSF_PP_V_SF033 .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZABSF_PP_V_SF033.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZABSF_PP_V_SF033-ST_DELETE EQ GELOESCHT.
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
  SELECT SINGLE FOR UPDATE * FROM ZABSF_PP042 WHERE
  AREAID = ZABSF_PP_V_SF033-AREAID AND
  WERKS = ZABSF_PP_V_SF033-WERKS AND
  HNAME = ZABSF_PP_V_SF033-HNAME AND
  MATNR = ZABSF_PP_V_SF033-MATNR .
    IF SY-SUBRC = 0.
    DELETE ZABSF_PP042 .
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
  SELECT SINGLE FOR UPDATE * FROM ZABSF_PP042 WHERE
  AREAID = ZABSF_PP_V_SF033-AREAID AND
  WERKS = ZABSF_PP_V_SF033-WERKS AND
  HNAME = ZABSF_PP_V_SF033-HNAME AND
  MATNR = ZABSF_PP_V_SF033-MATNR .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZABSF_PP042.
    ENDIF.
ZABSF_PP042-MANDT =
ZABSF_PP_V_SF033-MANDT .
ZABSF_PP042-AREAID =
ZABSF_PP_V_SF033-AREAID .
ZABSF_PP042-WERKS =
ZABSF_PP_V_SF033-WERKS .
ZABSF_PP042-HNAME =
ZABSF_PP_V_SF033-HNAME .
ZABSF_PP042-MATNR =
ZABSF_PP_V_SF033-MATNR .
ZABSF_PP042-TAKT =
ZABSF_PP_V_SF033-TAKT .
ZABSF_PP042-GMEIN =
ZABSF_PP_V_SF033-GMEIN .
ZABSF_PP042-PASSAGE =
ZABSF_PP_V_SF033-PASSAGE .
    IF SY-SUBRC = 0.
    UPDATE ZABSF_PP042 ##WARN_OK.
    ELSE.
    INSERT ZABSF_PP042 .
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
CLEAR: STATUS_ZABSF_PP_V_SF033-UPD_FLAG,
STATUS_ZABSF_PP_V_SF033-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ZABSF_PP_V_SF033.
  SELECT SINGLE * FROM ZABSF_PP042 WHERE
AREAID = ZABSF_PP_V_SF033-AREAID AND
WERKS = ZABSF_PP_V_SF033-WERKS AND
HNAME = ZABSF_PP_V_SF033-HNAME AND
MATNR = ZABSF_PP_V_SF033-MATNR .
ZABSF_PP_V_SF033-MANDT =
ZABSF_PP042-MANDT .
ZABSF_PP_V_SF033-AREAID =
ZABSF_PP042-AREAID .
ZABSF_PP_V_SF033-WERKS =
ZABSF_PP042-WERKS .
ZABSF_PP_V_SF033-HNAME =
ZABSF_PP042-HNAME .
ZABSF_PP_V_SF033-MATNR =
ZABSF_PP042-MATNR .
ZABSF_PP_V_SF033-TAKT =
ZABSF_PP042-TAKT .
ZABSF_PP_V_SF033-GMEIN =
ZABSF_PP042-GMEIN .
ZABSF_PP_V_SF033-PASSAGE =
ZABSF_PP042-PASSAGE .
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZABSF_PP_V_SF033 USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZABSF_PP_V_SF033-AREAID TO
ZABSF_PP042-AREAID .
MOVE ZABSF_PP_V_SF033-WERKS TO
ZABSF_PP042-WERKS .
MOVE ZABSF_PP_V_SF033-HNAME TO
ZABSF_PP042-HNAME .
MOVE ZABSF_PP_V_SF033-MATNR TO
ZABSF_PP042-MATNR .
MOVE ZABSF_PP_V_SF033-MANDT TO
ZABSF_PP042-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZABSF_PP042'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZABSF_PP042 TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZABSF_PP042'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*