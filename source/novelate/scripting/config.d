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
* This module handles configurations for game compilation, deployment and also default configurations.
*/
module novelate.scripting.config;

import std.conv : to;
import std.array : split;
import std.string : isNumeric;

/// A value that may contain two different type values. Similar to a union except they're not combined data.
struct AltValue(T1,T2)
{
  /// The first value.
  T1 value1;
  /// The second value.
  T2 value2;
}

/// The compiled config for the game.
final class NovelateConfig
{
  private:
  /// The data folder.
  string _dataFolder;
  /// The save folder.
  string _saveFolder;
  /// The title of the game.
  string _gameTitle;
  /// The slogan of the game.
  string _gameSlogan;
  /// The description of the game.
  string _gameDescription;
  /// The about text of the game.
  string[] _gameAbout;
  /// The x coordinate for the menubox under the 800 resolution.
  AltValue!(ptrdiff_t, string) _menuBox_X800;
  /// The y coordinate for the menubox under the 800 resolution.
  AltValue!(ptrdiff_t, string) _menuBox_Y800;
  /// The x coordinate for the menubox under the 1024 resolution.
  AltValue!(ptrdiff_t, string) _menuBox_X1024;
  /// The y coordinate for the menubox under the 1024 resolution.
  AltValue!(ptrdiff_t, string) _menuBox_Y1024;
  /// The x coordinate for the menubox under the 1280 resolution.
  AltValue!(ptrdiff_t, string) _menuBox_X1280;
  /// The y coordinate for the menubox under the 1280 resolution.
  AltValue!(ptrdiff_t, string) _menuBox_Y1280;
  /// The menu text for the menu item: Play
  NovelateMenuText _menuItem_Play;
  /// The menu text for the menu item: Load
  NovelateMenuText _menuItem_Load;
  /// The menu text for the menu item: Save
  NovelateMenuText _menuItem_Save;
  /// The menu text for the menu item: About
  NovelateMenuText _menuItem_About;
  /// The menu text for the menu item: Characters
  NovelateMenuText _menuItem_Characters;
  /// The menu text for the menu item: Exit
  NovelateMenuText _menuItem_Exit;

  /// The menu title text.
  NovelateMenuText _menuTitleText;
  /// The menu title slogan.
  NovelateMenuText _menuTitleSlogan;

  /// The menu logo animation/image.
  NovelateImageAnimation _menuLogoImage;

  /// The x coordinate for the menu logo under the 800 resolution.
  ptrdiff_t _menuLogoImageX800;
  /// The y coordinate for the menu logo under the 800 resolution.
  ptrdiff_t _menuLogoImageY800;
  /// The x coordinate for the menu logo under the 1024 resolution.
  ptrdiff_t _menuLogoImageX1024;
  /// The y coordinate for the menu logo under the 1024 resolution.
  ptrdiff_t _menuLogoImageY1024;
  /// The x coordinate for the menu logo under the 1280 resolution.
  ptrdiff_t _menuLogoImageX1280;
  /// The y coordinate for the menu logo under the 1280 resolution.
  ptrdiff_t _menuLogoImageY1280;

  /// The menu music.
  string _menuMusic;

  /// The menu background animation/image.
  NovelateImageAnimation _menuBackground;

  /// The default font.
  string _defaultFont;
  /// The default font size.
  uint _defaultFontSize;
  /// The default dialogue color.
  string _defaultDialogueColor;
  /// The default dialogue background color.
  string _defaultDialogueBackground;
  /// The default dialogue border color.
  string _defaultDialogueBorder;
  /// The default dialogue background image/animation.
  NovelateImageAnimation _defaultDialogueBackgroundImage;
  /// The default dialogue padding.
  size_t _defaultDialoguePadding;
  /// The default dialogue margin.
  size_t _defaultDialogueMargin;
  /// The default dialogue height under the 800 resolution.
  size_t _defaultDialogueHeight800;
  /// The default dialogue height under the 1024 resolution.
  size_t _defaultDialogueHeight1024;
  /// The default dialogue height under the 1280 resolution.
  size_t _defaultDialogueHeight1280;
  /// The default dialogue name font size.
  size_t _defaultDialogueNameFontSize;
  /// The default dialogue text font size.
  size_t _defaultDialogueTextFontSize;
  /// The default dialogue name font.
  string _defaultDialogueNameFont;
  /// The default dialogue text font.
  string _defaultDialogueTextFont;

