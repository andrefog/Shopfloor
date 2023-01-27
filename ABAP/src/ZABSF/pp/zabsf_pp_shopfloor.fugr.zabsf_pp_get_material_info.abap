FUNCTION zabsf_pp_get_material_info.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(I_MATNR) TYPE  MARA-MATNR
*"     VALUE(I_WERKS) TYPE  MARC-WERKS OPTIONAL
*"     VALUE(I_LGORT) TYPE  MARD-LGORT OPTIONAL
*"     VALUE(I_VKORG) TYPE  MVKE-VKORG OPTIONAL
*"     VALUE(I_VTWEG) TYPE  MVKE-VTWEG OPTIONAL
*"  EXPORTING
*"     VALUE(ET_MARA) TYPE  MARA_TAB
*"     VALUE(ET_MARC) TYPE  MARC_TAB
*"     VALUE(ET_MARD) TYPE  MARD_TAB
*"     VALUE(ET_MVKE) TYPE  MVKE_TAB
*"----------------------------------------------------------------------

  DATA: BEGIN OF l_data,
          matnr TYPE mara-matnr,
        END OF l_data.

  CLEAR: l_data. FREE: l_data.


  CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
    EXPORTING
      input  = i_matnr
    IMPORTING
      output = l_data-matnr.

  SELECT * INTO CORRESPONDING FIELDS OF TABLE et_mara FROM mara WHERE matnr = l_data-matnr.

  IF i_werks IS SUPPLIED AND et_marc IS REQUESTED.
    SELECT * FROM marc INTO CORRESPONDING FIELDS OF TABLE et_marc WHERE matnr = l_data-matnr
                                                                    AND werks = i_werks.
  ENDIF.

  IF i_werks IS SUPPLIED AND i_lgort IS SUPPLIED AND et_mard IS REQUESTED.
    SELECT * FROM mard INTO CORRESPONDING FIELDS OF TABLE et_mard WHERE matnr = l_data-matnr
                                                                    AND werks = i_werks
                                                                    AND lgort = i_lgort.
  ENDIF.
  IF i_vkorg IS SUPPLIED AND i_vtweg IS SUPPLIED AND et_mvke IS REQUESTED.
    SELECT * FROM mvke INTO CORRESPONDING FIELDS OF TABLE et_mvke WHERE matnr = l_data-matnr
                                                                    AND vkorg = i_vkorg
                                                                    AND vtweg = i_vtweg.
  ENDIF.

  CLEAR: l_data. FREE: l_data.


ENDFUNCTION.
