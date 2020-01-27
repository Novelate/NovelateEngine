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
* The core module for Novelate exposes misc. core functionality of the engine.
*/
module novelate.core;

import std.file : readText, write, exists;
import std.array : replace, split, array;
import std.string : strip, stripLeft, stripRight, format;
import std.algorithm : filter;
import std.conv : to;

import novelate.screens;
import novelate.config;
import novelate.state;
import novelate.fonts;
import novelate.parser;
import novelate.events;
import novelate.colormanager;
import novelate.external;

/// Enumeration of layer types. There are 10 available layers ranging from 0 - 9 as indexes. 7 is the largest named frame.
enum LayerType : size_t
{
  /// The background layer.
  background = 0,
  /// The object background.
  objectBackground = 1,
  /// The object foreground.
  objectForeground = 2,
  /// The character layer.
  character = 3,
  /// The front character layer.
  characterFront = 4,
  /// The dialogue box layer.
  dialogueBox = 5,
  /// The dialogue box interaction layer. Generally used for text, options etc.
  dialogueBoxInteraction = 6,
  /// The front layer.
  front = 7
}

/**
* Changes the resolution of the game. This should preferebly only be of the following resolutions: 800x600, 1024x768 or 1280x720. However any resolutions are acceptable but may have side-effects attached such as invalid rendering etc. All set resolutions are saved to a res.ini file in the data folder allowing for resolutions to be kept across instances of the game.
* Params:
*   width = The width of the resolution.
*   height = The height of the resolution.
*   fullScreen = A boolean determining whether the game is full-screen or not.
*/
void changeResolution(size_t width, size_t height, bool fullScreen)
{
  _width = width;
  _height = height;

  if (_window && _window.isOpen)
  {
    _window.close();

    _window = null;
  }

  write(config.dataFolder ~ "/res.ini", format("Width=%s\r\nHeight=%s\r\nFullScreen=%s", width, height, fullScreen));

  _window = ExternalWindow.create(_title, width, height, fullScreen);

  _window.fps = _fps;

  if (_activeScreens)
  {
    foreach (k,v; _activeScreens)
    {
      v.refresh(_width, _height);
    }
  }

  fireEvent!(EventType.onResolutionChange);
}

/// Loads the credits video. Currently does nothing.
void loadCreditsVideo()
{
  fireEvent!(EventType.onLoadingCreditsVideo);

  // ...
}

/// Enumeration of standard screens.
enum StandardScreen : string
{
  /// No screen.
  none = "none",
  /// The main menu.
  mainMenu = "mainMenu",
  /// The load screen.
  load = "load",
  /// The save screen.
  save = "save",
  /// The about screen.
  about = "about",
  /// The characters screen.
  characters = "characters",
  /// The game play screen (scene)
  scene = "scene"
}

/**
* Adds a screen to the game.
* Params:
*   screen = The screen to add.
*/
void addScreen(Screen screen)
{
  if (!screen)
  {
    return;
  }

  screen.setWidthAndHeight(_width, _height);

  _activeScreens[screen.name] = screen;
}

/**
* Removes a screen from the game.
* Params:
*   screenName = The name of the screen.
*/
void removeScreen(string screenName)
{
  if (!_activeScreens)
  {
    return;
  }

  _activeScreens.remove(screenName);
}

/**
* Changes the active screen.
* Params:
*   screenName = The screen to change to. You should use the "Screen" enum for accuracy of the screen name.
*   data = The data passed onto the screen.
*/
void changeActiveScreen(string screenName, string[] data = null)
{
  if (!_activeScreens)
  {
    return;
  }

  auto screen = _activeScreens.get(screenName, null);

  if (!screen)
  {
    return;
  }

  if (screen.shouldClearLayers(data))
  {
    screen.clearAllLayersButBackground();
  }

  screen.update(data);

  _activeScreen = screen;
  _activeScreenName = screen.name;

  fireEvent!(EventType.onScreenChange);
}

/// Initializes the game.
void initialize()
{
  initExternalBinding();

  parseFile("main.txt");

  loadFonts(config.dataFolder ~ "/fonts");

  _title = config.gameTitle;

  if (config.gameSlogan && config.gameSlogan.length)
  {
    _title ~= " - " ~ config.gameSlogan;
  }

  fullScreen = false;

  if (exists(config.dataFolder ~ "/res.ini"))
  {
    auto lines = readText(config.dataFolder ~ "/res.ini").replace("\r", "").split("\n");

    foreach (line; lines)
    {
      if (!line || !line.strip.length)
      {
        continue;
      }

      auto data = line.split("=");

      if (data.length != 2)
      {
        continue;
      }

      switch (data[0])
      {
        case "Width": _width = to!size_t(data[1]); break;
        case "Height": _height = to!size_t(data[1]); break;
        case "FullScreen": fullScreen = to!bool(data[1]); break;

        default: break;
      }
    }
  }

  addScreen(new MainMenuScreen);
  addScreen(new PlayScreen);

  playScene = config.startScene;
}

/// Runs the game/event/UI loop.
void run()
{
    auto backgroundColor = colorFromRGBA(0,0,0,0xff);

    changeResolution(_width, _height, fullScreen);

    changeActiveScreen(StandardScreen.mainMenu);

    auto manager = new ExternalEventManager;
    manager.addHandler(ExternalEventType.closed, {
      _window.close();
    });

    manager.addHandler(ExternalEventType.mouseMoved, {
      if (_activeScreen)
      {
        _activeScreen.mouseMove(ExternalEventState.mouseMoveEvent.x, ExternalEventState.mouseMoveEvent.y);
      }
    });
    manager.addHandler(ExternalEventType.mouseButtonPressed, {
      if (_activeScreen)
      {
        _activeScreen.mousePress(ExternalEventState.mouseButtonEvent.button);
      }
    });
    manager.addHandler(ExternalEventType.mouseButtonReleased, {
      if (_activeScreen)
      {
        _activeScreen.mouseRelease(ExternalEventState.mouseButtonEvent.button);
      }
    });

    manager.addHandler(ExternalEventType.keyPressed, {
      if (_activeScreen)
      {
        _activeScreen.keyPress(ExternalEventState.keyEvent.code);
      }
    });
    manager.addHandler(ExternalEventType.keyReleased, {
      if (_activeScreen)
      {
        _activeScreen.keyRelease(ExternalEventState.keyEvent.code);
      }
    });

    while (running && _window && _window.isOpen)
    {
      if (exitGame)
      {
        exitGame = false;
        running = false;
        _window.close();
        goto exit;
      }

      if (endGame)
      {
        if (config.creditsVideo)
        {
          // Should be a component ...
          loadCreditsVideo();
        }
        else
        {
          changeActiveScreen(StandardScreen.mainMenu);
        }

        endGame = false;
        playScene = config.startScene;
      }

      if (nextScene)
      {
        auto sceneScreen = _activeScreens[StandardScreen.scene];

        if (sceneScreen)
        {
          sceneScreen.update([nextScene]);
        }

        nextScene = null;
      }

      if (!_window.processEvents(manager))
      {
        goto exit;
      }

      if (_window.canUpdate)
      {
        _window.clear(backgroundColor);

        if (_activeScreen)
        {
          _activeScreen.render(_window);
        }

        fireEvent!(EventType.onRender);

        _window.render();
      }
    }
    exit:
    quit();
}
