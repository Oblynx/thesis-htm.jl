using Weave
using Lazy

dir= "design_walkthrough"
jmd_files= @>> readdir(dir) map(f->joinpath(dir,f)) map(abspath) filter(s->match(r".*jmd",s)|>!isnothing)

weave.(jmd_files,
       out_path= joinpath(dir,"build/"),
       doctype = "md2tex")
