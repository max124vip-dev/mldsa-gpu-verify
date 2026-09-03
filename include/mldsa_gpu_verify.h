/**
 * MLDSA-GPU Verify — public C API (evaluation / commercial DLL)
 *
 * Proprietary implementation. Header only; no CUDA source in public repo.
 * Evaluation: libmldsa_gpu_verify.dll from Releases.
 */
#pragma once

#include <stddef.h>
#include <stdint.h>

#ifdef _WIN32
#  ifdef MLDSA_GPU_VERIFY_EXPORTS
#    define MLDSA_GPU_API __declspec(dllexport)
#  else
#    define MLDSA_GPU_API __declspec(dllimport)
#  endif
#else
#  define MLDSA_GPU_API __attribute__((visibility("default")))
#endif

#ifdef __cplusplus
extern "C" {
#endif

#define MLDSA_GPU_MODE_2 2 /* ML-DSA-44 — available */
#define MLDSA_GPU_MODE_3 3 /* ML-DSA-65 — planned */
#define MLDSA_GPU_MODE_5 5 /* ML-DSA-87 — planned */

#define MLDSA_GPU_PK_BYTES  1312
#define MLDSA_GPU_SIG_BYTES 2420

typedef struct MldsaGpuVerifyCtx MldsaGpuVerifyCtx;

/** Returns version string, e.g. "0.2.0-eval". */
MLDSA_GPU_API const char* mldsa_gpu_verify_version(void);

MLDSA_GPU_API MldsaGpuVerifyCtx* mldsa_gpu_verify_ctx_create(int mode, const uint8_t* pk);
MLDSA_GPU_API void mldsa_gpu_verify_ctx_destroy(MldsaGpuVerifyCtx* ctx);

/**
 * Verify batch of signatures (one pk per context).
 * @return 0 on success, -1 on error.
 */
MLDSA_GPU_API int mldsa_gpu_verify_batch(
    MldsaGpuVerifyCtx* ctx,
    int* results,
    int count,
    const uint8_t* const* sigs,
    const uint8_t* const* msgs,
    size_t msglen);

/** Re-run last batch without host repack (benchmark / stress). */
MLDSA_GPU_API int mldsa_gpu_verify_batch_replay(MldsaGpuVerifyCtx* ctx, int count);

#ifdef __cplusplus
}
#endif
