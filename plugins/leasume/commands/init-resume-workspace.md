---
description: "멘티 vault 초기화 + 이력서 입력 + 데이터 처리 고지. 사용: /leasume:init-resume-workspace <id>"
argument-hint: "<id>"
allowed-tools: Bash
---

# leasume:init-resume-workspace

## 역할
멘티 vault를 생성하고, 이력서를 입력받고, 파이프라인을 시작합니다.

---

## 실행 절차

### 1단계: id 확인 및 vault_root 결정

`$ARGUMENTS` 에서 `<id>` 를 추출한다. id가 없으면:
```
오류: id가 필요합니다.
사용법: /leasume:init-resume-workspace <id>
예시: /leasume:init-resume-workspace kim-frontend-2026
```
출력 후 중단.

`scripts/resolve-vault-root.sh <id>` 를 실행해 MENTEE_ROOT를 얻는다.
스크립트가 비0 exit 하면 stderr 메시지를 그대로 출력하고 중단.

### 2단계: vault 디렉토리 생성

다음 구조를 생성한다:
```
{MENTEE_ROOT}/
  raw/
  wiki/
    projects/
    skills/
    episodes/
  resume/
  index.md
  SCHEMA.md          ← templates/SCHEMA.md 복사
  .leasume-session   ← templates/.leasume-session.tmpl 기반, id/vault_root/날짜 치환
```

Bash로 실행 (아래 코드의 `"$MENTEE_ROOT"` 는 1단계에서 얻은 실제 경로로 치환해 실행):
```bash
mkdir -p "$MENTEE_ROOT/raw" "$MENTEE_ROOT/wiki/projects" \
         "$MENTEE_ROOT/wiki/skills" "$MENTEE_ROOT/wiki/episodes" \
         "$MENTEE_ROOT/resume"
```

`index.md` 초기 내용:
```markdown
---
mentee_id: "{id}"
created: {오늘날짜}
---

# {id} — 이력서 작업 vault

| 파일 | 설명 |
|------|------|
| raw/resume-original.md | 원본 이력서 (불변) |
| wiki/projects/ | 프로젝트·경력 페이지 |
| wiki/skills/ | 기술 스택 페이지 |
| wiki/episodes/ | STAR/SBI 에피소드 |
| resume/draft.md | 이력서 초안 (추정 마커 포함) |
| resume/final.html | 최종 HTML 이력서 |
| .leasume-session | 파이프라인 상태 |
| escalate-handoff.md | 심화 세션 인계 파일 (escalate 시 생성) |
```

`.leasume-session` 초기값 (`templates/.leasume-session.tmpl` 참조, 치환):
- `mentee_id`: `{id}`
- `vault_root`: MENTEE_ROOT의 부모 디렉토리 (VAULT_ROOT)
- `pipeline_stage`: `init`
- `last_updated`: 오늘 날짜 (YYYY-MM-DD)

### 3단계: 데이터 처리 고지 (필수)

다음 고지 메시지를 표시한다:

---
**데이터 처리 안내**

- 이 세션에서 입력한 이력서 내용은 **로컬 디렉토리에만 저장**됩니다: `{MENTEE_ROOT}`
- Anthropic의 모델 학습에 사용되지 않습니다 (Claude Code 기본 정책).
- 이 vault는 git 추적 대상에서 제외됩니다 (`.gitignore` 설정).
- 언제든 `{MENTEE_ROOT}` 디렉토리를 삭제하면 모든 데이터가 제거됩니다.

계속하려면 Enter를 누르거나 '확인'을 입력하세요.

---

### 4단계: 이력서 입력

다음 세 가지 방법 중 하나를 선택하도록 안내한다:

```
이력서 입력 방법을 선택하세요:

1) 붙여넣기  — 이력서 텍스트를 지금 바로 붙여넣습니다
2) PDF 경로  — PDF 파일 경로를 입력합니다 (예: ~/Downloads/resume.pdf)
3) 빈 템플릿 — 이력서가 없거나 처음부터 작성합니다 (L0 경로)

선택 (1/2/3):
```

**선택 1 (붙여넣기)**:
- "이력서를 붙여넣은 후 빈 줄에 END를 입력하세요:" 안내
- 입력받은 텍스트를 `{MENTEE_ROOT}/raw/resume-original.md` 에 저장

**선택 2 (PDF 경로)**:
- 경로를 입력받아 Bash로 파일 존재 확인.
- 존재하면: **`skills/parse-resume-pdf/SKILL.md` 규칙을 따라** PDF→구조화 마크다운 추출 후 `{MENTEE_ROOT}/raw/resume-original.md` 저장.
  - 외부 OCR/PDF 파서 설치 요구 금지(Claude가 직접 읽음).
  - 최소 섹션: `## 기본 정보`, `## 경력`, `## 프로젝트`, `## 기술 스택`.
  - **추출 실패 처리**: 스캔본·암호화·텍스트 추출 불가 시 저장하지 말고 "PDF에서 텍스트를 추출할 수 없습니다(스캔본/암호화 가능성). 텍스트로 붙여넣기(선택 1)로 진행하세요." 안내 후 입력 방법 재선택.
- 파일 없으면: "파일을 찾을 수 없습니다. 경로를 확인하세요." 후 재입력 요청.

**선택 3 (빈 템플릿)**:
- 다음 내용으로 `{MENTEE_ROOT}/raw/resume-original.md` 생성:

```markdown
---
type: resume-original
status: empty-template
created: {오늘날짜}
---

# 이력서 초안

## 기본 정보
- 이름:
- 직군:
- 경력:

## 경력
<!-- 회사명, 기간, 역할, 주요 업무를 입력하세요 -->

## 프로젝트
<!-- 프로젝트명, 기간, 역할, 기술 스택, 주요 성과를 입력하세요 -->

## 기술 스택
<!-- 사용 가능한 기술을 나열하세요 -->
```

### 5단계: init 1문항

다음 질문을 한다:

```
한 가지만 물어볼게요.

최근 6개월 이내의 경력/프로젝트가 이력서에 반영되어 있지 않나요?
(예: 이직 준비 중인데 이력서가 1년 전 버전이다, 최근 프로젝트를 아직 못 넣었다 등)

Y / N:
```

- Y → `.leasume-session` 의 `self_reported_staleness: true` 로 업데이트
- N → `self_reported_staleness: false` 유지

### 6단계: 완료 보고

`.leasume-session` 의 `pipeline_stage` 를 `assess` 로 업데이트, `last_updated` 갱신.

다음을 출력:
```
vault 초기화 완료.
위치: {MENTEE_ROOT}

다음: /leasume:assess {id}
```

> 구체 예시: `examples/sample-vault/` — L2 가공 멘티의 전 파이프라인 결과 스냅샷 참조.
