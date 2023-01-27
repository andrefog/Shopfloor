*&---------------------------------------------------------------------*
*&  Include           Z_LP_PP_CLOSE_STOP_OPER_TOP
*&---------------------------------------------------------------------*
*Tables
TABLES: aufk.

*Types
TYPES: BEGIN OF ty_operation_proc,
         aufnr      TYPE aufnr,
         vornr      TYPE vornr,
         ltxa1      TYPE ltxa1,
         werks      TYPE werks_d,
         arbpl      TYPE arbpl,
         status_old	TYPE j_status,
         status_new	TYPE j_status,
         status     TYPE icon_d,
         id         TYPE symsgid,
         number     TYPE symsgno,
         message    TYPE bapi_msg,
       END OF ty_operation_proc.

*Global internal tables
DATA: gt_data TYPE TABLE OF ty_operation_proc.
