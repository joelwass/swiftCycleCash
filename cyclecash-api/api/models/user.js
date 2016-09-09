/**
 * Created by joelwasserman on 8/29/16.
 */

var Promise = require('bluebird');
var bcrypt = require('bcrypt');
Promise.promisifyAll(bcrypt);
var _ = require('lodash');


const helper = require('../helpers');
const MyError = helper.error;

module.exports = function (sequelize, DataTypes) {
  var User = sequelize.define('User', {
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true,
    },
    email: {
      type: DataTypes.STRING,
      field: 'email',
      validate: {
        isEmail: true,
      },
    },
    password: {
      type: DataTypes.STRING,
      field: 'password',
      validate: {
        len: [6, 100],
      },
    },
    first_name: {
      type: DataTypes.STRING,
      field: 'first_name'
    },
    last_name: {
      type: DataTypes.STRING,
      field: 'last_name',
    },
    pedal_points: {
      type: DataTypes.INTEGER,
      field: 'pedal_points',
    },
    distance_traveled: {
      type: DataTypes.DOUBLE,
      field: 'distance_traveled',
    },
    time_traveled: {
      type: DataTypes.INTEGER,
      field: 'time_traveled',
    },
    meta: {
      type: DataTypes.JSON,
      field: 'meta',
    },
  }, {
    classMethods: {
      authenticate: function (body) {
        var user;
        var params =  { where:
          { email: body.email },
        };
        return User.findOne(params)
          .then(function (localUser) {
            if (localUser) {
              user = localUser;
              return bcrypt.compareAsync(body.password, user.password);
            } else {
              return Promise.reject(new MyError(helper.strings.SorryWeCantFindEmail));
            }
          })
          .then(function (result) {
            if (result) {
              return Promise.resolve(user);
            } else {
              return Promise.reject(new MyError(helper.strings.PasswordInvalid));
            }
          })
          .catch(function (err) {
            return Promise.reject(err);
          });
      },

    },
    instanceMethods: {

    },
    indexes: [
      {
        unique: true,
        fields: ['email'],
      },
    ],
  });

  User.beforeCreate(function (user, options, next) {

    // encrypt password
    bcrypt.hash(user.password, 10, function (err, encryptedPassword) {
      if (err) return next(err);
      user.password = encryptedPassword;
      return next();
    });
  });

  User.beforeUpdate(function (user, options, next) {

    if (!user.changed('password')) {
      return next();
    }

    // encrypt password
    bcrypt.hash(user.password, 10, function (err, encryptedPassword) {
      if (err) return next(err);
      user.password = encryptedPassword;
      next();
    });
  });

  return User;
};