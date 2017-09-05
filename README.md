Ubuntu 16.04.3 LTS

git config --global user.name "Nurasyl Aldan" &&\
git config --global user.email "nurassyl.aldan@gmail.com" &&\
git config user.name &&\
git config user.email

apt install curl
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
apt update
apt install -y nodejs=6.11.*

sudo npm install -g gulp &&\
npm install

wget https://code.jquery.com/jquery-3.2.1.min.js
mv -f jquery-3.2.1.min.js js/lib/jquery.js

wget https://ajax.googleapis.com/ajax/libs/angularjs/1.6.5/angular.min.js &&\
mv -f angular.min.js js/lib/angular.js

rm -f font-awesome-4.7.0.zip &&\
rm -rf font-awesome-4.7.0 &&\
wget http://fontawesome.io/assets/font-awesome-4.7.0.zip &&\
unzip font-awesome-4.7.0.zip &&\
rm font-awesome-4.7.0.zip &&\
mv -f font-awesome-4.7.0/css/font-awesome.min.css css/lib/font-awesome.css &&\
mv -f font-awesome-4.7.0/fonts/* css/fonts &&\
rm -r font-awesome-4.7.0

rm -f bootstrap-3.3.7-dist.zip &&\
rm -rf bootstrap-3.3.7-dist &&\
wget https://github.com/twbs/bootstrap/releases/download/v3.3.7/bootstrap-3.3.7-dist.zip &&\
unzip bootstrap-3.3.7-dist.zip &&\
rm bootstrap-3.3.7-dist.zip &&\
mv -f bootstrap-3.3.7-dist/css/bootstrap.min.css css/lib/bootstrap.css &&\
mv -f bootstrap-3.3.7-dist/css/bootstrap-theme.min.css css/lib/bootstrap-theme.css &&\
mv -f bootstrap-3.3.7-dist/js/bootstrap.js js/lib/bootstrap.js &&\
mv -f bootstrap-3.3.7-dist/fonts/* css/fonts &&\
rm -r bootstrap-3.3.7-dist

rm -rf bootstrap-datepicker &&\
mkdir bootstrap-datepicker &&\
cd bootstrap-datepicker &&\
wget https://github.com/uxsolutions/bootstrap-datepicker/releases/download/v1.6.4/bootstrap-datepicker-1.6.4-dist.zip &&\
unzip bootstrap-datepicker-1.6.4-dist.zip &&\
rm bootstrap-datepicker-1.6.4-dist.zip &&\
cd ../ &&\
mv -f bootstrap-datepicker/js/bootstrap-datepicker.min.js js/lib/bootstrap-datepicker.js &&\
mv -f bootstrap-datepicker/css/bootstrap-datepicker.min.css css/lib/bootstrap-datepicker.css &&\
mv -f bootstrap-datepicker/css/bootstrap-datepicker.standalone.min.css css/lib/bootstrap-datepicker.standalone.css &&\
mv -f bootstrap-datepicker/locales/bootstrap-datepicker.en-AU.min.js js/lib/bootstrap-datepicker.en-AU.js
rm -rf bootstrap-datepicker

wget https://necolas.github.io/normalize.css/7.0.0/normalize.css &&\
mv -f normalize.css css/lib/normalize.css

wget http://ajax.googleapis.com/ajax/libs/angularjs/1.6.5/angular-cookies.min.js &&\
mv -f angular-cookies.min.js js/lib/angular-cookies.js

wget http://ajax.googleapis.com/ajax/libs/angularjs/1.6.5/angular-route.min.js &&\
mv -f angular-route.min.js js/lib/angular-route.js

wget https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js &&\
mv -f jquery.cookie.min.js js/lib/jquery.cookie.js

wget https://cdnjs.cloudflare.com/ajax/libs/bootbox.js/4.4.0/bootbox.min.js &&\
mv -f bootbox.min.js js/lib/bootbox.js

wget http://underscorejs.org/underscore-min.js &&\
mv -f underscore-min.js js/lib/underscore.js

gulp start

git checkout dev && sudo chmod 777 save.sh && ./save.sh

git rm -r --cached . && git reset && git add --all && git commit -m "dev" && git push origin master
