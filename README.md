# ML-DSA GPU Batch Signature Verification (CUDA / Dilithium2 / FIPS 204)

**Fast post-quantum signature verification on NVIDIA GPUs — batch ML-DSA verify at ~700,000 signatures/second.**

Keywords: `ML-DSA` · `Dilithium` · `Dilithium2` · `ML-DSA-44` · `GPU signature verification` · `CUDA` · `batch verify` · `post-quantum cryptography` · `FIPS 204` · `PQC` · `blockchain validator`

Developer: [max124vip-dev](https://github.com/max124vip-dev) · Telegram: [@MaxVip124](https://t.me/MaxVip124)

---

## What is this, in plain English?

When someone sends you a signed document (or a blockchain transaction), the computer must **verify the signature**: prove the data was not changed and was signed by the holder of the private key.

**ML-DSA** (also known as **Dilithium**, standard **FIPS 204**) is the new post-quantum signature algorithm chosen by NIST. Blockchains, banks, and security products are moving to it because classic elliptic-curve signatures may become breakable when large quantum computers appear.

**This project** is a GPU engine that verifies **many ML-DSA signatures at once** — a batch — instead of one-by-one on the CPU.

On an RTX 3080 we measure roughly **630,000–730,000 verifications per second**, compared to about **9,000/s** on the best CPU implementation (AVX2) on the **same machine**. That is about **70–80× faster** for large batches.

CUDA kernel source code is **not published** here. This repository is a **showcase**: benchmarks you can run yourself, documentation, and a path to a commercial license.

---

## Why would anyone need this?

| Who | Why it matters |
|-----|----------------|
| **Blockchain node / validator** | A block can contain thousands of signed transactions. Checking them one-by-one on CPU becomes a bottleneck. |
| **Audit / compliance** | You may need to re-verify millions of archived signatures overnight, not over weeks. |
| **API gateway / filter** | Accept or reject huge volumes of signed requests before they hit your core service. |
| **PQC integrator** | Ship ML-DSA verify in your product without spending months on CUDA, Keccak-on-GPU, and lattice math. |

**Good fit:** thousands or millions of signatures, often with the **same public key** (validator key, single issuer audit, cached key on GPU).

**Poor fit:** verifying **one** signature occasionally (e.g. a single TLS handshake). A normal CPU library is enough for that.

---

## How it works (high level)

You do **not** get “GPU-accelerated NTT only” and CPU for everything else. The full verify path runs on the GPU:

1. **Unpack** the signature and check basic constraints  
2. **Hash** (SHAKE) to build the message digest and challenge polynomial  
3. **Lattice math** (NTT, matrix multiply, modular arithmetic)  
4. **Apply hints** and **final hash** to accept or reject  

```
  You provide:  public key + batch of signatures + messages
                         ↓
              GPU runs the entire verify pipeline
                         ↓
  You get back:  OK / FAIL for each signature
```

The public key is prepared once and **cached on the GPU** (expanded matrix, precomputed values). That is why batch verify with one key is so fast.

---

## Numbers (RTX 3080, 4096 signatures, one public key)

| Mode | Throughput | What it means |
|------|------------|---------------|
| CPU AVX2 (same PC) | ~9,000/s | Best CPU baseline we measured |
| **GPU (+ host upload)** | **~632,000/s** | Realistic: new data copied to GPU each batch |
| **GPU (replay)** | **~729,000/s** | Data already on GPU; shows hardware ceiling |
| Speedup vs AVX2 | **~70–80×** | |

**Correctness:** bit-exact vs [pq-crystals](https://github.com/pq-crystals/dilithium) reference — 512 signatures, full pipeline, **PASS**.

Details and how to reproduce: [docs/BENCHMARKS.md](docs/BENCHMARKS.md)

---

## Try it yourself (free evaluation)

### Requirements

- Windows 64-bit  
- NVIDIA GPU (tested: RTX 3080; fat binary supports RTX 30xx/40xx/50xx, Hopper)  
- [CUDA 12.x runtime](https://developer.nvidia.com/cuda-downloads) installed  

### Steps

**Important:** do **not** use the green **Code → Download ZIP** button — that is source only (no `.exe` / `.dll`).

1. Open **[Releases](https://github.com/max124vip-dev/mldsa-gpu-verify/releases/latest)** (`v0.2.0-eval`).  
2. Download **`mldsa-gpu-verify-v0.2.0-eval-windows.zip`** (everything in one archive), **or** download all assets into one folder.  
3. Extract to a folder, e.g. `C:\mldsa-eval\`.  
4. Run **`quick_test.bat`** from that folder (not from `scripts\` inside the source tree).  

Expect `RESULT: PASS` — signs with pq-crystals ref, verifies via `libmldsa_gpu_verify.dll`. Takes a few seconds.

4. **Full benchmark** (a few minutes) — run `.\run_benchmark.bat` or:

```powershell
.\bench_ntt.exe 4096 512 10
```

At the end, look for:

```
GPU pipeline (replay): ... verify/s
GPU pipeline (+H2D):   ... verify/s
ref + hybrid + cuda pipeline: PASS
```

**PASS** means the math matches the reference. **verify/s** is your throughput on that GPU.

Arguments: `batch_size` `correctness_count` `benchmark_iterations` — example `4096 512 10`.

---

## I want to integrate this into my product

The evaluation **DLL** is in [Releases](https://github.com/max124vip-dev/mldsa-gpu-verify/releases/latest) — link against `libmldsa_gpu_verify.dll`, header in `include/mldsa_gpu_verify.h`. See [docs/API.md](docs/API.md).

For production you need a **commercial license**, which typically includes:

| | Free evaluation | Commercial license |
|---|-----------------|-------------------|
| `bench_ntt.exe` + eval DLL | ✅ | ✅ |
| Production / redistribution rights | ❌ | ✅ |
| Full CUDA source | ❌ | ✅ (usually under NDA) |
| Integration help | ❌ | negotiable |

**Contact:**

- GitHub: [open a commercial license issue](https://github.com/max124vip-dev/mldsa-gpu-verify/issues/new?template=commercial-license.md)  
- Telegram: [@MaxVip124](https://t.me/MaxVip124)

Describe your use case (volume, GPU, OS, blockchain or not). I will reply with options and pricing.

---

## What is done and what is planned

- [x] Full Dilithium2 (ML-DSA-44) verify on GPU  
- [x] Public benchmarks + correctness vs pq-crystals  
- [x] Evaluation DLL (`libmldsa_gpu_verify.dll`) + demo  
- [ ] Dilithium3 (ML-DSA-65) — NEAR, TLS, enterprise  
- [ ] Multi-public-key batches  
- [ ] Linux `.so`  

---

## More documentation

- [FAQ — common search questions](docs/FAQ.md)  
- [Benchmarks & methodology](docs/BENCHMARKS.md)  
- [Library API (eval DLL)](docs/API.md)  
- [Licensing](docs/LICENSING.md)  
- [Author](AUTHORS.md)  

---

## FAQ (short)

**Is this GPU Dilithium / ML-DSA signature verification?**  
Yes — full **batch verify** for **Dilithium2 (ML-DSA-44)** on NVIDIA GPUs, not CPU-only NTT.

**How fast vs CPU (liboqs / AVX2)?**  
~**70–80×** on RTX 3080 for batches of thousands of signatures with one public key. See [benchmarks](docs/BENCHMARKS.md).

**CUDA source on GitHub?**  
No — eval **DLL** + benchmark here; CUDA kernels under commercial license.

**Blockchain / validator use case?**  
Yes, when you verify **many signatures per block** with the same key. You serialize messages; we verify raw bytes.

More answers: [docs/FAQ.md](docs/FAQ.md)

---

## Honest comparison

| | MLDSA-GPU (this project) | CPU (liboqs / AVX2) | NVIDIA cuPQC-PK |
|---|--------------------------|---------------------|-----------------|
| Full batch ML-DSA verify on GPU | ✅ | ❌ (CPU only) | primitives; few public verify benchmarks |
| Reproducible throughput published | ✅ | ✅ | ❌ |
| Ready-to-link eval DLL | ✅ (evaluation) | open source | build-it-yourself SDK |

We do not claim “fastest in the world” without your hardware — **run the benchmark** and [share your results](https://github.com/max124vip-dev/mldsa-gpu-verify/issues/new?template=benchmark-report.md).

---

## Important notes

- **Algorithm today:** Dilithium2 / ML-DSA-44 only.  
- **Message format:** you pass raw bytes to verify; **your** app must hash/serialize transactions the way your protocol requires (we do not parse Bitcoin/Ethereum/NEAR txs out of the box).  
- **CUDA cores** are proprietary work by [max124vip-dev](https://github.com/max124vip-dev). Source available under commercial license. Evaluation benchmark is free to download and run.

**Questions?** Telegram [@MaxVip124](https://t.me/MaxVip124) or GitHub Issues.
