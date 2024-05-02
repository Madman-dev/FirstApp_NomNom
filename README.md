# NomNom
**🙋🏻‍♂️ You can also find the readme in [ENG](./Translation/English%20Readme.md)**

<img width="1232" alt="Screenshot 2024-05-03 at 00 28 39" src="https://github.com/Madman-dev/FirstApp_NomNom/assets/119504454/4cefbbce-a62b-4cd8-b1c6-dc1af135377d"><br/>

## Features
<img width="610" alt="Screenshot 2024-05-02 at 17 41 22" src="https://github.com/Madman-dev/FirstApp_NomNom/assets/119504454/fbb43506-daae-4d8f-bbe7-7e800a3cef4a"><img width="150" src="https://github.com/Madman-dev/FirstApp_NomNom/assets/119504454/67f40e1d-d24e-410d-84d7-3fe44e26b556">

1. **투두 작성 -** NOM 버튼을 탭하면 투두를 추가할 수 있어요.
2. **투두 삭제 -** 투두를 왼쪽으로 스와이프하면 삭제가 가능합니다.
3. **투두 완료 -** 투두를 오른쪽으로 스와이프하거나 투두 옆의 원을 탭하면 완료할 수 있어요.
4. **투두 수정 -** 리스트에서 투두를 탭하면 수정이 가능해요.
5. **Play breakout -** 완료한 투두 갯수가 보이는 버튼을 탭하면 벽돌깨기 게임을 할 수 있어요.

## Technical Details
- UIKit를 사용하여 만들었어요.
- 게임 및 게임 요소 (소리, 파티클, 공 등)을 위해 SpriteKit, GamePlayKit and AVFoundation을 사용 했었어요.
- 투두를 간단한 데이터로 보았기에 userdefault를 활용하여 데이터를 저장, 유지했어요.

## Technical Difficulties
- 스토리보드가 아닌 오로지 코드로 개발
- Tableviewcell내 버튼을 적용하는 과정
- 커스텀 애니메이션을 적용하는 과정
- SpriteKit에 대한 낮은 이해도로 인해 구현 및 프레임워크로 적용하는 과정