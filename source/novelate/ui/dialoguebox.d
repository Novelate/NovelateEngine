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
* A dialogue box is the box that is used to display the dialogues.
*/
module novelate.ui.dialoguebox;

import novelate.ui.component;
import novelate.buildstate;

/// A dialogue box component.
final class DialogueBox : Component
{
  private:
  /// The rectangle shape used for the dialogue box.
  ExternalRectangleShape _rect;
  /// The color of the dialogue box.
  Paint _color;

  public:
  final:
  package (novelate)
  {
    /// Creates a new dialogue box.
    this()
    {
      super();

      _rect = new ExternalRectangleShape(FloatVector(cast(float)0, cast(float)0));
    }
  }

  @property
  {
    /// Gets the color of the dialogue box.
    Paint color() { return _color; }

    /// Sets the color of the dialogue box.
    void color(Paint newColor)
    {
      _color = newColor;

      _rect.fillColor = _color;
    }
  }

  /// See: Component.render()
  override void render(ExternalWindow window)
  {
    _rect.draw(window);
  }

  /// See: Component.refresh()
  override void refresh(size_t width, size_t height)
  {
    import novelate.config;

    if (width == 800)
    {
      super.size = FloatVector(width - (config.defaultDialogueMargin * 2), config.defaultDialogueHeight800);
    }
    else if (width == 1024)
    {
      super.size = FloatVector(width - (config.defaultDialogueMargin * 2), config.defaultDialogueHeight1024);
    }
    else if (width == 1280)
    {
      super.size = FloatVector(width - (config.defaultDialogueMargin * 2), config.defaultDialogueHeight1280);
    }

    super.position = FloatVector
    (
      (width / 2) - (super.width / 2),
      height - (super.height + config.defaultDialogueMargin)
    );
  }

  /// See: Component.updateSize()
  override void updateSize()
  {
    static if (isManualMemory)
    {
      if (_rect)
      {
        _rect.clean();
      }
    }

    _rect = new ExternalRectangleShape(FloatVector(cast(float)super.width, cast(float)super.height));
    _rect.fillColor = _color;

    updatePosition();
  }

  /// See: Component.updatePosition()
  override void updatePosition()
  {
    _rect.position = FloatVector(cast(float)super.x, cast(float)super.y);
  }

  static if (isManualMemory)
  {
    /// See: Component.clean()
    override void clean()
    {
      if (_rect)
      {
        _rect.clean();
      }
    }
  }
}
