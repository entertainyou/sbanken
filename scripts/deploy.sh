KEY_FILE=/tmp/travis_rsa
BUILD=_build/prod/rel/sbanken/releases/*/sbanken.tar.gz
DEST_FOLDER=sbanken

function ssh_command {
    cmd="$@"
    ssh -q -oStrictHostKeyChecking=no -i $KEY_FILE $DEPLOY_TARGET $cmd
}

ssh_command mkdir -p $DEST_FOLDER
ssh_command $DEST_FOLDER/bin/sbanken stop
ssh_command rm -rf $DEST_FOLDER/*
scp -q -oStrictHostKeyChecking=no -i $KEY_FILE -r $BUILD $DEPLOY_TARGET:~/ &&
    ssh_command tar -zxvf ~/sbanken.tar.gz -C $DEST_FOLDER &&
    ssh_command LANG=en_US.utf8 $DEST_FOLDER/bin/sbanken start


