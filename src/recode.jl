"""
This function accepts path to a folder containing images (.png & .jpg) and  
    number of singular values you want as arguments and generates a CSV File 
    in the same folder with each row corresoponding to each images in the folder  
    and each column corresoponding to it's respective singular values. 
    USAGE: 
    ```julia
    recodeimage(path,3)
    ```
    In the above example, we are asking to return a CSV File that has the first 3 singular  
    values of the images in the folder. 
"""
function recodeimage(pathtoimage, n_singularvlas)
    imagelist = glob("*.jpg", pathtoimage) # reading all files with .jpg extension 
    append!(imagelist,  glob("*.JPG", pathtoimage))
    append!(imagelist,  glob("*.png", pathtoimage)) # reading files with .png extension
    append!(imagelist,  glob("*.PNG", pathtoimage))
    recodedArray = Array{Float64}(undef, 0, n_singularvlas) # empty array for storing the final matrix 
    @showprogress for images in imagelist
        X = load(images)
        img_singluar = @pipe X |> Float64.(Gray.(_)) |> svdvals(_)[1:n_singularvlas]' # @pipe is a macro for chaining multiple tasks
        recodedArray = vcat(recodedArray, img_singluar) 
    end
    filename = joinpath(pathtoimage, "image_recoded.csv")
    CSV.write(filename,  DataFrame(recodedArray), writeheader=true)
end

function recodeaudio(filepath,ncep)
    audiolist = glob("*.wav",filepath)
    recodedArray = Array{Float64}(undef, 0, ncep)
    @showprogress for files in audiolist
        x,fs = wavread(files)
        cep = collect(mfcc(x,fs, numcep = ncep)[1])# this is a matrix with ncep columns 
        recodedArray = vcat(recodedArray, mean(cep,dims=1))
    end
    filename = joinpath(filepath, "audio_recoded.csv")
    CSV.write(filename,  DataFrame(recodedArray), writeheader=true)
end

function recodetext(pathtotxt, n_singularvals)
    Taro.init()
    files = glob("*.pdf", pathtotxt)
    docs = Array{StringDocument{String},1}[]
    getTitle(t) = TextAnalysis.sentence_tokenize(Languages.English(), t)[1]
   @showprogress for i in 1:length(files)
        meta,txt = Taro.extract(files[i]);
        txt = replace(txt, '\n' => ' ')
        title = getTitle(txt)
        dm = TextAnalysis.DocumentMetadata(Languages.English(), title, "", meta["Creation-Date"] )
        doc = StringDocument(txt, dm)
        docs = vcat(docs, doc)
    end
    crps = Corpus(docs)
    
    prepare!(crps, strip_non_letters | strip_punctuation | strip_case | strip_stopwords)
    stem!(crps)
    update_lexicon!(crps)
    update_inverse_index!(crps)
    U,S,Vt = @pipe crps |> DocumentTermMatrix(_) |> dtm(_, :dense) |> svd(_)
    if n_singularvals > length(S)
        println("You have set more number of singluar values than present \n so seting number of singluar values = length(singular values)")
        n_singularvals = length(S)
    end
    DTM = U[:,1:n_singularvals]*diagm(S[1:n_singularvals])*Vt[:,1:n_singularvals]'
    filename = joinpath(pathtotxt, "reconstructed_document_term_matrix.csv")
    CSV.write(filename,  DataFrame(DTM), writeheader=true)
end