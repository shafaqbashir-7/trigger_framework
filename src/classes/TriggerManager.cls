public class TriggerManager {
  private TriggerContext context;
  private Boolean isTriggerExecuting;

  public TriggerManager() {
    this.setTriggerContext();
  }

  private Boolean validateRun() {
    if(!this.isTriggerExecuting || this.context == null) {
      throw new TriggerHandlerException('Trigger handler called outside of Trigger execution');
    }
    return true;
  }
  public void run() {
    if (!validateRun())
      return;
    if (this.context == TriggerContext.BEFORE_INSERT) {
      this.beforeInsert();
    } else if (this.context == TriggerContext.BEFORE_UPDATE) {
      this.beforeUpdate();
    } else if (this.context == TriggerContext.BEFORE_DELETE) {
      this.beforeDelete();
    } else if (this.context == TriggerContext.AFTER_INSERT) {
      this.afterInsert();
    } else if (this.context == TriggerContext.AFTER_UPDATE) {
      this.afterUpdate();
    } else if (this.context == TriggerContext.AFTER_DELETE) {
      this.afterDelete();
    } else if (this.context == TriggerContext.AFTER_UNDELETE) {
      this.afterUndelete();
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

  public  void afterUpdate() {
    List<sObject> sObjectList                     = Trigger.new;
    String objectType                             = sObjectList[0].getSObjectType().getDescribe().getName();
    List<Trigger_Definition__c> triggerDefinition = [SELECT Id, Active__c, Class_Name__c, Context__c, Update__c, Object_Name__c FROM Trigger_Definition__c WHERE Active__c = true AND Context__c INCLUDES('after') AND Update__c = true AND Object_Name__c = : objectType];
    for (Trigger_Definition__c tDefinition : triggerDefinition) {
      Type t = Type.forName(tDefinition.Class_Name__c);
      Object o = t.newInstance();
    }
  }

  public  void beforeUpdate() {
    List<sObject> sObjectList                     = Trigger.new;
    String objectType                             = sObjectList[0].getSObjectType().getDescribe().getName();
    List<Trigger_Definition__c> triggerDefinition = [SELECT Id, Active__c, Class_Name__c, Context__c, Update__c, Object_Name__c FROM Trigger_Definition__c WHERE Active__c = true AND Context__c INCLUDES('before') AND Update__c = true AND Object_Name__c = : objectType];
    if (triggerDefinition.size() > 0) {
      for (Trigger_Definition__c tDefinition : triggerDefinition) {
        Type t = Type.forName(tDefinition.Class_Name__c);
        Object o = t.newInstance();
      }
    }
  }

  public  void afterInsert() {
    List<sObject> sObjectList                     = Trigger.new;
    String objectType                             = sObjectList[0].getSObjectType().getDescribe().getName();
    List<Trigger_Definition__c> triggerDefinition = [SELECT Id, Active__c, Class_Name__c, Context__c, Insert__c, Object_Name__c FROM Trigger_Definition__c WHERE Active__c = true AND Context__c INCLUDES('after') AND Insert__c = true AND Object_Name__c = : objectType];
    if (triggerDefinition.size() > 0) {
      for (Trigger_Definition__c tDefinition : triggerDefinition) {
        Type t = Type.forName(tDefinition.Class_Name__c);
        Object o = t.newInstance();
      }
    }
  }

  public  void beforeInsert() {
    List<sObject> sObjectList                     = Trigger.new;
    String objectType                             = sObjectList[0].getSObjectType().getDescribe().getName();
    List<Trigger_Definition__c> triggerDefinition = [SELECT Id, Active__c, Class_Name__c, Context__c, Insert__c, Object_Name__c FROM Trigger_Definition__c WHERE Active__c = true AND Context__c INCLUDES('before') AND Insert__c = true AND Object_Name__c = : objectType];
    if (triggerDefinition.size() > 0) {
      for (Trigger_Definition__c tDefinition : triggerDefinition) {
        Type t = Type.forName(tDefinition.Class_Name__c);
        Object o = t.newInstance();
      }
    }
  }

  public void afterDelete() {
    List<sObject> sObjectList                     = Trigger.old;
    String objectType                             = sObjectList[0].getSObjectType().getDescribe().getName();
    List<Trigger_Definition__c> triggerDefinition = [SELECT Id, Active__c, Class_Name__c, Context__c, Delete__c, Object_Name__c FROM Trigger_Definition__c WHERE Active__c = true AND Context__c INCLUDES('after') AND Delete__c = true AND Object_Name__c = : objectType];
    if (triggerDefinition.size() > 0) {
      for (Trigger_Definition__c tDefinition : triggerDefinition) {
        Type t = Type.forName(tDefinition.Class_Name__c);
        Object o = t.newInstance();
      }
    }
  }
  public void afterUndelete() {
    List<sObject> sObjectList                     = Trigger.new;
    String objectType                             = sObjectList[0].getSObjectType().getDescribe().getName();
    List<Trigger_Definition__c> triggerDefinition = [SELECT Id, Active__c, Class_Name__c, Context__c, Update__c, Object_Name__c FROM Trigger_Definition__c WHERE Active__c = true AND Context__c INCLUDES('after') AND Delete__c = true AND Object_Name__c = : objectType];
    if (triggerDefinition.size() > 0) {
      for (Trigger_Definition__c tDefinition : triggerDefinition) {
        Type t = Type.forName(tDefinition.Class_Name__c);
        Object o = t.newInstance();
      }
    }
  }
  public void beforeDelete() {
    List<sObject> sObjectList                     = Trigger.old;
    String objectType                             = sObjectList[0].getSObjectType().getDescribe().getName();
    List<Trigger_Definition__c> triggerDefinition = [SELECT Id, Active__c, Class_Name__c, Context__c, Update__c, Object_Name__c FROM Trigger_Definition__c WHERE Active__c = true AND Context__c INCLUDES('after') AND Delete__c = true AND Object_Name__c = : objectType];
    if (triggerDefinition.size() > 0) {
      for (Trigger_Definition__c tDefinition : triggerDefinition) {
        Type t = Type.forName(tDefinition.Class_Name__c);
        Object o = t.newInstance();
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
