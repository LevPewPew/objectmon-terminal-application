# defined methods here but assume these methods are in your actual program files somewhere and you have done a "require" to bring them in here to be called upon
def adder(num0, num1)
    result = num0 + num1
    return result
end

def array_multiplier(arr0)
    result = arr0.map do |element|
        element * 10
    end
    return result
end

# THE ACTUAL TEST SUITE:

begin
    # delibretly creating a bad condition to force an error to illustrate how the raise will work
    # if adder(2, 8) == 9
    if adder(2, 8) == 10
        puts "adder method: PASS"
        puts ''
    else
        raise("adder method: FAIL\nexpected result of 10\n\n")
    end
rescue => error
    puts error
end

begin
    # delibretly creating a bad condition to force an error to illustrate how the raise will work
    # if array_multiplier([2, 3, 4]).length == 2
    if array_multiplier([2, 3, 4]).length == 3
        puts "array_multiplier method: PASS"
        puts ''
    else
        raise("array_multiplier method: FAIL\nexpected result to have length of 3\n\n")
    end
rescue => error
    puts error
end

begin
    # delibretly creating a bad condition to force an error to illustrate how the raise will work
    # if array_multiplier([2, 3, 4]).is_a?(Numeric)
    if array_multiplier([2, 3, 4]).is_a?(Array)
        puts "array_multiplier method: PASS"
        puts ''
    else
        raise("array_multiplier method: FAIL\nexpected result to be of type Array\n\n")
    end
rescue => error
    puts error
end
