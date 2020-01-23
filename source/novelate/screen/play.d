/**
* Copyright © Novelate 2020
* License: MIT (https://github.com/Novelate/NovelateEngine/blob/master/LICENSE)
* Author: Jacob Jensen (bausshf)
* Website: https://novelate.com/
* ------
* Novelate is a free and open-source visual novel engine and framework written in the D programming language.
* It can be used freely for both personal and commercial projects.
* ------
* Module Description:
* This module handles the core game play of the visual novel.
*/
module novelate.screen.play;

import std.array : split;
import std.conv : to;

import novelate.config;
import novelate.scene;
import novelate.media;
import novelate.music;
import novelate.ui.imagecomponent;
import novelate.ui.dialoguebox;
import novelate.colormanager;
import novelate.ui.timedtext;
import novelate.character;
import novelate.queue;
import novelate.ui.label;
import novelate.ui.animatedimage;
import novelate.events;

import novelate.core : getLayer, LayerType, clearTempLayers, setTempLayers, Screen;
import novelate.state : nextScene, endGame, playScene, changeTempScreen;

import novelate.external;

private
{
  /// The current scene.
  NovelateScene _currentScene;
  /// The current music name.
  string _music;
  /// The current background.
  string _background;
  /// The current music stream.
  ExternalMusic _currentMusic;
}

