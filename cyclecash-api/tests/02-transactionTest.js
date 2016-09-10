/**
 * Created by joelwasserman on 9/9/16.
 */
'use strict'

var request = require('supertest');
var should = require('should');
var server = require('../app.js');


describe('Transactions', function () {

    before((done) => {
        done();
    });

    const vendor1 = 'car_shop',
        points_spent1 = 10,
        password1 = 'test',
        email1 = 'joel@test.com';


    it('should create user', function (done) {

        var reqBody = {
            email: email1,
            password: password1
        };

        request(server)
            .post('/api/v1/users/')
            .expect('Content-Type', /json/)
            .send(reqBody)
            .end(function (err, res) {
                res.status.should.equal(200);
                var json = JSON.parse(res.text);
                json.success.should.equal(true);
                done();
            });

    });

    it('should create transaction', function (done) {

        var reqBody = {
            vendor: vendor1,
            points_spent: points_spent1,
            user_email: email1
        };

        request(server)
            .post('/api/v1/transaction/')
            .expect('Content-Type', /json/)
            .send(reqBody)
            .end(function (err, res) {
                res.status.should.equal(200);
                var json = JSON.parse(res.text);
                json.success.should.equal(true);
                json.transaction.points_spent.should.equal(10);
                done();
            });

    });

    it('should get all transactions', function (done) {

        request(server)
            .get('/api/v1/transaction/')
            .expect('Content-Type', /json/)
            .end(function (err, res) {
                res.status.should.equal(200);
                var json = JSON.parse(res.text);
                json.success.should.equal(true);
                json.transaction.length.should.equal(1);
                json.transaction[0].points_spent.should.equal(10);
                done();
            });

    });

    it('should delete transaction', function (done) {

        var reqBody = {
            vendor: vendor1,
            points_spent: points_spent1,
            user_email: email1,
        };

        request(server)
            .delete('/api/v1/transaction/')
            .expect('Content-Type', /json/)
            .send(reqBody)
            .end(function (err, res) {
                res.status.should.equal(200);
                var json = JSON.parse(res.text);
                json.success.should.equal(true);
                done();
            });

    });

    it('should delete user', function (done) {

        var reqBody = {
            email: email1,
            password: password1
        };

        request(server)
            .delete('/api/v1/users/')
            .expect('Content-Type', /json/)
            .send(reqBody)
            .end(function (err, res) {
                res.status.should.equal(200);
                var json = JSON.parse(res.text);
                json.success.should.equal(true);
                done();
            });

    });

});
