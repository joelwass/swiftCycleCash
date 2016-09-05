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


    createUser: function (req, res) {

        var params = _.pick(req.body, 'email', 'password'),
            user;

        models.User.findOrCreate({ where: { email: req.body.email }, defaults: params })
            .then(function (result) {
                var created = result[1];
                if (created) {
                    user = result[0];
                    return models.User.createAndSaveRefreshToken(user.id, models);
                } else {
                    throw new MyError(helper.strings.EmailAlreadyExists);
                }
            })
            .then(function (refreshToken) {
                const json = { success: true,
                    refreshToken: refreshToken.token,
                    user: user.toJSON(),
                    message: helper.strings.UserCreationSuccess, };
                return res.header('Auth', models.User.createAccessToken(user.id)).json(json);
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
     *   UpdateUser:
     *     properties:
     *       timeOffset:
     *         type: integer
     *       gender:
     *         type: string
     *       firstName:
     *         type: string
     */

    /**
     * @swagger
     * /api/v1/users:
     *   put:
     *     tags:
     *       - Users
     *     description: Updates a user.
     *       <table>
     *       <tr>
     *       <td>db</td>
     *       <td>sql check</td>
     *       <tr>
     *       <td>mysql</td>
     *       <td>select * from "Users" where email = "email"</td>
     *       </tr>
     *       </table>
     *     consumes:
     *       - application/json
     *     produces:
     *       - application/json
     *     parameters:
     *     - name: Auth
     *       in: header
     *       description: jwt
     *       required: true
     *       type: string
     *       format: string
     *     - name: user
     *       description: Input parameters needed for updating a user
     *       in: body
     *       required: true
     *       schema:
     *         $ref: '#/definitions/UpdateUser'
     *     responses:
     *       200:
     *         description: Updates a user
     */

    updateUser: function (req, res) {

        var user = req.user;
        if (user == null) {
            return res.status(400).json({ success: false, message: helper.strings.UserUpdateError });
        }

        req.user.save()
            .then(function (result) {
                return res.status(200).json({ success: true, user: user.toJSON() });
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
     *   SignInUser:
     *     properties:
     *       email:
     *         type: string
     *       password:
     *         type: string
     */

    /**
     * @swagger
     * /api/v1/users/login:
     *   post:
     *     tags:
     *       - Users
     *     description: Signs a user in.
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
     *         description: Signs in a user
     */
    
    loginUser: function (req, res) {
        var user;
        var refreshToken;
        var body = _.pick(req.body, 'email', 'password');

        if (_.keys(body).length != 2) {
            return res.status(400).json({ success: false, message: helper.strings.InvalidParameters });
        }

        models.User.authenticate(body)
            .then(function (localUser) {
                user = localUser;
                return models.User.createAndSaveRefreshToken(user.id, models);
            })
            .then(function (localRefreshToken) {
                refreshToken = localRefreshToken;
                const accessToken = models.User.createAccessToken(user.id);

                return res.header('Auth', accessToken)
                    .json({ success: true,
                        user: user.toJSON(),
                        refreshToken: refreshToken.token,
                        message: helper.strings.LoginSuccess, });
            })
            .catch(function (err) {
                if (err.name && err.name === 'MyError') {
                    return res.status(400).json({ success: false, message: err.message });
                } else {
                    helper.logging.logError(err, req);
                    return res.status(500).send({ success: false, message: helper.strings.AnErrorHappened });
                }
            });
    },
}