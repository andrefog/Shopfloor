FUNCTION zabsf_pp_getcomponents.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(AUFNR) TYPE  AUFNR OPTIONAL
*"     VALUE(VORNR) TYPE  VORNR OPTIONAL
*"     VALUE(REFDT) TYPE  VVDATUM DEFAULT SY-DATUM
*"     VALUE(INPUTOBJ) TYPE  ZABSF_PP_S_INPUTOBJECT
*"     VALUE(FOR_SUBPRODUCTS) TYPE  FLAG OPTIONAL
*"     VALUE(HU) TYPE  EXIDV OPTIONAL
*"     VALUE(FOR_DEVOLUTIONS) TYPE  FLAG OPTIONAL
*"  EXPORTING
*"     VALUE(COMPONENTS_TAB) TYPE  ZABSF_PP_T_COMPONENTS
*"     VALUE(RETURN_TAB) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
*References
  DATA: lref_sf_consum TYPE REF TO zabsf_pp_cl_consumptions. "zif_absf_pp_consumptions.

  IF hu IS INITIAL.
    IF for_devolutions EQ abap_true.
*Get class of interface
      SELECT SINGLE imp_clname, methodname
          FROM zabsf_pp003
          INTO (@DATA(l_class), @DATA(l_method))
         WHERE werks    EQ @inputobj-werks
           AND id_class EQ '22'
           AND endda    GE @refdt
           AND begda    LE @refdt.

      TRY .
          CREATE OBJECT lref_sf_consum TYPE (l_class)
            EXPORTING
              initial_refdt = refdt
              input_object  = inputobj.

        CATCH cx_sy_create_object_error.
*
          CALL METHOD zabsf_pp_cl_log=>add_message
            EXPORTING
              msgty      = 'E'
              msgno      = '019'
              msgv1      = l_class
            CHANGING
              return_tab = return_tab.

          EXIT.
      ENDTRY.

      CALL METHOD lref_sf_consum->(l_method)
        EXPORTING
          aufnr          = aufnr
          vornr          = vornr
        CHANGING
          components_tab = components_tab
          return_tab     = return_tab.

      DELETE ADJACENT DUPLICATES FROM return_tab.
    ELSE.
*Get class of interface
      SELECT SINGLE imp_clname, methodname
          FROM zabsf_pp003
          INTO (@l_class, @l_method)
         WHERE werks    EQ @inputobj-werks
           AND id_class EQ '8'
           AND endda    GE @refdt
           AND begda    LE @refdt.

      TRY .
          CREATE OBJECT lref_sf_consum TYPE (l_class)
            EXPORTING
              initial_refdt = refdt
              input_object  = inputobj.

        CATCH cx_sy_create_object_error.
*
          CALL METHOD zabsf_pp_cl_log=>add_message
            EXPORTING
              msgty      = 'E'
              msgno      = '019'
              msgv1      = l_class
            CHANGING
              return_tab = return_tab.

          EXIT.
      ENDTRY.

      CALL METHOD lref_sf_consum->(l_method)
        EXPORTING
          aufnr           = aufnr
          vornr           = vornr
          for_subproducts = for_subproducts
        CHANGING
          components_tab  = components_tab
          return_tab      = return_tab.

      DELETE ADJACENT DUPLICATES FROM return_tab.
    ENDIF.
  ELSE.
*>> leitura de paletes.
    SELECT SINGLE imp_clname, methodname
        FROM zabsf_pp003
        INTO (@l_class, @l_method)
       WHERE werks    EQ @inputobj-werks
         AND id_class EQ '21'
         AND endda    GE @refdt
         AND begda    LE @refdt.

    TRY .
        CREATE OBJECT lref_sf_consum TYPE (l_class)
          EXPORTING
            initial_refdt = refdt
            input_object  = inputobj.

      CATCH cx_sy_create_object_error.
*
        CALL METHOD zabsf_pp_cl_log=>add_message
          EXPORTING
            msgty      = 'E'
            msgno      = '019'
            msgv1      = l_class
          CHANGING
            return_tab = return_tab.

        EXIT.
    ENDTRY.

    CALL METHOD lref_sf_consum->(l_method)
      EXPORTING
        hu             = hu
        aufnr          = aufnr
      CHANGING
        components_tab = components_tab
        return_tab     = return_tab.

    DELETE ADJACENT DUPLICATES FROM return_tab.

  ENDIF.

  LOOP AT components_tab ASSIGNING FIELD-SYMBOL(<fs_component>).

    CALL FUNCTION 'CONVERSION_EXIT_CUNIT_OUTPUT'
      EXPORTING
        input                = <fs_component>-meins
        LANGUAGE             = SY-LANGU
     IMPORTING
       OUTPUT               = <fs_component>-meins_output
     EXCEPTIONS
       UNIT_NOT_FOUND       = 1
       OTHERS               = 2
              .
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.
  ENDLOOP.


ENDFUNCTION.
