# resume vault SCHEMA

이 파일은 `/resume:init <id>` 실행 시 멘티 vault에 자동 복사됩니다.

---

## vault 개요

이 디렉토리는 [resume](https://github.com/nice-future-company/marketplace/tree/main/plugins/resume) 플러그인이 생성한 **개인 이력서 작업 vault**입니다.

- william-vault 경량 fork 구조를 차용하되, **william-vault와 비동기화** — 별도 운영.
- raw/ 아래 원본은 불변. AI는 wiki/ 와 resume/ 만 편집.
- 이 vault는 로컬 전용(PII 격리). git push 대상에서 제외됩니다.

---

## 페이지 타입

### type: project
경력/프로젝트 단위 페이지. `wiki/projects/` 에 위치.

필수 frontmatter:
```yaml
---
type: project
title: "프로젝트 명"
period: "YYYY-MM ~ YYYY-MM"
role: "역할"
stack: []
assess_flags: []        # Why부재 | 정량없음 | 명사나열 | 빈약 | 실력진위불명
created: YYYY-MM-DD
updated: YYYY-MM-DD
---
```

필수 섹션: `## 요약`, `## 상세`, `## 결핍 플래그`

---

### type: skill-item
기술 스택 단위 페이지. `wiki/skills/` 에 위치.

필수 frontmatter:
```yaml
---
type: skill-item
title: "기술명"
level: "아는것|해본것|설명가능|최적화경험"
evidence_flags: []      # Why부재 | 근거부족 | 미검증
created: YYYY-MM-DD
updated: YYYY-MM-DD
---
```

필수 섹션: `## 요약`, `## 근거`, `## 결핍 플래그`

---

### type: episode
STAR 또는 SBI 에피소드 단위 페이지. `wiki/episodes/` 에 위치.

필수 frontmatter:
```yaml
---
type: episode
title: "에피소드 제목"
format: STAR | SBI
project_ref: "wiki/projects/xxx.md"
inferred: false         # true이면 star-sbi에서 > 추정: 마커 포함
created: YYYY-MM-DD
updated: YYYY-MM-DD
---
```

STAR 필수 섹션: `## Situation`, `## Task`, `## Action`, `## Result`
SBI 필수 섹션: `## Situation`, `## Behavior`, `## Impact`

SBI 선택 조건: 결과 수치화 불가 AND 팀 상호작용/행동 변화가 핵심인 경우.

---

## .resume-session 스키마

`.resume-session` 파일은 vault 루트에 위치하며 pipeline 상태를 추적합니다.

```yaml
---
mentee_id: "{id}"              # 멘티 식별자
vault_root: "/abs/path"        # 기록용 캐시, 경로 해소 진입점 아님
pipeline_stage: init|assess|interview|star-sbi|export
assess_level: L0|L1|L2|L3     # assess 완료 후 기록
self_reported_staleness: bool  # start 1문항: 최근 경력 미갱신 여부
dig_state:
  current_project_id: "..."    # 현재 dig 중인 프로젝트 id
  questions_asked: N           # 누적 질문 수
  projects_completed: []       # dig 완료된 프로젝트 id 목록
  last_checkpoint: N           # 마지막 checkpoint 번호 (8질문 배수마다 +1)
escalated: bool                # escalate-handoff.md 생성 여부
last_updated: "YYYY-MM-DD"
---
```

- `dig`: 시작 시 read, 8질문마다 checkpoint write, 중단 시 write.
- checkpoint = 저장 보장 단위. "여기까지 저장됨. 언제든 재개 가능." 안내 포함.
- 동시 실행(동일 id 멀티 터미널) 비지원 — 파일 락 없음.

---

## 누적 전략

기존 페이지가 있을 때:
- 섹션 단위 append + 날짜 표기: `### 업데이트 (YYYY-MM-DD): ...`
- 덮어쓰지 않음.
- 모순 발견 시: `> 모순 (YYYY-MM-DD):` 블록으로 명시.
- LLM 추정/해석은 `> 추정:` 마커 필수.
