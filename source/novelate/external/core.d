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
* This module is used for internal definitions that external definitions don't need implementation for.
*/
module novelate.external.core;

/// A 2d float vector.
struct FloatVector
{
  /// The x value.
  float x;
  /// The y value.
  float y;
}

/// A 2d 32 bit uint vector.
struct UintVector
{
  /// The x value.
  uint x;
  /// The y value.
  uint y;
}

/// A 2d 32 bit int vector.
struct IntVector
{
  /// The x value.
  int x;
  /// The y value.
  int y;
}

/// A paint struct
struct Paint
{
  /// The red channel.
  ubyte r;
  /// The green channel.
  ubyte g;
  /// The blue channel.
  ubyte b;
  /// The alpha channel.
  ubyte a;
}

/// Enumeration of keyboard keys.
enum KeyboardKey
{
  /// Unhandled key
  unknown = -1,
  /// The A key
  a = 0,
  /// The B key
  b,
  /// The C key
  c,
  /// The D key
  d,
  /// The E key
  e,
  /// The F key
  f,
  /// The G key
  g,
  /// The H key
  h,
  /// The I key
  i,
  /// The J key
  j,
  /// The K key
  k,
  /// The L key
  l,
  /// The M key
  m,
  /// The N key
  n,
  /// The O key
  o,
  /// The P key
  p,
  /// The Q key
  q,
  /// The R key
  r,
  /// The S key
  s,
  /// The T key
  t,
  /// The U key
  u,
  /// The V key
  v,
  /// The W key
  w,
  /// The X key
  x,
  /// The Y key
  y,
  /// The Z key
  z,
  /// The 0 key
  num0,
  /// The 1 key
  num1,
  /// The 2 key
  num2,
  /// The 3 key
  num3,
  /// The 4 key
  num4,
  /// The 5 key
  num5,
  /// The 6 key
  num6,
  /// The 7 key
  num7,
  /// The 8 key
  num8,
  /// The 9 key
  num9,
  /// The Escape key
  escape,
  /// The left Control key
  LControl,
  /// The left Shift key
  LShift,
  /// The left Alt key
  LAlt,
  /// The left OS specific key: window (Windows and Linux), apple (MacOS X), ...
  LSystem,
  /// The right Control key
  RControl,
  /// The right Shift key
  RShift,
  /// The right Alt key
  RAlt,
  /// The right OS specific key: window (Windows and Linux), apple (MacOS X), ...
  RSystem,
  /// The Menu key
  menu,
  /// The [ key
  LBracket,
  /// The ] key
  RBracket,
  /// The ; key
  semiColon,
  /// The , key
  comma,
  /// The . key
  period,
  /// The ' key
  quote,
  /// The / key
  slash,
  /// The \ key
  backSlash,
  /// The ~ key
  tilde,
  /// The = key
  equal,
  /// The - key
  dash,
  /// The Space key
  space,
  /// The Return key
  returnKey,
  /// The Backspace key
  backSpace,
  /// The Tabulation key
  tab,
  /// The Page up key
  pageUp,
  /// The Page down key
  pageDown,
  /// The End key
  end,
  /// The Home key
  home,
  /// The Insert key
  insert,
  /// The Delete key
  deleteKey,
  /// The + key
  add,
  /// The - key
  subtract,
  /// The * key
  multiply,
  /// The / key
  divide,
  /// Left arrow
  left,
  /// Right arrow
  right,
  /// Up arrow
  up,
  /// Down arrow
  down,
  /// The numpad 0 key
  numpad0,
  /// The numpad 1 key
  numpad1,
  /// The numpad 2 key
  numpad2,
  /// The numpad 3 key
  numpad3,
  /// The numpad 4 key
  numpad4,
  /// The numpad 5 key
  numpad5,
  /// The numpad 6 key
  numpad6,
  /// The numpad 7 key
  numpad7,
  /// The numpad 8 key
  numpad8,
  /// The numpad 9 key
  numpad9,
  /// The F1 key
  f1,
  /// The F2 key
  f2,
  /// The F3 key
  f3,
  /// The F4 key
  f4,
  /// The F5 key
  f5,
  /// The F6 key
  f6,
  /// The F7 key
  f7,
  /// The F8 key
  f8,
  /// The F9 key
  f9,
  /// The F10 key
  f10,
  /// The F11 key
  f11,
  /// The F12 key
  f12,
  /// The F13 key
  f13,
  /// The F14 key
  f14,
  /// The F15 key
  f15,
  /// The Pause key
  pause
}

