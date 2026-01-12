## Must be run in top-level ggDNAvis directory
if (file.exists("R/visualise_single_sequence.R")) {
    rsconnect::writeManifest(
        appDir = getwd(),
        appFiles = system("git ls-files", intern = TRUE),
        appPrimaryDoc = "inst/shinyapp/app.R",
    )
} else {
    abort("Not in correct directory")
}
