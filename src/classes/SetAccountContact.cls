public class SetAccountContact {
  public SetAccountContact() {
    if(Trigger.isExecuting && Trigger.isAfter && Trigger.isInsert) {
      afterInsert(Trigger.new);
    }
  }

  public void afterInsert(List<Account> accountList) {
    List<Contact> contactList = new List<Contact>();
    for (Account acc : accountList) {
      Contact con = new Contact(FirstName = 'Test', LastName = 'Contact', AccountId = acc.Id);
      contactList.add(con);
    }
    insert contactList;
  }
}