/// Enumeration of mouse buttons.
enum MouseButton
{
  /// The left mouse button
  left,
  /// The right mouse button
  right,
  /// The middle (wheel) mouse button
  middle,
  /// The first extra mouse button
  extraButton1,
  /// The second extra mouse button
  extraButton2,
}

/// Enumeration of event types.
enum ExternalEventType
{
  /// The window requested to be closed (no data)
  closed,
  /// The window was resized (data in event.size)
  resized,
  /// The window lost the focus (no data)
  lostFocus,
  /// The window gained the focus (no data)
  gainedFocus,
  /// A character was entered (data in event.text)
  textEntered,
  /// A key was pressed (data in event.key)
  keyPressed,
  /// A key was released (data in event.key)
  keyReleased,
  /// The mouse wheel was scrolled (data in event.mouseWheel)
  mouseWheelMoved,
  /// A mouse button was pressed (data in event.mouseButton)
  mouseButtonPressed,
  /// A mouse button was released (data in event.mouseButton)
  mouseButtonReleased,
  /// The mouse cursor moved (data in event.mouseMove)
  mouseMoved,
  /// The mouse cursor entered the area of the window (no data)
  mouseEntered,
  /// The mouse cursor left the area of the window (no data)
  mouseLeft,
  /// A joystick button was pressed (data in event.joystickButton)
  joystickButtonPressed,
  /// A joystick button was released (data in event.joystickButton)
  joystickButtonReleased,
  /// The joystick moved along an axis (data in event.joystickMove)
  joystickMoved,
  /// A joystick was connected (data in event.joystickConnect)
  joystickConnected,
  /// A joystick was disconnected (data in event.joystickConnect)
  joystickDisconnected
}

/// Joystick buttons events parameters (JoystickButtonPressed, JoystickButtonReleased)
struct ExternalJoystickButtonEvent
{
  ///Index of the joystick (in range [0 .. Joystick::Count - 1])
  uint joystickId;
  ///Index of the button that has been pressed (in range [0 .. Joystick::ButtonCount - 1])
  uint button;
}

/// Joystick connection events parameters (JoystickConnected, JoystickDisconnected
struct ExternalJoystickConnectEvent
{
  ///Index of the joystick (in range [0 .. Joystick::Count - 1])
  uint joystickId;
}

/// Joystick connection events parameters (JoystickConnected, JoystickDisconnected)
struct ExternalJoystickMoveEvent
{
  ///Index of the joystick (in range [0 .. Joystick::Count - 1])
  uint joystickId;
  ///Axis on which the joystick moved
  int axis;
  ///New position on the axis (in range [-100 .. 100])
  float position;
}

/// Keyboard event parameters (KeyPressed, KeyReleased)
struct ExternalKeyEvent
{
  ///Code of the key that has been pressed.
  KeyboardKey code;
  ///Is the Alt key pressed?
  bool alt;
  ///Is the Control key pressed?
  bool control;
  ///Is the Shift key pressed?
  bool shift;
  ///Is the System key pressed?
  bool system;
}

/// Mouse buttons events parameters (MouseButtonPressed, MouseButtonReleased)
struct ExternalMouseButtonEvent
{
  ///Code of the button that has been pressed
  MouseButton button;
  ///X position of the mouse pointer, relative to the left of the owner window
  int x;
  ///Y position of the mouse pointer, relative to the top of the owner window
  int y;
}

