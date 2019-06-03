using Weave
using Lazy

dir= "design_walkthrough"
out_dir= joinpath(dir,"build/")
jmd_files= @>> readdir(dir) map(f->joinpath(dir,f)) map(abspath) filter(s->match(r".*jmd",s)|>!isnothing)

#weave.(jmd_files, out_path= out_dir, doctype= "md2tex")

out_files= @>> readdir(out_dir) map(f->joinpath(out_dir,f)) map(abspath) filter(s->match(r".*tex",s)|>!isnothing)


for file in out_files
  cd(()->`csplit --suppress-matched --elide-empty-files "$file" '/documentclass/' '/begin.document./' '/end.document./'`|> run,
     out_dir)
  filename= file|> basename|> splitext; filename= filename[1];
  filename_preamble= filename*"_preamble.tex"
  filename_body= filename*"_body.tex"
  `mv "$out_dir/xx00" "$out_dir/$filename_preamble"`|> run
  `mv "$out_dir/xx01" "$out_dir/$filename_body"`|> run
end

