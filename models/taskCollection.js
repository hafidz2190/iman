function collectionDefinition()
{
    var _dbManager = requireLocal('helpers/dbManager');
    var _model = requireLocal('models/taskModel');

    var _collection = _dbManager.Collection.extend({
        model: _model
    });

    return _collection;
}

module.exports = collectionDefinition();