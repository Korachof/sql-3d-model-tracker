@echo off
REM =======================================================
REM  Build Script for the 3D Model Print Tracker Database
REM =======================================================
REM  This script reads all the individual .sql source files
REM  and concatenates them into a single Deploy.sql file.
REM
REM  Usage: Double-click this file in File Explorer to run it.
REM =======================================================

ECHO Building the deployment script...

REM Define the output file name
SET DEPLOY_SCRIPT=Deploy.sql

REM Wipe the old deployment script if it exists
IF EXIST %DEPLOY_SCRIPT% DEL %DEPLOY_SCRIPT%

REM --- Concatenate all SQL files in the correct order ---

ECHO -- Creating schema... >> %DEPLOY_SCRIPT%
type .\schema\CreateTables.sql >> %DEPLOY_SCRIPT%
ECHO. >> %DEPLOY_SCRIPT%
ECHO GO >> %DEPLOY_SCRIPT%

ECHO -- Creating procedures... >> %DEPLOY_SCRIPT%
FOR %%f IN (.\procedures\*.sql) DO (
    type "%%f" >> %DEPLOY_SCRIPT%
    ECHO. >> %DEPLOY_SCRIPT%
    ECHO GO >> %DEPLOY_SCRIPT%
)

ECHO -- Creating views... >> %DEPLOY_SCRIPT%
FOR %%f IN (.\views\*.sql) DO (
    type "%%f" >> %DEPLOY_SCRIPT%
    ECHO. >> %DEPLOY_SCRIPT%
    ECHO GO >> %DEPLOY_SCRIPT%
)

ECHO -- Creating utility scripts... >> %DEPLOY_SCRIPT%
FOR %%f IN (.\scripts\*.sql) DO (
    type "%%f" >> %DEPLOY_SCRIPT%
    ECHO. >> %DEPLOY_SCRIPT%
    ECHO GO >> %DEPLOY_SCRIPT%
)

ECHO. >> %DEPLOY_SCRIPT%
ECHO PRINT '================================================'; >> %DEPLOY_SCRIPT%
ECHO PRINT 'DATABASE SETUP COMPLETE.'; >> %DEPLOY_SCRIPT%
ECHO PRINT '================================================'; >> %DEPLOY_SCRIPT%
ECHO GO >> %DEPLOY_SCRIPT%

ECHO Build complete. The deployment script is ready: %DEPLOY_SCRIPT%