//import AST.Nodes.HTML.HtmlDocument;
//import AST.Visitor;
//import FileHandling.CustomFileWriter;
//import Generated.Grammars.HTMLLexer;
//import Generated.Grammars.HTMLParser;
//import org.antlr.v4.runtime.CharStream;
//import org.antlr.v4.runtime.CommonTokenStream;
//import org.antlr.v4.runtime.tree.ParseTree;
//import java.io.File;
//import java.io.IOException;
//import static org.antlr.v4.runtime.CharStreams.fromFileName;
//
//public class Main {
//    public static void main(String[] args) {
//        try {
//            String source = "Files/input.html";
//            CharStream cs = fromFileName(source);
//            File outputFile = new File("Files/output.txt");
//            CustomFileWriter writer = new CustomFileWriter(outputFile);
//            HTMLLexer lexer = new HTMLLexer(cs);
//            CommonTokenStream token = new CommonTokenStream(lexer);
//            HTMLParser parser = new HTMLParser(token);
//            ParseTree tree = parser.htmlDocument();
//            HtmlDocument htmlDocument = (HtmlDocument) new Visitor().visit(tree);
//            writer.WriteTree(htmlDocument.toString());
//            writer.CloseFile(outputFile);
//        } catch (IOException e) {
//            e.printStackTrace();
//        }
//    }
//}
