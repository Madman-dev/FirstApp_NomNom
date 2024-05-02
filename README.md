# FirstApp_NomNom

A simple todo app developed using UIKit.<br/>
The app displays the users' todos as dynamically as users add their todos as well as remove, edit or check as complete.
The completed numbers of todos are also displayed which the users can tap to enter a game.<br/>
The number of todos become the number of obstacles the users need to break within the game.

## Features
<img width="610" alt="Screenshot 2024-05-02 at 17 41 22" src="https://github.com/Madman-dev/FirstApp_NomNom/assets/119504454/fbb43506-daae-4d8f-bbe7-7e800a3cef4a"><img width="150" src="https://github.com/Madman-dev/FirstApp_NomNom/assets/119504454/67f40e1d-d24e-410d-84d7-3fe44e26b556">

1. **Add Todos -** tap 'Nom' to type additional todos.
2. **Remove Todos -** swipe todos left to delete todos.
3. **Complete Todos -** swipe todos right or tap the circle to mark todos complete.
4. **Edit Todos -** tap the todo to edit an existing todo on screen.
5. **Play breakout -** tap the number displaying button to play breakout with the total numbers of todos you've completed.

## Technical Details
- UIKit was used to create the todo app.
- SpriteKit, GamePlayKit and AVFoundation was used to create the breakout game and embed sound within the game.
- As todos are simple data, userdefaults was used to store and preserve data in your device.

## Technical Difficulties
- Not using Storyboard, only programmatic code
- Issue with embedding button within TableViewCell
- Configuring custom transition to type todo