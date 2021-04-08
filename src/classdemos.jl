function img_similarity(pathtoimage)
    imagelist = glob("*.jpg", pathtoimage)  
    append!(imagelist,  glob("*.JPG", pathtoimage))
    append!(imagelist,  glob("*.png", pathtoimage)) 
    append!(imagelist,  glob("*.PNG", pathtoimage))

    temp = Array{Array{Float64,2},1}(undef,length(imagelist))
    @showprogress "Loading Images " for i in 1:length(imagelist)
        temp[i] = Float64.(Gray.(imresize(load(imagelist[i]),128,128)))
    end

    similarity_matrix = Matrix{Float64}(undef, length(temp), length(temp))
    for i in 1:length(temp)
        for j in 1:length(temp)
            similarity_matrix[j,i] = assess_ssim(temp[j],temp[i])
        end
    end
    return similarity_matrix
end