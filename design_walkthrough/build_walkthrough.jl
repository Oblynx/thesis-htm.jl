using Weave
using Lazy

# This has to happen at the local package
#function uc2tex(s::String, escape=false)
#    for key in keys(latex_symbols)
#        if escape
#            s = replace(s, latex_symbols[key] => "(*@\\ensuremath{$(texify(key))}@*)")
#        else
#            #s = replace(s, latex_symbols[key] => "\\ensuremath{$(texify(key))}")
#        end
#    end
#    return s
#end

dir= "design_walkthrough"
out_dir= joinpath(dir,"build/")
jmd_files= @>> readdir(dir) map(f->joinpath(dir,f)) map(abspath) filter(s->match(r".*jmd",s)|>!isnothing)

weave.(jmd_files, out_path= out_dir, doctype= "md2tex")

out_files= @>> jmd_files map(basename) map(f->splitext(f)[1]) map(s->s*".tex") map(f->joinpath(out_dir,f)) map(abspath)

for file in out_files
  println(file)
  cd(()->`csplit --suppress-matched --elide-empty-files "$file" '/begin.document./' '/end.document./'`|> run,
     out_dir)
  filename= file|> basename|> splitext; filename= filename[1];
  filename_preamble= filename*"_preamble.tex"
  filename_body= filename*"_body.tex"
  `mv "$out_dir/xx00" "$out_dir/$filename_preamble"`|> run
  `mv "$out_dir/xx01" "$out_dir/$filename_body"`|> run
  `sed -i -E '/usepackage.*(geometry|lmodern|fontenc)/d' "$out_dir/$filename_preamble"`|> run
  `sed -i -E 's/(basicstyle.*)\\footnotesize/\1/' "$out_dir/$filename_preamble"`|> run
  `sed -i -E '/\\documentclass/d' "$out_dir/$filename_preamble"`|> run
  `perl -pi -e 's|\$@(.+?)@\$|\1|g' "$out_dir/$filename_body"`|> run 
end
