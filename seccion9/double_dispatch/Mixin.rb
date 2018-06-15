module A
    def double
        @num * 2
    end
end
module B
    def double
        @num * 4
    end
end
class C
    include B
    include A
    attr_accessor :num
    def initialize(x)
        @num = x
    end
end

obj = C.new(12)
puts obj.double
