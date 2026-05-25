---
description: "resume 사용법 및 레벨별 추천 흐름 안내."
argument-hint: ""
---

# resume:help

## resume 이란

개발자가 자신의 이력서를 LLM과 함께 파헤치는 Claude Code 플러그인입니다.
5why 드릴다운 + 실력 진위 확인 + STAR/SBI 에피소드 구조화까지 한 번에.

**무료 플러그인** = 방법론 전체 포함. 데이터팩 없이 완결됩니다.

---

## 명령 목록

| 명령 | 역할 |
|------|------|
| `/resume:init <id>` | vault 생성 + 이력서 입력 + 파이프라인 시작 |
| `/resume:assess <id>` | 이력서 진단 (L0~L3) + 경로 분기 |
| `/resume:interview <id>` | 인터뷰 + 5why 드릴다운 (핵심) |
| `/resume:star-sbi <id>` | STAR/SBI 에피소드 구조화 |
| `/resume:export <id> [--html]` | 이력서 draft.md + final.html 생성 |
| `/resume:status <id>` | 진행 상황 확인 |
| `/resume:help` | 이 화면 |

`<id>` = 멘티 식별자. 예: `kim-frontend-2026`, `park-backend`

---

## 레벨별 추천 흐름

### L0 — 이력서 없음 또는 내용 부족
```
init → assess → interview (빈템플릿) → star-sbi → export
```
이력서가 없어도 괜찮습니다. 인터뷰에서 경험을 하나씩 채워나갑니다.

### L1 — 최근 경력 미갱신
```
init → assess → interview (최근 경험 우선) → star-sbi → export
```
가장 최근 6개월 경험부터 집중적으로 탐색합니다.

### L2 — 보강 필요 (가장 많은 케이스)
```
init → assess → interview → star-sbi → export
```
Why부재·정량없음·명사나열 항목을 drill-down으로 보강합니다.
인터뷰가 가장 시간이 걸리지만 가장 중요한 단계입니다.

### L3 — 완성형
```
init → assess → interview (확인 위주) → star-sbi → export
```
인터뷰는 빠르게 검증하고, star-sbi·export에서 타겟 최적화에 집중합니다.

---

## 주요 개념

**vault** (`~/.resume-vaults/<id>/`)
모든 멘티 데이터는 로컬 vault에 저장됩니다. git 추적 제외 (PII 격리).

**checkpoint**
인터뷰 중 8질문마다 자동 저장됩니다. 언제든 중단하고 재개 가능.

**추정 마커 (`> 추정:`)**
LLM이 추론한 내용은 마커로 표시됩니다. `draft.md`에서 직접 확인하세요.
`final.html`에서는 자동으로 제거되고 경고 배너로 집계됩니다.

**escalate**
인터뷰에서 심화 세션이 필요한 신호가 감지되면 `escalate-handoff.md`가 생성됩니다.

---

## 설정

**기본 vault 위치**: `~/.resume-vaults/`

변경 방법:
1. 환경변수: `export RESUME_VAULT_ROOT=/your/path`
2. 전역 설정: `~/.resume-config.json` 에 `{"vault_root": "/your/path"}`

**동시 실행 비지원**: 동일 `<id>` 를 여러 터미널에서 동시에 실행하지 마세요.
파일 락이 없어 세션 데이터가 손상될 수 있습니다.

---

## 유료 데이터팩 (미출시)

`data/mentoring/topics/` 는 선택적 로드 훅으로 연결 지점만 예약되어 있습니다.
데이터팩 자료가 있으면 인터뷰에서 자동 활용됩니다. 현재 미출시.
데이터팩이 없으면 방법론 fallback으로 완결됩니다.
