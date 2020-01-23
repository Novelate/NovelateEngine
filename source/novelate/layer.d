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
* A layer consists of multiple components that have equal importance in terms of rendering and event delegation.
*/
module novelate.layer;

import novelate.component;

/// A layer of components.
final class Layer
{
  private:
  /// The components.
  Component[string] _components;
  /// The width of the layer. Usually the resolution width.
  size_t _width;
  /// The height of the layer. Usually the resolution height.
  size_t _height;
  /// The current mouse position within the window.
  FloatVector _mousePosition;

  public:
  final:
  package (novelate)
  {
    /**
    * Creates a new layer.
    * Params:
    *   width = The width of the layer.
    *   height = The height of the layer.
    */
    this(size_t width, size_t height)
    {
      _width = width;
      _height = height;
    }
  }

  @property
  {
    /// Gets the width of the layer. Usually the resolution width.
    size_t width() { return _width; }

    /// Gets the height of the layer. Usually the resolution height.
    size_t height() { return _height; }

    /// Gets the amount of components within the layer.
    size_t length() { return _components ? _components.length : 0; }
  }

  /// Clears the layer for its components.
  void clear()
  {
    if (!_components)
    {
      return;
    }

    _components.clear();
  }

  /**
  * Adds a component to the layer.
  * Params:
  *   component = The component to add.
  *   name = The name of the component. This must be unique for the layer, otherwise an existing component will be replaced.
  */
  void addComponent(Component component, string name)
  {
    _components[name] = component;
  }

  /**
  * Removes a component from the layer.
  * Params:
  *   name = The name of the component to remove.
  */
  void removeComponent(string name)
  {
    if (!_components)
    {
      return;
    }

    _components.remove(name);
  }

  /**
  * Gets a component from the layer. You msut cast to the original component type for it to be useful.
  * Params:
  *   name = The name of the component to get.
  * Returns:
  *   The component if found, null otherwise.
  */
  Component getComponent(string name)
  {
    if (!_components)
    {
      return null;
    }

    return _components.get(name, null);
  }

  /**
  * Will render the components of the layer to the given window.
  * Params:
  *   window = The window to render the components at.
  */
  void render(ExternalWindow window)
  {
    if (!window)
    {
      return;
    }

    if (!_components)
    {
      return;
    }

    foreach (k,v; _components)
    {
      v.render(window);
    }
  }

  /**
  * Refreshes the layer and its components with a given width and height. Usually the resolution width and height.
  * Params:
  *   width = The width to refresh with.
  *   height = The height to refresh with.
  */
  void refresh(size_t width, size_t height)
  {
    _width = width;
    _height = height;

    if (!_components)
    {
      return;
    }

    foreach (k,v; _components)
    {
      v.refresh(_width, _height);
    }
  }

  /**
  * Handles key press events and delegates them to its components.
  * Params:
  *   key = The key pressed.
  *   stopEvent = (ref) Boolean determining whether the event handling should no longer be delegated.
  */
  void keyPress(KeyboardKey key, ref bool stopEvent)
  {
    if (!_components)
    {
      return;
    }

    foreach (k,v; _components)
    {
      if (v.globalKeyPress)
      {
        v.globalKeyPress(key, stopEvent);

        if (stopEvent)
        {
          break;
        }
      }

      if (v.keyPress && v.intersect(_mousePosition))
      {
        v.keyPress(key, stopEvent);

        if (stopEvent)
        {
          break;
        }
      }
    }
  }

  /**
  * Handles key release events and delegates them to its components.
  * Params:
  *   key = The key released.
  *   stopEvent = (ref) Boolean determining whether the event handling should no longer be delegated.
  */
  void keyRelease(KeyboardKey key, ref bool stopEvent)
  {
    if (!_components)
    {
      return;
    }

    foreach (k,v; _components)
    {
      if (v.globalKeyRelease)
      {
        v.globalKeyRelease(key, stopEvent);

        if (stopEvent)
        {
          break;
        }
      }

      if (v.keyRelease && v.intersect(_mousePosition))
      {
        v.keyRelease(key, stopEvent);

        if (stopEvent)
        {
          break;
        }
      }
    }
  }

  /**
  * Handles mouse button press events and delegates them to its components.
  * Params:
  *   button = The mouse button pressed.
  *   stopEvent = (ref) Boolean determining whether the event handling should no longer be delegated.
  */
  void mousePress(MouseButton button, ref bool stopEvent)
  {
    if (!_components)
    {
      return;
    }

    foreach (k,v; _components)
    {
      if (v.globalMousePress)
      {
        v.globalMousePress(button, stopEvent);

        if (stopEvent)
        {
          break;
        }
      }

      if (v.mousePress && v.intersect(_mousePosition))
      {
        v.mousePress(button, stopEvent);

        if (stopEvent)
        {
          break;
        }
      }
    }
  }

  /**
  * Handles mouse button release events and delegates them to its components.
  * Params:
  *   button = The mouse button released.
  *   stopEvent = (ref) Boolean determining whether the event handling should no longer be delegated.
  */
  void mouseRelease(MouseButton button, ref bool stopEvent)
  {
    if (!_components)
    {
      return;
    }

    foreach (k,v; _components)
    {
      if (v.globalMouseRelease)
      {
        v.globalMouseRelease(button, stopEvent);

        if (stopEvent)
        {
          break;
        }
      }

      if (v.mouseRelease && v.intersect(_mousePosition))
      {
        v.mouseRelease(button, stopEvent);

        if (stopEvent)
        {
          break;
        }
      }
    }
  }

  /**
  * Handles mouse move events and delegates them to its components.
  * Params:
  *   x = The x coordinate of the mouse cursor.
  *   y = The y coordinate of the mouse cursor.
  *   stopEvent = (ref) Boolean determining whether the event handling should no longer be delegated.
  */
  void mouseMove(ptrdiff_t x, ptrdiff_t y, ref bool stopEvent)
  {
    _mousePosition = FloatVector(x, y);

    if (!_components)
    {
      return;
    }

    foreach (k,v; _components)
    {
      if (v.globalMouseMove)
      {
        v.globalMouseMove(_mousePosition, stopEvent);

        if (stopEvent)
        {
          break;
        }
      }

      if (v.mouseMove && v.intersect(_mousePosition))
      {
        v.mouseMove(_mousePosition, stopEvent);

        if (stopEvent)
        {
          break;
        }
      }
    }
  }
}
