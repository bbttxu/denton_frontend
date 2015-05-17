
exports.config = {
    "modules": [
        "copy",
        "server",
        "coffeescript",
        // "coffeelint",
        // "csslint",
        "lint",
        "require",
        "minify-js",
        "minify-css",
        'minify-img',
        "live-reload",
        "bower",
        "jade",
        "server-template-compile",
        "less",
        "cjsx",
        "dependency-graph"
    ],
    "iced": {
        extensions: ["coffee", "iced"],
        options: {
            sourceMap: true,
            bare: true,
            runtime: "inline"
        }
    },
    "serverTemplate": {
        'locals': {
            "title": "Mimosa",
            "reload": false,
            "optimize": true,
            "build": true
        }
    },
    require: {
      exclude:[],
      commonConfig:"common",
      tracking: {
        enabled: true,
        path: ".mimosa/require/tracking.json"
      },
      verify: {
        enabled: true,
        plugins: {
          css:"css",
          hbs:"hbs"
        }
      },
      optimize : {
        modules: null,
        moduleCachingPath: ".mimosa/require/moduleCaching",
        inferConfig:true,
        removeCombined: true,
        overrides:{}
      }
    }
  }
