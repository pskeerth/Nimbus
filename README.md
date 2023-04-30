# SER502-Spring2023-Team14
SER502 - Project: Compiler and Virtual Machine for a Programming Language
====================
Team Members
1. Shanmugapriyan Ravichanthiran
2. Poornima Sathya Keerthi
3. Prasant Ganesan
4. Joseph Thomas


Platform
---------
1. MacOS
2. Linux
3. Windows

Tools used:
--------
ANTLR (Another Tool for Language Recognition) 
We have used ANTLR to write the Lexer for our language because it is an efficient tool to write well-optimized lexers and parsers. It supports our chosen language Java, and also offers a rich set of features. If we were to write the Lexer on our own, it would be a complicated process of generating tokens by splitting it and serializing those tokens.

Install Instructions(for Mac, Linus and Windows)
---------
git clone https://github.com/pskeerth/SER502-Spring2023-Team14.git 

Run Instructions
---------
You need to have swi-prolog installed in your system
Run the below shell script command to execute:

sh nimbus.sh <sample-prog-path>.nimb

Eg: sh nimbus.sh data/if_sample.nimb

NOTE: For windows, please enable Windows subsystem for Linux, otherwise it may cause issues since it is a bash command. 
There are no restrictions for Mac. 



Future Scope
---------
We are planning to add:
1. Data structures: List, Map
2. Data types: Double, Char
3. Functions

