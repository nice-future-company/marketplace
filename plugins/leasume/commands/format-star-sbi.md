---
description: "인터뷰 완료 항목을 STAR/SBI 에피소드로 구조화합니다. 사용: /leasume:format-star-sbi <id>"
argument-hint: "<id>"
allowed-tools: Bash
---

# leasume:format-star-sbi

## 역할
interview-resume-hybrid에서 수집한 프로젝트 내용을 STAR 또는 SBI 형식의 에피소드로 구조화합니다.
결과를 `wiki/episodes/*.md` 에 저장합니다.

---

## 포맷 규칙 (인라인)

### STAR (기본)
- 필수 키: `Situation`, `Task`, `Action`, `Result`
- 결과를 수치 또는 질적 변화로 기술 가능한 경우.

### SBI (조건부)
- 필수 키: `Situation`, `Behavior`, `Impact`
- 선택 조건 (단방향): 결과 수치화 불가 **AND** 팀 상호작용/행동 변화가 에피소드의 핵심인 경우.
- 두 조건 동시 충족 시에만 SBI. 조건 불명확하면 STAR 사용.

### 공통
- 에피소드를 사건 단위로 분해한다 (프로젝트당 1~3개).
- 재작성 시 원문 의미를 유지하고 과장하지 않는다.
- LLM이 추론한 내용은 `> 추정:` 마커 필수.
- 직접 내리지 않은 결정은 `> 추정:` 마커 + frontmatter `inferred: true`.
- STAR/SBI 외 다른 포맷을 추가하지 않는다.

---

## 실행 절차

### 1단계: vault 확인

`scripts/resolve-vault-root.sh <id>` 로 MENTEE_ROOT 확인.

`.leasume-session` 읽기. `pipeline_stage` 가 `init`, `assess`, `interview` 이면 포맷 미실행 상태이므로 중단:
```
아직 인터뷰가 완료되지 않았습니다.
/leasume:interview-resume-hybrid {id} 를 먼저 실행하세요.
```
(`pipeline_stage` 허용 값: `format`, `export`. `init`/`assess`/`interview`이면 중단.)

`wiki/projects/` 파일 목록 확인. 없으면:
```
프로젝트 정보가 없습니다.
/leasume:interview-resume-hybrid {id} 로 정보를 수집하세요.
```

### 2단계: 에피소드 생성

`wiki/projects/` 의 각 프로젝트에 대해:

1. 프로젝트 페이지 내용과 인터뷰에서 수집된 Q&A를 읽는다.
2. 에피소드 단위로 분해 (프로젝트당 1~3개 에피소드).
3. STAR/SBI 포맷으로 작성.

#### STAR 형식:
```markdown
---
type: episode
title: "{에피소드 제목}"
format: STAR
project_ref: "wiki/projects/{project-id}.md"
inferred: false
created: {날짜}
updated: {날짜}
---

# {에피소드 제목}

## Situation
{배경 상황: 어떤 문제/맥락이었나}

## Task
{과제: 해결해야 할 것이 무엇이었나}

## Action
{행동: 직접 취한 행동 — 복수의 구체적 액션}

## Result
{결과: 무슨 일이 일어났나 — 수치 또는 질적 변화}
```

#### SBI 형식:
```markdown
---
type: episode
title: "{에피소드 제목}"
format: SBI
project_ref: "wiki/projects/{project-id}.md"
inferred: false
created: {날짜}
updated: {날짜}
---

# {에피소드 제목}

## Situation
{상황: 언제, 어떤 맥락에서}

## Behavior
{행동: 구체적으로 어떤 행동을 했나 — 관찰 가능한 행동}

## Impact
{영향: 팀/동료/결과에 어떤 변화가 있었나}
```

### 3단계: 추정 마커 적용 규칙

다음 경우에는 반드시 `> 추정:` 마커를 달고, `inferred: true` 로 설정:

- 인터뷰에서 "직접 결정 아님"으로 확인된 내용
- 멘티가 명확히 설명하지 않아 LLM이 추론한 부분
- 수치/결과가 불확실한 경우

```markdown
## Result
> 추정: 인터뷰에서 구체적 수치를 확인하지 못함. 멘티의 "많이 줄었다" 발언 기반 추정.
성능 개선 효과가 있었으나 측정 방식과 기준치 불명확.
```

**추정 마커는 draft.md에 유지. final.html에서 strip됨.**

### 4단계: wiki/episodes/ 저장

파일명: `wiki/episodes/{project-id}-{episode-n}.md`

기존 에피소드 파일이 있으면: 섹션 단위 append + `### 업데이트 (날짜):` 표기.

### 5단계: 완료 처리

`.leasume-session`:
- `pipeline_stage: export`
- `last_updated: YYYY-MM-DD`

출력:
```
에피소드 구조화 완료.

생성된 에피소드:
- wiki/episodes/{파일명} ({STAR/SBI})
- ...

추정 마커 포함 항목: {N}개
→ export 시 final.html에서 strip되고 경고 배너로 집계됩니다.

다음: /leasume:export {id}
또는 추정 항목을 먼저 보완하려면 /leasume:interview-resume-hybrid {id} 재실행 후 export.
```

> 구체 예시: `examples/sample-vault/wiki/episodes/redis-cache.md` — STAR 에피소드·면접 답변 포인트·추가 확인 숙제 기록 방식 참조.
