# Tags

이 문서는 이 프로젝트의 WorkDocs 표준 태그 사전이다.

## tofu-pet
DisplayName: 전자 두부
Aliases: tofu, virtual-pet
Description: 전자 두부 캐릭터와 돌봄, 반응, 상태 표현에 관련된 작업

## mobile-sensor
DisplayName: 모바일 센서
Aliases: accelerometer, motion
Description: 가속도계와 흔들기 등 모바일 센서 입력에 관련된 작업

## pet-rock
DisplayName: 화면 속 돌멩이
Aliases: rock, daily-petting
Description: 매일 쓰다듬을수록 조금씩 윤이 나는 돌멩이와 조용한 상호작용에 관련된 작업

## local-persistence
DisplayName: 로컬 저장
Aliases: preferences, device-storage
Description: 기기 안에 사용자 진행 상태를 저장하고 복원하는 작업

규칙:

- 태그는 작업 루트의 `Meta.md`에서만 사용한다.
- `Meta.md`의 `Tags` 값은 이 문서에 정의된 표준 태그 이름과 정확히 일치해야 한다.
- 이 파일에 작업 목록을 수동으로 적지 않는다.
- 작업 간 연결은 각 작업 루트의 `Meta.md`를 기준으로 조회한다.

새 태그는 아래 형식으로 추가한다.

```md
## tag_name
DisplayName: 표시 이름
Aliases: alias-a, alias-b
Description: 이 태그가 담당하는 작업 영역
```
