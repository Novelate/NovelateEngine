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
* This module handles the build state of Novelate.
*/
module novelate.buildstate;

mixin template VERSION_ELSE(string versionName, string variableName)
{
  mixin("version (" ~ versionName ~ ") { const bool " ~ variableName ~ " = true; } else { const bool " ~ variableName ~ " = false; }");
}

mixin VERSION_ELSE!("NOVELATE_CUSTOM_MAIN", "useCustomMain");
mixin VERSION_ELSE!("NOVELATE_SFML", "useSFML");
mixin VERSION_ELSE!("NOVELATE_SDL", "useSDL");
mixin VERSION_ELSE!("NOVELATE_DERELICT", "useDerelict");
mixin VERSION_ELSE!("NOVELATE_MANUALMEMORY", "isManualMemory");

static if (useSDL)
{
  const bool useNativeTextWrapping = true;
}
else
{
  const bool useNativeTextWrapping = false;
}