  /// The start scene.
  string _startScene;
  /// The credits video.
  string _creditsVideo;

  public:
  final:
  this()
  {
    _gameAbout = [];

    _menuItem_Play = new NovelateMenuText("Play");
    _menuItem_Load = new NovelateMenuText("Load");
    _menuItem_Save = new NovelateMenuText("Save");
    _menuItem_About = new NovelateMenuText("About");
    _menuItem_Characters = new NovelateMenuText("Characters");
    _menuItem_Exit = new NovelateMenuText("Exit");

    _menuTitleText = new NovelateMenuText("Game Title");
    _menuTitleSlogan = new NovelateMenuText("Game Slogan");

    _defaultDialoguePadding = 8;
    _defaultDialogueMargin = 8;

    _defaultFontSize = 16;
  }

  @property
  {
    /// Gets the data folder.
    string dataFolder() { return _dataFolder; }
    /// Gets the save folder.
    string saveFolder() { return _saveFolder; }
    /// Gets the game title.
    string gameTitle() { return _gameTitle; }
    /// Gets the game slogan.
    string gameSlogan() { return _gameSlogan; }
    /// Gets the game description.
    string gameDescription() { return _gameDescription; }
    /// Gets the about text of the game.
    string[] gameAbout() { return _gameAbout; }
    /// Gets the x coordinate for the menubox under the 800 resolution.
    AltValue!(ptrdiff_t, string) menuBox_X800() { return _menuBox_X800; }
    /// Gets the y coordinate for the menubox under the 800 resolution.
    AltValue!(ptrdiff_t, string) menuBox_Y800() { return _menuBox_Y800; }
    /// Gets the x coordinate for the menubox under the 1024 resolution.
    AltValue!(ptrdiff_t, string) menuBox_X1024() { return _menuBox_X1024; }
    /// Gets the y coordinate for the menubox under the 1024 resolution.
    AltValue!(ptrdiff_t, string) menuBox_Y1024() { return _menuBox_Y1024; }
    /// Gets the x coordinate for the menubox under the 1280 resolution.
    AltValue!(ptrdiff_t, string) menuBox_X1280() { return _menuBox_X1280; }
    /// Gets the y coordinate for the menubox under the 1280 resolution.
    AltValue!(ptrdiff_t, string) menuBox_Y1280() { return _menuBox_Y1280; }
    /// Gets the menu text for the menu item: Play
    NovelateMenuText menuItem_Play() { return _menuItem_Play; }
    /// Gets the menu text for the menu item: Load
    NovelateMenuText menuItem_Load() { return _menuItem_Load; }
    /// Gets the menu text for the menu item: Save
    NovelateMenuText menuItem_Save() { return _menuItem_Save; }
    /// Gets the menu text for the menu item: About
    NovelateMenuText menuItem_About() { return _menuItem_About; }
    /// Gets the menu text for the menu item: Characters
    NovelateMenuText menuItem_Characters() { return _menuItem_Characters; }
    /// Gets the menu text for the menu item: Exit
    NovelateMenuText menuItem_Exit() { return _menuItem_Exit; }
    /// Gets the menu title text.
    NovelateMenuText menuTitleText() { return _menuTitleText; }
    /// Gets the menu title slogan.
    NovelateMenuText menuTitleSlogan() { return _menuTitleSlogan; }
    /// Gets the menu logo animation/image.
    NovelateImageAnimation menuLogoImage() { return _menuLogoImage; }
    /// Gets the x coordinate for the menu logo under the 800 resolution.
    ptrdiff_t menuLogoImageX800() { return _menuLogoImageX800; }
    /// Gets the y coordinate for the menu logo under the 800 resolution.
    ptrdiff_t menuLogoImageY800() { return _menuLogoImageY800; }
    /// Gets the x coordinate for the menu logo under the 1024 resolution.
    ptrdiff_t menuLogoImageX1024() { return _menuLogoImageX1024; }
    /// Gets the y coordinate for the menu logo under the 1024 resolution.
    ptrdiff_t menuLogoImageY1024() { return _menuLogoImageY1024; }
    /// Gets the x coordinate for the menu logo under the 1280 resolution.
    ptrdiff_t menuLogoImageX1280() { return _menuLogoImageX1280; }
    /// Gets the y coordinate for the menu logo under the 1280 resolution.
    ptrdiff_t menuLogoImageY1280() { return _menuLogoImageY1280; }
    /// Gets the menu music.
    string menuMusic() { return _menuMusic; }
    /// Gets the menu background animation/image.
    NovelateImageAnimation menuBackground() { return _menuBackground; }
    /// Gets the default font.
    string defaultFont() { return _defaultFont; }
    /// Gets the default font size.
    uint defaultFontSize() { return _defaultFontSize; }
    /// Gets the default dialogue color.
    string defaultDialogueColor() { return _defaultDialogueColor; }
    /// Gets the default dialogue background.
    string defaultDialogueBackground() { return _defaultDialogueBackground; }
    /// Gets the default dialogue border.
    string defaultDialogueBorder() { return _defaultDialogueBorder; }
    /// Gets the default dialogue background image/animation.
    NovelateImageAnimation defaultDialogueBackgroundImage() { return _defaultDialogueBackgroundImage; }
    /// Gets the default dialogue padding.
    size_t defaultDialoguePadding() { return _defaultDialoguePadding; }
    /// Gets the default dialogue margin.
    size_t defaultDialogueMargin() { return _defaultDialogueMargin; }
    /// Gets the default dialogue height under the 800 resolution.
    size_t defaultDialogueHeight800() { return _defaultDialogueHeight800; }
    /// Gets the default dialogue height under the 1024 resolution.
    size_t defaultDialogueHeight1024() { return _defaultDialogueHeight1024; }
    /// Gets the default dialogue height under the 1280 resolution.
    size_t defaultDialogueHeight1280() { return _defaultDialogueHeight1280; }
    /// Gets the default dialogue name font size.
    size_t defaultDialogueNameFontSize() { return _defaultDialogueNameFontSize; }
    /// Gets the default dialogue text font size.
    size_t defaultDialogueTextFontSize() { return _defaultDialogueTextFontSize; }
    /// Gets the default dialogue name font.
    string defaultDialogueNameFont() { return _defaultDialogueNameFont; }
    /// Gets the default dialogue text font.
    string defaultDialogueTextFont() { return _defaultDialogueTextFont; }
    /// Gets the start scene.
    string startScene() { return _startScene; }
    /// Gets the credits video.
    string creditsVideo() { return _creditsVideo; }
  }

