if ! [ ${IP+x} ]; then export IP=localhost; fi
if ! [ ${PORT+x} ]; then export PORT=8080; fi
echo "IP is:" $IP " and PORT is:" $PORT
# In your project settings.py file,set ALLOWED_HOSTS like this:
# ALLOWED_HOSTS = ['localhost', '127.0.0.1', 'codelibrary-rodolfodc.c9users.io']
cd Treasuregram
python manage.py runserver $IP:$PORT
# Create a super user, for you to access the admin page at /admin/
# python manage.py createsuperuser