# Utilities

function get_cartdims(outer_data)
    g = get_section(outer_data, :GRID)
    @assert haskey(g, "cartDims") "Cannot access cartDims, has not been set."
    return g["cartDims"]
end

function set_cartdims!(outer_data, dim)
    @assert length(dim) == 3
    g = get_section(outer_data, :GRID)
    dim = tuple(dim...)
    gdata = get_section(outer_data, :GRID)
    gdata["cartDims"] = dim
    gdata["CURRENT_BOX"] = (lower = (1, 1, 1), upper = dim)
end

# Keywords follow

function parse_keyword!(data, outer_data, units, cfg, f, ::Val{:SGAS})
    data["SGAS"] = parse_grid_vector(f, outer_data["GRID"]["cartDims"], Float64)
end

function parse_keyword!(data, outer_data, units, cfg, f, ::Val{:SWAT})
    data["SWAT"] = parse_grid_vector(f, outer_data["GRID"]["cartDims"], Float64)
end

function parse_keyword!(data, outer_data, units, cfg, f, ::Val{:TEMPI})
    T_i = parse_grid_vector(f, outer_data["GRID"]["cartDims"], Float64)
    swap_unit_system!(T_i, units, :relative_temperature)
    data["TEMPI"] = T_i
end

function parse_mole_fractions!(f, outer_data)
    d = outer_data["GRID"]["cartDims"]
    nc = compositional_number_of_components(outer_data)
    return parse_grid_vector(f, (d[1], d[2], d[3], nc), Float64)
end

function parse_keyword!(data, outer_data, units, cfg, f, ::Val{:XMF})
    data["XMF"] = parse_mole_fractions!(f, outer_data)
end

function parse_keyword!(data, outer_data, units, cfg, f, ::Val{:YMF})
    data["YMF"] = parse_mole_fractions!(f, outer_data)
end

function parse_keyword!(data, outer_data, units, cfg, f, ::Val{:PRESSURE})
    p = parse_grid_vector(f, outer_data["GRID"]["cartDims"], Float64)
    swap_unit_system!(p, units, :pressure)
    data["PRESSURE"] = p
end

function parse_keyword!(data, outer_data, units, cfg, f, ::Val{:RS})
    rs = parse_grid_vector(f, outer_data["GRID"]["cartDims"], Float64)
    swap_unit_system!(rs, units, :u_rs)
    data["RS"] = rs
end

function parse_keyword!(data, outer_data, units, cfg, f, ::Val{:ACTNUM})
    data["ACTNUM"] = parse_grid_vector(f, get_cartdims(outer_data), Bool)
end

function parse_keyword!(data, outer_data, units, cfg, f, ::Val{:RSVD})
    n = number_of_tables(outer_data, :equil)
    out = []
    for i = 1:n
        rs = parse_deck_matrix(f)
        swap_unit_system_axes!(rs, units, (:length, :u_rs))
        push!(out, rs)
    end
    data["RSVD"] = out
end

function parse_keyword!(data, outer_data, units, cfg, f, ::Val{:EQUIL})
    n = number_of_tables(outer_data, :equil)
    def = [0.0, NaN, 0.0, 0.0, 0.0, 0.0, 0, 0, 0]
    eunits = (:length, :pressure, :length, :pressure, :length, :pressure, :id, :id, :id)
    out = []
    for i = 1:n
        rec = read_record(f)
        result = parse_defaulted_line(rec, def)
        swap_unit_system_axes!(result, units, eunits)
        push!(out, result)
    end
    data["EQUIL"] = out
end
