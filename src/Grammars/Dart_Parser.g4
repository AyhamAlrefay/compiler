
parser grammar Dart_Parser;
options { tokenVocab= Dart_Lexer; }
//@parser::header{
//import java.util.Stack;
//}
//
//
//@parser::members {
//  static String filePath = null;
//  static boolean errorHasOccurred = false;
//
//  /// Must be invoked before the first error is reported for a library.
//  /// Will print the name of the library and indicate that it has errors.
//  static void prepareForErrors() {
//    errorHasOccurred = true;
//    System.err.println("Syntax error in " + filePath + ":");
//  }
//
//  /// Parse library, return true if success, false if errors occurred.
//  public boolean parseLibrary(String filePath) throws RecognitionException {
//    this.filePath = filePath;
//    errorHasOccurred = false;
//    libraryDefinition();
//    return !errorHasOccurred;
//  }
//
//  // Enable the parser to treat AWAIT/YIELD as keywords in the body of an
//  // `async`, `async*`, or `sync*` function. Access via methods below.
//  private Stack<Boolean> asyncEtcAreKeywords = new Stack<Boolean>();
//  { asyncEtcAreKeywords.push(false); }
//
//  // Use this to indicate that we are now entering an `async`, `async*`,
//  // or `sync*` function.
//  void startAsyncFunction() { asyncEtcAreKeywords.push(true); }
//
//  // Use this to indicate that we are now entering a function which is
//  // neither `async`, `async*`, nor `sync*`.
//  void startNonAsyncFunction() { asyncEtcAreKeywords.push(false); }
//
//  // Use this to indicate that we are now leaving any funciton.
//  void endFunction() { asyncEtcAreKeywords.pop(); }
//
//  // Whether we can recognize AWAIT/YIELD as an identifier/typeIdentifier.
//  boolean asyncEtcPredicate(int tokenId) {
//    if (tokenId == AWAIT || tokenId == YIELD) {
//      return !asyncEtcAreKeywords.peek();
//    }
//    return false;
//  }
//}


// ---------------------------------------- Grammar rules.
libraryDefinition
    :    libraryName?
         importOrExport*
         partDirective*
         (metadata topLevelDefinition)*
         EOF
    ;
topLevelDefinition
    :    classDeclaration
    |    mixinDeclaration
    |    extensionDeclaration
    |    enumType
    |    typeAlias
    |    EXTERNAL functionSignature SEMICOLON
    |    EXTERNAL getterSignature SEMICOLON
    |    EXTERNAL setterSignature SEMICOLON
    |    EXTERNAL finalVarOrType identifierList SEMICOLON
    |    getterSignature functionBody
    |    setterSignature functionBody
    |    functionSignature functionBody
    |    (FINAL | CONST) type? staticFinalDeclarationList SEMICOLON
    |    LATE FINAL type? initializedIdentifierList SEMICOLON
    |    LATE? varOrType identifier (EQUAL expression)?
         (COMMA initializedIdentifier)* SEMICOLON
    ;
declaredIdentifier
    :    COVARIANT? finalConstVarOrType identifier
    ;
finalConstVarOrType
    :    LATE? FINAL type?
    |    CONST type?
    |    LATE? varOrType
    ;
finalVarOrType
    :    FINAL type?
    |    varOrType
    ;
varOrType
    :    VAR
    |    type
    ;
initializedIdentifier
    :    identifier (EQUAL expression)?
    ;
initializedIdentifierList
    :    initializedIdentifier (COMMA initializedIdentifier)*
    ;
functionSignature
    :    type? identifierNotFUNCTION formalParameterPart
    ;
functionBodyPrefix
    :    ASYNC? EGT
    |    (ASYNC | ASYNC STAR | SYNC STAR)? LBRACE
    ;
functionBody
    :    EGT { startNonAsyncFunction(); } expression { endFunction(); } SEMICOLON
    |    { startNonAsyncFunction(); } block { endFunction(); }
    |    ASYNC EGT
         { startAsyncFunction(); } expression { endFunction(); } SEMICOLON
    |    (ASYNC | ASYNC STAR | SYNC STAR)
         { startAsyncFunction(); } block { endFunction(); }
    ;
block
    :    LBRACE statements RBRACE
    ;
formalParameterPart
    :    typeParameters? formalParameterList
    ;
formalParameterList
    :    PARENTHESES_OPEN PARENTHESES_CLOSE
    |    PARENTHESES_OPEN normalFormalParameters COMMA? PARENTHESES_CLOSE
    |    PARENTHESES_OPEN normalFormalParameters COMMA optionalOrNamedFormalParameters PARENTHESES_CLOSE
    |    PARENTHESES_OPEN optionalOrNamedFormalParameters PARENTHESES_CLOSE
    ;
normalFormalParameters
    :    normalFormalParameter (COMMA normalFormalParameter)*
    ;
