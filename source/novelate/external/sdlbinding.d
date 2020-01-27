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
* This module is used for external bindings to SDL. Types and functions should only be exposed through internal types ex. SDL_Texture is only referenced through ex. ExternalImage.
* This module must always have public members exposed equally to the module: novelate.external.dsfmlbinding
*/
module novelate.sdlbinding;

import novelate.buildstate;

static if (useSDL && useDerelict)
{
  public import std.string : toStringz;
  import std.conv : to;
  import std.array : replace, split;
  import std.traits : isSomeString;
  import std.process : thisThreadID;

  import novelate.external.core;
  import novelate.config;
  import novelate.ui.textwrap;

  private
  {
    import derelict.sdl2.sdl;
    import derelict.sdl2.image;
    import derelict.sdl2.mixer;
    import derelict.sdl2.ttf;
    import derelict.sdl2.net;
  }

  /// Initialization of the external binding.
  void initExternalBinding()
  {
    DerelictSDL2.load();
    DerelictSDL2Image.load();
    DerelictSDL2Mixer.load();
    DerelictSDL2ttf.load();
    DerelictSDL2Net.load();

    TTF_Init();
  }

  /// Paint -> SDL_Color
  SDL_Color toNative(Paint paint)
  {
    return SDL_Color(paint.r, paint.g, paint.b, paint.a);
  }

  /// SDL_Color -> Paint
  Paint fromNative(SDL_Color color)
  {
    return Paint(color.r, color.g, color.b, color.a);
  }

  /// KeyboardKey -> SDL_Keycode
  SDL_Keycode toNative(KeyboardKey key)
  {
    switch (key)
    {
      case KeyboardKey.num0:
        return SDL_Keycode.SDLK_0;
      case KeyboardKey.num1:
        return SDL_Keycode.SDLK_1;
      case KeyboardKey.num2:
        return SDL_Keycode.SDLK_2;
      case KeyboardKey.num3:
        return SDL_Keycode.SDLK_3;
      case KeyboardKey.num4:
        return SDL_Keycode.SDLK_4;
      case KeyboardKey.num5:
        return SDL_Keycode.SDLK_5;
      case KeyboardKey.num6:
        return SDL_Keycode.SDLK_6;
      case KeyboardKey.num7:
        return SDL_Keycode.SDLK_7;
      case KeyboardKey.num8:
        return SDL_Keycode.SDLK_8;
      case KeyboardKey.num9:
        return SDL_Keycode.SDLK_9;
      case KeyboardKey.LControl:
        return SDL_Keycode.SDLK_LCTRL;
      case KeyboardKey.LShift:
        return SDL_Keycode.SDLK_LSHIFT;
      case KeyboardKey.LAlt:
        return SDL_Keycode.SDLK_LALT;
      case KeyboardKey.RControl:
        return SDL_Keycode.SDLK_RCTRL;
      case KeyboardKey.RShift:
        return SDL_Keycode.SDLK_RSHIFT;
      case KeyboardKey.RAlt:
        return SDL_Keycode.SDLK_RALT;
      case KeyboardKey.escape:
        return SDL_Keycode.SDLK_ESCAPE;
      case KeyboardKey.returnKey:
        return SDL_Keycode.SDLK_RETURN;
      case KeyboardKey.tab:
        return SDL_Keycode.SDLK_TAB;

      default: return cast(SDL_Keycode)'\0';
    }
  }

  /// SDL_Keycode -> KeyboardKey
  KeyboardKey fromNative(SDL_Keycode keyCode)
  {
    switch (keyCode)
    {
      case SDLK_0:
        return KeyboardKey.num0;
      case SDLK_1:
        return KeyboardKey.num1;
      case SDLK_2:
        return KeyboardKey.num2;
      case SDLK_3:
        return KeyboardKey.num3;
      case SDLK_4:
        return KeyboardKey.num4;
      case SDLK_5:
        return KeyboardKey.num5;
      case SDLK_6:
        return KeyboardKey.num6;
      case SDLK_7:
        return KeyboardKey.num7;
      case SDLK_8:
        return KeyboardKey.num8;
      case SDLK_9:
        return KeyboardKey.num9;
      case SDLK_LCTRL:
        return KeyboardKey.LControl;
      case SDLK_LSHIFT:
        return KeyboardKey.LShift;
      case SDLK_LALT:
        return KeyboardKey.LAlt;
      case SDLK_RCTRL:
        return KeyboardKey.RControl;
      case SDLK_RSHIFT:
        return KeyboardKey.RShift;
      case SDLK_RALT:
        return KeyboardKey.RAlt;
      case SDLK_ESCAPE:
        return KeyboardKey.escape;
      case SDLK_RETURN:
        return KeyboardKey.returnKey;
      case SDLK_TAB:
        return KeyboardKey.tab;

      default: return KeyboardKey.unknown;
    }
  }

  /// button -> SDL_D_MouseButton
  SDL_D_MouseButton toNative(MouseButton button)
  {
    switch (button)
    {
      case MouseButton.left:
        return SDL_D_MouseButton.SDL_BUTTON_LEFT;

      case MouseButton.middle:
        return SDL_D_MouseButton.SDL_BUTTON_MIDDLE;

      case MouseButton.right:
        return SDL_D_MouseButton.SDL_BUTTON_RIGHT;

      case MouseButton.extraButton1:
        return SDL_D_MouseButton.SDL_BUTTON_X1;

      case MouseButton.extraButton2:
        return SDL_D_MouseButton.SDL_BUTTON_X2;

      default: return cast(SDL_D_MouseButton)0;
    }
  }

  /// SDL_D_MouseButton -> MouseButton
  MouseButton fromNative(SDL_D_MouseButton button)
  {
    switch (button)
    {
      case SDL_D_MouseButton.SDL_BUTTON_LEFT:
        return MouseButton.left;

      case SDL_D_MouseButton.SDL_BUTTON_MIDDLE:
        return MouseButton.middle;

      case SDL_D_MouseButton.SDL_BUTTON_RIGHT:
        return MouseButton.right;

      case SDL_D_MouseButton.SDL_BUTTON_X1:
        return MouseButton.extraButton1;

      case SDL_D_MouseButton.SDL_BUTTON_X2:
        return MouseButton.extraButton2;

      default: return cast(MouseButton)-1;
    }
  }

  /// ExternalEventType -> SDL_EventType
  SDL_EventType toNative(ExternalEventType eventType)
  {
    switch (eventType)
    {
      case ExternalEventType.closed:
        return SDL_EventType.SDL_QUIT;

      case ExternalEventType.keyPressed:
        return SDL_EventType.SDL_KEYDOWN;

      case ExternalEventType.keyReleased:
        return SDL_EventType.SDL_KEYUP;

      case ExternalEventType.mouseButtonPressed:
        return SDL_EventType.SDL_MOUSEBUTTONDOWN;

      case ExternalEventType.mouseButtonReleased:
        return SDL_EventType.SDL_MOUSEBUTTONUP;

      case ExternalEventType.mouseMoved:
        return SDL_EventType.SDL_MOUSEMOTION;

      default: return cast(SDL_EventType)-1;
    }
  }

  /// SDL_EventType -> ExternalEventType
  ExternalEventType fromNative(SDL_EventType eventType)
  {
    switch (eventType)
    {
      case SDL_EventType.SDL_QUIT:
        return ExternalEventType.closed;

      case SDL_EventType.SDL_KEYDOWN:
        return ExternalEventType.keyPressed;

      case SDL_EventType.SDL_KEYUP:
        return ExternalEventType.keyReleased;

      case SDL_EventType.SDL_MOUSEBUTTONDOWN:
        return ExternalEventType.mouseButtonPressed;

      case SDL_EventType.SDL_MOUSEBUTTONUP:
        return ExternalEventType.mouseButtonReleased;

      case SDL_EventType.SDL_MOUSEMOTION:
        return ExternalEventType.mouseMoved;

      default: return cast(ExternalEventType)-1;
    }
  }

  /// IExternalDrawableComponent
  interface IExternalDrawableComponent
  {
    /// draw()
    void draw(ExternalWindow window);
  }

  /// The window.
  private SDL_Window* window;
  /// The renderer.
  private SDL_Renderer* renderer;
  /// The external window.
  private ExternalWindow externalWindow;

  /// A SDL Exception.
  private final class SDLException : Exception
  {
    public:
    /**
    * Creates a new SDL exception.
    * Params:
    *   message =   The message.
    *   fn =        The file.
    *   ln =        The line.
    */
    this(string message, string fn = __FILE__, size_t ln = __LINE__) @safe
    {
      super(message, fn, ln);
    }
  }

  /// reportError()
  private void reportError(string errorMessageFun = "SDL_GetError", T = string)(T extraData = null)
  if (isSomeString!T)
  {
    mixin("T message = to!T(" ~ errorMessageFun ~ "());");

    if (extraData && extraData.length)
    {
      message = "Data: " ~ extraData ~ "\r\n---\r\n" ~ message;
    }

    throw new SDLException(to!string(message));
  }

  // ExternalImage
  final class ExternalImage : IExternalDrawableComponent
  {
    private:
    /// _image
    SDL_Texture* _image;
    /// _width
    int _width;
    /// _height
    int _height;
    /// _rect
    SDL_Rect _rect;
    /// _color
    Paint _color;
    /// _path
    string _path;
    /// _scale
    FloatVector _scale;

    /// loadTexture
    SDL_Texture* loadTexture(string path)
    {
        SDL_Texture* texture = null;

        SDL_Surface* surface = IMG_Load(path.toStringz);

        if (surface)
        {
            texture = SDL_CreateTextureFromSurface(renderer, surface);

            if (texture)
            {
                SDL_FreeSurface(surface);
            }
            else
            {
              reportError(path);
            }
        }
        else
        {
          reportError(path);
        }

        return texture;
    }

    public:
    /// this()
    this()
    {
    }

    /// loadFromFile()
    void loadFromFile(string path)
    {
      _path = path;

      _image = loadTexture(path);

      if (SDL_QueryTexture(_image, null, null, &_width, &_height) != 0)
      {
        reportError(_path);
      }

      _rect.x = 0;
      _rect.y = 0;
      _rect.w = _width;
      _rect.h = _height;
    }

    @property
    {
      /// Gets bounds.
      FloatVector bounds()
      {
        return FloatVector(_width, _height);
      }

      /// Gets size.
      UintVector size()
      {
        return UintVector(cast(uint)_width, cast(uint)_height);
      }

      /// Gets position.
      FloatVector position()
      {
        return FloatVector(_rect.x, _rect.y);
      }

      /// Sets position.
      void position(FloatVector newPosition)
      {
        _rect.x = cast(int)newPosition.x;
        _rect.y = cast(int)newPosition.y;
      }

      /// Gets color.
      Paint color()
      {
        return _color;
      }

      /// Sets color.
      void color(Paint newColor)
      {
        _color = newColor;

        if (!_image)
        {
          return;
        }

        if (SDL_SetTextureBlendMode(_image, SDL_BLENDMODE_BLEND) != 0)
        {
          reportError(_path);
        }

        if (SDL_SetTextureAlphaMod(_image, _color.a) != 0)
        {
          reportError(_path);
        }
      }

      /// Gets scale.
      FloatVector scale()
      {
        return _scale;
      }

      /// Sets scale.
      void scale(FloatVector newScale)
      {
        _scale = newScale;

        _rect.w = cast(int)(((_scale.x * 100) / 100) * cast(float)_width);
        _rect.h = cast(int)(((_scale.y * 100) / 100) * cast(float)_height);
      }
    }

    /// draw()
    void draw(ExternalWindow window)
    {
      if (_image)
      {
        if (SDL_RenderCopy(renderer, _image, null, &_rect) != 0)
        {
          reportError(_path);
        }
      }
    }

    static if (isManualMemory)
    {
      /// clean()
      void clean()
      {
        if (_image)
        {
          SDL_DestroyTexture(_image);

          _image = null;
        }
      }
    }
  }

  /// ExternalWindow.
  final class ExternalWindow
  {
    private:
    /// _fps.
    uint _fps;
    /// _lastTicks
    uint _lastTicks;

    public:
    /// this()
    this()
    {
      _lastTicks = SDL_GetTicks();
    }

    @property
    {
      /// Gets isOpen.
      bool isOpen() { return window && renderer; }

      /// Gets fps.
      uint fps() { return _fps; }

      /// Sets fps.
      void fps(uint newFps)
      {
        _fps = newFps;
      }

      /// Gets canUpdate.
      bool canUpdate()
      {
        auto ticks = SDL_GetTicks();
        size_t delta = ticks - _lastTicks;

        auto deltaFps = cast(size_t)(1000 / cast(double)_fps);

        if (delta > deltaFps)
        {
          _lastTicks = ticks;

          return true;
        }

        return false;
      }
    }

    /// close()
    void close()
    {
      clean();
    }

    /// render()
    void render()
    {
      if (renderer)
      {
        SDL_RenderPresent(renderer);
      }
    }

    /// clear()
    void clear(Paint paint)
    {
      if (renderer)
      {
        if (SDL_RenderClear(renderer) != 0)
        {
          reportError();
        }
      }
    }

    /// processEvents()
    bool processEvents(ExternalEventManager eventManager)
    {
      SDL_Event e;
      while (SDL_PollEvent(&e))
      {
        switch (e.type)
        {
          case SDL_EventType.SDL_QUIT:
            eventManager.fireEvent(e.type.fromNative());
            return false;

          case SDL_EventType.SDL_KEYDOWN:
          case SDL_EventType.SDL_KEYUP:
            auto keysym = e.key.keysym.sym.fromNative();
            ExternalEventState._keyEvent.code = keysym;
            break;

          case SDL_EventType.SDL_MOUSEBUTTONDOWN:
          case SDL_EventType.SDL_MOUSEBUTTONUP:
            ExternalEventState._mouseButtonEvent.button = fromNative(cast(SDL_D_MouseButton)e.button.button);
            break;

          case SDL_EventType.SDL_MOUSEMOTION:
            ExternalEventState._mouseMoveEvent.x = cast(int)e.motion.x;
            ExternalEventState._mouseMoveEvent.y = cast(int)e.motion.y;
            break;

          default: break;
        }

        eventManager.fireEvent(e.type.fromNative());
      }

      return true;
    }

    static if (isManualMemory)
    {
      /// clean()
      void clean()
      {
        if (renderer)
        {
          SDL_DestroyRenderer(renderer);

          renderer = null;
        }

        if (window)
        {
          SDL_DestroyWindow(window);

          window = null;
        }
      }
    }

    static:
    /// create()
    ExternalWindow create(string title, size_t width, size_t height, bool fullScreen)
    {
      if (externalWindow)
      {
        return externalWindow;
      }

      if (fullScreen)
      {
        window = SDL_CreateWindow(
          title.toStringz,
          SDL_WINDOWPOS_UNDEFINED,
          SDL_WINDOWPOS_UNDEFINED,
          cast(int)width,
          cast(int)height,
          SDL_WINDOW_OPENGL | SDL_WINDOW_FULLSCREEN
        );
      }
      else
      {
        window = SDL_CreateWindow(
          title.toStringz,
          SDL_WINDOWPOS_UNDEFINED,
          SDL_WINDOWPOS_UNDEFINED,
          cast(int)width,
          cast(int)height,
          SDL_WINDOW_OPENGL
        );
      }

      renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);

      SDL_SetRenderDrawBlendMode(renderer, SDL_BLENDMODE_BLEND);

      auto window = new ExternalWindow;
      return window;
    }
  }

  /// ExternalRectangleShape
  final class ExternalRectangleShape : IExternalDrawableComponent
  {
    private:
    /// _rect
    SDL_Rect _rect;
    /// _fillColor
    Paint _fillColor;

    public:
    final:
    /// this()
    this(FloatVector size)
    {
      _rect.w = cast(int)size.x;
      _rect.h = cast(int)size.y;
    }

    @property
    {
      /// Gets fillColor
      Paint fillColor()
      {
        return _fillColor;
      }

      /// Sets fillColor
      void fillColor(Paint newColor)
      {
        _fillColor = newColor;
      }

      /// Gets position
      FloatVector position()
      {
        return FloatVector(_rect.x, _rect.y);
      }

      /// Sets position
      void position(FloatVector newPosition)
      {
        _rect.x = cast(int)newPosition.x;
        _rect.y = cast(int)newPosition.y;
      }
    }

    /// draw()
    void draw(ExternalWindow window)
    {
      if (SDL_SetRenderDrawColor(renderer, _fillColor.r, _fillColor.g, _fillColor.b, _fillColor.a) != 0)
      {
        reportError();
      }

      if (SDL_RenderFillRect(renderer, &_rect) != 0)
      {
        reportError();
      }
    }

    static if (isManualMemory)
    {
      /// clean()
      void clean()
      {
      }
    }
  }

  /// ExternalText
  final class ExternalText : IExternalDrawableComponent
  {
    /// SDL_TextEntry
    private class SDL_TextEntry
    {
      /// _texture
      SDL_Texture* _texture;
      /// _rect
      SDL_Rect _rect;
    }

    private:
    /// _text
    dstring _text;
    /// _color
    Paint _color;
    /// _font
    ExternalFont _font;
    /// _fontSize
    uint _fontSize;
    /// _position
    FloatVector _position;
    /// _textWidth
    int _textWidth;
    /// _textHeight
    int _textHeight;
    /// _entries
    SDL_TextEntry[] _entries;
    /// hasGottenPosition
    bool hasGottenPosition;

    /// updateText()
    void updateText()
    {
      clean();

      if (!_font || !_text || !renderer || !_font._fontPath || !_fontSize)
      {
        return;
      }

      dstring[] lines = _text.replace("\r", "").split("\n");

      _textHeight = 0;
      _textWidth = 0;

      _entries = [];

      foreach (l; lines)
      {
        auto line = l;

        if (!line || !line.length)
        {
          line = " "; // Weird workaround to TTF not handling empty strings properly.
        }

        auto textSurface = TTF_RenderUTF8_Blended(getFont(_font._fontPath, _fontSize), to!string(line).toStringz, _color.toNative());

        if (!textSurface)
        {
          reportError(_text);
        }

        auto text = new SDL_TextEntry;
        text._texture = SDL_CreateTextureFromSurface(renderer, textSurface);

        if (!text._texture)
        {
          reportError(_text);
        }

        _textWidth = textSurface.w > _textWidth ? textSurface.w : _textWidth;

        _textHeight += textSurface.h;

        text._rect.x = cast(int)_position.x;
        text._rect.y = cast(int)(_position.y + (_textHeight - textSurface.h));
        text._rect.w = textSurface.w;
        text._rect.h = textSurface.h;

        if (textSurface)
        {
          SDL_FreeSurface(textSurface);
        }

        _entries ~= text;
      }
    }

    public:
    final:
    /// this()
    this()
    {
    }

    @property
    {
      /// Gets bounds.
      FloatVector bounds()
      {
        return FloatVector(_textWidth, _textHeight);
      }

      /// Gets position.
      FloatVector position()
      {
        return _position;
      }

      /// Sets position.
      void position(FloatVector newPosition)
      {
        _position = newPosition;

        if (_entries)
        {
          foreach (texture; _entries)
          {
            texture._rect.x = cast(int)_position.x;
            texture._rect.y = cast(int)_position.y;
          }
        }
      }
    }

    /// setFont()
    void setFont(ExternalFont font)
    {
      _font = font;

      updateText();
    }

    /// setString()
    void setString(dstring text)
    {
      _text = text;

      updateText();
    }

    /// setCharacterSize()
    void setCharacterSize(size_t characterSize)
    {
      _fontSize = cast(uint)characterSize;

      updateText();
    }

    /// setColor()
    void setColor(Paint newColor)
    {
      _color = newColor;

      updateText();
    }

    /// draw()
    void draw(ExternalWindow window)
    {
      if (_entries)
      {
        if (!hasGottenPosition)
        {
          position = _position;

          hasGottenPosition = true;
        }

        foreach (texture; _entries)
        {
          if (SDL_RenderCopy(renderer, texture._texture, null, &texture._rect) != 0)
          {
            reportError(_text);
          }
        }
      }
    }

    static if (isManualMemory)
    {
      /// clean()
      void clean()
      {
        if (_entries)
        {
          foreach (texture; _entries)
          {
            SDL_DestroyTexture(texture._texture);
          }
        }
      }
    }
  }

  /// TTF_FontPtr
  private alias TTF_FontPtr = TTF_Font*;

  /// _fonts
  private TTF_FontPtr[string] _fonts;

  /// getFont()
  private TTF_FontPtr getFont(string path, size_t size)
  {
    auto key = path ~ "_" ~ to!string(size);

    auto font = _fonts.get(key, cast(TTF_FontPtr)null);

    if (!font)
    {
      font = TTF_OpenFont(path.toStringz, cast(uint)size);

      if (!font)
      {
        return null;
      }

      _fonts[key] = font;
    }

    return font;
  }

  /// ExternalFont
  final class ExternalFont
  {
    private:
    /// _fontPath
    string _fontPath;

    public:
    final:
    /// this()
    this()
    {
    }

    /// loadFromFile()
    void loadFromFile(string path)
    {
      if (_fontPath)
      {
        return;
      }

      _fontPath = path;
    }

    static if (isManualMemory)
    {
      /// clean()
      void clean()
      {
      }
    }
  }

  /// ExternalMusic
  final class ExternalMusic
  {
    private:
    /// _music
    Mix_Music* _music;

    public:
    final:
    /// this()
    this()
    {
    }

    @property
    {
      /// Gets looping
      bool looping()
      {
        return true;
      }

      /// Sets looping
      void looping(bool isLooping)
      {
        // Do nothing ...
      }
    }

    /// openFromFile()
    bool openFromFile(string music)
    {
      clean();

      if (!music || !music.length)
      {
        return false;
      }

      int flags = MIX_INIT_MP3 | MIX_INIT_OGG | MIX_INIT_FLAC | MIX_INIT_MOD;

      int initted = Mix_Init(flags);

      if ((initted & flags) != flags)
      {
        throw new Exception("Mix_GetError()");
      }

      if (Mix_OpenAudio(22050, AUDIO_S16SYS, 2, 640) != 0)
      {
        throw new Exception("Mix_GetError()");
      }

      _music = Mix_LoadMUS(music.toStringz);

      if (!_music)
      {
        throw new Exception("Mix_GetError()");
      }

      return true;
    }

    /// play()
    void play()
    {
      if (Mix_PlayMusic(_music, 1) != 0)
      {
        throw new Exception("Mix_GetError()");
      }
    }

    /// pause()
    void pause()
    {
      Mix_PauseMusic();
    }

    /// stop()
    void stop()
    {
      Mix_HaltMusic();
    }

    static if (isManualMemory)
    {
      /// clean
      void clean()
      {
        if (_music)
        {
          Mix_FreeMusic(_music);

          _music = null;
        }
      }
    }
  }

  /// quit()
  void quit()
  {
    if (externalWindow)
    {
      externalWindow.clean();
    }

    SDL_Quit();
  }
}
