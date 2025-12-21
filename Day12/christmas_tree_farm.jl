function unique_board_mutations(A::AbstractMatrix)
    rots = (A, rotl90(A,1), rotl90(A,2), rotl90(A,3))
    S = Set{Matrix{eltype(A)}}()
    for R in rots
        push!(S, Matrix(R))
        push!(S, Matrix(reverse(R, dims=2)))
    end
    return S
end

function generate_block(shape::AbstractString)
    rows = split(chomp(shape), "\n")
    @assert length(rows) == 3
    @assert all(length(r) == 3 for r in rows)

    M = Matrix{Int}(undef, 3, 3)
    for y in 1:3
        for x in 1:3
            M[y, x] = rows[y][x] == '#' ? 1 : 0
        end
    end
    return M
end

function count_cells(shape::AbstractMatrix{<:Integer})
    return sum(shape)
end

function generate_mask(width, height, shape::AbstractMatrix{<:Integer})
    mask = falses(width * height)
    for sy in 1:3
        for sx in 1:3
            if shape[sy, sx] == 1
                idx = (sy - 1) * width + sx
                mask[idx] = true
            end
        end
    end
    return mask
end

function shift_mask(mask::BitVector, shift::Int)
    if shift == 0
        return copy(mask)
    end
    result = falses(length(mask))
    result[1:end-shift] = mask[shift+1:end]
    return result
end

function generate_masks(width, height, shape_map)
    masks = BitVector[]
    base_mask = generate_mask(width, height, shape_map)
    for y in 1:height-2
        for x in 1:width-2
            shift = (y - 1) * width + (x - 1)
            mask = shift_mask(base_mask, shift)
            push!(masks, mask)
        end
    end
    return masks
end

function generate_all_masks_for_shape(width, height, shape::AbstractMatrix{<:Integer})
    muts = unique_board_mutations(shape)
    all_masks = Set{BitVector}()
    for m in muts
        for mask in generate_masks(width, height, m)
            push!(all_masks, mask)
        end
    end
    return collect(all_masks)
end

const MASK_CACHE = Dict{Tuple{Int,Int,Int}, Vector{BitVector}}()

function get_cached_masks(width, height, shape_idx, shape)
    key = (width, height, shape_idx)
    if !haskey(MASK_CACHE, key)
        MASK_CACHE[key] = generate_all_masks_for_shape(width, height, shape)
    end
    return MASK_CACHE[key]
end

function dfs(board::BitVector, pieces_to_place::Vector{Vector{BitVector}}, piece_idx::Int,
             empty_cells::Int, remaining_cells_needed::Int)
    if piece_idx > length(pieces_to_place)
        return true
    end

    if empty_cells < remaining_cells_needed
        return false
    end

    masks = pieces_to_place[piece_idx]
    for mask in masks
        has_overlap = false
        @inbounds for i in eachindex(board)
            if board[i] && mask[i]
                has_overlap = true
                break
            end
        end

        if !has_overlap
            new_board = board .| mask
            cells_placed = count(mask)
            new_empty = empty_cells - cells_placed
            new_remaining = remaining_cells_needed - cells_placed

            if dfs(new_board, pieces_to_place, piece_idx + 1, new_empty, new_remaining)
                return true
            end
        end
    end

    return false
end

function can_fit_region(width, height, shapes, counts, shape_cells)
    total_area = width * height
    required_cells = sum(counts[i] * shape_cells[i] for i in 1:length(shapes))

    if required_cells > total_area
        return false
    end

    if required_cells == 0
        return true
    end

    shape_masks = [get_cached_masks(width, height, i, shapes[i]) for i in 1:length(shapes)]

    for i in 1:length(shapes)
        if counts[i] > 0 && isempty(shape_masks[i])
            return false
        end
    end

    pieces_to_place = Vector{BitVector}[]
    for (i, count) in enumerate(counts)
        for _ in 1:count
            push!(pieces_to_place, shape_masks[i])
        end
    end

    sort!(pieces_to_place, by=length)

    empty_board = falses(width * height)
    return dfs(empty_board, pieces_to_place, 1, total_area, required_cells)
end

function parse_region(line)
    parts = split(line)
    dims = parts[1]
    w, h = parse.(Int, split(replace(dims, ":" => ""), "x"))
    counts = parse.(Int, parts[2:end])
    return w, h, counts
end

# Main
input = read("input", String)
blocks = split(input, "\n\n")

shapes = Matrix{Int}[]
for block in blocks[1:6]
    _, rest = split(block, "\n", limit=2)
    push!(shapes, generate_block(rest))
end

shape_cells = [count_cells(s) for s in shapes]

region_lines = split(chomp(blocks[7]), "\n")

count_fits = 0
for (i, line) in enumerate(region_lines)
    print("\r$i/$(length(region_lines))")
    w, h, counts = parse_region(line)
    if can_fit_region(w, h, shapes, counts, shape_cells)
        global count_fits += 1
    end
end

println("\n$count_fits")