  package(novelate):
  /**
  * Sets a parsed configuration. Some configurations can be set to multiple values by setting them multiple times.
  * Params:
  *   name = The name of the configuration to set.
  *   value = The value of the configuration to set.
  */
  void setConfig(string name, string value)
  {
    switch (name)
    {
      case "DataFolder": _dataFolder = value; break;
      case "SaveFolder": _saveFolder = value; break;
      case "GameTitle": _gameTitle = value; break;
      case "GameSlogan": _gameSlogan = value; break;
      case "GameDescription": _gameDescription = value; break;
      case "GameAbout": _gameAbout ~= value; break;
      case "MenuItem_Play": _menuItem_Play = parseMenuItem(value, _menuItem_Play); break;
      case "MenuItem_Load": _menuItem_Load = parseMenuItem(value, _menuItem_Load); break;
      case "MenuItem_Save": _menuItem_Save = parseMenuItem(value, _menuItem_Save); break;
      case "MenuItem_About": _menuItem_About = parseMenuItem(value, _menuItem_About); break;
      case "MenuItem_Characters": _menuItem_Characters = parseMenuItem(value, _menuItem_Characters); break;
      case "MenuItem_Exit": _menuItem_Exit = parseMenuItem(value, _menuItem_Exit); break;
      case "MenuTitleText": _menuTitleText = parseMenuItem(value, _menuTitleText); break;
      case "MenuTitleSlogan": _menuTitleSlogan = parseMenuItem(value, _menuTitleSlogan); break;

      case "MenuBoxPosition_800":
      {
        auto pos = value.split(",");

        if (pos[0].isNumeric) _menuBox_X800.value1 = to!ptrdiff_t(pos[0]);
        else _menuBox_X800.value2 = pos[0];

        if (pos[1].isNumeric) _menuBox_Y800.value1 = to!ptrdiff_t(pos[1]);
        else _menuBox_Y800.value2 = pos[1];
        break;
      }

      case "MenuBoxPosition_1024":
      {
        auto pos = value.split(",");

        if (pos[0].isNumeric) _menuBox_X1024.value1 = to!ptrdiff_t(pos[0]);
        else _menuBox_X1024.value2 = pos[0];

        if (pos[1].isNumeric) _menuBox_Y1024.value1 = to!ptrdiff_t(pos[1]);
        else _menuBox_Y1024.value2 = pos[1];
        break;
      }

      case "MenuBoxPosition_1280":
      {
        auto pos = value.split(",");

        if (pos[0].isNumeric) _menuBox_X1280.value1 = to!ptrdiff_t(pos[0]);
        else _menuBox_X1280.value2 = pos[0];

        if (pos[1].isNumeric) _menuBox_Y1280.value1 = to!ptrdiff_t(pos[1]);
        else _menuBox_Y1280.value2 = pos[1];
        break;
      }

      case "MenuLogoImageLocation_800":
      {
        auto pos = value.split(",");

        _menuLogoImageX800 = to!ptrdiff_t(pos[0]);
        _menuLogoImageY800 = to!ptrdiff_t(pos[1]);
        break;
      }

      case "MenuLogoImageLocation_1024":
      {
        auto pos = value.split(",");

        _menuLogoImageX1024 = to!ptrdiff_t(pos[0]);
        _menuLogoImageY1024 = to!ptrdiff_t(pos[1]);
        break;
      }

      case "MenuLogoImageLocation_1280":
      {
        auto pos = value.split(",");

        _menuLogoImageX1280 = to!ptrdiff_t(pos[0]);
        _menuLogoImageY1280 = to!ptrdiff_t(pos[1]);
        break;
      }

      case "MenuMusic": _menuMusic = value; break;

      case "MenuBackground":
      {
        if (!_menuBackground)
        {
          _menuBackground = new NovelateImageAnimation;
        }

        parseImageAnimationFrame(_menuBackground, value);
        break;
      }

      case "MenuLogoImage":
      {
        if (!_menuLogoImage)
        {
          _menuLogoImage = new NovelateImageAnimation;
        }

        parseImageAnimationFrame(_menuLogoImage, value);
        break;
      }

      case "DefaultFont": _defaultFont = value; break;
      case "DefaultFontSize": _defaultFontSize = to!uint(value); break;
      case "DefaultDialogueColor": _defaultDialogueColor = value; break;
      case "DefaultDialogueBackground": _defaultDialogueBackground = value; break;
      case "DefaultDialogueBorder": _defaultDialogueBorder = value; break;
      case "DefaultDialogueBackgroundImage":
      {
        if (!_defaultDialogueBackgroundImage)
        {
          _defaultDialogueBackgroundImage = new NovelateImageAnimation;
        }

        parseImageAnimationFrame(_defaultDialogueBackgroundImage, value);
        break;
      }
      case "DefaultDialoguePadding": _defaultDialoguePadding = to!size_t(value); break;
      case "DefaultDialogueMargin": _defaultDialogueMargin = to!size_t(value); break;
      case "DefaultDialogueHeight_800": _defaultDialogueHeight800 = to!size_t(value); break;
      case "DefaultDialogueHeight_1024": _defaultDialogueHeight1024 = to!size_t(value); break;
      case "DefaultDialogueHeight_1280": _defaultDialogueHeight1280 = to!size_t(value); break;
      case "DefaultDialogueNameFontSize": _defaultDialogueNameFontSize = to!size_t(value); break;
      case "DefaultDialogueTextFontSize": _defaultDialogueTextFontSize = to!size_t(value); break;
      case "DefaultDialogueNameFont": _defaultDialogueNameFont = value; break;
      case "DefaultDialogueTextFont": _defaultDialogueTextFont = value; break;

      case "StartScene": _startScene = value; break;
      case "CreditsVideo": _creditsVideo = value; break;

      default: break;
    }
  }
}

