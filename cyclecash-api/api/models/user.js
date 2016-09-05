/**
 * Created by joelwasserman on 8/29/16.
 */

var Promise = require('bluebird');
var bcrypt = require('bcrypt');
Promise.promisifyAll(bcrypt);
var _ = require('lodash');
var cryptojs = require('crypto-js');
var jwt = require('jsonwebtoken');


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
    firstname: {
      type: DataTypes.STRING,
      field: 'first_name'
    },
    lastname: {
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
      type: DataTypes.DATE,
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

      verifyAccessToken: function (token) {
        return new Promise(function (resolve, reject) {
          jwt.verify(token, process.env.JWT_PASSPHRASE, function (err, decoded) {
            if (err) {
              return reject(err);
            }

            resolve(decoded);
          });
        });
      },

      findByAccessToken: function (decoded) {
        return new Promise(function (resolve, reject) {
          try {
            var bytes = cryptojs.AES.decrypt(decoded.token, process.env.AES_PASSPHRASE);
            var tokenData = JSON.parse(bytes.toString(cryptojs.enc.Utf8));
            User.findById(tokenData.id)
              .then(function (user) {
                if (user) {
                  return resolve(user);
                } else {
                  return reject(new MyError(helper.strings.InvalidToken));
                }
              })
              .catch(function (err) {
                reject(err);
              });

          } catch (e) {
            if (e.message && e.message === 'jwt must be provided') {
              return reject(new MyError(helper.strings.InvalidToken));
            }

            if (e.message && e.message === 'invalid signature') {
              return reject(new MyError(helper.strings.InvalidToken));
            } else {
              reject(e);
            }
          }
        });
      },

      findByRefreshToken: function (refreshToken, model) {
        return model.Token.findOne({
          where: {
            tokenHash: cryptojs.MD5(refreshToken).toString(),
          },
        }).then(function (tokenData) {
          if (!tokenData) {
            return Promise.reject(new MyError(helper.strings.InvalidToken));
          }

          return Promise.resolve(tokenData);
        });
      },

      createAccessToken: function (userId) {
        return User.createToken(userId, '2h');
      },

      createRefreshToken: function (userId) {
        return User.createToken(userId, '2000d');
      },

      createToken: function (userId, expiration) {

        try {
          var stringData = JSON.stringify({ id: userId, type: 'authentication' });
          var encryptedData = cryptojs.AES.encrypt(stringData,
            process.env.AES_PASSPHRASE).toString();
          var token = jwt.sign({ token: encryptedData },
            process.env.JWT_PASSPHRASE,
            { expiresIn: expiration });
          return token;
        } catch (e) {
          console.error(e);
          return undefined;
        }
      },

      createAndSaveRefreshToken: function (userId, model) {
        const token = User.createRefreshToken(userId);
        if (token) {
          return model.Token.create({ token: token, userId: userId });
        } else {
          return Promise.reject(new MyError(helper.strings.InvalidToken));
        }
      },

      refreshToken: function (refreshToken, userId, model) {
        model.User.findByRefreshToken(refreshToken, model)
          .then(function (tokenData) {

            return model.User.findByRefreshToken(token);

          }).then(function (user) {
            if (!user) {
              return Promise.reject(new MyError(helper.strings.InvalidToken));
            }
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

  User.beforeValidate(function (user, options) {

    if (!user.email || !user.password) {
      throw new MyError(helper.strings.InvalidParameters);
    }
    user.email = user.email.toLowerCase();
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