
[![release](https://github.com/nofairTCM/InstallerPlugin/actions/workflows/publish.yml/badge.svg)](https://github.com/nofairTCM/InstallerPlugin/actions/workflows/publish.yml)

# 목차

<!-- TOC -->autoauto- [Plugin](#plugin)auto    - [설명](#설명)auto    - [설치 방법](#설치-방법)auto        - [툴박스에서 받기](#툴박스에서-받기)auto        - [github workflow 에 의해 빌드된 파일 받기](#github-workflow-에-의해-빌드된-파일-받기)auto        - [빌드하기](#빌드하기)auto- [저장소 설명](#저장소-설명)auto    - [워크플로우 설명](#워크플로우-설명)auto    - [브런치 설명](#브런치-설명)autoauto<!-- /TOC -->

# Plugin

## 설명

인스톨러 플러그인입니다, 각 모듈을 받고 관리하는데 사용될 수 있습니다  
**주의사항 : 아래 이외의 방법으로 플러그인을 얻는것은 위험을 초례합니다, 이 방법들 이외의 방법으로 플러그인을 얻고 실행함으로써 발생한 피해는 모두 본인의 책임입니다**

CLI 버전은 pip 나 npm 처럼 커맨드로만 조작이 가능합니다
GUI 버전의 경우 인터패이스를 통해 사용이 가능하며 cli 도 포함하고 있습니다 (풀 빌드)

## 설치 방법

### 툴박스에서 받기

깃허브 워크플로우에 의해서 관리되는 로블록스 플러그인 에셋을 [툴박스](https://www.roblox.com/library/6801472559/nofairTCM-Installer) 에서 받을 수 있습니다  
매 푸시마자 개속해서 자동으로 github workflow 에 의해 관리됩니다, workflow 구조를 보고 싶으시다면 .github\workflows\publish.yml 으로 이동해주세요  


### github workflow 에 의해 빌드된 파일 받기

코드에서 바로 빌드된 플러그인을 얻으려면 [릴리즈 탭](https://github.com/nofairTCM/InstallerPlugin/releases) 으로부터 빌드된 파일을 다운로드 할 수 있습니다  
매 푸시마다 개속해서 자동으로 github workflow 에 의해 관리됩니다, workflow 구조를 보고 싶으시다면 .github\workflows\publish.yml 으로 이동해주세요  

파일을 받고 난 뒤에는 다운로드한 파일을 스튜디오 플러그인 폴더로 옮깁니다 (스튜디오/플러그인 탭/플러그인 폴더)  

다 끝났습니다! 스튜디오를 한번 재시작 하면 플러그인이 정상적으로 깔려 있는것을 확인 할 수 있습니다  

### 빌드하기

필요에 따라서 소스코드에서 플러그인을 직접 빌드해야 할 수도 있습니다  

일단 빌드하기 위해서 이 저장소를 복사해와야 합니다. win64 기준으로 cmd 를 적합한 위치에서 연 후  
> git clone --recursive https://github.com/nofairTCM/InstallerPlugin.git  
다음과 같이 입력해서 이 저장소를 복사해오세요  

그 후 복사된 폴더로 이동합니다  
> cd InstallerPlugin  
이제 cmd 창을 닫지 말고 아래 단계로 내려가세요  

일단 rojo 가 없는 경우 [rojo](https://github.com/rojo-rbx/rojo/releases) 를 받아서 지금 폴더로 옮깁니다 (압축을 푼 후)  
이제 rojo.exe 가 폴더 안에 있어야 합니다  

그런 다름 cmd 라인에서 (주의 : 기기 성능에 따라서 0.2초 에서 최대 20초 이상의 시간이 걸립니다)  
> rojo build build.project.json --output plugin.rbxmx  
를 입력하고 새로 생겨난 plugin.rbxmx 파일을 로블록스 스튜디오 플러그인 폴더로 옮깁니다 (스튜디오/플러그인 탭/플러그인 폴더)  

다 끝났습니다! 스튜디오를 한번 재시작 하면 플러그인이 정상적으로 깔려 있는것을 확인 할 수 있습니다  

주의 : 직접 빌드한 플러그인을 설치 해 둔 채로 또 플러그인을 toolbox 에서 받지 마세요  
예기치 못한 충돌을 일으킬 수 있습니다  

# 저장소 설명

## 워크플로우 설명

일단 setup 을 거쳐서 버전 정보 (지금 시간을 토대로) 만듭니다  
그리고 build 에서 DATA 저장소의 json 을 한번 다시 쓰기 해주고 rojo 로 로블록스에 업데이트 해준 다름 또 다시 rojo 로 빌드해서 아웃풋을 하나 만들고 이타펙트로 넘깁니다  
그리고 이제 릴리즈 부분에서 위에서 만든 아웃풋을 ghr 로 깃허브 배포해 준 다음 종료합니다  

이렇게 해서 깃허브 배포 / 로블 배포 / db 업데이트 한번에 하나로 다합니다  
당연 이렇게 할 수 밖에 없는게 개발에 모든 시간을 쏟아야 하지 배포 방법에 시간을 쏟을 수는 없어서  
봇이 알아서 다 하도록 자동화를 넘겨버렸습니다  
더 많은 정보가 필요하면 그냥 이슈 여세요  

## 브런치 설명

dev 브런치 : 실제 개발이 일어나는 브런치입니다, 안정화된 버전이 나올 때 마다 master 브런치로 병합됩니다, 주요 개발은 여기에서 이루워집니다  
master 브런치 : 개발로 인해 만들어진 최종 프로덕트를 릴리즈 하는 브런치입니다  
hothix 브런치 : 필요에 따라 생성되며 사라지는 브런치입니다, 갑작스러운 오류 사항에 대비하기 위해서 master 브런치에서 분기하여 편집 후 master 브런치로 다시 병합됩니다  
feature 브런치 : 새로운 기능들을 만드는 브런치입니다, dev 브런치와는 다른점은 완전히 새로운것을 만들고 테스팅 하는 약간 베타 릴리즈같은 계념의 브런치입니다, dev 보다 훨씬 불안정적이며 이 브런치에서 빌드를 하게되면 master 로 최종 릴리즈 한것과는 다르게 버그가 있을 수 있는 기능까지 포함하여 불안정적일 수 있습니다, 사용에는 적합하지 않을 수 있습니다, 필요에 따라 삭제되거나 다시 생길 수 있는 브런치입니다  
