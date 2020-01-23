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
* An animated image component is basically a wrapper around multiple images that are displayed in order to create an animation.
*/
module novelate.animatedimage;

import std.conv : to;

import novelate.component;

/// An animated image component.
final class AnimatedImage : Component
{
  private:
  /// The images for each frame.
  ExternalImage[] _images;
  /// The current frame.
  size_t _currentFrame;
  /// Boolean determining whether the animation is full-screen or not.
  bool _fullScreen;
  /// The alpha channel of the animation.
  ubyte _alpha;
  /// The current fade-in amount.
  ubyte _fadingIn;
  /// The current fade-out amount.
  ubyte _fadingOut;
  /// The animation count.
  ptrdiff_t _animatorCount;
  /// The animation speed.
  ptrdiff_t _animationSpeed;

  public:
  final:
  /**
  * Creates a new animated image component.
  * Params:
  *   paths = The paths of the animation frame images.
  */
  this(string[] paths)
  {
    foreach (path; paths)
    {
      auto externalImage = new ExternalImage;
      externalImage.loadFromFile(path);

      _images ~= externalImage;
    }

    _alpha = 255;
    _animatorCount = 1000;
    _currentFrame = 0;
    _animationSpeed = 100;

    auto firstImage = _images[0];
    auto firstBounds = firstImage.bounds;

    super(firstBounds.x, firstBounds.y);
  }

  @property
  {
    /// Gets the animation speed.
    ptrdiff_t animationSpeed() { return _animationSpeed; }

    /// Sets the animation speed.
    void animationSpeed(ptrdiff_t newAnimationSpeed)
    {
      _animationSpeed = newAnimationSpeed;
    }

    /// Gets a boolean determining whether the animation is full-screen or not.
    bool fullScreen() { return _fullScreen; }

    /// Sets a boolean determining whether the animation is full-screen or not. If not initialized with width/height from a layer then refresh() must manually be set.
    void fullScreen(bool isFullScreen)
    {
      _fullScreen = isFullScreen;
    }

    /// Gets the alpha channel of the animation.
    ubyte alpha() { return _alpha; }

    /// Sets the alpha channel of the animation.
    void alpha(ubyte newAlpha)
    {
      _alpha = newAlpha;

      foreach (image; _images)
      {
        image.color = Paint(255, 255, 255, _alpha);
      }
    }
  }

  /// A handler for when the animation has faded out.
  void delegate() fadedOut;
  /// A handler for when the animation has faded in.
  void delegate() fadedIn;
  /// A handler for when the animation is fading out.
  void delegate(ubyte) fadingOut;
  /// A handler for when the animation is fading in.
  void delegate(ubyte) fadingIn;

  /**
  * Fades out the animation.
  * Params:
  *   speed = The speed at which the animation will fade.
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
  * Fades in the animation.
  * Params:
  *   speed = The speed at which the animation will fade.
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
    if (_images && _images.length)
    {
      if (_currentFrame >= _images.length)
      {
        _currentFrame = 0;
      }
    }

    auto sprite = _images && _images.length ? _images[_currentFrame] : null;

    if (sprite)
    {
      _animatorCount -= _animationSpeed;

      if (_animatorCount <= 0)
      {
        _currentFrame++;
        _animatorCount = 1000;
      }

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

      sprite.draw(window);
    }
  }

  /// See: Component.refresh()
  override void refresh(size_t width, size_t height)
  {
    if (!_fullScreen)
    {
      return;
    }

    foreach (sprite; _images)
    {
      auto bounds = sprite.bounds;

      sprite.scale =
      FloatVector
      (
        cast(int)width / bounds.x,
        cast(int)height / bounds.y
      );
    }
  }

  /// See: Component.updateSize()
  override void updateSize()
  {
    if (_fullScreen)
    {
      return;
    }

    foreach (sprite; _images)
    {
      auto bounds = sprite.bounds;

      sprite.scale =
      FloatVector
      (
        cast(int)super.width / bounds.x,
        cast(int)super.height / bounds.y
      );
    }
  }

  /**
  * Scales and fits the image into a specific size.
  * Params:
  *   maxWidth = The maximum width at which the image can fit into.
  *   maxHeight = The maximum height at which the image can fit into.
  *   enlarge = A boolean determining whether scaling up is allowed or not.
  */
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
    foreach (sprite; _images)
    {
      sprite.position = super.position;
    }
  }
}
