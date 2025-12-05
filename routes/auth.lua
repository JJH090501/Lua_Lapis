local AuthService = require("service.auth_service")
local cjson = require("cjson.safe")

return function(app)

    app:post("/signup", function(self) -- self는 자바의 requestDto와 같음. 보통은 self라고 정의함
        
        ngx.req.read_body()
        local raw = ngx.req.get_body_data()
        local body, err = cjson.decode(raw)

        if type(body) ~= "table" then
            return { status = 400, json = { success = false, message = "Invalid JSON structure" } }
        end

        local username = body.username
        local password = body.password
        local email = body.email

        if not username or not password or not email then
            return { status = 400, json = { success = false, message = "Missing required fields" } }
        end

        local ok, message = AuthService.signup(username, password, email)
        if not ok then
            return { status = 400, json = { success = false, message = message } }
        end

        return { status = 201, json = { success = true, message = "User registered successfully" } }
    end)

    app:post("/login", function(loginReq)
        ngx.req.read_body()
        local raw = ngx.req.get_body_data()
        local body, err = cjson.decode(raw)
        local username = body.username
        local password = body.password

        if type(body) ~= "table" then
            return { status = 400, json = { success = false, message = "Invalid JSON structure" } }
        end

        if not username or not password then
            return { status = 400, json = { success = false, message = "Missing required fields" } }
        end

        local ok, message = AuthService.login(username, password)
        if not ok then
            return { status = 401, json = { success = false, message = message } }
        end

        return { status = 200, json = { success = true, message = "Login successful" } }
    end)
end