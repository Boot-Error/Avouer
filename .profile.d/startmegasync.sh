
export PATH=$PATH:$HOME/bin/

echo "------> Starting mega sync"
megacmd -conf $HOME/.megacmd sync mega:/images/ $HOME/images &
