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
* This module is used for external bindings to dsfml. Types and functions should only be exposed through internal types ex. RenderWindow is only referenced through ExternalWindow.
* This is the main module for external bindings and all possible bindings should reference this module in terms of implementation.
*/
module novelate.dsfmlbinding;

import novelate.buildstate;

static if (useSFML && !useDerelict)
{
  import novelate.external.core;

  private
  {
    import dsfml.graphics;
    import dsfml.window;
    import dsfml.audio;
    import dsfml.system;
    import dsfml.network;
  }

  /// Initialization of the external binding.
  void initExternalBinding()
  {

  }

  /// FloatVector -> Vector2f
  Vector2f toNative(FloatVector vector)
  {
    return Vector2f(vector.x, vector.y);
  }

  /// UintVector -> Vector2u
  Vector2u toNative(UintVector vector)
  {
    return Vector2u(vector.x, vector.y);
  }

  /// IntVector -> Vector2i
  Vector2i toNative(IntVector vector)
  {
    return Vector2i(vector.x, vector.y);
  }

  /// Vector2f -> FloatVector
  FloatVector fromNative(Vector2f vector)
  {
    return FloatVector(vector.x, vector.y);
  }

  /// Vector2u -> UintVector
  UintVector fromNative(Vector2u vector)
  {
    return UintVector(vector.x, vector.y);
  }

  /// Vector2i -> IntVector
  IntVector fromNative(Vector2i vector)
  {
    return IntVector(vector.x, vector.y);
  }

  /// Paint -> Color
  Color toNative(Paint paint)
  {
    return Color(paint.r, paint.g, paint.b, paint.a);
  }

  /// Color -> Paint
  Paint fromNative(Color color)
  {
    return Paint(color.r, color.g, color.b, color.a);
  }

  /// KeyboardKey -> Keyboard.Key
  Keyboard.Key toNative(KeyboardKey key)
  {
    return cast(Keyboard.Key)key;
  }

  /// KeyboardKey -> Keyboard.Key
  KeyboardKey fromNative(Keyboard.Key key)
  {
    return cast(KeyboardKey)key;
  }

  /// MouseButton -> Mouse.Button
  Mouse.Button toNative(MouseButton button)
  {
    return cast(Mouse.Button)button;
  }

  /// Mouse.Button -> MouseButton
  MouseButton fromNative(Mouse.Button button)
  {
    return cast(MouseButton)button;
  }

  /// IExternalDrawableComponent
  interface IExternalDrawableComponent
  {
    /// draw()
    void draw(ExternalWindow window);
  }

  /// ExternalImage
  final class ExternalImage : IExternalDrawableComponent
  {
    private:
    /// _image
    Image _image;
    /// _texture
    Texture _texture;
    /// _sprite
    Sprite _sprite;

    public:
    /// this()
    this()
    {
    }

    /// loadFromFile()
    void loadFromFile(string path)
    {
      _image = new Image;
      _image.loadFromFile(path);
      _texture = new Texture;
      _texture.loadFromImage(_image);
  		_texture.setSmooth(true);
      _sprite = new Sprite(_texture);
    }

    @property
    {
      /// Gets bounds.
      FloatVector bounds()
      {
        auto localBounds = _sprite.getLocalBounds();

        return FloatVector(localBounds.width, localBounds.height);
      }

      /// Gets size.
      UintVector size()
      {
        return _image.getSize().fromNative();
      }

      /// Gets position.
      FloatVector position()
      {
        return _sprite.position.fromNative();
      }

      /// Sets position.
      void position(FloatVector newPosition)
      {
        _sprite.position = newPosition.toNative();
      }

      /// Gets color.
      Paint color()
      {
        return _sprite.color.fromNative();
      }

      /// Sets color.
      void color(Paint newColor)
      {
        _sprite.color = newColor.toNative();
      }

      /// Gets scale.
      FloatVector scale()
      {
        return _sprite.scale.fromNative();
      }

      /// Sets scale.
      void scale(FloatVector newScale)
      {
        _sprite.scale = newScale.toNative();
      }
    }

    /// draw()
    void draw(ExternalWindow window)
    {
      window._window.draw(_sprite);
    }
  }

  /// ExternalWindow.
  final class ExternalWindow
  {
    private:
    /// _window.
    RenderWindow _window;
    /// _fps.
    uint _fps;

    public:
    @property
    {
      /// Gets isOpen.
      bool isOpen() { return _window.isOpen(); }

      /// Gets fps.
      uint fps() { return _fps; }

      /// Sets fps.
      void fps(uint newFps)
      {
        _fps = newFps;

        _window.setFramerateLimit(_fps);
      }

      bool canUpdate()
      {
        return true;
      }
    }

    /// close()
    void close()
    {
      _window.close();
    }

    /// render()
    void render()
    {
      _window.display();
    }

    /// clear()
    void clear(Paint paint)
    {
      _window.clear(paint.toNative());
    }

    /// processEvents()
    bool processEvents(ExternalEventManager eventManager)
    {
      Event e;
      while(_window.pollEvent(e))
      {
        auto res = _window.pollEvent(e);

        switch (e.type)
        {
          case Event.EventType.Closed:
            eventManager.fireEvent(cast(ExternalEventType)e.type);
            return false;

          case Event.EventType.Resized:
            ExternalEventState._sizeEvent = cast(ExternalSizeEvent)e.size;
            break;

          case Event.EventType.TextEntered:
            ExternalEventState._textEvent = cast(ExternalTextEvent)e.text;
            break;

          case Event.EventType.KeyPressed:
          case Event.EventType.KeyReleased:
            ExternalEventState._keyEvent = cast(ExternalKeyEvent)e.key;
            break;

          case Event.EventType.MouseWheelMoved:
            ExternalEventState._mouseWheelEvent = cast(ExternalMouseWheelEvent)e.mouseWheel;
            break;

          case Event.EventType.MouseButtonPressed:
          case Event.EventType.MouseButtonReleased:
            ExternalEventState._mouseButtonEvent = cast(ExternalMouseButtonEvent)e.mouseButton;
            break;

          case Event.EventType.MouseMoved:
            ExternalEventState._mouseMoveEvent = cast(ExternalMouseMoveEvent)e.mouseMove;
            break;

          case Event.EventType.JoystickButtonPressed:
          case Event.EventType.JoystickButtonReleased:
            ExternalEventState._joystickButtonEvent = cast(ExternalJoystickButtonEvent)e.joystickButton;
            break;

          case Event.EventType.JoystickMoved:
            ExternalEventState._joystickMoveEvent = cast(ExternalJoystickMoveEvent)e.joystickMove;
            break;

          case Event.EventType.JoystickConnected:
          case Event.EventType.JoystickDisconnected:
            ExternalEventState._joystickConnectEvent = cast(ExternalJoystickConnectEvent)e.joystickConnect;
            break;

          default: break;
        }

        eventManager.fireEvent(cast(ExternalEventType)e.type);
      }

      return true;
    }

    static:
    /// create()
    ExternalWindow create(string title, size_t width, size_t height, bool fullScreen)
    {
      auto videoMode = VideoMode(cast(int)width, cast(int)height);
      ContextSettings context;
      context.antialiasingLevel = 100;

      RenderWindow renderWindow;
      if (fullScreen)
      {
        renderWindow = new RenderWindow(videoMode, title, (Window.Style.Fullscreen), context);
      }
      else
      {
        renderWindow = new RenderWindow(videoMode, title, (Window.Style.Titlebar | Window.Style.Close), context);
      }

      auto window = new ExternalWindow;
      window._window = renderWindow;
      return window;
    }
  }

  /// ExternalRectangleShape
  final class ExternalRectangleShape : IExternalDrawableComponent
  {
    private:
    /// _rect
    RectangleShape _rect;

    public:
    final:
    /// this()
    this(FloatVector size)
    {
      _rect = new RectangleShape(size.toNative());
    }

    @property
    {
      /// Gets fillColor
      Paint fillColor()
      {
        return _rect.fillColor.fromNative();
      }

      /// Sets fillColor
      void fillColor(Paint newColor)
      {
        _rect.fillColor = newColor.toNative();
      }

      /// Gets position
      FloatVector position()
      {
        return _rect.position.fromNative();
      }

      /// Sets position
      void position(FloatVector newPosition)
      {
        _rect.position = newPosition.toNative();
      }
    }

    /// draw()
    void draw(ExternalWindow window)
    {
      window._window.draw(_rect);
    }
  }

  /// ExternalText
  final class ExternalText : IExternalDrawableComponent
  {
    private:
    /// _text
    Text _text;

    public:
    final:
    /// this()
    this()
    {
      _text = new Text();
    }

    @property
    {
      /// Gets bounds.
      FloatVector bounds()
      {
        auto localBounds = _text.getLocalBounds();

        return FloatVector(localBounds.width, localBounds.height);
      }

      /// Gets position.
      FloatVector position()
      {
        return _text.position.fromNative();
      }

      /// Sets position.
      void position(FloatVector newPosition)
      {
        _text.position = newPosition.toNative();
      }
    }

    /// setFont()
    void setFont(ExternalFont font)
    {
      _text.setFont(font._font);
    }

    /// setString()
    void setString(dstring text)
    {
      _text.setString(text);
    }

    /// setCharacterSize()
    void setCharacterSize(size_t characterSize)
    {
      _text.setCharacterSize(cast(uint)characterSize);
    }

    /// setColor()
    void setColor(Paint newColor)
    {
      _text.setColor(newColor.toNative());
    }

    /// draw()
    void draw(ExternalWindow window)
    {
      window._window.draw(_text);
    }
  }

  /// ExternalFont
  final class ExternalFont
  {
    private:
    /// _font
    Font _font;

    public:
    final:
    /// this()
    this()
    {
      _font = new Font;
    }

    /// loadFromFile()
    void loadFromFile(string path)
    {
      _font.loadFromFile(path);
    }
  }

  /// ExternalMusic
  final class ExternalMusic
  {
    private:
    /// _music
    Music _music;

    public:
    final:
    /// this()
    this()
    {
      _music = new Music();
    }

    @property
    {
      /// Gets looping
      bool looping()
      {
        return _music.isLooping;
      }

      /// Sets looping
      void looping(bool isLooping)
      {
        _music.isLooping = isLooping;
      }
    }

    /// openFromFile()
    bool openFromFile(string music)
    {
      return _music.openFromFile(music);
    }

    /// play()
    void play()
    {
      _music.play();
    }

    /// pause()
    void pause()
    {
      _music.pause();
    }

    /// stop()
    void stop()
    {
      _music.stop();
    }
  }

  /// quit()
  void quit()
  {

  }
}
