# CMPUtils.jl

CMPUtils stands for Computational Modeling Project Utilities. This is a package developed to support the class projects for Cognitive & Neural Modeling Laboratory. 
Currently the package provides routines to recode image, audio, and text files.

To install this package, go to you package manager and: 
```julia 
add https://github.com/coinslab/CMPUtils.jl
```
### Usage

```julia
using CMPUtils
recodeimage(path_to_folder)
recodeaudio(path_to_folder,num_cep_coeffs)
recodetext(path_to_folder)
```
