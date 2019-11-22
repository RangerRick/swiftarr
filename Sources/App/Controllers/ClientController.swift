import Vapor
import Crypto
import FluentSQL

/// The collection of `/api/v3/client/*` route endpoints and handler functions that provide
/// bulk retrieval services for registered API clients.

struct ClientController: RouteCollection {
    
    // MARK: RouteCollection Conformance
    
    /// Required. Registers routes to the incoming router.
    func boot(router: Router) throws {
        
        // convenience route group for all /api/v3/client endpoints
        let clientRoutes = router.grouped("api", "v3", "client")
        
        // instantiate authentication middleware
        let basicAuthMiddleware = User.basicAuthMiddleware(using: BCryptDigest())
        let guardAuthMiddleware = User.guardAuthMiddleware()
        let tokenAuthMiddleware = User.tokenAuthMiddleware()
        
        // set protected route groups
        let basicAuthGroup = clientRoutes.grouped([basicAuthMiddleware, guardAuthMiddleware])
//        let sharedAuthGroup = clientRoutes.grouped([basicAuthMiddleware, tokenAuthMiddleware, guardAuthMiddleware])
        let tokenAuthGroup = clientRoutes.grouped([tokenAuthMiddleware, guardAuthMiddleware])
        
        // open access endpoints
        
        // endpoints available only when not logged in
        
        // endpoints available whether logged in or out

        // endpoints available only when logged in
        tokenAuthGroup.get("user", "headers", "since", String.parameter, use: userHeadersHandler)
        tokenAuthGroup.get("user", "updates", "since", String.parameter, use: userUpdatesHandler)
    }
    
    // MARK: - Open Access Handlers
    
    // MARK: - basicAuthGroup Handlers (not logged in)
    // All handlers in this route group require a valid HTTP Basic Authentication
    // header in the request.
    
    // MARK: - sharedAuthGroup Handlers (logged in or not)
    // All handlers in this route group require a valid HTTP Basic Authentication
    // *or* HTTP Bearer Authentication header in the request.

    // MARK: - tokenAuthGroup Handlers (logged in)
    // All handlers in this route group require a valid HTTP Bearer Authentication
    // header in the request.
    
    /// `GET /api/v3/client/user/headers/since/DATE`
    ///
    /// Retrieves the `UserProfile.Header` of all users with a `.profileUpdatedAt` timestamp
    /// later than the specified date. The `DATE` parameter is a string, and may be provided
    /// in either of two formats:
    ///
    /// * a string literal `Double` (e.g. "1574364935" or "1574364935.88991")
    /// * an ISO 8601 `yyyy-MM-dd'T'HH:mm:ssZ` string (e.g. "2019-11-21T05:31:28Z")
    ///
    /// The second format is precisely what is returned in `swiftarr` JSON responses, while
    /// the numeric form makes for a prettier URL.
    ///
    /// - Parameter req: The incoming request `Container`, provided automatically.
    /// - Throws: 400 error if no valid date string provided. 403 error if user is not
    ///   a registered client.
    /// - Returns: Array of all updated users, as `UserProfile.Header` objects.
    func userHeadersHandler(_ req: Request) throws -> Future<[UserProfile.Header]> {
        let user = try req.requireAuthenticated(User.self)
        // must be registered client
        guard user.accessLevel == .client else {
            throw Abort(.forbidden, reason: "registered clients only")
        }
        // parse date parameter
        let since = try req.parameters.next(String.self)
        guard let date = ClientController.dateFromParameter(string: since) else {
            throw Abort(.badRequest, reason: "'\(since)' is not a recognized date format")
        }
        // return .Header array
        return UserProfile.query(on: req)
            .filter(\.updatedAt > date)
            .all()
            .map {
                (profiles) in
                let headers = try profiles.map { try $0.convertToHeader() }
                return headers
        }
    }

    /// `GET /api/v3/client/user/updates/since/DATE`
    ///
    /// Retrieves the `User.Public` of all users with a `.profileUpdatedAt` timestamp later
    /// than the specified date. The `DATE` parameter is a string, and may be provided in either
    /// of two formats:
    ///
    /// * a string literal `Double` (e.g. "1574364935" or "1574364935.88991")
    /// * a UTC ISO8601 "yyyy-MM-dd'T'HH:mm:ssZ" string (e.g. "2019-11-21T05:31:28Z"), the
    ///   date format returned in `swiftarr` JSON responses
    ///
    /// - Parameter req: The incoming request `Container`, provided automatically.
    /// - Throws: 400 error if no valid date string provided. 403 error if user is not
    ///   a registered client.
    /// - Returns: Array of all updated users, as `User.Public` objects.
    func userUpdatesHandler(_ req: Request) throws -> Future<[User.Public]> {
        let user = try req.requireAuthenticated(User.self)
        // must be registered client
        guard user.accessLevel == .client else {
            throw Abort(.forbidden, reason: "registered clients only")
        }
        // parse date parameter
        let since = try req.parameters.next(String.self)
        guard let date = ClientController.dateFromParameter(string: since) else {
            throw Abort(.badRequest, reason: "'\(since)' is not a recognized date format")
        }
        // return .Public array
        return User.query(on: req)
            .filter(\.profileUpdatedAt > date)
            .all()
            .map {
                (users) in
                let publicUsers = try users.map { try $0.convertToPublic() }
                return publicUsers
        }
    }
    
    // MARK: - Helper Functions
}

// MARK: - Helper Structs
