// parceljs does not have a proxy build into its dev server
// so we add it ourselves https://github.com/parcel-bundler/parcel/issues/55
const proxy = require("http-proxy-middleware")
const Bundler = require("parcel-bundler")
const express = require("express")
const https = require("https")
const devcert = require("devcert")
const opn = require("opn")
require("dotenv").config()

let bundler = new Bundler("./src/index.html", {
  cache: false,
  minify: false
})

let app = express()

app.use(
  "/graphql",
  proxy({
    target: "http://localhost:4000",
    changeOrigin: true
  })
)

app.use(bundler.middleware())

devcert.certificateFor("localhost").then(ssl => {
  https.createServer(ssl, app).listen(Number(process.env.PORT || 4001))
  opn("https://localhost:4001")
})