
grammar Dart_Parser;

// ---------------------------------------- Grammar rules.
libraryDefinition
    :    SCRIPT_TAG?
         libraryName?
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
    |    EXTERNAL functionSignature ';'
    |    EXTERNAL getterSignature ';'
    |    EXTERNAL setterSignature ';'
    |    EXTERNAL finalVarOrType identifierList ';'
    |    getterSignature functionBody
    |    setterSignature functionBody
    |    functionSignature functionBody
    |    (FINAL | CONST) type? staticFinalDeclarationList ';'
    |    LATE FINAL type? initializedIdentifierList ';'
    |    LATE? varOrType identifier ('=' expression)?
         (',' initializedIdentifier)* ';'
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
    :    identifier ('=' expression)?
    ;
initializedIdentifierList
    :    initializedIdentifier (',' initializedIdentifier)*
    ;
functionSignature
    :    type? identifierNotFUNCTION formalParameterPart
    ;
functionBodyPrefix
    :    ASYNC? '=>'
    |    (ASYNC | ASYNC '*' | SYNC '*')? LBRACE
    ;
functionBody
    :    '=>' { startNonAsyncFunction(); } expression { endFunction(); } ';'
    |    { startNonAsyncFunction(); } block { endFunction(); }
    |    ASYNC '=>'
         { startAsyncFunction(); } expression { endFunction(); } ';'
    |    (ASYNC | ASYNC '*' | SYNC '*')
         { startAsyncFunction(); } block { endFunction(); }
    ;
block
    :    LBRACE statements RBRACE
    ;
formalParameterPart
    :    typeParameters? formalParameterList
    ;
formalParameterList
    :    '(' ')'
    |    '(' normalFormalParameters ','? ')'
    |    '(' normalFormalParameters ',' optionalOrNamedFormalParameters ')'
    |    '(' optionalOrNamedFormalParameters ')'
    ;
normalFormalParameters
    :    normalFormalParameter (',' normalFormalParameter)*
    ;
optionalOrNamedFormalParameters
    :    optionalPositionalFormalParameters
    |    namedFormalParameters
    ;
optionalPositionalFormalParameters
    :    '[' defaultFormalParameter (',' defaultFormalParameter)* ','? ']'
    ;
namedFormalParameters
    :    LBRACE defaultNamedParameter (',' defaultNamedParameter)* ','? RBRACE
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
    :    COVARIANT? type? identifierNotFUNCTION formalParameterPart '?'?
    ;
simpleFormalParameter
    :    declaredIdentifier
    |    COVARIANT? identifier
    ;
// NB: It is an anomaly that VAR can be a return type (`var this.x()`).
fieldFormalParameter
    :    finalConstVarOrType? THIS '.' identifier (formalParameterPart '?'?)?
    ;
superFormalParameter
    :    type? SUPER '.' identifier (formalParameterPart '?'?)?
    ;
defaultFormalParameter
    :    normalFormalParameter ('=' expression)?
    ;
defaultNamedParameter
    :    REQUIRED? normalFormalParameter ((':' | '=') expression)?
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
    |    declaration ';'
    ;
mixinApplicationClass
    :    typeWithParameters '=' mixinApplication ';'
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
    :    staticFinalDeclaration (',' staticFinalDeclaration)*
    ;
staticFinalDeclaration
    :    identifier '=' expression
    ;
operatorSignature
    :    type? OPERATOR operator formalParameterList
    ;
operator
    :    '~'
    |    binaryOperator
    |    '[' ']'
    |    '[' ']' '='
    ;
binaryOperator
    :    multiplicativeOperator
    |    additiveOperator
    |    shiftOperator
    |    relationalOperator
    |    '=='
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
    :    typeIdentifier ('.' (identifier | NEW))?
    ;
redirection
    :    ':' THIS ('.' (identifier | NEW))? arguments
    ;
initializers
    :    ':' initializerListEntry (',' initializerListEntry)*
    ;
initializerListEntry
    :    SUPER arguments
    |    SUPER '.' (identifier | NEW) arguments
    |    fieldInitializer
    |    assertion
    ;
fieldInitializer
    :    (THIS '.')? identifier '=' initializerExpression
    ;
initializerExpression
    :    conditionalExpression
    |    cascade
    ;
factoryConstructorSignature
    :    CONST? FACTORY constructorName formalParameterList
    ;
redirectingFactoryConstructorSignature
    :    CONST? FACTORY constructorName formalParameterList '='
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
         enumEntry (',' enumEntry)* (',')?
         (';' (metadata classMemberDefinition)*)?
         RBRACE
    ;
enumEntry
    :    metadata identifier argumentPart?
    |    metadata identifier typeArguments? '.' identifier arguments
    ;
typeParameter
    :    metadata typeIdentifier (EXTENDS typeNotVoid)?
    ;
