@echo off
setlocal ENABLEEXTENSIONS
title BlackSecurity - Check Secure Boot and TPM 2.0

:: ---- pick UI language (pt or en) ----
set "DETECTED_LANG=%LANG%"
if not defined DETECTED_LANG set "DETECTED_LANG=%OSLANG%"
set "LANG2=%DETECTED_LANG:~0,2%"
if /I "%LANG2%"=="pt" (set "UI=pt") else set "UI=en"

echo ============================================
if /I "%UI%"=="pt" (
  echo   BlackSecurity - Checagem de Requisitos
) else (
  echo   BlackSecurity - Requirements Check
)
echo ============================================
echo.

:: ---- Secure Boot ----
if /I "%UI%"=="pt" (echo [Secure Boot]) else (echo [Secure Boot])

powershell -NoProfile -ExecutionPolicy Bypass -Command "try { if (Get-Command Confirm-SecureBootUEFI -ErrorAction SilentlyContinue) { if (Confirm-SecureBootUEFI) { if ('%UI%' -eq 'pt') { 'Secure Boot: ATIVO' } else { 'Secure Boot: ENABLED' } } else { if ('%UI%' -eq 'pt') { 'Secure Boot: DESATIVADO' } else { 'Secure Boot: DISABLED' } } } else { if ('%UI%' -eq 'pt') { 'Nao foi possivel confirmar Secure Boot (use msinfo32).' } else { 'Could not confirm Secure Boot (use msinfo32).' } } } catch { if ('%UI%' -eq 'pt') { 'Erro ao consultar Secure Boot.' } else { 'Error checking Secure Boot.' } }"

echo.

:: ---- TPM ----
if /I "%UI%"=="pt" (echo [TPM]) else (echo [TPM])

powershell -NoProfile -ExecutionPolicy Bypass -Command "try { if (Get-Command Get-Tpm -ErrorAction SilentlyContinue) { $t=Get-Tpm; if ($t.TpmPresent -and ($t.SpecVersion -like '2*')) { if ($t.TpmEnabled -and $t.TpmActivated) { if ('%UI%' -eq 'pt') { 'TPM 2.0: ATIVO' } else { 'TPM 2.0: ENABLED' } } else { if ('%UI%' -eq 'pt') { 'TPM 2.0: DETECTADO mas DESATIVADO' } else { 'TPM 2.0: DETECTED but DISABLED' } } } elseif ($t.TpmPresent) { if ('%UI%' -eq 'pt') { 'TPM detectado, mas versao inferior a 2.0' } else { 'TPM detected, but version lower than 2.0' } } else { if ('%UI%' -eq 'pt') { 'TPM: NAO DETECTADO' } else { 'TPM: NOT DETECTED' } } } else { if ('%UI%' -eq 'pt') { 'Get-Tpm nao disponivel. Tente no PowerShell: Get-Tpm' } else { 'Get-Tpm not available. Try in PowerShell: Get-Tpm' } } } catch { if ('%UI%' -eq 'pt') { 'Erro ao consultar TPM.' } else { 'Error checking TPM.' } }"

echo.
echo ============================================
if /I "%UI%"=="pt" (
  echo Pressione qualquer tecla para sair...
) else (
  echo Press any key to exit...
)
pause >nul
endlocal
