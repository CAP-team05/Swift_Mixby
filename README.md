# Mixby
Mixby로 자신의 퍼스널라이징 바텐더를 만들어보세요!

![image](https://github.com/user-attachments/assets/747107a7-f835-4cd7-a6db-80dd297e0a8a)

## Introduction
이 repository는 mixby의 **프론트엔드**를 다룹니다.  
> [Swift Mixby](https://github.com/CAP-team05/Mixby)에서 백앤드 코드를 참고하세요!  
> 해당 백엔드 코드는 자체 서버에서 돌아가고 있습니다.  
> 따라서 swift mixby repository에서는 localhost가 아닌 다른 api address를 사용하고 있습니다.
> 자체 localhost에서 테스트를 돌리고 싶다면 url을 수정해서 돌려보면 됩니다.

## Environment
Swift를 이용한 native 개발이므로 mac os에서 xcode로 실행해야 합니다.  
XCode 16.1 version, mac os Sequoia 15.1.1 에서 개발했습니다.

## How to test
1. 이 repository를 clone 해주세요.
```bash
git clone https://github.com/CAP-team05/Swift_Mixby
```
2. clone 받은 폴더로 이동합니다.
```bash
cd Swift_Mixby
```
3. Xcode로 해당 프로젝트를 실행해주세요.
4. bundle identifier을 본인 계정으로 설정해주세요.  
<img src="https://github.com/user-attachments/assets/658db0b6-0a5e-4a37-9342-a5e5ae32d525" width="500" >

흰색 부분에 본인의 team과 bundle identifier을 입력해주세요.


## Directory Structure
<img width="243" alt="image" src="https://github.com/user-attachments/assets/e9de68fb-d177-4e09-ab96-07a6c2d372ce" />

|폴더(파일)명|기능|
|----|---|
|CustomTabBar|탭 전환용 하단바|
|*.otf|앱 폰트|
|----|---|
|API Handler|서버와의 API 통신, json 파싱|
|Bartender|바텐더 이미지, 대사|
|Cards|각 탭의 ScrollView, VGrid에 들어갈 요소|
|SoundFX|효과음 소스 및 재생|
|ChatBubble|메인 추천 탭의 말풍선 관리|
|Design|배경화면, 블러, 기본 색상 관리|
|DTO|데이터 테이블 구조|
|Handler|데이터 테이블 생성 및 관리|
|Tabs|메인 TabView 에서 전활할 탭 요소|
|User Input|사용자 입력을 받는 모든 요소 관리|
|Views|각 요소 클릭시 이동할 NavigationView 관리|

