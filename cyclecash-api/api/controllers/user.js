/**
 * Created by joelwasserman on 9/5/16.
 */

const _ = require('lodash');
const models  = require('../models');
const helper = require('../helpers');
const MyError = helper.error;

module.exports = {

    /**
     * @swagger
     * definition:
     *   UserBody:
     *     properties:
     *       email:
     *         type: string
     *         required: true
     *       password:
     *         type: string
     *         required: true
     *     required:
     *       - email
     *       - password
     */

    /**
     * @swagger
     * definition:
     *   User:
     *     properties:
     *       email:
     *         type: string
     *       password:
     *         type: string
     *       pedal_points:
     *         type: integer
     *       distance_traveled:
     *         type: double
     *       time_traveled:
     *         type: integer
     */

    /**
     * @swagger
     * definition:
     *   User200Response:
     *     properties:
     *       success:
     *         type: boolean
     *       user:
     *         $ref: '#/definitions/User'
     *       message:
     *         type: string
     */

    /**
     * @swagger
     * /api/v1/user:
     *   post:
     *     tags:
     *       - User
     *     description: Creates a user.
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
     *         $ref: '#/definitions/UserBody'
     *     responses:
     *       200:
     *         description: Creates a user
     *         schema:
     *           $ref: '#/definitions/User200Response
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

    createUser: function (req, res) {

        var params = _.pick(req.body, 'email', 'password'),
            user;
        params.pedal_points = 25;
        params.distance_traveled = 0.0;
        params.time_traveled = 0;

        // parameter validation
        if (_.keys(params).length != 2
        || (typeof params.email != "string")
        || (typeof params.password != "string")
        ) {
            return res.status(400).json({ success: false, message: helper.strings.InvalidParameters });
        }

        models.User.findOrCreate({ where: { email: params.email }, defaults: params })
            .then(function (result) {
                var created = result[1];
                if (created) {
                    user = result[0];
                    return user;
                } else {
                    throw new MyError(helper.strings.EmailAlreadyExists);
                }
            })
            .then(function (localUser) {

                const json = { success: true,
                    user: user.toJSON(),
                    message: helper.strings.UserCreationSuccess,
                };
                return res.json(json);
            })
            .catch(function (err) {
                if (err.name && err.name === 'MyError') {
                    return res.status(400).json({ success: false, message: err.message });
                }

                if (err.errors) {
                    if (err.errors.length > 0 && err.errors[0].message === 'email must be unique') {
                        return res.status(400).json({
                            success: false,
                            message: helper.strings.EmailAlreadyExists, });
                    } else if (err.errors.length > 0 && err.errors[0].message === 'Validation isEmail failed') {
                        return res.status(400).json({ success: false, message: helper.strings.EnterValidEmail });
                    } else if (err.errors.length > 0 && err.errors[0].message === 'Validation len failed') {
                        return res.status(400).json({ success: false, message: helper.strings.PasswordInvalid });
                    }
                }

                return res.status(500).json({ success: false, message: helper.strings.AnErrorHappened });
            });
    },

    /**
     * @swagger
     * definition:
     *   UserUpdate200Response:
     *     properties:
     *       success:
     *         type: boolean
     *       user:
     *         $ref: '#/definitions/User'
     */

    /**
     * @swagger
     * /api/v1/user:
     *   put:
     *     tags:
     *       - User
     *     description: Updates a user.
     *     consumes:
     *       - application/json
     *     produces:
     *       - application/json
     *     parameters:
     *     - name: user
     *       description: Input parameters needed for updating a user given an user email
     *       in: body
     *       required: true
     *       schema:
     *         properties:
     *           email:
     *             type: string
     *             required: true
     *         required:
     *           - email
     *     responses:
     *       200:
     *         description: Updates a user
     *         schema:
     *           $ref: '#/definitions/UserUpdate200Response
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

    updateUser: function (req, res) {

        var body = req.body;

        // parameter validation
        if (_.keys(body).length != 1
            || (typeof params.email != "string")
        ) {
            return res.status(400).json({ success: false, message: helper.strings.InvalidParameters });
        }

        models.User.findOne({ where: { email: body.email } })
            .then(function (localUser) {
                return localUser.update(body);
            })
            .then(function (result) {
                return res.status(200).json({ success: true, user: result.toJSON() });
            })
            .catch(function (err) {
                if (err.name && err.name === 'MyError') {
                    return res.status(400).json({ success: false, message: err.message });
                }

                if (err.errors) {
                    if (err.errors.length > 0 && err.errors[0].message === 'email must be unique') {
                        return res.status(400).json({
                            success: false,
                            message: helper.strings.EmailAlreadyExists, });
                    } else if (err.errors.length > 0 && err.errors[0].message === 'Validation isEmail failed') {
                        return res.status(400).json({ success: false, message: helper.strings.EnterValidEmail });
                    } else if (err.errors.length > 0 && err.errors[0].message === 'Validation len failed') {
                        return res.status(400).json({ success: false, message: helper.strings.PasswordInvalid });
                    }
                }

                return res.status(500).json({ success: false, message: helper.strings.AnErrorHappened });
            });
    },

    /**
     * @swagger
     * /api/v1/user/login:
     *   post:
     *     tags:
     *       - Login
     *     description: Logs in a user.
     *     consumes:
     *       - application/json
     *     produces:
     *       - application/json
     *     parameters:
     *     - name: User
     *       description: Input parameters needed for logging in a user
     *       in: body
     *       required: true
     *       schema:
     *         properties:
     *           email:
     *             type: string
     *             required: true
     *           password:
     *             type: string
     *             required: true
     *         required:
     *           - email
     *           - password
     *     responses:
     *       200:
     *         description: Logs in and returns a user
     *         schema:
     *           $ref: '#/definitions/User200Response
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

    loginUser: function (req, res) {
        var body = _.pick(req.body, 'email', 'password');

        // parameter validation
        if (_.keys(body).length != 2
        || (typeof body.email != "string")
        || (typeof body.password != "string")
        ) {
            return res.status(400).json({ success: false, message: helper.strings.InvalidParameters });
        }

        models.User.authenticate(body)
            .then(function (localUser) {

                return res.status(200).json({ success: true,
                        user: localUser.toJSON(),
                        message: helper.strings.LoginSuccess, });
            })
            .catch(function (err) {
                if (err.name && err.name === 'MyError') {
                    return res.status(400).json({ success: false, message: err.message });
                } else {
                    return res.status(500).send({ success: false, message: helper.strings.AnErrorHappened });
                }
            });
    },

    /**
     * @swagger
     * /api/v1/user:
     *   delete:
     *     tags:
     *       - User
     *     description: Deletes a user.
     *     consumes:
     *       - application/json
     *     produces:
     *       - application/json
     *     parameters:
     *     - name: user
     *       description: Input parameters needed for deleting a user
     *       in: body
     *       required: true
     *       schema:
     *         properties:
     *           email:
     *             type: string
     *             required: true
     *           password:
     *             type: string
     *             required: true
     *         required:
     *           - email
     *           - password
     *     responses:
     *       200:
     *         description: Deletes a user
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

    deleteUser: function (req, res) {
        var body = _.pick(req.body, 'email', 'password');

        if (_.keys(body).length != 2) {
            return res.status(400).json({ success: false, message: helper.strings.InvalidParameters });
        }

        models.User.findOne({ where: { email: body.email } })
            .then(function (user) {

                user.destroy();
                return res.json({ success: true });
            })
            .catch(function (err) {
                if (err.name && err.name === 'MyError') {
                    return res.status(400).json({ success: false, message: err.message });
                } else {
                    return res.status(500).send({ success: false, message: helper.strings.AnErrorHappened });
                }
            });
    },
}