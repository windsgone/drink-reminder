#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: scripts/release-next-tag.sh [patch|minor|major] [--dry-run]

Examples:
  scripts/release-next-tag.sh
  scripts/release-next-tag.sh patch
  scripts/release-next-tag.sh minor --dry-run
USAGE
}

bump_part="patch"
dry_run="false"

for arg in "$@"; do
  case "${arg}" in
    patch|minor|major)
      bump_part="${arg}"
      ;;
    --dry-run)
      dry_run="true"
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: ${arg}" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Must run inside a git repository." >&2
  exit 1
fi

if ! git remote get-url origin >/dev/null 2>&1; then
  echo "Git remote 'origin' is not configured." >&2
  exit 1
fi

echo "Fetching tags from origin..." >&2
git fetch --tags origin >/dev/null 2>&1 || true

latest_tag="$(git tag -l 'v[0-9]*.[0-9]*.[0-9]*' | sort -V | tail -n 1)"
if [[ -z "${latest_tag}" ]]; then
  latest_tag="v0.0.0"
fi

if [[ ! "${latest_tag}" =~ ^v([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
  echo "Latest semver tag is invalid: ${latest_tag}" >&2
  exit 1
fi

major="${BASH_REMATCH[1]}"
minor="${BASH_REMATCH[2]}"
patch="${BASH_REMATCH[3]}"

case "${bump_part}" in
  patch)
    patch=$((patch + 1))
    ;;
  minor)
    minor=$((minor + 1))
    patch=0
    ;;
  major)
    major=$((major + 1))
    minor=0
    patch=0
    ;;
esac

next_tag="v${major}.${minor}.${patch}"

echo "Latest tag: ${latest_tag}"
echo "Next tag:   ${next_tag}"

if [[ "${dry_run}" == "true" ]]; then
  echo "Dry run enabled. No tag was created."
  exit 0
fi

if git rev-parse -q --verify "refs/tags/${next_tag}" >/dev/null; then
  echo "Tag already exists locally: ${next_tag}" >&2
  exit 1
fi

echo "Creating tag ${next_tag}..." >&2
git tag "${next_tag}"

echo "Pushing ${next_tag} to origin..." >&2
git push origin "${next_tag}"

echo

echo "Triggered release workflow for ${next_tag}."
echo "Track run:" 
echo "  gh run list --workflow release.yml --limit 5"
echo "Watch latest run:" 
echo "  gh run watch \\$(gh run list --workflow release.yml --limit 1 --json databaseId --jq '.[0].databaseId') --exit-status"
echo "Open release:" 
echo "  gh release view ${next_tag} --web"