/**
* Parses an image animation frame configuration.
* Params:
*   animation = The animation object to add the frame to.
*   value = The value of the frame configuration.
*/
private void parseImageAnimationFrame(NovelateImageAnimation animation, string value)
{
  auto entryData = value.split("|");
  auto image = entryData[0];
  auto time = to!size_t(entryData[1]);

  animation.add(new NovelateImageAnimationFrame(image, time));
}

/**
* Parses a menu item configuration.
* Params:
*   value = The value of the menu item configuration.
*   refItem = The referenced menu item. Usually the old state of the menu item.
* Returns:
*   Returns the parsed menu item configuration.
*/
private NovelateMenuText parseMenuItem(string value, NovelateMenuText refItem)
{
  auto entryData = value.split("|");
  auto text = entryData[0];
  auto color = refItem.color;
  auto font = refItem.font;

  if (entryData.length >= 2)
  {
    color = entryData[1];
  }

  if (entryData.length >= 3)
  {
    font = entryData[2];
  }

  return new NovelateMenuText(text, color, font);
}

/// A menu text configuration.
final class NovelateMenuText
{
  private:
  /// The text.
  string _text;
  /// The color.
  string _color;
  /// The font.
  string _font;

  public:
  /**
  * Creates a new menu item text configuration.
  * Params:
  *   text = The text.
  *   color = The color.
  *   font = The font.
  */
  this(string text, string color = "255,255,255", string font = null)
  {
    _text = text;
    _color = color;
    _font = font;
  }

