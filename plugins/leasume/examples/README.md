# examples/ — 가공 예시 (fictional data)

> **주의**: 이 디렉토리의 모든 내용은 **가공(fictional) 데이터**입니다.
> 실제 멘티·개인 정보가 아닙니다. 신규 사용자·기여자 안내 및 런타임 few-shot 참조용입니다.

---

## 가상 멘티 프로파일

| 항목 | 내용 |
|------|------|
| 가명 | 박재원 (fictional) |
| 직군 | 백엔드 개발자 3년차 |
| 주요 스택 | Java, Spring Boot, MySQL, Redis |
| assess 결과 | **L2** — 불릿 나열·Why부재·정량 맥락 약함 |
| 핵심 프로젝트 | 핀테크 스타트업 상품조회 API Redis 캐시 최적화 |

---

## 전 파이프라인 흐름과 산출 파일 매핑

```
/leasume:init-resume-workspace jaewon-park-2026
    → sample-vault/raw/resume-original.md       (원본 이력서, 불변)
    → sample-vault/.leasume-session              (pipeline_stage: init)
    → sample-vault/index.md
    → sample-vault/SCHEMA.md

/leasume:assess jaewon-park-2026
    → sample-vault/wiki/projects/fintech-startup.md  (assess_flags 기록)
    → .leasume-session pipeline_stage: interview, assess_level: L2

/leasume:interview-resume-hybrid jaewon-park-2026
    → sample-vault/wiki/projects/fintech-startup.md  (인터뷰 정제 내용 append)
    → sample-vault/wiki/skills/redis.md
    → sample-vault/wiki/skills/jwt.md
    → .leasume-session pipeline_stage: format, dig_state 갱신

/leasume:format-star-sbi jaewon-park-2026
    → sample-vault/wiki/episodes/redis-cache.md      (STAR 에피소드)
    → .leasume-session pipeline_stage: export

/leasume:export jaewon-park-2026
    → sample-vault/resume/draft.md              (추정 마커 포함, canonical)
    → sample-vault/resume/final.html            (ATS 친화, 마커 strip)
```

---

## Before / After 핵심 예시

**Before** (원본 이력서 불릿):
```
- Redis 캐시 적용으로 상품조회 API 응답 20초→0.8초 개선
```

**After** (인터뷰 + STAR 정제 결과, draft.md):
```
상품조회 API 응답 지연(P99 18초) 문제를 Redis Look-aside 캐시 도입으로 해소했습니다.
PM 이슈 제보 → 원인 분석(MySQL 풀스캔 + N+1) → Look-aside 패턴 선택 이유(read-heavy
특성, 쓰기 복잡도 낮음) → TTL 5분 + 명시적 eviction 설계 → 배포 후 P99 0.8초.
단, 수치(20초→0.8초)의 측정 조건(부하·동시접속)은 인터뷰에서 확인 불완전 — 면접 전
재확인 권장.
```

변화 포인트:
- "적용으로 개선" → Why(read-heavy 특성) + How(Look-aside 패턴 선택 근거) + 트레이드오프(쓰기 복잡도) 포함
- 맥락 없는 수치 → 측정 조건 불확실 표기 + 면접 전 확인 숙제 명시
- 1줄 불릿 → 결론 먼저(두괄식) + 흐름 있는 문장

---

## 파일 목록

```
examples/
├── README.md                               ← 이 파일
└── sample-vault/                           ← 전 파이프라인 후 vault 스냅샷 (가공)
    ├── raw/
    │   └── resume-original.md              ← 입력 원본 (불변, 빈약한 불릿 나열)
    ├── wiki/
    │   ├── projects/
    │   │   └── fintech-startup.md          ← assess 플래그 + interview 정제
    │   ├── skills/
    │   │   ├── redis.md                    ← Redis 기술 항목 (최적화경험)
    │   │   └── jwt.md                      ← JWT 항목 (Why 확보 예시)
    │   └── episodes/
    │       └── redis-cache.md              ← STAR 에피소드 + 면접 답변 포인트
    ├── resume/
    │   ├── draft.md                        ← 추정 마커 포함 초안
    │   └── final.html                      ← ATS 친화 HTML (마커 strip)
    ├── index.md
    ├── SCHEMA.md
    └── .leasume-session                    ← pipeline_stage: export (완주)
```
