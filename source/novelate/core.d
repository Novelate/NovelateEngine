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

import dsfml.graphics : RenderWindow, Color;
import dsfml.window : VideoMode, ContextSettings, Window, Event, Keyboard, Mouse;

import novelate.layer;
import novelate.config;
import novelate.mainmenu;
import novelate.play;
import novelate.state;
import novelate.fonts;
import novelate.parser;
import novelate.events;

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

/// Clears the temp layers.
void clearTempLayers()
{
  _isTempScreen = false;
  selectedLayers = _layers;

  foreach (tempLayer; _tempLayers)
  {
    tempLayer.clear();
  }

  fireEvent!(EventType.onTempScreenClear);
}

/// Sets the temp layers.
void setTempLayers()
{
  _isTempScreen = true;
  selectedLayers = _tempLayers;

  fireEvent!(EventType.onTempScreenShow);
}

/**
* Gets a layer by its index. It retrieves it from the current selected layers whether it's the main layers or the temp layers.
* Params:
*   index = The index of the layer to get.
* Returns:
*   The layer within the current selected layers.
*/
Layer getLayer(size_t index)
{
  if (!selectedLayers || index >= selectedLayers.length)
  {
    return null;
  }

  return selectedLayers[index];
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

  if (_window && _window.isOpen())
  {
    _window.close();

    _window = null;
  }

  write(config.dataFolder ~ "/res.ini", format("Width=%s\r\nHeight=%s\r\nFullScreen=%s", width, height, fullScreen));

  _videoMode = VideoMode(cast(int)width, cast(int)height);

  if (fullScreen)
  {
    _window = new RenderWindow(_videoMode, _title, (Window.Style.Fullscreen), _context);
  }
  else
  {
    _window = new RenderWindow(_videoMode, _title, (Window.Style.Titlebar | Window.Style.Close), _context);
  }

  _window.setFramerateLimit(_fps);

  if (_layers)
  {
    foreach (layer; _layers)
    {
      layer.refresh(_width, _height);
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

/// Clears all layers for their components except for the background layer as that should usually be cleared by fading-in and fading-out when adding a new background. This adds smoothness to the game.
void clearAllLayersButBackground()
{
  if (!selectedLayers || !selectedLayers.length)
  {
    return;
  }

  foreach (i; 1 .. selectedLayers.length)
  {
    selectedLayers[i].clear();
  }

  fireEvent!(EventType.onClearingAllLayersButBackground);
}

/// Enumeration of screens.
enum Screen : string
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
* Changes the screen.
* Params:
*   screen = The screen to change to. You should use the "Screen" enum for accuracy of the screen name.
*   data = The data passed onto the screen.
*/
void changeScreen(string screen, string[] data = null)
{
  clearAllLayersButBackground();

  switch (screen)
  {
    case Screen.mainMenu: showMainMenu(); break;

    case Screen.scene: if (data && data.length) changeScene(data[0]); break;

    default: break; // TODO: Custom screen handling through events.
  }

  fireEvent!(EventType.onScreenChange);
}

/// Initializes the game.
void initialize()
{
  parseFile("main.txt");

  loadFonts(config.dataFolder ~ "/fonts");

  _context.antialiasingLevel = 100;

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

  foreach (_; 0 .. 10)
  {
    _layers ~= new Layer(_width, _height);
    _tempLayers ~= new Layer(_width, _height);
  }

  selectedLayers = _layers;

  playScene = config.startScene;
}

/// Runs the game/event/UI loop.
void run()
{
    auto backgroundColor = Color(0,0,0,0xff);

    changeResolution(_width, _height, fullScreen);

    changeScreen(Screen.mainMenu);

    while (running && _window && _window.isOpen())
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
          changeScreen(Screen.mainMenu);
        }

        endGame = false;
        playScene = config.startScene;
      }

      if (changeTempScreen != Screen.none)
      {
        changeScreen(changeTempScreen);

        changeTempScreen = Screen.none;
      }

      if (nextScene)
      {
        changeScene(nextScene);

        nextScene = null;
      }

      Event event;
      while(_window.pollEvent(event))
      {
        switch (event.type)
        {
          case Event.EventType.Closed:
          {
            running = false;
            _window.close();
            goto exit;
          }

          case Event.EventType.MouseMoved:
          {
            if (selectedLayers && selectedLayers.length)
            {
              foreach_reverse (layer; selectedLayers)
              {
                bool stopEvent = false;

                layer.mouseMove(event.mouseMove.x, event.mouseMove.y, stopEvent);

                if (stopEvent)
                {
                  break;
                }
              }
            }
            break;
          }

          case Event.EventType.MouseButtonPressed:
          {
            if (selectedLayers && selectedLayers.length)
            {
              foreach_reverse (layer; selectedLayers)
              {
                bool stopEvent = false;

                layer.mousePress(event.mouseButton.button, stopEvent);

                if (stopEvent)
                {
                  break;
                }
              }
            }
            break;
          }

          case Event.EventType.MouseButtonReleased:
          {
            if (selectedLayers && selectedLayers.length)
            {
              foreach_reverse (layer; selectedLayers)
              {
                bool stopEvent = false;

                layer.mouseRelease(event.mouseButton.button, stopEvent);

                if (stopEvent)
                {
                  break;
                }
              }
            }
            break;
          }

          case Event.EventType.KeyPressed:
          {
            if (selectedLayers && selectedLayers.length)
            {
              foreach_reverse (layer; selectedLayers)
              {
                bool stopEvent = false;

                layer.keyPress(event.key.code, stopEvent);

                if (stopEvent)
                {
                  break;
                }
              }
            }
            break;
          }

          case Event.EventType.KeyReleased:
          {
            if (selectedLayers && selectedLayers.length)
            {
              foreach_reverse (layer; selectedLayers)
              {
                bool stopEvent = false;

                layer.keyRelease(event.key.code, stopEvent);

                if (stopEvent)
                {
                  break;
                }
              }
            }
            break;
          }

          default: break;
        }
      }

      _window.clear(backgroundColor);

      if (_layers && _layers.length)
      {
        foreach (layer; _layers)
        {
          layer.render(_window);
        }
      }

      if (_tempLayers && _tempLayers.length)
      {
        foreach (layer; _tempLayers)
        {
          layer.render(_window);
        }
      }

      fireEvent!(EventType.onRender);

      _window.display();
    }

    exit:
}
