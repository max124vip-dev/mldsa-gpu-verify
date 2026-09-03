# FAQ — GPU ML-DSA / Dilithium signature verification

Answers to questions people often search for when looking for **fast post-quantum signature verify on GPU**.

---

## What is this project?

**MLDSA-GPU Verify** is a **CUDA batch signature verifier** for **ML-DSA** (NIST **FIPS 204**), implemented for **Dilithium2 / ML-DSA-44** today. You pass a public key and many `(message, signature)` pairs; the GPU returns valid/invalid per signature.

This repo is the **public showcase**: benchmarks, evaluation DLL, API docs, and licensing — not open CUDA kernel source.

---

## Search terms this project matches

- GPU **Dilithium** verify / **Dilithium2** verification  
- **ML-DSA** batch verify, **ML-DSA-44**  
- **Post-quantum cryptography** (PQC) signature verification on **NVIDIA GPU**  
- **CUDA** lattice signatures, **NTT** on GPU (full pipeline, not NTT-only)  
- Faster than **liboqs** / **pq-crystals** CPU **AVX2** for large batches  
- **Blockchain validator** / node throughput for PQC signatures  
- **FIPS 204** verify acceleration  
- **SHAKE256** / Keccak on GPU (inside verify pipeline)  

---

## How is this different from “GPU NTT only”?

Many experiments speed up only the **Number Theoretic Transform**. Real **ML-DSA verify** also needs unpacking, **SHAKE** hashing, matrix operations, hint processing, and final checks.

This project runs the **entire verify path on GPU** (with public key cached once). That is why batch throughput reaches **hundreds of thousands of verify/s** on RTX 3080-class hardware.

---

## How fast is it?

On RTX 3080, batch 4096, one public key (see [BENCHMARKS.md](BENCHMARKS.md)):

| Path | Throughput |
|------|------------|
| CPU AVX2 (same machine) | ~9,000 verify/s |
| GPU full pipeline (+ upload) | ~632,000 verify/s |
| GPU full pipeline (replay) | ~729,000 verify/s |

Correctness: bit-exact vs [pq-crystals/dilithium](https://github.com/pq-crystals/dilithium) reference.

---

## vs liboqs, pq-crystals, NVIDIA cuPQC?

| | MLDSA-GPU | liboqs / pq-crystals | NVIDIA cuPQC-PK |
|---|-----------|----------------------|-----------------|
| Target | Production batch **verify** DLL | Reference / general PQC lib | Low-level PQC primitives SDK |
| Full ML-DSA verify on GPU | Yes (published benchmarks) | CPU-focused | Build-it-yourself; few public verify numbers |
| Eval binary on GitHub | Yes | Open source | SDK |

---

## Which GPUs are supported?

Evaluation builds are **fat binaries**: sm_86 (RTX 30xx), sm_89 (RTX 40xx), sm_90 (Hopper), sm_120 (RTX 50xx) + forward PTX.

Requirements: Windows x64, NVIDIA GPU, CUDA 12.x runtime.

---

## Can I use this for Bitcoin / Ethereum / NEAR?

The library verifies **raw message bytes** you provide. It does **not** parse chain-specific transaction formats out of the box. Your node or adapter must serialize/hash transactions per your protocol, then call batch verify.

Commercial integration help (chain adapters) is available under license.

---

## Is the CUDA source public?

No. CUDA kernels are proprietary. You get:

- Free **evaluation**: `bench_ntt.exe`, `libmldsa_gpu_verify.dll`, `demo_verify.exe`  
- **Commercial license**: production rights + CUDA source (typically under NDA)  

Contact: [@MaxVip124](https://t.me/MaxVip124) or [commercial license issue](https://github.com/max124vip-dev/mldsa-gpu-verify/issues/new?template=commercial-license.md).

---

## How do I try it?

1. [Releases](https://github.com/max124vip-dev/mldsa-gpu-verify/releases/latest) — download all files  
2. Run `quick_test.bat` (seconds) or `run_benchmark.bat` (minutes)  
3. Report your GPU results via [benchmark issue template](https://github.com/max124vip-dev/mldsa-gpu-verify/issues/new?template=benchmark-report.md)

---

## Related standards and projects

- [FIPS 204](https://csrc.nist.gov/pubs/fips/204/final) — ML-DSA  
- [pq-crystals/dilithium](https://github.com/pq-crystals/dilithium) — reference implementation  
- [open-quantum-safe/liboqs](https://github.com/open-quantum-safe/liboqs) — CPU PQC library  
