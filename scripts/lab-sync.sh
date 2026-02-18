#!/usr/bin/env bash
set -euo pipefail

message="brainstorm: milestone update"
no_push=0
files=()

while (($# > 0)); do
  case "$1" in
    --no-push)
      no_push=1
      shift
      ;;
    -m|--message)
      if (($# < 2)); then
        echo "Error: $1 requires a value." >&2
        exit 1
      fi
      message="$2"
      shift 2
      ;;
    --)
      shift
      files+=("$@")
      break
      ;;
    *)
      if [[ $# -eq 1 && ${#files[@]} -eq 0 && "$1" != -* ]]; then
        message="$1"
      else
        files+=("$1")
      fi
      shift
      ;;
  esac
done

if (( ${#files[@]} > 0 )); then
  git add -- "${files[@]}"
else
  git add -A
fi

staged="$(git diff --cached --name-only)"
if [[ -z "$staged" ]]; then
  echo "No staged changes to commit."
  exit 0
fi

git commit -m "$message"
commit_sha="$(git rev-parse --short HEAD | tr -d '[:space:]')"
echo "Committed: $commit_sha"

if (( no_push == 1 )); then
  echo "Push skipped due to --no-push."
  exit 0
fi

branch="$(git symbolic-ref --quiet --short HEAD 2>/dev/null || true)"
if [[ -z "$branch" ]]; then
  echo "Warning: Detached HEAD detected. Commit kept locally; push skipped." >&2
  exit 2
fi

if ! git remote | grep -Fxq "origin"; then
  echo "Warning: Remote 'origin' not configured. Commit kept locally; push skipped." >&2
  exit 2
fi

dirty="$(git status --porcelain)"
if [[ -n "$dirty" ]]; then
  echo "Warning: Working tree is not clean after commit. Push skipped by policy." >&2
  echo "Warning: Commit kept locally. Resolve local changes, then push manually." >&2
  exit 2
fi

if ! git push origin "$branch"; then
  echo "Warning: Push failed for origin/$branch. Commit $commit_sha is local and safe." >&2
  echo "Warning: Retry: git push origin $branch" >&2
  exit 3
fi

echo "Pushed: origin/$branch @ $commit_sha"
