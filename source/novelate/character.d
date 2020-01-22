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
* This module handles everything that has to do with the core of characters within a novel.
*/
module novelate.character;

import std.array : split;
import std.path : baseName;
import std.conv : to;

/// A character.
final class NovelateCharacter
{
  private:
  /// The name.
  string _name;
  /// The alias name. Used internally if ex. display name has special characters, making it easier to retrieve/update etc. from code.
  string _aliasName;
  /// The name color.
  string _nameColor;
  /// The about information.
  string _about;
  /// The about image.
  string _aboutImage;
  /// The image collection of the character.
  NovelateCharacterImageCollection[string] _graphics;

  public:
  final:
  /**
  * Creates a new character.
  * Params:
  *   name = The name of the character.
  */
  this(string name)
  {
    _name = name;
    _aliasName = _name;
  }

  @property
  {
    /// Gets the name of the character.
    string name() { return _name; }

    /// Gets the alias name of the character. Used internally if ex. display name has special characters, making it easier to retrieve/update etc. from code.
    string aliasName() { return _aliasName; }

    /// Gets the name color of the character.
    string nameColor() { return _nameColor; }

    /// Gets the about information of the character.
    string about() { return _about; }

    /// Gets the about image of the character.
    string aboutImage() { return _aboutImage; }
  }

  /**
  * Gets an image from the character's internal image collection.
  * Params:
  *   entry = The entry of the image ex. "Casual.Smiling"
  *   width = The relative width to retrieve from. This can be 800, 1024 or 1280.
  * Returns:
  *   The path of the image retrieved.
  */
  string getImage(string entry, size_t width)
  {
    if (!_graphics)
    {
      return null;
    }

    auto data = entry.split(".");

    if (data.length != 2)
    {
      return null;
    }

    auto collection = _graphics.get(data[0], null);

    if (!collection)
    {
      return null;
    }

    return collection.get(data[1] ~ "_" ~ to!string(width));
  }
}

/// A collection of character images.
final class NovelateCharacterImageCollection
{
  private:
  /// The images of the character.
  string[string] _images;

  public:
  final:
  /**
  * Creates a new collection of character images.
  * Params:
  *   path = The path of the image collection for the character.
  */
  this(string path)
  {
    import std.file : dirEntries, SpanMode;
    import std.algorithm : filter, endsWith;

    auto images = dirEntries(to!string(path), SpanMode.shallow).filter!(f => f.name.endsWith(".png"));

    foreach (image; images)
    {
      auto name = baseName(image).split(".")[0];

      _images[name] = image;
    }
  }

  /**
  * Gets an image from the collection.
  * Params:
  *   name = The name of the image.
  * Returns:
  *   The image retrieved from the collection.
  */
  string get(string name)
  {
    if (!_images)
    {
      return null;
    }

    return _images.get(name, null);
  }
}

/// The collection of characters.
private NovelateCharacter[string] _characters;

public:
/**
* Gets a character.
* Params:
*   name = The name of the character. This can also be the alias name.
* Returns:
*   The character from the character collection.
*/
NovelateCharacter getCharacter(string name)
{
  if (!_characters)
  {
    return null;
  }

  return _characters.get(name, null);
}

package(novelate):
/**
* Creates a character base and adds it to the character collection.
* Params:
*   name = The name of the character.
*/
void createCharacterBase(string name)
{
  if (_characters && (name in _characters))
  {
    return;
  }

  auto character = new NovelateCharacter(name);

  _characters[character.name] = character;
}

/**
* Updates a character with parsed configurations.
* Params:
*   characterName = The name of the character to update.
*   name = The name of the configuration.
*   value = The value of the configuration.
*/
void updateCharacter(string characterName, string name, string value)
{
  if (!_characters)
  {
    return;
  }

  auto character = _characters.get(characterName, null);

  if (!character)
  {
    return;
  }

  switch (name)
  {
    case "Alias":
    {
      character._aliasName = value;

      _characters[character._aliasName] = character;
      break;
    }
    case "NameColor": character._nameColor = value; break;
    case "About": character._about = value; break;
    case "AboutImage": character._aboutImage = value; break;

    default:
    {
      character._graphics[name] = new NovelateCharacterImageCollection(value);
      break;
    }
  }
}
