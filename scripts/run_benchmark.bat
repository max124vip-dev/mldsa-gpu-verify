@echo off
setlocal EnableExtensions
cd /d "%~dp0"
title MLDSA-GPU Benchmark

echo ============================================================
echo  MLDSA-GPU Verify - Full Benchmark
echo  This may take a few minutes (correctness + timing).
echo ============================================================
echo.

if not exist "bench_ntt.exe" (
    echo ERROR: bench_ntt.exe not found.
    echo.
    echo Download the evaluation package ^(NOT the source Code zip^):
    echo   https://github.com/max124vip-dev/mldsa-gpu-verify/releases/latest
    echo.
    echo Use: mldsa-gpu-verify-v0.2.0-eval-windows.zip
    echo Extract and run run_benchmark.bat from the same folder as bench_ntt.exe.
    pause
    exit /b 1
)

echo Running: bench_ntt.exe 4096 512 10
echo Look for "ref + hybrid + cuda pipeline: PASS" at the end.
echo.
bench_ntt.exe 4096 512 10
set "RC=%ERRORLEVEL%"
echo.
if "%RC%"=="0" (
    echo Benchmark finished. Check verify/s numbers above.
) else (
    echo Benchmark failed or was interrupted.
)
echo.
pause
endlocal & exit /b %RC%
