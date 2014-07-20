module.exports = function(grunt) {
    "use strict";

    var srcDirs = ["src/**/*.purs", "src/**/*.purs.hs", "bower_components/**/src/**/*.purs"];

    grunt.initConfig({
	      psc: {
	          options: {
		            main: "XMLHttpRequest",
		            modules: ["XMLHttpRequest"]
	          },
	          all: {
		            src: srcDirs,
		            dest: "dist/Main.js"
	          }
	      },
	      dotPsci: {
	          all: {
		            src: srcDirs,
	          }
	      },
        watch: {
            scripts: {
                files: srcDirs,
                tasks: ["psc:all", "dotPsci:all"],
            },
        },
    });

    grunt.loadNpmTasks("grunt-purescript");
    grunt.loadNpmTasks('grunt-contrib-watch');

    grunt.registerTask("default", ["psc:all", "dotPsci:all"]);
};