typeParameters
    :    '<' typeParameter (',' typeParameter)* '>'
    ;
metadata
    :    ('@' metadatum)*
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
    :    expression (',' expression)*
    ;
primary
    :    thisExpression
    |    SUPER unconditionalAssignableSelector
    |    constObjectExpression
    |    newExpression
    |    constructorInvocation
    |    functionPrimary
    |    '(' expression ')'
    |    literal
    |    identifier
    |    constructorTearoff
    |    switchExpression
    ;
constructorInvocation
    :    typeName typeArguments '.' NEW arguments
    |    typeName '.' NEW arguments
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
    :    CONST? typeArguments? '[' elements? ']'
    ;
recordLiteral
    :    CONST? recordLiteralNoConst
    ;
recordLiteralNoConst
    :    '(' ')'
    |    '(' expression ',' ')'
    |    '(' label expression ','? ')'
    |    '(' recordField ',' recordField (',' recordField)* ','? ')'
    ;
recordField
    :    label? expression
    ;
elements
    : element (',' element)* ','?
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
    : expression ':' expression
    ;
spreadElement
    : ('...' | '...?') expression
    ;
ifElement
    : ifCondition element (ELSE element)?
    ;
forElement
    : AWAIT? FOR '(' forLoopParts ')' element
    ;
constructorTearoff
    :    typeName typeArguments? '.' NEW
    ;
switchExpression
    :    SWITCH '(' expression ')'
         LBRACE switchExpressionCase (',' switchExpressionCase)* ','? RBRACE
    ;
switchExpressionCase
    :    guardedPattern '=>' expression
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
    :    '=>' { startNonAsyncFunction(); } expression { endFunction(); }
    |    ASYNC '=>' { startAsyncFunction(); } expression { endFunction(); }
    ;
functionExpressionBodyPrefix
    :    ASYNC? '=>'
    ;
functionExpressionWithoutCascade
    :    formalParameterPart functionExpressionWithoutCascadeBody
    ;
functionExpressionWithoutCascadeBody
    :    '=>' { startNonAsyncFunction(); }
         expressionWithoutCascade { endFunction(); }
    |    ASYNC '=>' { startAsyncFunction(); }
         expressionWithoutCascade { endFunction(); }
    ;
functionPrimary
    :    formalParameterPart functionPrimaryBody
    ;
functionPrimaryBody
    :    { startNonAsyncFunction(); } block { endFunction(); }
    |    (ASYNC | ASYNC '*' | SYNC '*')
         { startAsyncFunction(); } block { endFunction(); }
    ;
functionPrimaryBodyPrefix
    : (ASYNC | ASYNC '*' | SYNC '*')? LBRACE
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
    :    '(' (argumentList ','?)? ')'
    ;
argumentList
    :    argument (',' argument)*
    ;
argument
    :    label? expression
    ;
cascade
    :     cascade '..' cascadeSection
    |     conditionalExpression ('?..' | '..') cascadeSection
    ;
cascadeSection
    :    cascadeSelector cascadeSectionTail
    ;
cascadeSelector
    :    '[' expression ']'
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
    :    '='
    |    compoundAssignmentOperator
    ;
compoundAssignmentOperator
    :    '*='
    |    '/='
    |    '~/='
    |    '%='
    |    '+='
    |    '-='
    |    '<<='
    |    '>' '>' '>' '='
    |    '>' '>' '='
    |    '&='
    |    '^='
    |    '|='
    |    '??='
    ;
conditionalExpression
    :    ifNullExpression
         ('?' expressionWithoutCascade ':' expressionWithoutCascade)?
    ;
ifNullExpression
    :    logicalOrExpression ('??' logicalOrExpression)*
    ;
logicalOrExpression
    :    logicalAndExpression ('||' logicalAndExpression)*
    ;
logicalAndExpression
    :    equalityExpression ('&&' equalityExpression)*
    ;
equalityExpression
    :    relationalExpression (equalityOperator relationalExpression)?
    |    SUPER equalityOperator relationalExpression
    ;
equalityOperator
    :    '=='
    |    '!='
    ;
relationalExpression
    :    bitwiseOrExpression
         (typeTest | typeCast | relationalOperator bitwiseOrExpression)?
    |    SUPER relationalOperator bitwiseOrExpression
    ;
relationalOperator
    :    '>' '='
    |    '>'
    |    '<='
    |    '<'
    ;
bitwiseOrExpression
    :    bitwiseXorExpression ('|' bitwiseXorExpression)*
    |    SUPER ('|' bitwiseXorExpression)+
    ;
bitwiseXorExpression
    :    bitwiseAndExpression ('^' bitwiseAndExpression)*
    |    SUPER ('^' bitwiseAndExpression)+
    ;
