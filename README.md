DSFML
=====

DSFML is a D static binding of SFML, which let's you use SFML in your D program. DSFML attempts to be as compatible with SFML as possible, but does so in a D way by using new D semanics, as well as avoiding raw pointers. 



Compiling a project using DSFML
===

You can use DSFML in one of two ways, both of which are simple. You can either compile the source code into a library and link against it in your final project, or simply include the source code along with your own when compiling. DSFML is based on CSFML(which can be downloaded from SFML's website) and need's its shared libraries and import libraries in order to compile properly. Link against the import libraries, and make sure the application has access to the shared libraries and you should be good to go! If you are on Windows, you need to make sure that your import libraries are compatible with D. The easiest way to do this is to use [implib](http://www.digitalmars.com/ctg/implib.html) to make the import library based off a .dll, and it should work regardless of the compiler used to build CSFML.


If problems are encountered!
===

This is my first project that I have provided others to use, so feel free to give me feed back. Especially if you encounter an issue that prevents you from using the binding!

Email is <dehaan.jeremiah@gmail.com>
