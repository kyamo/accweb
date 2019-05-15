# Assetto Corsa Competizione Server Web Interface

[![CircleCI](https://circleci.com/gh/assetto-corsa-web/accweb.svg?style=svg)](https://circleci.com/gh/assetto-corsa-web/accweb)
[![Go Report Card](https://goreportcard.com/badge/github.com/assetto-corsa-web/accweb)](https://goreportcard.com/report/github.com/assetto-corsa-web/accweb)

The successor of [acweb](https://github.com/assetto-corsa-web/acweb)! accweb lets you manage your Assetto Corsa Competizione servers via a nice and simple web interface. You can start, stop and configure server instances and monitor their status.

**WORK IN PROGRESS**

## Table of contents

1. [Features](#features)
2. [Installation](#installation)
3. [Contribute and support](#support)
4. [Links](#links)
5. [License](#license)
6. [Screenshots](#screenshots)

## Features
<a name="features" />

* create and manage as many server instances as you like
* configure your instances in browser
* start/stop instances and monitor their status
* view server logs
* copy server configurations
* import/export server configuration files
* delete server configurations
* three different permissions: admin, mod and read only (using three different passwords)
* status page for non logged in users
* easy setup
    * no database required
    * simple configuration using environment variables

## Installation and configuration
<a name="installation" />

WIP

## Contribute and support
<a name="support" />

If you like to contribute, have questions or suggestions you can open tickets and pull requests on GitHub.

All Go code must have been run through go fmt. The frontend and backend changes must be (manually) tested on your system. If you have issues running it locally open a ticket. You can use the `dev.sh` and `gen_rsa_keys.sh` scripts to start accweb on your computer (on Linux).

## Links
<a name="links" />

* [Assetto Corsa Forums](https://www.assettocorsa.net/forum/index.php?threads/accweb-assetto-corsa-competizione-server-management-tool-via-web-interface.56710/)

## License
<a name="license" />

MIT

## Screenshots
<a name="screenshots" />

![Login](screenshots/login.png)
![Overview](screenshots/overview.png)
![Configuration](screenshots/configuration.png)
![Import](screenshots/import.png)
![Logs](screenshots/logs.png)
![Status page](screenshots/statuspage.png)
