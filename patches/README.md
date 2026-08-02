# CUDA 10.2 compatibility patch notes

The canonical executable patch procedure is `scripts/05-patch-llama-cuda10.sh`.

The changes are intentionally limited to the pinned `llama.cpp` tag `b5050` / commit `23106f94e`:

1. Comment `#include <cuda_bf16.h>` because CUDA 10.2 does not provide it.
2. Replace selected `nv_bfloat16` kernel types with `half`.
3. Change the `kvalues_iq4nl` device constant from `static constexpr __device__` to `static __device__`.
4. Comment `__builtin_assume` statements unsupported by this toolchain.

Do not assume these edits are correct for another `llama.cpp` revision. Revalidate every patch when changing commits.
