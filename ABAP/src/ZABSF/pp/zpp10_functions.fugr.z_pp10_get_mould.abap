FUNCTION Z_PP10_GET_MOULD.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(IV_AUFPL) TYPE  CO_AUFPL
*"     REFERENCE(IV_APLZL) TYPE  CO_APLZL
*"     REFERENCE(IV_WERKS) TYPE  WERKS_D
*"  EXPORTING
*"     REFERENCE(EV_EQUNR) TYPE  EQUNR
*"     REFERENCE(EV_EQKTX) TYPE  KTX01
*"----------------------------------------------------------------------

*Structures
  DATA: ls_affh TYPE affh.

*Constants
  CONSTANTS: c_objty TYPE cr_objty VALUE 'FH', "Production resources/tools
             c_eqtyp TYPE eqtyp    VALUE 'C'.  "Equipment Type - Moulds

*Get PRT assignment data for the work order
  SELECT *
    FROM affh
    INTO TABLE @DATA(lt_affh)
   WHERE aufpl EQ @iv_aufpl
     AND aplzl EQ @iv_aplzl
     AND objty EQ @c_objty
     AND loekz EQ @space.

  IF lt_affh[] IS NOT INITIAL.
    CLEAR ls_affh.

    LOOP AT lt_affh INTO ls_affh.
*    Get object ID of Equipement
      SELECT SINGLE equnr
        FROM crve_a
        INTO (@DATA(l_equnr))
       WHERE objid EQ @ls_affh-objid.

      IF l_equnr IS NOT INITIAL.
*      Check if equipment type is Moulds
        SELECT SINGLE *
          FROM equi
          INTO @DATA(ls_equi)
         WHERE equnr EQ @l_equnr
           AND eqtyp EQ @c_eqtyp.

        IF sy-subrc EQ 0.
*        Get Equipment description
          SELECT SINGLE eqktx
            FROM eqkt
            INTO (@DATA(l_eqktx))
           WHERE equnr EQ @l_equnr
             AND spras EQ @sy-langu.

          IF sy-subrc NE 0.
*          Get Equipment description in alternative language.
            SELECT SINGLE spras
              FROM zabsf_pp061
              INTO (@DATA(l_spras))
             WHERE werks     EQ @iv_werks
              AND is_default EQ @abap_true.

            IF sy-subrc EQ 0.
              CLEAR l_eqktx.

*            Get Equipment description
              SELECT SINGLE eqktx
                FROM eqkt
                INTO @l_eqktx
               WHERE equnr EQ @l_equnr
                 AND spras EQ @l_spras.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.

      IF l_equnr IS NOT INITIAL AND l_eqktx IS NOT INITIAL.
        EXIT.
      ENDIF.
    ENDLOOP.

*  Equipment number (Mould)
    ev_equnr = l_equnr.
*  Equipment description
    ev_eqktx = l_eqktx.
  ENDIF.
ENDFUNCTION.
