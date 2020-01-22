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
* This module handles music files.
*/
module novelate.music;

/// A music file.
final class NovelateMusic
{
  private:
  /// The name of the music file.
  string _name;
  /// The path of the music file.
  string _path;

  public:
  final:
  /**
  * Creates a new music file.
  * Params:
  *   name = The name of the music file.
  *   path = The path of the music file.
  */
  this(string name, string path)
  {
    _name = name;
    _path = path;
  }

  @property
  {
    /// Gets the name of the music file.
    string name() { return _name; }

    /// Gets the path of the music file.
    string path() { return _path; }
  }
}

/// The music file collection.
private NovelateMusic[string] _musicFiles;

/**
* Adds a music file to the music file collection.
* Params:
*   name = The name of the music file.
*   path = The path of the music file.
*/
void addMusicFile(string name, string path)
{
  _musicFiles[name] = new NovelateMusic(name, path);
}

/**
* Gets a music file.
* Params:
*   name = The name of the music file.
* Returns:
*   The music file from the music file collection.
*/
NovelateMusic getMusicFile(string name)
{
  return _musicFiles.get(name, null);
}
