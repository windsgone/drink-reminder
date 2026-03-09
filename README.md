# Drink Reminder

A macOS menu bar app for hydration reminders.

## 1) Push this project to a new public GitHub repo

```bash
git remote add origin git@github.com:<your-username>/<your-repo>.git
# or:
# git remote add origin https://github.com/<your-username>/<your-repo>.git

git push -u origin main
```

## 2) Create a downloadable Release package

This repo includes `.github/workflows/release.yml`.
When you push a tag like `v1.0.0`, GitHub Actions will:
- build the macOS app in Release mode
- package `Drink Reminder.app` into a zip
- create a GitHub Release and attach the zip
- set app versions automatically:
  - `MARKETING_VERSION` = `1.0.0` (from tag `v1.0.0`)
  - `CURRENT_PROJECT_VERSION` = GitHub Actions run number (auto-incrementing build number)

Run:

```bash
git tag v1.0.0
git push origin v1.0.0
```

## 3) Local package build (optional)

```bash
scripts/build-release-zip.sh Release
```

The generated zip is in `dist/`.

## Install for end users

1. Download the zip from GitHub Release.
2. Unzip it.
3. Drag `Drink Reminder.app` to `Applications` and open it.

If you need truly "double-click and install without security warning", you must code sign + notarize with an Apple Developer certificate.
