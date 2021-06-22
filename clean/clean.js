var fs = require("fs");

fs.readFile("./ski.csv", "utf8" , (err, data) => {
    if (err) {
        console.error(err)
        return
    }
    console.log(data)
});