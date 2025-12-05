local lapis = require("lapis")
local app = lapis.Application()

local auth_routes = require("routes.auth")
auth_routes(app)

return app
