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
import novelate.ui.component;
import novelate.ui.imagecomponent;
import novelate.ui.animatedimage;
import novelate.media;
import novelate.core : LayerType;
import novelate.config : NovelateImageAnimation;
import novelate.buildstate;

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
  /// The screen name.
  string _screenName;

  protected:
  /**
  * Creates a new screen.
  * Params:
  *   screenName = The name of the screen.
  */
  this(string screenName)
  {
    _screenName = screenName;

    foreach (_; 0 .. 10)
    {
      _layers ~= new Layer(screenName);
    }
  }

  /// Clears the old background.
  private void clearOldBackground()
  {
    {
      auto oldBackground = cast(ImageComponent)getComponent(LayerType.background, "background");

      if (oldBackground)
      {
        addComponent(LayerType.background, oldBackground, "background_old");
        removeComponent(LayerType.background, "background", false);
        oldBackground.fadeOut(20);

        static if (isManualMemory)
        {
          oldBackground.fadedOut = ()
          {
            oldBackground.clean();
          };
        }
      }
    }

    {
      auto oldBackground = cast(AnimatedImage)getComponent(LayerType.background, "background");

      if (oldBackground)
      {
        addComponent(LayerType.background, oldBackground, "background_old");
        removeComponent(LayerType.background, "background", false);
        oldBackground.fadeOut(20);

        static if (isManualMemory)
        {
          oldBackground.fadedOut = ()
          {
            oldBackground.clean();
          };
        }
      }
    }
  }

  /**
  * Updates the background with a media file.
  * Params:
  *   mediaFile = The name of the media file.
  */
  void updateBackground(string mediaFile)
  {
    clearOldBackground();

    if (!mediaFile || !mediaFile.length)
    {
      return;
    }

    auto backgroundImage = getMediaFile(mediaFile);

    if (!backgroundImage)
    {
      return;
    }

    auto image = new ImageComponent(backgroundImage.relativePath(_width));
    image.fadeIn(20);
    image.fadedIn = ()
    {
      removeComponent(LayerType.background, "background_old");
    };
    image.fullScreen = true;
    image.refresh(_width, _height);

    addComponent(LayerType.background, image, "background");
  }

  /**
  * Updates the background with an animation.
  * Params:
  *   backgroundAnimation = The background animation to update with.
  */
  void updateBackground(NovelateImageAnimation backgroundAnimation)
  {
    clearOldBackground();

    if (!backgroundAnimation || !backgroundAnimation.frames || !backgroundAnimation.frames.length)
    {
      return;
    }

    string[] backgroundImages = [];

    auto frameSpeed = backgroundAnimation.frames[0].nextFrameTime;

    foreach (frame; backgroundAnimation.frames)
    {
      backgroundImages ~= getMediaFile(frame.image).relativePath(_width);
    }

    if (!backgroundImages || !backgroundImages.length)
    {
      return;
    }

    auto image = new AnimatedImage(backgroundImages);
    image.animationSpeed = frameSpeed;
    image.fadeIn(20);
    image.fadedIn = ()
    {
      removeComponent(LayerType.background, "background_old");
    };
    image.fullScreen = true;
    image.refresh(_width, _height);

    addComponent(LayerType.background, image, "background");
  }

  package(novelate)
  {
    static if (isManualMemory)
    {
      /// Cleans the screen for its native objects.
      void clean()
      {
        foreach (layer; _layers)
        {
          layer.clean();
        }
      }
    }

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

      /// Gets the screen name.
      string name() { return _screenName; }
    }

    /**
    * Adds a component to a layer.
    * Params:
    *   index = The index of the layer to add the component to.
    *   component = The component to add.
    *   name = The name of the component. This must be unique for the layer, otherwise an existing component will be replaced.
    *   cleanOldComponent = Boolean determining whether the old component's memory should be cleaned or not. Only used if "NOVELATE_MANUALMEMORY" is enabled.
    */
    void addComponent(size_t index, Component component, string name, bool cleanOldComponent = true)
    {
      if (!_layers || index >= _layers.length)
      {
        return;
      }

      _layers[index].addComponent(component, name, cleanOldComponent);
    }

    /**
    * Removes a component from a layer.
    * Params:
    *   index = The index of the layer to remove the component from.
    *   name = The name of the component to remove.
    *   cleanOldComponent = Boolean determining whether the component's memory should be cleaned or not. Only used if "NOVELATE_MANUALMEMORY" is enabled.
    */
    void removeComponent(size_t index, string name, bool cleanOldComponent = true)
    {
      if (!_layers || index >= _layers.length)
      {
        return;
      }

      _layers[index].removeComponent(name, cleanOldComponent);
    }

    /**
    * Gets a component from a layer. You msut cast to the original component type for it to be useful.
    * Params:
    *   name = The name of the component to get.
    * Returns:
    *   The component if found, null otherwise.
    */
    Component getComponent(size_t index, string name)
    {
      if (!_layers || index >= _layers.length)
      {
        return null;
      }

      return _layers[index].getComponent(name);
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
    * Clears a layer of its components.
    * Params:
    *   index = The index of the layer.
    */
    void clear(size_t index)
    {
      if (!_layers || index >= _layers.length)
      {
        return;
      }

      _layers[index].clear();
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
        if (_screenName != _activeScreenName)
        {
          break;
        }

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
        if (_screenName != _activeScreenName)
        {
          break;
        }

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
        if (_screenName != _activeScreenName)
        {
          break;
        }

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
      import novelate.state;

      if (!_layers)
      {
        return;
      }

      foreach_reverse (layer; _layers)
      {
        if (_screenName != _activeScreenName)
        {
          break;
        }

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
        if (_screenName != _activeScreenName)
        {
          break;
        }

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
