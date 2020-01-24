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
* This is the module for displaying the main menu.
*/
module novelate.screens.mainmenu;

import std.conv : to;

import novelate.config;
import novelate.ui.imagecomponent;
import novelate.ui.animatedimage;
import novelate.media;
import novelate.ui.label;
import novelate.colormanager;
import novelate.screens.layer;
import novelate.screens.screen;
import novelate.external;

import novelate.core : LayerType, changeActiveScreen, StandardScreen;
import novelate.state :   exitGame, playScene;

/// The main menu screen.
final class MainMenuScreen : Screen
{
  public:
  final:
  /// Creates a new main menu screen.
  this()
  {
    super();
  }

  /// See: Screen.update()
  override void update(string[] data)
  {
    updateBackground(config.menuBackground);

    auto logoFrames = config.menuLogoImage;

    if (logoFrames && logoFrames.frames && logoFrames.frames.length)
    {
      string[] logoImages = [];

      auto frameSpeed = logoFrames.frames[0].nextFrameTime;

      foreach (frame; logoFrames.frames)
      {
        logoImages ~= getMediaFile(frame.image).relativePath(super.width);
      }

      if (logoImages && logoImages.length)
      {
        auto image = new AnimatedImage(logoImages);
        image.animationSpeed = frameSpeed;
        image.fadeIn(20);
        image.position = FloatVector(config.menuLogoImageX800, config.menuLogoImageY800);

        addComponent(LayerType.front, image, "logo");
      }
    }

    AltValue!(ptrdiff_t, string) menuBoxOffsetX;
    AltValue!(ptrdiff_t, string) menuBoxOffsetY;

    if (super.width == 800)
    {
      menuBoxOffsetX = config.menuBox_X800;
      menuBoxOffsetY = config.menuBox_Y800;
    }
    else if (super.width == 1024)
    {
      menuBoxOffsetX = config.menuBox_X1024;
      menuBoxOffsetY = config.menuBox_Y1024;
    }
    else if (super.width == 1280)
    {
      menuBoxOffsetX = config.menuBox_X1280;
      menuBoxOffsetY = config.menuBox_Y1280;
    }

    ptrdiff_t offsetX = 0;
    ptrdiff_t offsetY = 0;

    if (menuBoxOffsetX.value2 && menuBoxOffsetX.value2.length)
    {
      switch (menuBoxOffsetX.value2)
      {
        case "C":
        case "Center":
          offsetX = (super.width / 2);
          break;

        default: break;
      }
    }
    else
    {
      offsetX = menuBoxOffsetX.value1;
    }

    Label[] labels = [];

    labels ~= createLabel(config.menuItem_Play.text, (b, ref s)
    {
      changeActiveScreen(StandardScreen.scene, [playScene]);
    }, offsetX);

    labels ~= createLabel(config.menuItem_Load.text, (b, ref s)
    {
      changeActiveScreen(StandardScreen.load);
    }, offsetX);

    labels ~= createLabel(config.menuItem_Save.text, (b, ref s)
    {
      changeActiveScreen(StandardScreen.save);
    }, offsetX);

    labels ~= createLabel(config.menuItem_About.text, (b, ref s)
    {
      changeActiveScreen(StandardScreen.about);
    }, offsetX);

    labels ~= createLabel(config.menuItem_Characters.text, (b, ref s)
    {
      changeActiveScreen(StandardScreen.characters);
    }, offsetX);

    labels ~= createLabel(config.menuItem_Exit.text, (b, ref s)
    {
      exitGame = true;
    }, offsetX);

    if (menuBoxOffsetY.value2 && menuBoxOffsetY.value2.length)
    {
      size_t totalHeight = 0;

      foreach (label; labels)
      {
        totalHeight += label.height;
        totalHeight += cast(size_t)(cast(double)label.fontSize * 0.5);
      }

      switch (menuBoxOffsetY.value2)
      {
        case "B":
        case "Bottom":
          totalHeight += cast(size_t)(cast(double)labels[0].fontSize * 1.5);

          offsetY = (super.height - totalHeight);
          break;
        case "T":
        case "Top":
          offsetY = cast(ptrdiff_t)(cast(double)labels[0].fontSize * 1.5);
          break;

        case "C":
        case "Center":
          offsetY = cast(ptrdiff_t)((super.height / 2) - (totalHeight / 2));
          break;

        default: break;
      }
    }
    else
    {
      offsetY = menuBoxOffsetY.value1;
    }

    foreach (label; labels)
    {
      label.position = FloatVector(label.x, offsetY);

      offsetY += label.height;
      offsetY += cast(size_t)(cast(double)label.fontSize * 0.5);

      addComponent(LayerType.dialogueBoxInteraction, label, to!string(label.text));
    }
  }

  /**
  * Creates a label for the menu.
  * Params:
  *   text = The text of the label.
  *   mouseRelease = Handler for when the label is pressed.
  *   offsetX = The x offset of the label.
  */
  private Label createLabel(string text, void delegate(MouseButton button, ref bool stopEvent) mouseRelease, ptrdiff_t offsetX)
  {
    auto label = new Label;
    label.color = colorFromString(config.defaultDialogueColor);
    label.fontSize = 48;
    if (config.defaultFont && config.defaultFont.length)
    {
      label.fontName = config.defaultFont;
    }
    label.text = to!dstring(text);
    label.position = FloatVector(offsetX - (label.width / 2), 50000);
    label.mouseRelease = mouseRelease;

    return label;
  }
}
