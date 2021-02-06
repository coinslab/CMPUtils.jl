module CMPUtils
    using Images
    using ImageIO
    using ImageMagick
    using LinearAlgebra
    using Pipe: @pipe
    using ProgressMeter: @showprogress
    using CSV
    using DataFrames
    using StatsBase
    using WAV
    using MFCC
    using Glob
    using TextAnalysis
    using Taro
    using Languages 
    include("recode.jl")

    export recodeimage, recodeaudio, recodetext
end
