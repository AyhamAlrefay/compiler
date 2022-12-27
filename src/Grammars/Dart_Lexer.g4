lexer grammar Dart_Lexer;
//@lexer::header{
//import java.util.Stack;
//}
//
//@lexer::members{
//  public static final int BRACE_NORMAL = 1;
//  public static final int BRACE_SINGLE = 2;
//  public static final int BRACE_DOUBLE = 3;
//  public static final int BRACE_THREE_SINGLE = 4;
//  public static final int BRACE_THREE_DOUBLE = 5;
//
//  // Enable the parser to handle string interpolations via brace matching.
//  // The top of the `braceLevels` stack describes the most recent unmatched
//  // '{'. This is needed in order to enable/disable certain lexer rules.
//  //
//  //   NORMAL: Most recent unmatched '{' was not string literal related.
//  //   SINGLE: Most recent unmatched '{' was `'...${`.
//  //   DOUBLE: Most recent unmatched '{' was `"...${`.
//  //   THREE_SINGLE: Most recent unmatched '{' was `'''...${`.
//  //   THREE_DOUBLE: Most recent unmatched '{' was `"""...${`.
//  //
//  // Access via functions below.
//  private Stack<Integer> braceLevels = new Stack<Integer>();
//  // Whether we are currently in a string literal context, and which one.
//  boolean currentBraceLevel(int braceLevel) {
//    if (braceLevels.empty()) return false;
//    return braceLevels.peek() == braceLevel;
//  }
//  // Use this to indicate that we are now entering a specific '{...}'.
//  // Call it after accepting the '{'.
//  void enterBrace() {
//    braceLevels.push(BRACE_NORMAL);
//  }
//  void enterBraceSingleQuote() {
//    braceLevels.push(BRACE_SINGLE);
//  }
//  void enterBraceDoubleQuote() {
//    braceLevels.push(BRACE_DOUBLE);
//  }
//  void enterBraceThreeSingleQuotes() {
//    braceLevels.push(BRACE_THREE_SINGLE);
//  }
//  void enterBraceThreeDoubleQuotes() {
//    braceLevels.push(BRACE_THREE_DOUBLE);
//  }
//  // Use this to indicate that we are now exiting a specific '{...}',
//  // no matter which kind. Call it before accepting the '}'.
//  void exitBrace() {
//      // We might raise a parse error here if the stack is empty, but the
//      // parsing rules should ensure that we get a parse error anyway, and
//      // it is not a big problem for the spec parser even if it misinterprets
//      // the brace structure of some programs with syntax errors.
//      if (!braceLevels.empty()) braceLevels.pop();
//  }
//}


COMMA
    : ','
    ;
SEMICOLON
    : ';'
    ;
EQUAL
    : '='
    ;
STAR
    : '*'
    ;
MINUS
    : '-'
    ;
MINUS_MINUS
    : '--'
    ;
ADD
    : '+'
    ;
ADD_ADD
    : '++'
    ;
AND
    : '&'
    ;
AND_AND
    : '&&'
    ;
GREATER_THAN
    : '>'
    ;
LESS_THAN
    : '<'
    ;
LESS_THAN_LESS_THAN
    : '<<'
    ;
CARET
    : '^'
    ;
SLASH
    : '/'
    ;
TILDE_SLASH
    : '~/'
    ;
PERCENT
    : '%'
    ;
PARENTHESES_OPEN
    : '('
    ;
PARENTHESES_CLOSE
    : ')'
    ;

SQUARE_BRACJETS_OPEN
    : '['
    ;
SQUARE_BRACJETS_CLOSE
    : ']'
    ;
NOT
    : '!'
    ;
STAR_EQUAL
    : '*='
    ;

SLASH_EQUAL
    : '/='
    ;
TILDE_SLASH_EQUAL
    : '~/='
    ;
PERCENT_EQUAL
    : '%='
    ;
ADD_EQUAL
    : '+='
    ;
MINUS_EQUAL
    : '-='
    ;
LESS_LESS_EQUAL
    : '<<='
    ;
AND_EQUAL
    : '&='
    ;
CARET_EQUAL
    : '^='
    ;
BAR_EQUAL
    : '|='
    ;
