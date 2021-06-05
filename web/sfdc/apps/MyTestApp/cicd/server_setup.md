# Setting up Build Agent
Setup a new Linux Ubuntu server (this will be designated the Build Agent).

1. Connect to the Build Agent using an SSH client application (such as PuTTY).
2. Download and install Git:
    ```
    sudo apt install git -y
    ```
3. Install Node Version Manager - https://github.com/nvm-sh/nvm
    ```
    wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
    source ~/.nvm/nvm.sh
    ```
4. Install the latest Node.js LTS version:
    ```
    nvm install 12 && nvm alias default 12
    node --version
    ```
5. Setup Intel proxy settings (reference: https://devops.intel.com/#/content/setup-proxies). 
    Ensure the following files are configured:
    ```
    ~/.gitconfig
    ~/.npmrc
    /etc/environment
    ```
6. Install Salesforce CLI (sfdx).  For additional reference see here.
    ```
    npm install sfdx-cli --global
    ```
7. Install and configure GitLab Runner (https://docs.gitlab.com/runner/).  For additional reference about the setup process see here.
    * Add GitLab’s official repository:
        ```
        curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
        ```
    * Install the latest version of GitLab Runner:
        ```
        sudo apt install gitlab-runner
        ```
    * Validate GitLab Runner setup, execute the following command:
        ```
        gitlab-runner --version
        sudo gitlab-runner status
        ```
    * Check Proxy settings for gitlab-runner (it is required to be able to register).  More information here.
        ```
        sudo nano /etc/environment
        ```
    * Register the Runner.  For additional reference see here. 
        * Login to the corporate GitLab server and open your project repository.
        * Browse to: Repository - Settings - CI/CD - Runners, to get parameters required.
        * Execute the command in the Build Agent: 
            ```
            sudo gitlab-runner register
            ```
        * Enter the configuration parameters
            * Enter your GitLab instance URL: https://gitlab.com/
            * Enter the token you obtained to register the Runner: (get registration token from GitLab Settings - CI/CD - Runners)
            * Enter a description for the Runner: MyProject
            * Enter the tags associated with the Runner: MyProject
            * Enter the Runner executor: shell
        * By registering the GitLab runner instance, it creates a local user account in the server.  Add the 'gitlab-runner' system account to the sudoers file.
            ```
            sudo nano /etc/sudoers
            ```
