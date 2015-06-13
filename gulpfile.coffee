gulp = require "gulp"
jshint = require "gulp-jshint"
nodemon = require "gulp-nodemon"
coffee = require "gulp-coffee"
gutil = require "gulp-util"
less = require "gulp-less"
livereload = require "gulp-livereload"
watch = require "gulp-watch"

gulp.task "lint", ->
    gulp.src "."
        .pipe jshint()
        .pipe jshint.reporter "jshint-stylish"

gulp.task "coffee", ->
    gulp.src "./src/*.coffee"
        .pipe coffee bare: true
        .on "error", gutil.log
        .pipe gulp.dest "./dist/"

gulp.task "less", ->
    gulp.src "./less/*.less"
        .pipe less()
        .pipe gulp.dest "./dist/css/"
        .pipe livereload()
        # .on "error", gutil.log

gulp.task "watch", ->
    gulp.watch "./src/*.coffee", ["coffee"]
    gulp.watch "./less/*.less", ["less"]

gulp.task "server", ->
    nodemon
        script: "app.coffee"
        ext: "coffee"
        env: "NODE_ENV": "development"
    .on "change", ["lint"]

gulp.task "default", ["server", "watch"]
