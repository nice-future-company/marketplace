#!/usr/bin/env bash
# resolve-vault-root.sh — 단일 정규 진입점. vault_root + id → MENTEE_ROOT 출력.
# 사용: ./resolve-vault-root.sh <id>
# stdout: MENTEE_ROOT 절대경로
# exit 0=성공, 1=오류(stderr에 메시지)
set -euo pipefail

# ── 인자 확인 ──────────────────────────────────────────────────────────────
ID="${1:-}"
if [[ -z "$ID" ]]; then
  echo "ERROR: <id> 인자가 필요합니다. 사용법: resolve-vault-root.sh <id>" >&2
  exit 1
fi

# id 검증: ^[a-zA-Z0-9_-]{1,64}$ (path traversal 차단)
if ! [[ "$ID" =~ ^[a-zA-Z0-9_-]{1,64}$ ]]; then
  echo "ERROR: 유효하지 않은 id '$ID'. 허용 문자: a-z A-Z 0-9 _ - (1~64자)" >&2
  exit 1
fi

# ── vault_root 해소 순서 ───────────────────────────────────────────────────
# 1) 환경변수 LEASUME_VAULT_ROOT
# 2) ~/.leasume-config.json 의 vault_root 필드
# 3) 기본값 ~/.leasume-vaults

VAULT_ROOT=""

if [[ -n "${LEASUME_VAULT_ROOT:-}" ]]; then
  VAULT_ROOT="$LEASUME_VAULT_ROOT"
elif [[ -f "$HOME/.leasume-config.json" ]]; then
  CONFIG_FILE="$HOME/.leasume-config.json"
  # jq가 있으면 사용, 없으면 python3 fallback, 없으면 grep 단순 파싱
  if command -v jq &>/dev/null; then
    VAULT_ROOT=$(jq -r '.vault_root // empty' "$CONFIG_FILE" 2>/dev/null || true)
  elif command -v python3 &>/dev/null; then
    # CONFIG_FILE을 argv로 전달 — 쉘 변수를 Python 소스에 직접 보간하지 않음
    VAULT_ROOT=$(python3 - "$CONFIG_FILE" <<'PYEOF' 2>/dev/null || true
import json, sys
try:
    d = json.load(open(sys.argv[1]))
    print(d.get('vault_root', ''))
except Exception:
    pass
PYEOF
    )
  else
    # 최후 수단: grep으로 vault_root 값 추출 (단순 케이스만)
    VAULT_ROOT=$(grep -oP '"vault_root"\s*:\s*"\K[^"]+' "$CONFIG_FILE" 2>/dev/null || true)
  fi
fi

if [[ -z "$VAULT_ROOT" ]]; then
  VAULT_ROOT="$HOME/.leasume-vaults"
fi

# 홈 디렉토리 ~ 확장 (env var에 ~가 들어온 경우 대응)
VAULT_ROOT="${VAULT_ROOT/#\~/$HOME}"

# ── VAULT_ROOT 보안 검증 ────────────────────────────────────────────────────
# 1) 절대경로 여부 확인
if [[ "$VAULT_ROOT" != /* ]]; then
  echo "ERROR: vault_root 가 절대경로가 아닙니다: '$VAULT_ROOT'" >&2
  echo "       절대경로(예: /home/user/vaults)를 사용하세요." >&2
  exit 1
fi

# 2) .. 컴포넌트 포함 여부 확인 (path traversal 차단)
if [[ "$VAULT_ROOT" == *"/.."* || "$VAULT_ROOT" == *"../"* || "$VAULT_ROOT" == ".." ]]; then
  echo "ERROR: vault_root 에 '..' 가 포함되어 있습니다: '$VAULT_ROOT'" >&2
  echo "       '..'가 없는 절대경로를 사용하세요." >&2
  exit 1
fi

# ── MENTEE_ROOT 출력 ────────────────────────────────────────────────────────
MENTEE_ROOT="${VAULT_ROOT}/${ID}"
echo "$MENTEE_ROOT"
