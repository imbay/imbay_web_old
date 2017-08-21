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

wget https://necolas.github.io/normalize.css/7.0.0/normalize.css &&\
mv -f normalize.css css/lib/normalize.css

gulp start

git checkout dev && sudo chmod 777 save.sh && ./save.sh
