perl -E 'sub how { unless(defined wantarray){say "void";return}; say wantarray ? "arrayish" : "scalarish" }; @a=how()'

