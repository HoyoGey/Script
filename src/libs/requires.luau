return function(Config)
    getgenv().requireL = function(path)
        -- Ensure the path is a string
        assert(type(path) == "string", "invalid argument #1 to 'requireL' (string expected, got " .. type(path) .. ")", 2)

        -- Construct the URL to fetch the script from GitHub
        local url = string.format("https://raw.githubusercontent.com/%s/%s/refs/heads/%s/%s",
            Config.githubUsername, -- 1
            Config.githubRepo,     -- 2
            Config.githubBranch,   -- 3
            path                   -- 4
        )

        -- Make the request to the URL
        local response = request({Url = url; Method = "GET";})
        print("Get Request on Url:", url)

        -- Check if the response is successful
        if response.Success then
            return response.Body -- Return the body of the response
        else
            error("Failed to fetch script from: " .. url .. " | Error: " .. response.StatusCode)
        end
    end
end
