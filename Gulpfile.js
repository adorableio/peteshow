// Require the needed packages
var browserify   = require('browserify'),
    buffer       = require('vinyl-buffer'),
    coffeeify    = require('coffeeify'),
    hbsfy        = require('hbsfy').configure({extensions: ['.hbs']}),
    del          = require('del'),
    flatten      = require('gulp-flatten'),
    gulp         = require('gulp'),
    gutil        = require('gulp-util'),
    minifycss    = require('gulp-minify-css'),
    path         = require('path'),
    plumber      = require('gulp-plumber'),
    qunit        = require('gulp-qunit'),
    rename       = require('gulp-rename'),
    runSequence  = require('run-sequence'),
    stylus       = require('gulp-stylus'),
    source       = require('vinyl-source-stream'),
    sourcemaps   = require('gulp-sourcemaps'),
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
    css: path.join(BASE_CSS_PATH, 'peteshow.styl'),

    js: {
      vendor: [ ],

      src: [
        path.join(BASE_JS_PATH, 'peteshow.coffee')
      ]
    },

    testSync: {
      src: [
        path.join(BASE_TEST_PATH, 'suite', '*.js'),
        path.join(BASE_TEST_PATH, 'vendor', '**', '*')
      ],
      vendor: [
        path.join(__dirname, 'node_modules', 'qunitjs', 'qunit', '*'),
        path.join(__dirname, 'node_modules', 'faker', 'build', 'build', '*'),
        path.join(__dirname, 'node_modules', 'jquery', 'dist', '*'),
        path.join(__dirname, 'node_modules', 'jquery.cookie', 'jquery.cookie.js'),
        path.join(__dirname, 'node_modules', 'jquery-formatdatetime', 'jquery.formatDateTime.js')
      ]
    }
  },

  output: {
    css     : path.join(BASE_GENERATED_PATH, 'stylesheets'),
    js      : path.join(BASE_GENERATED_PATH, 'javascripts'),
    testSync: path.join(BASE_GENERATED_PATH),
    vendor  : path.join(BASE_GENERATED_PATH, 'vendor')
  },

  watch: {
    css : path.join(BASE_SRC_PATH, 'css', '**', '*.styl'),
    js  : [
      path.join(BASE_SRC_PATH, 'js', '*.coffee'),
      path.join(BASE_SRC_PATH, 'templates', '*.hbs')
    ],
    testSync : [
      path.join(BASE_TEST_PATH, 'suite', '*.js'),
      path.join(BASE_TEST_PATH, 'vendor', '**', '*')
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
    .pipe(watch(path.join(BASE_GENERATED_PATH, '**', '*')))
    .pipe(qunit());
});

// test : synchronize
gulp.task('test-sync', function() {
  return gulp.src(paths.input.testSync.src, { base: BASE_TEST_PATH })
    .pipe(gulp.dest(paths.output.testSync)
      .on('error', gutil.log)
      .on('error', gutil.beep));

});
// vendor
gulp.task('vendor', function() {
  return gulp.src(paths.input.testSync.vendor)
    .pipe(plumber())
    .pipe(flatten())
    .pipe(gulp.dest(paths.output.vendor));
});

//
// css
gulp.task('css', function() {
  gulp.src(paths.input.css)
    .pipe(plumber())
    .pipe(sourcemaps.init({loadMaps: true}))
    .pipe(stylus()
      .on('error', gutil.log)
      .on('error', gutil.beep))
    .pipe(sourcemaps.write('./'))
    .pipe(gulp.dest(paths.output.css));

  return gulp.src(paths.input.css)
    .pipe(plumber())
    .pipe(sourcemaps.init({loadMaps: true}))
    .pipe(stylus()
      .on('error', gutil.log)
      .on('error', gutil.beep))
    .pipe(rename({suffix: '.min'}))
    .pipe(minifycss()
      .on('error', gutil.log)
      .on('error', gutil.beep))
    .pipe(sourcemaps.write('./'))
    .pipe(gulp.dest(paths.output.css));
});

//
// js
gulp.task('js', function() {
  var jsStream = browserify(paths.input.js.src, {
      extensions: ['.coffee'],
      debug: true
    })
    .require(paths.input.js.vendor)
    .transform('coffeeify')
    .transform('hbsfy')
    .bundle()
    .on('error', gutil.log)
    .on('error', gutil.beep);

  // standard code
  jsStream
    .pipe(plumber())
    .pipe(source(paths.input.js.src[0]))
    .pipe(buffer())
    .pipe(sourcemaps.init({loadMaps: true}))
    .pipe(rename('peteshow.js'))
    .pipe(sourcemaps.write('./'))
    .pipe(gulp.dest(paths.output.js));

  // minified code
  jsStream
    .pipe(plumber())
    .pipe(source(paths.input.js.src[0]))
    .pipe(buffer())
    .pipe(sourcemaps.init({loadMaps: true}))
    .pipe(uglify({ compress: { negate_iife: false }})
      .on('error', gutil.log)
      .on('error', gutil.beep))
    .pipe(rename('peteshow.min.js'))
    .pipe(sourcemaps.write('./'))
    .pipe(gulp.dest(paths.output.js));

  return jsStream;
});

//
// Clean
gulp.task('clean', function() {
  return del(paths.clean);
});

//
// Watch
gulp.task('watch', ['pre-watch'], function() {
  watch(paths.watch.css, function() {
    gulp.start('css');
  });

  watch(paths.watch.js, function() {
    gulp.start('js');
  });

  watch(paths.watch.testSync, function() {
    gulp.start('test-sync');
  });
});

gulp.task('pre-watch', function(callback) {
  runSequence('clean', 'css', 'js', 'test-sync', callback);
});

//
// Default
gulp.task('default', function(callback) {
  runSequence('clean', 'css', 'js', 'test-sync', 'test', callback);
});
