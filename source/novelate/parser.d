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
* This module handles parsing of the visual novel scripting files.
*/
module novelate.parser;

import novelate.config;
import novelate.media;
import novelate.character;
import novelate.music;
import novelate.scene;
import novelate.files;

/**
* Parses a Novelate file.
* Params:
*   file = The file to parse.
*/
void parseFile(string file)
{
  import std.path : absolutePath, dirName;

  parse(cast(string)readFileText(file));
}

private
{
  /// The parsing types.
  enum ParsingType
  {
    none,
    config,
    media,
    character,
    music,
    scene
  }
}

/**
* Parses content using the Novelate file format.
* Params:
*   content = The content to parse.
*/
void parse(string content)
{
  import std.array : array, replace, split;
  import std.string : strip, stripLeft, stripRight, format;
  import std.algorithm : map, filter, startsWith, endsWith, countUntil;

  auto lines = content.replace("\r", "").split("\n").map!(l => l.strip).filter!(l => l.length).array;

  ParsingType parsingType;
  string currentName;
  NovelateScene currentScene;

  foreach (l; lines)
  {
    auto line = l.split("//")[0].stripRight;

    if (line.startsWith("#"))
    {
      auto fileName = line[1 .. $];

      parse(readFileText(fileName ~ ".txt"));
    }

    if (line.startsWith("<") && line.endsWith(">"))
    {
      parsingType = ParsingType.none;
      currentScene = null;

      auto entryData = line[1 .. $-1];

      if (entryData == "__Config__")
      {
        parsingType = ParsingType.config;
      }
      else
      {
        auto entries = entryData.split(":");
        auto name = entries[0];
        auto type = entries[1];

        currentName = name;

        switch (type)
        {
          case "Media": parsingType = ParsingType.media; break;
          case "Character":
          {
            parsingType = ParsingType.character;
            createCharacterBase(name);
            break;
          }
          case "Music": parsingType = ParsingType.music; break;
          case "Scene":
          {
            parsingType = ParsingType.scene;
            currentScene = createSceneBase(name);
            break;
          }
          default: parsingType = ParsingType.none;
        }
      }
    }
    else
    {
      switch (parsingType)
      {
        case ParsingType.config:
        {
          auto valueIndex = line.countUntil("=");

          if (valueIndex < 1)
          {
            break;
          }

          auto name = line[0 .. valueIndex];
          auto value = line[valueIndex + 1 .. $];

          config.setConfig(name, value);
          break;
        }

        case ParsingType.media:
        {
          addMediaFile(currentName, line);
          break;
        }

        case ParsingType.character:
        {
          auto valueIndex = line.countUntil("=");

          if (valueIndex < 1)
          {
            break;
          }

          auto name = line[0 .. valueIndex];
          auto value = line[valueIndex + 1 .. $];

          updateCharacter(currentName, name, value);
          break;
        }

        case ParsingType.music:
        {
          addMusicFile(currentName, line);
          break;
        }

        case ParsingType.scene:
        {
          if (currentScene)
          {
            currentScene.updateScene(line);
          }
          break;
        }

        default: break;
      }
    }
  }
}
