/**
 * Created by joelwasserman on 9/5/16.
 */

var express = require('express');
var router = express.Router();
var controllers = require('../api/controllers');

router.route('/v1/users/')
    .post(controllers.user.createUser)
    .put(controllers.user.updateUser)
    .delete(controllers.user.deleteUser);

router.route('/v1/users/login/')
    .post(controllers.user.loginUser);

router.route('/v1/transaction/')
    .post(controllers.transaction.createTransaction)
    .get(controllers.transaction.getAllTransactions)
    .delete(controllers.transaction.deleteTransaction);

module.exports = router;
