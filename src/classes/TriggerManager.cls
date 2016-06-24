public class TriggerManager {
  private TriggerContext context;
  private Boolean isTriggerExecuting;
  private String query;

  public TriggerManager() {
    query = '';
    this.setTriggerContext();
  }

  private Boolean validateRun() {
    if (!this.isTriggerExecuting || this.context == null) {
      throw new TriggerHandlerException('Trigger handler called outside of Trigger execution');
    }
    return true;
  }
  public void run() {
    if (!validateRun())
      return;
      if (this.context == TriggerContext.BEFORE_INSERT) {
        List<sObject> sObjectList = Trigger.new;
        query                     = 'SELECT Id, Active__c, Class_Name__c, Context__c, Insert__c, Object_Name__c FROM Trigger_Definition__c WHERE Active__c = true AND Context__c INCLUDES(\'before\') AND Insert__c = true AND Object_Name__c = \''+ sObjectList[0].getSObjectType().getDescribe().getName() +'\' ';
        classObject(sObjectList, query);
      } else if (this.context == TriggerContext.BEFORE_UPDATE) {
        List<sObject> sObjectList = Trigger.new;
        query                     = 'SELECT Id, Active__c, Class_Name__c, Context__c, Update__c, Object_Name__c FROM Trigger_Definition__c WHERE Active__c = true AND Context__c INCLUDES(\'before\') AND Update__c = true AND Object_Name__c = \''+ sObjectList[0].getSObjectType().getDescribe().getName() +'\' ';
        classObject(sObjectList, query);
      } else if (this.context == TriggerContext.BEFORE_DELETE) {
        List<sObject> sObjectList = Trigger.old;
        query                     = 'SELECT Id, Active__c, Class_Name__c, Context__c, Delete__c, Object_Name__c FROM Trigger_Definition__c WHERE Active__c = true AND Context__c INCLUDES(\'before\') AND Delete__c = true AND Object_Name__c = \''+ sObjectList[0].getSObjectType().getDescribe().getName() +'\' ';
        classObject(sObjectList, query);
      } else if (this.context == TriggerContext.AFTER_INSERT) {
        List<sObject> sObjectList = Trigger.new;
        query                     = 'SELECT Id, Active__c, Class_Name__c, Context__c, Insert__c, Object_Name__c FROM Trigger_Definition__c WHERE Active__c = true AND Context__c INCLUDES(\'after\') AND Insert__c = true AND Object_Name__c = \''+ sObjectList[0].getSObjectType().getDescribe().getName() +'\' ';
        classObject(sObjectList, query);
      } else if (this.context == TriggerContext.AFTER_UPDATE) {
        List<sObject> sObjectList = Trigger.new;
        query                     = 'SELECT Id, Active__c, Class_Name__c, Context__c, Update__c, Object_Name__c FROM Trigger_Definition__c WHERE Active__c = true AND Context__c INCLUDES(\'after\') AND Update__c = true AND Object_Name__c = \''+ sObjectList[0].getSObjectType().getDescribe().getName() +'\' ';
        classObject(sObjectList, query);
      } else if (this.context == TriggerContext.AFTER_DELETE) {
          List<sObject> sObjectList = Trigger.old;
          query                     = 'SELECT Id, Active__c, Class_Name__c, Context__c, Delete__c, Object_Name__c FROM Trigger_Definition__c WHERE Active__c = true AND Context__c INCLUDES(\'after\') AND Delete__c = true AND Object_Name__c = \''+ sObjectList[0].getSObjectType().getDescribe().getName() +'\' ';
          classObject(sObjectList, query);
      } else if (this.context == TriggerContext.AFTER_UNDELETE) {
        List<sObject> sObjectList = Trigger.new;
        query                     = 'SELECT Id, Active__c, Class_Name__c, Context__c, Undelete__c, Object_Name__c FROM Trigger_Definition__c WHERE Active__c = true AND Context__c INCLUDES(\'after\') AND Undelete__c = true AND Object_Name__c = \''+ sObjectList[0].getSObjectType().getDescribe().getName() +'\' ';
        classObject(sObjectList, query);
      }
  }

  private void setTriggerContext() {
    if (!Trigger.isExecuting) {
      this.isTriggerExecuting = false;
      return;
    } else {
      this.isTriggerExecuting = true;
    }

    if (Trigger.isExecuting && Trigger.isBefore && Trigger.isInsert) {
      this.context = TriggerContext.BEFORE_INSERT;
    } else if (Trigger.isExecuting && Trigger.isBefore && Trigger.isUpdate) {
      this.context = TriggerContext.BEFORE_UPDATE;
    } else if (Trigger.isExecuting && Trigger.isBefore && Trigger.isDelete) {
      this.context = TriggerContext.BEFORE_DELETE;
    } else if (Trigger.isExecuting && Trigger.isAfter && Trigger.isInsert) {
      this.context = TriggerContext.AFTER_INSERT;
    } else if (Trigger.isExecuting && Trigger.isAfter && Trigger.isUpdate) {
      this.context = TriggerContext.AFTER_UPDATE;
    } else if (Trigger.isExecuting && Trigger.isAfter && Trigger.isDelete) {
      this.context = TriggerContext.AFTER_DELETE;
    } else if (Trigger.isExecuting && Trigger.isAfter && Trigger.isUndelete) {
      this.context = TriggerContext.AFTER_UNDELETE;
    }
}
  public void classObject(List<sObject> sObjectList, String query) {
    String objectType                             = sObjectList[0].getSObjectType().getDescribe().getName();
    List<Trigger_Definition__c> triggerDefinition = Database.query(query);
    if (triggerDefinition.size() > 0) {
     for (Trigger_Definition__c tDefinition : triggerDefinition) {
         try {
           Type t = Type.forName(tDefinition.Class_Name__c);
           t.newInstance();
         } catch(Exception e) {
             System.debug('Class Name was Wrong');
         }
       }
     }
  }
  private enum TriggerContext {
    BEFORE_INSERT, BEFORE_UPDATE, BEFORE_DELETE,
    AFTER_INSERT, AFTER_UPDATE, AFTER_DELETE,
    AFTER_UNDELETE
  }

  public class TriggerHandlerException extends Exception {}

}
