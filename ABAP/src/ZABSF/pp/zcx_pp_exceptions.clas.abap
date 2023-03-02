CLASS zcx_pp_exceptions DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_t100_dyn_msg .
    INTERFACES if_t100_message .

    DATA msgty TYPE bal_s_msg-msgty .
    DATA msgid TYPE bal_s_msg-msgid .
    DATA msgno TYPE bal_s_msg-msgno .
    DATA msgv1 TYPE bal_s_msg-msgv1 .
    DATA msgv2 TYPE bal_s_msg-msgv2 .
    DATA msgv3 TYPE bal_s_msg-msgv3 .
    DATA msgv4 TYPE bal_s_msg-msgv4 .

    METHODS constructor
      IMPORTING
        !textid   LIKE if_t100_message=>t100key OPTIONAL
        !previous LIKE previous OPTIONAL
        !msgty    TYPE bal_s_msg-msgty OPTIONAL
        !msgid    TYPE bal_s_msg-msgid OPTIONAL
        !msgno    TYPE bal_s_msg-msgno OPTIONAL
        !msgv1    TYPE bal_s_msg-msgv1 OPTIONAL
        !msgv2    TYPE bal_s_msg-msgv2 OPTIONAL
        !msgv3    TYPE bal_s_msg-msgv3 OPTIONAL
        !msgv4    TYPE bal_s_msg-msgv4 OPTIONAL .
protected section.
private section.
ENDCLASS.



CLASS ZCX_PP_EXCEPTIONS IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
.
me->MSGTY = MSGTY .
me->MSGID = MSGID .
me->MSGNO = MSGNO .
me->MSGV1 = MSGV1 .
me->MSGV2 = MSGV2 .
me->MSGV3 = MSGV3 .
me->MSGV4 = MSGV4 .
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = IF_T100_MESSAGE=>DEFAULT_TEXTID.
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
  endmethod.
ENDCLASS.
