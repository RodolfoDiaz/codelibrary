# Create a Private Key and Self-Signed Digital Certificate

Continuous integration (CI) environments are fully automated and don’t support the human interactivity of a web-based login flow that accepts a username and password. In these environments, you must use the JSON web tokens (JWT) login flow. The JWT-based authorization flow requires generating a digital certificate and uploading it to a connected app. You execute these tasks only once. After that, you can authorize the org in a script that runs in your CI environment.  For additional reference, follow the instructions indicated in this link.

1. Download and install OpenSSL 1.1.1c (latest version).  
    For Ubuntu, you can check the following guide: https://cloudwafer.com/blog/installing-openssl-on-ubuntu-16-04-18-04/

2. You can find the passwords (RSA_Private_Key_Pass, PRIVATE_KEY_PASSWORD) in the password safe system.

    Note: There are many characters that are considered special by the shell, and may need to be escaped, such as:
    ```
    $ ! ' " ( ) ; \ ` * ? { } [ ] < > | & % # ~ @ 
    ```
    To define a secure password you can use a combination of uppercase and lowercase letters with dash - and underscore characters _ (with password length > 16).
3. Create a Private Key and Self-Signed Digital Certificate:
    ```
    cd ~
    mkdir certificates
    cd certificates/
    openssl genrsa -des3 -passout pass:RSA_Private_Key_Pass -out server.pass.key 4096
    openssl rsa -passin pass:RSA_Private_Key_Pass -in server.pass.key -out server.key
    rm server.pass.key
    openssl req -new -key server.key -out server.csr
    openssl x509 -req -sha256 -days 1095 -in server.csr -signkey server.key -out server.crt
    ```

4. Encrypt the server.key file so that you can safely add it to your Git repository. Copy the files to the source code repository.
    ```
    openssl enc -aes-256-cbc -md md5 -salt -e -in server.key -out server.key.enc -k PRIVATE_KEY_PASSWORD -pbkdf2
    cd ~/source/repos/MyTestApp/
    mkdir cicd
    cp ~/certificates/server.key.enc ~/source/repos/MyTestApp/cicd
    cp ~/certificates/server.crt ~/source/repos/MyTestApp/cicd
    ```
5. To decrypt the server.key.enc file during CI/CD pipeline (.gitlab-ci.yml), just execute the following command:
    ```
    openssl enc -aes-256-cbc -md md5 -salt -d -in server.key.enc -out server.key -k PRIVATE_KEY_PASSWORD -pbkdf2
    ```

## Notes

* The server.crt file is your site certificate, suitable for use with the connected app along with the server.key private key.

* The server.key.enc is an encrypted version of the server.key private key that is safe to commit to your GitLab repository.

* Do not store the unencrypted private key file in Git repository ('server.key').

