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
module novelate.mainmenu;

import std.conv : to;

import dsfml.window : Keyboard, Mouse;
import dsfml.system : Vector2f;

import novelate.config;
import novelate.imagecomponent;
import novelate.animatedimage;
import novelate.media;
import novelate.label;
import novelate.colormanager;
import novelate.layer;

import novelate.core : getLayer, LayerType, changeScreen, Screen;
import novelate.state :   exitGame, playScene;

public alias MouseButton = Mouse.Button;
public alias Key = Keyboard.Key;

package(novelate):
/// Shows the main menu.
void showMainMenu()
{
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

  auto backgroundFrames = config.menuBackground;

  if (backgroundFrames && backgroundFrames.frames && backgroundFrames.frames.length)
  {
    string[] backgroundImages = [];

    auto frameSpeed = backgroundFrames.frames[0].nextFrameTime;

    foreach (frame; backgroundFrames.frames)
    {
      backgroundImages ~= getMediaFile(frame.image).relativePath(backgroundLayer.width);
    }

    if (backgroundImages && backgroundImages.length)
    {
      auto image = new AnimatedImage(backgroundImages);
      image.animationSpeed = frameSpeed;
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

  auto frontLayer = getLayer(LayerType.front);

  auto logoFrames = config.menuLogoImage;

  if (logoFrames && logoFrames.frames && logoFrames.frames.length)
  {
    string[] logoImages = [];

    auto frameSpeed = logoFrames.frames[0].nextFrameTime;

    foreach (frame; logoFrames.frames)
    {
      logoImages ~= getMediaFile(frame.image).relativePath(frontLayer.width);
    }

    if (logoImages && logoImages.length)
    {
      auto image = new AnimatedImage(logoImages);
      image.animationSpeed = frameSpeed;
      image.fadeIn(20);
      image.position = Vector2f(config.menuLogoImageX800, config.menuLogoImageY800);

      frontLayer.addComponent(image, "logo");
    }
  }

  AltValue!(ptrdiff_t, string) menuBoxOffsetX;
  AltValue!(ptrdiff_t, string) menuBoxOffsetY;

  if (backgroundLayer.width == 800)
  {
    menuBoxOffsetX = config.menuBox_X800;
    menuBoxOffsetY = config.menuBox_Y800;
  }
  else if (backgroundLayer.width == 1024)
  {
    menuBoxOffsetX = config.menuBox_X1024;
    menuBoxOffsetY = config.menuBox_Y1024;
  }
  else if (backgroundLayer.width == 1280)
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
        offsetX = (backgroundLayer.width / 2);
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
    changeScreen(Screen.scene, [playScene]);
  }, offsetX);

  labels ~= createLabel(config.menuItem_Load.text, (b, ref s)
  {
    changeScreen(Screen.load);
  }, offsetX);

  labels ~= createLabel(config.menuItem_Save.text, (b, ref s)
  {
    changeScreen(Screen.save);
  }, offsetX);

  labels ~= createLabel(config.menuItem_About.text, (b, ref s)
  {
    changeScreen(Screen.about);
  }, offsetX);

  labels ~= createLabel(config.menuItem_Characters.text, (b, ref s)
  {
    changeScreen(Screen.characters);
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

        offsetY = (backgroundLayer.height - totalHeight);
        break;
      case "T":
      case "Top":
        offsetY = cast(ptrdiff_t)(cast(double)labels[0].fontSize * 1.5);
        break;

      case "C":
      case "Center":
        offsetY = cast(ptrdiff_t)((backgroundLayer.height / 2) - (totalHeight / 2));
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
    label.position = Vector2f(label.x, offsetY);

    offsetY += label.height;
    offsetY += cast(size_t)(cast(double)label.fontSize * 0.5);
    getLayer(LayerType.dialogueBoxInteraction)
      .addComponent(label, to!string(label.text));
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
  label.position = Vector2f(offsetX - (label.width / 2), 50000);
  label.mouseRelease = mouseRelease;

  return label;
}
