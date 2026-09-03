# v0.2.0-eval

Evaluation release with **DLL + demo + benchmark**.

## Assets

| File | Purpose |
|------|---------|
| `libmldsa_gpu_verify.dll` | Batch ML-DSA-44 verify API (evaluation license) |
| `libmldsa_gpu_verify.lib` | MSVC import lib |
| `demo_verify.exe` | Integration smoke test (sign ref → verify GPU) |
| `bench_ntt.exe` | Throughput + correctness vs pq-crystals |
| `mldsa_gpu_verify.h` | Public C header |
| `quick_test.bat` | One-click smoke test (~5 s) |
| `run_benchmark.bat` | Full benchmark launcher |

## GPU architectures

Fat binary: **sm_86, sm_89, sm_90, sm_120** + PTX forward compatibility.

## Quick start

```powershell
.\quick_test.bat
.\run_benchmark.bat
```

Or manually:

```powershell
.\demo_verify.exe 64
.\bench_ntt.exe 4096 512 10
```

## License

Evaluation only — see [EVALUATION_LICENSE.txt](EVALUATION_LICENSE.txt). Production / source: [@MaxVip124](https://t.me/MaxVip124).
