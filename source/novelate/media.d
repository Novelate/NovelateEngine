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
* This module handles media files. Currently only supports image files for relative sizes as of now.
*/
module novelate.media;

/// Wrapper around a media file.
final class NovelateMedia
{
  private:
  /// The name.
  string _name;
  /// The path.
  string _path;

  public:
  final:
  /**
  * Creates a new media file.
  * Params:
  *   name = The name of the media file.
  *   path = The path of the media file.
  */
  this(string name, string path)
  {
    _name = name;
    _path = path;
  }

  @property
  {
    /// Gets the name.
    string name() { return _name; }

    /// Gets the path.
    string path() { return _path; }
  }

  /**
  * Gets a path relative to the given resolution. Ex. car.png is retrieved as ex. car_1280.png" if a relative file is found.
  * Params:
  *   width = The width to be relative to. Usually best kept within the available resolutions such as 800, 1024 and 1280.
  * Returns:
  *   The path of the media file relative to its resolution if a relative file is found, otherwise it returns the original media file path.
  */
  string relativePath(size_t width)
  {
    import std.array : replace;
    import std.file : exists;
    import std.conv : to;

    auto newPath = path
    .replace(".png", "_" ~ to!string(width) ~ ".png")
    .replace(".jpg", "_" ~ to!string(width) ~ ".jpg")
    .replace(".jpeg", "_" ~ to!string(width) ~ ".jpeg")
    .replace(".jfif", "_" ~ to!string(width) ~ ".jfif");

    if (!exists(newPath))
    {
      return path;
    }

    return newPath;
  }
}

/// The collection of media files.
private NovelateMedia[string] _mediaFiles;

/**
* Adds a media file.
* Params:
*   name = The name of the media file.
*   path = The path of the media file.
*/
void addMediaFile(string name, string path)
{
  _mediaFiles[name] = new NovelateMedia(name, path);
}

/**
* Gets a media file.
* Params:
*   name = The name of the media file.
* Returns:
*   The media file from the media file collection.
*/
NovelateMedia getMediaFile(string name)
{
  return _mediaFiles.get(name, null);
}
