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
  D = { "<cmd>FlutterRun --flavor development -t lib/main_development.dart --dart-define SENTRY_ENABLED=false<cr>",
    "Run development" },
  P = { "<cmd>FlutterRun --flavor production -t lib/main_production.dart --dart-define SENTRY_ENABLED=false<cr>",
    "Run production" },
  S = {
    "<cmd>FlutterRun --flavor staging -t lib/main_staging.dart --dart-define SENTRY_ENABLED=false<cr>",
    "Run staging" },
  SR = {
    "<cmd>FlutterRun --release --flavor staging -t lib/main_staging.dart --dart-define SENTRY_ENABLED=false<cr>",
    "Run staging release" },
}

-- Flutter command line
lvim.builtin.which_key.mappings["G"] = {
  r = {
    "<cmd>ter fvm flutter run<cr>",
    "Run" },
  d = {
    "<cmd>ter fvm flutter run --flavor development -t lib/main_development.dart --dart-define SENTRY_ENABLED=false<cr>",
    "Run development" },
  p = {
    "<cmd>ter fvm flutter run --flavor production -t lib/main_production.dart --dart-define SENTRY_ENABLED=false<cr>",
    "Run production" },
  P = {
    "<cmd>ter fvm flutter run --release --flavor production -t lib/main_production.dart --dart-define SENTRY_ENABLED=false<cr>",
    "Run production" },
  s = {
    "<cmd>ter fvm flutter run --flavor staging -t lib/main_staging.dart --dart-define SENTRY_ENABLED=false<cr>",
    "Run staging" },
  S = {
    "<cmd>ter fvm flutter run --release --flavor staging -t lib/main_staging.dart --dart-define SENTRY_ENABLED=false<cr>",
    "Run staging release" },
  wd = {
    "<cmd>ter fvm flutter run --flavor development -t lib/main_development_web_chat.dart --web-port=7331 --web-browser-flag=--disable-web-security --dart-define SENTRY_ENABLED=false<cr>",
    "Run web development" },
  wr = {
    "<cmd>ter fvm flutter run -d chrome --web-browser-flag \"--disable-web-security\"<cr>",
    "Run web, no cors" },

  f = { "<cmd>Telescope flutter commands<cr>", "Open Flutter Commans" },
  t = { "<cmd>ter fvm dart format . && fvm dart analyze && fvm flutter test -x integration<cr>", "Test" },
  b = { "<cmd>ter fvm flutter pub run build_runner build -d<cr>", "Run build runner" },
  g = { "<cmd>ter fvm flutter pub get<cr>", "Pub get" },
  c = { "<cmd>ter fvm flutter clean<cr>", "Flutter clean" },
  v = { "<cmd>Telescope flutter fvm<cr>", "Flutter version" },
  o = { "<cmd>ter fvm dart run build_runner watch<cr>", "Build runner watch" },
}
