//
// ProfileApi.swift
// Foodly
// Created by Decagon on 29/06/2021.

import Foundation
import FirebaseFirestore
import FirebaseAuth

enum ProfileApi {
    case createProfile(data: RequestParameter)
    case getProfile
    case updateProfile(userID: String, data: ProfileModel)

}

extension ProfileApi: FirestoreRequest {
    var baseCollectionReference: DocumentReference? {
        guard let userID = Auth.auth().currentUser?.uid else { return nil }
        return Firestore.firestore().collection("/users").document(userID)
    }

    var tasks: Tasks {
        switch self {
        case .createProfile(let profileData):
            return .create(documentData: profileData.asParameter)
        case .getProfile:
            return .read
        case .updateProfile(_, let profileData):
            return .update(documentData: profileData.asParameter)
        }
    }

    var documentReference: DocumentReference? {
        switch self {
        case .createProfile:
            return baseCollectionReference
        case .getProfile:
            return baseCollectionReference?.collection(Collection.userProfile.identifier).document("id")
        case .updateProfile(_, _):
            return baseCollectionReference?.collection(Collection.userProfile.identifier).document("id")
        }

    }

    var collectionReference: CollectionReference? {
        switch self {
        case .createProfile:
            return baseCollectionReference?.collection(Collection.userProfile.identifier)
        case .getProfile:
            return baseCollectionReference?.collection(Collection.userProfile.identifier)
        case .updateProfile:
            return baseCollectionReference?.collection(Collection.userProfile.identifier)
        }

    }
}