optionalOrNamedFormalParameters
    :    optionalPositionalFormalParameters
    |    namedFormalParameters
    ;
optionalPositionalFormalParameters
    :    SQUARE_BRACJETS_OPEN defaultFormalParameter (COMMA defaultFormalParameter)* COMMA? SQUARE_BRACJETS_CLOSE
    ;
namedFormalParameters
    :    LBRACE defaultNamedParameter (COMMA defaultNamedParameter)* COMMA? RBRACE
    ;
normalFormalParameter
    :    metadata normalFormalParameterNoMetadata
    ;
normalFormalParameterNoMetadata
    :    functionFormalParameter
    |    fieldFormalParameter
    |    simpleFormalParameter
    |    superFormalParameter
    ;
// NB: It is an anomaly that a functionFormalParameter cannot be FINAL.
functionFormalParameter
    :    COVARIANT? type? identifierNotFUNCTION formalParameterPart QUESTION_MARK?
    ;
simpleFormalParameter
    :    declaredIdentifier
    |    COVARIANT? identifier
    ;
// NB: It is an anomaly that VAR can be a return type (`var this.x()`).
fieldFormalParameter
    :    finalConstVarOrType? THIS DOT identifier (formalParameterPart QUESTION_MARK?)?
    ;
superFormalParameter
    :    type? SUPER DOT identifier (formalParameterPart QUESTION_MARK?)?
    ;
defaultFormalParameter
    :    normalFormalParameter (EQUAL expression)?
    ;
defaultNamedParameter
    :    REQUIRED? normalFormalParameter ((COLON | EQUAL) expression)?
    ;
typeWithParameters
    :    typeIdentifier typeParameters?
    ;
classDeclaration
    :    ABSTRACT? CLASS typeWithParameters superclass? mixins? interfaces?
         LBRACE (metadata classMemberDefinition)* RBRACE
    |    ABSTRACT? CLASS mixinApplicationClass
    ;
superclass
    :    EXTENDS typeNotVoidNotFunction
    ;
mixins
    :    WITH typeNotVoidNotFunctionList
    ;
interfaces
    :    IMPLEMENTS typeNotVoidNotFunctionList
    ;
classMemberDefinition
    :    methodSignature functionBody
    |    declaration SEMICOLON
    ;
mixinApplicationClass
    :    typeWithParameters EQUAL mixinApplication SEMICOLON
    ;
mixinDeclaration
    :    MIXIN typeIdentifier typeParameters?
         (ON typeNotVoidNotFunctionList)? interfaces?
         LBRACE (metadata mixinMemberDefinition)* RBRACE
    ;
// TODO: We will probably want to make this more strict.
mixinMemberDefinition
    :    classMemberDefinition
    ;
extensionDeclaration
    :    EXTENSION identifier? typeParameters? ON type
         LBRACE (metadata extensionMemberDefinition)* RBRACE
    ;
// TODO: We might want to make this more strict.
extensionMemberDefinition
    :    classMemberDefinition
    ;
methodSignature
    :    constructorSignature initializers
    |    factoryConstructorSignature
    |    STATIC? functionSignature
    |    STATIC? getterSignature
    |    STATIC? setterSignature
    |    operatorSignature
    |    constructorSignature
    ;
declaration
    :    EXTERNAL factoryConstructorSignature
    |    EXTERNAL constantConstructorSignature
    |    EXTERNAL constructorSignature
    |    (EXTERNAL STATIC?)? getterSignature
    |    (EXTERNAL STATIC?)? setterSignature
    |    (EXTERNAL STATIC?)? functionSignature
    |    EXTERNAL (STATIC? finalVarOrType | COVARIANT varOrType) identifierList
    |    ABSTRACT (finalVarOrType | COVARIANT varOrType) identifierList
    |    EXTERNAL? operatorSignature
    |    STATIC (FINAL | CONST) type? staticFinalDeclarationList
    |    STATIC LATE FINAL type? initializedIdentifierList
    |    STATIC LATE? varOrType initializedIdentifierList
    |    COVARIANT LATE FINAL type? identifierList
    |    COVARIANT LATE? varOrType initializedIdentifierList
    |    LATE? (FINAL type? | varOrType) initializedIdentifierList
    |    redirectingFactoryConstructorSignature
    |    constantConstructorSignature (redirection | initializers)?
    |    constructorSignature (redirection | initializers)?
    ;
staticFinalDeclarationList
    :    staticFinalDeclaration (COMMA staticFinalDeclaration)*
    ;
staticFinalDeclaration
    :    identifier EQUAL expression
    ;
operatorSignature
    :    type? OPERATOR operator formalParameterList
    ;
operator
    :    TILDE
    |    binaryOperator
    |    SQUARE_BRACJETS_OPEN SQUARE_BRACJETS_CLOSE
    |    SQUARE_BRACJETS_OPEN SQUARE_BRACJETS_CLOSE EQUAL
    ;
