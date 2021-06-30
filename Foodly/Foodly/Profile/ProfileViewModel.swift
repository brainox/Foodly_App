//
//  ProfileViewModel.swift
//  Foodly
//
//  Created by Decagon on 29/06/2021.
//
import Foundation
import FirebaseFirestore
import FirebaseAuth
import UIKit

struct ProfileModel {
    var address = ""
    var phoneNumber = ""
}

extension ProfileModel: RequestParameter {
    
    var asParameter: Parameter {
        return ["address": address, "phoneNumber": phoneNumber]
    }
}

class ProfileViewModel {
    var fullName = ""
    let profileService = ProfileService()
    var profileModelData = [ProfileModel]()
    var profileModel = ProfileModel()
        
//    var proi = Food()
//    proi.name = viewModel.restName
//    proi.image = viewModel.image
    
    
//    func updateProfile() {
//        Auth.auth().updateCurrentUser(<#T##user: User##User#>) { <#Error?#> in
//            <#code#>
//        }
//    }
    
    func getProfile() {
        profileService.getProfile {(result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let result):
                result?.documents.forEach({ (doc) in
                    self.profileModelData.removeAll()
                    let data = doc.data()
                    if let address = data["address"] as? String, let phoneNumber = data["phoneNumber"] as? String {
                        DispatchQueue.main.async {
                            let profileInfo = ProfileModel(address: address, phoneNumber: phoneNumber )
                            self.profileModelData.append(profileInfo)
                            print(self.profileModelData)
                        }
                    }
                })
            }
        }
    }

    private func getUserName() {
        let docId = Auth.auth().currentUser?.uid
        let docRef = Firestore.firestore().collection("/users").document("\(docId!)")
        docRef.getDocument {(document, error) in
            if let document = document, document.exists {
                let docData = document.data()
                let name = docData!["fullName"] as? String ?? ""
                self.fullName += name
            } else {
                print(error as Any)
            }
        }
    }
    
}
