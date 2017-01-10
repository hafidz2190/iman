var dbManager = require('../helpers/dbManager');

var model = dbManager.Model.extend({
    tableName: 'dropdown',
    property: propertyRelatedModelHandler
});

function propertyRelatedModelHandler()
{
    return this.belongsTo('property', 'property_id');
}

module.exports = dbManager.model('dropdown', model);