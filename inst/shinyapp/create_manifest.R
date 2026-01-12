## Must be run in shinyapp directory
if (file.exists("app.R")) {
    app_files <- system("cd ../..; git ls-files", intern = TRUE)
    app_files <- app_files[app_files != "manifest.json"]
    app_files <- sort(app_files)
    
    rsconnect::writeManifest(
        appDir = "../..",
        appFiles = ,
        appPrimaryDoc = "inst/shinyapp/app.R",
        verbose = TRUE
    )
} else {
    abort("Not in correct directory")
}

