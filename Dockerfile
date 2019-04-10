FROM python:3

RUN set -eux; \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get update; \
    apt-get install -y \
      git \
      openssh-client \
      ruby; \
    pip install --no-cache-dir \
      ansible; \
    gem install serverspec;

COPY . /role

RUN set -eux; \
    cd /role/test; \
    ls -al /opt; \
    cp /role/test/spec/default/fixtures/concourse.tar.gz /opt/concourse.tar.gz; \
    ansible-playbook -i inventory --skip-tags no-test -t web playbook.yml; \
    cp /role/test/spec/default/fixtures/concourse.tar.gz /opt/concourse.tar.gz; \
    ansible-playbook -i inventory --skip-tags no-test -t worker playbook.yml; \
    rake spec
