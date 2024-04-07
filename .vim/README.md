Add to polyglot

doc.vim
 syntax keyword typescriptDocTags               contained borrows exports nextgroup=typescriptDocA skipwhite
 syntax keyword typescriptDocTags               contained param arg argument property prop module nextgroup=typescriptDocNamedParamType,typescriptDocParamName skipwhite

+syntax match typescriptDocParamType contained /\v\{\w+\}/ nextgroup=typescriptDocParamName skipwhite " Temp
+syntax match typescriptDocParamName contained /\v\w+/ nextgroup=typescriptDocParamDesc skipwhite " Solution

 syntax keyword typescriptDocTags               contained define enum extends implements this typedef nextgroup=typescriptDocParamType skipwhite
 syntax keyword typescriptDocTags               contained return returns throws exception nextgroup=typescriptDocParamType,typescriptDocParamName skipwhite
 syntax keyword typescriptDocTags               contained see nextgroup=typescriptDocRef skipwhite
                                                                                                                  
function.vim
+syn match tsxFuncName /\b\([a-zA-Z_]\w*\)\s*(/ contained

identifiers.vim
syntax region  typescriptIndexExpr      contained matchgroup=typescriptProperty start=/\[/ end=/]/ contains=@typescriptValue,typescriptCastKeyword nextgroup=@typescriptSymbols,typescriptDotNotation,typescriptFuncCallArg skipwhite skipempty

-syntax match   typescriptDotNotation           /\.\|?\.\|!\./ nextgroup=typescriptProp skipnl
+syntax match typescriptFuncCall /\k*\ze(/ nextgroup=typescriptFuncCallArg skipwhite skipempty
+
+"syntax cluster typescriptFunctions contains=typescriptFuncCall
+"syntax match   typescriptFuncCall              /\(\.\|?\.\|!\.\)\@<!\k\+\ze(/ contained nextgroup=typescriptFuncCallArg
+syntax match   typescriptDotNotation           /\.\|?\.\|!\./ nextgroup=typescriptProp,typescriptFuncCall skipnl " Temp Solution
 syntax match   typescriptDotStyleNotation      /\.style\./ nextgroup=typescriptDOMStyle transparent
-" syntax match   typescriptFuncCall              contained /[a-zA-Z]\k*\ze(/ nextgroup=typescriptFuncCallArg
+syntax match   typescriptFuncCall              contained /[a-zA-Z]\k*ze(/ nextgroup=typescriptFuncCallArg
 syntax region  typescriptParenExp              matchgroup=typescriptParens start=/(/ end=/)/ contains=@typescriptComments,@typescriptValue,typescriptCastKeyword nextgroup=@typescriptSymbols skipwhite skipempty
 syntax region  typescriptFuncCallArg           contained matchgroup=typescriptParens start=/(/ end=/)/ contains=@typescriptValue,@typescriptComments,typescriptCastKeyword nextgroup=@typescriptSymbols,typescriptDotNotation skipwhite skipempty skipnl
 syntax region  typescriptEventFuncCallArg      contained matchgroup=typescriptParens start=/(/ end=/)/ contains=@typescriptEventExpression


