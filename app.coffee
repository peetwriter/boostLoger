express = require "express"
serveStatic = require "serve-static"
mongoose = require "mongoose"
bodyParser = require "body-parser"
cors = require "express-cors"
path = require "path"
jf = require "jsonfile"

app = express()
connectionString = "mongodb://pereter:0032380as@ds043981.mongolab.com:43981/boostloger"
mongoose.connect connectionString
clickFile = "#{__dirname}/db/clicks.json"

ClickSchema = new mongoose.Schema
    elementName: String
    userAction: String
    updated: { type: Date, default: Date.now }
    widget: String
    role: String
    userUri: String
    roleUri: String

Click = mongoose.model "Click", ClickSchema

app.use bodyParser.urlencoded extended: true
app.use bodyParser.json()

app.use cors
    allowedOrigins: [
        "role-sandbox.eu"
        "http://127.0.0.1:8073"
    ]

app.use express.static(__dirname + '/dist')
app.use express.static(__dirname + '/public')



app.set "views", path.join(__dirname, "views")
app.set "view engine", "jade"


app.use (req, res, next) ->
  res.header 'Access-Control-Allow-Origin', '*'
  res.header 'Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept'
  next()

app.get "/", (req, res) ->
    obj = {name: "loh2"}
    jf.appendFile clickFile, obj, (err) ->
      console.log err
    Click.find {}, (err, clicks) ->
        res.render "index", {clicks}

app.get "/widget/:widgetName", (req, res) ->
    widgetName = req.params.widgetName
    console.log widgetName
    Click.find { widget: widgetName }, (err, clicks) ->
        res.render "widgets", {clicks, widgetName}

app.get "/get", (req, res) ->
    Click.find { }, (err, result) ->
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

    obj = {name: "loh"}
    jf.writeFile clickFile, obj, (err) ->
      console.log err

app.listen(process.env.PORT || 5000)
