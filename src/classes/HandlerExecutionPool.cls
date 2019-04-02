public with sharing class HandlerExecutionPool {

    private static HandlerExecutionPool instance;

    private final Map<Type, HandlerExecutor> handlerPool;

    private HandlerExecutionPool() {
        this.handlerPool = new Map<Type, HandlerExecutor>();
    }

    public static HandlerExecutionPool getInstance() {
        if (HandlerExecutionPool.instance == null) {
            HandlerExecutionPool.instance = new HandlerExecutionPool();
        }
        return HandlerExecutionPool.instance;
    }

    public HandlerExecutor getHandler(Type typeName) {
        HandlerExecutor executor = this.handlerPool.get(typeName);
        if (executor == null) {
            executor = new HandlerExecutor(typeName);
            this.handlerPool.put(typeName, executor);
        }
        return executor;
    }

    public class HandlerExecutor {
        
        private Type typeName;
        private final List<Handler> activeHandlers;

        private HandlerExecutor(Type typeName) {
            this.typeName = typeName;
            this.activeHandlers = this.getActiveHandlers();
        }

        public void execute() {
            for(Handler handler : this.activeHandlers) {
                this.executeHandler(handler);
            }
        }
        
        private List<Handler> getActiveHandlers() {
            HandlerMetadata handlerMetadata = new HandlerMetadata(this.typeName);
            List<Handler> handlers = new List<Handler>();
            for (Trigger_Dependency__mdt handlerMeta : handlerMetadata.getMeta()) {
                Type handlerType = Type.forName(handlerMeta.NamespacePrefix, handlerMeta.Class_Name__c);
                if (handlerType == null) {
                    this.logNoApplicableClassError(handlerMeta);
                    continue;
                }
                Handler handler = (Handler) handlerType.newInstance();
                handler.setSobjectType(this.typeName);
                handlers.add(handler);
            }
            return handlers;
        }

        private void executeHandler(Handler handler) {
            switch on Trigger.operationType {
                when BEFORE_INSERT {
                    handler.beforeInsert();
                }
                when BEFORE_UPDATE {
                    handler.beforeUpdate();
                }
                when BEFORE_DELETE {
                    handler.beforeDelete();
                }
                when AFTER_INSERT {
                    handler.afterInsert();
                }
                when AFTER_UPDATE {
                    handler.afterUpdate();
                }
                when AFTER_DELETE {
                    handler.afterDelete();
                }
                when AFTER_UNDELETE {
                    handler.afterUnDelete();
                }
            }
        }

        private void logNoApplicableClassError(Trigger_Dependency__mdt handlerMeta) {
            System.debug('\n\nHandlerExecutionPool: creating handler "'
                    + (String.isEmpty(handlerMeta.NamespacePrefix) ? '' : handlerMeta.NamespacePrefix) + handlerMeta.Class_Name__c
                    + '" encountered an error:\n' +
                    'No applicable class was found. Probably the class was removed or renamed.\n');
        }
    }

    private class HandlerMetadata {

        private List<Trigger_Dependency__mdt> handlersMeta;

        public HandlerMetadata(Type typeName) {
            this.handlersMeta = this.readHandlersMetadata(typeName);
        }

        public List<Trigger_Dependency__mdt> getMeta() {
            return this.handlersMeta;
        }

        private List<Trigger_Dependency__mdt> readHandlersMetadata(Type typeName) {
            return [
                    SELECT Id
                        , Class_Name__c
                        , Object_Name__c
                        , NamespacePrefix
                    FROM Trigger_Dependency__mdt
                    WHERE Is_Active__c = true
                        AND Object_Name__c = :typeName.toString()
                    ORDER BY Execution_Order__c ASC
            ];
        }
    }
}