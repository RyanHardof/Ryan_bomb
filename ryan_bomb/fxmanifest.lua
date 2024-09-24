fx_version 'cerulean'
game 'gta5'

author 'YourName'
description 'Bomb Script for FiveM using QB-Core'
version '1.0.0'

shared_script 'config.lua'
client_script 'client.lua'
shared_script 'vehicle.lua'
server_script 'server.lua'


dependencies {
    'qb-core',  -- Ensure qb-core is available as a dependency for the resource
    'boii_minigames',
    'ps-dispatch'
}