# Migrating Large Files to Git LFS

## 1. Install Git LFS

```bash
git lfs install
```

## 2. Find Large Files

### In the working tree

```bash
du -ah . | sort -rh | head -n 30
```

### Across all git history (including deleted files)

```bash
git rev-list --objects --all \
  | git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' \
  | sed -n 's/^blob //p' \
  | sort --numeric-sort --key=2 --reverse \
  | head -n 30 \
  | cut -c 1-12,41- \
  | awk '{printf "%-10s %s\n", $2, $3}'
```

## 3. Migrate Files to LFS

### Option A: Migrate in-place (non-bare repo)

Rewrite history to move matching files into LFS:

```bash
git lfs migrate import --everything \
  --include="path/to/large_files/*.json,other/big_file.bin"
```

Clean up after the migration:

```bash
# Remove backup refs created by the migration tool
git for-each-ref --format="%(refname)" refs/original/ | xargs -n 1 git update-ref -d

# Clear the reflog and prune the database
git reflog expire --expire=now --all
git gc --prune=now --aggressive
```

Force-push the rewritten history:

```bash
git push --force --all
git push --force --tags
```

### Option B: Migrate via a mirror clone

This is safer as it works on a separate copy of the repo:

```bash
# Clone as a mirror (includes all branches and tags)
git clone --mirror <REPO_URL> migration_repo.git
cd migration_repo.git
git lfs install

# Perform the migration
git lfs migrate import --everything \
  --include="path/to/large_files/*.json,other/big_file.bin"

# Push the mirror back
git push --mirror <REPO_URL>
```

## 4. Remove Large Files from History (without LFS)

If you just want to permanently delete large files from history rather than track them with LFS, use `git filter-repo`:

### Install git-filter-repo

```bash
# Fedora/RHEL
dnf install git-filter-repo

# Ubuntu/Debian
apt install git-filter-repo

# pip
pip install git-filter-repo
```

### Remove specific files or directories

```bash
# Remove a single file from all history
git filter-repo --invert-paths --path path/to/huge_file.bin

# Remove a directory from all history
git filter-repo --invert-paths --path path/to/large_dir/

# Remove multiple paths at once
git filter-repo --invert-paths --path path/to/file1.bin --path path/to/file2.zip
```

### Remove files by size

```bash
# Remove all blobs larger than 100MB from history
git filter-repo --strip-blobs-bigger-than 100M
```

### After filtering

`git filter-repo` rewrites history and removes the original remote by default. Re-add it and force-push:

```bash
git remote add origin <REPO_URL>
git push --force --all
git push --force --tags
```

> **Warning:** This rewrites history. All team members must re-clone the repo afterwards.

### Remove files via a mirror clone

You can also run `git filter-repo` on a mirror clone to avoid modifying your local working copy:

```bash
# Clone as a bare mirror
git clone --mirror <REPO_URL> migration_repo.git
cd migration_repo.git

# Remove files (e.g. by path or by size)
git filter-repo --invert-paths --path path/to/huge_file.bin
# or
git filter-repo --strip-blobs-bigger-than 100M

# Re-add the remote (filter-repo removes it)
git remote add origin <REPO_URL>

# Push the cleaned mirror back
git push --force --all
git push --force --tags
```

> **Note:** `git push --mirror` can also be used but be careful — it deletes any remote refs not present in the local mirror (e.g. PRs, draft branches others may have pushed).

## 5. Verify

After migration, `.gitattributes` will contain entries like:

```
path/to/large_files/*.json filter=lfs diff=lfs merge=lfs -text
```

All team members should re-clone or run `git lfs pull` to fetch the LFS objects.
