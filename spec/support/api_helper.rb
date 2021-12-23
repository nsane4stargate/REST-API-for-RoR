module ApiHelpers
    def json
        JSON.parse(response.body).deep_symbolize_keys # parse the JSON body response # returns symbols instead of strings
            # pp body # Print out the body to see the different values
    end

    def json_data
        json[:data] # returns data key from json
    end
end