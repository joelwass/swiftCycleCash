/**
 * Created by joelwasserman on 9/5/16.
 */

var express = require('express');
var router = express.Router();
var middleware = require('./middleware');
var controllers = require('../api/controllers');

router.route('/api/v1/users/')
    .post(controllers.user.createUser)
    .put(middleware.requireAuthentication, controllers.user.updateUser)
    .get(middleware.requireAuthentication, controllers.user.retrieveUser)

router.route('/api/v1/users/login/')
    .post(controllers.user.loginUser);

router.route('/api/v1/users/stats/')
    .post(controllers.transaction.createTransaction)
    .get(controllers.transaction.getAllTransactions);

module.exports = router;