bitwiseAndExpression
    :    shiftExpression ('&' shiftExpression)*
    |    SUPER ('&' shiftExpression)+
    ;
bitwiseOperator
    :    '&'
    |    '^'
    |    '|'
    ;
shiftExpression
    :    additiveExpression (shiftOperator additiveExpression)*
    |    SUPER (shiftOperator additiveExpression)+
    ;
shiftOperator
    :    '<<'
    |    '>' '>' '>'
    |    '>' '>'
    ;
additiveExpression
    :    multiplicativeExpression (additiveOperator multiplicativeExpression)*
    |    SUPER (additiveOperator multiplicativeExpression)+
    ;
additiveOperator
    :    '+'
    |    '-'
    ;
multiplicativeExpression
    :    unaryExpression (multiplicativeOperator unaryExpression)*
    |    SUPER (multiplicativeOperator unaryExpression)+
    ;
multiplicativeOperator
    :    '*'
    |    '/'
    |    '%'
    |    '~/'
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
    :    '-'
    ;
negationOperator
    :    '!'
    ;
tildeOperator
    :    '~'
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
    :    '!'
    |    assignableSelector
    |    argumentPart
    |    typeArguments
    ;
argumentPart
    :    typeArguments? arguments
    ;
incrementOperator
    :    '++'
    |    '--'
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
    :    '[' expression ']'
    |    '.' identifier
    ;
assignableSelector
    :    unconditionalAssignableSelector
    |    '?.' identifier
    |    '?' '[' expression ']'
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
    :    typeIdentifier '.' (identifier | NEW)
    |    typeIdentifier '.' typeIdentifier '.' (identifier | NEW)
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
    :    IS '!'?
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
    :    pattern (',' pattern)* ','?
    ;
logicalOrPattern
    :    logicalAndPattern ('||' logicalAndPattern)*
    ;
logicalAndPattern
    :    relationalPattern ('&&' relationalPattern)*
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
    :    primaryPattern '?'
    ;
nullAssertPattern
    :    primaryPattern '!'
    ;
constantPattern
    :    booleanLiteral
    |    nullLiteral
    |    '-'? numericLiteral
    |    stringLiteral
    |    symbolLiteral
    |    identifier
    |    qualifiedName
    |    constObjectExpression
    |    CONST typeArguments? '[' elements? ']'
    |    CONST typeArguments? LBRACE elements? RBRACE
    |    CONST '(' expression ')'
    ;
variablePattern
    :    (VAR | FINAL | FINAL? type)? identifier
    ;
parenthesizedPattern
    :    '(' pattern ')'
    ;
listPattern
    :    typeArguments? '[' listPatternElements? ']'
    ;
listPatternElements
    :    listPatternElement (',' listPatternElement)* ','?
    ;
listPatternElement
    :    pattern
    |    restPattern
    ;
restPattern
    :    '...' pattern?
    ;
mapPattern
    :    typeArguments? LBRACE mapPatternEntries? RBRACE
    ;
mapPatternEntries
    :    mapPatternEntry (',' mapPatternEntry)* ','?
    ;
mapPatternEntry
    :    expression ':' pattern
    |    '...'
    ;
recordPattern
    :    '(' patternFields? ')'
    ;
patternFields
    :    patternField ( ',' patternField )* ','?
    ;
patternField
    :    (identifier? ':')? pattern
    ;
objectPattern
    :    typeName typeArguments? '(' patternFields? ')'
    ;
patternVariableDeclaration
    :    (FINAL | VAR) outerPattern '=' expression
    ;
outerPattern
    :    parenthesizedPattern
    |    listPattern
    |    mapPattern
    |    recordPattern
    |    objectPattern
    ;
patternAssignment
    : outerPattern '=' expression
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
    :    expression? ';'
    ;
localVariableDeclaration
    :    metadata initializedVariableDeclaration ';'
    |    metadata patternVariableDeclaration ';'
    ;
initializedVariableDeclaration
    :    declaredIdentifier ('=' expression)? (',' initializedIdentifier)*
    ;
localFunctionDeclaration
    :    metadata functionSignature functionBody
    ;
ifStatement
    :    ifCondition statement (ELSE statement)?
    ;
ifCondition
    :    IF '(' expression (CASE guardedPattern)? ')'
    ;
forStatement
    :    AWAIT? FOR '(' forLoopParts ')' statement
    ;
// TODO: Include `metadata` in the pattern form?
forLoopParts
    :    metadata declaredIdentifier IN expression
    |    metadata identifier IN expression
    |    forInitializerStatement expression? ';' expressionList?
    |    metadata (FINAL | VAR) outerPattern IN expression
    ;
// The localVariableDeclaration cannot be CONST, but that can
// be enforced in a later phase, and the grammar allows it.
forInitializerStatement
    :    localVariableDeclaration
    |    expression? ';'
    ;
