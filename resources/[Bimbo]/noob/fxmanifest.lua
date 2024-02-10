fx_version 'cerulean'
game 'gta5'
this_is_a_map 'yes'

author 'noob'
version '1.0.0'

ui_page "client/game_view/index.html"

data_file 'DLC_ITYP_REQUEST' 'stream/southside_stairs.ytyp'


files {
    "client/game_view/**/*",
    'stream/southside_stairs.ytyp'
}
client_scripts {
    "@PolyZone/client.lua",
    "@PolyZone/BoxZone.lua",
    "@PolyZone/EntityZone.lua",
    "@PolyZone/CircleZone.lua",
    "@PolyZone/ComboZone.lua",
    
    "client/*.lua",
    "client/*.js",
    "client/modules/**/*.lua"
}

server_scripts {
    "server/*.lua",
    "server/*.js"
}