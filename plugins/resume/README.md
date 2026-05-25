# resume

개발자 이력서 멘토링 Claude Code 플러그인 (v0.3.0).

5why 드릴다운 + 실력 진위 확인 + STAR/SBI 에피소드 구조화를 한 번에.
멘티별 개인 vault에 영속 저장. 완전 로컬 — PII git 추적 제외.

**무료 플러그인** = 방법론 전체 포함. 데이터팩 없이 완결됩니다.

---

## 설치

```bash
claude --plugin-dir /path/to/nice-future-company/marketplace/plugins/resume
```

---

## 7가지 명령

| 명령 | 역할 |
|------|------|
| `/resume:init <id>` | vault 생성 + 이력서 입력 + 데이터 처리 고지 |
| `/resume:assess <id>` | 이력서 진단 (L0~L3) + 경로 분기 |
| `/resume:interview <id>` | 인터뷰 + 5why 드릴다운 (핵심) |
| `/resume:star-sbi <id>` | STAR/SBI 에피소드 구조화 |
| `/resume:export <id> [--html]` | 이력서 draft.md + final.html 생성 |
| `/resume:status <id>` | 진행 상황 확인 |
| `/resume:help` | 사용법 안내 |

`<id>` = 멘티 식별자. 예: `kim-frontend-2026`  
허용 문자: `a-z A-Z 0-9 _ -` (1~64자)

---

## 레벨별 추천 흐름

### L0 — 이력서 없음 또는 내용 부족
```
/resume:init <id>
/resume:assess <id>
/resume:interview <id>   ← 빈 템플릿에서 경험 채우기
/resume:star-sbi <id>
/resume:export <id>
```

### L1 — 최근 경력 미갱신
```
init → assess → interview (최근 경험 우선) → star-sbi → export
```

### L2 — 보강 필요 (가장 많은 케이스)
```
init → assess → interview → star-sbi → export
```
Why부재·정량없음·명사나열 항목을 drill-down으로 보강합니다.

### L3 — 완성형
```
init → assess → interview (확인 위주) → star-sbi → export
```

---

## pipeline_stage 값

| stage | 의미 |
|-------|------|
| `init` | init 완료 |
| `assess` | assess 진행 준비 |
| `interview` | interview 진행 준비 |
| `star-sbi` | star-sbi 진행 준비 |
| `export` | export 완료 |

---

## vault 구조

```
~/.resume-vaults/<id>/         ← 기본 위치 (PII, 로컬 전용)
  raw/
    resume-original.md          ← 원본 이력서 (불변)
  wiki/
    projects/*.md               ← 경력/프로젝트 페이지
    skills/*.md                 ← 기술 스택 페이지
    episodes/*.md               ← STAR/SBI 에피소드
  resume/
    draft.md                    ← 이력서 초안 (추정 마커 포함)
    final.html                  ← 최종 HTML (ATS 친화)
  index.md
  SCHEMA.md
  .resume-session              ← 파이프라인 상태
  escalate-handoff.md           ← escalate 시 생성 (없을 수 있음)
```

vault 위치 변경:
```bash
# 환경변수
export RESUME_VAULT_ROOT=/your/path

# 전역 설정 파일
echo '{"vault_root": "/your/path"}' > ~/.resume-config.json
```

---

## 데이터 처리 안내

- 이력서 데이터는 **로컬 vault에만 저장**됩니다.
- Anthropic 모델 학습에 사용되지 않습니다 (Claude Code 기본 정책).
- `~/.resume-vaults/<id>/` 삭제 시 모든 데이터 제거.
- `.resume-session`, `.resume-config.json`, `mentee-vault/` 는 `.gitignore` 로 git 추적 제외.

---

## Obsidian 연동 (선택)

vault 폴더(`~/.resume-vaults/<id>/`)를 Obsidian에서 열면 wiki 링크와 그래프 뷰를 활용할 수 있습니다.
필수가 아닙니다. 순수 마크다운 폴더로 완결됩니다.

---

## 유료 데이터팩 연결 지점 (미출시)

`data/mentoring/topics/` 는 선택적 로드 훅으로 연결 지점만 예약되어 있습니다.
데이터팩 미출시(topics/ 디렉토리는 데이터팩 설치 시 생성). 데이터팩이 없으면 방법론 fallback으로 동작합니다.

데이터팩 미출시. `data/mentoring/topics/` 디렉토리는 데이터팩 설치 시 생성됩니다.

---

## 주의 사항

