package com.nimbus.compiler;

import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.Token;

import java.io.FileWriter;
import java.io.IOException;

public class LexerGen {
    public static void main(String[] args) throws IOException {

        String filename = "";
        filename = args.length > 0 ? args[0] : null;
        if (filename.equals(null)){
            System.out.println("Please enter an input file name");
            return;
        }

        if (!filename.contains(".nimb")) {
            System.out.println("Enter a valid .nimb file");
            return;
        }

        CharStream input = CharStreams.fromFileName(filename);
        NimbusLexer lexer = new NimbusLexer(input);
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        tokens.fill();
        FileWriter writer = new FileWriter(filename+"tokens");
        for (Token token : tokens.getTokens()) {
            if(token.getText().equals("<EOF>")) break;
            writer.write(token.getText() + "\n");
        }
        writer.close();
    }
}