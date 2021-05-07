// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

require("chartkick")
require("chart.js")
require("packs/bootstrap.min")


const images = require.context('../../assets/images', true, /\.(gif|jpg|png|svg|ico)$/i)
const imagePath = (name) => images(name, true)
