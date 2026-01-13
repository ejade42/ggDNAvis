## Must be run in main ggDNAvis directory
if (file.exists("R/visualise_single_sequence.R")) {
    app_files <- system("git ls-files", intern = TRUE)
    app_files <- app_files[app_files != "manifest.json"]
    app_files <- sort(app_files)
    
    rsconnect::writeManifest(
        appDir = ".",
        appFiles = app_files,
        appPrimaryDoc = "app.R",
        appMode = "shiny",
        verbose = TRUE
    )
} else {
    abort("Not in correct directory")
}

