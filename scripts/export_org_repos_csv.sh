#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: export_org_repos_csv.sh <org-name> [output.csv]

Exports all repositories in a GitHub organization to a CSV file using gh CLI.

Arguments:
  <org-name>   GitHub organization login
  [output.csv] Output CSV file path (default: <org-name>-repos.csv)
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

ORG="${1:-}"
if [[ -z "${ORG}" ]]; then
  usage
  exit 1
fi

OUTPUT="${2:-${ORG}-repos.csv}"

if ! command -v gh >/dev/null 2>&1; then
  echo "Error: gh CLI is not installed." >&2
  exit 1
fi

if ! gh auth status >/dev/null 2>&1; then
  echo "Error: gh is not authenticated. Run: gh auth login" >&2
  exit 1
fi

TMP_DATA="$(mktemp)"
trap 'rm -f "${TMP_DATA}"' EXIT

printf '%s\n' "repo_name,full_name,last_updated_at,privacy_status,is_private,is_archived,is_fork,is_disabled,default_branch,primary_language,stars,forks,open_issues,size_kb,created_at,last_pushed_at,license_spdx,has_issues,has_wiki,has_projects,homepage,url" > "${OUTPUT}"

gh api --paginate "/orgs/${ORG}/repos?per_page=100&type=all&sort=updated&direction=desc" --jq '
  .[] |
  [
    .name,
    .full_name,
    (.updated_at // ""),
    (.visibility // ""),
    .private,
    .archived,
    .fork,
    .disabled,
    (.default_branch // ""),
    (.language // ""),
    .stargazers_count,
    .forks_count,
    .open_issues_count,
    .size,
    (.created_at // ""),
    (.pushed_at // ""),
    (.license.spdx_id // ""),
    .has_issues,
    .has_wiki,
    .has_projects,
    (.homepage // ""),
    .html_url
  ] | @csv
' > "${TMP_DATA}"

cat "${TMP_DATA}" >> "${OUTPUT}"

TOTAL_REPOS="$(( $(wc -l < "${OUTPUT}") - 1 ))"
echo "Export complete: ${TOTAL_REPOS} repos written to ${OUTPUT}"
