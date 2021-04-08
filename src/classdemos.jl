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

# Demo for Perceptron =====================================================
function Perceptron(units)
    ϕ(x) = x >= 0 ? 1 : -1       # Stimulus  
    Chain(
    Dense(3,units, ϕ),           # Hidden Layer 
    Dense(units,1, x-> ϕ.(x)))   # Output Layer 
end

function demoperceptron(lr,epochs, units, X,y)
   #data = Flux.Data.DataLoader(X', y)
    opt = Descent(lr)
    model = Perceptron(units)
    loss(x, y) = sum(Flux.Losses.logitbinarycrossentropy(model(X'), y))
    # Training Method 1
    ps = Flux.params(model)
    for i in 1:epochs
        Flux.train!(loss, ps,zip(X',y), opt)
    end
    return model 
end
#  ========================================================================