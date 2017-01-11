var businessManagerMap = require('../business/index');

var methodMap = {
    '/getDropdownCollectionByProperty' : businessManagerMap.entityManager.getDropdownCollectionByProperty,
    '/getEntityCollection' : businessManagerMap.entityManager.getEntityCollection,
    '/getPropertyCollectionByEntity' : businessManagerMap.entityManager.getPropertyCollectionByEntity,
    '/getWorkflowStatusCollectionByProperty' : businessManagerMap.entityManager.getWorkflowStatusCollectionByProperty,

    '/getHistoryCollectionByPropertyAndUser' : businessManagerMap.historyManager.getHistoryCollectionByPropertyAndUser,

    '/getEwalletCollectionByUser' : businessManagerMap.transactionManager.getEwalletCollectionByUser,
    '/getGhTransactionCollectionByUser' : businessManagerMap.transactionManager.getGhTransactionCollectionByUser,
    '/getPhTransactionCollectionByUser' : businessManagerMap.transactionManager.getPhTransactionCollectionByUser,
    '/getTaskCollectionByUser' : businessManagerMap.transactionManager.getTaskCollectionByUser,

    '/getCredential' : businessManagerMap.userManager.getCredential,
    '/getUser' : businessManagerMap.userManager.getUser,
    '/getUserSession' : businessManagerMap.userManager.getUserSession
};

function managerDefinitions() 
{
    function requestHandler(req, res)
    {
        methodMap[req.url](req.body).then(callback);

        function callback(result)
        {
            res.send(result);
        }
    }
    
    return {
        requestHandler: requestHandler
    };
}

module.exports = managerDefinitions();