binaryOperator
    :    multiplicativeOperator
    |    additiveOperator
    |    shiftOperator
    |    relationalOperator
    |    EQUAL_EQUAL
    |    bitwiseOperator
    ;
getterSignature
    :    type? GET identifier
    ;
setterSignature
    :    type? SET identifier formalParameterList
    ;
constructorSignature
    :    constructorName formalParameterList
    ;
constructorName
    :    typeIdentifier (DOT (identifier | NEW))?
    ;
redirection
    :    COLON THIS (DOT (identifier | NEW))? arguments
    ;
initializers
    :    COLON initializerListEntry (COMMA initializerListEntry)*
    ;
initializerListEntry
    :    SUPER arguments
    |    SUPER DOT (identifier | NEW) arguments
    |    fieldInitializer
    |    assertion
    ;
fieldInitializer
    :    (THIS DOT)? identifier EQUAL initializerExpression
    ;
initializerExpression
    :    conditionalExpression
    |    cascade
    ;
factoryConstructorSignature
    :    CONST? FACTORY constructorName formalParameterList
    ;
redirectingFactoryConstructorSignature
    :    CONST? FACTORY constructorName formalParameterList EQUAL
         constructorDesignation
    ;
constantConstructorSignature
    :    CONST constructorName formalParameterList
    ;
mixinApplication
    :    typeNotVoidNotFunction mixins interfaces?
    ;
enumType
    :    ENUM typeIdentifier typeParameters? mixins? interfaces? LBRACE
         enumEntry (COMMA enumEntry)* (COMMA)?
         (SEMICOLON (metadata classMemberDefinition)*)?
         RBRACE
    ;
enumEntry
    :    metadata identifier argumentPart?
    |    metadata identifier typeArguments? DOT identifier arguments
    ;
typeParameter
    :    metadata typeIdentifier (EXTENDS typeNotVoid)?
    ;
typeParameters
    :    LESS_THAN typeParameter (COMMA typeParameter)* GREATER_THAN
    ;
metadata
    :    (AT metadatum)*
    ;
metadatum
    :    constructorDesignation arguments
    |    identifier
    |    qualifiedName
    ;
expression
    :    patternAssignment
    |    functionExpression
    |    throwExpression
    |    assignableExpression assignmentOperator expression
    |    conditionalExpression
    |    cascade
    ;
expressionWithoutCascade
    :    functionExpressionWithoutCascade
    |    throwExpressionWithoutCascade
    |    assignableExpression assignmentOperator expressionWithoutCascade
    |    conditionalExpression
    ;
expressionList
    :    expression (COMMA expression)*
    ;
primary
    :    thisExpression
    |    SUPER unconditionalAssignableSelector
    |    constObjectExpression
    |    newExpression
    |    constructorInvocation
    |    functionPrimary
    |    PARENTHESES_OPEN expression PARENTHESES_CLOSE
    |    literal
    |    identifier
    |    constructorTearoff
    |    switchExpression
    ;
constructorInvocation
    :    typeName typeArguments DOT NEW arguments
    |    typeName DOT NEW arguments
    ;
literal
    :    nullLiteral
    |    booleanLiteral
    |    numericLiteral
    |    stringLiteral
    |    symbolLiteral
    |    setOrMapLiteral
    |    listLiteral
    |    recordLiteral
    ;
nullLiteral
    :    NULL
    ;
numericLiteral
    :    NUMBER
    |    HEX_NUMBER
    ;
booleanLiteral
    :    TRUE
    |    FALSE
    ;
stringLiteral
    :    (multiLineString | singleLineString)+
    ;
// Not used in the specification (needed here for <uri>).
stringLiteralWithoutInterpolation
    :    singleStringWithoutInterpolation+
    ;
setOrMapLiteral
    :    CONST? typeArguments? LBRACE elements? RBRACE
    ;
listLiteral
    :    CONST? typeArguments? SQUARE_BRACJETS_OPEN elements? SQUARE_BRACJETS_CLOSE
    ;
recordLiteral
    :    CONST? recordLiteralNoConst
    ;
recordLiteralNoConst
    :    PARENTHESES_OPEN PARENTHESES_CLOSE
    |    PARENTHESES_OPEN expression COMMA PARENTHESES_CLOSE
    |    PARENTHESES_OPEN label expression COMMA? PARENTHESES_CLOSE
    |    PARENTHESES_OPEN recordField COMMA recordField (COMMA recordField)* COMMA? PARENTHESES_CLOSE
    ;
recordField
    :    label? expression
    ;
elements
    : element (COMMA element)* COMMA?
    ;
element
    : expressionElement
    | mapElement
    | spreadElement
    | ifElement
    | forElement
    ;
expressionElement
    : expression
    ;
mapElement
    : expression COLON expression
    ;
