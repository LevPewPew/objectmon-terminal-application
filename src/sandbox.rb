# array = [1, 2, nil, 4]
# test = []
# array.each_with_index do |item, i|
#     begin
#         test << item + i
#     rescue => error
#         p "RESCUED"
#     end
#     p "DID I BREAK? #{i}"
# end

# puts ''

# array = [1, 2, nil, 4]
# test = []
# array.each_with_index do |item, i|
#     begin
#         test << item + i
#     rescue => error
#         p "RESCUED"
#         break
#     end
#     p "DID I BREAK? #{i}"
# end

# ary = [1, 3, 2, 6, 5]
# ary.sort! { |a, b| a <=> b } 

# p ary
arr = [5, 6, 7, 8]
test = arr.map { |x| x*10 }
p test