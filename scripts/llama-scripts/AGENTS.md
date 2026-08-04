# Agent Instructions

## Workflow

1. **Plan first** — before touching any file, use `/plan <task>` to explore the
   codebase read-only, ask clarifying questions, and produce an implementation
   plan. Only start editing after the plan is confirmed.

2. **Read before editing** — always read a file in full before modifying it.
   Never guess at existing content.

3. **Targeted edits** — make the smallest change that satisfies the requirement.
   Do not rewrite working code that was not asked about.

4. **Verify after editing** — after any code change:
   - run the relevant tests if a test suite exists
   - check LSP diagnostics (`lens_diagnostics`) for new errors introduced
   - fix any errors you caused before reporting done

5. **Confirm before running commands** — do not run shell commands that modify
   state (install packages, delete files, git push, restart services) without
   first showing the command and getting confirmation.

   The following commands are pre-approved and may run without asking:
   - **Read/inspect**: `ls`, `find`, `cat`, `head`, `tail`, `less`, `wc`, `file`, `stat`, `du`
   - **Search**: `grep`, `rg`, `awk`, `sed` (read-only), `jq`
   - **Navigation**: `pwd`, `echo`, `which`, `type`, `env`
   - **Git (read-only)**: `git status`, `git log`, `git diff`, `git show`, `git branch`, `git remote`
   - **Network (read-only)**: `curl` (GET only), `ping`, `nslookup`, `dig`
   - **Process info**: `ps`, `top`, `htop`, `lsof`, `df`

6. **One task at a time** — use the todo tool to track subtasks. Mark each done
   before moving to the next. Do not silently skip a step.

7. **Ask when uncertain** — if the intent is ambiguous or a decision materially
   changes the approach, use `ask_user_question` before proceeding.

<!-- ## Network

- There is no internet access in this environment
- Do not use `web_search`, `fetch_content`, or `agent_browser` — they will fail
- Do not suggest installing packages from the internet or fetching remote resources
- Use only local files, the existing codebase, and your training knowledge -->

## Memory

- At session start, check memory for relevant context about the current project
  or task before asking the user to re-explain things already discussed
- Store decisions, patterns, and hard-won facts that should survive across
  sessions (e.g. build commands, naming conventions, known gotchas)
- Do not store transient state or things the user can trivially re-state
- Prefer updating an existing memory entry over creating a duplicate

## Code style

- Match the existing style of the file being edited
- Do not add comments that restate what the code does
- Do not add error handling for impossible conditions
- Do not add features that were not asked for

## Shell scripts

- Always use `set -euo pipefail` in bash scripts
- Quote all variable expansions
- Prefer `$()` over backticks
