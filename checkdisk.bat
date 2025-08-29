@echo off
setlocal
title Check MBR/GPT

set "OUT=%TEMP%\resultado_mbr_gpt.txt"
del "%OUT%" >nul 2>&1

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
 "$ErrorActionPreference='Stop';" ^
 "$out=$env:OUT;" ^
 "$tbl=Get-Disk | Select Number,FriendlyName,PartitionStyle,IsBoot,IsSystem;" ^
 "$sys=$tbl | Where-Object { $_.IsSystem } | Select-Object -First 1;" ^
 "$boot=$tbl | Where-Object { $_.IsBoot } | Select-Object -First 1;" ^
 "$rc=2; if($sys){ if($sys.PartitionStyle -eq 'GPT'){ $rc=0 } elseif($sys.PartitionStyle -eq 'MBR'){ $rc=1 } };" ^
 "" ^
 "'=== Discos detectados / Detected Disks ===' | Out-File -FilePath $out -Encoding utf8;" ^
 "($tbl | Format-Table -Auto | Out-String) | Add-Content -Encoding utf8 $out;" ^
 "" ^
 "if($sys){" ^
 "  Add-Content -Encoding utf8 $out '';" ^
 "  Add-Content -Encoding utf8 $out '=== Disco do Sistema (IsSystem=True) / System Disk ===';" ^
 "  Add-Content -Encoding utf8 $out ('Numero / Number      : ' + $sys.Number);" ^
 "  Add-Content -Encoding utf8 $out ('Modelo / Model      : ' + $sys.FriendlyName);" ^
 "  Add-Content -Encoding utf8 $out ('Estilo / Style      : ' + $sys.PartitionStyle)" ^
 "} else {" ^
 "  Add-Content -Encoding utf8 $out '';" ^
 "  Add-Content -Encoding utf8 $out '=== Disco do Sistema NAO encontrado / System Disk NOT found ==='" ^
 "};" ^
 "" ^
 "if($boot){" ^
 "  Add-Content -Encoding utf8 $out '';" ^
 "  Add-Content -Encoding utf8 $out '=== Disco de Boot (IsBoot=True) / Boot Disk ===';" ^
 "  Add-Content -Encoding utf8 $out ('Numero / Number      : ' + $boot.Number);" ^
 "  Add-Content -Encoding utf8 $out ('Modelo / Model      : ' + $boot.FriendlyName);" ^
 "  Add-Content -Encoding utf8 $out ('Estilo / Style      : ' + $boot.PartitionStyle)" ^
 "} else {" ^
 "  Add-Content -Encoding utf8 $out '';" ^
 "  Add-Content -Encoding utf8 $out '=== Disco de Boot NAO encontrado / Boot Disk NOT found ==='" ^
 "};" ^
 "" ^
 "Add-Content -Encoding utf8 $out '';" ^
 "Add-Content -Encoding utf8 $out ('Codigo de saida / Exit code: ' + $rc + '  (0=GPT no Disco do Sistema / GPT on System Disk, 1=MBR no Disco do Sistema / MBR on System Disk, 2=Indeterminado / Unknown)');" ^
 "Write-Host $out; exit $rc"

set "RC=%ERRORLEVEL%"
start "" notepad "%OUT%"
echo Resultado em / Result saved at: %OUT%
echo Codigo de saida / Exit code: %RC%
echo.
pause
exit /b %RC%
