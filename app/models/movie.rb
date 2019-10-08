class Movie < ActiveRecord::Base
    def self.get_raitings
        ['G','PG','PG-13','R']
    end
    
    def initialize(arr)
        
    end
end
