# input = read("input", String)
# blocks = split(input, "\n\n")

# for block in blocks[1:5]
#     println(block)
# end

# A = [1 2 3; 4 1 6; 7 8 1]
# println(A[3])

# Functions
# function extract(line)
#   result = []

#   for char in line
#     if char == '#'
#       push!(result, 1)
#     else
#       push!(result, 0)
#     end
#   end
#   return result
# end
# shape_lines = split(shape, "\n")
# shape_maps = [extract(line) for line in shape_lines]

function unique_board_mutations(A::AbstractMatrix)
    rots = (A, rotl90(A,1), rotl90(A,2), rotl90(A,3))
    flipped = reverse(A, dims=2)

    S = Set{Matrix{eltype(A)}}()
    for R in rots
        push!(S, Matrix(R))
        push!(S, Matrix(reverse(R, dims=2)))
    end
    return S
end

function generate_mask(width, height, shape)
    mask = 0
    counter = 1
    for y in 1:height
        for x in 1:width
            mask = mask << 1

            index = (y - 1) * width + x

            if index > 2 * width + 3
              continue
            end

            if x + 2 > width
              continue
            end

            mask += shape[counter]
            counter += 1
        end
    end
    return mask
end

function generate_masks(width, height, shape_maps)
    masks = []
    for y in 1:height-2
        for x in 1:width-2
            mask = generate_mask(width, height, shape_maps) >> ((y - 1) * width + x - 1)
            println("Mask: ", string(mask, base=2, pad=width*height))
            push!(masks, mask)
        end
    end
    return masks
end


# shape = """#.#
# ###
# #.#"""

# temp = []
# for char in shape
#     if char == '#'
#         push!(temp, 1)
#     elseif char == '.'
#         push!(temp, 0)
#     end
# end

# shape_maps = reshape(temp, 3, 3)

# mutations = unique_board_mutations(shape_maps)
# println(mutations)

# println(shape_maps)

# board = "5x5"

# board_info = split(board, "x")
# width = parse(Int, board_info[1])
# height = parse(Int, board_info[2])

# println("Width: ", width)
# println("Height: ", height)

# masks = Set(Iterators.flatten(generate_masks(width, height, m) for m in mutations))

# println("Final masks: ", masks)
