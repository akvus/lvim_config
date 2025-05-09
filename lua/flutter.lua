lvim.builtin.telescope.on_config_done = function(telescope)
  telescope.load_extension "flutter"
end

-- Flutter snippets enable
local luasnip = require("luasnip")
luasnip.filetype_extend("dart", { "flutter" })

-- Flutter .arb files should be considered as json files
vim.filetype.add {
  extension = {
    arb = 'json',
  }
}

-- Flutter
lvim.builtin.which_key.mappings["a"] = {
  name = "+Flutter",
  a = { "<cmd>FlutterRun<cr>", "Run, no flavors" },
  d = { "<cmd>FlutterDevices<cr>", "Flutter Devices" },
  e = { "<cmd>FlutterEmulators<cr>", "Flutter Emulators" },
  o = { "<cmd>FlutterOutlineToggle<cr>", "Toggle outline" },
  r = { "<cmd>FlutterReload<cr>", "Hot Reload App" },
  R = { "<cmd>FlutterRestart<cr>", "Hot Restart app" },
  t = { "<cmd>FlutterDevTools<cr>", "Start dev tools" },
  q = { "<cmd>FlutterQuit<cr>", "Quit running application" },
  x = { "<cmd>FlutterLogClear<cr>", "Clear log" },
}

-- Flutter command line
lvim.builtin.which_key.mappings["G"] = {
  r = {
    "<cmd>ter fvm flutter run<cr>",
    "Run" },
  d = {
    "<cmd>ter fvm flutter run --flavor development -t lib/main_development.dart<cr>",
    "Run development" },
  p = {
    "<cmd>ter fvm flutter run --flavor production -t lib/main_production.dart<cr>",
    "Run production" },
  P = {
    "<cmd>ter fvm flutter run --release --flavor production -t lib/main_production.dart<cr>",
    "Run production" },
  s = {
    "<cmd>ter fvm flutter run --flavor staging -t lib/main_staging.dart<cr>",
    "Run staging" },
  S = {
    "<cmd>ter fvm flutter run --release --flavor staging -t lib/main_staging.dart<cr>",
    "Run staging release" },
  wr = {
    "<cmd>ter fvm flutter run --release -t lib/main_development.dart -d chrome --web-browser-flag \"--disable-web-security\" --web-port 33223 --dds-port 33224<cr>",
    "Run web release, no cors" },
  wp = {
    "<cmd>ter fvm flutter run --profile -t lib/main_development.dart -d chrome --web-browser-flag \"--disable-web-security\" --web-port 33223 --dds-port 33224<cr>",
    "Run web profile, no cors" },
  wd = {
    "<cmd>ter fvm flutter run -t lib/main_development.dart -d chrome --web-browser-flag \"--disable-web-security\" --web-port 33223 --dds-port 33224<cr>",
    "Run web debug, no cors" },

  f = { "<cmd>Telescope flutter commands<cr>", "Open Flutter Commans" },
  t = { "<cmd>ter fvm dart format . && fvm dart analyze && fvm flutter test -x integration<cr>", "Test" },
  b = { "<cmd>ter fvm flutter pub run build_runner build -d<cr>", "Run build runner" },
  bw = { "<cmd>ter fvm flutter pub run build_runner watch -d<cr>", "Run build runner watcher" },
  g = { "<cmd>ter fvm flutter pub get<cr>", "Pub get" },
  c = { "<cmd>ter fvm flutter clean<cr>", "Flutter clean" },
  v = { "<cmd>Telescope flutter fvm<cr>", "Flutter version" },
  o = { "<cmd>ter fvm dart run build_runner watch<cr>", "Build runner watch" },
}
