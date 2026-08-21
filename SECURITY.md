# Security Policy

## Supported Versions

Security fixes are provided for the latest published 0.x release. Older
developer-preview releases may be superseded instead of patched separately.

## Reporting a Vulnerability

Do not open a public issue for a suspected vulnerability. Use the repository's
private GitHub security-advisory reporting flow and include:

- the affected version or commit;
- OS, architecture, renderer backend, and bgfx revision;
- a minimal reproduction;
- expected and observed behavior;
- potential impact.

Do not include production credentials, private data, or third-party secrets.
Native library loading, FFI layouts and callbacks, memory ownership, shader
inputs, and platform-window handles should be treated as security-sensitive.
