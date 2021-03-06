module CMPUtils
    
    using Images
    using ImageIO
    using ImageMagick 
    using LinearAlgebra
    using Pipe: @pipe
    using ProgressMeter: @showprogress
    using CSV
    using DataFrames: DataFrame
    using StatsBase
    using WAV
    using MFCC: mfcc 
    using Glob
    using TextAnalysis
    using Taro
    using Languages 
    using StatsBase
    using Plots 
    include("recode.jl")

    export recodeimage, recodeaudio, recodetext
    precompile(recodeimage, (String,Int),)
    precompile(recodeaudio, (String,Int),)
    precompile(recodetext, (String,Int),)
end
