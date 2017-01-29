var dateFormat = require('dateFormat');
var dbManager = require('../helpers/dbManager');
var modelMap = require('../models/index');

function managerDefinitions() 
{
    function fetch(modelName, filterMap, transactionScope)
    {
        return new modelMap[modelName](filterMap).fetch({transacting: transactionScope});
    }

    function fetchAll(modelName, sortDescriptions, pageSize, page, transactionScope)
    {
        return new modelMap[modelName]()
            .query(orderingHandler)
            .query(paginationHandler)
            .fetchAll({transacting: transactionScope});
        
        function orderingHandler(qb)
        {
            if(!sortDescriptions)
                return;
            
            for(var i = 0, ii = sortDescriptions.length; i < ii; i++)
                qb.orderBy(sortDescriptions[i].field, sortDescriptions[i].direction);
        }

        function paginationHandler(qb)
        {
            if(!pageSize)
                return;

            if(pageSize)
                qb.limit(pageSize);

            if(page)
                qb.offset(page < 2 ? 0 : pageSize * page - pageSize );
        }
    }

    function fetchWithRelated(modelName, relatedTableNames, filterMap, sortDescriptions, pageSize, page, transactionScope)
    {
        return new modelMap[modelName]()
            .query(filterMap)
            .query(orderingHandler)
            .query(paginationHandler)
            .fetch({withRelated: relatedTableNames, transacting: transactionScope});

        function orderingHandler(qb)
        {
            if(!sortDescriptions)
                return;
            
            for(var i = 0, ii = sortDescriptions.length; i < ii; i++)
                qb.orderBy(sortDescriptions[i].field, sortDescriptions[i].direction);
        }

        function paginationHandler(qb)
        {
            if(!pageSize)
                return;

            if(pageSize)
                qb.limit(pageSize);

            if(page)
                qb.offset(page < 2 ? 0 : pageSize * page - pageSize );
        }
    }

    function save(modelName, forger, transactionScope)
    {
        return new modelMap[modelName](forger).save(null, {transacting: transactionScope});
    }

    function processTransaction(transaction)
    {
        return dbManager.transaction(transaction);
    }

    function validateProperties(entityName, databaseProperties, requestPropertyMap)
    {
        var databasePropertyMap = {};

        for(var i = 0, ii = databaseProperties.length; i < ii; i++)
        {
            var property = databaseProperties[i];
            var name = property.name;
            databasePropertyMap[name] = true;
        }

        for(var propertyName in requestPropertyMap)
            if(!(propertyName in databasePropertyMap))
                throw new Error('Illegal property ' + propertyName + ' in entity ' + entityName);
    }

    function getDateTimeNow()
    {
        return dateFormat(new Date(), 'yyyy-mm-dd H:MM:ss');
    }

    return {
        fetch: fetch,
        fetchAll: fetchAll,
        fetchWithRelated: fetchWithRelated,
        processTransaction: processTransaction,
        save: save,
        validateProperties: validateProperties,
        getDateTimeNow: getDateTimeNow
    };
}

module.exports = managerDefinitions();