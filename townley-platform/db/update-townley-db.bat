@echo off
setlocal enabledelayedexpansion

REM =============================================================
REM Townley DB Update (Option B: backend uses api.*)
REM Runs SQL scripts inside the running townley_mssql container.
REM =============================================================

set CONTAINER=townley_mssql
set SA_PASSWORD=Your_Strong_Password123!
set DB=Townley_MySQL

echo.
echo [1/5] Deploy end-to-end (creates DB if missing)
docker exec -i %CONTAINER% /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "%SA_PASSWORD%" -d master -b -i /scripts/townley_deploy_end_to_end.sql
if errorlevel 1 goto :fail

echo.
echo [2/5] Ensure support objects
docker exec -i %CONTAINER% /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "%SA_PASSWORD%" -d %DB% -b -i /scripts/townley_platform_support_objects.sql
if errorlevel 1 goto :fail

echo.
echo [3/5] Create/refresh api views
docker exec -i %CONTAINER% /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "%SA_PASSWORD%" -d %DB% -b -i /scripts/townley_api_views_fastapi_exact.sql
if errorlevel 1 goto :fail

echo.
echo [4/5] Create/refresh api write procs
docker exec -i %CONTAINER% /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "%SA_PASSWORD%" -d %DB% -b -i /scripts/townley_platform_api_write_procs.sql
if errorlevel 1 goto :fail

echo.
echo [5/5] Full legacy parity check
docker exec -i %CONTAINER% /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "%SA_PASSWORD%" -d %DB% -b -i /scripts/parity_legacy_full.sql
if errorlevel 1 goto :fail

echo.
echo DONE: DB updated and legacy parity check executed.
exit /b 0

:fail
echo.
echo ERROR: One or more steps failed.
exit /b 1
