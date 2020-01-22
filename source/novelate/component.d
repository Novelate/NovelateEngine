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
* A component is an element that can be rendered on the screen with optional event handlers etc.
*/
module novelate.component;

import dsfml.graphics : RenderWindow;
import dsfml.system : Vector2f;
import dsfml.window : Event, Keyboard, Mouse;

/// Alias for DSFML's mouse button.
public alias MouseButton = Mouse.Button;
/// Alias for DSFML's keyboard key.
public alias Key = Keyboard.Key;

/// A component.
abstract class Component
{
  private:
  /// The position.
  Vector2f _position;
  /// The size.
  Vector2f _size;

  protected:
  /// Creates a new component.
  this()
  {

  }

  /**
  * Creates a new component.
  * Params:
  *   width = The width of the component.
  *   height = The height of the component.
  */
  this(float width, float height)
  {
    _size = Vector2f(width, height);
  }

  public:
  final
  {
    @property
    {
      /// Gets the position.
      Vector2f position() { return _position; }

      /// Sets the position.
      void position(Vector2f newPosition)
      {
        _position = newPosition;

        updatePosition();
      }

      /// Gets the x coordinate.
      ptrdiff_t x() { return cast(ptrdiff_t)_position.x; }

      /// Gets the y coordinate.
      ptrdiff_t y() { return cast(ptrdiff_t)_position.y; }

      /// Gets the size.
      Vector2f size() { return _size; }

      /// Sets the size.
      void size(Vector2f newSize)
      {
        _size = newSize;

        updateSize();
      }

      /// Gets the width.
      ptrdiff_t width() { return cast(ptrdiff_t)_size.x; }

      /// Gets the height.
      ptrdiff_t height() { return cast(ptrdiff_t)_size.y; }
    }

    /**
    * Checks whether the component intersects with a specific point.
    * Params:
    *   p = The point to check.
    * Returns:
    *   True if the component intersects with the specific point, false otherwise.
    */
    bool intersect(Vector2f p)
    {
      return (p.x > this.x) &&
  			(p.x < (this.x + cast(ptrdiff_t)this.width)) &&
  			(p.y > this.y) &&
  			(p.y < (this.y + cast(ptrdiff_t)this.height));
    }

    /**
    * Updates the internal position. Use this to avoid event handling.
    * Params:
    *   position = The position to set the internal position as.
    */
    protected void updateInternalPosition(Vector2f position)
    {
      _position = position;
    }
  }

  /// Handler for global mouse press events.
  void delegate(MouseButton button, ref bool stopEvent) globalMousePress;
  /// Handler for global mouse release events.
  void delegate(MouseButton button, ref bool stopEvent) globalMouseRelease;
  /// Handler for global mouse movement events.
  void delegate(Vector2f position, ref bool stopEvent) globalMouseMove;
  /// Handler for global key press events.
  void delegate(Key key, ref bool stopEvent) globalKeyPress;
  /// Handler for global key release events.
  void delegate(Key key, ref bool stopEvent) globalKeyRelease;
  /// Handler for mouse press events.
  void delegate(MouseButton button, ref bool stopEvent) mousePress;
  /// Handler for mouse release events.
  void delegate(MouseButton button, ref bool stopEvent) mouseRelease;
  /// Handler for mouse movement events.
  void delegate(Vector2f position, ref bool stopEvent) mouseMove;
  /// Handler for key press events.
  void delegate(Key key, ref bool stopEvent) keyPress;
  /// Handler for key release events.
  void delegate(Key key, ref bool stopEvent) keyRelease;

  abstract:
  /**
  * Will render the component. Called during every frame render.
  * Params:
  *   window = The window used for rendering.
  */
  void render(RenderWindow window);
  /**
  * Refreshes the component with a given width ahd height. This is usually the layer size which is usually the window size.
  * Params:
  *   width = The width.
  *   height = The height.
  */
  void refresh(size_t width, size_t height);
  /// Called when the size of the component updates.
  void updateSize();
  /// Called when the position of the component updates.
  void updatePosition();
}
