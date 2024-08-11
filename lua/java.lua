-- TODO:
-- 1. Add more mappings for java
-- 2. Handle both mavne and gradle (same short cuts?)
-- 3. DAP for java?
-- 4. Auto formatting for XML
--
-- TODO: Checkout for yaml support instead of XML:
-- https://github.com/takari/polyglot-maven?tab=readme-ov-file

local mvnCommand = ""

if (IsWindows()) then
  mvnCommand = "./mvnw"
else
  mvnCommand = "mvn"
end

-- Auto compile on save, in order to trigger Spring Boot DevTools Restart
-- vim.api.nvim_create_autocmd({ "BufWritePost" }, {
--   pattern = { "*.java", "*.kotlin" },
--   command = "silent exec 'ter " .. mvnCommand .. " compile'",
-- })

-- Maven
lvim.builtin.which_key.mappings["m"] = {
  -- TODO: think of writing a script to unify all my run commands for all types of projects
  r = { "<cmd>ter " .. mvnCommand .. " spring-boot:run<cr>", "Run spring boot with maven" },
  h = { "<cmd>ter " .. mvnCommand .. " spring-boot:help<cr>", "Spring help" },
  c = { "<cmd>ter " .. mvnCommand .. " clean<cr>", "Clean" },
  t = { "<cmd>ter " .. mvnCommand .. " test<cr>", "Test" },
  T = { "<cmd>ter " .. mvnCommand .. " spring-boot:test-run<cr>", "Test run spring" },
}

-- Gradle
lvim.builtin.which_key.mappings["r"] = {
  r = { "<cmd>ter gradle bootRun<cr>", "Run spring boot with gradle" },
  c = { "<cmd>ter gradle clean<cr>", "Clean" },
  t = { "<cmd>ter gradle test<cr>", "Test" },
  T = { "<cmd>ter gradle test<cr>", "Test" },
}
