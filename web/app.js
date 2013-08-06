var APP_KEY = 'bqc1ih1bbpcboui';

var client = new Dropbox.Client({key: APP_KEY});

// Try to finish OAuth authorization.
client.authenticate({interactive: true}, function (error) {
  if (error) {
    alert('Authentication error: ' + error);
  }
});

if (client.isAuthenticated()) {
  var datastoreManager = client.getDatastoreManager();
  datastoreManager.openDefaultDatastore(function (error, datastore) {
    if (error) {
      alert('Error opening default datastore: ' + error);
    }

    // Now you have a datastore. The next few examples can be included here.
    var contactsTable = datastore.getTable('contacts');
    var results = contactsTable.query();
    console.log('results', results);
  });
}
