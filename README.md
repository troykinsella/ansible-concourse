# ansible-concourse

[![Build Status][travis-image]][travis-url]

An Ansible role to manage [Concourse CI](https://concourse-ci.org).

## Scope

This role understands how to manage a Concourse CI web (ATC/TSA) or worker service installation.

It:
* (Optionally) creates a `concourse` user and group with which to run the daemon process.
* (Optionally) formats and mounts a volume in which Concourse work is done.
* Installs a `systemd` service called `concourse-web` and/or `concourse-worker`.
* Fetches the Concourse binary tarball from the official site.
* Creates a wrapper script that captures options passed into the binary executable.
* Installs necessary ssh key files, provided through variables.

It does not:
* Generate ssh key-pairs.
* Manage the Postgres database.
* Manage any cloud infrastructure.

## Installation

```bash
ansible-galaxy install troykinsella.concourse
```

## Branches

* `master`: Concourse 5.x (5.4.1)
* `support/4.x`: Concourse 4.x
* `support/3.x`: Concourse 3.x

Note: Concourse makes backwards-incompatible command option changes within major versions, so these branches
will likely not support early minor or patch revisions of a major version. The latest version
used in testing is shown in brackets.

## Role Variables

See `defaults/main.yml` for default values not specified below. Many of these variables map sensibly to options supplied
to the concourse binary at launch time. Run `concourse web -h` or `concourse worker -h` for more detail.

Note: The vast majority of variables have sensible defaults and normally need not be defined,
but exist for when control over related behaviour is needed. See examples for a minimal configuration set.

### Maintenance Variables

* `concourse_force_restart`: Optional. Default: "no". Triggers a restart of the web and/or worker services regardless as to whether or not configuration has changed.

### User Variables

* `concourse_manage_user`: Optional. Default: "yes". Manage the system user to which file ownership is assigned.
* `concourse_user`: Optional. The user that will own the Concourse install directory and the running process.
* `concourse_uid`: Optional. The user ID.
* `concourse_group`: Optional. The group that will own the Concourse install directory and the running process.
* `concourse_gid`: Optional. The group ID.

### Installation Variables

* `concourse_version`: Optional. The version of Concourse to install.
* `concourse_install_prefix_dir`: Optional. The prefix directory under which the Concourse installation directory will be placed. The Concourse tarball is also downloaded into this directory during installation.
* `concourse_install_dir`: Optional. The directory path into which the Concourse tarball is extracted.
* `concourse_binary_path`: Optional. The absolute path to the Concourse binary.
* `concourse_bin_dir`: Optional. A directory in which the Concourse binary and related shell scripts live.
* `concourse_etc_dir`: Optional. A directory in which Concourse-related generated or managed files are created.
* `concourse_archive_name`: Optional. The file name of the Concourse release tarball to install.
* `concourse_archive_url`: Optional. The URL at which the Concourse release tarball can be downloaded.
* `concourse_archive_checksum`: Optional. The checksum of the Concourse release tarball used to validate the downloaded archive.
* `concourse_archive_os`: Optional. The operating system for which to fetch the Concourse release tarball.
* `concourse_archive_arch`: Optional. The system architecture for which to fetch the Concourse release tarball.
* `concourse_archive_fetch_timeout`: Optional. The timeout in seconds for fetching the Concourse release tarball.
* `concourse_archive_delete_after_unarchive`: Optional. Default: "yes". Delete the release tarball after it is unpacked.
* `concourse_binary_mode`: Optional. The file mode of the Concourse binary.
* `concourse_etc_files_mode`: Optional. The file mode of all files stored in `concourse_etc_dir`.

### Common Variables

* `concourse_service_enabled`: Optional. Default: "yes". Manage a `systemd` service for a Concourse `web` and/or `worker` instance.
* `concourse_service_start`: Optional. Default: "yes". Start the `systemd` service(s) for Concourse `web` and/or `worker`.
* `concourse_log_level`: Optional. The minimum level of logs to see. [debug|info|error|fatal]

### Web Variables

* `concourse_web`: Optional. Set to "yes" to install the Concourse ATC.
* `concourse_bind_ip`: Optional. The IP address on which to listen to web traffic.
* `concourse_bind_port`: Optional. The port on which to listen for HTTP traffic.
* `concourse_tls_bind_port`: Optional. The port on which to listen for HTTPS traffic.
* `concourse_tls_certificate`: Optional. The content of the TLS certificate to use for HTTPS termination.
* `concourse_tls_certificate_path`: Optional. The remote file path of the TLS certificate to use for HTTPS termination.
  Normally, only `concourse_tls_certificate` needs to be defined.  
* `concourse_tls_key`: Optional. Optional. The content of the TLS key to use for HTTPS termination.
* `concourse_tls_key_path`: Optional. The remote file path of the TLS key to use for HTTPS termination.
  Normally, only `concourse_tls_key` needs to be defined. 
* `concourse_peer_address`: Optional. The URL at which this ATC can be reached from other ATCs in the cluster.
* `concourse_external_url`: Optional. The URL at which any ATC can be reached from the outside.
* `concourse_web_launcher_path`: Optional. The path to the script that launches the Concourse web process.
* `concourse_web_launcher_mode`: Optional. The file mode of the web launcher script.
* `concourse_cli_artifacts_dir`: Optional. The value of the `--cli-artifacts-dir` option.
* `concourse_authorized_worker_keys_path`: Optional. The path to the authorized worker keys file.
* `concourse_host_key_path`: Optional. The path to the host key file.
* `concourse_session_signing_key`: Required. The session signing key.
* `concourse_session_signing_key_path`: Optional. The path to the session signing key file.
* `concourse_encryption_key`: Optional. A 16 or 32 length key used to encrypt sensitive data before storing
  it in the database 
* `concourse_old_encryption_key`: Optional. An encryption key previously used. If provided without a new key, 
  data is encrypted. If provided with a new key, data is re-encrypted.
* `concourse_host_key`: Required. The host key.
* `concourse_authorized_worker_keys`: Required. Concatenated authorized worker keys.
* `concourse_auth_duration`: Optional. The length of time for which tokens are valid.
* `concourse_resource_checking_interval`: Optional. Interval on which to check for new versions of resources. 
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
* `concourse_worker_land_path`: Optional. The path to the script that lands a worker.
* `concourse_worker_retire_path`: Optional. The path to the script that retires a worker.
* `concourse_worker_binary_mode`: Optional. The file mode of the worker launcher, land, and retire scripts.
* `concourse_worker_land_on_stop`: Optional. Default: "no". Run `concourse land-worker` upon stopping the service.
* `concourse_worker_retire_on_stop`: Optional. Default: "yes". Run `concourse retire-worker` upon stopping the service.
* `concourse_work_dir`: Optional. The directory in which the worker does work.
* `concourse_tsa_public_key_path`: Optional. The path to the tsa public key file.
* `concourse_tsa_worker_key_path`: Optional. The path to the worker private key file.
* `concourse_tsa_host`: Required. The value of the `--tsa-host` option.
* `concourse_tsa_public_key`: Required. The tsa public key.
* `concourse_tsa_worker_key`: Required. The tsa worker private key.
* `concourse_worker_tag`: Optional. The value of the `--tag` option.
* `concourse_baggageclaim_driver`: Optional. The driver to use for managing volumes.
* `concourse_garden_config`: Optional. Configuration values passed to Garden.
  [This](https://github.com/cloudfoundry/garden-runc-release/blob/master/jobs/garden/templates/config/config.ini.erb)
  seems to be the best reference for Garden configuration options as of the time of this writing.
* `concourse_garden_config_path`: Optional.
  Normally, only `concourse_garden_config` needs to be defined.  
* `concourse_worker_options`: Optional. Other non-managed options to pass to `concourse`.
* `concourse_manage_work_volume`: Optional. Default: "no". Activate management of the work volume.
* `concourse_work_volume_device`: Required when `concourse_manage_work_volume` is "yes". The device to mount as the work volume.
* `concourse_work_volume_fs_type`: Optional. The filesystem type of the work volume. By default, this is calculated to be `btrfs` or `ext4` based on the value of `concourse_baggageclaim_driver`.
* `concourse_work_volume_fs_opts`: Optional. A list of options to be passed to mkfs command when creating the work volume filesystem.
* `concourse_work_volume_fs_force_create`: Optional. Default: "no". If yes, allows to create a new work volume filesystem on a device that already has a filesystem.
* `concourse_work_volume_fs_resize`: Optional. Default: "no". If yes, if the work volume block device and filesystem size differ, grow the filesystem into the space.
* `concourse_work_volume_mount_path`: Optional. The directory to which the work volume will be mounted.
* `concourse_work_volume_mount_opts`: Optional. Work volume mount options.

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
        concourse_garden_config: |
          [server]
          network-pool = 10.254.0.0/16
          max-containers = 1024
          docker-registry = docker.my-private-registry.org

## Testing

Prerequisites:
* Install Docker

To run serverspec tests:

```bash
docker build .
```

## Contributors

* [gaelL](https://github.com/gaelL)
* [troykinsella](https://github.com/troykinsella) (Maintainer)

## License

MIT © Troy Kinsella

[travis-image]: https://travis-ci.org/troykinsella/ansible-concourse.svg?branch=master
[travis-url]: https://travis-ci.org/troykinsella/ansible-concourse
