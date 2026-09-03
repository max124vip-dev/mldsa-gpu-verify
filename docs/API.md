# Library API (commercial DLL)

> **Today:** evaluation DLL in [Releases](https://github.com/max124vip-dev/mldsa-gpu-verify/releases/latest). Full CUDA source — commercial license.

Header: [`include/mldsa_gpu_verify.h`](../include/mldsa_gpu_verify.h)

---

## In short

1. **Create** a context once per public key (key material is cached on GPU).  
2. **Call** verify on batches of signatures — get OK/FAIL per signature.  
3. **Destroy** the context when finished.  

```c
MldsaGpuVerifyCtx* ctx = mldsa_gpu_verify_ctx_create(2, public_key);

int ok[1000];
mldsa_gpu_verify_batch(ctx, ok, 1000, signatures, messages, msg_length);

mldsa_gpu_verify_ctx_destroy(ctx);
```

---

## Functions

### `mldsa_gpu_verify_version`

```c
const char* mldsa_gpu_verify_version(void);
```

Returns version string (e.g. `"0.2.0-eval"`).

### `mldsa_gpu_verify_ctx_create`

```c
MldsaGpuVerifyCtx* mldsa_gpu_verify_ctx_create(int mode, const uint8_t* pk);
```

- `mode = 2` → Dilithium2 (available). Modes 3 and 5 planned.  
- `pk` → 1312 bytes (mode 2).  
- Returns `NULL` on error.  

Unpacks the key on CPU, uploads matrix / `t1` / `tr` to GPU — **done once**, not per signature.

### `mldsa_gpu_verify_batch`

```c
int mldsa_gpu_verify_batch(ctx, results, count, sigs, msgs, msglen);
```

- `count` — batch size (512–4096 recommended for throughput).  
- `sigs[i]` — 2420 bytes each (mode 2).  
- `results[i]` — 1 valid, 0 invalid.  
- Returns `0` on success, `-1` on GPU/memory error.  

All signatures must use the **same public key** as the context.

### `mldsa_gpu_verify_batch_replay`

```c
mldsa_gpu_verify_batch_replay(ctx, count);
```

Re-runs the last uploaded batch without host repack — used in our throughput benchmark.

---

## Your responsibility before calling verify

The library checks **raw message bytes**. If you are on a blockchain or custom protocol, **you** must serialize/hash the transaction exactly as the network expects, then pass those bytes in.

We do not ship Bitcoin / Ethereum / NEAR parsers out of the box — chain adapters are a separate integration (available under commercial license).

---

## Evaluation vs production

The evaluation DLL is free to download from Releases for testing on your hardware. Production deployment and CUDA source require a [commercial license](LICENSING.md) — contact [@MaxVip124](https://t.me/MaxVip124).
