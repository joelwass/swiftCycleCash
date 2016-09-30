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
     *   TransactionBody:
     *     properties:
     *       user_email:
     *         type: string
     *         required: true
     *       points_spent:
     *         type: integer
     *         required: true
     *       vendor:
     *         type: string
     *         required: true
     *     required:
     *       - user_email
     *       - points_spent
     *       - vendor
     */

    /**
     * @swagger
     * definition:
     *   Transaction:
     *     properties:
     *       user_email:
     *         type: string
     *       points_spent:
     *         type: integer
     *       vendor:
     *         type: string
     */

    /**
     * @swagger
     * definition:
     *   Transaction200Response:
     *     properties:
     *       success:
     *         type: boolean
     *       transaction:
     *         $ref: '#/definitions/Transaction'
     *       message:
     *         type: string
     */

    /**
     * @swagger
     * definition:
     *   ErrorResponse:
     *     properties:
     *       success:
     *         type: boolean
     *       message:
     *         type: string
     */

    /**
     * @swagger
     * /api/v1/transaction:
     *   post:
     *     tags:
     *       - Transaction
     *     description: Creates a transaction.
     *     consumes:
     *       - application/json
     *     produces:
     *       - application/json
     *     parameters:
     *     - name: transaction
     *       description: Input parameters needed for creating a transaction
     *       in: body
     *       required: true
     *       schema:
     *         $ref: '#/definitions/TransactionBody'
     *     responses:
     *       200:
     *         description: Creates a transaction
     *         schema:
     *           $ref: '#/definitions/Transaction200Response'
     *       400:
     *         description: Something we're aware of went wrong, description of what went
     *           wrong should be returned in the message of the body returned
     *         schema:
     *           $ref: '#/definitions/ErrorResponse'
     *       500:
     *         description: Something went wrong with our server or that we aren't aware of
     *           or anticipating.
     *         schema:
     *           $ref: '#/definitions/ErrorResponse'
     */

    createTransaction: function (req, res) {

        var body = _.pick(req.body, 'user_email', 'points_spent', 'vendor');

        // parameter validation
        if (_.keys(body).length != 3
        || (typeof req.body.user_email != "string")
        || (typeof req.body.points_spent != "number")
        || (typeof req.body.vendor != "string")
        ) {
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
     *   TransactionGetAll200Response:
     *     properties:
     *       success:
     *         type: boolean
     *       transaction:
     *         type: array
     *         items:
     *           $ref: '#/definitions/Transaction'
     */

    /**
     * @swagger
     * /api/v1/transaction:
     *   get:
     *     tags:
     *       - Transaction
     *     description: Gets all a transactions.
     *     consumes:
     *       - application/json
     *     produces:
     *       - application/json
     *     parameters:
     *     - name: transaction
     *       description: Should have an empty body, no params, nothing.
     *       in: body
     *     responses:
     *       200:
     *         description: Gets all transactions
     *         schema:
     *           $ref: '#/definitions/TransactionGetAll200Response'
     *       400:
     *         description: Something we're aware of went wrong, description of what went
     *           wrong should be returned in the message of the body returned
     *         schema:
     *           $ref: '#/definitions/ErrorResponse'
     *       500:
     *         description: Something went wrong with our server or that we aren't aware of
     *           or anticipating.
     *         schema:
     *           $ref: '#/definitions/ErrorResponse'
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
     * /api/v1/transaction:
     *   delete:
     *     tags:
     *       - Transaction
     *     description: Deletes transactions.
     *     consumes:
     *       - application/json
     *     produces:
     *       - application/json
     *     parameters:
     *     - name: transaction
     *       description: Should have all valid params to pass to deleting a transaction.
     *       in: body
     *       required: true
     *       schema:
     *         properties:
     *           user_email:
     *             type: string
     *             required: true
     *           points_spent:
     *             type: integer
     *             required: true
     *           vendor:
     *             type: string
     *             required: true
     *         required:
     *           - user_email
     *           - points_spent
     *           - vendor
     *     responses:
     *       200:
     *         description: Gets all transactions
     *         schema:
     *           properties:
     *             success:
     *               type: boolean
     *       400:
     *         description: Something we're aware of went wrong, description of what went
     *           wrong should be returned in the message of the body returned
     *         schema:
     *           $ref: '#/definitions/ErrorResponse'
     *       500:
     *         description: Something went wrong with our server or that we aren't aware of
     *           or anticipating.
     *         schema:
     *           $ref: '#/definitions/ErrorResponse'
     */

    deleteTransaction: function (req, res) {

        var body = _.pick(req.body, 'user_email', 'points_spent', 'vendor');

        // parameter validation
        if (_.keys(body).length != 3
        || (typeof req.body.user_email != "string")
        || (typeof req.body.points_spent != "number")
        || (typeof req.body.vendor != "string")
        ) {
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