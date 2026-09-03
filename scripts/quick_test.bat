@echo off
setlocal EnableExtensions
cd /d "%~dp0"
title MLDSA-GPU Quick Test

echo ============================================================
echo  MLDSA-GPU Verify - Quick Test
echo  https://github.com/max124vip-dev/mldsa-gpu-verify
echo ============================================================
echo.

if not exist "libmldsa_gpu_verify.dll" (
    echo ERROR: libmldsa_gpu_verify.dll not found in this folder.
    echo Extract all files from the GitHub Release into one folder.
    goto :fail
)
if not exist "demo_verify.exe" (
    echo ERROR: demo_verify.exe not found.
    goto :fail
)

echo [1/1] DLL smoke test - 64 signatures, one public key...
echo.
demo_verify.exe 64
set "RC=%ERRORLEVEL%"
echo.

if "%RC%"=="0" (
    echo ============================================================
    echo  RESULT: PASS
    echo  GPU verify works on your hardware.
    echo  For full throughput run: run_benchmark.bat
    echo ============================================================
    goto :end
)

:fail
set "RC=1"
echo ============================================================
echo  RESULT: FAIL
echo  Check: NVIDIA GPU + driver, CUDA 12.x runtime, all release files.
echo  Questions: Telegram @MaxVip124
echo ============================================================

:end
echo.
pause
endlocal & exit /b %RC%
