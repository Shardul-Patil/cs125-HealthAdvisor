
const admin = require('./node_modules/firebase-admin');
const serviceAccount = require("./firebasekey.json");
const data = require("./foodjson.json");
const collectionKey = "Food"; //name of the collection

admin.initializeApp({
   credential: admin.credential.cert(serviceAccount),
   databaseURL: "https://nutrious-f74a2-default-rtdb.firebaseio.com"
});

const firestore = admin.firestore();
const settings = {timestampsInSnapshots: true};
firestore.settings(settings);
if (data && (typeof data === "object")) {
   Object.keys(data).forEach(docKey => {
      firestore.collection(collectionKey).doc(docKey).set(data[docKey]).then((res) => {
      console.log("Document " + docKey + " successfully written!");
   }).catch((error) => {
      console.error("Error writing document: ", error);
      });   
   });
}