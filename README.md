# ansible-concourse

An ansible role to manage Concourse CI.

## Role Variables

See `defaults/main.yml` for default values.

### General

* concourse_version: Optional. The version of Concourse to install.
* concourse_install_dir: Optional. The directory path to which to put the Concourse binary and config files.
* concourse_binary_path: Optional. The path to the Concourse binary.
* concourse_binary_os: Optional. The operating system for which to fetch the Concourse binary.
* concourse_binary_arch: Optional. The system architecture for which to fetch the Concourse binary.
* concourse_user: Optional. The user that will own the Concourse install directory and the running process.
* concourse_group: Optional. The group that will own the Concourse install directory and the running process.

### Web Variables

* concourse_web: Optional. Set to "yes" to install the Concourse ATC.
* concourse_web_launcher_path: Optional. The path to the script that launches the Concourse web process.
* concourse_cli_artifacts_dir: Optional. The value of the `--cli-artifacts-dir` option.
* concourse_authorized_worker_keys_path: Optional. The path to the authorized worker keys file.
* concourse_host_key_path: Optional. The path to the host key file.
* concourse_session_signing_key_path: Optional. The path to the session signing key file.
* concourse_session_signing_key: Required. The session signing key.
* concourse_host_key: Required. The host key.
* concourse_authorized_worker_keys: Required. Concatenated authorized worker keys.
* concourse_web_options: Optional. Other non-managed options to pass to `concourse`.

### Worker Variables

* concourse_worker: Optional. Set to "yes" to install a Concourse worker.
* concourse_worker_launcher_path: Optional. The path to the script that launches the Concourse worker process.
* concourse_work_dir: Optional. The directory in which the worker does work.
* concourse_tsa_public_key_path: Optional. The path to the tsa public key file.
* concourse_tsa_worker_key_path: Optional. The path to the worker private key file.
* concourse_tsa_host: Required. The value of the `--tsa-host` option.
* concourse_tsa_public_key: Required. The tsa public key.
* concourse_tsa_worker_key: Required. The tas worker private key.
* concourse_worker_options: Optional. Other non-managed options to pass to `concourse`.

## Example Playbook

    - hosts: atc
      roles:
      - role: troykinsella.concourse
        concourse_web: yes
        concourse_authorized_worker_keys:
        - "{{ worker1_public_key }}"
        concourse_web_options: |
          --basic-auth-username concourse \
          --basic-auth-password changeme \
          --postgres-data-source postgres://concourse:changeme@concoursedb.abc123.us-east-1.rds.amazonaws.com/concourse \
          --external-url http://concourse.example.com

    - hosts: worker1
      roles:
      - role: troykinsella.concourse
        concourse_worker: yes
        concourse_tsa_worker_key: "{{ worker1_key }}"

License
-------

MIT