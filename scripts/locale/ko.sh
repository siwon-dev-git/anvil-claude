#!/usr/bin/env bash
# shellcheck disable=SC2034
# Anvil locale — 한국어 (sourced by _load.sh, variables used externally)

# Monitor
L_MONITOR_TITLE="anvil 모니터"
L_TRACE="추적"
L_GATE="게이트"
L_HERITAGE="유산"
L_GUARDS="가드"
L_CONSTITUTION="헌법"
L_STACK="스택"
L_GIT="Git"

L_TRACE_ACTIVE="활성"
L_TRACE_INACTIVE="비활성"
L_TRACE_PAST="과거 추적"
L_GATE_NONE="--"
L_GUARDS_RULES="활성 규칙"
L_GUARDS_NONE="--"
L_CONST_INTACT="무결"
L_CONST_MODIFIED="변경됨 (체크섬 불일치)"
L_CONST_PRESENT="존재 (체크섬 없음)"
L_CONST_MISSING="없음"
L_STACK_NONE="프로필 없음"
L_GIT_NONE="git 저장소 아님"
L_GIT_UNCOMMITTED="미커밋"
L_HELP_HINT="bash monitor.sh --help 로 사용법 확인"

# Init
L_INIT_TITLE="Anvil 초기화"
L_INIT_EXISTS=".anvil/ 이미 존재 — 건너뜀"
L_INIT_DETECTING="스택 감지 중..."
L_INIT_COMPLETE="Anvil 초기화 완료"
L_INIT_FILES="파일 생성됨"
L_INIT_NEXT="다음 단계:"
L_INIT_NEXT_1=".anvil/constitution.md 편집 — 최종 목표와 제약 조건 설정"
L_INIT_NEXT_2="/anvil-claude:health 실행 — 게이트 체인 동작 확인"
L_INIT_NEXT_3="/anvil-claude:sprint <퀘스트> 로 빌드 시작"

# Session context
L_SESSION_FAILURES="활성 실패 패턴"
L_SESSION_DECISIONS="활성 결정"
L_SESSION_GUARDS="활성 가드"
L_SESSION_TRACE="활성 추적"
L_SESSION_GATE="현재 게이트"
L_SESSION_LANG="선호 언어: 한국어"
