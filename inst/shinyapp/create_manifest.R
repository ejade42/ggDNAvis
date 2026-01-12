## Must be run in shinyapp directory
if (file.exists("app.R")) {
    rsconnect::writeManifest(
        appDir = "../..",
        appFiles = system("cd ../..; git ls-files", intern = TRUE),
        appPrimaryDoc = "inst/shinyapp/app.R",
        verbose = TRUE
    )
} else {
    abort("Not in correct directory")
}
