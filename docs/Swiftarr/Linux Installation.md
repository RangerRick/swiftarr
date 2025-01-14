Linux Installation
==================

This guide was written based on Fedora 34 (Red Hat). Some adjustments 
will need to be made for other distros (such as Ubuntu/Debian/etc).

Prerequisites
-------------

01. You will need an instance of PostgreSQL (postgres) and Redis. It is HIGHLY
    recommended to use the Dockerized instances provided by `scripts/docker-compose-instance.yml`
    and its wrapper (`scripts/instance.sh`). If you want natively-installed
    instances of these applications you are on your own.

02. Several packages and libraries are required. Install these with your 
    package manager.
    ```
    sudo dnf install -y gd-devel libjpeg-turbo-devel swift-lang
    ```

03. This project uses the [Vapor](https://docs.vapor.codes/) web framework for Swift.
    While Linux is a supported platform there are no packages available for the Toolbox
    so it must be built. Follow the instructions at https://docs.vapor.codes/4.0/install/linux/
    To summarize:
    ```
    git clone https://github.com/vapor/toolbox
    cd toolbox
    git checkout 18.3.3 # This was the latest at the time of writing.
    sudo make install
    ```

Build
-----

01. From the root of this repo:
    ```
    vapor build
    # or
    swift build
    ```

Run
---

01. Ensure that the prereqs from above are running.
    ```
    ~ # scripts/instance.sh up -d            
    Creating network "swiftarr_default" with the default driver
    Creating swiftarr_postgres_1 ... done
    Creating swiftarr_redis_1    ... done
    ```

02. If you are populating a fresh database then you'll need to run a migration.
    to get some data. See the [Vapor docs](https://docs.vapor.codes/4.0/fluent/overview/#migrate) for details.
    ```
    # Note there is no `swift` eqivalent here. You need the vapor CLI.
    vapor run migrate --yes
    ```
    Example output:
    ```
    [0/0] Build complete!
    [ NOTICE ] Starting up in Development mode.
    ...
    The following migration(s) will be prepared:
    ...
    + App.SetInitialCategoryForumCounts on psql
    Would you like to continue?
    y/n>

    [ INFO ] Starting registration code import [database-id: psql]
    [ INFO ] Starting boardgame import [database-id: psql]
    ...
    [ INFO ] Imported 25000 karaoke songs. [database-id: psql]
    Migration successful
    ```

03. Run the server!
    ```
    vapor run
    # or
    swift run
    ```
    You should see a line akin to `Server starting on http://127.0.0.1:8081`
    which tells you where to point your web browser.