  @property
  {
    /// Gets the text.
    string text() { return _text; }
    /// Gets the color.
    string color() { return _color; }
    /// Gets the font.
    string font() { return _font; }
  }
}

/// An image animation configuration.
final class NovelateImageAnimation
{
  private:
  /// The frames of the image animation.
  NovelateImageAnimationFrame[] _frames;

  public:
  /// Creates a new image animation configuration.
  this()
  {
    _frames = [];
  }

  @property
  {
    /// Gets the frames.
    NovelateImageAnimationFrame[] frames() { return _frames; }
  }

  /// Clears the frames of the image animation.
  void clear()
  {
    _frames = [];
  }

  /**
  * Adds an image animation frame.
  * Params:
  *   frame = The frame to add.
  */
  void add(NovelateImageAnimationFrame frame)
  {
    _frames ~= frame;
  }
}

/// An image animation frame.
final class NovelateImageAnimationFrame
{
  private:
  /// The image.
  string _image;
  /// The next frame time. Generally only the first frame's time is used to be consistent.
  size_t _nextFrameTime;

  public:
  final:
  /**
  * Creates an image animation frame.
  * Params:
  *   image = The image of the animation frame.
  *   nextFrameTime = The next frame time. Generally only the first frame's time is used to be consistent.
  */
  this(string image, size_t nextFrameTime)
  {
    _image = image;
    _nextFrameTime = nextFrameTime;
  }

  @property
  {
    /// Gets the image.
    string image() { return _image; }

    /// Gets the next frame time. Generally only the first frame's time is used to be consistent.
    size_t nextFrameTime() { return _nextFrameTime; }
  }
}

/// The configuration.
private NovelateConfig _config;

public:
@property
{
  /// Gets the configuration.
  NovelateConfig config()
  {
    if (!_config)
    {
      _config = new NovelateConfig();
    }

    return _config;
  }
}
