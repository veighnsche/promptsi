import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();
const profilesRef = admin.firestore().collection('profiles');

// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript

export const onChatCreate = functions.firestore.document('chats/{chatId}')
 .onCreate(snapshot => {
   const {user1, user2}: AppChat = snapshot.data() as AppChat;
   const match: AppMatch = {chatId: snapshot.id, updatedOn: Date.now().valueOf()};
   return Promise.all([
     profilesRef.doc(user1).collection('matches').doc(user2).set(match),
     profilesRef.doc(user2).collection('matches').doc(user1).set(match),
   ]);
 });

export const onChatDelete = functions.firestore.document('chats/{chatId}')
 .onDelete(snapshot => {
   const {user1, user2}: AppChat = snapshot.data() as AppChat;
   return Promise.all([
     profilesRef.doc(user1).collection('matches').doc(user2).delete(),
     profilesRef.doc(user2).collection('matches').doc(user1).delete(),
   ]);
 });
