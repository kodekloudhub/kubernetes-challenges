var restify = require("restify");
var server = restify.createServer();
var pkg = require("../package.json");
var rootResponder = require("./routes/root");

server.get("/", rootResponder);

server.listen(3000, function() {
  console.log("restifyjs version %s running on port 3000", pkg.version);
  setInterval(function() {
    console.log("restifyjs version %s running on port 3000", pkg.version);
  }, 10000);
});
