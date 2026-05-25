---
type: project
title: "REST API 서버 개발"
period: "2024-01 ~ 2024-12"
role: "백엔드 개발자"
stack: ["Go", "PostgreSQL", "Redis"]
assess_flags: ["Why부재", "정량없음"]
created: 2026-05-25
updated: 2026-05-25
---

## 요약
Go 언어로 REST API 서버를 개발했습니다. PostgreSQL 기반 CRUD와 Redis 캐시 레이어를 구현했습니다.

## 상세
레거시 Node.js 서버를 Go로 전환. 핵심 엔드포인트 3개의 응답속도를 개선하고 PostgreSQL 인덱스 최적화를 수행했습니다.

dig 수집 내용:
- N+1 쿼리 제거 (ORM 남용 패턴 발견)
- 복합 인덱스 추가 (created_at + user_id)
- Redis 캐시 TTL 300초 설정

### 업데이트 (2026-05-25): dig checkpoint 2
Why부재 항목 보강: Go 선택 이유 — 팀 내 Go 경험자 존재, 타입 안정성 필요.
정량없음 항목 보강: 응답속도 800ms → 180ms (측정 도구: k6, 부하조건: 100 VU).

## 결핍 플래그
- Why부재: Go 선택 이유 최초 미기재 → dig에서 보강 완료
- 정량없음: 성과 수치 최초 미기재 → dig에서 측정 방식 확인 완료
