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
module novelate.dialoguebox;

import dsfml.graphics : RectangleShape, Color, RenderWindow;
import dsfml.system : Vector2f;

import novelate.component;

/// A dialogue box component.
final class DialogueBox : Component
{
  private:
  /// The rectangle shape used for the dialogue box.
  RectangleShape _rect;
  /// The color of the dialogue box.
  Color _color;

  public:
  final:
  package (novelate)
  {
    /// Creates a new dialogue box.
    this()
    {
      super();

      _rect = new RectangleShape(Vector2f(cast(float)0, cast(float)0));
    }
  }

  @property
  {
    /// Gets the color of the dialogue box.
    Color color() { return _color; }

    /// Sets the color of the dialogue box.
    void color(Color newColor)
    {
      _color = newColor;

      _rect.fillColor = _color;
    }
  }

  /// See: Component.render()
  override void render(RenderWindow window)
  {
    window.draw(_rect);
  }

  /// See: Component.refresh()
  override void refresh(size_t width, size_t height)
  {
    import novelate.config;

    if (width == 800)
    {
      super.size = Vector2f(width - (config.defaultDialogueMargin * 2), config.defaultDialogueHeight800);
    }
    else if (width == 1024)
    {
      super.size = Vector2f(width - (config.defaultDialogueMargin * 2), config.defaultDialogueHeight1024);
    }
    else if (width == 1280)
    {
      super.size = Vector2f(width - (config.defaultDialogueMargin * 2), config.defaultDialogueHeight1280);
    }

    super.position = Vector2f
    (
      (width / 2) - (super.width / 2),
      height - (super.height + config.defaultDialogueMargin)
    );
  }

  /// See: Component.updateSize()
  override void updateSize()
  {
    _rect = new RectangleShape(Vector2f(cast(float)super.width, cast(float)super.height));
    _rect.fillColor = _color;

    updatePosition();
  }

  /// See: Component.updatePosition()
  override void updatePosition()
  {
    _rect.position = Vector2f(cast(float)super.x, cast(float)super.y);
  }
}
