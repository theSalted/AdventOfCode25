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
    @assert width >= 3 && height >= 3
    mask = big(0)
    counter = 1

    for y in 1:height
        for x in 1:width
            mask <<= 1

            if y > 3 || x > 3
                continue
            end

            sy = (counter - 1) ÷ 3 + 1
            sx = (counter - 1) % 3 + 1

            mask += shape[sy, sx]
            counter += 1
        end
    end

    return mask
end

function generate_masks(width, height, shape_map)
    masks = BigInt[]
    base_mask = generate_mask(width, height, shape_map)
    for y in 1:height-2
        for x in 1:width-2
            mask = base_mask >> ((y - 1) * width + x - 1)
            push!(masks, mask)
        end
    end
    return masks
end

function generate_all_masks_for_shape(width, height, shape::AbstractMatrix{<:Integer})
    muts = unique_board_mutations(shape)
    all_masks = Set{BigInt}()
    for m in muts
        for mask in generate_masks(width, height, m)
            push!(all_masks, mask)
        end
    end
    return collect(all_masks)
end

function dfs(board::BigInt, pieces_to_place::Vector{Vector{BigInt}}, piece_idx::Int)
    if piece_idx > length(pieces_to_place)
        return true  # All pieces placed successfully
    end

    masks = pieces_to_place[piece_idx]
    for mask in masks
        if (board & mask) == 0  # No overlap
            new_board = board | mask
            if dfs(new_board, pieces_to_place, piece_idx + 1)
                return true
            end
        end
    end

    return false
end

function can_fit_region(width, height, shapes, counts)
    total_area = width * height

    required_cells = sum(counts[i] * count_cells(shapes[i]) for i in 1:length(shapes))

    if required_cells > total_area
        return false
    end

    if required_cells == 0
        return true
    end

    shape_masks = [generate_all_masks_for_shape(width, height, s) for s in shapes]

    pieces_to_place = Vector{BigInt}[]
    for (i, count) in enumerate(counts)
        for _ in 1:count
            push!(pieces_to_place, shape_masks[i])
        end
    end

    sort!(pieces_to_place, by=length)

    return dfs(big(0), pieces_to_place, 1)
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

region_lines = split(chomp(blocks[7]), "\n")

count_fits = 0
for (i, line) in enumerate(region_lines)
    print("\r$i/$(length(region_lines))")
    w, h, counts = parse_region(line)
    if can_fit_region(w, h, shapes, counts)
        global count_fits += 1
    end
end

println("\n$count_fits")
