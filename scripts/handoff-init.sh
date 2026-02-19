#!/usr/bin/env bash
set -euo pipefail

TEMPLATE_SSH_URL="git@github.com:Broda/codex_template.git"
TEMPLATE_HTTPS_URL="https://github.com/Broda/codex_template.git"
MILESTONE_NAME="Milestone 0 — Foundation / Spine"

idea_id=""
dest=""
init_mode="prompt"

usage() {
  cat <<USAGE
Usage: ./scripts/handoff-init.sh --idea-id <idea-id> [--dest <path>] [--init yes|no]

Options:
  --idea-id <idea-id>   Required idea id from IDEA_CATALOG.md
  --dest <path>         Optional destination path for template clone
  --init yes|no         Skip prompt and force init branch behavior
USAGE
}

trim() {
  local s="$1"
  s="${s#${s%%[![:space:]]*}}"
  s="${s%${s##*[![:space:]]}}"
  printf '%s' "$s"
}

kebab_case() {
  local s
  s=$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')
  s=$(printf '%s' "$s" | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//; s/-+/-/g')
  printf '%s' "${s:-project}"
}

prompt_yes_no() {
  local prompt="$1"
  local default_no="${2:-1}"
  local ans
  while true; do
    if [[ "$default_no" == "1" ]]; then
      read -r -p "$prompt [y/N]: " ans || true
    else
      read -r -p "$prompt [Y/n]: " ans || true
    fi
    ans=$(printf '%s' "$ans" | tr '[:upper:]' '[:lower:]')
    if [[ -z "$ans" ]]; then
      if [[ "$default_no" == "1" ]]; then
        return 1
      fi
      return 0
    fi
    if [[ "$ans" == "y" || "$ans" == "yes" ]]; then
      return 0
    fi
    if [[ "$ans" == "n" || "$ans" == "no" ]]; then
      return 1
    fi
  done
}

replace_line_prefix() {
  local file="$1"
  local prefix="$2"
  local value="$3"
  awk -v p="$prefix" -v v="$value" '
    index($0,p)==1 { print p" "v; next }
    { print }
  ' "$file" > "$file.tmp"
  mv "$file.tmp" "$file"
}

infer_project_type() {
  local text
  text=$(printf '%s %s' "$project_name" "$objective" | tr '[:upper:]' '[:lower:]')
  if [[ "$text" == *"cli"* || "$text" == *"command line"* ]]; then
    printf '%s' "CLI"
  elif [[ "$text" == *"desktop"* || "$text" == *"electron"* ]]; then
    printf '%s' "Desktop"
  elif [[ "$text" == *"web"* || "$text" == *"frontend"* || "$text" == *"browser"* ]]; then
    printf '%s' "Web App"
  elif [[ "$text" == *"api"* || "$text" == *"service"* || "$text" == *"backend"* ]]; then
    printf '%s' "API"
  elif [[ "$text" == *"library"* || "$text" == *"sdk"* || "$text" == *"package"* ]]; then
    printf '%s' "Library"
  else
    printf '%s' ""
  fi
}

ask_non_empty() {
  local prompt="$1"
  local current="$2"
  local ans
  if [[ -n "$current" ]]; then
    read -r -p "$prompt [$current]: " ans || true
    ans=$(trim "$ans")
    if [[ -n "$ans" ]]; then
      printf '%s' "$ans"
    else
      printf '%s' "$current"
    fi
  else
    while true; do
      read -r -p "$prompt: " ans || true
      ans=$(trim "$ans")
      if [[ -n "$ans" ]]; then
        printf '%s' "$ans"
        return
      fi
    done
  fi
}

choose_project_type() {
  local current="$1"
  local ans
  echo "Project type options:"
  echo "1) CLI"
  echo "2) Desktop"
  echo "3) Web App"
  echo "4) API"
  echo "5) Library"
  if [[ -n "$current" ]]; then
    echo "Detected: $current"
  fi
  while true; do
    read -r -p "Select project type [1-5]: " ans || true
    case "$ans" in
      1) printf '%s' "CLI"; return ;;
      2) printf '%s' "Desktop"; return ;;
      3) printf '%s' "Web App"; return ;;
      4) printf '%s' "API"; return ;;
      5) printf '%s' "Library"; return ;;
    esac
  done
}

