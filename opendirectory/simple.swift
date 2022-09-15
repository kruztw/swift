import Foundation
import OpenDirectory

func setAttributes(forRecord inRecord: ODRecord?, inAttributes: [String:String]) {
    for item in inAttributes {
        do {
            try inRecord?.addValue(item.value, toAttribute: item.key)
        } catch {
        }
    }
}

func randomUserPic() -> String {
    let libraryDir = FileManager.default.urls(for: .libraryDirectory, in: .localDomainMask)
    guard let library = libraryDir.first else {
        return ""
    }

    let picturePath = library.appendingPathComponent("User Pictures", isDirectory: true)
    let picDirs = (try? FileManager.default.contentsOfDirectory(at: picturePath, 
                            includingPropertiesForKeys: [URLResourceKey.isDirectoryKey],
                            options: .skipsHiddenFiles)) ?? []
    let pics = picDirs.flatMap {(try? FileManager.default.contentsOfDirectory(at: $0, 
                                          includingPropertiesForKeys: [URLResourceKey.isRegularFileKey],
                                          options: .skipsHiddenFiles)) ?? []}
    return pics[Int(arc4random_uniform(UInt32(pics.count)))].path
}

func verifyUser(account: String, pw: String) -> Bool {
    do {
        let records = try getODRecords(forRecordTypes: kODRecordTypeUsers, 
                                       queryValues: account, 
                                       attribute: kODAttributeTypeRecordName,
                                       returnAttributes: kODAttributeTypeAllAttributes)

        do {
            if try records.first?.verifyPassword(pw) != nil {
                return true;
            } else {
                // accountInvalid
            }
        } catch {
            // pwInvalid
        }
    } catch {
        // internalError
    }
    return false;
}

func createUser(account: String,
                displayName: String,
                first: String,
                last: String,
                pass: String?,
                uid: String,
                homeDir: String,
                privilege: String,
                canChangePass: Bool,
                customAttributes: [String:String]) -> Int32 {

    var newRecord: ODRecord?
    let userPicture = randomUserPic()
    let picURL = URL(fileURLWithPath: userPicture)
    let picData = NSData(contentsOf: picURL)
    let gid = getGID(byGroupName: "staff") ?? "20"


    let attrs: [AnyHashable:Any] = [
        kODAttributeTypeFullName: [displayName],
        kODAttributeTypeNFSHomeDirectory: [homeDir],
        kODAttributeTypeUserShell: ["/bin/zsh"],
        kODAttributeTypeUniqueID: [uid],
        kODAttributeTypePrimaryGroupID: [gid],
        kODAttributeTypeAuthenticationHint: [""],
        kODAttributeTypePicture: [userPicture],
        kODAttributeTypeJPEGPhoto: [picData]
    ]

    do {
        let node = try ODNode.init(session: ODSession.default(), type: ODNodeType(kODNodeTypeLocalNodes))
        newRecord = try node.createRecord(withRecordType: kODRecordTypeUsers, name: account, attributes: attrs)
    } catch {
        return -1
    }


    /// Native attributes that are all set to the user's shortname on account creation to give them
    /// the ability to update the items later.
    let nativeAttrsWriters = ["dsAttrTypeNative:_writers_AvatarRepresentation",
                              "dsAttrTypeNative:_writers_hint",
                              "dsAttrTypeNative:_writers_jpegphoto",
                              "dsAttrTypeNative:_writers_picture",
                              "dsAttrTypeNative:_writers_unlockOptions",
                              "dsAttrTypeNative:_writers_UserCertificate"]

    var nativeAttrsWritersDict: [String:String] = [:]
    nativeAttrsWriters.forEach {item in nativeAttrsWritersDict[item] = account}
    setAttributes(forRecord: newRecord, inAttributes: nativeAttrsWritersDict)

    /// Native attributes that are simply set to OS defaults on account creation.
    let nativeAttrsDetails = ["dsAttrTypeNative:AvatarRepresentation": "",
                              "dsAttrTypeNative:unlockOptions": "0"]
    setAttributes(forRecord: newRecord, inAttributes: nativeAttrsDetails)

    if canChangePass {
        do {
            try newRecord?.addValue(account, toAttribute: "dsAttrTypeNative:_writers_passwd")
        } catch {
        }
    }

    if let password = pass {
        do {
            try newRecord?.changePassword(nil, toPassword: password)
        } catch {
        }
    }

    if customAttributes.isEmpty == false {
        setAttributes(forRecord: newRecord, inAttributes: customAttributes)
    }

    if privilege == "administrator" || privilege == "sudo" {
        do {
            let results = try getODRecords(forRecordTypes: kODRecordTypeGroups, 
                                           queryValues: "admin", 
                                           attribute: kODAttributeTypeRecordName,
                                           returnAttributes: kODAttributeTypeNativeOnly)
            let adminGroup = results.first
            try adminGroup?.addMemberRecord(newRecord)
        } catch {
        }
    }

    return 0
}

