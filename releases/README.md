# Releases

Binaries are on the **[Releases](https://github.com/max124vip-dev/mldsa-gpu-verify/releases)** page (not stored in git).

## Latest: v0.2.0-eval

| File | Description |
|------|-------------|
| `libmldsa_gpu_verify.dll` | Evaluation DLL — batch ML-DSA verify (Dilithium2) |
| `libmldsa_gpu_verify.lib` | MSVC import library (link your app against the DLL) |
| `demo_verify.exe` | Signs with pq-crystals ref, verifies via DLL — integration smoke test |
| `bench_ntt.exe` | Throughput benchmark + correctness test |
| `mldsa_gpu_verify.h` | Public C API header |
| `quick_test.bat` | Double-click smoke test (DLL, ~5 seconds) |
| `run_benchmark.bat` | Full benchmark launcher (~few minutes) |

**GPU support:** fat binary — sm_86 (RTX 30xx), sm_89 (RTX 40xx), sm_90 (Hopper), sm_120 (RTX 50xx) + forward PTX.

### Quick test (easiest)

Double-click **`quick_test.bat`** or run:

```powershell
.\quick_test.bat
```

### Quick test (manual)

```powershell
.\demo_verify.exe 64
```

Expect `RESULT: PASS`. Keep `libmldsa_gpu_verify.dll` in the same folder as `demo_verify.exe`.

### Full benchmark

```powershell
.\run_benchmark.bat
```

Or manually: `.\bench_ntt.exe 4096 512 10`

Requires Windows x64, NVIDIA GPU, and [CUDA 12.x runtime](https://developer.nvidia.com/cuda-downloads).

See [README](../README.md), [docs/API.md](../docs/API.md), and [docs/BENCHMARKS.md](../docs/BENCHMARKS.md).

**Commercial source license** — [@MaxVip124](https://t.me/MaxVip124) or [GitHub Issue](https://github.com/max124vip-dev/mldsa-gpu-verify/issues/new?template=commercial-license.md).
