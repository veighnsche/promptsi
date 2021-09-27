import * as functions from "firebase-functions";

// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript

export const helloWorld = functions.https.onCall(() => {
  return {
    text: "Hello world from Firebase functions",
  };
});
