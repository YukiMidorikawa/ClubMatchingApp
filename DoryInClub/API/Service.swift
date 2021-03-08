//
//  Service.swift
//  DoryInClub
//
//  Created by 緑川裕紀 on 2021/01/24.
//

import UIKit
import Firebase

struct Service {
    
    // MARK: -Fetch
    
    static func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {
        COLLECTION_USERS.document(uid).getDocument { (snapShot, error) in
            guard let dictionary = snapShot?.data() else { return }
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    
    static func fetchUsers(forCurrentUser user: User, completion: @escaping([User]) -> Void) {
        var users = [User]()
    
        let query = COLLECTION_USERS
            .whereField("age", isGreaterThanOrEqualTo: user.minSeekingAge)
            .whereField("age", isLessThanOrEqualTo: user.maxSeekingAge)
//            .whereField("gender", isEqualTo: "男")
        
        fetchSwipes { (swipedUserIDs) in
            query.getDocuments { (snapShot, error) in
                guard let snapShot = snapShot else { return }
                snapShot.documents.forEach({ (document) in
                    let dictionary = document.data()
                    let user = User(dictionary: dictionary)
                    guard user.uid != Auth.auth().currentUser?.uid else { return }
                    guard swipedUserIDs[user.uid] == nil else { return }
                    users.append(user)
                    
                })
                completion(users)
            }
        }
        
    }
    
    private static func fetchSwipes(completion: @escaping([String: Bool]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_SWIPES.document(uid).getDocument { (snapShot, error) in
            guard let data = snapShot?.data() as? [String: Bool] else {
                completion([String: Bool]())
                return
            }
            completion(data)
        }
    }
    
    static func fetcheMatches(completion: @escaping([Match]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_MATCHES_MESSAGES.document(uid).collection("matches").getDocuments { (snapShot, error) in
            guard let data = snapShot else { return }
            
            let matches = data.documents.map({ Match(dictionary: $0.data()) })
            completion(matches)
            

        }
    }

    static func fetchMessages(forUser user: User, completion: @escaping([Message]) -> Void) {
        var messages = [Message]()
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let query = COLLECTION_MATCHES_MESSAGES.document(currentUid).collection(user.uid).order(by: "timestamp")
        
        query.addSnapshotListener { (snapshot, error) in
            snapshot?.documentChanges.forEach({ (change) in
                if change.type == .added {
                    let dictionary = change.document.data()
                    messages.append(Message(dictionary: dictionary))
                    completion(messages)
                }
            })
        }
    }
    
    static func fetchRecentUsers(completion: @escaping([User]) -> Void) {
        COLLECTION_USERS.getDocuments { (snapshot, error) in
            guard var users = snapshot?.documents.map({ User(dictionary: $0.data()) }) else { return }
            if let i = users.firstIndex(where: { $0.uid == Auth.auth().currentUser?.uid }) {
                users.remove(at: i)
            }
            completion(users)
        }
    }
    
    static func fetchConversations(completion: @escaping([Conversation]) -> Void) {
        var conversations = [Conversation]()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let query = COLLECTION_MATCHES_MESSAGES.document(uid).collection("recent-messages").order(by: "timestamp")
        
        query.addSnapshotListener { (snapshot, error) in
            snapshot?.documentChanges.forEach({ (change) in
                let dictionary = change.document.data()
                let message = Message(dictionary: dictionary)
                
                self.fetchUser(withUid: message.chatPartnerId) { (user) in
                    let conversation = Conversation(user: user, message: message)
                    conversations.append(conversation)
                    completion(conversations)
                }
                
            })
        }
        
    }
    
    static func checkTouch(forMatches uid: String, completion: @escaping(Bool) -> Void) {
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_MATCHES_MESSAGES.document(currentUserUid).collection("matches")
            .document(uid).getDocument { (snapshot, error) in
                guard let data = snapshot else { return }
                guard let read = data["isTouch"] as? Bool else { return }
                completion(read)
            }
    }
    
    static func checkRead(forChatWith user: User, completion: @escaping(Bool) -> Void) {
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_MATCHES_MESSAGES.document(currentUserUid).collection("recent-messages")
            .document(user.uid).getDocument { (snapshot, error) in
                guard let data = snapshot else { return }
                guard let read = data["isRead"] as? Bool else { return }
                guard let direction = data["toId"] as? String else { return }
                if read == false && direction == currentUserUid {
                    completion(read)
                }
            }
    }
    
    // MARK: -Uploads
    static func saveUserData(user: User, copletion: @escaping(Error?) -> Void) {
        
        let data = ["uid": user.uid,
                    "fullName": user.name,
                    "imageURLs": user.imageURLs,
                    "age": user.age,
                    "bio": user.bio,
                    "gender": user.gender,
                    "profession": user.profession,
                    "club": user.club,
                    "minSeekingAge": user.minSeekingAge,
                    "maxSeekingAge": user.maxSeekingAge] as [String : Any]
        
        COLLECTION_USERS.document(user.uid).setData(data, completion: copletion)
        
        
    }
    

    static func saveSwipe(forUser user:User, isLike: Bool, completion: ((Error?) -> Void)?) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
//        let shouldLike = isLike ? 1 : 0
        
        COLLECTION_SWIPES.document(uid).getDocument { (snapShot, error) in
            let data = [user.uid: isLike]
            
            if snapShot?.exists == true {
                COLLECTION_SWIPES.document(uid).updateData(data, completion: completion)
            } else {
                COLLECTION_SWIPES.document(uid).setData(data, completion: completion)
            }
        }
    }
    
    static func checkIfMatchExists(forUser user: User, completion: @escaping(Bool) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_SWIPES.document(user.uid).getDocument { (snapShot, error) in
            guard let data = snapShot?.data() else { return }
            guard let didMatch = data[currentUid] as? Bool else { return }
            completion(didMatch)
        }
    }
    
    static func uploadMatch(currentUser: User, matchedUser: User) {
        guard let profileImageUrl = matchedUser.imageURLs.first else { return }
        guard let currentUserProfileImageUrl = currentUser.imageURLs.first else { return }
        
        let matchedUserData = ["uid": matchedUser.uid,
                               "name": matchedUser.name,
                               "profileImageUrl": profileImageUrl,
                               "isTouch": false] as [String : Any]
        
        COLLECTION_MATCHES_MESSAGES.document(currentUser.uid).collection("matches").document(matchedUser.uid).setData(matchedUserData)
        
        let currentUserData = ["uid": currentUser.uid,
                               "name": currentUser.name,
                               "profileImageUrl": currentUserProfileImageUrl,
                               "isTouch": false] as [String : Any]
        
        COLLECTION_MATCHES_MESSAGES.document(matchedUser.uid).collection("matches").document(currentUser.uid).setData(currentUserData)
        
        
    }
    
    static func uploadMessage(_ message: String, to user: User, completion: ((Error?) -> Void)?) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let data = ["text": message,
                    "fromId": currentUid,
                    "toId": user.uid,
                    "isRead": false,
                    "timestamp": Timestamp(date: Date())] as [String : Any]
        
        COLLECTION_MATCHES_MESSAGES.document(currentUid).collection(user.uid).addDocument(data: data) { (_) in
            COLLECTION_MATCHES_MESSAGES.document(user.uid).collection(currentUid).addDocument(data: data, completion: completion)
            
            COLLECTION_MATCHES_MESSAGES.document(currentUid).collection("recent-messages")
                .document(user.uid).setData(data)
            
            COLLECTION_MATCHES_MESSAGES.document(user.uid).collection("recent-messages").document(currentUid).setData(data)
        }
        
    }
    
    static func uploadImage(image: UIImage, completion: @escaping(String) -> Void){
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/image/\(filename)")
        
        ref.putData(imageData, metadata: nil) { (metaData, error) in
            if let error = error {
                print("エラー\(error)")
                return
            }
            
            ref.downloadURL { (url, erroe) in
                guard let imageUrl = url?.absoluteString else { return }
                completion(imageUrl)
            }
            
        }
        
    }
    
    static func updateTouch(forMatches uid: String) {
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_MATCHES_MESSAGES.document(currentUserUid).collection("matches")
            .document(uid).updateData(["isTouch": true])
    }
    
    static func updateRead(wantToCheckWith user: User) {
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_MATCHES_MESSAGES.document(currentUserUid).collection("recent-messages")
            .document(user.uid).updateData(["isRead": true])
    }
    
    //MARK: - Unique
    
    static func fetchBeLikedUsers(completion: @escaping([String: Bool]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_SWIPES.whereField(uid, isEqualTo: true)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                    }
                }
            }
    }
    
    static func relaseUsers(forCurrentUser user: User) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        //スワイプの履歴を削除、1方向
        COLLECTION_SWIPES.document(uid).updateData([
            user.uid: FieldValue.delete()
        ])
        //双方向
        COLLECTION_SWIPES.document(user.uid).updateData([
            uid: FieldValue.delete()
        ])
        
        //マッチの履歴を削除、1方向
        COLLECTION_MATCHES_MESSAGES.document(uid).collection("matches").document(user.uid).delete()
        //双方向
        COLLECTION_MATCHES_MESSAGES.document(user.uid).collection("matches").document(uid).delete()

        //トークの履歴を削除、1方向
//        COLLECTION_MATCHES_MESSAGES.document(uid).collection(user.uid)
        
        //最新トークの履歴を削除、1方向
        COLLECTION_MATCHES_MESSAGES.document(uid).collection("recent-messages").document(user.uid).delete()
        //双方向
        COLLECTION_MATCHES_MESSAGES.document(user.uid).collection("recent-messages").document(uid).delete()

    }
    
    
}

