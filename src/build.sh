# for linux users
chmod +x ./build.sh
# copy across files to distribution directory
mkdir ../dist
cp ./objectmon.rb ../dist
cp ./game_system.rb ../dist
cp ./default_high_scores.csv ../dist
cp ./default_high_scores.csv ../dist/high_scores.csv
# install all gems
gem install colorize
gem install artii 
gem install terminal-table 
gem install tty-prompt 