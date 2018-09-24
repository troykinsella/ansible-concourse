# ansible-concourse

[![Build Status][travis-image]][travis-url]

An Ansible role to manage [Concourse CI](https://concourse-ci.org).

## Scope

This role understands how to manage a Concourse CI web (ATC/TSA) or worker service installation.

It:
* Creates a Concourse user with which to run the daemon process.
* Installs a `systemd` service called `concourse-web` and/or `concourse-worker`.
* Fetches the Concourse binary executable from the official site.
* Creates a wrapper script that defines options passed into the binary executable.
* Installs necessary ssh key files provided through variables.

It does not:
* Generate ssh key-pairs.
* Manage the Postgres database.
* Manage any cloud infrastructure.

## Installation

```bash
ansible-galaxy install troykinsella.concourse
```

## Branches

* `master`: Concourse 4.x (published to Ansible Galaxy)
* `support/3.x`: Concourse 3.x

## Role Variables

See `defaults/main.yml` for default values. Many of these variables map sensibly to options supplied
to the concourse binary at launch time. Run `concourse web -h` or `concourse worker -h` for more detail.

### General

* `concourse_version`: Optional. The version of Concourse to install.
* `concourse_install_dir`: Optional. The directory path to which to put the Concourse binary and config files.
* `concourse_binary_path`: Optional. The path to the Concourse binary.
* `concourse_binary_os`: Optional. The operating system for which to fetch the Concourse binary.
* `concourse_binary_arch`: Optional. The system architecture for which to fetch the Concourse binary.
* `concourse_binary_mode`: Optional. The file mode of the concourse binary.
* `concourse_download_url`: Optional. The URL at which the concourse binary can be downloaded. Normally only variables 
  such as `concourse_binary_os` or `concourse_version` need to be adjusted to configure the download URL.
* `concourse_manage_user`: Optional. Create and manage the concourse user and group. Otherwise, the 
  `concourse_user` and `concourse_group` are expected to be available / managed externally.
* `concourse_user`: Optional. The user that will own the Concourse install directory and the running process.
* `concourse_group`: Optional. The group that will own the Concourse install directory and the running process.
* `concourse_force_restart`: Optional. Triggers a restart of the web and/or worker services regardless as to whether or not configuration has changed.
* `concourse_log_level`: Optional. The minimum level of logs to see. [debug|info|error|fatal]

### Web Variables

* `concourse_web`: Optional. Set to "yes" to install the Concourse ATC.
* `concourse_web_launcher_path`: Optional. The path to the script that launches the Concourse web process.
* `concourse_web_launcher_mode`: Optional. The file mode of the web launcher script.
* `concourse_cli_artifacts_dir`: Optional. The value of the `--cli-artifacts-dir` option.
* `concourse_authorized_worker_keys_path`: Optional. The path to the authorized worker keys file.
* `concourse_host_key_path`: Optional. The path to the host key file.
* `concourse_session_signing_key_path`: Optional. The path to the session signing key file.
* `concourse_session_signing_key`: Required. The session signing key.
* `concourse_host_key`: Required. The host key.
* `concourse_authorized_worker_keys`: Required. Concatenated authorized worker keys.
* `concourse_bind_ip`: Optional. The IP address on which to listen to web traffic.
* `concourse_bind_port`: Optional. The port on which to listen for HTTP traffic.
* `concourse_peer_url`: Optional. The URL at which this ATC can be reached from other ATCs in the cluster.
* `concourse_external_url`: Optional. The URL at which any ATC can be reached from the outside.
* `concourse_encryption_key`: Optional. A 16 or 32 length key used to encrypt sensitive data before storing
  it in the database 
* `concourse_old_encryption_key`: Optional. An encryption key previously used. If provided without a new key, 
  data is encrypted. If provided with a new key, data is re-encrypted.
* `concourse_auth_duration`: Optional. The length of time for which tokens are valid. 
* `concourse_web_options`: Optional. Other non-managed options to pass to `concourse`.

#### Web PostgreSQL Variables

* `concourse_postgres_host`: Optional. The Postgres host to connect to.
* `concourse_postgres_port`: Optional. The Postgres port to connect to.
* `concourse_postgres_socket`: Optional. The path to a Unix domain socket to connect to.
* `concourse_postgres_user`: Optional. The Postgres user to sign in as. 
* `concourse_postgres_password`: Optional. The Postgres user's password.
* `concourse_postgres_ssl_mode`: Optional. Whether or not to use SSL with the Postgres connection.
* `concourse_postgres_ca_cert`: Optional. The Postgres CA cert file location.
* `concourse_postgres_client_cert`: Optional. The Postgres client cert file location.
* `concourse_postgres_client_key`: Optional. The Postgres client key file location.
* `concourse_postgres_connect_timeout`: Optional. The Postgres dialing timeout.
* `concourse_postgres_database`: Optional. The Postgres database name.

#### Web Local Authentication Variables

* `concourse_local_users`: Optional. A list of concourse user credentials that are added as local users. 
  Entries are objects having `name` and `password` fields (see example). Passwords can be plain text or bcrypted.
* `concourse_main_team_local_users`: Optional. List of whitelisted local concourse users (of the supplied local user list).
* `concourse_main_team_allow_all_users`: Optional. Set to `true` to whitelist all logged in users on the system.

#### Web GitHub Authentication Variables

* `concourse_github_client_id`: Optional. GitHub client ID.
* `concourse_github_client_secret`: Optional. GitHub client secret.
* `concourse_main_team_github_users`: Optional. List of whitelisted GitHub users.
* `concourse_main_team_github_orgs`: Optional. List of whitelisted GitHub orgs.
* `concourse_main_team_github_teams`: Optional. List of whitelisted GitHub teams formatted as "org:team".

#### Web Other Authentication Methods

Unsupported. Do it yer dang self by supplying `concourse web` command options with the `concourse_web_options` variable.

### Worker Variables

* `concourse_worker`: Optional. Set to "yes" to install a Concourse worker.
* `concourse_worker_launcher_path`: Optional. The path to the script that launches the Concourse worker process.
* `concourse_worker_launcher_mode`: Optional. The file mode of the web launcher script.
* `concourse_work_dir`: Optional. The directory in which the worker does work.
* `concourse_tsa_public_key_path`: Optional. The path to the tsa public key file.
* `concourse_tsa_worker_key_path`: Optional. The path to the worker private key file.
* `concourse_tsa_host`: Required. The value of the `--tsa-host` option.
* `concourse_tsa_public_key`: Required. The tsa public key.
* `concourse_tsa_worker_key`: Required. The tsa worker private key.
* `concourse_worker_tag`: Optional. The value of the `--tag` option.
* `concourse_garden_docker_registry`: Optional. Docker registry API endpoint.
* `concourse_worker_options`: Optional. Other non-managed options to pass to `concourse`.

## Example Playbook

    - hosts: atc
      roles:
      - role: troykinsella.concourse
        concourse_web: yes
        concourse_authorized_worker_keys:
        - "{{ worker_public_key }}"
        concourse_postgres_host: concoursedb.abc123.us-east-1.rds.amazonaws.com
        concourse_postgres_user: concourse
        concourse_postgres_password: changeme
        concourse_postgres_database: atc
        concourse_local_users:
        - name: admin
          password: my_bcrypted_password
        concourse_main_team_local_users:
        - admin
        concourse_external_url: http://concourse.example.com

    - hosts: workers
      roles:
      - role: troykinsella.concourse
        concourse_worker: yes
        concourse_tsa_host: my-atc
        concourse_tsa_public_key: "{{ host_pub_key }}"
        concourse_tsa_worker_key: "{{ worker_key }}"
        concourse_worker_options: |
          --garden-network-pool 10.254.0.0/16 \
          --garden-max-containers 1024

## Testing

Prerequisites:
* Python 2
* Ruby
* Ansible (duh)
* Serverspec

To run serverspec tests in a Vagrant machine:

```bash
> vagrant up
> rake
```

Take a peek at the UI: `http://192.168.66.10:8080/`

## License

MIT © Troy Kinsella

[travis-image]: https://travis-ci.org/troykinsella/ansible-concourse.svg?branch=master
[travis-url]: https://travis-ci.org/troykinsella/ansible-concourse
