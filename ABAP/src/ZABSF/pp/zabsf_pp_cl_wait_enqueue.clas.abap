class ZABSF_PP_CL_WAIT_ENQUEUE definition
  public
  final
  create public .

public section.

  class-methods WAIT_FOR_DEQUEUE_MAT
    importing
      !I_MATNR type MATNR
      !I_WERKS type WERKS_D default SPACE
      !I_CHARG type CHARG_D default SPACE
      !I_MAX_TIME type I default 10
    exporting
      !E_GNAME type SEQG3-GNAME
      !E_GARG type SEQG3-GARG
      !E_GUNAME type SEQG3-GUNAME
      !E_RETURN type SY-SUBRC .
  class-methods WAIT_FOR_DEQUEUE_ORD
    importing
      !I_AUFNR type AUFNR default SPACE
      !I_MAX_TIME type I default 10
    exporting
      !E_GNAME type SEQG3-GNAME
      !E_GARG type SEQG3-GARG
      !E_GUNAME type SEQG3-GUNAME
      !E_RETURN type SY-SUBRC
      !E_ENQUEUE_TAB type WLF_SEQG3_TAB .
  class-methods WAIT_FOR_DEQUEUE_RES
    importing
      !I_AUFNR type AUFNR default SPACE
      !I_MAX_TIME type I default 10
    exporting
      !E_GNAME type SEQG3-GNAME
      !E_GARG type SEQG3-GARG
      !E_GUNAME type SEQG3-GUNAME
      !E_RETURN type SY-SUBRC .
protected section.
private section.
ENDCLASS.



CLASS ZABSF_PP_CL_WAIT_ENQUEUE IMPLEMENTATION.


METHOD wait_for_dequeue_mat.
    DATA: enq  TYPE TABLE OF seqg3,
          wenq TYPE seqg3.

    DATA: gclient TYPE   seqg3-gclient,
          subrc   TYPE   sy-subrc.

    CLEAR: e_return.

*Bloqueio do lote
    IF i_matnr IS NOT INITIAL AND  i_charg IS NOT INITIAL.
      CONCATENATE sy-mandt i_matnr i_charg INTO e_garg.

      e_gname = 'MCH1'.

      DO i_max_time TIMES.
        REFRESH enq.

        CALL FUNCTION 'ENQUEUE_READ'
          EXPORTING
            gname                 = e_gname
            garg                  = e_garg
            guname                = ' '
          TABLES
            enq                   = enq
          EXCEPTIONS
            communication_failure = 1
            system_failure        = 2
            OTHERS                = 3.
        IF enq[] IS INITIAL.
          EXIT.
        ENDIF.
        WAIT UP TO 1 SECONDS.
      ENDDO.
      IF NOT enq[] IS INITIAL.
        READ TABLE enq INTO wenq INDEX 1.
        e_guname = wenq-guname.
        e_return = 1.
        EXIT.
      ENDIF.
    ENDIF.

*Bloqueio do material
    IF i_matnr IS NOT INITIAL .
      CONCATENATE sy-mandt i_matnr INTO e_garg.
      e_guname = space.
      e_gname = 'MARA'.
      REFRESH enq.

      DO i_max_time TIMES.
        REFRESH enq.
        CALL FUNCTION 'ENQUEUE_READ'
          EXPORTING
            gname                 = e_gname
            garg                  = e_garg
            guname                = ' '
          TABLES
            enq                   = enq
          EXCEPTIONS
            communication_failure = 1
            system_failure        = 2
            OTHERS                = 3.

        IF enq[] IS INITIAL.
          EXIT.
        ENDIF.
        WAIT UP TO 1 SECONDS.
      ENDDO.
      IF NOT enq[] IS INITIAL.
        READ TABLE enq INTO wenq INDEX 1.
        e_guname = wenq-guname.
        e_return = 2.
      ENDIF.
    ENDIF.

*Bloqueio do material/centro
    IF i_matnr IS NOT INITIAL AND i_werks IS NOT INITIAL.
      CONCATENATE sy-mandt i_matnr i_werks INTO e_garg.
      e_guname = space.
      e_gname  = 'MARC'.
      REFRESH enq.
      DO i_max_time TIMES.
        REFRESH enq.
        CALL FUNCTION 'ENQUEUE_READ'
          EXPORTING
            gname                 = e_gname
            garg                  = e_garg
            guname                = ' '
          TABLES
            enq                   = enq
          EXCEPTIONS
            communication_failure = 1
            system_failure        = 2
            OTHERS                = 3.

        IF enq[] IS INITIAL.
          EXIT.
        ENDIF.
        WAIT UP TO 1 SECONDS.
      ENDDO.
      IF NOT enq[] IS INITIAL.
        READ TABLE enq INTO wenq INDEX 1.
        e_guname = wenq-guname.
        e_return = 3.
      ENDIF.
    ENDIF.
  ENDMETHOD.


METHOD wait_for_dequeue_ord.
*  Internal tables
    DATA: lt_enq TYPE TABLE OF seqg3.

*  Structures
    DATA: ls_wenq TYPE seqg3.

    CLEAR: e_return.

*  Checl block order
    IF i_aufnr IS NOT INITIAL.
*    Object
      CONCATENATE sy-mandt i_aufnr INTO e_garg.

      e_gname = 'AUFK'.

      DO i_max_time TIMES.
        REFRESH lt_enq.

        CALL FUNCTION 'ENQUEUE_READ'
          EXPORTING
            gname                 = e_gname
            garg                  = e_garg
            guname                = ' '
          TABLES
            enq                   = lt_enq
          EXCEPTIONS
            communication_failure = 1
            system_failure        = 2
            OTHERS                = 3.
        IF lt_enq[] IS INITIAL.
          EXIT.
        ENDIF.
        WAIT UP TO 1 SECONDS.
      ENDDO.
      IF NOT lt_enq[] IS INITIAL.
        READ TABLE lt_enq INTO ls_wenq INDEX 1.
        e_guname = ls_wenq-guname.
        e_return = 1.

        MOVE lt_enq[] TO e_enqueue_tab.
        EXIT.
      ENDIF.
    ENDIF.
  ENDMETHOD.


METHOD wait_for_dequeue_res.
*  Internal tables
    DATA: lt_enq TYPE TABLE OF seqg3.

*  Strucutures
    DATA: ls_wenq TYPE seqg3.

    CLEAR: e_return.

*  Checl block order
    IF i_aufnr IS NOT INITIAL.
*    Get reserve number
      SELECT SINGLE rsnum
        FROM afko
        INTO (@DATA(l_rsnum))
       WHERE aufnr EQ @i_aufnr.

*    Object
      CONCATENATE sy-mandt l_rsnum INTO e_garg.

*    Table
      e_gname = 'RKPF'.

      DO i_max_time TIMES.
        REFRESH lt_enq.

        CALL FUNCTION 'ENQUEUE_READ'
          EXPORTING
            gname                 = e_gname
            garg                  = e_garg
            guname                = ' '
          TABLES
            enq                   = lt_enq
          EXCEPTIONS
            communication_failure = 1
            system_failure        = 2
            OTHERS                = 3.
        IF lt_enq[] IS INITIAL.
          EXIT.
        ENDIF.
        WAIT UP TO 1 SECONDS.
      ENDDO.

      IF NOT lt_enq[] IS INITIAL.
*      Name of user
        READ TABLE lt_enq INTO ls_wenq INDEX 1.
        e_guname = ls_wenq-guname.
        e_return = 1.
        EXIT.
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