choose_from_list() {
  local prompt="$1"
  shift
  local options=("$@")
  local i=1
  local ans
  for opt in "${options[@]}"; do
    echo "$i) $opt"
    i=$((i + 1))
  done
  while true; do
    read -r -p "$prompt [1-${#options[@]}]: " ans || true
    if [[ "$ans" =~ ^[0-9]+$ ]] && (( ans >= 1 && ans <= ${#options[@]} )); then
      printf '%s' "${options[$((ans - 1))]}"
      return
    fi
  done
}

copy_base() {
  local src="$1"
  local dst="$2"
  mkdir -p "$(dirname "$dst")"
  cp "$src" "$dst"
}

apply_replacements() {
  local file="$1"
  sed -i \
    -e "s#<Project Name>#$project_name#g" \
    -e "s#<Milestone Name>#$MILESTONE_NAME#g" \
    -e "s#<Build command>#$build_command#g" \
    -e "s#<Run command>#$run_command#g" \
    -e "s#<Test command>#$test_command#g" \
    -e "s#<Short Title>#Decision Title#g" \
    "$file"
}

resolve_destination() {
  local default_slug
  default_slug=$(kebab_case "$project_name")
  local default_dest="../$default_slug"

  if [[ -n "$dest" ]]; then
    printf '%s' "$dest"
    return
  fi

  echo "Choose clone destination:"
  echo "1) Workspace sibling (recommended): $default_dest"
  echo "2) Custom path"
  local choice
  while true; do
    read -r -p "Select option [1-2]: " choice || true
    case "$choice" in
      1) printf '%s' "$default_dest"; return ;;
      2)
        read -r -p "Enter destination path: " choice || true
        choice=$(trim "$choice")
        if [[ -n "$choice" ]]; then
          printf '%s' "$choice"
          return
        fi
        ;;
    esac
  done
}

clone_with_recovery() {
  local target="$1"

  while true; do
    if [[ -e "$target" ]]; then
      echo "Destination already exists: $target"
      echo "1) Use existing folder"
      echo "2) Choose a new destination"
      echo "3) Abort"
      local existing_choice
      read -r -p "Choose recovery option [1-3]: " existing_choice || true
      case "$existing_choice" in
        1)
          if [[ -d "$target/.git" ]]; then
            clone_dir="$target"
            return 0
          fi
          echo "Existing destination is not a git repo."
          ;;
        2)
          read -r -p "Enter new destination path: " target || true
          target=$(trim "$target")
          ;;
        3)
          return 1
          ;;
      esac
      continue
    fi

    if git clone "$TEMPLATE_SSH_URL" "$target"; then
      clone_dir="$target"
      return 0
    fi

    echo "Clone failed for SSH URL."
    echo "1) Retry SSH"
    echo "2) Retry with HTTPS"
    echo "3) Choose a new destination"
    echo "4) Abort"
    local clone_choice
    read -r -p "Choose recovery option [1-4]: " clone_choice || true
    case "$clone_choice" in
      1) ;;
      2)
        if git clone "$TEMPLATE_HTTPS_URL" "$target"; then
          clone_dir="$target"
          return 0
        fi
        echo "HTTPS clone failed."
        ;;
      3)
        read -r -p "Enter new destination path: " target || true
        target=$(trim "$target")
        ;;
      4)
        return 1
        ;;
    esac
  done
}

detach_template_origin() {
  local repo="$1"
  if ! git -C "$repo" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    return 0
  fi

  if git -C "$repo" remote | grep -Fxq "origin"; then
    local old_origin
    old_origin=$(git -C "$repo" remote get-url origin 2>/dev/null || echo "unknown")
    if git -C "$repo" remote remove origin; then
      echo "Detached template remote: removed origin ($old_origin)"
    else
      echo "Failed to remove inherited origin remote." >&2
      return 1
    fi
  fi
}

configure_private_origin() {
  local repo="$1"
  if ! prompt_yes_no "Configure a new private repository remote as origin now?" 1; then
    echo "Skipped origin setup. Add one later with: git -C \"$repo\" remote add origin <your-private-repo-url>"
    return 0
  fi

  local new_origin
  read -r -p "Enter new private origin URL (git@... or https://...): " new_origin || true
  new_origin=$(trim "$new_origin")
  if [[ -z "$new_origin" ]]; then
    echo "No origin URL provided. Repository remains detached from any origin."
    return 0
  fi

  if git -C "$repo" remote add origin "$new_origin"; then
    echo "Configured origin: $new_origin"
    return 0
  fi

  echo "Failed to set new origin remote. Repository remains without origin." >&2
  return 1
}

