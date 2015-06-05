express = require "express"
serveStatic = require "serve-static"
bodyParser = require "body-parser"
cors = require "express-cors"
path = require "path"
Sequelize = require "sequelize"
_ = require "lodash"
Promise = require "bluebird"


app = express()
sequelize = new Sequelize('database', 'username', 'password',
    dialect: 'sqlite'
    pool:
        max: 5
        min: 0
        idle: 10000
    storage: __dirname + '/logs.SQLite')

Click = sequelize.define('log',
    elementName: Sequelize.STRING
    userAction: Sequelize.STRING
    widget: Sequelize.STRING
    role: Sequelize.STRING
    userUri: Sequelize.STRING
    roleUri: Sequelize.STRING)

sequelize.sync()

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
    Click.findAll().then (clicks) ->
        res.render "index", {clicks}

app.get "/api/:user/:company", (req, res) ->
    sequelize.query("Select COUNT(*) AS count, DATE(createdAt) as date
        FROM logs WHERE replace(replace(userUri,char(10),''),char(13),'') = '#{req.params.user}'
        AND roleUri = '#{req.params.company}'
        GROUP BY `date`
        ORDER BY `date`")
    .then (clicks) ->
        res.json clicks[0]

app.get "/dashboard", (req, res) ->
    finalCompanies = []
    sequelize.query("Select DISTINCT roleUri FROM logs").then (companies) ->
        Promise.each companies[0], (company) ->
            sequelize.query("Select DISTINCT userUri FROM logs WHERE roleUri = '#{company.roleUri}'").then (users) ->
                users = _.map users[0], (user) ->
                    userUri: user.userUri.replace(/(\r\n|\n|\r)/gm,"")
                finalCompanies.push
                    roleUri: company.roleUri
                    users: users
        .then ->
            res.render "dashboard", {companies: finalCompanies}

app.get "/widget/:widgetName", (req, res) ->
    widgetName = req.params.widgetName
    Click.findAll(where: widget: widgetName).then (clicks) ->
        res.render "widgets", {clicks, widgetName}
        return

app.get "/get", (req, res) ->
    Click.findAll().then (clicks) ->
        res.render "index", {clicks}

app.post "/save", (req, res, next) ->
    data = req.body
    rec = Click.build data
    rec.save().error((err) ->
        console.log err
        return
    )

app.listen(process.env.PORT || 9080)
