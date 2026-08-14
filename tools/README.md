# tools/

Python scripts that do the actual work — API calls, data transforms, file
operations, queries. Deterministic, testable, fast.

Rules:

- Check here for an existing tool **before** building anything new.
- Secrets and API keys live in `.env` only — never hardcode them.
- On failure: read the full trace, fix the script, retest. Ask first if the
  retest burns paid API calls or credits.
- Document what you learned (rate limits, timing quirks) in the matching
  workflow under `workflows/`.