validate_generated() {
  local root="$1"
  local missing=0
  local required=(
    "README.md"
    "docs/PROJECT_CONTEXT.md"
    "docs/ROADMAP.md"
    "docs/ARCHITECTURE.md"
    "docs/FILE_MAP.md"
    "docs/GOVERNANCE_INDEX.md"
    "docs/VERSIONING_AND_RELEASE_POLICY.md"
    "docs/SECURITY_POLICY.md"
    "docs/RUNTIME_VERIFICATION_REPORT.md"
    "docs/adr/ADR-0001-record-architecture-decisions.md"
    "docs/adr/ADR-TEMPLATE.md"
    "CHANGELOG.md"
    ".gitignore"
  )

  if [[ "$persistence" != "None" ]]; then
    required+=("docs/MIGRATION_POLICY.md")
  fi

  for rel in "${required[@]}"; do
    if [[ ! -f "$root/$rel" ]]; then
      echo "Missing generated file: $rel" >&2
      missing=1
    fi
  done

  if ! grep -Fq "$MILESTONE_NAME" "$root/docs/ROADMAP.md"; then
    echo "ROADMAP missing required milestone title: $MILESTONE_NAME" >&2
    missing=1
  fi

  if grep -R -n -E '<[^>]+>' "$root/README.md" "$root/docs" "$root/CHANGELOG.md" >/dev/null 2>&1; then
    echo "Unresolved placeholders detected in generated files." >&2
    missing=1
  fi

  if [[ "$missing" -ne 0 ]]; then
    return 1
  fi

  return 0
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --idea-id)
      idea_id="${2:-}"
      shift 2
      ;;
    --dest)
      dest="${2:-}"
      shift 2
      ;;
    --init)
      init_mode="${2:-prompt}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if [[ -z "$idea_id" ]]; then
  echo "--idea-id is required." >&2
  usage
  exit 1
fi

if [[ ! -f "IDEA_CATALOG.md" ]]; then
  echo "IDEA_CATALOG.md not found." >&2
  exit 1
fi

catalog_row=$(grep -E "^\|[[:space:]]*$idea_id[[:space:]]*\|" IDEA_CATALOG.md | head -n 1 || true)
if [[ -z "$catalog_row" ]]; then
  echo "Idea '$idea_id' not found in IDEA_CATALOG.md." >&2
  exit 1
fi

IFS='|' read -r _ c1 c2 c3 c4 c5 c6 c7 _ <<< "$catalog_row"
project_name=$(trim "$c2")
status=$(trim "$c3")
owner=$(trim "$c4")
sessions=$(trim "$c5")
notes=$(trim "$c7")

if [[ -z "$project_name" || "$project_name" == "_none yet_" ]]; then
  project_name="$idea_id"
fi
if [[ -z "$owner" || "$owner" == "unassigned" ]]; then
  owner="$(git config --get user.name 2>/dev/null || echo unassigned)"
fi

date_stamp=$(date +%F)
mkdir -p exports
export_path="exports/${date_stamp}_PROJECT_PLAN_PACKET_${idea_id}.md"
cp templates/project_plan_packet_template.md "$export_path"
replace_line_prefix "$export_path" "- Project name:" "$project_name"
replace_line_prefix "$export_path" "- Idea ID:" "$idea_id"
replace_line_prefix "$export_path" "- Owner:" "$owner"
replace_line_prefix "$export_path" "- Date:" "$date_stamp"

objective=$(awk -F': ' '/^- One-sentence objective:/{print $2}' "$export_path" | head -n1)
objective=$(trim "$objective")

new_catalog_row="| $idea_id | $project_name | exported | $owner | $sessions | \\`$export_path\\` | $notes |"
awk -v id="$idea_id" -v row="$new_catalog_row" '
  $0 ~ "^\\|[[:space:]]*" id "[[:space:]]*\\|" { print row; next }
  { print }
' IDEA_CATALOG.md > IDEA_CATALOG.md.tmp
mv IDEA_CATALOG.md.tmp IDEA_CATALOG.md

echo "Project plan created: $export_path"

run_init=0
case "$init_mode" in
  yes) run_init=1 ;;
  no) run_init=0 ;;
  prompt)
    if prompt_yes_no "Do you want to initialize a project from this plan now?" 1; then
      run_init=1
    fi
    ;;
  *)
    echo "Invalid --init value: $init_mode (expected yes|no)." >&2
    exit 1
    ;;
esac

if [[ "$run_init" -eq 0 ]]; then
  echo "Initialization skipped. Finalized at project plan creation."
  exit 0
fi

resolved_dest=$(resolve_destination)
if ! clone_with_recovery "$resolved_dest"; then
  echo "Initialization canceled before clone completion." >&2
  exit 1
fi

if ! detach_template_origin "$clone_dir"; then
  exit 1
