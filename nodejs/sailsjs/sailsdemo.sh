npm install sails -g
# Demo application - https://www.youtube.com/watch?v=Kv6MIHsjGY8
if [ -d ./sailsdemo/ ]; then rm -rf sailsdemo; fi
sails generate new sailsdemo
cd sailsdemo
sails generate api user
sails generate api role
sails lift
