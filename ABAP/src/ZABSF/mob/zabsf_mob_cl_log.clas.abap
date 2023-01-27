class ZABSF_MOB_CL_LOG definition
  public
  final
  create public .

public section.

  class-methods ADD_MESSAGE
    importing
      !MSGID type SYMSGID default 'ZABSF_MOB'
      !MSGTY type SYMSGTY
      !MSGNO type SYMSGNO
      !MSGV1 type ANY optional
      !MSGV2 type ANY optional
      !MSGV3 type ANY optional
      !MSGV4 type ANY optional
    changing
      !RETURN_TAB type BAPIRET2_T .
protected section.
private section.
ENDCLASS.



CLASS ZABSF_MOB_CL_LOG IMPLEMENTATION.


METHOD ADD_MESSAGE.

*  FIELD-SYMBOLS <return> TYPE bapiret2.
*
  DATA: l_msgv1 TYPE symsgv,
        l_msgv2 TYPE symsgv,
        l_msgv3 TYPE symsgv,
        l_msgv4 TYPE symsgv.

*For conversion purposes
  l_msgv1 = msgv1.
  l_msgv2 = msgv2.
  l_msgv3 = msgv3.
  l_msgv4 = msgv4.

  CONDENSE: l_msgv1, l_msgv2, l_msgv3, l_msgv4.

*Append line to return table
  APPEND INITIAL LINE TO return_tab ASSIGNING FIELD-SYMBOL(<return>).

*Convert the
  CALL FUNCTION 'BALW_BAPIRETURN_GET2'
    EXPORTING
      type   = msgty
      cl     = msgid
      number = msgno
      par1   = l_msgv1
      par2   = l_msgv2
      par3   = l_msgv3
      par4   = l_msgv4
    IMPORTING
      return = <return>.


*  CALL FUNCTION 'FORMAT_MESSAGE'
*    EXPORTING
*      id        = msgid
*      lang      = sy-langu
*      no        = msgno
*      v1        = msgv1
*      v2        = msgv2
*      v3        = msgv3
*      v4        = msgv4
*    IMPORTING
*      msg       = <return>-message
*    EXCEPTIONS
*      not_found = 1
*      OTHERS    = 2.
ENDMETHOD.
ENDCLASS.
