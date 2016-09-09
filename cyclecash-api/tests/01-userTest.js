/**
 * Created by joelwasserman on 9/8/16.
 */
'use strict'

var request = require('supertest');
var should = require('should');
var _ = require('lodash');
var server = require('../app.js');


describe('Users', function () {

    before((done) => {
        done();
    });

    const email1 = 'joel@test.com';
    let password1 = 'test';

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

    it('should not create (dup email)', function (done) {

        var reqBody = {
            email: email1,
            password: password1
        };

        request(server)
            .post('/api/v1/users/')
            .expect('Content-Type', /json/)
            .send(reqBody)
            .end(function (err, res) {
                res.status.should.equal(400);
                var json = JSON.parse(res.text);
                json.success.should.equal(false);
                json.message.should.equal('Email already exists. Try logging in');
                done();
            });

    });

    it('should update user', function (done) {

        var reqBody = {
            email: email1,
            password: password1,
            pedal_points: 25,
        };

        request(server)
            .put('/api/v1/users/')
            .expect('Content-Type', /json/)
            .send(reqBody)
            .end(function (err, res) {
                res.status.should.equal(200);
                var json = JSON.parse(res.text);
                json.success.should.equal(true);
                json.user.pedal_points.should.equal(25);
                done();
            });

    });

    it('should login', function (done) {

        var reqBody = {
            email: email1,
            password: password1
        };

        request(server)
            .post('/api/v1/users/login/')
            .expect('Content-Type', /json/)
            .send(reqBody)
            .end(function (err, res) {
                res.status.should.equal(200);
                var json = JSON.parse(res.text);
                json.success.should.equal(true);
                done();
            });

    });

    it('should not login (invalid pwd)', function (done) {

        done();
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
