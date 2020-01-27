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
* This module handles scenes.
*/
module novelate.scripting.scene;

import std.conv : to;
import std.algorithm : countUntil, endsWith;

/// Wrapper around a scene configuration.
final class NovelateScene
{
  private:
  /// The name.
  string _name;
  /// The music.
  string _music;
  /// The background.
  string _background;
  /// The animation.
  string _animation;
  /// The animation direction.
  string _animationDirection;
  /// The animation start position.
  string _animationStartPosition;
  /// Boolean determining whether the scene name should be displayed or not.
  bool _displaySceneName;
  /// Boolean determining whether the configuration is parsing actions.
  bool _parseActions;
  /// The actions.
  NovelateSceneAction[] _actions;

  public:
  final:
  package(novelate)
  {
    this(string name)
    {
      _name = name;

      _actions = [];
    }

    /**
    * Updates the scene with a line to parse from the parsed Novelate content.
    * Params:
    *   line = The line to parse.
    */
    void updateScene(string line)
    {
      if (line == "---")
      {
        _parseActions = true;
      }
      else
      {
        if (_parseActions)
        {
          if (line == "===")
          {
            _actions ~= new NovelateSceneAction(NovelateSceneActionType.actionChange, line);
          }
          else
          {
            auto valueIndex = line.countUntil("=");

            if (valueIndex < 1)
            {
              if (line.endsWith(";"))
              {
                _actions ~= new NovelateSceneAction(NovelateSceneActionType.action, line[0 .. $-1]);
              }
              else
              {
                _actions ~= new NovelateSceneAction(NovelateSceneActionType.characterChange, line);
              }
            }
            else
            {
              import std.array : replace;

              auto name = line[0 .. valueIndex];
              auto value = line[valueIndex + 1 .. $];

              _actions ~= new NovelateSceneAction(NovelateSceneActionType.option, name, value.replace("\\n", "\n"));
            }
          }
        }
        else
        {
          auto valueIndex = line.countUntil("=");

          if (valueIndex < 1)
          {
            return;
          }

          auto name = line[0 .. valueIndex];
          auto value = line[valueIndex + 1 .. $];

          switch (name)
          {
            case "Music": _music = value; break;
            case "Background": _background = value; break;
            case "Animation": _animation = value; break;
            case "AnimationDirection": _animationDirection = value; break;
            case "AnimationStartPosition": _animationStartPosition = value; break;
            case "DisplaySceneName": _displaySceneName = to!bool(value); break;

            default: break;
          }
        }
      }
    }
  }

  @property
  {
    /// Gets the name of the scene.
    string name() { return _name; }

    /// Gets the music of the scene.
    string music() { return _music; }

    /// Gets the background of the scene.
    string background() { return _background; }

    /// Gets the animation of the scene.
    string animation() { return _animation; }

    /// Gets the animation direction of the scene.
    string animationDirection() { return _animationDirection; }

    /// Gets the animation start position of the scene.
    string animationStartPosition() { return _animationStartPosition; }

    /// Gets a boolean determining whether the scene name should be displayed or not.
    bool displaySceneName() { return _displaySceneName; }

    /// Gets the actions of the scene.
    NovelateSceneAction[] actions() { return _actions; }
  }
}

/// Enumeration of scene action types.
enum NovelateSceneActionType
{
  /// A character change.
  characterChange,
  /// An option. This means an optiion for inputting configurations, setting data etc.
  option,
  /// An action to execute.
  action,
  /// An action change. This forces a wait for the next set of actions.
  actionChange
}

/// Wrapper around a scene action.
final class NovelateSceneAction
{
  private:
  /// The type.
  NovelateSceneActionType _type;
  /// The name.
  string _name;
  /// The value.
  string _value;

  public:
  final:
  /**
  * Creates a new scene action.
  * Params:
  *   type = The type of the scene action.
  *   name = The name of the scene action.
  */
  this(NovelateSceneActionType type, string name)
  {
    _type = type;
    _name = name;
  }

  /**
  * Creates a new scene action.
  * Params:
  *   type = The type of the scene action.
  *   name = The name of the scene action.
  *   value = The value of the scene action.
  */
  this(NovelateSceneActionType type, string name, string value)
  {
    this(type, name);

    _value = value;
  }

  @property
  {
    /// Gets the type.
    NovelateSceneActionType type() { return _type; }

    /// Gets the name.
    string name() { return _name; }

    /// Gets the value.
    string value() { return _value; }
  }
}

/// The scene collection.
private NovelateScene[string] _scenes;

public:
/**
* Gets a scene.
* Params:
*   name = The name of the scene to get.
* Returns:
*   The scene.
*/
NovelateScene getScene(string name)
{
  if (!_scenes)
  {
    return null;
  }

  return _scenes.get(name, null);
}

package(novelate):
/**
* Creates a scene base.
* Params:
*   name = The name of the scene to create a base for.
* Returns:
*   The scene base created.
*/
NovelateScene createSceneBase(string name)
{
  auto scene = new NovelateScene(name);

  _scenes[scene.name] = scene;

  return scene;
}
