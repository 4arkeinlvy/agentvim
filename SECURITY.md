# Security Policy

This is an editor configuration: the main risks are the plugins it pins and
the install scripts it ships.

- **Reporting:** use GitHub's private vulnerability reporting on this repo
  (Security → Report a vulnerability). Please don't open public issues for
  exploitable problems.
- **Scope:** the install/update scripts, CI workflow, and any plugin pinned
  in `lazy-lock.json` known to be compromised.
- **Response:** best-effort; compromised-plugin reports get a lockfile pin
  or removal as fast as possible.

Practical user advice: read `scripts/install.sh` before piping it to bash
(always, for any project), and update via `scripts/update.sh` so you get
lockfile-reviewed plugin versions rather than latest-of-everything.
