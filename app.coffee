express = require "express"
serveStatic = require "serve-static"
mongoose = require "mongoose"
bodyParser = require "body-parser"
cors = require "express-cors"
path = require "path"

app = express()
connectionString = "mongodb://pereter:0032380as@ds043981.mongolab.com:43981/boostloger"
mongoose.connect connectionString

ClickSchema = new mongoose.Schema
    elementName: String
    userAction: String
    updated: { type: Date, default: Date.now }
    widget: String
    role: String

Click = mongoose.model "Click", ClickSchema

app.use bodyParser.urlencoded extended: true
app.use bodyParser.json()

app.use cors
    allowedOrigins: [
        "fp.dev:*"
    ]

app.use express.static(__dirname + '/dist')
app.use express.static(__dirname + '/public')

app.set "views", path.join(__dirname, "views")
app.set "view engine", "jade"

app.get "/", (req, res) ->
    Click.find {}, (err, clicks) ->
        res.render "index", {clicks}

app.get "/get", (req, res) ->
    Click.find {}, (err, result) ->
        res.json {
            result
            code: 200
            status: "OK"
        }

app.post "/save", (req, res, next) ->
    data = req.body
    c = new Click data
    c.save (err) ->
        res.json
            code: 200
            status: "OK"
            id: c.id

app.listen(process.env.PORT || 5000)
