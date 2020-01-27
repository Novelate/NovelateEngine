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
* Compile-time file management for reading files during compilation.
*/
module novelate.scripting.files;

/// Mixin template for loading the story at compile-time.
mixin template LoadStory()
{
  /// Generates the code to load file contents at compile-time.
  string generate()
  {
    import std.array : replace, split;
    import std.string : strip;
    import std.conv : to;

    string getFileContentString = "string[string] getFileContents() { string[string] fileContents; ";

    enum filesContent = import("files.txt");

    foreach (line; filesContent.replace("\r", "").split("\n"))
    {
      if (!line || !line.strip.length)
      {
        continue;
      }

      getFileContentString ~= "fileContents[\"" ~ line ~ "\"] = import(\"" ~ line ~ "\");";
    }

    getFileContentString ~= " return fileContents; }";

    return getFileContentString;
  }

  mixin(generate());
}

mixin LoadStory!();

/// Enum for the loaded file content.
private enum loadedFiles = getFileContents();

/**
* Reads text from a file loaded at compile-time. The file must be available in the parsed "files.txt" which can be found in the "config" folder in the root of the game project.
* Params:
*   fileName = The name of the file.
* Returns:
*   The contents of the file.
*/
string readFileText(string fileName)
{
  return loadedFiles.get(fileName, null);
}
