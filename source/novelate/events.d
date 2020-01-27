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
* This module is used for event handling within the engine.
*/
module novelate.events;

/// Enumeration of event types.
enum EventType : string
{
  /// The onSceneChange event.
  onSceneChange = "onSceneChange",
  /// The onResolutionChange event.
  onResolutionChange = "onResolutionChange",
  /// The onLoadingCreditsVideo event.
  onLoadingCreditsVideo = "onLoadingCreditsVideo",
  /// The onClearingAllLayersButBackground event.
  onClearingAllLayersButBackground = "onClearingAllLayersButBackground",
  /// The onScreenChange event.
  onScreenChange = "onScreenChange",
  /// The onRender event.
  onRender = "onRender"
}

private
{
  /// The event delegate.
  alias _EVENTDELEGATE = void delegate();

  /// The onSceneChange event handlers.
  _EVENTDELEGATE[] onSceneChange;
  /// The onResolutionChange event handelers.
  _EVENTDELEGATE[] onResolutionChange;
  /// The onLoadingCreditsVideo event handlers.
  _EVENTDELEGATE[] onLoadingCreditsVideo;
  /// The onClearingAllLayersButBackground event handlers.
  _EVENTDELEGATE[] onClearingAllLayersButBackground;
  /// The onScreenChange event handlers.
  _EVENTDELEGATE[] onScreenChange;
  /// The onRender event handlers.
  _EVENTDELEGATE[] onRender;
}

/**
* Adds an event handler.
* Params:
*   handler = The handler for the event.
*/
void addEventHandler(EventType eventType)(_EVENTDELEGATE handler)
{
  mixin((cast(string)eventType) ~ " ~= handler;");
}

/**
* Fires an event.
* Params:
*   eventType = The type of the event to fire.
*/
void fireEvent(EventType eventType)()
{
  mixin("auto handlers = " ~ (cast(string)eventType) ~ ";");

  if (!handlers || !handlers.length)
  {
    return;
  }

  foreach (handler; handlers)
  {
    handler();
  }
}