spreadElement
    : (ELLIPSIS | ELLIPSIS_QUESTION_MARK) expression
    ;
ifElement
    : ifCondition element (ELSE element)?
    ;
forElement
    : AWAIT? FOR PARENTHESES_OPEN forLoopParts PARENTHESES_CLOSE element
    ;
constructorTearoff
    :    typeName typeArguments? DOT NEW
    ;
switchExpression
    :    SWITCH PARENTHESES_OPEN expression PARENTHESES_CLOSE
         LBRACE switchExpressionCase (COMMA switchExpressionCase)* COMMA? RBRACE
    ;
switchExpressionCase
    :    guardedPattern EGT expression
    ;
throwExpression
    :    THROW expression
    ;
throwExpressionWithoutCascade
    :    THROW expressionWithoutCascade
    ;
functionExpression
    :    formalParameterPart functionExpressionBody
    ;
functionExpressionBody
    :    EGT { startNonAsyncFunction(); } expression { endFunction(); }
    |    ASYNC EGT { startAsyncFunction(); } expression { endFunction(); }
    ;
functionExpressionBodyPrefix
    :    ASYNC? EGT
    ;
functionExpressionWithoutCascade
    :    formalParameterPart functionExpressionWithoutCascadeBody
    ;
functionExpressionWithoutCascadeBody
    :    EGT { startNonAsyncFunction(); }
         expressionWithoutCascade { endFunction(); }
    |    ASYNC EGT { startAsyncFunction(); }
         expressionWithoutCascade { endFunction(); }
    ;
functionPrimary
    :    formalParameterPart functionPrimaryBody
    ;
functionPrimaryBody
    :    { startNonAsyncFunction(); } block { endFunction(); }
    |    (ASYNC | ASYNC STAR | SYNC STAR)
         { startAsyncFunction(); } block { endFunction(); }
    ;
functionPrimaryBodyPrefix
    : (ASYNC | ASYNC STAR | SYNC STAR)? LBRACE
    ;
thisExpression
    :    THIS
    ;
newExpression
    :    NEW constructorDesignation arguments
    ;
constObjectExpression
    :    CONST constructorDesignation arguments
    ;
arguments
    :    PARENTHESES_OPEN (argumentList COMMA?)? PARENTHESES_CLOSE
    ;
argumentList
    :    argument (COMMA argument)*
    ;
argument
    :    label? expression
    ;
cascade
    :     cascade DOT_DOT cascadeSection
    |     conditionalExpression (QUESTION_MARK_DOT_DOT | DOT_DOT) cascadeSection
    ;
cascadeSection
    :    cascadeSelector cascadeSectionTail
    ;
cascadeSelector
    :    SQUARE_BRACJETS_OPEN expression SQUARE_BRACJETS_CLOSE
    |    identifier
    ;
cascadeSectionTail
    :    cascadeAssignment
    |    selector* (assignableSelector cascadeAssignment)?
    ;
cascadeAssignment
    :    assignmentOperator expressionWithoutCascade
    ;
assignmentOperator
    :    EQUAL
    |    compoundAssignmentOperator
    ;
compoundAssignmentOperator
    :    STAR_EQUAL
    |    SLASH_EQUAL
    |    TILDE_SLASH_EQUAL
    |    PERCENT_EQUAL
    |    ADD_EQUAL
    |    MINUS_EQUAL
    |    LESS_LESS_EQUAL
    |    GREATER_THAN GREATER_THAN GREATER_THAN EQUAL
    |    GREATER_THAN GREATER_THAN EQUAL
    |    AND_EQUAL
    |    CARET_EQUAL
    |    BAR_EQUAL
    |    QUESTION_QUESTION_EQUAL
    ;
conditionalExpression
    :    ifNullExpression
         (QUESTION_MARK expressionWithoutCascade COLON expressionWithoutCascade)?
    ;
ifNullExpression
    :    logicalOrExpression (QUESTION_MARK_QUESTION_MARK logicalOrExpression)*
    ;
logicalOrExpression
    :    logicalAndExpression (BAR_BAR logicalAndExpression)*
    ;
logicalAndExpression
    :    equalityExpression (AND_AND equalityExpression)*
    ;
equalityExpression
    :    relationalExpression (equalityOperator relationalExpression)?
    |    SUPER equalityOperator relationalExpression
    ;
equalityOperator
    :    EQUAL_EQUAL
    |    NOT_EQUAL
    ;
relationalExpression
    :    bitwiseOrExpression
         (typeTest | typeCast | relationalOperator bitwiseOrExpression)?
    |    SUPER relationalOperator bitwiseOrExpression
    ;
relationalOperator
    :    GREATER_THAN EQUAL
    |    GREATER_THAN
    |    LTE
    |    LESS_THAN
    ;
bitwiseOrExpression
    :    bitwiseXorExpression (BAR bitwiseXorExpression)*
    |    SUPER (BAR bitwiseXorExpression)+
    ;
