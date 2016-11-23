echo "https://github.com/johnpapa/generator-hottowel"
echo "export NODE_PATH=$NODE_PATH:/home/ubuntu/.nvm/versions/node/v6.9.1/lib/node_modules" >> ~/.bashrc && source ~/.bashrc
npm install -g yo
npm install -g bower gulp nodemon
npm install -g generator-hottowel
mkdir myapp
cd myapp
yo hottowel helloWorld