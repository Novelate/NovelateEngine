# Novelate - Visual Novel Engine

![Novelate](https://i.imgur.com/aPEknjn.png "Novelate")

Website: [https://novelate.com/](https://novelate.com/) (Coming Soon)

Novelate is an open-source visual novel framework and engine, written in the D programming language using bindings to SFML (DSFML.) and can be used freely for personal and commercial projects.

*The project began all the way back in 2013 but was quickly abandonded afterwards due to personal reasons back then. It was under a different name and was never published.*

*Novelate is basically a complete remake of the engine back then and instead of using SDL it uses SFML.*

The bindings to SFML are through DSFMLusing version 2.1.1 (Apr. 19th 2016) in case the original project stagnates entirely or goes through breaking changes. That is also the latest release for the binding other than the master itself which is not stable.

***The engine itself is not currently stable and still in early development, however it has some of the basic functionality done. This also means not all configurations etc. are supported yet.***

When creating stories it uses a specialized file format that allows for flexibility when creating your visual novel.

*Novelate compiles natively through D which comes with great speed and support across multiple-platforms.*

---

### Preview

![Novelate Preview](https://i.imgur.com/YyoIWkp.png "Novelate Preview")

---

### Current Features

* Proper unicode support - Ex. Japanese, Chinese etc.
* Events for extra programming functionality
* UI Components (Labels, Timed Text, Images, Animations ...) Events, Customization, Effects (Fading ...) etc.
* A lot of game configurations and customization
* Flexible and dynamic *"game scripting"* for creative story creation
* Native compilation
* Basic Visual Novel Features (Characters, Dialogues, Options etc.)
* And more ...

---

## Novelate Files / File Format

The novelate file format is rather simple and builds on a simple syntax.

For a full game example see the **examples** folder.

Encountering a block like **\<SECTION\>** or **\<SECTION:TYPE\>** means content following it is a section to parse.

All sections must be given a type which tells the parser how to parse the section's content as some sections are parsed differently.

The only section that can be specified without a type is the **__Config__** section.

Sections:

**SECTION** can be replaced by a custom named that is used when retrieving the specified sections and their data.

Ex. **\<SECTION:Media\>** can become **\<MenuBackground:Media\>**

When the parser encounters a **//** then the rest of the line is deemed a comment and is ignored.

```
<__Config__>
<SECTION:Media>
<SECTION:Music>
<SECTION:Character>
<SECTION:Scene>
```

### \<\_\_Config\_\_\>

The config section only allows for INI like entries such as:

**Key=Value**

Below are all the available configs. Not all configurations are required.

The values given are examples.

Some configurations has **800**, **1024** and **1280** in their key name which indicates relative configurations to the 3 resolutions currently supported.

```
DataFolder=data
SaveFolder=data/saves

GameTitle=Novelate
GameSlogan=Visual Novel Engine
GameDescription=The description of the game

GameAbout=Line1 for about
GameAbout=https://novelate.com/
GameAbout=Line3 for about

// TEXT|COLOR|FONT
// COLOR = R,G,B or R,G,B,A
MenuItem_Play=Play|255,255,255|msgothic
MenuItem_Load=Load|255,255,255|msgothic
MenuItem_Save=Save|255,255,255|msgothic
MenuItem_About=About|255,255,255|msgothic
MenuItem_Characters=Characters|255,255,255|msgothic
MenuItem_Exit=Exit|255,255,255|msgothic

//X,Y
// C = Center Relative
// T = Top Relative (Y only)
// B = Bottom Relative (Y only)
MenuBoxPosition_800=C,C
MenuBoxPosition_1024=C,C
MenuBoxPosition_1280=C,C

// TEXT|X,Y|COLOR|FONT
MenuTitleText=Title|100,100|255,255,255|msgothic
MenuTitleSlogan=Slogan Text|100,100|255,255,255|msgothic

// Since images here are animations we can set multiple images that will show as if they were animations.
// IMAGE|FRAME_SPEED
MenuLogoImage=Logo1|24
MenuLogoImage=Logo2|24
MenuLogoImage=Logo3|24
MenuLogoImage=Logo2|24
// X,Y
MenuLogoImageLocation_800=48,48
MenuLogoImageLocation_1024=48,48
MenuLogoImageLocation_1280=48,48

MenuMusic=MenuMusic

// Same as with MenuLogoImage
MenuBackground=MenuBackground1|100
MenuBackground=MenuBackground2|100
MenuBackground=MenuBackground3|100
MenuBackground=MenuBackground2|100

DefaultFont=msgothic
DefaultFontSize=18
DefaultDialogueColor=255,255,255
DefaultDialogueBackground=0,0,0,140
DefaultDialogueBorder=0,0,0,190
// Same as with MenuLogoImage and MenuBackground
DefaultDialogueBackgroundImage=DialogueBackground|100
DefaultDialoguePadding=8
DefaultDialogueMargin=8
DefaultDialogueHeight_800=200
DefaultDialogueHeight_1024=300
DefaultDialogueHeight_1280=400
DefaultDialogueNameFontSize=24
DefaultDialogueTextFontSize=20
DefaultDialogueNameFont=msgothic
DefaultDialogueTextFont=msgothic

StartScene=Scene1
```

### \<SECTION:Media\> and \<SECTION:Music\>

Media and Music are similar in that they only take one value as their section content which is the path to a file.

Media is for image files (ex. **.png**) and Music is for music files (ex. **.ogg**)

Example:

```
<GameMusic:Music>
data/music/game.ogg

<Restaurant_A:Media>
data/backgrounds/Restaurant_A.png
```

For media files you don't need to specify the relative paths for the supported resolutions as the engine handles that automatic.

Ex. **data/backgrounds/Restaurant_A.png**

will be automatically mapped to the following (if they exist):

**data/backgrounds/Restaurant_A_800.png**

**data/backgrounds/Restaurant_A_1024.png**

**data/backgrounds/Restaurant_A_1280.png**

### \<SECTION:Character\>

A character section will create a character for the game.

The name of the section is the name of the character however if using foreign names with unicode ex. Japanese then it's not always easy to refer to the character through code so you can add an alias name to the character as well. This makes it easier to retrieve a character without having to write special characters etc.

To handle graphics for a character you simply just specify a name for a given set of images.

A character can have multiple sets attached to them.

Any names that doesn't correspond with a configuration name is acceptable.

All values for a character section are similar to that of a config section as they're all **Key=Value** entries.

Configurations:

```
Alias=AliasName
NameColor=DialogueColor
About=Description
AboutImage=Image displayed in about.
```

Example:

```
<Aiko:Character>
Alias=Aiko
NameColor=255,0,0
Casual=data/Aiko/Casual
Casual_Pony=data/Aiko/Casual/Pony
About=Some description about Aiko
// Graphics for characters are referenced using a call syntax like SET_NAME.FILE_NAME_WITHOUT_EXTENSION
// Ex. below will reference the file data/Aiko/Casual/Aiko_Smile_Blush_Side.png
AboutImage=Casual.Aiko_Smile_Blush_Side
```

### \<SECTION:Scene\>

Scene sections are what's used in the actual game play.

A scene has similar content to a **__Config__** section or **Character** section as it also consists of **Key=Value** entries, but it also has some additional entries supported.

A section may contain a line that only consists of `---` which indicates everything after that are parsed as scene actions.

Until the `---` then configurations for the scene are passed (All **Key=Value** entries)

Configurations:

```
Music=MusicFileName
Background=BackgroundMediaFileName
// If set to true then the scene name is displayed for a short while. (Currently not implemented.)
DisplaySceneName=true/false
```

Example:

```
Music=GameMusic
Background=Background2
DisplaySceneName=true
```

When parsing scene actions you must specify lines consisting of `===` each time the game needs to take a break and wait for user input (Left Mouse-Click *or* pressing SPACE/ENTER)

When a line is just a single value that ends with **;** then it indicates an action that the engine executes.

Example:

```
KeepSprite;
```

When a line is just a single value with nothing else then it indicates a new character is displayed.

Example:

```
Aiko
```

Scene Actions:

```
// Position can be Left,Center or Right
SpritePosition=Position
// Uses the call syntax shown under Character Section ex. Casual.Aiko_Smile_Blush_Side
Sprite=SpriteEntry
// You cannot display multiple texts unless you === (break) inbetween them.
Text=Text To Display
// You can display multiple options but not along with text.
Option=SCENE_NAME|Text For Option To Display
```

Example Scene:

```
<Scene1:Scene>
Music=GameMusic
Background=Background1
DisplaySceneName=true
---
  Aiko
  Text=This is dialogue text!
  SpritePosition=Left
  Sprite=Casual.Aiko_Smile_Blush_Side
  ===
  Text=This is some more text by Aiko
  ===
  Miki
  KeepSprite;
  SpritePosition=Center
  Sprite=Casual.Miki_Casual_Open_Blush
  Text=This is some text by Miki
  ===
  Option=Scene2|Go to Scene 2
  Option=Scene2|Go to Scene 2 as well (but with more scenes it could be different.)

<Scene2:Scene>
Background=Background2
DisplaySceneName=true
---
  Aiko
  Text=This is the final text
  ===
  End; // Ends the game.
```

### Compiling the files

When compiling the game you must have a **files.txt** within the **config** folder where each line corresponds to a file name available at compile-time to the D compiler. Generally it'll be all files in the **story** folder.

On Windows you can do the following to automatically create the **files.txt** file with the correct content.

```
dir /b "story" > "config/files.txt"
```

The only mandatory file is a **main.txt** file and that file alone can be used for the whole game.

However maintaining a single file for a whole game is not easy and thus multiple files can be used.

You can decide the order in which they are parsed since files are only parsed when specified from another file.

You can specify a file for parsing using the import syntax **#FILE_NAME_WITHOUT_EXTENSION**

Example: (Of main.txt)

```
#backgrounds
#story
```

Will parse:

```
story/backgrounds.txt
story/story.txt
```

---

## Compiling A Game

Currently there are no examples on compiling a game on any other platforms other than Windows (x86).

Examples for other platforms and architectures will be given later.

You can see https://dlang.org/ and/or https://code.dlang.org/ for compiler instructions and project configurations that can be used in order to compile games using different configurations than given.

### Windows (x86)

To compile on Windows x86 you can simply use **dub build** on a project with the following **dub.json**

```
{
  "name": "OUTPUT_NAME",
  "targetType": "executable",
  "sourcePaths": ["source"],
  "stringImportPaths": ["story", "config"],
  "lflags" : ["+libs\\"],
  "dependencies": {
    "novelate": "0.0.3"
  }
}
```

The lib files for DSFML must be present in a folder named **libs** that should be located in the root folder of the project.

#### Distributing A Game (Windows - x86)

The files and folders when distributing a game should only include the output file (.exe), libraries (.dll) and the data folder (usually /data)

*You don't need the Novelate files when publishing nor the project files or any source code.*

---

## Events

If you need more flexibility than currently available in the engine through its custom file format then you can use the D programming language to create event handlers for various actions that allows you to shape the game however you want.

**More events will be added over time.**

Example:

```d
addEventHandler!(EventType.onSceneChange)({
  import std.stdio : writeln;
  writeln("Changing scene ...");
});
```

### Event Handlers



#### Scene Change - onSceneChange

Event handler for whenever the scene changes.

#### Temp Screen Clear - onTempScreenClear

Event handler for whenever the temp screen clears.

#### Temp Screen Show - onTempScreenShow

Event handler for whenever a temp screen is shown.

#### Resolution Change - onResolutionChange

Event handler for whenever the resolution changes.

#### Loading Credits Video - onLoadingCreditsVideo

Event handler for whenever the credits video is loaded.

#### Clearing All Layers But Background - onClearingAllLayersButBackground

Event handler for whenever all layers clear except for their backgrounds.

#### Screen Change - onScreenChange

Event handler for whenever the screen changes.

#### Rendering - onRender

Event handler for whenever the game is rendering.
