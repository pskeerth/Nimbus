package compiler;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.Token;

import java.io.FileWriter;
import java.io.IOException;

public class Lexer {
    public static void main(String[] args) throws IOException {

        String filename = "";
        filename = args.length > 0 ? args[0] : null;
        if (filename.equals(null)){
            System.out.println("input filename can't be empty");
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
            System.out.print("hi");
            System.out.println(token);
            writer.write(token.getText() + "\n");
        }
        writer.close();
    }
}