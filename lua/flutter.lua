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
  b = { "<cmd>ter fvm flutter pub run build_runner build -d<cr>", "Run build runner" },
  c = { "<cmd>ter fvm flutter clean<cr>", "Flutter clean" },
  l = { "<cmd>Telescope flutter commands<cr>", "Open Flutter Commans" },
  d = { "<cmd>FlutterDevices<cr>", "Flutter Devices" },
  D = { "<cmd>FlutterRun --flavor development -t lib/main_development.dart --dart-define SENTRY_ENABLED=false<cr>",
    "Run development" },
  e = { "<cmd>FlutterEmulators<cr>", "Flutter Emulators" },
  o = { "<cmd>FlutterOutlineToggle<cr>", "Toggle outline" },
  P = { "<cmd>FlutterRun --flavor production -t lib/main_production.dart --dart-define SENTRY_ENABLED=false<cr>",
    "Run production" },
  r = { "<cmd>FlutterReload<cr>", "Hot Reload App" },
  R = { "<cmd>FlutterRestart<cr>", "Hot Restart app" },
  S = {
    "<cmd>FlutterRun --flavor staging -t lib/main_staging.dart --dart-define SENTRY_ENABLED=false<cr>",
    "Run staging" },
  SR = {
    "<cmd>FlutterRun --release --flavor staging -t lib/main_staging.dart --dart-define SENTRY_ENABLED=false<cr>",
    "Run staging release" },
  t = { "<cmd>FlutterDevTools<cr>", "Start dev tools" },
  q = { "<cmd>FlutterQuit<cr>", "Quit running application" },
  v = { "<cmd>Telescope flutter fvm<cr>", "Flutter version" },
  x = { "<cmd>FlutterLogClear<cr>", "Clear log" },
  w = { "<cmd>ter fvm dart run build_runner watch<cr>", "Build runner watch" },
}

-- Flutter command line
lvim.builtin.which_key.mappings["G"] = {
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
  t = { "<cmd>ter fvm dart format . && fvm flutter analyze lib test && fvm flutter test<cr>", "Test" },
  b = { "<cmd>ter fvm flutter pub run build_runner build -d<cr>", "Build" },
  g = { "<cmd>ter fvm flutter pub get<cr>", "Pub get" },
  c = {
    "<cmd>ter very_good test --coverage --exclude-coverage 'lib/{**/*.g.dart, gen/**/*.dart, firebase_options_*.dart}' --min-coverage 100<cr>",
    "Run tests with coverage check" },
}