QUESTION_QUESTION_EQUAL
    : '??='
    ;

EQUAL_EQUAL
    : '=='
    ;
NOT_EQUAL
    : '!='
    ;
ELLIPSIS
    : '...'
    ;
DOT
    : '.'
    ;
DOT_DOT
    : '..'
    ;
QUESTION_MARK_DOT_DOT
    : '?..'
    ;
COLON
    : ':'
    ;
QUESTION_MARK
    : '?'
    ;
QUESTION_MARK_QUESTION_MARK
    : '??'
    ;
QUESTION_MARK_DOT
    : '?.'
    ;
AT
    : '@'
    ;
EGT
    : '=>'
    ;
LTE
    : '<='
    ;

TILDE
    : '~'
    ;
ELLIPSIS_QUESTION_MARK
    : '...?'
    ;
HASH
    : '#'
    ;
BAR
    : '|'
    ;
BAR_BAR
    : '||'
    ;
fragment
LETTER
    :    'a' .. 'z'
    |    'A' .. 'Z'
    ;
fragment
DIGIT
    :    '0' .. '9'
    ;
fragment
EXPONENT
    :    ('e' | 'E') ('+' | '-')? DIGIT+
    ;
fragment
HEX_DIGIT
    :    ('a' | 'b' | 'c' | 'd' | 'e' | 'f')
    |    ('A' | 'B' | 'C' | 'D' | 'E' | 'F')
    |    DIGIT
    ;
// Reserved words.
ASSERT
    :    'assert'
    ;
BREAK
    :    'break'
    ;
CASE
    :    'case'
    ;
CATCH
    :    'catch'
    ;
CLASS
    :    'class'
    ;
CONST
    :    'const'
    ;
CONTINUE
    :    'continue'
    ;
DEFAULT
    :    'default'
    ;
DO
    :    'do'
    ;
ELSE
    :    'else'
    ;
ENUM
    :    'enum'
    ;
EXTENDS
    :    'extends'
    ;
FALSE
    :    'false'
    ;
FINAL
    :    'final'
    ;
FINALLY
    :    'finally'
    ;
FOR
    :    'for'
    ;
IF
    :    'if'
    ;
IN
    :    'in'
    ;
IS
    :    'is'
    ;
NEW
    :    'new'
    ;
NULL
    :    'null'
    ;
RETHROW
    :    'rethrow'
    ;
RETURN
    :    'return'
    ;
SUPER
    :    'super'
    ;
SWITCH
    :    'switch'
    ;
THIS
    :    'this'
    ;
THROW
    :    'throw'
    ;
TRUE
    :    'true'
    ;
TRY
    :    'try'
    ;
VAR
    :    'var'
    ;
VOID
    :    'void'
    ;
WHILE
    :    'while'
    ;
WITH
    :    'with'
    ;
// Built-in identifiers.
ABSTRACT
    :    'abstract'
    ;
AS
    :    'as'
    ;
COVARIANT
    :    'covariant'
    ;
DEFERRED
    :    'deferred'
    ;
DYNAMIC
    :    'dynamic'
    ;
EXPORT
    :    'export'
    ;
EXTENSION
    :    'extension'
    ;
EXTERNAL
    :    'external'
    ;
FACTORY
    :    'factory'
    ;
FUNCTION
    :    'Function'
    ;
GET
    :    'get'
    ;
IMPLEMENTS
    :    'implements'
    ;
IMPORT
    :    'import'
    ;
INTERFACE
    :    'interface'
    ;
LATE
    :    'late'
    ;
LIBRARY
    :    'library'
    ;
OPERATOR
    :    'operator'
    ;
MIXIN
    :    'mixin'
    ;
PART
    :    'part'
    ;
REQUIRED
    :    'required'
    ;
SET
    :    'set'
    ;
STATIC
    :    'static'
    ;
TYPEDEF
    :    'typedef'
    ;
// "Contextual keywords".
AWAIT
    :    'await'
    ;
YIELD
    :    'yield'
    ;
// Other words used in the grammar.
ASYNC
    :    'async'
    ;
HIDE
    :    'hide'
    ;
OF
    :    'of'
    ;
ON
    :    'on'
    ;
SHOW
    :    'show'
    ;
SYNC
    :    'sync'
    ;
