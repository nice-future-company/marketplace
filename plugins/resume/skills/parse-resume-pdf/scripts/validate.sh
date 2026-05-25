#!/usr/bin/env bash
set -eu

test -f skills/parse-resume-pdf/SKILL.md
test -f skills/parse-resume-pdf/template.md
test -f skills/parse-resume-pdf/examples/sample.md
# 공유 지시블록(경로 무관): 추출 규칙·실패 규칙 핵심 마커 검증
grep -q "공유 지시블록" skills/parse-resume-pdf/SKILL.md
grep -q "## 기술 스택" skills/parse-resume-pdf/SKILL.md
grep -q "스캔본" skills/parse-resume-pdf/SKILL.md

echo "parse-resume-pdf: validation passed"
