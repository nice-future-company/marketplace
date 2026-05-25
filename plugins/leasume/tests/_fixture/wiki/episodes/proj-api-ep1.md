---
type: episode
title: "API 응답속도 개선 — N+1 제거 및 캐시 도입"
format: STAR
project_ref: "wiki/projects/proj-api.md"
inferred: false
created: 2026-05-25
updated: 2026-05-25
---

# API 응답속도 개선 — N+1 제거 및 캐시 도입

## Situation
레거시 Node.js API의 핵심 엔드포인트 3개가 평균 응답속도 800ms를 초과했습니다.
트래픽 증가(월 10만 → 30만 요청)로 인해 성능 개선이 급선무였습니다.

## Task
Go 전환 과정에서 핵심 엔드포인트 3개를 200ms 이하로 개선하는 것.
측정 기준: k6 부하 테스트, 100 VU, 5분 지속.

## Action
1. ORM 쿼리 분석으로 N+1 패턴 7곳 발견 → raw SQL로 교체
2. (created_at, user_id) 복합 인덱스 추가 — EXPLAIN ANALYZE로 검증
3. Redis 캐시 레이어 도입: TTL 300초, 캐시 히트율 측정

## Result
평균 응답속도 800ms → 180ms (78% 개선).
k6 100 VU 기준 에러율 0%. 캐시 히트율 62%.
