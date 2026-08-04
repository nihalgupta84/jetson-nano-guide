# Contributing

Thank you for helping improve the Jetson Nano AI Server guide.

This repository documents a verified setup for the original 4 GB NVIDIA Jetson Nano running JetPack 4.x, CUDA 10.2, a pinned `llama.cpp` build, Open WebUI, Cloudflare Access, RAG, and switchable GGUF models.

## Before opening a change

1. Read the README and the relevant document under `docs/`.
2. Confirm that the change applies to the original Jetson Nano and does not silently assume JetPack 5 or 6.
3. Search existing issues and pull requests.
4. Remove passwords, tokens, private domains, email addresses, IP addresses, and model binaries from logs and examples.

## Good contributions

- Reproducible fixes for JetPack 4.x or CUDA 10.2 compatibility.
- Tested installation and recovery instructions.
- Sanitized logs that clarify a failure mode.
- Small ARM64-compatible model benchmarks.
- Improvements to scripts, systemd units, backup procedures, or health checks.
- Documentation corrections that preserve the verified baseline.

## Pull-request checklist

- [ ] The change was tested on a Jetson Nano or is clearly marked as unverified.
- [ ] Commands are copy-pasteable and use explicit paths where needed.
- [ ] Destructive commands include a warning and verification step.
- [ ] Secrets and model binaries are not committed.
- [ ] Documentation links and code blocks render correctly.
- [ ] Relevant changelog or documentation entries are updated.

## Repository conventions

- Put detailed procedures in `docs/`.
- Put reusable shell commands in `scripts/`.
- Put systemd units in `systemd/`.
- Put benchmark results in `benchmarks/`.
- Do not commit GGUF files, build trees, Docker data, private backups, or Cloudflare tokens.
- Use clear commit messages written in the imperative mood.

## Reporting test results

Include:

- Jetson model and RAM size.
- JetPack/L4T version.
- CUDA version.
- `llama.cpp` revision.
- Model name and quantization.
- Exact command used.
- Relevant output and error messages.
- Whether the result was reproduced after reboot.

## Scope

The verified baseline targets the original Jetson Nano Developer Kit. Changes for other Jetson devices are welcome when isolated and clearly labelled, but they must not replace the Nano-specific instructions.
