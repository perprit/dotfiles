---
name: llm-api-call
description: 사내 dev 키로 OpenAI, Anthropic API를 직접 호출할 때 쓴다(키 위치, 접근, summon 실행, 비용 확인, Batch API). "API 직접 호출", "OpenAI API", "Anthropic API", "GPT로 돌려", "배치로 돌려", "API 키", /llm-api-call 요청 시 사용한다. claude -p나 서브에이전트 대신 API로 대량 처리할 때도 사용한다.
---

# OpenAI, Anthropic API 직접 호출

## 1. 키 위치

- AWS Secrets Manager `ai/dev/cs-chatbot`(리전 `ap-northeast-2`). cs-chatbot 프로젝트의 dev 키다.
- 출처: justin, Slack C03J46N6JKV 스레드(2026-10-02).
- `OPENAI_API_KEY`: 읽기를 확인했다(2026-10-03).
- `ANTHROPIC_API_KEY`: 스레드 안내로는 있다. 읽기는 확인하지 않았다. 새로 발급한 키라 cs-chatbot의 secrets.yaml에는 매핑되지 않았을 수 있다.
- 키 이름이 다르면 값을 출력하지 말고 키 이름만 확인한다.

## 2. 접근

- 역할: `ai-developers`(SSO). `~/.aws/config`의 프로필도 이것 하나다.
- 이 역할은 기본으로 `ai/dev/*` 접근이 막혀 있다(SCP explicit deny).
- 사용자가 접근을 열어야 읽힌다. 여는 방법은 사용자가 안다. 접근은 시간 제한이 있다.
- `AccessDeniedException ... explicit deny in a service control policy`가 나오면: 접근이 닫힌 상태다. 사용자에게 다시 열어 달라고 한다. 다른 우회를 시도하지 않는다.

## 3. 실행 절차

1. summon 파일을 만든다. 시크릿 경로만 적는다.
   ```yaml
   # llm-secrets.yaml
   OPENAI_API_KEY: !var ai/dev/cs-chatbot#OPENAI_API_KEY
   ANTHROPIC_API_KEY: !var ai/dev/cs-chatbot#ANTHROPIC_API_KEY
   ```
2. 명령을 summon으로 감싸 실행한다. `assume`은 zsh 별칭이라 `zsh -ic`로 부른다.
   ```sh
   zsh -ic 'assume ai-developers --exec -- summon -p summon-aws-secrets -f llm-secrets.yaml <명령>'
   ```
3. 키 확인은 길이만 출력한다.
   ```sh
   zsh -ic 'assume ai-developers --exec -- summon -p summon-aws-secrets -f llm-secrets.yaml sh -c "echo len=\${#OPENAI_API_KEY}"'
   ```
4. 모델 id는 models API로 확인한다(OpenAI: `client.models.list()`).

## 4. 키 취급 규칙

- 키 값을 파일, 로그, 결과, 대화에 남기지 않는다.
- 키를 macOS 키체인에 저장하지 않는다(2026-10-04 사용자 결정).
- 코드는 환경변수(`OPENAI_API_KEY`, `ANTHROPIC_API_KEY`)에서만 키를 읽는다.

## 5. 비용 확인

1. 공식 가격표에서 단가를 확인한다.
   - OpenAI: https://developers.openai.com/api/docs/pricing
2. 실제 입력으로 토큰 수를 잰다(OpenAI: tiktoken `o200k_base`).
3. 본 실행 전에 소량(예: 50건)을 일반 API로 돌린다. 응답의 `usage`로 실측 비용을 낸다.
4. 실측 비용을 전체 건수로 늘려 사용자에게 보고하고 승인을 받는다.

## 6. 비용 줄이기

- **프롬프트 캐시:** 공통 지시를 앞에, 요청마다 바뀌는 내용을 맨 뒤에 둔다. 앞부분은 글자 하나까지 같게 둔다.
  - OpenAI: 자동 캐시(같은 앞부분 1,024토큰 이상). `prompt_cache_key`를 같은 값으로 준다. 캐시된 입력은 입력 단가의 1/10이다.
  - 첫 요청 1건을 먼저 보내 캐시를 만든 뒤 나머지를 병렬로 보낸다.
- **Batch API:** 50% 할인, 24시간 안에 끝난다. Batch에서도 캐시가 적용된다(실측 적중률 99%).
- **출력:** reasoning(생각) 토큰이 비용 대부분이 된다. 정확도가 덜 중요하면 reasoning effort를 낮춘다.
- **출력 형식:** JSON 스키마(structured output)로 고정한다. 형식 오류와 재시도가 줄어든다.

## 7. OpenAI Batch API

1. 요청 JSONL을 만든다. 한 줄에 요청 하나다.
   ```json
   {"custom_id": "<id>", "method": "POST", "url": "/v1/responses", "body": {"model": "...", "input": [...], "reasoning": {"effort": "..."}, "prompt_cache_key": "...", "text": {"format": {...}}}}
   ```
2. 파일은 200MB 미만으로 나눈다(공통 앞부분이 요청마다 반복되어 파일이 커진다).
3. 파일을 올리고(`files.create(purpose="batch")`) 배치를 만든다(`batches.create(endpoint="/v1/responses", completion_window="24h")`).
4. 배치 id와 파일 id를 로컬 상태 파일에 저장한다. 새 세션에서도 수거할 수 있다.
5. 상태를 확인한다: `GET /v1/batches/{id}`(`batches.retrieve`).
   - 진행 중에는 `request_counts`만 바뀐다. `usage`는 완료 때 채워진다.
   - 배치 하나가 `completed`가 되어야 결과를 받는다.
6. 결과를 받는다: `files.content(output_file_id)`. 한 줄에 `custom_id`와 `response.body`가 있다.
7. 실패한 요청은 모아서 일반 API로 다시 보낸다.

- 키는 제출과 수거 때만 필요하다. 제출한 뒤에는 접근을 닫아도 된다.
- 마지막 몇 건이 오래 남을 수 있다. 끝난 배치부터 수거한다.

## 8. 참고 구현

- `~/dev/onboarding/cs-sop/chat-logs/scripts/classify_api.py`: 일반 API, 병렬 호출, 캐시 데우기, 재시도
- `~/dev/onboarding/cs-sop/chat-logs/scripts/batch_api.py`: Batch 준비, 제출, 상태, 수거

## 9. 데이터

- 고객 데이터를 외부 API로 보내기 전에 사용자 허용을 받는다.
- 보내기 전에 개인정보를 가린다(주민번호, 휴대폰, 차량번호, 이메일, 긴 숫자). 이름은 규칙으로 가려지지 않는다.