func changePassword(account: String, oldPw: String, toPw: String) {
    do {
        let records = try getODRecords(forRecordTypes: kODRecordTypeUsers, 
                                       queryValues: account, 
                                       attribute: kODAttributeTypeRecordName,
                                       returnAttributes: kODAttributeTypeAllAttributes)
        
        let record = records.isEmpty ? nil : records.first
        try record?.changePassword(oldPw, toPassword: toPw)
    } catch {
    }
    // NOTE: if account has secureToken, setFVPassPhrase is needed
}

func isUserExistLocally(account: String) -> Bool {
    do {
        let records = try getODRecords(forRecordTypes: kODRecordTypeUsers, 
                                       queryValues: account, 
                                       attribute: kODAttributeTypeRecordName,
                                       returnAttributes: kODAttributeTypeAllAttributes)
        let isLocal = records.isEmpty ? false : true
        return isLocal
    } catch {
        return false
    }
}

func getODRecords(forRecordTypes inRecordTypeOrList: Any!,
                  queryValues inQueryValueOrList: String,
                  attribute inAttribute: String,
                  returnAttributes inReturnAttributeOrList: Any!) throws -> [ODRecord] {
        let node = try ODNode.init(session: ODSession.default(), type: ODNodeType(kODNodeTypeLocalNodes))
        let query = try ODQuery.init(node: node,
                                     forRecordTypes: inRecordTypeOrList,
                                     attribute: inAttribute,
                                     matchType: ODMatchType(kODMatchEqualTo),
                                     queryValues: inQueryValueOrList,
                                     returnAttributes: inReturnAttributeOrList,
                                     maximumResults: 0)
        return try query.resultsAllowingPartial(false) as! [ODRecord]
}

func getGID(byGroupName groupName: String) -> String? {
    do {
        let records = try getODRecords(forRecordTypes: kODRecordTypeGroups,
                                       queryValues: groupName,
                                       attribute: kODAttributeTypeRecordName,
                                       returnAttributes: kODAttributeTypeStandardOnly)
        let values = try records.first?.values(forAttribute: kODAttributeTypePrimaryGroupID)

        if let value = values?.first as? String {
            return value
        }
    } catch {
    }

    return nil
}

let account = "swift_tester"
let pw = "SecretPass123"

// run as administrator
let res = createUser(account: account,
                     displayName: "displayName",
                     first: "first",
                     last: "last",
                     pass: pw,
                     uid: "1000",
                     homeDir: "/tmp",
                     privilege: "guest",
                     canChangePass: false,
                     customAttributes: [:])

if isUserExistLocally(account: account) == false {
    exit(0)
}

if verifyUser(account: account, pw: pw) == false {
    exit(0)
}

let records = try getODRecords(forRecordTypes: kODRecordTypeUsers, 
			       queryValues: account, 
                               attribute: kODAttributeTypeRecordName,
                               returnAttributes: kODAttributeTypeStandardOnly)

let record = records.isEmpty ? nil : records.first
print(record ?? "")

let uidStr = try record?.values(forAttribute: kODAttributeTypeUniqueID).first
print("uid: ", uidStr ?? "<Unknown>")

let gidStr = try record?.values(forAttribute: kODAttributeTypePrimaryGroupID).first
print("gid: ", gidStr ?? "<Unknown>")
