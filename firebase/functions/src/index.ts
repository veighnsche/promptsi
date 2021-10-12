import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript

export const onChatCreate = functions.firestore.document('chats/{chatId}')
 .onCreate((snapshot, context) => {
   const chatId: string = snapshot.id;

   const {user1, user2}: AppChat = snapshot.data() as AppChat;
   const chatTile: AppChatTile = {chatId, updatedOn: Date.now().valueOf()};

   const profilesRef = admin.firestore().collection('profiles');

   return Promise.all([
     profilesRef.doc(user1).collection('chat tiles').doc(user2).set(chatTile),
     profilesRef.doc(user2).collection('chat tiles').doc(user1).set(chatTile),
   ]).catch(() => {
     functions.logger.error('failed to write to chat tile', {structuredData: true});
   });
 });