whileStatement
    :    WHILE '(' expression ')' statement
    ;
doStatement
    :    DO statement WHILE '(' expression ')' ';'
    ;
switchStatement
    :    SWITCH '(' expression ')'
         LBRACE switchStatementCase* switchStatementDefault? RBRACE
    ;
switchStatementCase
    :    label* CASE guardedPattern ':' statements
    ;
guardedPattern
    :    pattern (WHEN expression)?
    ;
switchStatementDefault
    :    label* DEFAULT ':' statements
    ;
rethrowStatement
    :    RETHROW ';'
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
    :    CATCH '(' identifier (',' identifier)? ')'
    ;
finallyPart
    :    FINALLY block
    ;
returnStatement
    :    RETURN expression? ';'
    ;
label
    :    identifier ':'
    ;
breakStatement
    :    BREAK identifier? ';'
    ;
continueStatement
    :    CONTINUE identifier? ';'
    ;
yieldStatement
    :    YIELD expression ';'
    ;
yieldEachStatement
    :    YIELD '*' expression ';'
    ;
assertStatement
    :    assertion ';'
    ;
assertion
    :    ASSERT '(' expression (',' expression)? ','? ')'
    ;
libraryName
    :    metadata LIBRARY dottedIdentifierList ';'
    ;
dottedIdentifierList
    :    identifier ('.' identifier)*
    ;
importOrExport
    :    libraryImport
    |    libraryExport
    ;
libraryImport
    :    metadata importSpecification
    ;
importSpecification
    :    IMPORT configurableUri (DEFERRED? AS identifier)? combinator* ';'
    ;
combinator
    :    SHOW identifierList
    |    HIDE identifierList
    ;
identifierList
    :    identifier (',' identifier)*
    ;
libraryExport
    :    metadata EXPORT uri combinator* ';'
    ;
partDirective
    :    metadata PART uri ';'
    ;
partHeader
    :    metadata PART OF (dottedIdentifierList | uri)';'
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
    :    IF '(' uriTest ')' uri
    ;
uriTest
    :    dottedIdentifierList ('==' stringLiteral)?
    ;
type
    :    functionType '?'?
    |    typeNotFunction
    ;
typeNotVoid
    :    functionType '?'?
    |    recordType '?'?
    |    typeNotVoidNotFunction
    ;
typeNotFunction
    :    typeNotVoidNotFunction
    |    recordType '?'?
    |    VOID
    ;
typeNotVoidNotFunction
    :    typeName typeArguments? '?'?
    |    FUNCTION '?'?
    ;
typeName
    :    typeIdentifier ('.' typeIdentifier)?
    ;
typeArguments
    :    '<' typeList '>'
    ;
typeList
    :    type (',' type)*
    ;
recordType
    :    '(' ')'
    |    '(' recordTypeFields ',' recordTypeNamedFields ')'
    |    '(' recordTypeFields ','? ')'
    |    '(' recordTypeNamedFields ')'
    ;
recordTypeFields
    :    recordTypeField (',' recordTypeField)*
    ;
recordTypeField
    :    metadata type identifier?
    ;
recordTypeNamedFields
    :    LBRACE recordTypeNamedField (',' recordTypeNamedField)* ','? RBRACE
    ;
recordTypeNamedField
    :    metadata typedIdentifier
    ;
typeNotVoidNotFunctionList
    :    typeNotVoidNotFunction (',' typeNotVoidNotFunction)*
    ;
typeAlias
    :    TYPEDEF typeIdentifier typeParameters? '=' type ';'
    |    TYPEDEF functionTypeAlias
    ;
functionTypeAlias
    :    functionPrefix formalParameterPart ';'
    ;
functionPrefix
    :    type identifier
    |    identifier
    ;
functionTypeTail
    :    FUNCTION typeParameters? parameterTypeList
    ;
functionTypeTails
    :    functionTypeTail '?'? functionTypeTails
    |    functionTypeTail
    ;
functionType
    :    functionTypeTails
    |    typeNotFunction functionTypeTails
    ;
parameterTypeList
    :    '(' ')'
    |    '(' normalParameterTypes ',' optionalParameterTypes ')'
    |    '(' normalParameterTypes ','? ')'
    |    '(' optionalParameterTypes ')'
    ;
normalParameterTypes
    :    normalParameterType (',' normalParameterType)*
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
    :    '[' normalParameterTypes ','? ']'
    ;
namedParameterTypes
    :    LBRACE namedParameterType (',' namedParameterType)* ','? RBRACE
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
    |    typeName typeArguments ('.' (identifier | NEW))?
    ;
symbolLiteral
    :    '#' (operator | (identifier ('.' identifier)*) | VOID)
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
// ---------------------------------------- Lexer rules.
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

SCRIPT_TAG
    :    '#!' (~('\r' | '\n'))* NEWLINE
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