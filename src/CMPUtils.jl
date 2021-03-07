module CMPUtils
    println("Howdy!!!, Sit back and relax! This might take some time...")
    println("Loading the mighty plotting functions")
    using Plots 

    println("Let me get some tools to handle images. ")
    using Images
    using ImageIO
    using ImageMagick 
    using LinearAlgebra
    using Pipe: @pipe
    using ProgressMeter: @showprogress
    using CSV
    using DataFrames: DataFrame
    using StatsBase
    println("Did you hear something? Tuning up my audio powers!!!!")
    using WAV
    using MFCC: mfcc 
    using Glob
    println("Oh, I almost forgot about the PDFs!")
    using TextAnalysis
    using Taro
    Taro.init()
    using Languages 
    using StatsBase
    include("recode.jl")

    export recodeimage, recodeaudio, recodetext
    precompile(recodeimage, (String,Int),)
    precompile(recodeaudio, (String,Int),)
    precompile(recodetext, (String,Int),)
    println("CMPUtils reporting for duty!")
end
