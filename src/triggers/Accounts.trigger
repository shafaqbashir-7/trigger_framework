trigger Accounts on Account (before insert, before update, before delete, after insert,
                               after update, after delete, after undelete) {

  TriggerManager t = new TriggerManager();
  t.run();
}