bitwiseXorExpression
    :    bitwiseAndExpression (CARET bitwiseAndExpression)*
    |    SUPER (CARET bitwiseAndExpression)+
    ;
bitwiseAndExpression
    :    shiftExpression (AND shiftExpression)*
    |    SUPER (AND shiftExpression)+
    ;
bitwiseOperator
    :    AND
    |    CARET
    |    BAR
    ;
shiftExpression
    :    additiveExpression (shiftOperator additiveExpression)*
    |    SUPER (shiftOperator additiveExpression)+
    ;
shiftOperator
    :    LESS_THAN_LESS_THAN
    |    GREATER_THAN GREATER_THAN GREATER_THAN
    |    GREATER_THAN GREATER_THAN
    ;
additiveExpression
    :    multiplicativeExpression (additiveOperator multiplicativeExpression)*
    |    SUPER (additiveOperator multiplicativeExpression)+
    ;
additiveOperator
    :    ADD
    |    MINUS
    ;
multiplicativeExpression
    :    unaryExpression (multiplicativeOperator unaryExpression)*
    |    SUPER (multiplicativeOperator unaryExpression)+
    ;
multiplicativeOperator
    :    STAR
    |    SLASH
    |    PERCENT
    |    TILDE_SLASH
    ;
unaryExpression
    :    prefixOperator unaryExpression
    |    awaitExpression
    |    postfixExpression
    |    (minusOperator | tildeOperator) SUPER
    |    incrementOperator assignableExpression
    ;
prefixOperator
    :    minusOperator
    |    negationOperator
    |    tildeOperator
    ;
minusOperator
    :    MINUS
    ;
negationOperator
    :    NOT
    ;
tildeOperator
    :    TILDE
    ;
awaitExpression
    :    AWAIT unaryExpression
    ;
postfixExpression
    :    assignableExpression postfixOperator
    |    primary selector*
    ;
postfixOperator
    :    incrementOperator
    ;
selector
    :    NOT
    |    assignableSelector
    |    argumentPart
    |    typeArguments
    ;
argumentPart
    :    typeArguments? arguments
    ;
incrementOperator
    :    ADD_ADD
    |    MINUS_MINUS
    ;
assignableExpression
    :    SUPER unconditionalAssignableSelector
    |    primary assignableSelectorPart
    |    identifier
    ;
assignableSelectorPart
    :    selector* assignableSelector
    ;
unconditionalAssignableSelector
    :    SQUARE_BRACJETS_OPEN expression SQUARE_BRACJETS_CLOSE
    |    DOT identifier
    ;
assignableSelector
    :    unconditionalAssignableSelector
    |    QUESTION_MARK_DOT identifier
    |    QUESTION_MARK SQUARE_BRACJETS_OPEN expression SQUARE_BRACJETS_CLOSE
    ;
identifierNotFUNCTION
    :    IDENTIFIER
    |    builtInIdentifier
    |    ASYNC // Not a built-in identifier.
    |    HIDE // Not a built-in identifier.
    |    OF // Not a built-in identifier.
    |    ON // Not a built-in identifier.
    |    SHOW // Not a built-in identifier.
    |    SYNC // Not a built-in identifier.
    |    { asyncEtcPredicate(getCurrentToken().getType()) }? (AWAIT|YIELD)
    ;
identifier
    :    identifierNotFUNCTION
    |    FUNCTION // Built-in identifier that can be used as a type.
    ;
qualifiedName
    :    typeIdentifier DOT (identifier | NEW)
    |    typeIdentifier DOT typeIdentifier DOT (identifier | NEW)
    ;
typeIdentifier
    :    IDENTIFIER
    |    DYNAMIC // Built-in identifier that can be used as a type.
    |    ASYNC // Not a built-in identifier.
    |    HIDE // Not a built-in identifier.
    |    OF // Not a built-in identifier.
    |    ON // Not a built-in identifier.
    |    SHOW // Not a built-in identifier.
    |    SYNC // Not a built-in identifier.
    |    { asyncEtcPredicate(getCurrentToken().getType()) }? (AWAIT|YIELD)
    ;
typeTest
    :    isOperator typeNotVoid
    ;
isOperator
    :    IS NOT?
    ;
typeCast
    :    asOperator typeNotVoid
    ;
asOperator
    :    AS
    ;
pattern
    :    logicalOrPattern
    ;
patterns
    :    pattern (COMMA pattern)* COMMA?
    ;
logicalOrPattern
    :    logicalAndPattern (BAR_BAR logicalAndPattern)*
    ;
logicalAndPattern
    :    relationalPattern (AND_AND relationalPattern)*
    ;
relationalPattern
    :    (equalityOperator | relationalOperator) bitwiseOrExpression
    |    unaryPattern
    ;
