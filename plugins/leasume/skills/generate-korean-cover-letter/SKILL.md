---
name: generate-korean-cover-letter
description: "[v1 미배선, 로드맵] 이력서/인터뷰/STAR 자료를 종합해 한국형 자기소개서를 작성합니다. v1 범위 밖 — 자동 호출 차단."
disable-model-invocation: true
---

# Generate Korean Cover Letter

> **v1 미배선 — 로드맵 항목**
> 이 스킬은 v1(현재) 파이프라인에 연결되어 있지 않습니다.
> `disable-model-invocation: true` 로 자동 호출이 차단되어 있습니다.
> 향후 버전에서 `/leasume:export` 또는 별도 command로 배선될 예정입니다.

---

## 입력 (v1 이후 기준)
- 필수: `resume/draft.md`
- 필수: `wiki/episodes/*.md`
- 선택: `data/mentoring/topics/*.md`

## 출력
- 성공 시: `resume/cover-letter-ko.md`

## 필수 섹션
- 지원 동기
- 문제 해결 경험
- 협업/커뮤니케이션
- 성장 계획

## 문체 가이드
- 한국어 문어체를 기본으로 작성한다.
- 과장 표현보다 구체적 근거를 우선한다.

## 범위 제한
- 영어 전용 포맷을 기본으로 사용하지 않는다.
