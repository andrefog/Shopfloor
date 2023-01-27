CLASS zabsf_pp_cl_wait_enqueue DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS wait_for_dequeue_mat
      IMPORTING
        !i_matnr    TYPE matnr
        !i_werks    TYPE werks_d DEFAULT space
        !i_charg    TYPE charg_d DEFAULT space
        !i_max_time TYPE i DEFAULT 10
      EXPORTING
        !e_gname    TYPE seqg3-gname
        !e_garg     TYPE seqg3-garg
        !e_guname   TYPE seqg3-guname
        !e_return   TYPE sy-subrc .
    CLASS-METHODS wait_for_dequeue_ord
      IMPORTING
        !i_aufnr       TYPE aufnr DEFAULT space
        !i_max_time    TYPE i DEFAULT 10
      EXPORTING
        !e_gname       TYPE seqg3-gname
        !e_garg        TYPE seqg3-garg
        !e_guname      TYPE seqg3-guname
        !e_return      TYPE sy-subrc
        !e_enqueue_tab TYPE wlf_seqg3_tab .
    CLASS-METHODS wait_for_dequeue_res
      IMPORTING
        !i_aufnr    TYPE aufnr DEFAULT space
        !i_max_time TYPE i DEFAULT 10
      EXPORTING
        !e_gname    TYPE seqg3-gname
        !e_garg     TYPE seqg3-garg
        !e_guname   TYPE seqg3-guname
        !e_return   TYPE sy-subrc .
  PROTECTED SECTION.
  PRIVATE SECTION.
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
