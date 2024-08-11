local mvnCommand = ""

if (IsWindows()) then
  mvnCommand = "./mvnw"
else
  mvnCommand = "mvn"
end

-- Maven
lvim.builtin.which_key.mappings["m"] = {
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
