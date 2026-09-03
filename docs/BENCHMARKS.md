# Benchmarks

How we measured the numbers in the README — and how you can repeat them on your own GPU.

## Hardware used

| Item | Value |
|------|--------|
| GPU | NVIDIA GeForce RTX 3080 (sm_86) |
| OS | Windows 64-bit |
| CUDA | 12.x |
| Algorithm | Dilithium2 / ML-DSA-44 |

## What we measure

- **Batch size:** 4096 signatures per run  
- **Public keys:** one key for the whole batch (cached on GPU — typical validator / single-issuer audit case)  
- **Message length:** 32 bytes in our tests  

## Two GPU modes — why both?

| Mode | Plain explanation |
|------|-------------------|
| **GPU (+ H2D)** | Each iteration **uploads** signatures and messages from host memory to the GPU. Closer to a streaming workload with fresh data. |
| **GPU (replay)** | Data **already sits on the GPU**; we only re-run compute. Shows the ceiling of the card without PCIe copy overhead. |

Both numbers are honest — they answer different questions: “real pipeline” vs “maximum GPU throughput.”

## Results (RTX 3080)

| Path | ms / 4096 sigs | verify/s |
|------|----------------|----------|
| CPU C reference | ~84 | ~6,100 |
| CPU AVX2 (same PC) | ~57 | ~9,040 |
| GPU hybrid (CPU SHAKE + GPU NTT, legacy) | ~10 | ~52,000 |
| **GPU full pipeline (+ upload)** | **~6.5** | **~632,000** |
| **GPU full pipeline (replay)** | **~5.6** | **~729,000** |

## Reproduce

```powershell
.\bench_ntt.exe 4096 512 10
```

- 5 warmup iterations, then 10 timed runs (average reported)  
- Correctness block uses 512 signatures vs pq-crystals — must print **PASS**  

Your GPU will differ. Compare **GPU vs AVX2 on the same machine**, not across different websites.

## Not covered yet

- Multiple public keys in one batch (roadmap)  
- ML-DSA-65 / Dilithium3 (roadmap)  
- Linux builds (roadmap)  

Share your results: [benchmark issue](https://github.com/max124vip-dev/mldsa-gpu-verify/issues/new?template=benchmark-report.md) or Telegram [@MaxVip124](https://t.me/MaxVip124).
