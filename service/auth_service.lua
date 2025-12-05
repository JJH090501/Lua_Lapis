local db = require("lapis.db")
local bcrypt = require("bcrypt")

local AuthService = {}

-- signUp
function AuthService.signup(username, password, email)


    if type(username) ~= "string" or username == "" then
        return false, "Invalid username"
    end
    if not password or #password < 6 then
        return false, "Password must be at least 6 characters long"
    end

    -- 중복 처리
    local exists = db.select("id FROM users WHERE username = ?", username)[1]
    if exists then return false, "Username already exists" end -- 예외처리

    local hashed_password = bcrypt.digest(password, 12)
    db.insert("users", {
        username = username,
        pw = hashed_password,
        email = email
    })

    return true
end

-- login
function AuthService.login(username, password)

    -- 쿼리문으로 사용자 조회
    local user = db.select("* FROM users WHERE username = ?", username)[1]
    if not user then return false, "User Not Found" end

    -- 비밀번호 검증
    if not bcrypt.verify(password, user.pw) then
        return false, "Password Incorrect"
    end

    -- 로그인 성공 반환
    return true, "Login Successful"
end

return AuthService