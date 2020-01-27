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
* A timed text component is useful for displaying text that is rendered over time looking like an automated typing animation.
*/
module novelate.ui.timedtext;

import novelate.ui.component;
import novelate.ui.textwrap;
import novelate.fonts;
import novelate.config;
import novelate.queue;
import novelate.buildstate;

/// Alias for delegate handler.
private alias _DELEGATE = void delegate(MouseButton button, ref bool stopEvent);

/// Wrapper around timed text, which is text that is gradually rendered over time.
final class TimedText : Component
{
  private:
  /// The text component.
  ExternalText _textComponent;
  /// The original text without wrapping.
  dstring _originalText;
  /// The text with wrapping.
  dstring _text;
  /// The text count.
  size_t _textCount;
  /// The original text speed.
  size_t _originalTextSpeed;
  /// The text speed.
  size_t _textSpeed;
  /// The font name.
  string _fontName;
  /// The font.
  ExternalFont _font;
  /// The font size.
  size_t _fontSize;
  /// The box width.
  size_t _boxWidth;
  /// Boolean determining whether the text has finished rendering.
  bool _hasFinished;
  /// The color.
  Paint _color;
  /// Boolean determining whether shift is held or not.
  bool _shiftHeld;

  public:
  final:
  /// Creates a new timed text component.
  this()
  {
    super();

    globalMouseReleaseTextFinished = new Queue!_DELEGATE;

    _fontName = config.defaultFont;
    _font = retrieveFont(_fontName, FontStyle.normal);
    _fontSize = config.defaultFontSize;

    _textComponent = new ExternalText;
    _textComponent.setFont(_font);
    _textComponent.setString("");
    _textComponent.setCharacterSize(_fontSize);

    _textCount = 1;
    _textSpeed = 1;

    super.globalKeyPress = (k, ref s)
    {
      if (k == KeyboardKey.LShift)
      {
        _originalTextSpeed = _textSpeed;

        _textSpeed *= 3;

        _shiftHeld = true;
      }
    };

    super.globalKeyRelease = (k, ref s)
    {
      if (k == KeyboardKey.returnKey || k == KeyboardKey.space)
      {
        super.globalMouseRelease(MouseButton.left, s);
      }
      else if (k == KeyboardKey.LShift)
      {
        _textSpeed = _originalTextSpeed;

        _shiftHeld = false;
      }
    };

    super.globalMouseRelease = (b, ref s)
    {
      if (b != MouseButton.left)
      {
        return;
      }

      if (_hasFinished)
      {
        if (globalMouseReleaseTextFinished.has)
        {
          auto action = globalMouseReleaseTextFinished.dequeue();

          if (action)
          {
            action(b, s);
          }
        }
      }
      else
      {
        if (!_text || !_text.length)
        {
          return;
        }

        _textComponent.setString(_text);
        _textCount = _text.length;
        _hasFinished = true;
      }
    };
  }

  /// A queue of handlers for when the text has finished rendering by mouse release.
  Queue!_DELEGATE globalMouseReleaseTextFinished;

  @property
  {
    /// Gets the text.
    dstring text() { return _text; }

    /// Sets the text.
    void text(dstring newText)
    {
      _originalText = newText;

      _text = wrapableText(_originalText, _fontName, _fontSize, _boxWidth);

      _textCount = 1;
      _hasFinished = false;
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
    size_t fontSize() { return _fontSize; }

    /// Sets the font size.
    void fontSize(size_t newFontSize)
    {
      _fontSize = newFontSize;

      _textComponent.setCharacterSize(_fontSize);
    }

    /// Gets the color.
    Paint color() { return _color; }

    /// Sets the color.
    void color(Paint newColor)
    {
      _color = newColor;

      _textComponent.setColor(_color);
    }

    /// Gets the text speed.
    size_t textSpeed() { return _textSpeed; }

    /// Sets the text speed.
    void textSpeed(size_t newTextSpeed)
    {
      _textSpeed = newTextSpeed;
      _originalTextSpeed = _textSpeed;

      if (_shiftHeld)
      {
        _textSpeed *= 3;
      }
    }
  }

  /// Fps counter for when the text is rendering.
  private size_t _fpsCounter = 0;

  /// See: Component.render()
  override void render(ExternalWindow window)
  {
    if (!_hasFinished)
    {
      _fpsCounter++;

      if (_fpsCounter >= 2)
      {
        _fpsCounter = 0;

        if (_text && _text.length)
        {
          if (_textCount > _text.length)
          {
            _textCount = _text.length;
          }

          _textComponent.setString(_text[0 .. _textCount]);

          _textCount += _textSpeed;

          _hasFinished = _textCount >= _text.length;

          if (_hasFinished)
          {
            _textComponent.setString(_text);
          }
        }
      }
    }

    _textComponent.draw(window);
  }

  /// See: Component.refresh()
  override void refresh(size_t width, size_t height)
  {
    _boxWidth = width;
    _boxWidth -= ((config.defaultDialoguePadding * 2) + (config.defaultDialogueMargin * 2));

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

     boxHeight -= cast(size_t)(cast(double)config.defaultDialogueNameFontSize * 1.5);

    _textComponent.position = FloatVector(config.defaultDialogueMargin + config.defaultDialoguePadding, ((height + config.defaultDialoguePadding) - boxHeight));

    _text = wrapableText(_originalText, _fontName, _fontSize, _boxWidth);

    if (_text && _text.length)
    {
      if (_hasFinished)
      {
        _textComponent.setString(_text);
      }
      else
      {
        if (_textCount > _text.length)
        {
          _textCount = _text.length;
        }

        _textComponent.setString(_text[0 .. _textCount]);
      }
    }

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

  static if (isManualMemory)
  {
    /// See: Component.clean()
    override void clean()
    {
      if (_textComponent)
      {
        _textComponent.clean();
      }
    }
  }
}
