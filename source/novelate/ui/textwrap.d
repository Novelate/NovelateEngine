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
* This module handles text wrapping which is an essential feature when working with text that has to fit into a specific width. It's currently not a very performant algorithm but it gets the job done.
*/
module novelate.ui.textwrap;

import std.uni : isWhite;
import std.conv : to;

import novelate.fonts;
import novelate.external : ExternalText;
import novelate.buildstate;

/**
* Creates text that wraps when it exceeds a given width. It does so by adding a new line at the last space given before the text exceeds the width and does so for all of the text.
* Params:
*   text = The text to wrap.
*   fontName = The font used for the text.
*   fontSize = The size of the font used.
*   width = The width to wrap the text at when it exceeds.
* Returns:
*   A string that is wrapable based on the original given string and conditions.
*/
dstring wrapableText(dstring text, string fontName, size_t fontSize, size_t width)
{
  if (!text || !text.length)
  {
    return "";
  }

  width -= (fontSize / 2);

  auto font = retrieveFont(fontName, FontStyle.normal);

  bool[] splitIndexes = new bool[text.length];
  bool[] includeSplitters = new bool[text.length];

  dstring calculateText = "";

  size_t lastWhiteIndex = 0;
  bool hasForeignCharacters = false;

  foreach (ref i; 0 .. text.length)
  {
    dchar c = text[i];
    bool isForeighnCharacter = cast(ushort)c > 128;

    if (!hasForeignCharacters && isForeighnCharacter)
    {
      width -= cast(size_t)(cast(double)fontSize * 1.2);

      hasForeignCharacters = true;
    }

    if (c.isWhite || isForeighnCharacter)
    {
      lastWhiteIndex = i;
    }

    calculateText ~= c;

    auto textInstance = new ExternalText;
    textInstance.setFont(font);
    textInstance.setString(calculateText);
    textInstance.setCharacterSize(fontSize);

    auto textWidth = textInstance.bounds.x;

    static if (isManualMemory)
    {
      textInstance.clean();
    }

    if (textWidth >= width)
    {
      splitIndexes[lastWhiteIndex] = true;
      includeSplitters[lastWhiteIndex] = isForeighnCharacter;
      calculateText = "";

      i = lastWhiteIndex + 1;
    }
  }

  calculateText = "";

  foreach (i; 0 .. text.length)
  {
    dchar c = text[i];

    if (splitIndexes[i])
    {
      if (includeSplitters[i])
      {
        calculateText ~= c ~ to!dstring("\r\n");
      }
      else
      {
        calculateText ~= "\r\n";
      }
    }
    else
    {
      calculateText ~= c;
    }
  }

  return calculateText;
}
