/**
 * <p><b>Handler</b></p>
 * Smallest part of Trigger-handling process.
 * Handles base events from trigger.
 * Designed to handle a business process.
 *
 * @author Oleksii.Fisher
 * @version 1.0
 */
public abstract with sharing class Handler {

    protected Type typeName;

    public Handler() {
    }

    /**
     * <p><b>onBeforeInsert(TriggerContext)</b></p>
     * Handles before insert event from trigger.
     * Have to be overridden to perform some business logic.
     *
     * @param context
     * @see TriggerContext
     */
    protected virtual void onBeforeInsert(TriggerContext context) {
    }

    /**
     * <p><b>onBeforeUpdate(TriggerContext)</b></p>
     * Handles beforeUpdate insert event from trigger
     * Have to be overridden to perform some business logic.
     *
     * @param context
     * @see TriggerContext
     */
    protected virtual void onBeforeUpdate(TriggerContext context) {
    }

    /**
     * <p><b>onBeforeDelete(TriggerContext)</b></p>
     * Handles before delete event from trigger
     * Have to be overridden to perform some business logic.
     *
     * @param context
     * @see TriggerContext
     */
    protected virtual void onBeforeDelete(TriggerContext context) {
    }

    /**
    * <p><b>onAfterInsert(TriggerContext)</b></p>
    * Handles after insert event from trigger
    * Have to be overridden to perform some business logic.
    *
    * @param context
    * @see TriggerContext
    */
    protected virtual void onAfterInsert(TriggerContext context) {
    }

    /**
    * <p><b>onAfterUpdate(TriggerContext)</b></p>
    * Handles after update event from trigger
    * Have to be overridden to perform some business logic.
    *
    * @param context
    * @see TriggerContext
    */
    protected virtual void onAfterUpdate(TriggerContext context) {
    }

    /**
    * <p><b>onAfterDelete(TriggerContext)</b></p>
    * Handles after delete event from trigger
    * Have to be overridden to perform some business logic.
    *
    * @param context
    * @see TriggerContext
    */
    protected virtual void onAfterDelete(TriggerContext context) {
    }

    /**
    * <p><b>onAfterUnDelete(TriggerContext)</b></p>
    * Handles after undelete event from trigger
    * Have to be overridden to perform some business logic.
    *
    * @param context
    * @see TriggerContext
    */
    protected virtual void onAfterUnDelete(TriggerContext context) {
    }

    /**
    * <p><b>beforeInsert()</b></p>
    * Creates an instance of TriggerContext, executes overridden event-related method
    * and logBeforeEventHandling(), logAfterEventHandling() methods.
    * Is executed directly by HandlerExecutor. Cannot be overridden.
    *
    * @see HandlerExecutionPool.HandlerExecutor
    */
    public void beforeInsert() {
        TriggerContext context = new TriggerContext();
        this.logBeforeEventHandling(context);
        this.onBeforeInsert(context);
        this.logAfterEventHandling(context);
    }

    /**
    * <p><b>beforeUpdate()</b></p>
    * Creates an instance of TriggerContext, executes overridden event-related method
    * and logBeforeEventHandling(), logAfterEventHandling() methods.
    * Is executed directly by HandlerExecutor. Cannot be overridden.
    *
    * @see HandlerExecutionPool.HandlerExecutor
    */
    public void beforeUpdate() {
        TriggerContext context = new TriggerContext();
        this.logBeforeEventHandling(context);
        this.onBeforeUpdate(context);
        this.logAfterEventHandling(context);
    }

    /**
    * <p><b>beforeDelete()</b></p>
    * Creates an instance of TriggerContext, executes overridden event-related method
    * and logBeforeEventHandling(), logAfterEventHandling() methods.
    * Is executed directly by HandlerExecutor. Cannot be overridden.
    *
    * @see HandlerExecutionPool.HandlerExecutor
    */
    public void beforeDelete() {
        TriggerContext context = new TriggerContext();
        this.logBeforeEventHandling(context);
        this.onBeforeDelete(context);
        this.logAfterEventHandling(context);
    }

    /**
    * <p><b>afterInsert()</b></p>
    * Creates an instance of TriggerContext, executes overridden event-related method
    * and logBeforeEventHandling(), logAfterEventHandling() methods.
    * Is executed directly by HandlerExecutor. Cannot be overridden.
    *
    * @see HandlerExecutionPool.HandlerExecutor
    */
    public void afterInsert() {
        TriggerContext context = new TriggerContext();
        this.logBeforeEventHandling(context);
        this.onAfterInsert(context);
        this.logAfterEventHandling(context);
    }

    /**
    * <p><b>afterUpdate()</b></p>
    * Creates an instance of TriggerContext, executes overridden event-related method
    * and logBeforeEventHandling(), logAfterEventHandling() methods.
    * Is executed directly by HandlerExecutor. Cannot be overridden.
    *
    * @see HandlerExecutionPool.HandlerExecutor
    */
    public void afterUpdate() {
        TriggerContext context = new TriggerContext();
        this.logBeforeEventHandling(context);
        this.onAfterUpdate(context);
        this.logAfterEventHandling(context);
    }

    /**
    * <p><b>afterDelete()</b></p>
    * Creates an instance of TriggerContext, executes overridden event-related method
    * and logBeforeEventHandling(), logAfterEventHandling() methods.
    * Is executed directly by HandlerExecutor. Cannot be overridden.
    *
    * @see HandlerExecutionPool.HandlerExecutor
    */
    public void afterDelete() {
        TriggerContext context = new TriggerContext();
        this.logBeforeEventHandling(context);
        this.onAfterDelete(context);
        this.logAfterEventHandling(context);
    }

    /**
    * <p><b>afterUnDelete()</b></p>
    * Creates an instance of TriggerContext, executes overridden event-related method
    * and logBeforeEventHandling(), logAfterEventHandling() methods.
    * Is executed directly by HandlerExecutor. Cannot be overridden.
    *
    * @see HandlerExecutionPool.HandlerExecutor
    */
    public void afterUnDelete() {
        TriggerContext context = new TriggerContext();
        this.logBeforeEventHandling(context);
        this.onAfterUnDelete(context);
        this.logAfterEventHandling(context);
    }

    /**
    * <p><b>setSobjectType(Type)<b></p>
     * Sets the type of the object for this Handler.
     *
     * @param typeName Type of the object, this Handler handles events for
     */
    public void setSobjectType(Type typeName) {
        this.typeName = typeName;
    }

    /**
     * <p><b>logBeforeEventHandling(TriggerContext)</b></p>
     * Method executes before each trigger event handling and can be used
     * to perform info log, log limits before event handling etc.
     *
     * @param context
     * @see TriggerContext
     */
    protected virtual void logBeforeEventHandling(TriggerContext context) {
    }

    /**
     * <p><b>logAfterEventHandling(TriggerContext)</b></p>
     * Method executes after each trigger event handling and can be used
     * to perform info log, log limits after event handling etc.
     *
     * @param context
     * @see TriggerContext
     */
    protected virtual void logAfterEventHandling(TriggerContext context) {
    }

    /**
     * <p><b>TriggerContext</b></p>
     * Encapsulates trigger context variables in an instance form.
     *
     * @author Oleksii.Fisher
     * @version 1.0
     */
    public virtual class TriggerContext {

        public final List<SObject> newList;
        public final Map<Id, SObject> newMap;
        public final List<SObject> oldList;
        public final Map<Id, SObject> oldMap;
        public final Integer size;
        public final TriggerOperation operationType;

        public TriggerContext() {
            this.newList = Trigger.new;
            this.newMap = Trigger.newMap;
            this.oldList = Trigger.old;
            this.oldMap = Trigger.oldMap;
            this.size = Trigger.size;
            this.operationType = Trigger.operationType;
        }
    }
}