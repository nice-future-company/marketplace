#!/usr/bin/env bash
# validate.sh — leasume vault 구조 검증
# 사용: ./validate.sh <MENTEE_ROOT>
#       인자 없이 실행 시 tests/_fixture 대상 self-test 실행
# exit 0=모두 통과, exit 1=하나 이상 실패
#
# 검증 범위: 파일 존재 + 필수 frontmatter 필드 + 필수 섹션 헤더 grep
# LLM 생성 내용의 정확성은 범위 밖 (비결정적).
set -euo pipefail

# 인자 없으면 _fixture self-test
if [[ -z "${1:-}" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  FIXTURE_ROOT="$SCRIPT_DIR/../tests/_fixture"
  if [[ ! -d "$FIXTURE_ROOT" ]]; then
    echo "ERROR: _fixture 디렉토리를 찾을 수 없습니다: $FIXTURE_ROOT" >&2
    exit 1
  fi
  echo "=== self-test: tests/_fixture ==="
  exec "$0" "$FIXTURE_ROOT"
fi

MENTEE_ROOT="${1}"

PASS=0
FAIL=0

ok()   { echo "[PASS] $1"; ((PASS++)) || true; }
fail() { echo "[FAIL] $1"; ((FAIL++)) || true; }

# ── 1. 디렉토리 구조 ────────────────────────────────────────────────────────
check_dir() {
  local d="$MENTEE_ROOT/$1"
  if [[ -d "$d" ]]; then ok "dir: $1"; else fail "dir missing: $1"; fi
}

check_dir "raw"
check_dir "wiki/projects"
check_dir "wiki/skills"
check_dir "wiki/episodes"
check_dir "resume"

# ── 2. 필수 파일 존재 ───────────────────────────────────────────────────────
check_file() {
  local f="$MENTEE_ROOT/$1"
  if [[ -f "$f" ]]; then ok "file: $1"; else fail "file missing: $1"; fi
}

check_file "index.md"
check_file "SCHEMA.md"
check_file ".leasume-session"

# ── 3. .leasume-session frontmatter 필수 필드 ──────────────────────────────
SESSION="$MENTEE_ROOT/.leasume-session"
if [[ -f "$SESSION" ]]; then
  for field in mentee_id vault_root pipeline_stage assess_level self_reported_staleness escalated last_updated; do
    if grep -q "^${field}:" "$SESSION" 2>/dev/null; then
      ok "session.field: $field"
    else
      fail "session.field missing: $field"
    fi
  done
  # dig_state 서브필드 — 앵커로 거짓 PASS 차단 (들여쓰기 공백 1개 이상 필수)
  for subfield in current_project_id questions_asked projects_completed last_checkpoint; do
    if grep -q "^[[:space:]]\+${subfield}:" "$SESSION" 2>/dev/null; then
      ok "session.dig_state.$subfield"
    else
      fail "session.dig_state.$subfield missing"
    fi
  done
fi

# ── 4. wiki/projects/*.md — frontmatter + 섹션 헤더 ────────────────────────
for f in "$MENTEE_ROOT"/wiki/projects/*.md; do
  [[ -f "$f" ]] || continue
  base=$(basename "$f")
  for field in type title period role; do
    if grep -q "^${field}:" "$f" 2>/dev/null; then
      ok "projects/$base: frontmatter.$field"
    else
      fail "projects/$base: frontmatter.$field missing"
    fi
  done
  for section in "## 요약" "## 상세" "## 결핍 플래그"; do
    if grep -qF "$section" "$f" 2>/dev/null; then
      ok "projects/$base: section '$section'"
    else
      fail "projects/$base: section '$section' missing"
    fi
  done
done

# ── 5. wiki/episodes/*.md — frontmatter + 포맷별 섹션 ──────────────────────
for f in "$MENTEE_ROOT"/wiki/episodes/*.md; do
  [[ -f "$f" ]] || continue
  base=$(basename "$f")
  for field in type title format project_ref; do
    if grep -q "^${field}:" "$f" 2>/dev/null; then
      ok "episodes/$base: frontmatter.$field"
    else
      fail "episodes/$base: frontmatter.$field missing"
    fi
  done
  fmt=$(grep "^format:" "$f" 2>/dev/null | head -1 | awk '{print $2}')
  if [[ "$fmt" == "STAR" ]]; then
    for section in "## Situation" "## Task" "## Action" "## Result"; do
      if grep -qF "$section" "$f" 2>/dev/null; then
        ok "episodes/$base: STAR section '$section'"
      else
        fail "episodes/$base: STAR section '$section' missing"
      fi
    done
  elif [[ "$fmt" == "SBI" ]]; then
    for section in "## Situation" "## Behavior" "## Impact"; do
      if grep -qF "$section" "$f" 2>/dev/null; then
        ok "episodes/$base: SBI section '$section'"
      else
        fail "episodes/$base: SBI section '$section' missing"
      fi
    done
  fi
done

# ── 6. examples/sample-vault 핵심 파일 존재 (self-test 시에만) ───────────────
SCRIPT_DIR_V="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXAMPLES_VAULT="$SCRIPT_DIR_V/../examples/sample-vault"
if [[ -d "$EXAMPLES_VAULT" ]]; then
  for ef in \
    "raw/resume-original.md" \
    "wiki/projects/fintech-startup.md" \
    "wiki/skills/redis.md" \
    "wiki/episodes/redis-cache.md" \
    "resume/draft.md" \
    "resume/final.html" \
    ".leasume-session"; do
    if [[ -f "$EXAMPLES_VAULT/$ef" ]]; then
      ok "examples/sample-vault/$ef"
    else
      fail "examples/sample-vault/$ef missing"
    fi
  done
fi

# ── 7. 결과 요약 ────────────────────────────────────────────────────────────
echo ""
echo "결과: PASS=${PASS}, FAIL=${FAIL}"
if [[ $FAIL -gt 0 ]]; then
  exit 1
fi
exit 0
