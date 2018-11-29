module.exports = function(req, res, next) {
  res.contentType = "text/html";
  res.end('<html><body body style="background-color:powderblue;">  <p align="center"><font size="6">Hello Kubernetes!</font></p></body></html>');
  next();
};