WHEN
    :    'when'
    ;
// Lexical tokens that are not words.
NUMBER
    :    DIGIT+ '.' DIGIT+ EXPONENT?
    |    DIGIT+ EXPONENT?
    |    '.' DIGIT+ EXPONENT?
    ;
HEX_NUMBER
    :    '0x' HEX_DIGIT+
    |    '0X' HEX_DIGIT+
    ;
RAW_SINGLE_LINE_STRING
    :    'r' '\'' (~('\'' | '\r' | '\n'))* '\''
    |    'r' '"' (~('"' | '\r' | '\n'))* '"'
    ;
RAW_MULTI_LINE_STRING
    :    'r' '"""' (.)*? '"""'
    |    'r' '\'\'\'' (.)*? '\'\'\''
    ;

fragment
SIMPLE_STRING_INTERPOLATION
    :    '$' IDENTIFIER_NO_DOLLAR
    ;

fragment
ESCAPE_SEQUENCE
    :    '\\n'
    |    '\\r'
    |    '\\b'
    |    '\\t'
    |    '\\v'
    |    '\\x' HEX_DIGIT HEX_DIGIT
    |    '\\u' HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT
    |    '\\u{' HEX_DIGIT_SEQUENCE '}'
    ;

fragment
HEX_DIGIT_SEQUENCE
    :    HEX_DIGIT HEX_DIGIT? HEX_DIGIT?
         HEX_DIGIT? HEX_DIGIT? HEX_DIGIT?
    ;

fragment
STRING_CONTENT_COMMON
    :    ~('\\' | '\'' | '"' | '$' | '\r' | '\n')
    |    ESCAPE_SEQUENCE
    |    '\\' ~('n' | 'r' | 'b' | 't' | 'v' | 'x' | 'u' | '\r' | '\n')
    |    SIMPLE_STRING_INTERPOLATION
    ;

fragment
STRING_CONTENT_SQ
    :    STRING_CONTENT_COMMON
    |    '"'
    ;

SINGLE_LINE_STRING_SQ_BEGIN_END
    :    '\'' STRING_CONTENT_SQ* '\''
    ;

SINGLE_LINE_STRING_SQ_BEGIN_MID
    :    '\'' STRING_CONTENT_SQ* '${' { enterBraceSingleQuote(); }
    ;

SINGLE_LINE_STRING_SQ_MID_MID
    :    { currentBraceLevel(BRACE_SINGLE) }?
         { exitBrace(); } '}' STRING_CONTENT_SQ* '${'
         { enterBraceSingleQuote(); }
    ;

SINGLE_LINE_STRING_SQ_MID_END
    :    { currentBraceLevel(BRACE_SINGLE) }?
         { exitBrace(); } '}' STRING_CONTENT_SQ* '\''
    ;

fragment
STRING_CONTENT_DQ
    :    STRING_CONTENT_COMMON
    |    '\''
    ;

SINGLE_LINE_STRING_DQ_BEGIN_END
    :    '"' STRING_CONTENT_DQ* '"'
    ;

SINGLE_LINE_STRING_DQ_BEGIN_MID
    :    '"' STRING_CONTENT_DQ* '${' { enterBraceDoubleQuote(); }
    ;

SINGLE_LINE_STRING_DQ_MID_MID
    :    { currentBraceLevel(BRACE_DOUBLE) }?
         { exitBrace(); } '}' STRING_CONTENT_DQ* '${'
         { enterBraceDoubleQuote(); }
    ;

SINGLE_LINE_STRING_DQ_MID_END
    :    { currentBraceLevel(BRACE_DOUBLE) }?
         { exitBrace(); } '}' STRING_CONTENT_DQ* '"'
    ;

fragment
QUOTES_SQ
    :
    |    '\''
    |    '\'\''
    ;

// Read string contents, which may be almost anything, but stop when seeing
// '\'\'\'' and when seeing '${'. We do this by allowing all other
// possibilities including escapes, simple interpolation, and fewer than
// three '\''.
fragment
STRING_CONTENT_TSQ
    :    QUOTES_SQ
         (STRING_CONTENT_COMMON | '"' | '\r' | '\n' | '\\\r' | '\\\n')
    ;