/// Mouse move event parameters (MouseMoved)
struct ExternalMouseMoveEvent
{
  ///X position of the mouse pointer, relative to the left of the owner window
  int x;
  ///Y position of the mouse pointer, relative to the top of the owner window
  int y;
}

 /// Mouse wheel events parameters (MouseWheelMoved)
struct ExternalMouseWheelEvent
{
  ///Number of ticks the wheel has moved (positive is up, negative is down)
  int delta;
  ///X position of the mouse pointer, relative to the left of the owner window
  int x;
  ///Y position of the mouse pointer, relative to the top of the owner window
  int y;
}

/// Size events parameters (Resized)
struct ExternalSizeEvent
{
  ///New width, in pixels
  uint width;
  ///New height, in pixels
  uint height;
}

/// Text event parameters (TextEntered)
struct ExternalTextEvent
{
  /// UTF-32 unicode value of the character
  dchar unicode;
}

/// The external event state.
final class ExternalEventState
{
  final:
  static:

  package(novelate):
  /// _joystickButtonEvent.
  ExternalJoystickButtonEvent _joystickButtonEvent;
  /// _joystickConnectEvent.
  ExternalJoystickConnectEvent _joystickConnectEvent;
  /// _joystickMoveEvent.
  ExternalJoystickMoveEvent _joystickMoveEvent;
  /// _keyEvent.
  ExternalKeyEvent _keyEvent;
  /// _mouseButtonEvent.
  ExternalMouseButtonEvent _mouseButtonEvent;
  /// _mouseMoveEvent.
  ExternalMouseMoveEvent _mouseMoveEvent;
  /// _mouseWheelEvent.
  ExternalMouseWheelEvent _mouseWheelEvent;
  /// _sizeEvent.
  ExternalSizeEvent _sizeEvent;
  /// _textEvent.
  ExternalTextEvent _textEvent;

  public:
  @property
  {
    /// Gets joystickButtonEvent.
    ExternalJoystickButtonEvent joystickButtonEvent() { return _joystickButtonEvent; }
    /// Gets joystickConnectEvent.
    ExternalJoystickConnectEvent joystickConnectEvent() { return _joystickConnectEvent; }
    /// Gets joystickMoveEvent.
    ExternalJoystickMoveEvent joystickMoveEvent() { return _joystickMoveEvent; }
    /// Gets keyEvent.
    ExternalKeyEvent keyEvent() { return _keyEvent; }
    /// Gets mouseButtonEvent.
    ExternalMouseButtonEvent mouseButtonEvent() { return _mouseButtonEvent; }
    /// Gets mouseMoveEvent.
    ExternalMouseMoveEvent mouseMoveEvent() { return _mouseMoveEvent; }
    /// Gets mouseWheelEvent.
    ExternalMouseWheelEvent mouseWheelEvent() { return _mouseWheelEvent; }
    /// Gets sizeEvent.
    ExternalSizeEvent sizeEvent() { return _sizeEvent; }
    /// Gets textEvent.
    ExternalTextEvent textEvent() { return _textEvent; }
  }
}

/// The external event manager.
final class ExternalEventManager
{
  private:
  /// Delegate for event handlers.
  alias _DELEGATE = void delegate();

  /// Collection of handlers.
  _DELEGATE[ExternalEventType] _handlers;

  public:
  /**
  * Adds an event handler.
  * Params:
  *   eventType = The event type.
  *   handler = The handler.
  */
  void addHandler(ExternalEventType eventType, _DELEGATE handler)
  {
    _handlers[eventType] = handler;
  }

  /**
  * Removes an event handler.
  * Params:
  *   eventType = The event type.
  */
  void removeHandler(ExternalEventType eventType)
  {
    if (!_handlers)
    {
      return;
    }

    _handlers.remove(eventType);
  }

  /**
  * Fires an event.
  * Params:
  *   eventType = The event type.
  */
  void fireEvent(ExternalEventType eventType)
  {
    if (!_handlers)
    {
      return;
    }

    auto handler = _handlers.get(eventType, null);

    if (!handler)
    {
      return;
    }

    handler();
  }
}
