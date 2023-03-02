*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZABSF_EQUIPMENTS................................*
DATA:  BEGIN OF STATUS_ZABSF_EQUIPMENTS              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZABSF_EQUIPMENTS              .
CONTROLS: TCTRL_ZABSF_EQUIPMENTS
            TYPE TABLEVIEW USING SCREEN '0041'.
*...processing: ZABSF_PP004.....................................*
DATA:  BEGIN OF STATUS_ZABSF_PP004                   .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZABSF_PP004                   .
CONTROLS: TCTRL_ZABSF_PP004
            TYPE TABLEVIEW USING SCREEN '0004'.
*...processing: ZABSF_PP_OPEREQU................................*
DATA:  BEGIN OF STATUS_ZABSF_PP_OPEREQU              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZABSF_PP_OPEREQU              .
CONTROLS: TCTRL_ZABSF_PP_OPEREQU
            TYPE TABLEVIEW USING SCREEN '0042'.
*...processing: ZABSF_PP_V_ALERT................................*
TABLES: ZABSF_PP_V_ALERT, *ZABSF_PP_V_ALERT. "view work areas
CONTROLS: TCTRL_ZABSF_PP_V_ALERT
TYPE TABLEVIEW USING SCREEN '0007'.
DATA: BEGIN OF STATUS_ZABSF_PP_V_ALERT. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZABSF_PP_V_ALERT.
* Table for entries selected to show on screen
DATA: BEGIN OF ZABSF_PP_V_ALERT_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZABSF_PP_V_ALERT.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZABSF_PP_V_ALERT_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZABSF_PP_V_ALERT_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZABSF_PP_V_ALERT.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZABSF_PP_V_ALERT_TOTAL.

*...processing: ZSF_ACTIONS.....................................*
DATA:  BEGIN OF STATUS_ZSF_ACTIONS                   .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSF_ACTIONS                   .
CONTROLS: TCTRL_ZSF_ACTIONS
            TYPE TABLEVIEW USING SCREEN '0029'.
*...processing: ZSF_AUTH........................................*
DATA:  BEGIN OF STATUS_ZSF_AUTH                      .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSF_AUTH                      .
CONTROLS: TCTRL_ZSF_AUTH
            TYPE TABLEVIEW USING SCREEN '0001'.
*...processing: ZSF_AUTHACT.....................................*
DATA:  BEGIN OF STATUS_ZSF_AUTHACT                   .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSF_AUTHACT                   .
CONTROLS: TCTRL_ZSF_AUTHACT
            TYPE TABLEVIEW USING SCREEN '0013'.
*...processing: ZSF_AUTHACTOBJ..................................*
DATA:  BEGIN OF STATUS_ZSF_AUTHACTOBJ                .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSF_AUTHACTOBJ                .
CONTROLS: TCTRL_ZSF_AUTHACTOBJ
            TYPE TABLEVIEW USING SCREEN '0009'.
*...processing: ZSF_AUTHOBJ.....................................*
DATA:  BEGIN OF STATUS_ZSF_AUTHOBJ                   .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSF_AUTHOBJ                   .
CONTROLS: TCTRL_ZSF_AUTHOBJ
            TYPE TABLEVIEW USING SCREEN '0025'.
*...processing: ZSF_AUTHPROF....................................*
DATA:  BEGIN OF STATUS_ZSF_AUTHPROF                  .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSF_AUTHPROF                  .
CONTROLS: TCTRL_ZSF_AUTHPROF
            TYPE TABLEVIEW USING SCREEN '0021'.
*...processing: ZSF_AUTHPROFROLE................................*
DATA:  BEGIN OF STATUS_ZSF_AUTHPROFROLE              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSF_AUTHPROFROLE              .
CONTROLS: TCTRL_ZSF_AUTHPROFROLE
            TYPE TABLEVIEW USING SCREEN '0011'.
*...processing: ZSF_AUTHROLE....................................*
DATA:  BEGIN OF STATUS_ZSF_AUTHROLE                  .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSF_AUTHROLE                  .
CONTROLS: TCTRL_ZSF_AUTHROLE
            TYPE TABLEVIEW USING SCREEN '0023'.
*...processing: ZSF_AUTHROLEUSER................................*
DATA:  BEGIN OF STATUS_ZSF_AUTHROLEUSER              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSF_AUTHROLEUSER              .
CONTROLS: TCTRL_ZSF_AUTHROLEUSER
            TYPE TABLEVIEW USING SCREEN '0027'.
*...processing: ZSF_DEPOSITSAREA................................*
DATA:  BEGIN OF STATUS_ZSF_DEPOSITSAREA              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSF_DEPOSITSAREA              .
CONTROLS: TCTRL_ZSF_DEPOSITSAREA
            TYPE TABLEVIEW USING SCREEN '0003'.
*...processing: ZSF_ERROR_LOG...................................*
DATA:  BEGIN OF STATUS_ZSF_ERROR_LOG                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSF_ERROR_LOG                 .
CONTROLS: TCTRL_ZSF_ERROR_LOG
            TYPE TABLEVIEW USING SCREEN '0017'.
