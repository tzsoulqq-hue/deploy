#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
DEPLOY_DIR=$(cd -- "$SCRIPT_DIR/.." && pwd)
SOURCE_ROOT=${SOURCE_ROOT:-$(cd -- "$DEPLOY_DIR/.." && pwd)}
FRONTEND_MODULES_CONFIG=${FRONTEND_MODULES_CONFIG:-$DEPLOY_DIR/frontend-modules.json}
TARGET_DIR=${TARGET_DIR:-$SOURCE_ROOT/webui/src/dashboard/modules}

if [[ ! -f "$FRONTEND_MODULES_CONFIG" ]]; then
  printf '[sync-dashboard-modules] frontend module config not found: %s\n' "$FRONTEND_MODULES_CONFIG" >&2
  exit 1
fi

python3 - "$FRONTEND_MODULES_CONFIG" "$SOURCE_ROOT" "$TARGET_DIR" <<'PY'
import json
import os
import shutil
import sys

config_path, source_root, target_root = sys.argv[1:4]

with open(config_path, "r", encoding="utf-8") as handle:
    modules = (json.load(handle).get("modules") or [])

if not modules:
    raise SystemExit(f"frontend module config has no modules: {config_path}")

if os.path.isdir(target_root):
    shutil.rmtree(target_root)
os.makedirs(target_root, exist_ok=True)

seen = set()
for module in modules:
    if module.get("enabled") is False:
        continue
    name = str(module.get("name") or "").strip()
    source = str(module.get("source") or "").strip()
    target = str(module.get("target") or name).strip()
    if not name or not source or not target:
        raise SystemExit(f"invalid frontend module entry in {config_path}: {module!r}")
    if "/" in target or "\\" in target or target in {".", ".."} or target in seen:
        raise SystemExit(f"invalid or duplicate frontend module target: {target}")
    seen.add(target)

    source_path = source if os.path.isabs(source) else os.path.join(source_root, source)
    if not os.path.isdir(source_path):
        raise SystemExit(f"frontend module source not found for {name}: {source_path}")

    destination = os.path.join(target_root, target)
    shutil.copytree(source_path, destination)
    print(f"[sync-dashboard-modules] {name}: {source_path} -> {destination}")
PY
