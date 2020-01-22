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
* This module handles color management.
*/
module novelate.colormanager;

import std.array : split;
import std.conv : to;

import dsfml.graphics : Color;

/**
* Creates a color from given RGBA channels.
* Params:
*   r = The red channel.
*   g = The green channel.
*   b = The blue channel.
*   a = The alpha channel.
*  Returns:
*   The color created.
*/
Color colorFromRGBA(ubyte r, ubyte g, ubyte b, ubyte a = 0xff)
{
  return Color(r, g, b, a);
}

/**
* Creates a color from given RGBA channels contained in a string. Ex. "255,255,0" fpr green or with alpha "255,255,0,150"
* Params:
*   color = The color string of the RGBA channels.
*  Returns:
*   The color created.
*/
Color colorFromString(string color)
{
  auto data = color.split(",");

  if (data.length < 3)
  {
    return colorFromRGBA(0,0,0);
  }

  auto r = to!ubyte(data[0]);
  auto g = to!ubyte(data[1]);
  auto b = to!ubyte(data[2]);
  auto a = data.length == 4 ? to!ubyte(data[3]) : cast(ubyte)0xff;

  return colorFromRGBA(r, g, b, a);
}
