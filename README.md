
[![release](https://github.com/nofairTCM/InstallerPlugin/actions/workflows/publish.yml/badge.svg)](https://github.com/nofairTCM/InstallerPlugin/actions/workflows/publish.yml)

---

# Plugin

인스톨러 플러그인입니다, 각 모듈을 받고 관리하는데 사용될 수 있습니다  
**주의사항 : 아래 이외의 방법으로 플러그인을 얻는것은 위험을 초례합니다, 이 방법들 이외의 방법으로 플러그인을 얻고 실행함으로써 발생한 피해는 모두 본인의 책임입니다**

## 툴박스에서 받기

깃허브 워크플로우에 의해서 관리되는 로블록스 플러그인 에셋을 [툴박스](https://www.roblox.com/library/6801472559/nofairTCM-Installer) 에서 받을 수 있습니다  
매 푸시마자 개속해서 자동으로 github workflow 에 의해 관리됩니다, workflow 구조를 보고 싶으시다면 .github\workflows\publish.yml 으로 이동해주세요  


## github workflow 에 의해 빌드된 파일 받기

코드에서 바로 빌드된 플러그인을 얻으려면 [릴리즈 탭](https://github.com/nofairTCM/InstallerPlugin/releases) 으로부터 빌드된 파일을 다운로드 할 수 있습니다  
매 푸시마다 개속해서 자동으로 github workflow 에 의해 관리됩니다, workflow 구조를 보고 싶으시다면 .github\workflows\publish.yml 으로 이동해주세요  

파일을 받고 난 뒤에는 다운로드한 파일을 스튜디오 플러그인 폴더로 옮깁니다 (스튜디오/플러그인 탭/플러그인 폴더)  

다 끝났습니다! 스튜디오를 한번 재시작 하면 플러그인이 정상적으로 깔려 있는것을 확인 할 수 있습니다  

## 빌드하기

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
