&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWin 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: New V9 Version - January 15, 1998
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AB.              */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

{src/adm2/widgetprto.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VARIABLE wWin         AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_bemployee  AS HANDLE        NO-UNDO.
DEFINE VARIABLE h_demployee  AS HANDLE        NO-UNDO.
DEFINE VARIABLE h_dyntoolbar AS HANDLE        NO-UNDO.
DEFINE VARIABLE h_vemployee  AS HANDLE        NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
    LABEL "MESSAGE" 
    SIZE 12 BY .91 TOOLTIP "Muentra un mensaje".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
    BUTTON-1 AT ROW 18.62 COL 123 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
    SIDE-LABELS NO-UNDERLINE THREE-D 
    AT COLUMN 1 ROW 1
    SIZE 151 BY 25.81 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: APPSERVER
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
    CREATE WINDOW wWin ASSIGN
        HIDDEN             = YES
        TITLE              = "<insert SmartWindow title>"
        HEIGHT             = 25.81
        WIDTH              = 151
        MAX-HEIGHT         = 28.81
        MAX-WIDTH          = 180.2
        VIRTUAL-HEIGHT     = 28.81
        VIRTUAL-WIDTH      = 180.2
        RESIZE             = NO
        SCROLL-BARS        = NO
        STATUS-AREA        = NO
        BGCOLOR            = ?
        FGCOLOR            = ?
        THREE-D            = YES
        MESSAGE-AREA       = NO
        SENSITIVE          = YES.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWin 
/* ************************* Included-Libraries *********************** */

    {src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   FRAME-NAME                                                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
    THEN wWin:HIDDEN = YES.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* <insert SmartWindow title> */
    OR ENDKEY OF {&WINDOW-NAME} ANYWHERE 
    DO:
        /* This case occurs when the user presses the "Esc" key.
           In a persistently run window, just ignore this.  If we did not, the
           application would exit. */
        IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* <insert SmartWindow title> */
    DO:
        /* This ADM code must be left here in order for the SmartWindow
           and its descendents to terminate properly on exit. */
        APPLY "CLOSE":U TO THIS-PROCEDURE.
        RETURN NO-APPLY.
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 wWin
ON CHOOSE OF BUTTON-1 IN FRAME fMain /* MESSAGE */
    DO:
        DEFINE VARIABLE icount AS INTEGER NO-UNDO.
    
        FOR EACH Employee NO-LOCK:
            icount = icount + 1.
        END.    
        MESSAGE "Total registros es " + STRING(icount).
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWin 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm2/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects wWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
    /*------------------------------------------------------------------------------
      Purpose:     Create handles for all SmartObjects used in this procedure.
                   After SmartObjects are initialized, then SmartLinks are added.
      Parameters:  <none>
    ------------------------------------------------------------------------------*/
    DEFINE VARIABLE currentPage AS INTEGER NO-UNDO.

    ASSIGN 
        currentPage = getCurrentPage().

    CASE currentPage: 

        WHEN 0 THEN 
            DO:
                RUN constructObject (
                    INPUT  'source/demployee.wDB-AWARE':U ,
                    INPUT  FRAME fMain:HANDLE ,
                    INPUT  'AppServiceASInfoASUsePrompt?CacheDuration0CheckCurrentChangedyesDestroyStatelessyesDisconnectAppServernoServerOperatingModeNONEShareDatanoUpdateFromSourcenoForeignFieldsObjectNamedemployeeOpenOnInityesPromptColumns(NONE)PromptOnDeleteyesRowsToBatch200RebuildOnReposnoToggleDataTargetsyes':U ,
                    OUTPUT h_demployee ).
                RUN repositionObject IN h_demployee ( 22.43 , 136.00 ) NO-ERROR.
                /* Size in AB:  ( 1.86 , 10.80 ) */

                RUN constructObject (
                    INPUT  'source/bemployee.w':U ,
                    INPUT  FRAME fMain:HANDLE ,
                    INPUT  'ScrollRemotenoNumDown0CalcWidthnoMaxWidth80FetchOnReposToEndyesUseSortIndicatoryesSearchFieldDataSourceNames?UpdateTargetNames?LogicalObjectNameHideOnInitnoDisableOnInitnoObjectLayout':U ,
                    OUTPUT h_bemployee ).
                RUN repositionObject IN h_bemployee ( 4.57 , 3.00 ) NO-ERROR.
                RUN resizeObject IN h_bemployee ( 11.19 , 146.00 ) NO-ERROR.

                RUN constructObject (
                    INPUT  'source/vemployee.w':U ,
                    INPUT  FRAME fMain:HANDLE ,
                    INPUT  'EnabledObjFldsToDisable?ModifyFields(All)DataSourceNamesUpdateTargetNamesLogicalObjectNameLogicalObjectNamePhysicalObjectNameDynamicObjectnoRunAttributeHideOnInitnoDisableOnInitnoObjectLayout':U ,
                    OUTPUT h_vemployee ).
                RUN repositionObject IN h_vemployee ( 17.43 , 4.00 ) NO-ERROR.
                /* Size in AB:  ( 7.00 , 43.40 ) */

                RUN constructObject (
                    INPUT  'adm2/dyntoolbar.w':U ,
                    INPUT  FRAME fMain:HANDLE ,
                    INPUT  'EdgePixels2DeactivateTargetOnHidenoDisabledActionsFlatButtonsyesMenuyesShowBorderyesToolbaryesActionGroupsTableio,NavigationTableIOTypeSaveSupportedLinksNavigation-Source,TableIo-SourceToolbarBandsToolbarAutoSizenoToolbarDrawDirectionhorizontalLogicalObjectNameDisabledActionsHiddenActionsUpdate,ResetHiddenToolbarBandsHiddenMenuBandsMenuMergeOrder0RemoveMenuOnHidenoCreateSubMenuOnConflictyesNavigationTargetNameHideOnInitnoDisableOnInitnoObjectLayout':U ,
                    OUTPUT h_dyntoolbar ).
                RUN repositionObject IN h_dyntoolbar ( 1.24 , 3.00 ) NO-ERROR.
                RUN resizeObject IN h_dyntoolbar ( 1.24 , 67.20 ) NO-ERROR.

                /* Links to SmartDataObject h_demployee. */
                RUN addLink ( h_dyntoolbar , 'Navigation':U , h_demployee ).

                /* Links to SmartDataBrowser h_bemployee. */
                RUN addLink ( h_demployee , 'Data':U , h_bemployee ).

                /* Links to SmartDataViewer h_vemployee. */
                RUN addLink ( h_demployee , 'Data':U , h_vemployee ).
                RUN addLink ( h_vemployee , 'Update':U , h_demployee ).
                RUN addLink ( h_dyntoolbar , 'TableIo':U , h_vemployee ).

                /* Adjust the tab order of the smart objects. */
                RUN adjustTabOrder ( h_dyntoolbar ,
                    BUTTON-1:HANDLE IN FRAME fMain , 'BEFORE':U ).
                RUN adjustTabOrder ( h_bemployee ,
                    h_dyntoolbar , 'AFTER':U ).
                RUN adjustTabOrder ( h_vemployee ,
                    h_bemployee , 'AFTER':U ).
            END. /* Page 0 */

    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWin  _DEFAULT-DISABLE
PROCEDURE disable_UI :
    /*------------------------------------------------------------------------------
      Purpose:     DISABLE the User Interface
      Parameters:  <none>
      Notes:       Here we clean-up the user-interface by deleting
                   dynamic widgets we have created and/or hide 
                   frames.  This procedure is usually called when
                   we are ready to "clean-up" after running.
    ------------------------------------------------------------------------------*/
    /* Delete the WINDOW we created */
    IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
        THEN DELETE WIDGET wWin.
    IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWin  _DEFAULT-ENABLE
PROCEDURE enable_UI :
    /*------------------------------------------------------------------------------
      Purpose:     ENABLE the User Interface
      Parameters:  <none>
      Notes:       Here we display/view/enable the widgets in the
                   user-interface.  In addition, OPEN all queries
                   associated with each FRAME and BROWSE.
                   These statements here are based on the "Other 
                   Settings" section of the widget Property Sheets.
    ------------------------------------------------------------------------------*/
    ENABLE BUTTON-1 
        WITH FRAME fMain IN WINDOW wWin.
    {&OPEN-BROWSERS-IN-QUERY-fMain}
    VIEW wWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject wWin 
PROCEDURE exitObject :
    /*------------------------------------------------------------------------------
      Purpose:  Window-specific override of this procedure which destroys 
                its contents and itself.
        Notes:  
    ------------------------------------------------------------------------------*/

    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
