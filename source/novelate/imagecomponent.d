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
* An image component allows for images to be rendered with a set of extra features and flexibility such as fading etc.
*/
module novelate.imagecomponent;

import std.conv : to;

import novelate.component;

/// Wrapepr around an image component.
final class ImageComponent : Component
{
  private:
  /// The image.
  ExternalImage _image;
  /// Boolean determining whether the image is full-screen or not.
  bool _fullScreen;
  /// The alpha channel.
  ubyte _alpha;
  /// The current fade-in amount.
  ubyte _fadingIn;
  /// The current fade-out amount.
  ubyte _fadingOut;

  public:
  final:
  /**
  * Creates a new image component.
  * Params:
  *   path = The path of the image.
  */
  this(string path)
  {
    _image = new ExternalImage();
    _image.loadFromFile(path);
    _image.position = FloatVector(0, 0);

    _alpha = 255;

    auto bounds = _image.bounds;

    super(bounds.x, bounds.y);
  }

  @property
  {
    /// Gets a boolean determining whether the image is full-screen or not.
    bool fullScreen() { return _fullScreen; }

    /// Sets a boolean determining whether the image is full-screen or not.
    void fullScreen(bool isFullScreen)
    {
      _fullScreen = isFullScreen;
    }
    /// Gets the alpha channel.
    ubyte alpha() { return _alpha; }
    /// Sets the alpha channel.
    void alpha(ubyte newAlpha)
    {
      _alpha = newAlpha;

      _image.color = Paint(255, 255, 255, _alpha);
    }
  }

  /// A handler for when the image has faded out.
  void delegate() fadedOut;
  /// A handler for when the image has faded in.
  void delegate() fadedIn;
  /// A handler for when the image is fading out.
  void delegate(ubyte) fadingOut;
  /// A handler for when the image is fading in.
  void delegate(ubyte) fadingIn;

  /**
  * Fades out the image.
  * Params:
  *   speed = The speed at which the image will fade.
  */
  void fadeOut(ubyte speed)
  {
    if (_fadingOut)
    {
      return;
    }

    _fadingIn = 0;
    _fadingOut = speed;
    alpha = 255;
  }

  /**
  * Fades in the image.
  * Params:
  *   speed = The speed at which the image will fade.
  */
  void fadeIn(ubyte speed)
  {
    if (_fadingIn)
    {
      return;
    }

    _fadingOut = 0;
    _fadingIn = speed;
    alpha = 0;
  }

  /// See: Component.render()
  override void render(ExternalWindow window)
  {
    if (_image)
    {
      ptrdiff_t oldAlpha = cast(ptrdiff_t)_alpha;

      if (_fadingIn && oldAlpha < 255)
      {
        oldAlpha += _fadingIn;

        if (fadingIn)
        {
          fadingIn(cast(ubyte)oldAlpha);
        }

        if (oldAlpha >= 255)
        {
          oldAlpha = 255;

          if (fadedIn)
          {
            fadedIn();
          }
        }

        alpha = cast(ubyte)oldAlpha;
      }
      else if (_fadingOut && _alpha > 0)
      {
        oldAlpha -= _fadingOut;

        if (fadingOut)
        {
          fadingOut(cast(ubyte)oldAlpha);
        }

        if (oldAlpha <= 0)
        {
          oldAlpha = 0;

          if (fadedOut)
          {
            fadedOut();
          }
        }

        alpha = cast(ubyte)oldAlpha;
      }

      _image.draw(window);
    }
  }

  /// See: Component.refresh()
  override void refresh(size_t width, size_t height)
  {
    if (!_fullScreen)
    {
      return;
    }

    auto bounds = _image.bounds;

    _image.scale =
    FloatVector
    (
      cast(int)width / bounds.x,
      cast(int)height / bounds.y
    );
  }

  /// See: Component.updateSize()
  override void updateSize()
  {
    if (_fullScreen)
    {
      return;
    }

    auto bounds = _image.bounds;

    _image.scale =
    FloatVector
    (
      cast(int)super.width / bounds.x,
      cast(int)super.height / bounds.y
    );
  }

  /// See: Component.fitToSize()
  void fitToSize(double maxWidth, double maxHeight, bool enlarge = false)
  {
    import std.math : fmin, round;

    auto src = super.size;

    maxWidth = enlarge ? cast(double)maxWidth : fmin(maxWidth, cast(double)src.x);
    maxHeight = enlarge ? cast(double)maxHeight : fmin(maxHeight, cast(double)src.y);

    double rnd = fmin(maxWidth / cast(double)src.x, maxHeight / cast(double)src.y);

    auto newWidth = round(src.x * rnd);
    auto newHeight = round(src.y * rnd);

    super.size = FloatVector(newWidth, newHeight);
  }

  /// See: Component.updatePosition()
  override void updatePosition()
  {
    _image.position = super.position;
  }
}
