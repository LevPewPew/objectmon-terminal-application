array = [1, 2, nil, 4]
test = []
array.each_with_index do |item, i|
    begin
        test << item + i
    rescue => error
        p "RESCUED"
    end
    p "DID I BREAK? #{i}"
end

puts ''

array = [1, 2, nil, 4]
test = []
array.each_with_index do |item, i|
    begin
        test << item + i
    rescue => error
        p "RESCUED"
        break
    end
    p "DID I BREAK? #{i}"
end