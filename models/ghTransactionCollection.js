var dbManager = require('../helpers/dbManager');
var model = require('./ghTransactionModel');

var collection = dbManager.Collection.extend({
    model: model
});

module.exports = collection;