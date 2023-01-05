function getPDFText(src)
    doc = pdDocOpen(src)
    docinfo = pdDocGetInfo(doc)
        io = IOBuffer()
		npage = pdDocGetPageCount(doc)
        for i=1:npage
            page = pdDocGetPage(doc, i)
            pdPageExtractText(io, page)
        end
        Text = String(take!(io))
    pdDocClose(doc)
    return (meta = docinfo, text = Text)
end
using PDFIO
path = joinpath(pwd(),"br.pdf")
met,tx = getPDFText(path)
using TextAnalysis
using Languages

alltext = res.text
alltext = replace(alltext, '\n' => ' ')

docs = vcat(StringDocument(alltext), StringDocument(alltext))

crps = TextAnalysis.Corpus(docs)
prepare!(crps, strip_non_letters | strip_punctuation | strip_case | strip_stopwords)
    TextAnalysis.stem!(crps)
    update_lexicon!(crps)
    update_inverse_index!(crps)