#!/usr/bin/env bash
set -eu

test -f skills/generate-korean-cover-letter/SKILL.md
test -f skills/generate-korean-cover-letter/template.md
test -f skills/generate-korean-cover-letter/examples/sample.md
grep -q "지원 동기" skills/generate-korean-cover-letter/SKILL.md
grep -q "문제 해결" skills/generate-korean-cover-letter/SKILL.md
grep -q "협업/커뮤니케이션" skills/generate-korean-cover-letter/SKILL.md
grep -q "성장 계획" skills/generate-korean-cover-letter/SKILL.md

echo "generate-korean-cover-letter: validation passed"