unaryPattern
    :    castPattern
    |    nullCheckPattern
    |    nullAssertPattern
    |    primaryPattern
    ;
primaryPattern
    :    constantPattern
    |    variablePattern
    |    parenthesizedPattern
    |    listPattern
    |    mapPattern
    |    recordPattern
    |    objectPattern
    ;
castPattern
    :    primaryPattern AS type
    ;
nullCheckPattern
    :    primaryPattern QUESTION_MARK
    ;
nullAssertPattern
    :    primaryPattern NOT
    ;
constantPattern
    :    booleanLiteral
    |    nullLiteral
    |    MINUS? numericLiteral
    |    stringLiteral
    |    symbolLiteral
    |    identifier
    |    qualifiedName
    |    constObjectExpression
    |    CONST typeArguments? SQUARE_BRACJETS_OPEN elements? SQUARE_BRACJETS_CLOSE
    |    CONST typeArguments? LBRACE elements? RBRACE
    |    CONST PARENTHESES_OPEN expression PARENTHESES_CLOSE
    ;
variablePattern
    :    (VAR | FINAL | FINAL? type)? identifier
    ;
parenthesizedPattern
    :    PARENTHESES_OPEN pattern PARENTHESES_CLOSE
    ;
listPattern
    :    typeArguments? SQUARE_BRACJETS_OPEN listPatternElements? SQUARE_BRACJETS_CLOSE
    ;
listPatternElements
    :    listPatternElement (COMMA listPatternElement)* COMMA?
    ;
listPatternElement
    :    pattern
    |    restPattern
    ;
restPattern
    :    ELLIPSIS pattern?
    ;
mapPattern
    :    typeArguments? LBRACE mapPatternEntries? RBRACE
    ;
mapPatternEntries
    :    mapPatternEntry (COMMA mapPatternEntry)* COMMA?
    ;
mapPatternEntry
    :    expression COLON pattern
    |    ELLIPSIS
    ;
recordPattern
    :    PARENTHESES_OPEN patternFields? PARENTHESES_CLOSE
    ;
patternFields
    :    patternField ( COMMA patternField )* COMMA?
    ;
patternField
    :    (identifier? COLON)? pattern
    ;
objectPattern
    :    typeName typeArguments? PARENTHESES_OPEN patternFields? PARENTHESES_CLOSE
    ;
patternVariableDeclaration
    :    (FINAL | VAR) outerPattern EQUAL expression
    ;
outerPattern
    :    parenthesizedPattern
    |    listPattern
    |    mapPattern
    |    recordPattern
    |    objectPattern
    ;
patternAssignment
    : outerPattern EQUAL expression
    ;
statements
    :    statement*
    ;
statement
    :    label* nonLabelledStatement
    ;
// Exception in the language specification: An expressionStatement cannot
// start with LBRACE. We force anything that starts with LBRACE to be a block,
// which will prevent an expressionStatement from starting with LBRACE, and
// which will not interfere with the recognition of any other case. If we
// add another statement which can start with LBRACE we must adjust this
// check.
nonLabelledStatement
    :    block
    |    localVariableDeclaration
    |    forStatement
    |    whileStatement
    |    doStatement
    |    switchStatement
    |    ifStatement
    |    rethrowStatement
    |    tryStatement
    |    breakStatement
    |    continueStatement
    |    returnStatement
    |    localFunctionDeclaration
    |    assertStatement
    |    yieldStatement
    |    yieldEachStatement
    |    expressionStatement
    ;
expressionStatement
    :    expression? SEMICOLON
    ;
localVariableDeclaration
    :    metadata initializedVariableDeclaration SEMICOLON
    |    metadata patternVariableDeclaration SEMICOLON
    ;
initializedVariableDeclaration
    :    declaredIdentifier (EQUAL expression)? (COMMA initializedIdentifier)*
    ;
localFunctionDeclaration
    :    metadata functionSignature functionBody
    ;
ifStatement
    :    ifCondition statement (ELSE statement)?
    ;
ifCondition
    :    IF PARENTHESES_OPEN expression (CASE guardedPattern)? PARENTHESES_CLOSE
    ;
forStatement
    :    AWAIT? FOR PARENTHESES_OPEN forLoopParts PARENTHESES_CLOSE statement
    ;
// TODO: Include `metadata` in the pattern form?
forLoopParts
    :    metadata declaredIdentifier IN expression
    |    metadata identifier IN expression
    |    forInitializerStatement expression? SEMICOLON expressionList?
    |    metadata (FINAL | VAR) outerPattern IN expression
    ;
// The localVariableDeclaration cannot be CONST, but that can
// be enforced in a later phase, and the grammar allows it.
forInitializerStatement
    :    localVariableDeclaration
    |    expression? SEMICOLON
    ;
whileStatement
    :    WHILE PARENTHESES_OPEN expression PARENTHESES_CLOSE statement
    ;
