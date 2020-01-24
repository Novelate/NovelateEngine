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
module novelate.screens.play;

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
import novelate.screens.screen;

import novelate.core : LayerType, StandardScreen, changeActiveScreen;
import novelate.state : nextScene, endGame, playScene;

import novelate.external;

/// The play screen.
final class PlayScreen : Screen
{
  private:
  /// The current scene.
  NovelateScene _currentScene;
  /// The current music name.
  string _music;
  /// The current background.
  string _background;
  /// The current music stream.
  ExternalMusic _currentMusic;

  public:
  final:
  /// Creates a new play screen.
  this()
  {
    super();
  }

  /// See: Screen.shouldClearLayers()
  override bool shouldClearLayers(string[] data)
  {
    if (!data || !data.length)
    {
      return true;
    }

    auto sceneName = data[0];

    return !_currentScene || _currentScene.name != sceneName;
  }

  /// See: Screen.update()
  override void update(string[] data)
  {
    if (!data || !data.length)
    {
      return;
    }

    auto sceneName = data[0];

    if (_currentScene && _currentScene.name == sceneName)
    {
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

    updateBackground(_background);

    removeComponent(LayerType.dialogueBox, "dialogueBox");

    auto dialogueBox = new DialogueBox;
    dialogueBox.globalKeyRelease = (k, ref b)
    {
      if (k == KeyboardKey.backSpace || k == KeyboardKey.escape)
      {
        changeActiveScreen(StandardScreen.mainMenu);
      }
    };

    dialogueBox.refresh(super.width, super.height);

    dialogueBox.color = colorFromString(config.defaultDialogueBackground);

    addComponent(LayerType.dialogueBox, dialogueBox, "dialogueBox");

    clear(LayerType.dialogueBoxInteraction);

    auto dialogueText = new TimedText;
    dialogueText.color = colorFromString(config.defaultDialogueColor);
    dialogueText.fontSize = config.defaultDialogueTextFontSize;
    if (config.defaultDialogueTextFont && config.defaultDialogueTextFont.length)
    {
      dialogueText.fontName = config.defaultDialogueTextFont;
    }
    dialogueText.text = "";
    dialogueText.refresh(super.width, super.height);
    addComponent(LayerType.dialogueBoxInteraction, dialogueText, "dialogueText");

    auto nameLabel = new Label;
    nameLabel.color = colorFromString(config.defaultDialogueColor);
    nameLabel.fontSize = config.defaultDialogueNameFontSize;
    if (config.defaultDialogueNameFont && config.defaultDialogueNameFont.length)
    {
      nameLabel.fontName = config.defaultDialogueNameFont;
    }
    nameLabel.text = "";
    nameLabel.refresh(super.width, super.height);
    addComponent(LayerType.dialogueBoxInteraction, nameLabel, "nameLabel");

    NovelateCharacter currentCharacter = null;
    string nextSpritePosition = "Left";
    bool keepSprite = false;

    clear(LayerType.character);

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
                  clear(LayerType.character);
                }

                keepSprite = false;

                auto image = new ImageComponent(currentCharacter.getImage(action.value, super.width));
                image.fadeIn(12);
                auto imgSize = image.size;

                switch (nextSpritePosition)
                {
                  case "Left":
                    image.position = FloatVector(12, super.height - imgSize.y);
                    break;

                  case "Right":
                    image.position = FloatVector(super.width - (12 + imgSize.x), super.height - imgSize.y);
                    break;

                  case "Center":
                    image.position = FloatVector((super.width / 2) - (imgSize.x / 2), super.height - imgSize.y);
                    break;

                    default: break;
                }

                addComponent(LayerType.character, image, "character_" ~ currentCharacter.name);
                break;
              }

              case "Text":
              {
                dialogueText.text = to!dstring(action.value);
                break;
              }

              case "Option":
              {
                removeComponent(LayerType.dialogueBoxInteraction, "dialogueText");
                removeComponent(LayerType.dialogueBoxInteraction, "nameLabel");

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
                auto dialogueBoxInteractionLayerLength = getLayer(LayerType.dialogueBoxInteraction).length;

                optionLabel.text = to!dstring(optionText);
                auto optionY = cast(double)nameLabel.y;
                optionY += config.defaultDialogueTextFontSize * dialogueBoxInteractionLayerLength;
                optionY += 8 * dialogueBoxInteractionLayerLength;

                optionLabel.position = FloatVector(nameLabel.x, cast(float)optionY);
                optionLabel.mouseRelease = (b, ref s)
                {
                  nextScene = optionSceneName;
                };
                addComponent(LayerType.dialogueBoxInteraction, optionLabel, optionSceneName);
                break;
              }

              case "Screen":
              {
                changeActiveScreen(action.value);
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
}