fi
configure_private_origin "$clone_dir" || true

echo "Template available at: $clone_dir"

inferred_type=$(infer_project_type)
project_type=$(choose_project_type "$inferred_type")
language=$(ask_non_empty "Language" "")
runtime=$(ask_non_empty "Runtime" "")
framework=$(ask_non_empty "Framework (if any, else 'None')" "None")
package_tool=$(ask_non_empty "Package manager/build tool (if any, else 'None')" "None")
persistence=$(choose_from_list "Persistence" "None" "File-based (JSON/YAML/etc.)" "SQLite" "Postgres/MySQL/Other RDBMS")
authentication=$(choose_from_list "Authentication" "None" "Local users" "External auth provider")
determinism=$(choose_from_list "Determinism/correctness sensitivity" "Normal" "High")
packaging=$(choose_from_list "Packaging/distribution planned" "None" "Yes (desktop installers / containers / artifacts)")
constraints=$(ask_non_empty "Constraints (comma-separated; use 'None' if none)" "None")

build_command=$(ask_non_empty "Build command" "")
run_command=$(ask_non_empty "Run command" "")
test_command=$(ask_non_empty "Test command" "")

prefill_path="exports/${date_stamp}_HANDOFF_PREFILL_${idea_id}.json"
cat > "$prefill_path" <<JSON
{
  "ideaId": "$idea_id",
  "projectName": "$project_name",
  "purpose": "${objective:-TBD}",
  "projectType": "$project_type",
  "techStack": {
    "language": "$language",
    "runtime": "$runtime",
    "framework": "$framework",
    "packageTool": "$package_tool"
  },
  "persistence": "$persistence",
  "authentication": "$authentication",
  "determinism": "$determinism",
  "packaging": "$packaging",
  "constraints": "$constraints",
  "commands": {
    "build": "$build_command",
    "run": "$run_command",
    "test": "$test_command"
  },
  "destination": "$clone_dir"
}
JSON

mkdir -p "$clone_dir/docs/adr"
copy_base "$clone_dir/project_init_templates/docs/README.base.md" "$clone_dir/README.md"
copy_base "$clone_dir/project_init_templates/docs/PROJECT_CONTEXT.base.md" "$clone_dir/docs/PROJECT_CONTEXT.md"
copy_base "$clone_dir/project_init_templates/docs/ROADMAP.base.md" "$clone_dir/docs/ROADMAP.md"
copy_base "$clone_dir/project_init_templates/docs/ARCHITECTURE.base.md" "$clone_dir/docs/ARCHITECTURE.md"
copy_base "$clone_dir/project_init_templates/docs/FILE_MAP.base.md" "$clone_dir/docs/FILE_MAP.md"
copy_base "$clone_dir/project_init_templates/docs/GOVERNANCE_INDEX.base.md" "$clone_dir/docs/GOVERNANCE_INDEX.md"
copy_base "$clone_dir/project_init_templates/docs/VERSIONING_AND_RELEASE_POLICY.base.md" "$clone_dir/docs/VERSIONING_AND_RELEASE_POLICY.md"
copy_base "$clone_dir/project_init_templates/docs/SECURITY_POLICY.base.md" "$clone_dir/docs/SECURITY_POLICY.md"
copy_base "$clone_dir/project_init_templates/docs/RUNTIME_VERIFICATION_REPORT.base.md" "$clone_dir/docs/RUNTIME_VERIFICATION_REPORT.md"
copy_base "$clone_dir/project_init_templates/docs/adr/ADR-0001-record-architecture-decisions.md" "$clone_dir/docs/adr/ADR-0001-record-architecture-decisions.md"
copy_base "$clone_dir/project_init_templates/docs/adr/ADR-TEMPLATE.md" "$clone_dir/docs/adr/ADR-TEMPLATE.md"
copy_base "$clone_dir/project_init_templates/docs/CHANGELOG.base.md" "$clone_dir/CHANGELOG.md"

if [[ "$persistence" != "None" ]]; then
  copy_base "$clone_dir/project_init_templates/docs/MIGRATION_POLICY.base.md" "$clone_dir/docs/MIGRATION_POLICY.md"
fi

lc_lang=$(printf '%s' "$language" | tr '[:upper:]' '[:lower:]')
if [[ "$lc_lang" == *"python"* ]]; then
  cp "$clone_dir/project_init_templates/gitignore/python.gitignore" "$clone_dir/.gitignore"
elif [[ "$lc_lang" == *"node"* || "$lc_lang" == *"javascript"* || "$lc_lang" == *"typescript"* ]]; then
  cp "$clone_dir/project_init_templates/gitignore/node.gitignore" "$clone_dir/.gitignore"
