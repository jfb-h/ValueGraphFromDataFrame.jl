module ValueGraphFromDataFrame

using SimpleValueGraphs
using DataFrames

export ValDiGraph

function vattr_types_from_df(vertex_df)
    vatypes = eltype.(eachcol(vertex_df))
    vanames = names(vertex_df)
    (; (Symbol.(vanames) .=> vatypes)...)
end

function make_edgelist_nodeidx(edgelist, vertex_df, vertex_df_col=1)
    vind = DataFrame(name=vertex_df[:,vertex_df_col], idx=1:size(vertex_df, 1))
    elnames = Symbol.(names(edgelist, [1,2]))
    res = leftjoin(edgelist, vind, on=elnames[1] => :name)
    rename!(res, :idx => :idx1)
    res = leftjoin(res, vind, on=elnames[2] => :name)
    select!(res, :idx1, :idx, Not(elnames))
    rename!(res, :idx1 => elnames[1], :idx => elnames[2])
    return res
end

function add_vertices_from_df!(vg, vertex_df)
    for r in eachrow(vertex_df)
       add_vertex!(vg, NamedTuple(r))
    end
end

function add_edges_from_df!(vg, edgelist)
    if size(edgelist, 2) > 2
        for r in eachrow(edgelist)
            add_edge!(vg, r[1], r[2], NamedTuple(r[Not([1,2])]))
        end
    else
        for r in eachrow(edgelist)
            add_edge!(vg, r[1], r[2])
        end
    end
end

function SimpleValueGraphs.ValDiGraph(edgelist::DataFrame, vertex_df::DataFrame; vertex_df_col=1)
    vg = ValDiGraph(0, vertexval_types=vattr_types_from_df(vertex_df), vertexval_init=undef)
    el = make_edgelist_nodeidx(edgelist, vertex_df, vertex_df_col)
    add_vertices_from_df!(vg, vertex_df)
    add_edges_from_df!(vg, el)
    return vg
end


end
