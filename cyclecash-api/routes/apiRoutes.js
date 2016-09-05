/**
 * Created by joelwasserman on 9/5/16.
 */

var express = require('express');
var router = express.Router();
var controllers = require('../api/controllers');

router.route('/api/v1/users/')
    .post(controllers.user.createUser)
    .put(controllers.user.updateUser)

router.route('/api/v1/users/login/')
    .post(controllers.user.loginUser);

router.route('/api/v1/users/stats/')
    .post(controllers.transaction.createTransaction)
    .get(controllers.transaction.getAllTransactions);

module.exports = router;
