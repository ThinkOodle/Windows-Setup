sudo apt install git
sudo apt install python3

# NVM + Yarn
export NVM_DIR="" #Hackish way to make NVM not get confused
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.9/install.sh | sh
nvm install --lts
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install --no-install-recommends yarn #Skip installing Node since we have NVM

# Ruby
sudo apt install autoconf bison build-essential libssl-dev libyaml-dev libreadline-dev zlib1g-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.bashrc
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
rbenv install 2.5.1 --verbose
rbenv global 2.5.1
echo "gem: --no-document" > ~/.gemrc
gem install bundler
gem install rails

