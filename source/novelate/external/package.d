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
* This module is used for interacing with external bindings. This allows novelate to be used with a various libraries ex. sfml, sdl etc.
*/
module novelate.external;

public import novelate.external.core;

import novelate.buildstate;

static if (useSFML && !useDerelict)
{
  // Bindings should never expose their external types.
  // fromNative() and toNative() are exposed for usage when implemented Novelate into an existing engine or game.

  public import novelate.dsfmlbinding :
    ExternalWindow, ExternalImage,
    ExternalText, ExternalRectangleShape,
    ExternalFont, ExternalMusic,
    toNative, fromNative,
    initExternalBinding,
    quit;
}
else static if (useSDL && useDerelict)
{
  // Bindings should never expose their external types.
  // fromNative() and toNative() are exposed for usage when implemented Novelate into an existing engine or game.

  public import novelate.sdlbinding :
    ExternalWindow, ExternalImage,
    ExternalText, ExternalRectangleShape,
    ExternalFont, ExternalMusic,
    toNative, fromNative,
    initExternalBinding,
    quit;
}
