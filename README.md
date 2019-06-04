# thesis-htm.jl

This repo contains the HTM.jl thesis report in LaTeX.
The main .tex document that builds the thesis is `kosamara-thesis-main.tex`.
It includes the preamble and each chapter separately.
Most chapters are individual .tex files in the [chapters](chapters/) dir.

The part of the thesis describing the HTM implementation's design is written in Julia Markdown (.jmd),
which is like a Jupyter notebook, merging text with code.
The .jmd are then built with Weave.jl producing .tex outputs [here](design_walkthrough/build/).
These outputs need a little extra postprocessing to be mergeable with the main thesis:
- splitting preamble and body
- removing latex packages that conflict with the main text's and are unnecessary
- stripping a special syntax (`$@ ... @$`) I use to pass latex commands from the .jmd directly through the tex-ification process without modifications by hacking .jmd's math mode
This process is written in [build_walkthrough.jl](design_walkthrough/build_walkthrough.jl).

## Building the thesis

1. Build the design walkthroughs: `$ design_walkthrough/build_walkthrough`
1. Build the [main .tex](kosamara-thesis-main.tex) with **LuaLaTeX**
