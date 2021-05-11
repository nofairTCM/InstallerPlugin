# Plugin
인스톨러 플러그인입니다, 각 모듈을 받고 관리하는데 사용될 수 있습니다  

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
를 입력하고 새로 생겨난 plugin.rbxmx 파일을 로블록스 스튜디오 플러그인 폴더로 옮깁니다  

다 끝났습니다! 스튜디오를 한번 재시작 하면 플러그인이 정상적으로 깔려 있는것을 확인 할 수 있습니다  

주의 : 직접 빌드한 플러그인을 설치 해 둔 채로 또 플러그인을 toolbox 에서 받지 마세요  
예기치 못한 충돌을 일으킬 수 있습니다  
