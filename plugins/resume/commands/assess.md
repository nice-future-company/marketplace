---
description: "이력서 진단 L0~L3 + 경로 분기. 사용: /resume:assess <id>"
argument-hint: "<id>"
allowed-tools: Bash
---

# resume:assess

## 역할
이력서를 읽어 결핍 플래그를 카운트하고, L0~L3 레벨을 판정합니다.
`.resume-session` 에 `assess_level` + 근거를 기록하고, 멘티에게 진단 결과와 다음 경로를 안내합니다.

---

## 실행 절차

### 1단계: vault 확인

`scripts/resolve-vault-root.sh <id>` 로 MENTEE_ROOT 확인.
비0 exit 시 오류 출력 후 중단.

`.resume-session` 읽기. 파일이 없으면:
```
오류: {id} vault를 찾을 수 없습니다.
먼저 /resume:init {id} 를 실행하세요.
```

### 2단계: 이력서 파일 확인 (결정적 체크)

`{MENTEE_ROOT}/raw/resume-original.md` 존재 여부 확인 (Bash).

**파일 없음** → L0 확정. 3단계 건너뛰고 4단계로.

**파일 있음** → 파일을 읽어 아래 체크 수행.

#### L0 추가 조건 (파일이 있어도)
파일을 읽어 다음 중 하나라도 해당하면 L0:
- 경력 불릿(- 로 시작하는 경력 설명 라인) 3개 미만
- `## 프로젝트` 섹션이 없거나 내용이 비어있음

### 3단계: 결핍 플래그 카운트 (L0가 아닐 때만)

다음 5가지 결핍 플래그를 항목별로 체크한다:

| 플래그 | 판단 기준 |
|--------|-----------|
| Why부재 | 기술 선택/결정 이유 없이 "사용함"/"도입함"만 기술 |
| 정량없음 | 성과/결과가 수치 없이 "개선", "향상", "최적화"로만 기술 |
| 명사나열 | 문장 없이 기술명·역할명 나열만 (예: "React, Node.js, AWS") |
| 빈약 | 해당 항목 설명이 1줄 이하이고 맥락이 없음 |
| 실력진위불명 | 팀 전체 산출물인지 개인 기여인지 불분명 |

각 경력/프로젝트 항목에 대해 플래그를 체크.
`결핍플래그_비율 = 1종 이상 플래그가 있는 항목 수 / 전체 항목 수`

### 4단계: 레벨 판정

```
L0: 파일 없음 OR 경력 불릿 3개 미만 OR 프로젝트 섹션 없음/비어있음
L1: 파일 있고 self_reported_staleness == true (최근 경력 미갱신)
L2: 결핍플래그_비율 >= 30% (Why부재, 정량없음, 명사나열 중 2종 이상이 조건을 충족)
    → L1과 동시 해당 시 L1 우선 (최근 경험 dig 먼저)
L3: 결핍플래그_비율 < 30% AND Why+정량+구조(두괄식/STAR) 충족 항목 다수
```

**임계비율 30%는 기본값**. 실측 후 조정 가능 (멘티가 명시적으로 요청 시).

### 5단계: .resume-session 업데이트

```yaml
assess_level: L{N}
pipeline_stage: interview   # assess 완료, interview 준비
last_updated: YYYY-MM-DD
```

`wiki/projects/` 아래 프로젝트별 페이지를 생성/업데이트한다:
- 파일 없으면 신규 생성, 있으면 섹션 append
- `assess_flags` frontmatter에 해당 플래그 목록 기록
- 필수 frontmatter: `type: project`, `title`, `period`, `role`, `stack`, `assess_flags`, `created`, `updated`
- 필수 섹션: `## 요약`, `## 상세`, `## 결핍 플래그`

L0 시: 빈 프로젝트 템플릿 1개(`wiki/projects/project-1.md`) 생성 — dig에서 채울 구조만.

### 6단계: 진단 결과 출력

**L2 진단 시 코치 언어 사용** (비판 아님, 채용 담당자 관점).

#### L0 출력:
```
진단 결과: L0 — 이력서 없음 또는 내용 부족

이력서 파일이 없거나 경력/프로젝트 항목이 충분하지 않습니다.
괜찮아요. 빈 템플릿을 채우는 방식으로 dig를 진행합니다.

/resume:interview {id} 를 실행하면 프로젝트 경험을 하나씩 채워나가게 됩니다.

다음: /resume:interview {id}
```

#### L1 출력:
```
진단 결과: L1 — 최근 경력 미갱신

최근 6개월 이내 경험이 이력서에 반영되어 있지 않습니다.
dig에서 가장 최근 경험부터 집중적으로 탐색합니다.

다음: /resume:interview {id}
```

#### L2 출력:
```
진단 결과: L2 — 보강 필요

채용 담당자 관점에서 {N}개 항목 ({비율}%)에 더 구체적인 맥락이 있으면 좋겠습니다.

주요 보강 포인트:
- [Why부재 해당 시] "왜 이 기술/방식을 선택했는지" 배경이 있으면 인상이 달라집니다.
- [정량없음 해당 시] 수치가 있으면 더 설득력 있습니다. 어떻게 측정했는지도 포함해서요.
- [명사나열 해당 시] 기술 목록보다 "어떤 문제를 해결하는 데 썼는지"가 더 기억에 남습니다.

dig에서 하나씩 채워봅시다.

다음: /resume:interview {id}
```

#### L3 출력:
```
진단 결과: L3 — 완성형

Why+정량+구조가 잘 갖춰져 있습니다.
dig는 확인/보완 위주로 빠르게 진행되고, export·타겟 최적화에 집중합니다.

다음: /resume:interview {id}
```

> 구체 예시: `examples/sample-vault/wiki/projects/fintech-startup.md` — L2 진단 플래그와 assess_flags 기록 방식 참조.
