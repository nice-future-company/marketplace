---
type: skill-item
title: "Redis"
level: "최적화경험"
evidence_flags: []
created: 2026-05-25
updated: 2026-05-25
note: "가공 데이터 — fictional. 실제 인물 아님."
---

# Redis

## 요약
Look-aside 캐시 패턴 설계 및 운영 경험. TTL·명시적 eviction 전략을 직접 결정하고
구현했습니다. 단순 사용(캐시 적재/조회)을 넘어 패턴 선택 근거와 트레이드오프를
설명할 수 있는 수준입니다.

## 근거

### 직접 경험한 것 (해본것 이상)
- Look-aside 패턴 선택 이유 설명 가능 (read-heavy 특성 기반)
- TTL 설계 결정 경험 (5분, 상품 변경 주기 고려)
- 명시적 eviction 구현 (`DEL` 키 삭제 시점 설계)
- 직렬화 포맷 결정 (Jackson JSON)
- 캐시 키 구조 설계 (`product:list:{category_id}:{page}:{size}`)

### 동작 원리 설명 가능 여부 (설명가능 수준)
- Look-aside vs Write-through 차이 및 선택 기준
- TTL 만료 vs 명시적 eviction 트레이드오프
- Redis 단일 스레드 이벤트 루프 구조 (개념 설명 가능)

### 아직 경험 없는 것
- Redis Cluster / Sentinel 운영
- Lua 스크립트를 활용한 원자적 연산
- Redis Streams / Pub-Sub 실무 적용

## 결핍 플래그
- 없음. 단, 수치(응답속도 개선값)의 측정 조건은 면접 전 재확인 권장.
