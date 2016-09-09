/**
 * Created by joelwasserman on 8/29/16.
 */

var fs = require('fs');
var path = require('path');
var Sequelize = require('sequelize');

var sequelize = new Sequelize(process.env.MYSQL_DB_NAME, process.env.MYSQL_USER, process.env.MYSQL_PASSWORD, {
  host: process.env.MYSQL_ENDPOINT,
  dialect: 'mysql',
  port:    3306,
  logging: console.log,
  pool: {
    max: 5,
    min: 0,
    idle: 10000,
  },
  benchmark: true,
});

var db = {};

fs.readdirSync(__dirname).filter(function (file) {
  return (file.indexOf('.') !== 0) && (file !== 'index.js');
}).forEach(function (file) {
  var model = sequelize.import(path.join(__dirname, file));
  db[model.name] = model;
});

Object.keys(db).forEach(function (modelName) {
  if ('associate' in db[modelName]) {
    db[modelName].associate(db);
  }
});

db.sequelize = sequelize;
db.Sequelize = Sequelize;

module.exports = db;