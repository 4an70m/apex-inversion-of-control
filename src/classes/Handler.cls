public abstract with sharing class Handler {

    protected Type typeName;

    public Handler() {}

    //TO OVERRIDE
    //before
    protected virtual void onBeforeInsert(TriggerContext context) {}

    protected virtual void onBeforeUpdate(TriggerContext context) {}

    protected virtual void onBeforeDelete(TriggerContext context) {}

    //after
    protected virtual void onAfterInsert(TriggerContext context) {}

    protected virtual void onAfterUpdate(TriggerContext context) {}

    protected virtual void onAfterDelete(TriggerContext context) {}

    protected virtual void onAfterUnDelete(TriggerContext context) {}

    //PUBLIC INTERFACE
    //before
    public void beforeInsert() {
        TriggerContext context = new TriggerContext();
        this.logBeforeEventHandling(context);
        this.onBeforeInsert(context);
        this.logAfterEventHandling(context);
    }

    public void beforeUpdate() {
        TriggerContext context = new TriggerContext();
        this.logBeforeEventHandling(context);
        this.onBeforeUpdate(context);
        this.logAfterEventHandling(context);
    }

    public void beforeDelete() {
        TriggerContext context = new TriggerContext();
        this.logBeforeEventHandling(context);
        this.onBeforeDelete(context);
        this.logAfterEventHandling(context);
    }

    //after
    public void afterInsert() {
        TriggerContext context = new TriggerContext();
        this.logBeforeEventHandling(context);
        this.onAfterInsert(context);
        this.logAfterEventHandling(context);
    }

    public void afterUpdate() {
        TriggerContext context = new TriggerContext();
        this.logBeforeEventHandling(context);
        this.onAfterUpdate(context);
        this.logAfterEventHandling(context);
    }

    public void afterDelete() {
        TriggerContext context = new TriggerContext();
        this.logBeforeEventHandling(context);
        this.onAfterDelete(context);
        this.logAfterEventHandling(context);
    }

    public void afterUnDelete() {
        TriggerContext context = new TriggerContext();
        this.logBeforeEventHandling(context);
        this.onAfterUnDelete(context);
        this.logAfterEventHandling(context);
    }

    //UTILITY
    public void setSobjectType(Type typeName) {
        this.typeName = typeName;
    }

    //LOGGERS
    protected virtual void logBeforeEventHandling(TriggerContext context) {}

    protected virtual void logAfterEventHandling(TriggerContext context) {}

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