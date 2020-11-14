# Install Salesforce CLI - https://developer.salesforce.com/tools/sfdxcli
if [ "$(uname)" == "Darwin" ]; then
    echo "Install Salesforce CLI in macOS"
    # brew install sfdx
    npm install sfdx-cli@latest --global
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    echo "Install Salesforce CLI in Linux"
    # Follow the instructions from: 
    # https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_install_cli.htm
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    echo "Download Salesforce CLI for 32 bits Windows NT platform"
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
    echo "Download Salesforce CLI for 64 bits Windows NT platform"
    # When you are installing the Salesforce CLI on Windows, you may see a Windows Defender warning.  
    # To override this warning you need to 'Unblock' the setup executable from the file Properties screen.
    # https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_considerations.htm
    # sfdx-windows-amd64.exe
    npm install sfdx-cli@latest --global
fi