package(novelate):
/**
* Handles the play screen.
* Params:
*   sceneName = The name of the scene to play.
*/
void changeScene(string sceneName)
{
  if (_currentScene && _currentScene.name == sceneName)
  {
    clearTempLayers();
    return;
  }

  _currentScene = getScene(sceneName);

  if (!_currentScene)
  {
    return;
  }

  playScene = sceneName;

  fireEvent!(EventType.onSceneChange);

  if (_currentScene.music && _currentScene.music.length)
  {
    auto musicFile = getMusicFile(_currentScene.music);

    if (musicFile && musicFile.path.length && _music != musicFile.path)
    {
      _music = musicFile.path;

      if (_currentMusic)
      {
        _currentMusic.stop();
      }

      _currentMusic = new ExternalMusic();

      if (_currentMusic.openFromFile(_music))
      {
        _currentMusic.looping = true;

        _currentMusic.play();
      }
    }
  }

  if (_currentScene.background && _currentScene.background.length)
  {
    _background = _currentScene.background;
  }

  auto backgroundLayer = getLayer(LayerType.background);

  {
    auto oldBackground = cast(ImageComponent)backgroundLayer.getComponent("background");

    if (oldBackground)
    {
      backgroundLayer.addComponent(oldBackground, "background_old");
      backgroundLayer.removeComponent("background");
      oldBackground.fadeOut(20);
    }
  }

  {
    auto oldBackground = cast(AnimatedImage)backgroundLayer.getComponent("background");

    if (oldBackground)
    {
      backgroundLayer.addComponent(oldBackground, "background_old");
      backgroundLayer.removeComponent("background");
      oldBackground.fadeOut(20);
    }
  }

  if (_background && _background.length)
  {
    auto backgroundImage = getMediaFile(_background);

    if (backgroundImage)
    {
      auto image = new ImageComponent(backgroundImage.relativePath(backgroundLayer.width));
      image.fadeIn(20);
      image.fadedIn = ()
      {
        backgroundLayer.removeComponent("background_old");
      };
      image.fullScreen = true;
      image.refresh(backgroundLayer.width, backgroundLayer.height);

      backgroundLayer.addComponent(image, "background");
    }
  }

  auto dialogueBoxLayer = getLayer(LayerType.dialogueBox);
  dialogueBoxLayer.removeComponent("dialogueBox");

  auto dialogueBox = new DialogueBox;
  dialogueBox.globalKeyRelease = (k, ref b)
  {
    if (k == KeyboardKey.backSpace || k == KeyboardKey.escape)
    {
      setTempLayers();

      changeTempScreen = Screen.mainMenu;
    }
  };

  dialogueBox.refresh(backgroundLayer.width, backgroundLayer.height);

  dialogueBox.color = colorFromString(config.defaultDialogueBackground);

  dialogueBoxLayer.addComponent(dialogueBox, "dialogueBox");

  auto dialogueBoxInteractionLayer = getLayer(LayerType.dialogueBoxInteraction);
  dialogueBoxInteractionLayer.clear();

  auto dialogueText = new TimedText;
  dialogueText.color = colorFromString(config.defaultDialogueColor);
  dialogueText.fontSize = config.defaultDialogueTextFontSize;
  if (config.defaultDialogueTextFont && config.defaultDialogueTextFont.length)
  {
    dialogueText.fontName = config.defaultDialogueTextFont;
  }
  dialogueText.text = "";
  dialogueText.refresh(backgroundLayer.width, backgroundLayer.height);
  dialogueBoxInteractionLayer.addComponent(dialogueText, "dialogueText");

  auto nameLabel = new Label;
  nameLabel.color = colorFromString(config.defaultDialogueColor);
  nameLabel.fontSize = config.defaultDialogueNameFontSize;
  if (config.defaultDialogueNameFont && config.defaultDialogueNameFont.length)
  {
    nameLabel.fontName = config.defaultDialogueNameFont;
  }
  nameLabel.text = "";
  nameLabel.refresh(backgroundLayer.width, backgroundLayer.height);
  dialogueBoxInteractionLayer.addComponent(nameLabel, "nameLabel");

  NovelateCharacter currentCharacter = null;
  string nextSpritePosition = "Left";
  bool keepSprite = false;

  auto characterLayer = getLayer(LayerType.character);
  characterLayer.clear();

  Queue!NovelateSceneAction actionQueue = new Queue!NovelateSceneAction;

  foreach (action; _currentScene.actions)
  {
    actionQueue.enqueue(action);
  }

  bool firstText = false;

  void handleAction()
  {
    if (!actionQueue.has)
    {
      return;
    }

    auto action = actionQueue.dequeue();

    if (!action)
    {
      return;
    }

    switch (action.type)
    {
      case NovelateSceneActionType.characterChange:
      {
        currentCharacter = getCharacter(action.name);

        nameLabel.text = "";
        nameLabel.color = colorFromString(currentCharacter.nameColor);
        nameLabel.text = to!dstring(currentCharacter.name);
        break;
      }

      case NovelateSceneActionType.action:
      {
        switch (action.name)
        {
          case "KeepSprite":
          {
            keepSprite = true;
            break;
          }

          case "End":
          {
            if (_currentMusic)
            {
              _currentMusic.stop();
            }

            _currentScene = null;
            _music = null;
            _background = null;
            _currentMusic = null;
            endGame = true;
            break;
          }

          default: break;
        }
        break;
      }

      case NovelateSceneActionType.option:
      {
        switch (action.name)
        {
          case "SpritePosition":
            nextSpritePosition = action.value;
            break;

            case "Sprite":
            {
              if (!keepSprite)
              {
                characterLayer.clear();
              }

              keepSprite = false;

              auto image = new ImageComponent(currentCharacter.getImage(action.value, backgroundLayer.width));
              image.fadeIn(12);
              auto imgSize = image.size;

              switch (nextSpritePosition)
              {
                case "Left":
                  image.position = FloatVector(12, backgroundLayer.height - imgSize.y);
                  break;

                case "Right":
                  image.position = FloatVector(backgroundLayer.width - (12 + imgSize.x), backgroundLayer.height - imgSize.y);
                  break;

                case "Center":
                  image.position = FloatVector((backgroundLayer.width / 2) - (imgSize.x / 2), backgroundLayer.height - imgSize.y);
                  break;

                  default: break;
              }

              characterLayer.addComponent(image, "character_" ~ currentCharacter.name);
              break;
            }

            case "Text":
            {
              dialogueText.text = to!dstring(action.value);
              break;
            }

            case "Option":
            {
              dialogueBoxInteractionLayer.removeComponent("dialogueText");
              dialogueBoxInteractionLayer.removeComponent("nameLabel");

              auto optionData = action.value.split("|");
              auto optionSceneName = optionData[0];
              auto optionText = optionData[1];

              auto optionLabel = new Label;
              optionLabel.color = colorFromString(config.defaultDialogueColor);
              optionLabel.fontSize = config.defaultDialogueTextFontSize;
              if (config.defaultDialogueTextFont && config.defaultDialogueTextFont.length)
              {
                optionLabel.fontName = config.defaultDialogueTextFont;
              }
              optionLabel.text = to!dstring(optionText);
              auto optionY = cast(double)nameLabel.y;
              optionY += config.defaultDialogueTextFontSize * dialogueBoxInteractionLayer.length;
              optionY += 8 * dialogueBoxInteractionLayer.length;

              optionLabel.position = FloatVector(nameLabel.x, cast(float)optionY);
              optionLabel.mouseRelease = (b, ref s)
              {
                nextScene = optionSceneName;
              };
              dialogueBoxInteractionLayer.addComponent(optionLabel, optionSceneName);
              break;
            }

            default: break;
        }
        break;
      }

      default: break;
    }

    if (actionQueue.has)
    {
      auto peek = actionQueue.peek;

      if (peek.type == NovelateSceneActionType.actionChange)
      {
        actionQueue.dequeue();

        dialogueText.globalMouseReleaseTextFinished.enqueue((b, ref s)
        {
          handleAction();
        });
      }
      else
      {
        handleAction();
      }
    }
  }

  dialogueText.globalMouseReleaseTextFinished.enqueue((b, ref s)
  {
    handleAction();
  });

  handleAction();
}
