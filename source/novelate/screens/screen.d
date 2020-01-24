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
* This module handles the screen which is a container of layers with components.
*/
module novelate.screens.screen;

import novelate.state;
import novelate.screens.layer;
import novelate.external;
import novelate.events;

/// A screen.
abstract class Screen
{
  private:
  /// The layers of the screen.
  Layer[] _layers;
  /// The width of the screen. Usually the resolution width.
  size_t _width;
  /// The height of the screen. Usually the resolution height.
  size_t _height;
  /// The current mouse position within the window.
  FloatVector _mousePosition;

  protected:
  /// Creates a new screen.
  this()
  {
    foreach (_; 0 .. 10)
    {
      _layers ~= new Layer;
    }
  }

  package(novelate)
  {
    /**
    * Sets the width and height of the screen.
    * Params:
    *   width = The width.
    *   height = The height.
    */
    void setWidthAndHeight(size_t width, size_t height)
    {
      _width = width;
      _height = height;
    }

    /// Clears all layer components except for the background.
    void clearAllLayersButBackground()
    {
      if (!_layers || !_layers.length)
      {
        return;
      }

      foreach (i; 1 .. _layers.length)
      {
        _layers[i].clear();
      }

      fireEvent!(EventType.onClearingAllLayersButBackground);
    }
  }

  public:
  /**
  * A function that tells the engine whether the screen should clear layers before updating and becoming active.
  * Params:
  *   data = The data passed to the screen. Use the data to validate only.
  * Returns:
  *   True if the screen should clear layers, false otherwise. (Defaults to true when not override.)
  */
  bool shouldClearLayers(string[] data)
  {
    return true;
  }

  final
  {
    @property
    {
      /// Gets the width of the screen. Usually the resolution width.
      size_t width() { return _width; }

      /// Gets the height of the screen. Usually the resolution height.
      size_t height() { return _height; }
    }

    /**
    * Gets a layer of the screen.
    * Params:
    *   index = The index of the layer.
    * Returns:
    *   The layer if present at the index given, null otherwise.
    */
    Layer getLayer(size_t index)
    {
      if (!_layers || index >= _layers.length)
      {
        return null;
      }

      return _layers[index];
    }

    /**
    * Will render the screen, its layers and their components.
    * Params:
    *   window = The window to render at.
    */
    void render(ExternalWindow window)
    {
      if (!window)
      {
        return;
      }

      if (!_layers)
      {
        return;
      }

      foreach (layer; _layers)
      {
        layer.render(_window);
      }
    }

    /**
    * Refreshes the screen and its layers and their components with a given width and height. Usually the resolution width and height.
    * Params:
    *   width = The width to refresh with.
    *   height = The height to refresh with.
    */
    void refresh(size_t width, size_t height)
    {
      _width = width;
      _height = height;

      if (!_layers)
      {
        return;
      }

      foreach (layer; _layers)
      {
        layer.refresh(_width, _height);
      }
    }

    /**
    * Handles key press events and delegates them to its layers.
    * Params:
    *   key = The key pressed.
    */
    void keyPress(KeyboardKey key)
    {
      if (!_layers)
      {
        return;
      }

      foreach_reverse (layer; _layers)
      {
        bool stopEvent;
        layer.keyPress(key, stopEvent);

        if (stopEvent)
        {
          return;
        }
      }
    }

    /**
    * Handles key release events and delegates them to its layers.
    * Params:
    *   key = The key released.
    */
    void keyRelease(KeyboardKey key)
    {
      if (!_layers)
      {
        return;
      }

      foreach_reverse (layer; _layers)
      {
        bool stopEvent;
        layer.keyRelease(key, stopEvent);

        if (stopEvent)
        {
          return;
        }
      }
    }

    /**
    * Handles mouse button press events and delegates them to its layers.
    * Params:
    *   button = The mouse button pressed.
    */
    void mousePress(MouseButton button)
    {
      if (!_layers)
      {
        return;
      }

      foreach_reverse (layer; _layers)
      {
        bool stopEvent;
        layer.mousePress(button, stopEvent);

        if (stopEvent)
        {
          return;
        }
      }
    }

    /**
    * Handles mouse button release events and delegates them to its layers.
    * Params:
    *   button = The mouse button released.
    */
    void mouseRelease(MouseButton button)
    {
      if (!_layers)
      {
        return;
      }

      foreach_reverse (layer; _layers)
      {
        bool stopEvent;
        layer.mouseRelease(button, stopEvent);

        if (stopEvent)
        {
          return;
        }
      }
    }

    /**
    * Handles mouse move events and delegates them to its layers.
    * Params:
    *   x = The x coordinate of the mouse cursor.
    *   y = The y coordinate of the mouse cursor.
    */
    void mouseMove(ptrdiff_t x, ptrdiff_t y)
    {
      _mousePosition = FloatVector(x, y);

      if (!_layers)
      {
        return;
      }

      foreach_reverse (layer; _layers)
      {
        bool stopEvent;
        layer.mouseMove(_mousePosition, stopEvent);

        if (stopEvent)
        {
          return;
        }
      }
    }
  }

  abstract:
  /**
  * Updates the screen with data.
  * Params:
  *   data = The data to update the screen with.
  */
  void update(string[] data);
}
