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

module dsfml.audio.soundfile;

import std.string;
import dsfml.system.inputstream;
import dsfml.system.err;

package:

struct SoundFile
{
	private sfSoundFile* m_soundFile;
	private soundFileStream m_stream;//keeps an instance of the C++ interface stored if used

	void create()
	{
		m_soundFile = sfSoundFile_create();
	}
	
	~this()
	{
		sfSoundFile_destroy(m_soundFile);
	}

	bool openReadFromFile(string filename)
	{
		import dsfml.system.string;
		bool toReturn = sfSoundFile_openReadFromFile(m_soundFile, toStringz(filename));
		err.write(dsfml.system.string.toString(sfErr_getOutput()));
		return toReturn;
	}

	bool openReadFromMemory(const(void)[] data)
	{
		import dsfml.system.string;
		bool toReturn = sfSoundFile_openReadFromMemory(m_soundFile, data.ptr, data.length);
		err.write(dsfml.system.string.toString(sfErr_getOutput()));
		return toReturn;
	}
	bool openReadFromStream(InputStream stream)
	{
		import dsfml.system.string;
		m_stream = new soundFileStream(stream);

		bool toReturn  = sfSoundFile_openReadFromStream(m_soundFile, m_stream);
		err.write(dsfml.system.string.toString(sfErr_getOutput()));
		return toReturn;
	}

	bool openWrite(string filename,uint channelCount,uint sampleRate)
	{
		import dsfml.system.string;
		bool toReturn = sfSoundFile_openWrite(m_soundFile, toStringz(filename),channelCount,sampleRate);
		err.write(dsfml.system.string.toString(sfErr_getOutput()));
		return toReturn;
	}

	long read(ref short[] data)
	{
		return sfSoundFile_read(m_soundFile,data.ptr, data.length);

	}

	void write(const(short)[] data)
	{
		sfSoundFile_write(m_soundFile, data.ptr, data.length);
	}

	void seek(long timeOffset)
	{
		import dsfml.system.string;
		sfSoundFile_seek(m_soundFile, timeOffset);
		
		//Temporary fix for a bug where attempting to write to err
		//throws an exception in a thread created in C++. This causes
		//the program to explode. Hooray.
		
		//This fix will skip the call to err.write if there was no error
		//to report. If there is an error, well, the program will still explode,
		//but the user should see the error prior to the call that will make the 
		//program explode.
		
		string temp = dsfml.system.string.toString(sfErr_getOutput());
		if(temp.length > 0)
		{
		    err.write(temp);
		}
	}

	long getSampleCount()
	{
		return sfSoundFile_getSampleCount(m_soundFile);
	}
	uint getSampleRate()
	{
		return sfSoundFile_getSampleRate(m_soundFile);
	}
	uint getChannelCount()
	{
		return sfSoundFile_getChannelCount(m_soundFile);
	}




}

private
{

extern(C++) interface soundInputStream
{
	long read(void* data, long size);
	
	long seek(long position);
	
	long tell();
	
	long getSize();
}


class soundFileStream:soundInputStream
{
	private InputStream myStream;
	
	this(InputStream stream)
	{
		myStream = stream;
	}
	
	extern(C++)long read(void* data, long size)
	{
		return myStream.read(data[0..cast(size_t)size]);
	}
	
	extern(C++)long seek(long position)
	{
		return myStream.seek(position);
	}

	extern(C++)long tell()
	{
		return myStream.tell();
	}
	
	extern(C++)long getSize()
	{
		return myStream.getSize();
	}
}


extern(C) const(char)* sfErr_getOutput();


extern(C)
{

struct sfSoundFile;

sfSoundFile* sfSoundFile_create();

void sfSoundFile_destroy(sfSoundFile* file);

long sfSoundFile_getSampleCount(const sfSoundFile* file);

uint sfSoundFile_getChannelCount( const sfSoundFile* file);

uint sfSoundFile_getSampleRate(const sfSoundFile* file);

bool sfSoundFile_openReadFromFile(sfSoundFile* file, const char* filename);

bool sfSoundFile_openReadFromMemory(sfSoundFile* file,const(void)* data, long sizeInBytes);

bool sfSoundFile_openReadFromStream(sfSoundFile* file, soundInputStream stream);

//bool sfSoundFile_openReadFromStream(sfSoundFile* file, void* stream);

bool sfSoundFile_openWrite(sfSoundFile* file, const(char)* filename,uint channelCount,uint sampleRate);

long sfSoundFile_read(sfSoundFile* file, short* data, long sampleCount);

void sfSoundFile_write(sfSoundFile* file, const short* data, long sampleCount);

void sfSoundFile_seek(sfSoundFile* file, long timeOffset);
	}
}
