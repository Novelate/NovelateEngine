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

enum EventType : string
{
  onSceneChange = "onSceneChange",
  onTempScreenClear = "onTempScreenClear",
  onTempScreenShow = "onTempScreenShow",
  onResolutionChange = "onResolutionChange",
  onLoadingCreditsVideo = "onLoadingCreditsVideo",
  onClearingAllLayersButBackground = "onClearingAllLayersButBackground",
  onScreenChange = "onScreenChange",
  onRender = "onRender"
}

private
{
  alias _EVENTDELEGATE = void delegate();

  _EVENTDELEGATE[] onSceneChange;
  _EVENTDELEGATE[] onTempScreenClear;
  _EVENTDELEGATE[] onTempScreenShow;
  _EVENTDELEGATE[] onResolutionChange;
  _EVENTDELEGATE[] onLoadingCreditsVideo;
  _EVENTDELEGATE[] onClearingAllLayersButBackground;
  _EVENTDELEGATE[] onScreenChange;
  _EVENTDELEGATE[] onRender;
}

void addEventHandler(EventType eventType)(_EVENTDELEGATE handler)
{
  mixin((cast(string)eventType) ~ " ~= handler;");
}

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
