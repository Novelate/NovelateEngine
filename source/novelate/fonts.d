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
* This module handles fonts.
*/
module novelate.fonts;

import std.file : dirEntries, SpanMode;
import std.algorithm : filter, endsWith;
import std.string : toLower;
import std.path : stripExtension, baseName;
import std.array : replace;
import std.conv : to;

public import dsfml.graphics : Font;

/// The font collection.
private Font[string] _fonts;

/// Enumeration of font styles.
enum FontStyle : string
{
  /// Normal font style.
  normal = "",
  /// The bold font style.
  bold = "b",
  /// The italic font style.
  italic = "i",
  /// The bold italic font style.
  boldItalic = "z"
}

/**
* Loads fonts within a specific folder. Supports .ttf and .ttc file extensions. It also looks through sub-folders.
* Params:
*   path = The path of the folder that contains the fonts.
*/
void loadFonts(string path)
{
  auto entries = dirEntries(to!string(path), SpanMode.depth).filter!(f => f.name.toLower().endsWith(".ttf") || f.name.toLower().endsWith(".ttc"));

  foreach (string filePath; entries)
  {
    loadFont(filePath);
  }
}

/**
* Loads a font from a specific file. Supports .ttf and .ttc file extensions.
* Params:
*   path = The path of the font file.
* Returns:
*   The loaded font.
*/
Font loadFont(string path)
{
  auto font = _fonts.get(path, null);

  if (font)
  {
    return font;
  }

  font = new Font();
  font.loadFromFile(to!string(path));

  auto name = stripExtension(baseName(path));

  _fonts[name.toLower] = font;
  _fonts[path.replace("\\", "/")] = font;
  _fonts[path.replace("/", "\\")] = font;

  return font;
}

/**
* Retrieves a font by its name and font style.
* Params:
*   fontName = The name of the font to retrieve.
*   style = The style of the font to retrieve.
* Returns:
*   The retrieved font if found, null otherwise.
*/
Font retrieveFont(string fontName, FontStyle style)
{
  return _fonts.get(fontName ~ style, null);
}
