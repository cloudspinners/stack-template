load "${BATS_HELPER_DIR}/bats-support/load.bash"
load "${BATS_HELPER_DIR}/bats-assert/load.bash"


setup_file() {
    >&3 echo "setup for online tests"

    if [ -n "${TARGET_INSTANCE_CONFIGURATION_FILE}" ] ; then
        >&3 echo "Using instance configuration file ${TARGET_INSTANCE_CONFIGURATION_FILE}"
        export INSTANCE_CONFIGURATION_FILE=${TARGET_INSTANCE_CONFIGURATION_FILE}
    else
        >&3 echo "Using default instance configuration file"
        export INSTANCE_CONFIGURATION_FILE=./instance-spec.yml
    fi

    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY

    mkdir -p ~/.aws
    if [ -e ~/.aws/credentials ] ; then
        >&3 echo "Backing up aws credentials file"
        export AWS_CREDENTIALS_BAK=$(mktemp -u -p ~/.aws bak.credentialsXXXXXX)
        cp ~/.aws/credentials ${AWS_CREDENTIALS_BAK}
    fi


    if [ -n "${AWS_SANDBOX_ACCESS_KEY_ID}" -a -n "${AWS_SANDBOX_SECRET_ACCESS_KEY}" ]
        >&3 echo "Creating aws credentials file with credentials from AWS_SANDBOX_ACCESS_KEY_ID and AWS_SANDBOX_SECRET_ACCESS_KEY"
        echo "
[spintools_aws]
aws_access_key_id=${AWS_SANDBOX_ACCESS_KEY_ID}
aws_secret_access_key=${AWS_SANDBOX_SECRET_ACCESS_KEY}
" > ~/.aws/credentials
    else
        >&3 echo "Either AWS_SANDBOX_ACCESS_KEY_ID or AWS_SANDBOX_SECRET_ACCESS_KEY are not set"
        exit 1
    fi
}


@test "AWS cli can connect" {
  run aws --profile spintools_aws ssm describe-parameters
  echo "command: $BATS_RUN_COMMAND"
  echo "output: $output"
  assert_success
}


teardown_file() {
    >&3 echo "teardown for online tests"

    if [ ! -z ${AWS_CREDENTIALS_BAK} -a -e ${AWS_CREDENTIALS_BAK} ] ; then
        >&3 echo "Restoring aws credentials file"
        mv ${AWS_CREDENTIALS_BAK} ~/.aws/credentials
    fi
}

