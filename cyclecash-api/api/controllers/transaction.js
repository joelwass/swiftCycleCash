/**
 * Created by joelwasserman on 9/5/16.
 */


const _ = require('lodash');
const models  = require('../models');
const helper = require('../helpers');

module.exports = {


    createTransaction: function (req, res) {

        var params = _.pick(req.body, 'email', 'password'),
            user;

        models.User.findOrCreate({ where: { email: req.body.email }, defaults: params })
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

    getAllTransactions: function (req, res) {

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
}