*...processing: ZSF_HIERARCHIES.................................*
DATA:  BEGIN OF STATUS_ZSF_HIERARCHIES               .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSF_HIERARCHIES               .
CONTROLS: TCTRL_ZSF_HIERARCHIES
            TYPE TABLEVIEW USING SCREEN '0031'.
*...processing: ZSF_ODATA_CONFIG................................*
DATA:  BEGIN OF STATUS_ZSF_ODATA_CONFIG              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSF_ODATA_CONFIG              .
CONTROLS: TCTRL_ZSF_ODATA_CONFIG
            TYPE TABLEVIEW USING SCREEN '0016'.
*...processing: ZSF_OROUTER_END.................................*
DATA:  BEGIN OF STATUS_ZSF_OROUTER_END               .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSF_OROUTER_END               .
CONTROLS: TCTRL_ZSF_OROUTER_END
            TYPE TABLEVIEW USING SCREEN '0039'.
*...processing: ZSF_OROUTER_KEY.................................*
DATA:  BEGIN OF STATUS_ZSF_OROUTER_KEY               .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSF_OROUTER_KEY               .
CONTROLS: TCTRL_ZSF_OROUTER_KEY
            TYPE TABLEVIEW USING SCREEN '0037'.
*...processing: ZSF_PERMISSIONS.................................*
DATA:  BEGIN OF STATUS_ZSF_PERMISSIONS               .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSF_PERMISSIONS               .
CONTROLS: TCTRL_ZSF_PERMISSIONS
            TYPE TABLEVIEW USING SCREEN '0035'.
*...processing: ZSF_ROLES.......................................*
DATA:  BEGIN OF STATUS_ZSF_ROLES                     .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSF_ROLES                     .
CONTROLS: TCTRL_ZSF_ROLES
            TYPE TABLEVIEW USING SCREEN '0005'.
*...processing: ZSF_USERS.......................................*
DATA:  BEGIN OF STATUS_ZSF_USERS                     .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSF_USERS                     .
CONTROLS: TCTRL_ZSF_USERS
            TYPE TABLEVIEW USING SCREEN '0033'.
*...processing: ZSF_USERSSAP....................................*
DATA:  BEGIN OF STATUS_ZSF_USERSSAP                  .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSF_USERSSAP                  .
CONTROLS: TCTRL_ZSF_USERSSAP
            TYPE TABLEVIEW USING SCREEN '0019'.
*.........table declarations:.................................*
TABLES: *ZABSF_EQUIPMENTS              .
TABLES: *ZABSF_PP004                   .
TABLES: *ZABSF_PP_OPEREQU              .
TABLES: *ZSF_ACTIONS                   .
TABLES: *ZSF_AUTH                      .
TABLES: *ZSF_AUTHACT                   .
TABLES: *ZSF_AUTHACTOBJ                .
TABLES: *ZSF_AUTHOBJ                   .
TABLES: *ZSF_AUTHPROF                  .
TABLES: *ZSF_AUTHPROFROLE              .
TABLES: *ZSF_AUTHROLE                  .
TABLES: *ZSF_AUTHROLEUSER              .
TABLES: *ZSF_DEPOSITSAREA              .
TABLES: *ZSF_ERROR_LOG                 .
TABLES: *ZSF_HIERARCHIES               .
TABLES: *ZSF_ODATA_CONFIG              .
TABLES: *ZSF_OROUTER_END               .
TABLES: *ZSF_OROUTER_KEY               .
TABLES: *ZSF_PERMISSIONS               .
TABLES: *ZSF_ROLES                     .
TABLES: *ZSF_USERS                     .
TABLES: *ZSF_USERSSAP                  .
TABLES: ZABSF_EQUIPMENTS               .
TABLES: ZABSF_PP004                    .
TABLES: ZABSF_PP_ALERTS                .
TABLES: ZABSF_PP_OPEREQU               .
TABLES: ZSF_ACTIONS                    .
TABLES: ZSF_AUTH                       .
TABLES: ZSF_AUTHACT                    .
TABLES: ZSF_AUTHACTOBJ                 .
TABLES: ZSF_AUTHOBJ                    .
TABLES: ZSF_AUTHPROF                   .
TABLES: ZSF_AUTHPROFROLE               .
TABLES: ZSF_AUTHROLE                   .
TABLES: ZSF_AUTHROLEUSER               .
TABLES: ZSF_DEPOSITSAREA               .
TABLES: ZSF_ERROR_LOG                  .
TABLES: ZSF_HIERARCHIES                .
TABLES: ZSF_ODATA_CONFIG               .
TABLES: ZSF_OROUTER_END                .
TABLES: ZSF_OROUTER_KEY                .
TABLES: ZSF_PERMISSIONS                .
TABLES: ZSF_ROLES                      .
TABLES: ZSF_USERS                      .
TABLES: ZSF_USERSSAP                   .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