MULTI_LINE_STRING_SQ_BEGIN_END
    :    '\'\'\'' STRING_CONTENT_TSQ* '\'\'\''
    ;

MULTI_LINE_STRING_SQ_BEGIN_MID
    :    '\'\'\'' STRING_CONTENT_TSQ* QUOTES_SQ '${'
         { enterBraceThreeSingleQuotes(); }
    ;

MULTI_LINE_STRING_SQ_MID_MID
    :    { currentBraceLevel(BRACE_THREE_SINGLE) }?
         { exitBrace(); } '}' STRING_CONTENT_TSQ* QUOTES_SQ '${'
         { enterBraceThreeSingleQuotes(); }
    ;

MULTI_LINE_STRING_SQ_MID_END
    :    { currentBraceLevel(BRACE_THREE_SINGLE) }?
         { exitBrace(); } '}' STRING_CONTENT_TSQ* '\'\'\''
    ;

fragment
QUOTES_DQ
    :
    |    '"'
    |    '""'
    ;

// Read string contents, which may be almost anything, but stop when seeing
// '"""' and when seeing '${'. We do this by allowing all other possibilities
// including escapes, simple interpolation, and fewer-than-three '"'.
fragment
STRING_CONTENT_TDQ
    :    QUOTES_DQ
         (STRING_CONTENT_COMMON | '\'' | '\r' | '\n' | '\\\r' | '\\\n')
    ;

MULTI_LINE_STRING_DQ_BEGIN_END
    :    '"""' STRING_CONTENT_TDQ* '"""'
    ;

MULTI_LINE_STRING_DQ_BEGIN_MID
    :    '"""' STRING_CONTENT_TDQ* QUOTES_DQ '${'
         { enterBraceThreeDoubleQuotes(); }
    ;

MULTI_LINE_STRING_DQ_MID_MID
    :    { currentBraceLevel(BRACE_THREE_DOUBLE) }?
         { exitBrace(); } '}' STRING_CONTENT_TDQ* QUOTES_DQ '${'
         { enterBraceThreeDoubleQuotes(); }
    ;

MULTI_LINE_STRING_DQ_MID_END
    :    { currentBraceLevel(BRACE_THREE_DOUBLE) }?
         { exitBrace(); } '}' STRING_CONTENT_TDQ* '"""'
    ;

LBRACE
    :    '{' { enterBrace(); }
    ;

RBRACE
    :    { currentBraceLevel(BRACE_NORMAL) }? { exitBrace(); } '}'
    ;

fragment
IDENTIFIER_START_NO_DOLLAR
    :    LETTER
    |    '_'
    ;

fragment
IDENTIFIER_PART_NO_DOLLAR
    :    IDENTIFIER_START_NO_DOLLAR
    |    DIGIT
    ;

fragment
IDENTIFIER_NO_DOLLAR
    :    IDENTIFIER_START_NO_DOLLAR IDENTIFIER_PART_NO_DOLLAR*
    ;

fragment
IDENTIFIER_START
    :    IDENTIFIER_START_NO_DOLLAR
    |    '$'
    ;

fragment
IDENTIFIER_PART
    :    IDENTIFIER_START
    |    DIGIT
    ;

IDENTIFIER
    :    IDENTIFIER_START IDENTIFIER_PART*
    ;

SINGLE_LINE_COMMENT
    :    '//' (~('\r' | '\n'))* NEWLINE?
         -> skip
    ;

MULTI_LINE_COMMENT
    :    '/*' (MULTI_LINE_COMMENT | .)*? '*/'
         -> skip
    ;

fragment
NEWLINE
    :    ('\r' | '\n' | '\r\n')
    ;



WS
    :    (' ' | '\t' | '\r' | '\n')+
        -> skip
    ;

INTEGER
    : 'int'
    ;
DOUBLE
    : 'double'
    ;
FLOAT
    : 'float'
    ;
STRING
    : 'String'
    ;
BOOLEAN
    : 'bool'
    ;
LIST
    : 'List'
    ;
MAP
    : 'Map'
    ;
DATA_TYPE
    : INTEGER
    | DOUBLE
    | FLOAT
    | STRING
    | BOOLEAN
    | DYNAMIC
    | VAR
    ;