- **동시 실행 비지원**: 동일 `<id>` 를 여러 터미널에서 동시에 실행하지 마세요. 파일 락이 없어 세션 데이터가 손상될 수 있습니다.
- **`RESUME_VAULT_ROOT` 일관 유지**: 세션 간 환경변수가 바뀌면 vault를 찾지 못합니다.

---

## 예시

`examples/sample-vault/` — 가공(fictional) L2 멘티 박재원의 전 파이프라인 결과 스냅샷.

```
examples/
├── README.md                          ← 예시 가이드 (가공 데이터 경고 포함)
└── sample-vault/
    ├── raw/resume-original.md         ← 입력: 수치만 나열된 약한 이력서 (before)
    ├── wiki/
    │   ├── projects/fintech-startup.md ← assess L2 플래그 + 인터뷰 checkpoint 기록
    │   ├── skills/redis.md            ← 기술 레벨: 최적화경험
    │   ├── skills/jwt.md              ← 기술 레벨: 해본것, Why부재 해소 기록
    │   └── episodes/redis-cache.md    ← STAR 에피소드 + 면접 답변 포인트 + 숙제
    ├── resume/
    │   ├── draft.md                   ← > 추정: 마커 유지 (canonical)
    │   └── final.html                 ← 마커 strip + 경고 배너 (ATS 친화)
    └── .resume-session               ← pipeline_stage: export
```

**Before → After 요점 (redis-cache 에피소드)**

| | Before (raw 이력서) | After (에피소드) |
|---|---|---|
| Redis 항목 | "Redis 캐시 적용으로 상품조회 API 응답 20초→0.8초 개선" | Why: PM 이슈 → Look-aside 선택 근거 → TTL 5분·eviction 전략 → 측정 조건 불명확 `> 추정:` 마커 부착 |

> 실제 PII 아님. 방법론 시연용 가공 데이터.

---

## 검증

```bash
# resolve-vault-root.sh 테스트
./scripts/resolve-vault-root.sh valid-id-123           # → MENTEE_ROOT 출력
./scripts/resolve-vault-root.sh "../bad"               # → ERROR: 유효하지 않은 id, exit 1
RESUME_VAULT_ROOT=../../etc ./scripts/resolve-vault-root.sh ok  # → ERROR: 절대경로 아님, exit 1

# vault 구조 self-test (_fixture 대상)
./scripts/validate.sh
```

---

## 프로젝트 구조

```
resume/
├── .claude-plugin/
│   └── plugin.json                  ← 플러그인 매니페스트 (v0.3.0)
├── commands/                        ← 7개 명령 (메인 진입점)
│   ├── init.md
│   ├── assess.md
│   ├── interview.md
│   ├── star-sbi.md
│   ├── export.md
│   ├── status.md
│   └── help.md
├── skills/                          ← 공유 지시블록 (commands가 텍스트 참조)
│   ├── parse-resume-pdf/            ← PDF 파싱 규칙 (init가 참조)
│   └── generate-korean-cover-letter/ ← [v1 미배선, 로드맵] disable-model-invocation: true
├── scripts/
│   ├── resolve-vault-root.sh        ← 경로 해소 단일 진입점
│   └── validate.sh                  ← vault 구조 검증 + _fixture self-test
├── templates/
│   ├── SCHEMA.md                    ← vault 스키마 (init가 복사)
│   └── .resume-session.tmpl        ← 세션 파일 템플릿
├── tests/
│   └── _fixture/                    ← validate.sh self-test 대상
├── data/
│   └── mentoring/
│       ├── index.md
│       └── pii-masking-policy.md    ← topics/ 는 데이터팩 설치 시 생성
└── README.md
```

---

## 변경 이력

### v0.3.0 (2026-05-25)
- skills-only → commands 전환 (멘티 id 인자 기반)
- 7개 명령: init, assess, interview, star-sbi, export, status, help
- 기존 스킬명 재사용 (행동기반 신규명 폐기): start→init, dig→interview, frame→star-sbi
- 멘티 vault 구조 (william-vault 경량 fork)
- scripts/resolve-vault-root.sh — 경로 해소 단일 진입점 (절대경로·.. 검증 포함)
- templates/SCHEMA.md, .resume-session.tmpl
- pipeline_stage enum: init|assess|interview|star-sbi|export
- L0~L3 진단 + 52세션 질문 프레임 인라인 (interview)
- STAR/SBI two-pass export (추정 마커 strip)
- scripts/validate.sh + tests/_fixture self-test
- 중복 스킬 제거: init, interview, star-sbi (command로 대체)
- generate-korean-cover-letter: v1 미배선 표기 + disable-model-invocation: true

### v0.2.0
- skills-only 5단계 파이프라인 (init/parse/interview/star-sbi/cover-letter)