doStatement
    :    DO statement WHILE PARENTHESES_OPEN expression PARENTHESES_CLOSE SEMICOLON
    ;
switchStatement
    :    SWITCH PARENTHESES_OPEN expression PARENTHESES_CLOSE
         LBRACE switchStatementCase* switchStatementDefault? RBRACE
    ;
switchStatementCase
    :    label* CASE guardedPattern COLON statements
    ;
guardedPattern
    :    pattern (WHEN expression)?
    ;
switchStatementDefault
    :    label* DEFAULT COLON statements
    ;
rethrowStatement
    :    RETHROW SEMICOLON
    ;
tryStatement
    :    TRY block (onParts finallyPart? | finallyPart)
    ;
onPart
    :    catchPart block
    |    ON typeNotVoid catchPart? block
    ;
onParts
    :    onPart onParts
    |    onPart
    ;
catchPart
    :    CATCH PARENTHESES_OPEN identifier (COMMA identifier)? PARENTHESES_CLOSE
    ;
finallyPart
    :    FINALLY block
    ;
returnStatement
    :    RETURN expression? SEMICOLON
    ;
label
    :    identifier COLON
    ;
breakStatement
    :    BREAK identifier? SEMICOLON
    ;
continueStatement
    :    CONTINUE identifier? SEMICOLON
    ;
yieldStatement
    :    YIELD expression SEMICOLON
    ;
yieldEachStatement
    :    YIELD STAR expression SEMICOLON
    ;
assertStatement
    :    assertion SEMICOLON
    ;
assertion
    :    ASSERT PARENTHESES_OPEN expression (COMMA expression)? COMMA? PARENTHESES_CLOSE
    ;
libraryName
    :    metadata LIBRARY dottedIdentifierList SEMICOLON
    ;
dottedIdentifierList
    :    identifier (DOT identifier)*
    ;
importOrExport
    :    libraryImport
    |    libraryExport
    ;
libraryImport
    :    metadata importSpecification
    ;
importSpecification
    :    IMPORT configurableUri (DEFERRED? AS identifier)? combinator* SEMICOLON
    ;
combinator
    :    SHOW identifierList
    |    HIDE identifierList
    ;
identifierList
    :    identifier (COMMA identifier)*
    ;
libraryExport
    :    metadata EXPORT uri combinator* SEMICOLON
    ;
partDirective
    :    metadata PART uri SEMICOLON
    ;
partHeader
    :    metadata PART OF (dottedIdentifierList | uri)SEMICOLON
    ;
partDeclaration
    :    partHeader (metadata topLevelDefinition)* EOF
    ;
// In the specification a plain <stringLiteral> is used.
// TODO(eernst): Check whether it creates ambiguities to do that.
uri
    :    stringLiteralWithoutInterpolation
    ;
configurableUri
    :    uri configurationUri*
    ;
configurationUri
    :    IF PARENTHESES_OPEN uriTest PARENTHESES_CLOSE uri
    ;
uriTest
    :    dottedIdentifierList (EQUAL_EQUAL stringLiteral)?
    ;
type
    :    functionType QUESTION_MARK?
    |    typeNotFunction
    ;
typeNotVoid
    :    functionType QUESTION_MARK?
    |    recordType QUESTION_MARK?
    |    typeNotVoidNotFunction
    ;
typeNotFunction
    :    typeNotVoidNotFunction
    |    recordType QUESTION_MARK?
    |    VOID
    ;
typeNotVoidNotFunction
    :    typeName typeArguments? QUESTION_MARK?
    |    FUNCTION QUESTION_MARK?
    ;
typeName
    :    typeIdentifier (DOT typeIdentifier)?
    ;
typeArguments
    :    LESS_THAN typeList GREATER_THAN
    ;
typeList
    :    type (COMMA type)*
    ;
recordType
    :    PARENTHESES_OPEN PARENTHESES_CLOSE
    |    PARENTHESES_OPEN recordTypeFields COMMA recordTypeNamedFields PARENTHESES_CLOSE
    |    PARENTHESES_OPEN recordTypeFields COMMA? PARENTHESES_CLOSE
    |    PARENTHESES_OPEN recordTypeNamedFields PARENTHESES_CLOSE
    ;
recordTypeFields
    :    recordTypeField (COMMA recordTypeField)*
    ;
recordTypeField
    :    metadata type identifier?
    ;
recordTypeNamedFields
    :    LBRACE recordTypeNamedField (COMMA recordTypeNamedField)* COMMA? RBRACE
    ;
recordTypeNamedField
    :    metadata typedIdentifier
    ;
typeNotVoidNotFunctionList
    :    typeNotVoidNotFunction (COMMA typeNotVoidNotFunction)*
    ;
typeAlias
    :    TYPEDEF typeIdentifier typeParameters? EQUAL type SEMICOLON
    |    TYPEDEF functionTypeAlias
    ;
