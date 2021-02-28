using ValueGraphFromDataFrame
using SimpleValueGraphs
using LightGraphs
using DataFrames
using Test


vertex_attributes = DataFrame(
    name=["a", "b", "c", "d", "e", "f", "g", "h", "i", "j"], 
    col1=1:10,
    col2=vcat(trues(5), falses(5))
)

edgelist = DataFrame(
    from=["a", "a", "a", "b", "f", "g", "d", "d", "c"],
    to  =["b", "c", "i", "a", "d", "f", "e", "a", "j"],
    #eval=1:9
)

g = ValDiGraph(edgelist, vertex_attributes)
e = LightGraphs.edges(g) |> first

@testset "ValueGraphFromDataFrame.jl" begin
    get_vertexval(g, 4, :name) == "d"
    get_vertexval(g, 9, :col1) == 9
    get_vertexval(g, 3, :col2) == true
    get_vertexval(g, src(e), :name) == "a"
    get_vertexval(g, dst(e), :col1) == 2
    #get_edgeval(g, 1, 3, :eval) == 3
end
