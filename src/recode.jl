"""
recodeimage(pathtoimage, n_singularvlas) 


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
    # The following code block looks for .jpg/.JPG/.png/.PNG files and create a list of them 
    imagelist = glob("*.jpg", pathtoimage)  
    append!(imagelist,  glob("*.JPG", pathtoimage))
    append!(imagelist,  glob("*.png", pathtoimage)) 
    append!(imagelist,  glob("*.PNG", pathtoimage))

    # Initializing an empty array to store the n_singular values of the images 
    recodedArray = Array{Float64}(undef, 0, n_singularvlas) 

    # @showprogress is a macro to print the progress of this loop when this function is run 
    @showprogress for images in imagelist
        X = load(images)

        # @pipe is a macro for chaining multiple tasks
        # the next two blocks of code takes the image, converts it into grayscale and compute 
        # the singular values, then only the first n_singular values are stored in the recodedArray    
        img_singluar = @pipe X |> Float64.(Gray.(_)) |> svdvals(_)[1:n_singularvlas]' 
        recodedArray = vcat(recodedArray, img_singluar) 
    end
    recodedArray =  standardize(UnitRangeTransform, recodedArray, dims=1)
    # writing the array as a .csv file 
    filename = joinpath(pathtoimage, "image_recoded.csv")
    CSV.write(filename,  DataFrame(recodedArray), writeheader=true)
end


"""
recodeaudio(filepath,ncep)

This function reads audio files (.wav files) in the file path and generates an excel file (.csv) with 
    each row corresoponding to a particular audio file and each column corresoponding to the mean 
    cepstral coefficient. Only the first ncep coefficients are computed.

    USAGE: 
    ```julia
    recodeaudio(path,3)
    ```
"""
function recodeaudio(filepath,ncep)

    # creating a list of .wav files in the folder and an empty array to store the mean cepstral coefficients
    audiolist = glob("*.wav",filepath)
    recodedArray = Array{Float64}(undef, 0, ncep)

    @showprogress for files in audiolist
        x,fs = wavread(files)

        # mfcc is a function from the MFCC package and computes the Mel Frequency Cepstral Coefficients 
        # mfcc returns 3 values: [1] a matrix of numcep columns with for each speech frame a row of MFCC coefficient,
        # [2] the power spectrum, and [3] a dictionary containing the information about the parameters 
        # mfcc(x,fs, numcep = ncep)[1]...here the [1] specifies that we accesing only the cep coefficients matrix. 
        # From the above step, the mean cep is calculated and stored to the recodedArray 
        cep = collect(mfcc(x,fs, numcep = ncep)[1])
        recodedArray = vcat(recodedArray, mean(cep,dims=1))
    end

    # Saving the recodedArray as a .csv file 
    filename = joinpath(filepath, "audio_recoded.csv")
    CSV.write(filename,  DataFrame(recodedArray), writeheader=true)
end

"""
recodetext(pathtotxt, n_singularvals)

This function reads PDF files in the pathtotxt and generates an excel file (.CSV) which contains the 
    document by term matrix reconstructed using only the first n_singularvals. If the passed n_singularvals
    is a larger number than the singular values present, all singular values are used. 

    USAGE: 
    ```julia
    recodetext(pathtotxt,3)
    ```
"""
function recodetext(pathtotxt, n_singularvals)

    # PDF parsing utilities for this function are provided by the Taro julia package 
    # and Taro requires to initialize a java virtual machine. Taro.init() achieves that
    Taro.init()

    # Creating a list of PDF files in the path. 
    files = glob("*.pdf", pathtotxt)

    # Initializing an empty array to store the text from each document 
    docs = Array{StringDocument{String},1}[]

    # This block of code extracts the text from the PDFs and creates a corpus 
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
    
    # cleaning the corpus. getting rid of non-words, punctuations etc...
    prepare!(crps, strip_non_letters | strip_punctuation | strip_case | strip_stopwords)
    stem!(crps)
    update_lexicon!(crps)
    update_inverse_index!(crps)

    # The corpus is used to generates a document term matrix, 
    # and we perform singluar value decomposition on this matrix. 
    U,S,Vt = @pipe crps |> DocumentTermMatrix(_) |> dtm(_, :dense) |> svd(_)
    if n_singularvals > length(S)
        println("You have set more number of singluar values than present \n so seting number of singluar values = length(singular values)")
        n_singularvals = length(S)
    end
    
    # Reconstructing the document term matrix with just the first n_singularvals. 
    DTM = U[:,1:n_singularvals]*diagm(S[1:n_singularvals])*Vt[:,1:n_singularvals]'

    # saving the reconstructed document term matrix as a .csv file 
    filename = joinpath(pathtotxt, "reconstructed_document_term_matrix.csv")
    CSV.write(filename,  DataFrame(DTM), writeheader=true)
end