functionTypeAlias
    :    functionPrefix formalParameterPart SEMICOLON
    ;
functionPrefix
    :    type identifier
    |    identifier
    ;
functionTypeTail
    :    FUNCTION typeParameters? parameterTypeList
    ;
functionTypeTails
    :    functionTypeTail QUESTION_MARK? functionTypeTails
    |    functionTypeTail
    ;
functionType
    :    functionTypeTails
    |    typeNotFunction functionTypeTails
    ;
parameterTypeList
    :    PARENTHESES_OPEN PARENTHESES_CLOSE
    |    PARENTHESES_OPEN normalParameterTypes COMMA optionalParameterTypes PARENTHESES_CLOSE
    |    PARENTHESES_OPEN normalParameterTypes COMMA? PARENTHESES_CLOSE
    |    PARENTHESES_OPEN optionalParameterTypes PARENTHESES_CLOSE
    ;
normalParameterTypes
    :    normalParameterType (COMMA normalParameterType)*
    ;
normalParameterType
    :    metadata typedIdentifier
    |    metadata type
    ;
optionalParameterTypes
    :    optionalPositionalParameterTypes
    |    namedParameterTypes
    ;
optionalPositionalParameterTypes
    :    SQUARE_BRACJETS_OPEN normalParameterTypes COMMA? SQUARE_BRACJETS_CLOSE
    ;
namedParameterTypes
    :    LBRACE namedParameterType (COMMA namedParameterType)* COMMA? RBRACE
    ;
namedParameterType
    :    metadata REQUIRED? typedIdentifier
    ;
typedIdentifier
    :    type identifier
    ;
constructorDesignation
    :    typeIdentifier
    |    qualifiedName
    |    typeName typeArguments (DOT (identifier | NEW))?
    ;
symbolLiteral
    :    HASH (operator | (identifier (DOT identifier)*) | VOID)
    ;
// Not used in the specification (needed here for <uri>).
singleStringWithoutInterpolation
    :    RAW_SINGLE_LINE_STRING
    |    RAW_MULTI_LINE_STRING
    |    SINGLE_LINE_STRING_DQ_BEGIN_END
    |    SINGLE_LINE_STRING_SQ_BEGIN_END
    |    MULTI_LINE_STRING_DQ_BEGIN_END
    |    MULTI_LINE_STRING_SQ_BEGIN_END
    ;
singleLineString
    :    RAW_SINGLE_LINE_STRING
    |    SINGLE_LINE_STRING_SQ_BEGIN_END
    |    SINGLE_LINE_STRING_SQ_BEGIN_MID expression
         (SINGLE_LINE_STRING_SQ_MID_MID expression)*
         SINGLE_LINE_STRING_SQ_MID_END
    |    SINGLE_LINE_STRING_DQ_BEGIN_END
    |    SINGLE_LINE_STRING_DQ_BEGIN_MID expression
         (SINGLE_LINE_STRING_DQ_MID_MID expression)*
         SINGLE_LINE_STRING_DQ_MID_END
    ;
multiLineString
    :    RAW_MULTI_LINE_STRING
    |    MULTI_LINE_STRING_SQ_BEGIN_END
    |    MULTI_LINE_STRING_SQ_BEGIN_MID expression
         (MULTI_LINE_STRING_SQ_MID_MID expression)*
         MULTI_LINE_STRING_SQ_MID_END
    |    MULTI_LINE_STRING_DQ_BEGIN_END
    |    MULTI_LINE_STRING_DQ_BEGIN_MID expression
         (MULTI_LINE_STRING_DQ_MID_MID expression)*
         MULTI_LINE_STRING_DQ_MID_END
    ;
reservedWord
    :    ASSERT
    |    BREAK
    |    CASE
    |    CATCH
    |    CLASS
    |    CONST
    |    CONTINUE
    |    DEFAULT
    |    DO
    |    ELSE
    |    ENUM
    |    EXTENDS
    |    FALSE
    |    FINAL
    |    FINALLY
    |    FOR
    |    IF
    |    IN
    |    IS
    |    NEW
    |    NULL
    |    RETHROW
    |    RETURN
    |    SUPER
    |    SWITCH
    |    THIS
    |    THROW
    |    TRUE
    |    TRY
    |    VAR
    |    VOID
    |    WHILE
    |    WITH
    ;
builtInIdentifier
    :    ABSTRACT
    |    AS
    |    COVARIANT
    |    DEFERRED
    |    DYNAMIC
    |    EXPORT
    |    EXTENSION
    |    EXTERNAL
    |    FACTORY
    |    FUNCTION
    |    GET
    |    IMPLEMENTS
    |    IMPORT
    |    INTERFACE
    |    LATE
    |    LIBRARY
    |    OPERATOR
    |    MIXIN
    |    PART
    |    REQUIRED
    |    SET
    |    STATIC
    |    TYPEDEF
    ;
