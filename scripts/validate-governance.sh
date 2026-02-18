#!/usr/bin/env bash
set -u

failures=()
warnings=()

add_failure() {
  failures+=("$1")
}

add_warning() {
  warnings+=("$1")
}

path_exists() {
  local path="$1"
  [[ -n "$path" && -e "$path" ]]
}

core_artifacts=(
  "README.md"
  "AGENTS.md"
  "CONVERSATIONAL_MODE.md"
  "COMMANDS.md"
  "QUICKSTART.md"
  "FILE_MAP.md"
  "IDEA_CATALOG.md"
  "ideas/_inbox.md"
  "ideas/_active.md"
  "ideas/_parked.md"
  "ideas/_killed.md"
  "templates/idea_template.md"
  "templates/decision_template.md"
  "templates/project_plan_packet_template.md"
  "templates/risk_template.md"
  "templates/review_gate_template.md"
  "docs/adr/template.md"
  "docs/adr/ADR-0001-adopt-governance-structure-for-idea-lab.md"
  "scripts/validate-governance.ps1"
  "scripts/lab-sync.ps1"
  "scripts/validate-governance.sh"
  "scripts/lab-sync.sh"
  "scripts/validate-governance"
  "scripts/lab-sync"
  ".github/workflows/governance-audit.yml"
  ".github/PULL_REQUEST_TEMPLATE.md"
)

for artifact in "${core_artifacts[@]}"; do
  if ! path_exists "$artifact"; then
    add_failure "Missing required artifact: $artifact"
  fi
done

while IFS= read -r mdfile; do
  while IFS= read -r match; do
    [[ -z "$match" ]] && continue
    if ! path_exists "$match"; then
      add_failure "Missing ADR link target: '$match' referenced in '$mdfile'."
    fi
  done < <(grep -Eo 'docs/adr/ADR-[0-9]{4}-[a-z0-9-]+\.md' "$mdfile" || true)
done < <(find . -type f -name '*.md' -not -path './.git/*' -not -path './external/*')

catalog_path="IDEA_CATALOG.md"
if ! path_exists "$catalog_path"; then
  add_failure "Missing IDEA_CATALOG.md"
else
  while IFS= read -r row; do
    IFS='|' read -r _ c1 c2 c3 c4 c5 c6 c7 _ <<< "$row"
    idea_id=$(echo "$c1" | xargs)
    status=$(echo "$c3" | xargs)
    sessions=$(echo "$c5" | xargs)
    export_path=$(echo "$c6" | xargs)

    if [[ -z "$idea_id" || -z "$status" ]]; then
      add_failure "Malformed catalog row: $row"
      continue
    fi

    case "$status" in
      inbox) state_file='ideas/_inbox.md' ;;
      active) state_file='ideas/_active.md' ;;
      parked) state_file='ideas/_parked.md' ;;
      killed) state_file='ideas/_killed.md' ;;
      exported) state_file='ideas/_active.md' ;;
      *)
        add_failure "Unknown status '$status' for '$idea_id'."
        continue
        ;;
    esac

    if ! path_exists "$state_file"; then
      add_failure "Required state file '$state_file' missing for status '$status'."
    fi

    sessions_lc=$(echo "$sessions" | tr '[:upper:]' '[:lower:]')
    if [[ "$status" == "active" && "$sessions_lc" =~ (_none_|_none\ yet_|n/a) ]]; then
      add_warning "Active idea '$idea_id' has no session link yet."
    fi

    if [[ "$status" == "exported" ]]; then
      export_lc=$(echo "$export_path" | tr '[:upper:]' '[:lower:]')
      if [[ -z "$export_path" || "$export_lc" =~ (_n/a_|_none_|_none\ yet_) ]]; then
        add_failure "Exported idea '$idea_id' must include export file path."
      else
        clean_export_path=$(echo "$export_path" | sed 's/^`//; s/`$//' | xargs)
        if ! path_exists "$clean_export_path"; then
          add_failure "Catalog export path missing for '$idea_id': $clean_export_path"
        fi
      fi
    fi
  done < <(grep -E '^\|[[:space:]]*idea-[a-z0-9-]+' "$catalog_path" || true)
fi

file_map_path="FILE_MAP.md"
if path_exists "$file_map_path"; then
  fm=$(cat "$file_map_path")
  for artifact in "${core_artifacts[@]}"; do
    token="\`$artifact\`"
    if ! grep -Fq "$token" <<< "$fm"; then
      add_warning "FILE_MAP.md missing registry row for: $artifact"
    fi
  done
fi

echo "Lean validation summary"
echo "- Failures: ${#failures[@]}"
echo "- Warnings: ${#warnings[@]}"

if (( ${#warnings[@]} > 0 )); then
  echo
  echo "Warnings:"
  for warning in "${warnings[@]}"; do
    echo "- $warning"
  done
fi

if (( ${#failures[@]} > 0 )); then
  echo
  echo "Failures:"
  for failure in "${failures[@]}"; do
    echo "- $failure"
  done
  exit 1
fi

echo
echo "PASS: lean integrity checks completed with no blocking failures."
