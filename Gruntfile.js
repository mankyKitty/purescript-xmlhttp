module.exports = function(grunt) {
    "use strict";

    var srcDirs = ["src/Network/**/*.purs.hs",
                   "bower_components/purescript-*/src/**/*.purs"
                  ];

    grunt.initConfig({
	      psc: {
	          options: {
                tco: true,
                magicDo: true
	          },
	          lib: {
		            src: srcDirs,
	          }
	      },
        watch: {
            scripts: {
                files: srcDirs,
                tasks: ["psc:lib"],
            },
        },
    });

    grunt.loadNpmTasks("grunt-purescript");
    grunt.loadNpmTasks('grunt-contrib-watch');

    grunt.registerTask("default", ["psc:lib"]);
};
