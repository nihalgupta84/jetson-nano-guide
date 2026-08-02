# 9. Maintenance policy

Every future Jetson Nano change should be committed to this repository.

For each new feature or fix, record:

1. Hardware and software assumptions.
2. Exact commands.
3. Expected output.
4. Verification procedure.
5. Errors encountered.
6. Root cause.
7. Tested fix.
8. Rollback or cleanup procedure.
9. Date and commit.

Do not commit credentials, private keys, access tokens, GGUF files, compiled toolchains, or generated build directories.

Suggested branches:

```text
main                tested stable instructions
feature/<topic>     new capability or experiment
fix/<problem>       compatibility or troubleshooting fix
```
