---
description: Generates a conventional commit message from staged changes.
allowed-tools: Bash(git diff:*), Bash(git commit:*)
---

# Task: Create a Git Commit
1. Check staged changes: ! git diff --cached
2. If nothing is staged, check unstaged: ! git diff
3. Analyze the changes and generate a **Conventional Commit** message (e.g., `feat(ui): add logout button`).
4. Present the message to me and ask: "Should I execute this commit?"
5. If I agree, run: git commit -m "[MESSAGE]"
