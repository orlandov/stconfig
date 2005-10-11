runtime! syntax/perl.vim

" __END__ and __DATA__ clauses
if exists("perl_fold")
  syntax region perlDATA		start="^__\(DATA\|END\)__$" skip="." end="." contains=TestLiveBlock fold
else
  syntax region perlDATA		start="^__\(DATA\|END\)__$" skip="." end="." contains=TestLiveBlock
endif

syntax region TestLiveBlock start="^===" end="^===" contains=TestLiveMatchSection,TestLiveNameSection,TestLiveDataSection contained

syntax region TestLiveNameSection start="^===" end="^\ze\(--- \|$\)" contains=TestLiveNameOperator contained

syntax match TestLiveNameOperator /^=== \+/ nextgroup=TestLiveName contained
syntax match TestLiveNameOperator /^===$/ contained
syntax match TestLiveName /.*$/ contained

syntax region TestLiveMatchSection start="^--- match\>" end="^\ze\(--- \|$\)" contains=TestLiveDataSpec,perlSpecialMatch contained

syntax region TestLiveDataSection start="^--- \(match\>\)\@!" end="^\ze\(--- \|$\)" contains=TestLiveDataSpec contained
syntax region TestLiveDataSpec start="^--- " end="$" contains=TestLiveDataOperator,TestLiveDataFilter contained
syntax match TestLiveDataOperator /^--- \+/ nextgroup=TestLiveDataName contained
syntax match TestLiveDataName /[^ :]\+\ze:\>/ contained nextgroup=TestLiveData
syntax match TestLiveDataName /[^ :]\+\>/ contained
syntax match TestLiveData /.*$/ contained
syntax match TestLiveDataFilter / \zs[^ ]\+/ contained

if version >= 508 || !exists("did_perl_syn_inits")
  if version < 508
    let did_perl_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink TestLiveNameOperator   perlOperator
  HiLink TestLiveName           perlPackageDecl
  HiLink TestLiveDataOperator   perlOperator
  HiLink TestLiveDataName       ModeMsg
  HiLink TestLiveDataFilter     perlIdentifier
  HiLink TestLiveMatchSection   perlQQ

  delcommand HiLink
endif
