gulp       = require('gulp')
concat     = require('gulp-concat')
coffee     = require('gulp-coffee')
umd        = require('gulp-umd-wrap')
plumber    = require('gulp-plumber')
preprocess = require('gulp-preprocess')
fs         = require('fs')

gulp.task 'default', ['build', 'watch'], ->

gulp.task 'build', ->
  dependencies = [
    {global: '$',         require: 'jquery'}
    {global: 'Math',      native:  true}
    {global: 'document',  native:  true}
    {global: 'Error',     native:  true}
    {global: 'TypeError', native:  true}
  ]
    
  header = fs.readFileSync('source/__license__.coffee').toString('UTF-8')
  
  gulp.src('source/__manifest__.coffee')
    .pipe plumber()
    .pipe preprocess()
    .pipe umd({global: 'Autogrow', dependencies, header})
    .pipe concat('autogrow.coffee')
    .pipe gulp.dest('build')
    .pipe coffee()
    .pipe concat('autogrow.js')
    .pipe gulp.dest('build')

gulp.task 'watch', ->
  gulp.watch 'source/**/*', ['build']
