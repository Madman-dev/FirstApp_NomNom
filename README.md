# FirstApp_NomNom

## 4/8
- created every label, button, views through code (programmatically)
- no issue with having buttons and views connected
- enabled Button to connect to 2nd VC, overall visuals of the apps (excluding colors)

### 4/9
- added Todo UIView to act as UItextField(will place on later)
- created Animating effect to appear and disappear from current view without delay
- faced issue with button after embedding within TableViewCell. Apparently placing a button within a cell overlays the cell above the button, making it unclickable > fixed issue using delegatePattern by adding the target DIRECTLY TO @OBJC Func (&& by delegating the func to viewController - the button now appeared to be working within the cell)

> after trying to create a checkable / crossing out title label within tableViewCell,
to work like a ToDo app - I have failed to make the functions work.
Code to connecting the targets have gone difficult to straighten out.
Created UITableView anew through storyboard.

### 4/10
- unable to fix previous issue with UITableView
- made adjustments to plan && app UX/UI

### 4/11
- added 'complete', 'delete' features within todo list
- added new button to check previous written/ daily finished tasks - plan to change plans to this feature as I have a specific plan for the app
- fixed issue with having gradientLayer being projected over the todo list as well as the button - considering time frame of the app's launch was VERY important

### 4/12
- spent most of the time searching to learn about custom Transition
* difficult to learn, still don't understand much of it but found lot of resources in creating one

### 4/13
- lots of trials and errors regarding using custom transition inside the app.
** managed to place a transition in, but apparently a view transition is not what's needed for my use
- to place in a button within the transitioning image, I'll have to look into collectionViewCell transition - will have to post online && ask for help
![ezgif com-resize](https://user-images.githubusercontent.com/119504454/231800035-48072093-2804-4fd0-9fc3-3b3d3a13cbae.gif)

