require('gulp-lazyload')
  gulp:       'gulp'
  connect:    'gulp-connect'
  concat:     'gulp-concat'
  coffee:     'gulp-coffee'
  preprocess: 'gulp-preprocess'
  iife:       'gulp-iife-wrap'
  uglify:     'gulp-uglify'
  rename:     'gulp-rename'
  del:        'del'
  plumber:    'gulp-plumber'
  replace:    'gulp-replace'

gulp.task 'default', ['build', 'watch'], ->

gulp.task 'build', ->
  gulp.src('source/autogrow.coffee')
  .pipe plumber()
  .pipe preprocess()
  .pipe iife(dependencies: {require: 'jquery', global: '$'})
  .pipe concat('autogrow.coffee')
  .pipe gulp.dest('build')
  .pipe coffee()
  .pipe concat('autogrow.js')
  .pipe gulp.dest('build')

gulp.task 'build-min', ['build'], ->
  gulp.src('build/autogrow.js')
  .pipe uglify()
  .pipe rename('autogrow.min.js')
  .pipe gulp.dest('build')

gulp.task 'watch', ->
  gulp.watch 'source/**/*', ['build']