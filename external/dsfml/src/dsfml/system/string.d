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

/**
 *A module containing functions for interacting with strings going to and from 
 *a C/C++ library as well as converting between D's string types. This module has no dependencies
 *except for std.utf.
 */
module dsfml.system.string;

///Returns a D string copy of a zero terminated C style string
///
///Params:
///		str = The C style string to convert.
///
///Returns: the D style string copy.
immutable(T)[] toString(T)(in const(T)* str) pure
	if (is(T == dchar)||is(T == wchar)||is(T == char))
{
	return str[0..strlen(str)].idup;
}

///Returns a pointer to a C style string created from a D string type
///
///Params:
///		str = The D style string to convert.
///
///Returns: the C style string pointer.
const(T)* toStringz(T)(in immutable(T)[] str) nothrow 
	if (is(T == dchar)||is(T == wchar)||is(T == char))
{
	//TODO: get rid of GC usage without adding dependencies?

	//a means to store the copy after returning the address
	static T[] copy;

	//if str is just ""
	if(str.length == 0)
	{
		copy = new T[1];
		copy[0] = 0;
		return copy.ptr;
	}

	//Already zero terminated
	if(str[$-1] == 0)
	{
		return str.ptr;
	}
	//not zero terminated
	else
	{
		copy = new T[str.length+1];
		copy[0..str.length] = str[];
		copy[$-1] = 0;

		return copy.ptr;

	}
}

///Returns the same string in a different utf encoding
///
///Params:
///		str = The string to convert.
///
///Returns: the C style string pointer.
immutable(U)[] stringConvert(T, U)(in immutable(T)[] str) pure
if ((is(T == dchar)||is(T == wchar)||is(T == char)) &&	
	(is(U == dchar)||is(U == wchar)||is(U == char)))
{
	import std.utf;

	static if(is(U == char))
	{
		return toUTF8(str);
	}

	else static if(is(U == wchar))
	{
		return toUTF16(str);
	}
	else
	{
		return toUTF32(str);
	}

}


///Get the length of a C style string
///
///Params:
///		str = The C style string.
///
///Returns: The C string's length.
private size_t strlen(T)(in const(T)* str) pure nothrow
if (is(T == dchar)||is(T == wchar)||is(T == char))
{
	size_t n = 0;
	for (; str[n] != 0; ++n) {}
	return n;
}

unittest
{
	version(DSFML_Unittest_System)
	{
		import std.stdio;
		
		writeln("Unit test for string functions");

		string str1 = "Hello, World";
		wstring str2 = "Hello, World";
		dstring str3 = "Hello, World";

		const(char)* cstr1 = toStringz(str1);
		const(wchar)* cstr2 = toStringz(str2);
		const(dchar)* cstr3 = toStringz(str3);

		assert(strlen(cstr1) == 12);
		assert(strlen(cstr2) == 12);
		assert(strlen(cstr3) == 12);

	}

}
