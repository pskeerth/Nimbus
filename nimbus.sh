#!/bin/sh

ROOT_PATH=${PWD}

javac -d . -cp ".:$ROOT_PATH/lib/antlr-runtime-4.12.0.jar" src/com/nimbus/compiler/*.java
java -cp ".:$ROOT_PATH/lib/antlr-runtime-4.12.0.jar" com/nimbus/compiler/LexerGen $1
exec swipl -s $ROOT_PATH/src/com/nimbus/runtime/execute.pl -g "main('"$ROOT_PATH/$1tokens"', Ans), halt"