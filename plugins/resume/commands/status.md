---
description: "파이프라인 진행 상황 표시. 사용: /resume:status <id>"
argument-hint: "<id>"
allowed-tools: Bash
---

# resume:status

## 역할
`.resume-session` 을 읽어 현재 파이프라인 진행 상태를 표시합니다.

---

## 실행 절차

### 1단계: vault 확인

`scripts/resolve-vault-root.sh <id>` 로 MENTEE_ROOT 확인.
비0 exit 시 오류 출력 후 중단.

### 2단계: 파일 존재 확인 (Bash)

다음 파일 존재 여부를 Bash로 확인:
- `{MENTEE_ROOT}/.resume-session`
- `{MENTEE_ROOT}/raw/resume-original.md`
- `{MENTEE_ROOT}/wiki/projects/*.md` (개수)
- `{MENTEE_ROOT}/wiki/episodes/*.md` (개수)
- `{MENTEE_ROOT}/resume/draft.md`
- `{MENTEE_ROOT}/resume/final.html`
- `{MENTEE_ROOT}/escalate-handoff.md`

`.resume-session` 이 없으면:
```
{id} vault를 찾을 수 없습니다.
/resume:init {id} 를 먼저 실행하세요.
```

### 3단계: 상태 표시

다음 형식으로 출력:

```
resume 상태: {id}
vault: {MENTEE_ROOT}
마지막 업데이트: {last_updated}

파이프라인:
  [완료] init      — vault 초기화 완료
  [완료] assess    — L{N}: {assess_level 설명}
  [진행중] interview — 프로젝트 {A}/{B} 완료, 질문 {questions_asked}개, checkpoint {last_checkpoint}
  [대기] format
  [대기] export

산출물:
  이력서 원본     : {있음/없음}
  프로젝트 페이지 : {N}개
  스킬 페이지     : {N}개
  에피소드        : {N}개
  draft.md        : {있음/없음}
  final.html      : {있음/없음}

escalate: {true이면 "예 — escalate-handoff.md 생성됨" / false이면 "아니오"}

다음 명령: /resume:{다음 pipeline_stage} {id}
```

파이프라인 단계 표시 기준:
- `pipeline_stage` 값에 해당하는 단계는 `[진행중]`
- 그 이전 단계는 `[완료]`
- 그 이후 단계는 `[대기]`
- `init`은 vault가 존재하면 항상 `[완료]`
- 순서: `init` → `assess` → `interview` → `star-sbi` → `export`

assess_level 설명:
- L0: 이력서 없음/부족 — 빈템플릿 dig 경로
- L1: 최근 경력 미갱신
- L2: 보강 필요 ({결핍플래그_비율}%)
- L3: 완성형
- (비어있으면): assess 미실행