elif [[ "$lc_lang" == *"c#"* || "$lc_lang" == *"dotnet"* || "$lc_lang" == *".net"* ]]; then
  cp "$clone_dir/project_init_templates/gitignore/dotnet.gitignore" "$clone_dir/.gitignore"
else
  cp "$clone_dir/project_init_templates/gitignore/generic.gitignore" "$clone_dir/.gitignore"
fi

if [[ "$persistence" != "None" ]]; then
  cat >> "$clone_dir/.gitignore" <<'EOG'
*.db
*.sqlite
*.sqlite3
EOG
fi
if [[ "$packaging" != "None" ]]; then
  cat >> "$clone_dir/.gitignore" <<'EOG'
*.dmg
*.msi
*.AppImage
*.deb
*.rpm
EOG
fi

setup_steps="Language: $language\nRuntime: $runtime\nFramework: $framework\nTooling: $package_tool"
purpose_text=${objective:-"$project_name is initialized from brainstorming handoff."}

for f in \
  "$clone_dir/README.md" \
  "$clone_dir/docs/PROJECT_CONTEXT.md" \
  "$clone_dir/docs/ROADMAP.md" \
  "$clone_dir/docs/ARCHITECTURE.md" \
  "$clone_dir/docs/FILE_MAP.md" \
  "$clone_dir/docs/GOVERNANCE_INDEX.md" \
  "$clone_dir/docs/VERSIONING_AND_RELEASE_POLICY.md" \
  "$clone_dir/docs/SECURITY_POLICY.md" \
  "$clone_dir/docs/RUNTIME_VERIFICATION_REPORT.md" \
  "$clone_dir/docs/adr/ADR-0001-record-architecture-decisions.md" \
  "$clone_dir/docs/adr/ADR-TEMPLATE.md"; do
  apply_replacements "$f"
done

sed -i \
  -e "s#<Prototype / MVP / Beta>#MVP#g" \
  -e "s#<Stack-specific setup steps>#$setup_steps#g" \
  -e "s#<command>#$build_command#g" \
  "$clone_dir/README.md"

# Replace command blocks in README for run/test separately.
awk -v b="$build_command" -v r="$run_command" -v t="$test_command" '
  /Run:/ {print; getline; print "\n    " r; next}
  /Test:/ {print; getline; print "\n    " t; next}
  {print}
' "$clone_dir/README.md" > "$clone_dir/README.md.tmp" && mv "$clone_dir/README.md.tmp" "$clone_dir/README.md"

sed -i \
  -e "s#<Describe what this project is and why it exists.>#$purpose_text#g" \
  -e "s#<What comes next>#Deliver Milestone 0 vertical slice and validation evidence.#g" \
  "$clone_dir/docs/PROJECT_CONTEXT.md"

sed -i \
  -e "s#Milestone 0 – Foundation#$MILESTONE_NAME#g" \
  -e "s#<commands run> + <results observed>#$build_command (success), $test_command (pass), $run_command (smoke verified)#g" \
  "$clone_dir/docs/ROADMAP.md"

sed -i \
  -e "s#<build command>#$build_command#g" \
  -e "s#<test command>#$test_command#g" \
  -e "s#<run command>#$run_command#g" \
  "$clone_dir/docs/RUNTIME_VERIFICATION_REPORT.md"

# Changelog initialization line under Unreleased.
awk '
  /## \[Unreleased\]/ { print; print "\n### Added\n- Initialized Structured Mode governance baseline."; next }
  { print }
' "$clone_dir/CHANGELOG.md" > "$clone_dir/CHANGELOG.md.tmp" && mv "$clone_dir/CHANGELOG.md.tmp" "$clone_dir/CHANGELOG.md"

if ! validate_generated "$clone_dir"; then
  echo "Initialization validation failed. project_init_templates/ retained for manual fix." >&2
  exit 1
fi

rm -rf "$clone_dir/project_init_templates"

session_path="exports/${date_stamp}_HANDOFF_SESSION_${idea_id}.md"
cat > "$session_path" <<MD
# Handoff Session

- Date: $date_stamp
- Idea ID: $idea_id
- Export: \`$export_path\`
- Prefill: \`$prefill_path\`
- Destination: \`$clone_dir\`
- Initialization: completed

The project has been successfully initialized under Structured Mode governance.
MD

echo "Handoff prefill: $prefill_path"
echo "Handoff session log: $session_path"
echo "The project has been successfully initialized under Structured Mode governance."
