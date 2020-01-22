/*
DSFML - The Simple and Fast Multimedia Library for D

Copyright (c) 2013 - 2015 Jeremy DeHaan (dehaan.jeremiah@gmail.com)

This software is provided 'as-is', without any express or implied warranty.
In no event will the authors be held liable for any damages arising from the use of this software.

Permission is granted to anyone to use this software for any purpose, including commercial applications,
and to alter it and redistribute it freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software.
If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.

2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.

3. This notice may not be removed or altered from any source distribution
*/
module dsfml.graphics.blendmode;

/++
 + Available blending modes for drawing.
 + 
 + See_Also: http://www.sfml-dev.org/documentation/2.0/group__graphics.php#ga80c52fe2f7050d7f7573b7ed3c995388
 + Authors: Laurent Gomila, Jeremy DeHaan
 +/
enum BlendMode
{
	/// Pixel = Source * Source.a + Dest * (1 - Source.a)
	Alpha,
	/// Pixel = Source + Dest.
	Add,
	/// Pixel = Source * Dest.
	Multiply,
	/// Pixel = Source.
	None
}