
# ELASTICSEARCH
echo "Waiting for elasticsearch"
# it's stupid but i don't want to waist more time for checking 
#    if elasticsearch is ready for accepting connections
sleep 20

# APPLICATION
# dart '--enable-experiment=non-nullable' ./bin/run_app.dart ./infra/docker.json # populate
dart --no-sound-null-safety ./bin/run_app.dart ./infra/docker.json # populate