# Apex-inversion-of-control
Creating or editing triggers may be painful in a multy-team environment. Depeding on your deployment tool or state of the org code - some of the code changes may overwrite changes from other teams, some of the old triggers should be deactived and all of the code might be in the trigger itself, which drastically increases the complexity of adding/changing the code.
# Solution
Using simple entrprise patterns we can separate the logic from configuration - we separate triggers from the actual business logic and assigne what business logic handler should be executed via custom metadata.


## Quick Setup
To start using dependency injection in your triggers simply start with creating a class, which extends the __Handler__ class.

```java
public class AccountHandler extends Handler {
}
```
Override one of the virtual methods from Handler class.
Change Trigger for the object you are going to listen this way:

```java
trigger AccountTrigger on Account (before insert) {
    HandlerExecutionPool.getInstance().getHandler(Account.class).execute();
}
```

And configure custom metadata record to use your class for specified Object type:
__Object Name__: Account
__Class Name__: AccountHandler
__Is Active__: true

## Handler

Each Handler child class inherits a number of methods, specific for handling diffrent Trigger events and a couple more. Availalble methods for overriding:
 - onBeforeInsert(TriggerContext)
 - onBeforeUpdate(TriggerContext)
 - onBeforeDelete(TriggerContext)
 - onAfterInsert(TriggerContext)
 - onAfterUpdate(TriggerContext)
 - onAfterDelete(TriggerContext)
 - onAfterUnDelete(TriggerContext)
 - logBeforeEventHandling(TriggerContext)
 - logAfterEventHandling(TriggerContext)

Each method receives an instance of TriggerContext class, which includes all context-variables from static Trigger class.
Event-handling methods runs on Trigger events. logBeforeEventHandling() and logAfterEventHandling() methods runs before and after each event is handled.

```java
public class AccountHandler extends Handler {
    public override void onBeforeInsert(Handler.TriggerContext context) {
        System.debug(context.newList);
    }
    
    public override void logBeforeEventHandling(Handler.TriggerContext context) {
        System.debug('Executing: ' + context.operationType);
    }
}
```

Inserting an Account produces debug log:
```
Debug| [Account:{...}, ...]
Debug| Executing: BEFORE_INSERT
```

## TriggerContext
Class encapsulates all trigger-related static variables and makes them instance. Allows to have and abstraction layer between what handler gets from Trigger as well as allows creating mocks in unit tests.
Fiels, pulled from Trigger static variables:

- List<SObject> newList
- Map<Id, SObject> newMap
- List<SObject> oldList
- Map<Id, SObject> oldMap
- Integer size
- TriggerOperation operationType
 
## HandlerExecutionPool
Class instantiates of inner class - HandlerExecutors and stores them in a static pool. The class is a singleton.
Public static method __getInstance()__ which retrieves a singleton instance of HandlerExecutionPool;
Public method __getHandler(System.Type)__ retrieves (or creates) a HandlerExecutor for specific System.Type.

```java
trigger AccountTrigger on Account (before insert) {
    HandlerExecutionPool.getInstance(); //returns HandlerExecutionPool instance
    HandlerExecutionPool.getInstance().getHandler(Account.class); //returns HandlerExecutor instance for Account type
}
```
## HandlerExecutor
HandlerExecutor is an inner class, which stores a list of handlers for its assigned System.Type. It has single public method - __execute()__, which iterates through each individual Handler instance, which are active based on the metadata, and executes designated event-handling method e.g. beforeInsert() on each Handler instance.
Only one instance of __HandlerExecutor__ is created per System.Type. Second trigger run in one context will get the same HandlerExecutor and execute Handlers, that were previously created from the metadata configurations.

```java
trigger AccountTrigger on Account (before insert) {
    HandlerExecutionPool.getInstance().getHandler(Account.class).execute();
}
```
License
----

MIT
