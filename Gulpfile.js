// Require the needed packages
var browserify   = require('browserify'),
    coffeeify    = require('coffeeify'),
    hbsfy        = require('hbsfy').configure({extensions: ['.hbs']}),
    del          = require('del'),
    gulp         = require('gulp'),
    gutil        = require('gulp-util'),
    minifycss    = require('gulp-minify-css'),
    path         = require('path'),
    plumber      = require('gulp-plumber'),
    qunit        = require('gulp-qunit'),
    rename       = require('gulp-rename'),
    runSequence  = require('run-sequence'),
    sass         = require('gulp-sass'),
    source       = require('vinyl-source-stream'),
    sourcemaps   = require('gulp-sourcemaps'),
    streamify    = require('gulp-streamify'),
    uglify       = require('gulp-uglify'),
    watch        = require('gulp-watch');

// Base paths
var BASE_SRC_PATH       = path.join(__dirname, 'src'),
    BASE_GENERATED_PATH = path.join(__dirname, '.generated'),
    BASE_JS_PATH        = path.join(BASE_SRC_PATH, 'js'),
    BASE_CSS_PATH       = path.join(BASE_SRC_PATH, 'css');
    BASE_TEST_PATH      = path.join(__dirname, 'test');

// Task paths
var paths = {
  input: {
    css: path.join(BASE_CSS_PATH, 'peteshow.scss'),

    js: {
      vendor: [ ],

      src: [
        path.join(BASE_JS_PATH, 'peteshow.coffee')
      ]
    },
    
    testSync: [
      path.join(BASE_TEST_PATH, 'suite', '*.js'),
      path.join(BASE_TEST_PATH, '*.html')
    ]
  },

  output: {
    css     : path.join(BASE_GENERATED_PATH, 'stylesheets'),
    js      : path.join(BASE_GENERATED_PATH, 'javascripts'),
    testSync: path.join(BASE_GENERATED_PATH)
  },

  watch: {
    css : path.join(BASE_SRC_PATH, 'css', '**', '*.scss'),
    js  : [
      path.join(BASE_SRC_PATH, 'js', '*.coffee'),
      path.join(BASE_SRC_PATH, 'templates', '*.hbs')
    ],
    testSync : [
      path.join(BASE_TEST_PATH, 'suite', '*.js'),
      path.join(BASE_TEST_PATH, '*.html')
    ]
  },

  clean: [
    path.join(BASE_GENERATED_PATH, '**', '*')
  ],

  test: [ 'test/index.html' ]
};

// test : qunit
gulp.task('test', function() {
  return gulp.src(path.join(BASE_GENERATED_PATH, 'test_index.html'))
    .pipe(qunit());
});

// test : synchronize
gulp.task('test-sync', function() {
  return gulp.src(paths.input.testSync, { base: BASE_TEST_PATH })
    .pipe(gulp.dest(paths.output.testSync)
      .on('error', gutil.log)
      .on('error', gutil.beep));
});

//
// css
gulp.task('css', function() {
  return gulp.src(paths.input.css)
    .pipe(plumber())
    .pipe(sourcemaps.init())
    .pipe(sass()
      .on('error', gutil.log)
      .on('error', gutil.beep))
    .pipe(sourcemaps.write())
    .pipe(gulp.dest(paths.output.css))
    .pipe(rename({suffix: '.min'}))
    .pipe(minifycss()
      .on('error', gutil.log)
      .on('error', gutil.beep))
    .pipe(gulp.dest(paths.output.css));
});

//
// js
gulp.task('js', function() {
  var jsStream = browserify(paths.input.js.src, {
      extensions: ['.coffee']
    })
    .require(paths.input.js.vendor)
    .transform('coffeeify')
    .transform('hbsfy')
    .bundle()
    .on('error', gutil.log)
    .on('error', gutil.beep);

  return jsStream
    .pipe(plumber())
    .pipe(source(paths.input.js.src[0]))
    .pipe(rename('peteshow.js'))
    .pipe(gulp.dest(paths.output.js))
    .pipe(rename({suffix:'.min'}))
    .pipe(streamify(uglify())
      .on('error', gutil.log)
      .on('error', gutil.beep))
    .pipe(gulp.dest(paths.output.js));
});

//
// Clean
gulp.task('clean', function() {
  return del(paths.clean);
});

//
// Watch
gulp.task('watch', ['pre-watch'], function() {
  watch(paths.watch.css, function(files, cb) {
    gulp
      .start('css', cb)
      .on('error', gutil.log);
  });
  watch(paths.watch.js, function(files, cb) {
    gulp
      .start('js', cb)
      .on('error', gutil.log);
  });
  watch(paths.watch.testSync, function(files, cb) {
    gulp
      .start('test-sync', cb)
      .on('error', gutil.log);
  });
});

gulp.task('pre-watch', function(callback) {
  runSequence('clean', ['css', 'js'], 'test-sync', callback);
});

//
// Default
gulp.task('default', function(callback) {
  runSequence('clean', ['css', 'js'], 'test-sync', 'test', callback);
});
