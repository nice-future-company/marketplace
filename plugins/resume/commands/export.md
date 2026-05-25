---
description: "이력서 draft.md + final.html 생성. 사용: /resume:export <id> [--html]"
argument-hint: "<id> [--html]"
allowed-tools: Bash
---

# resume:export

## 역할
에피소드와 프로젝트 정보를 조합해 이력서를 생성합니다.
two-pass 방식: `draft.md` (추정 마커 포함) → `final.html` (마커 strip + 경고 배너).

---

## 실행 절차

### 1단계: vault 확인

`scripts/resolve-vault-root.sh <id>` 로 MENTEE_ROOT 확인.

`.resume-session` 읽기. `pipeline_stage` 가 `init`, `assess`, `interview`, `star-sbi` 중 하나이면 export 미실행 상태이므로 중단:
```
아직 star-sbi가 완료되지 않았습니다.
/resume:star-sbi {id} 를 먼저 실행하세요.
```
(`pipeline_stage` 허용 값: `export`. `init`/`assess`/`interview`/`star-sbi`이면 중단.)

`wiki/episodes/` 파일 목록 확인 (Bash). 없으면:
```
에피소드 파일이 없습니다.
/resume:star-sbi {id} 를 먼저 실행하세요.
```

### 2단계: Pass 1 — draft.md 생성

`{MENTEE_ROOT}/wiki/episodes/*.md`, `{MENTEE_ROOT}/wiki/projects/*.md`,
`{MENTEE_ROOT}/raw/resume-original.md` 를 읽어 초안을 작성한다.

**draft.md 규칙:**
- `> 추정:` 마커를 그대로 유지 (strip 하지 않음)
- 미완성 섹션은 `<!-- TODO: {이유} -->` 표기
- 모든 에피소드를 포함
- md가 canonical (html은 파생)

출력 구조:
```markdown
---
type: resume-draft
mentee_id: "{id}"
version: 1
inferred_count: N     # > 추정: 마커 개수
incomplete_count: N   # <!-- TODO: --> 개수
created: {날짜}
updated: {날짜}
---

# 이름 — 직군

## 요약
[2~3문장 직군 요약]

## 경력

### {회사명} | {역할} | {기간}
[STAR/SBI 기반 경력 기술]

## 프로젝트

### {프로젝트명} | {기간}
**역할**: {역할}  
**기술 스택**: {스택}

[에피소드 내용]

> 추정: ...  ← 마커 유지

## 기술 스택
[skills 페이지 기반]

## 교육
[이력서 원본에서]
```

저장: `{MENTEE_ROOT}/resume/draft.md`

### 3단계: Pass 2 — final.html 생성

`--html` 플래그가 있거나 기본 동작으로 생성한다.

**final.html 규칙:**
- `> 추정:` 로 시작하는 라인 전체를 strip
- strip한 항목을 집계해 상단 경고 배너에 표시
- `<!-- TODO: -->` 항목을 별도 미완성 배너로 표시
- ATS 친화 시맨틱 HTML + 인라인 CSS

#### HTML 구조:
```html
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{이름} — 이력서</title>
  <style>
    /* 인라인 CSS — ATS 친화: 단일 컬럼, 시맨틱 태그, 폰트 기본값 */
    body { font-family: Arial, sans-serif; max-width: 800px; margin: 40px auto; padding: 0 20px; color: #333; }
    h1 { font-size: 1.8em; border-bottom: 2px solid #333; padding-bottom: 8px; }
    h2 { font-size: 1.3em; border-bottom: 1px solid #ccc; margin-top: 24px; }
    h3 { font-size: 1.1em; margin-top: 16px; }
    .banner-warning { background: #fff3cd; border: 1px solid #ffc107; padding: 12px; margin-bottom: 20px; border-radius: 4px; }
    .banner-incomplete { background: #f8d7da; border: 1px solid #f5c6cb; padding: 12px; margin-bottom: 20px; border-radius: 4px; }
    ul { padding-left: 20px; }
    li { margin-bottom: 4px; }
    .meta { color: #666; font-size: 0.9em; }
    section { margin-bottom: 24px; }
  </style>
</head>
<body>
```

#### 경고 배너 (추정 마커가 있을 때):
```html
<div class="banner-warning">
  <strong>검토 필요:</strong> {N}개 항목에 확인이 필요한 내용이 있습니다.
  draft.md 에서 <code>&gt; 추정:</code> 마커를 검색해 직접 확인하세요.
</div>
```

#### 미완성 배너 (TODO 항목이 있을 때):
```html
<div class="banner-incomplete">
  <strong>미완성 항목:</strong> {N}개 섹션이 아직 채워지지 않았습니다.
  <ul>
    <li>{TODO 이유 1}</li>
    ...
  </ul>
</div>
```

#### 본문 HTML 구조:
```html
<header>
  <h1>{이름}</h1>
  <p class="meta">{직군} · {연락처}</p>
</header>

<main>
  <section aria-label="요약">
    <h2>요약</h2>
    <p>...</p>
  </section>

  <section aria-label="경력">
    <h2>경력</h2>
    <article>
      <h3>{회사} | {역할} | {기간}</h3>
      <ul>
        <li>...</li>
      </ul>
    </article>
  </section>

  <section aria-label="프로젝트">
    <h2>프로젝트</h2>
    <article>
      <h3>{프로젝트명}</h3>
      <p class="meta">{기간} · {스택}</p>
      <ul>
        <li>...</li>
      </ul>
    </article>
  </section>

  <section aria-label="기술 스택">
    <h2>기술 스택</h2>
    <p>...</p>
  </section>
</main>
</body>
</html>
```

저장: `{MENTEE_ROOT}/resume/final.html`

### 4단계: 완료 처리

`.resume-session`:
- `pipeline_stage: export` (완료 상태 유지)
- `last_updated: YYYY-MM-DD`

출력:
```
export 완료.

생성된 파일:
- {MENTEE_ROOT}/resume/draft.md  (추정 마커 포함, canonical)
- {MENTEE_ROOT}/resume/final.html  (ATS 친화, 배너 포함)

요약:
- 추정 마커 항목: {N}개 → final.html에서 strip, 경고 배너로 집계
- 미완성 항목: {M}개 → final.html에 미완성 배너로 표시
- 에피소드: STAR {A}개, SBI {B}개

draft.md 를 먼저 검토하고 > 추정: 항목을 직접 확인하세요.
추가 보완이 필요하면 /resume:interview {id} 재실행 후 /resume:star-sbi {id}, /resume:export {id} 순으로 다시 실행하세요.
```

> 구체 예시: `examples/sample-vault/resume/draft.md`, `resume/final.html` — 추정 마커 처리·ATS 친화 HTML 구조 참조.
