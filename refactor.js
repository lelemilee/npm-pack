var fs = require('fs');

function jsonConcat(o1, o2) {
 for (var key in o2) {
  o1[key] = o2[key];
 }
 return o1;
}

function devToNoDev(filename) {
    fs.readFile(filename, 'utf8', function(err, data){
        var dict = JSON.parse(data)
        dict.dependencies = jsonConcat(dict.dependencies, dict.devDependencies)
        dict.devDependencies = {}
        fs.writeFile(filename, JSON.stringify(dict, null, 2) , function (err) {
            if (err) throw err;
        })
    });
}

filename = process.argv.slice(2)[0]
if (!filename) {
    console.log("Failed")
}

devToNoDev(filename)

console.log("Success")