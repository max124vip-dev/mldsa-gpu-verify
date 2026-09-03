# Licensing

## Free evaluation

You may **free of charge**:

- download evaluation binaries (`bench_ntt.exe`, `libmldsa_gpu_verify.dll`, `demo_verify.exe`) from [Releases](https://github.com/max124vip-dev/mldsa-gpu-verify/releases);  
- run them on **your** hardware for testing;  
- publish reproduced numbers with a link to this repo.  

You may **not** without a commercial agreement:

- use the binary in production;  
- redistribute it except by linking to official Releases;  
- reverse-engineer or decompile it.  

Full text: [EVALUATION_LICENSE.txt](../EVALUATION_LICENSE.txt)

---

## Commercial license

Typical package:

| Item | Included |
|------|----------|
| `libmldsa_gpu_verify.dll` (+ import lib / `.so`) | Yes |
| Full CUDA source (`src/cuda/`) | Yes, under NDA |
| Updates & integration support | negotiable |
| OEM / embed in your product | negotiable |

Pricing depends on scope (platforms, exclusivity, support). Ballpark for B2B projects: **$5k–50k**. Exact quote after we discuss your case.

**Contact:**

- [Commercial license issue](https://github.com/max124vip-dev/mldsa-gpu-verify/issues/new?template=commercial-license.md)  
- Telegram [@MaxVip124](https://t.me/MaxVip124)

---

## Why no CUDA source on GitHub?

The GPU kernels are the core IP (months of work). This repo is the **shop window**: numbers, docs, evaluation binary. Source is delivered to **licensees**, not dumped publicly.

Enterprise **source escrow** is available on request.

---

## Trademarks

ML-DSA and FIPS 204 are standards. We test against pq-crystals for correctness. This product is independent — not affiliated with NIST, pq-crystals, liboqs, or NVIDIA.
