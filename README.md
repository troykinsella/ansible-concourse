# ansible-concourse

[![Build Status][travis-image]][travis-url]

An Ansible role to manage [Concourse CI](https://concourse-ci.org).

## Role Variables

See `defaults/main.yml` for default values. Many of these variables map sensibly to options supplied
to the concourse binary at launch time. Run `concourse web -h` or `concourse worker -h` for more detail.

### General

* `concourse_version`: Optional. The version of Concourse to install.
* `concourse_install_dir`: Optional. The directory path to which to put the Concourse binary and config files.
* `concourse_binary_path`: Optional. The path to the Concourse binary.
* `concourse_binary_os`: Optional. The operating system for which to fetch the Concourse binary.
* `concourse_binary_arch`: Optional. The system architecture for which to fetch the Concourse binary.
* `concourse_user`: Optional. The user that will own the Concourse install directory and the running process.
* `concourse_group`: Optional. The group that will own the Concourse install directory and the running process.
* `concourse_force_restart`: Optional. Triggers a restart of the web and/or worker services regardless as to whether or not configuration has changed.

### Web Variables

* `concourse_web`: Optional. Set to "yes" to install the Concourse ATC.
* `concourse_web_launcher_path`: Optional. The path to the script that launches the Concourse web process.
* `concourse_cli_artifacts_dir`: Optional. The value of the `--cli-artifacts-dir` option.
* `concourse_authorized_worker_keys_path`: Optional. The path to the authorized worker keys file.
* `concourse_host_key_path`: Optional. The path to the host key file.
* `concourse_session_signing_key_path`: Optional. The path to the session signing key file.
* `concourse_session_signing_key`: Required. The session signing key.
* `concourse_host_key`: Required. The host key.
* `concourse_authorized_worker_keys`: Required. Concatenated authorized worker keys.
* `concourse_web_options`: Optional. Other non-managed options to pass to `concourse`.

#### Web Local Authentication Variables

* `concourse_local_users`: Optional. A list of concourse user credentials that are added as local users. 
  Entries are objects having `name` and `password` fields (see example). Passwords must be bcrypted.
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
* `concourse_work_dir`: Optional. The directory in which the worker does work.
* `concourse_tsa_public_key_path`: Optional. The path to the tsa public key file.
* `concourse_tsa_worker_key_path`: Optional. The path to the worker private key file.
* `concourse_tsa_host`: Required. The value of the `--tsa-host` option.
* `concourse_tsa_public_key`: Required. The tsa public key.
* `concourse_tsa_worker_key`: Required. The tas worker private key.
* `concourse_worker_tag`: Optional. The value of the `--tag` option.
* `concourse_worker_options`: Optional. Other non-managed options to pass to `concourse`.

## Example Playbook

    - hosts: atc
      roles:
      - role: troykinsella.concourse
        concourse_web: yes
        concourse_authorized_worker_keys:
        - "{{ worker1_public_key }}"
        concourse_local_users:
        - name: admin
          password: my_bcrypted_password
        concourse_main_team_local_users:
        - admin
        concourse_web_options: |
          --postgres-data-source postgres://concourse:changeme@concoursedb.abc123.us-east-1.rds.amazonaws.com/concourse \
          --external-url http://concourse.example.com

    - hosts: worker1
      roles:
      - role: troykinsella.concourse
        concourse_worker: yes
        concourse_tsa_host: my-atc
        concourse_tsa_public_key: "{{ host_pub_key }}"
        concourse_tsa_worker_key: "{{ worker1_key }}"
        concourse_worker_options: |
          --garden-network-pool 10.254.0.0/16 \
          --garden-max-containers 1024

License
-------

MIT © Troy Kinsella

[travis-image]: https://travis-ci.org/troykinsella/ansible-concourse.svg?branch=master
[travis-url]: https://travis-ci.org/troykinsella/ansible-concourse
