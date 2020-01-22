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
* This module handles the global state of the visual novel. Global states are only available internal in the engine and are used to share data between parts that aren\t interacting with each other.
* At some point these states needs to be rewritten so they're used more safely but as of now they function and doesn't require a lot to maintain.
*/
module novelate.state;

import dsfml.graphics : RenderWindow;
import dsfml.window : VideoMode, ContextSettings;

import novelate.layer;
import novelate.core : Screen;

package(novelate):

/// The resolution width.
size_t _width = 800;
/// The resolution height.
size_t _height = 600;
/// The next scene.
string nextScene = null;
/// Boolean determining whether the game has ended or not.
bool endGame = false;
/// boolean determining whether the game should exit or not.
bool exitGame = false;
/// The temp screen to change to.
Screen changeTempScreen = Screen.none;
/// Boolean determining whether the displayed screen is temp or not.
bool _isTempScreen = false;
/// Gets a boolean determining whether the displayed screen is temp or not.
@property bool isTempScreen() { return _isTempScreen; }
/// The current play scene.
string playScene;
/// Boolean determining whether the game is running.
bool running = true;
/// The context settings.
ContextSettings _context;
/// The video mode.
VideoMode _videoMode;
/// The render window.
RenderWindow _window;
/// The fps.
const _fps = 60;
/// The window title.
string _title = "";
/// The layers.
Layer[] _layers;
/// The temp layers.
Layer[] _tempLayers;
/// The selected layers. Usually refers to _layers or _tempLayers.
Layer[] selectedLayers;
/// Boolean determining whether the game is in full-screen or not.
bool fullScreen = false;
