/**
 * Created by joelwasserman on 8/29/16.
 */

var MyError = function (message) {
    this.name = 'MyError';
    this.message = message || 'Default Message';
    this.stack = (new Error()).stack;
};

MyError.prototype = Object.create(Error.prototype);
MyError.prototype.constructor = MyError;

module.exports = MyError;