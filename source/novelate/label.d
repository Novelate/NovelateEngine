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
* A label is a simple component for displaying text.
*/
module novelate.label;

import std.datetime;

import dsfml.graphics : Text, RenderWindow, Color;
import dsfml.system : Vector2f;

import novelate.component;
import novelate.fonts;
import novelate.config;

/// Wrapper around a label component.
final class Label : Component
{
  private:
  /// The text component.
  Text _textComponent;
  /// The text.
  dstring _text;
  /// The font name.
  string _fontName;
  /// The font.
  Font _font;
  /// The font size.
  uint _fontSize;
  /// The color.
  Color _color;

  public:
  final:
  /// Creates a new label.
  this()
  {
    super();

    _fontName = config.defaultFont;
    _font = retrieveFont(_fontName, FontStyle.normal);
    _fontSize = config.defaultFontSize;

    _textComponent = new Text();
    _textComponent.setFont(_font);
    _textComponent.setString("");
    _textComponent.setCharacterSize(_fontSize);
  }

  @property
  {
    /// Gets the text.
    dstring text() { return _text; }

    /// Sets the text.
    void text(dstring newText)
    {
      _text = newText;

      _textComponent.setString(_text);

      auto bounds = _textComponent.getLocalBounds();

      super.size = Vector2f(bounds.width, bounds.height);
    }

    /// Gets the font name.
    string fontName() { return _fontName; }

    /// Sets the font name.
    void fontName(string newFontName)
    {
      _fontName = newFontName;

      _font = retrieveFont(_fontName, FontStyle.normal);
      _textComponent.setFont(_font);
    }

    /// Gets the font size.
    uint fontSize() { return _fontSize; }

    /// Sets the font size.
    void fontSize(uint newFontSize)
    {
      _fontSize = newFontSize;

      _textComponent.setCharacterSize(_fontSize);
    }

    /// Gets the color.
    Color color() { return _color; }

    /// Sets the color.
    void color(Color newColor)
    {
      _color = newColor;

      _textComponent.setColor(_color);
    }
  }

  /// See: Component.render()
  override void render(RenderWindow window)
  {
    window.draw(_textComponent);
  }

  /// See: Component.refresh()
  override void refresh(size_t width, size_t height)
  {
    size_t boxHeight;
    if (width == 800)
    {
      boxHeight = config.defaultDialogueHeight800;
    }
    else if (width == 1024)
    {
      boxHeight = config.defaultDialogueHeight1024;
    }
    else if (width == 1280)
    {
      boxHeight = config.defaultDialogueHeight1280;
    }

    _textComponent.position = Vector2f(config.defaultDialogueMargin + config.defaultDialoguePadding, ((height + config.defaultDialoguePadding) - boxHeight));

    updateInternalPosition(_textComponent.position);
  }

  /// See: Component.updateSize()
  override void updateSize()
  {
  }

  /// See: Component.updatePosition()
  override void updatePosition()
  {
    _textComponent.position = super.position;
  }
}
