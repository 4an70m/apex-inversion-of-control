/**
 * <p><b>HandlerExecutor</b></p>
 * Singleton class, designed to execute metadata-wired handlers.
 *
 * @author Oleksii.Fisher
 * @version 1.0
 */
public with sharing class HandlerExecutionPool {

    private static HandlerExecutionPool instance;
    private final Map<Type, HandlerExecutor> handlerPool;

    private HandlerExecutionPool() {
        this.handlerPool = new Map<Type, HandlerExecutor>();
    }

    /**
     * <p><b>getInstance()</b></p>
     * Static method to get instance of HandlerExecutionPool class
     *
     * @return Singleton instance of HandlerExecutionPool
     * @see HandlerExecutionPool
     */
    public static HandlerExecutionPool getInstance() {
        if (HandlerExecutionPool.instance == null) {
            HandlerExecutionPool.instance = new HandlerExecutionPool();
        }
        return HandlerExecutionPool.instance;
    }

    /**
     * <p><b>getHandler(System.Type)</b></p>
     * Tries to retrieve an instance for HandlerExecutor class from the pool.
     * If there's no instance - creates a new one and puts it in the map
     *
     * @param typeName System.Type, name of the SObject. <p>e.g. Account.class</p>
     * @return Singleton HandlerExecutor for specific System.Type
     * @see HandlerExecutor
     * @see handlerPool
     */
    public HandlerExecutor getHandler(Type typeName) {
        HandlerExecutor executor = this.handlerPool.get(typeName);
        if (executor == null) {
            executor = new HandlerExecutor(typeName);
            this.handlerPool.put(typeName, executor);
        }
        return executor;
    }

    /**
     * <p><b>HandlerExecutor</b></p>
     * Instantiates all the type-related Handlers and allows to execute them.
     * Also performs a type-check and displays a debug log with error message
     * if the instance of Handler is invalid.
     *
     * @see Handler
     * @author Oleksii.Fisher
     * @version 1.0
     */
    public class HandlerExecutor {
        
        private Type typeName;
        private final List<Handler> activeHandlers;

        private HandlerExecutor(Type typeName) {
            this.typeName = typeName;
            this.activeHandlers = this.getActiveHandlers();
        }

        /**
         * <p>execute()</p>
         * Iterates through the list of active Handlers,
         * retrieved from the metadata and <b>sequentially</b> executes them.
         *
         * @see Trigger_Dependency__mdt
         */
        public void execute() {
            for(Handler handler : this.activeHandlers) {
                this.executeHandler(handler);
            }
        }

        /**
         * <p><b>getActiveHandlers</b></p>
         * Using HandlerMetadata class retrieves active handlers from the metadata,
         * instantiates them, validates them and returns a list of active Handler instances.
         * <p><p>If a handler class name retrieved from the metadata is invalid,
         * the logic will simply skip this handler, but will add a System.debug() log
         * with the name of faulty handler</p></p>
         *
         * @return List of instances of active Handlers
         * @see Handler
         * @see HandlerMetadata
         */
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

        /**
         * <p><b>executeHandler(Handler)</b></p>
         * Determines the trigger operation type and calls according method
         * from the Handler class.
         *
         * @param handler A handler being executed
         * @see Handler
         */
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

        /**
         * <p><b>logNoApplicableClassError(Trigger_Dependency__mdt)</b></p>
         * Displays an error message with System.debug() if the name of handler,
         * retrieved from metadata was faulty.
         *
         * @param handlerMeta Instance of custom metadata Trigger_Dependency__mdt
         * @see Trigger_Dependency__mdt
         */
        private void logNoApplicableClassError(Trigger_Dependency__mdt handlerMeta) {
            System.debug('\n\nHandlerExecutionPool: creating handler "'
                    + (String.isEmpty(handlerMeta.NamespacePrefix) ? '' : handlerMeta.NamespacePrefix) + handlerMeta.Class_Name__c
                    + '" encountered an error:\n' +
                    'No applicable class was found. Probably the class was removed or renamed.\n');
        }
    }

    /**
     * <p><b>HandlerMetadata</b></p>
     * Class reads the metadata from the Database and
     * populates it in an array.
     * <p>The metadata is filtered by <b>Object_Name__c<b/> field,
     * <b>Is_Active__c<b/> field and is ordered by <b>Execution_Order__c<b/> field.
     *
     * @see Trigger_Dependency__mdt
     * @author Oleksii.Fisher
     * @version 1.0
     */
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