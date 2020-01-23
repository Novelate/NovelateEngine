// Example implementation of a custom entry point with an attached event handler.
module main;

import novelate;

void main()
{
  initialize();

  addEventHandler!(EventType.onSceneChange)({
    import std.stdio;
    writeln("Changing scene ...");
  });

  run();
}
