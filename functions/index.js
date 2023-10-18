const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp({credential: admin.credential.applicationDefault()});

exports.setVerifiedEmail = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated");
  }
  await admin.auth().updateUser(context.auth.uid, {
    emailVerified: true,
  });
  return {success: true};
});

