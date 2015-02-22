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

Click = mongoose.model "Click", ClickSchema

app.use bodyParser.urlencoded extended: true
app.use bodyParser.json()

app.use cors
    allowedOrigins: [
        "fp.dev:*"
    ]

app.use serveStatic "./dist"

app.set "views", path.join(__dirname, "views")
app.set "view engine", "jade"

app.get "/", (req, res) ->
    res.render "index", {}

app.get "/get", (req, res) ->
    Click.find {}, (err, result) ->
        res.json {
            result
            code: 200
            status: "OK"
        }

app.post "/save", (req, res, next) ->
    data = req.body
    console.log req.body
    c = new Click data
    console.log c
    c.save (err) ->
        res.json
            code: 200
            status: "OK"
            id: c.id

app.listen(process.env.PORT || 5000)
