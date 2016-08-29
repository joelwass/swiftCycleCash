/**
 * Created by joelwasserman on 8/29/16.
 */

var dbOpts = {
    host:     process.env.dbHost, // this is in the eb configuration settings
    database: process.env.dbRdsName, // this is in the eb configuration settings
    user     : process.env.dbRdsUser, // this is in the eb configuration settings
    password : process.env.dbRdsPassword, // this is in the eb configuration settings
    protocol: 'mysql',
    port:     '3306',
    query:    {pool: true},
    ssl:      "Amazon RDS"
};

module.exports = dbOpts;