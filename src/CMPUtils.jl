module CMPUtils
    #using JavaCall
    #JavaCall.init()
    using PDFIO 
    #Taro.init() 
println("Howdy!!!, Sit back and relax! This might take some time...")
    println("Loading the mighty plotting functions")
    using GRUtils
    println("Let me get some tools to handle images. ")
    using Images
    using ImageIO
    using ImageMagick_jll
    using LinearAlgebra
    using Pipe: @pipe
    using ProgressMeter: @showprogress
    using CSV
    using DataFrames: DataFrame
    using StatsBase
    println("Did you hear something? Tuning up my audio powers!!!!")
    using WAV
    using MFCC: mfcc, deltas 
    using Glob
    println("Oh, I almost forgot about the PDFs!")
    using TextAnalysis
    using Languages 
    using StatsBase
    include("plotting.jl")
    include("recode.jl")
    include("classdemo.jl")

    export recodeimage, recodeaudio, recodetext, img_similarity, recodeaudio2
    precompile(recodeimage, (String,Int),)
    precompile(recodeaudio, (String,Int),)
    precompile(recodetext, (String,Int),)
    println("CMPUtils reporting for duty!")
end
