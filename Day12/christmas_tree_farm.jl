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

function generate_masks(width, height, shape_maps)
    masks = BigInt[]
    for y in 1:height-2
        for x in 1:width-2
            mask = generate_mask(width, height, shape_maps) >> ((y - 1) * width + x - 1)
            println("Mask: ", string(mask, base=2, pad=width*height))
            push!(masks, mask)
        end
    end
    return masks
end

input = read("input", String)
blocks = split(input, "\n\n")

shapes = Matrix{Int}[]
for block in blocks[1:6]
    _, rest = split(block, "\n", limit=2)
    push!(shapes, generate_block(rest))
end

println(shapes)

board = "5x5"
w, h = parse.(Int, split(board, "x"))
for s in shapes
    muts = unique_board_mutations(s)
    masks = Set(Iterators.flatten(generate_masks(w, h, m) for m in muts))
    println("Final masks: ", masks)
end
