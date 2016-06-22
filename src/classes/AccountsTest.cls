@isTest
public class AccountsTest {
  static testMethod void testInsert() {
    Trigger_Definition__c beforeDefinition = new Trigger_Definition__c(Active__c = true, Class_Name__c = 'SetAccountFlag', Object_Name__c = 'Account', Context__c = 'before', Insert__c = true, Update__c = true, Delete__c = true, Undelete__c = true);
    insert beforeDefinition;
    Trigger_Definition__c afterDefinition = new Trigger_Definition__c(Active__c = true, Class_Name__c = 'SetAccountFlag', Object_Name__c = 'Account', Context__c = 'after', Insert__c = true, Update__c = true, Delete__c = true, Undelete__c = true);
    insert afterDefinition;

    Account acc = new Account(Name = 'Test Trigger');
    insert acc;
    System.assertEquals(1, [SELECT Count() FROM Contact]);

    acc.Name = 'updated Test Trigger';
    update acc;
    System.assertEquals(1, [SELECT Count() FROM Account WHERE Name = : 'updated Test Trigger']);

    delete acc;
    System.assertEquals(0, [SELECT Count() FROM Account]);

    List<Account> accList = [SELECT id, Name FROM Account WHERE Name = : 'updated Test Trigger' ALL ROWS];
    undelete accList[0];
    System.assertEquals(1, [SELECT Count() FROM Account]);
  }
}
