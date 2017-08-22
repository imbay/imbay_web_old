// Configuration.
const
dir = {
	html: ['./*.pug'],
	js: './js/*.coffee',
	css: './css/*.sass'
},
dest = {
	html: './',
	js: './js/',
	css: './css/'
},
ext = {
	html: '.html',
	js: '.js',
	css: '.css'
},
liveReload = {
	on: false,
	host: '127.0.0.1',
	port: 2001,
	baseDir: './',
	open: false,
	notify: false
},
expressConf = {
	on: true,
	path: './',
	port: 1996
};
// Require modules.
const
	gulp = require('gulp'),
	pug = require('gulp-pug'),
  coffee = require('gulp-coffee'),
	sass = require('gulp-sass'),
	watch = require('gulp-watch'),
	rename = require('gulp-rename'),
	browserSync = require('browser-sync'),
	express = require('express'),
	app = express()
	reload = browserSync.reload;
// Run livereload.
if(liveReload.on === true) {
	browserSync({
		server: {
			baseDir: liveReload.baseDir
		},
		port: liveReload.port,
		open: liveReload.open,
		notify: liveReload.notify
	});
}
// Run the server.
if(expressConf.on === true) {
	app.use(express.static(expressConf.path));
	app.listen(expressConf.port);
}
// Tasks.
gulp.task('html', function() {
	gulp.src(dir.html)
		.pipe(pug({
			pretty: true
		}).on('error', function(error) {
			console.log(error);
		}))
		.pipe(rename(function(path) {
			path.extname = ext.html
		}))
		.pipe(reload({stream: true}))
		.pipe(gulp.dest(dest.html));
});

gulp.task('js', function() {
	gulp.src(dir.js)
		.pipe(coffee().on('error', function(error) {
			console.log(error);
		}))
		.pipe(rename(function(path) {
			path.extname = ext.js
		}))
		.pipe(reload({stream: true}))
		.pipe(gulp.dest(dest.js));
});

gulp.task('css', function() {
	gulp.src(dir.css)
		.pipe(sass().on('error', function(error) {
			console.log(error);
		}))
		.pipe(rename(function(path) {
			path.extname = ext.css
		}))
		.pipe(reload({stream: true}))
		.pipe(gulp.dest(dest.css));
});

gulp.task('start', ['html', 'js', 'css'], function() {
	// Watch html files.
	watch(dir.html, function() {
		gulp.start('html');
	});
	// Watch js files.
	watch(dir.js, function() {
		gulp.start('js');
	});
	// Watch css files.
	watch(dir.css, function() {
		gulp.start('css');
	});
});
