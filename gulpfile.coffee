gulp       = require('gulp')
concat     = require('gulp-concat')
coffee     = require('gulp-coffee')
iife       = require('gulp-iife-wrap')
plumber    = require('gulp-plumber')
preprocess = require('gulp-preprocess')

gulp.task 'default', ['build', 'watch'], ->

gulp.task 'build', ->
  dependencies = [
    {global: '$',         require: 'jquery'}
    {global: 'Math',      native:  true}
    {global: 'document',  native:  true}
    {global: 'Error',     native:  true}
    {global: 'TypeError', native:  true}
  ]
    
  gulp.src('source/__manifest__.coffee')
    .pipe plumber()
    .pipe preprocess()
    .pipe iife({global: 'Autogrow', dependencies})
    .pipe concat('autogrow.coffee')
    .pipe gulp.dest('build')
    .pipe coffee()
    .pipe concat('autogrow.js')
    .pipe gulp.dest('build')

gulp.task 'watch', ->
  gulp.watch 'source/**/*', ['build']
