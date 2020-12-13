
# POSTGRES & ELASTICSEARCH
echo "Waiting for postgres and elasticsearch"
# it's stupid but i don't want to waist more time fo checking 
#    if postgres and elasticsearch are ready for accepting connections
sleep 20

# APPLICATION
dart '--enable-experiment=non-nullable' ./bin/run_app.dart ./infra/docker.json # populate
