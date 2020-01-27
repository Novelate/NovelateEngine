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
module novelate.screens.layer;

import novelate.ui.component;
import novelate.buildstate;

/// A layer of components.
final class Layer
{
  private:
  /// The screen name.
  string _screenName;
  /// The components.
  Component[string] _components;
  /// The current mouse position.
  FloatVector _mousePosition;

  public:
  final:
  package (novelate)
  {
    /**
    * Creates a new layer.
    * Params:
    *   screenName = The name of the screen.
    */
    this(string screenName)
    {
      _screenName = screenName;
    }
  }

  @property
  {
    /// Gets the amount of components within the layer.
    size_t length() { return _components ? _components.length : 0; }

    /// Gets the screen name.
    string screenName() { return _screenName; }
  }

  static if (isManualMemory)
  {
    /// Cleans the layer and all its components.
    void clean()
    {
      foreach (component; _components)
      {
        component.clean();
      }
    }
  }


  /// Clears the layer for its components.
  void clear()
  {
    if (!_components)
    {
      return;
    }

    static if (isManualMemory)
    {
      clean();
    }

    _components.clear();
  }

  /**
  * Adds a component to the layer.
  * Params:
  *   component = The component to add.
  *   name = The name of the component. This must be unique for the layer, otherwise an existing component will be replaced.
  *   cleanOldComponent = Boolean determining whether the old component's memory should be cleaned or not. Only used if "NOVELATE_MANUALMEMORY" is enabled.
  */
  void addComponent(Component component, string name, bool cleanOldComponent = true)
  {
    static if (isManualMemory)
    {
      if (cleanOldComponent && _components && name in _components)
      {
        _components[name].clean();
      }
    }

    _components[name] = component;
  }

  /**
  * Removes a component from the layer.
  * Params:
  *   name = The name of the component to remove.
  *   cleanOldComponent = Boolean determining whether the component's memory should be cleaned or not. Only used if "NOVELATE_MANUALMEMORY" is enabled.
  */
  void removeComponent(string name, bool cleanOldComponent = true)
  {
    if (!_components)
    {
      return;
    }

    static if (isManualMemory)
    {
      if (cleanOldComponent && _components && name in _components)
      {
        _components[name].clean();
      }
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
    if (!_components)
    {
      return;
    }

    foreach (k,v; _components)
    {
      v.refresh(width, height);
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
      import novelate.state : _activeScreenName;

      if (_screenName != _activeScreenName)
      {
        break;
      }

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
      import novelate.state : _activeScreenName;

      if (_screenName != _activeScreenName)
      {
        break;
      }

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
      import novelate.state : _activeScreenName;

      if (_screenName != _activeScreenName)
      {
        break;
      }

      if (v.globalMousePress)
      {
        v.globalMousePress(button, stopEvent);

        if (stopEvent)
        {
          break;
        }
      }

      auto mousePosX = ExternalEventState.mouseMoveEvent.x;
      auto mousePosY = ExternalEventState.mouseMoveEvent.y;

      if (v.mousePress && v.intersect(FloatVector(mousePosX, mousePosY)))
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
    import novelate.state;

    if (!_components)
    {
      return;
    }

    foreach (k,v; _components)
    {
      import novelate.state : _activeScreenName;

      if (_screenName != _activeScreenName)
      {
        break;
      }

      if (v.globalMouseRelease)
      {
        v.globalMouseRelease(button, stopEvent);

        if (stopEvent)
        {
          break;
        }
      }

      auto mousePosX = ExternalEventState.mouseMoveEvent.x;
      auto mousePosY = ExternalEventState.mouseMoveEvent.y;

      if (v.mouseRelease && v.intersect(FloatVector(mousePosX, mousePosY)))
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
  *   mousePosition = The mouse position.
  *   stopEvent = (ref) Boolean determining whether the event handling should no longer be delegated.
  */
  void mouseMove(FloatVector mousePosition, ref bool stopEvent)
  {
    _mousePosition = mousePosition;

    if (!_components)
    {
      return;
    }

    foreach (k,v; _components)
    {
      import novelate.state : _activeScreenName;

      if (_screenName != _activeScreenName)
      {
        break;
      }

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
