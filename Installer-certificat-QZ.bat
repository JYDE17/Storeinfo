@echo off
REM ============================================================
REM  Installe le certificat GoPlex dans la liste blanche de
REM  QZ Tray (override.crt) pour l'impression 100%% silencieuse.
REM  Double-clique ce fichier ; il demandera les droits admin.
REM ============================================================
setlocal

REM --- Auto-elevation en administrateur ---
net session >nul 2>&1
if %errorlevel% neq 0 (
  echo Demande des droits administrateur...
  powershell -Command "Start-Process '%~f0' -Verb RunAs"
  exit /b
)

set "SRC=%~dp0signing\digital-certificate.txt"
set "QZDIR=%ProgramFiles%\QZ Tray"
set "DST=%QZDIR%\override.crt"

echo.
if not exist "%SRC%" (
  echo [ERREUR] Certificat introuvable : %SRC%
  echo Verifie que le dossier "signing" est bien a cote de ce fichier.
  pause & exit /b 1
)
if not exist "%QZDIR%\qz-tray.exe" (
  echo [ERREUR] QZ Tray n'est pas installe dans "%QZDIR%".
  echo Installe QZ Tray d'abord : https://qz.io/download/
  pause & exit /b 1
)

echo Copie du certificat vers :
echo    %DST%
copy /Y "%SRC%" "%DST%" >nul
if %errorlevel% neq 0 (
  echo [ERREUR] La copie a echoue.
  pause & exit /b 1
)

echo Redemarrage de QZ Tray...
taskkill /IM qz-tray.exe /F >nul 2>&1
timeout /t 2 >nul
start "" "%QZDIR%\qz-tray.exe"

echo.
echo ============================================================
echo  Termine ! Le certificat GoPlex est maintenant approuve.
echo  Les recus s'impriment sans aucune fenetre de confirmation.
echo ============================================================
echo.
pause
