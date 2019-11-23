#if !canImport(ObjectiveC)
import XCTest

extension AppTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__AppTests = [
        ("testNothing", testNothing),
    ]
}

extension ClientTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__ClientTests = [
        ("testClientMigration", testClientMigration),
        ("testUserHeaders", testUserHeaders),
        ("testUserUpdates", testUserUpdates),
    ]
}

extension UserTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__UserTests = [
        ("testAuthLogin", testAuthLogin),
        ("testAuthLogout", testAuthLogout),
        ("testAuthRecovery", testAuthRecovery),
        ("testRegistrationCodesMigration", testRegistrationCodesMigration),
        ("testUserAccessLevelsAreOrdered", testUserAccessLevelsAreOrdered),
        ("testUserAdd", testUserAdd),
        ("testUserCreate", testUserCreate),
        ("testUserNotes", testUserNotes),
        ("testUserPassword", testUserPassword),
        ("testUserProfile", testUserProfile),
        ("testUserUsername", testUserUsername),
        ("testUserVerify", testUserVerify),
        ("testUserWhoami", testUserWhoami),
    ]
}

extension UsersTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__UsersTests = [
        ("testUsersFind", testUsersFind),
        ("testUsersHeader", testUsersHeader),
    ]
}

public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AppTests.__allTests__AppTests),
        testCase(ClientTests.__allTests__ClientTests),
        testCase(UserTests.__allTests__UserTests),
        testCase(UsersTests.__allTests__UsersTests),
    ]
}
#endif
