/**
 * Created by joelwasserman on 9/5/16.
 */


const _ = require('lodash');
const models  = require('../models');
const helper = require('../helpers');

module.exports = {

    /**
     * @swagger
     * definition:
     *   CreateUser:
     *     properties:
     *       email:
     *         type: string
     *       password:
     *         type: string
     */

    /**
     * @swagger
     * /api/v1/users:
     *   post:
     *     tags:
     *       - Users
     *     description: Creates a grownup.
     *       <table>
     *       <tr>
     *       <td>db</td>
     *       <td>sql check</td>
     *       <tr>
     *       <td>mysql</td>
     *       <td>SELECT * FROM  "Users" WHERE email = 'email' </td>
     *       </tr>
     *       </table>
     *     consumes:
     *       - application/json
     *     produces:
     *       - application/json
     *     parameters:
     *     - name: user
     *       description: Input parameters needed for creating a user
     *       in: body
     *       required: true
     *       schema:
     *         $ref: '#/definitions/CreateUser'
     *     responses:
     *       200:
     *         description: Creates a user
     */

    createTransaction: function (req, res) {

        var body = _.pick(req.body, 'user_email', 'points_spent', 'vendor');
        if (_.keys(body).length != 3) {
            return res.status(400).json({ success: false, message: helper.strings.InvalidParameters });
        }

        models.Transaction.create(body)
            .then(function (localTransaction) {

                return res.status(200).json({ success: true,
                        transaction: localTransaction.toJSON(),
                        message: helper.strings.TransactionCreatedSuccess,
                });
            })
            .catch(function (err) {
                if (err.name && err.name === "MyError") {
                    return res.status(400).json({ success: false, message: err.message });
                } else {
                    return res.status(500).send({ success: false, message: helper.strings.AnErrorHappened });
                }
            });
    },

    /**
     * @swagger
     * definition:
     *   CreateUser:
     *     properties:
     *       email:
     *         type: string
     *       password:
     *         type: string
     */

    /**
     * @swagger
     * /api/v1/users:
     *   post:
     *     tags:
     *       - Users
     *     description: Creates a grownup.
     *       <table>
     *       <tr>
     *       <td>db</td>
     *       <td>sql check</td>
     *       <tr>
     *       <td>mysql</td>
     *       <td>SELECT * FROM  "Users" WHERE email = 'email' </td>
     *       </tr>
     *       </table>
     *     consumes:
     *       - application/json
     *     produces:
     *       - application/json
     *     parameters:
     *     - name: user
     *       description: Input parameters needed for creating a user
     *       in: body
     *       required: true
     *       schema:
     *         $ref: '#/definitions/CreateUser'
     *     responses:
     *       200:
     *         description: Creates a user
     */

    getAllTransactions: function (req, res) {

        models.Transaction.findAll()
            .then(function (results) {

                return res.status(200).json({
                    success: true,
                    transaction: results
                });
            })
            .catch(function (err) {

                if (err.name && err.name === "MyError") {
                    return res.status(400).json({ success: false, message: err.message });
                } else {
                    return res.status(500).send({ success: false, message: helper.strings.AnErrorHappened });
                }
            });
    },

    /**
     * @swagger
     * definition:
     *   SignInUser:
     *     properties:
     *       email:
     *         type: string
     *       password:
     *         type: string
     */

    /**
     * @swagger
     * /api/v1/users:
     *   delete:
     *     tags:
     *       - Users
     *     description: Deletes a user in.
     *       <table>
     *       <tr>
     *       <td>db</td>
     *       <td>sql example</td>
     *       <tr>
     *       <td>postgres</td>
     *       <td>select * from "Users" where email = "email"</td>
     *       </tr>
     *       </table>
     *     consumes:
     *       - application/json
     *     produces:
     *       - application/json
     *     parameters:
     *     - name: user
     *       description: Input parameters needed for signing in a user
     *       in: body
     *       required: true
     *       schema:
     *         $ref: '#/definitions/SignInUser'
     *     responses:
     *       200:
     *         description: Deletes in a user
     */

    deleteTransaction: function (req, res) {

        var body = _.pick(req.body, 'user_id', 'points_spent', 'vendor');
        if (_.keys(body).length != 3) {
            return res.status(400).json({ success: false, message: helper.strings.InvalidParameters });
        }

        models.Transaction.findOne(body)
            .then(function (localTransaction) {

                localTransaction.destroy();
                return res.status(200).json({ success: true });
            })
            .catch(function (err) {
                if (err.name && err.name === "MyError") {
                    return res.status(400).json({ success: false, message: err.message });
                } else {
                    return res.status(500).send({ success: false, message: helper.strings.AnErrorHappened });
                }
            });
    },
}