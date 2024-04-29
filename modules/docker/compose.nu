def --wrapped with-flag [...flag] {
    if ($in | is-empty) { [] } else { [...$flag $in] }
}

def "nu-complete compose projects" [] {
  compose-project-list
  | each { { value: $in.name, description: $in.config_files } }
}

export def compose-project-list [] {
  ^$env.docker-cli compose ls --format json
  | from json
  | rename name status config_files
}

export def compose-down [
  --file(-f): path
  --project-name(-p): string@"nu-complete compose projects"
  ...rest
] {
  ^$env.docker-cli compose ...($file | with-flag -f) ...($project_name | with-flag -p) down ...$rest
}

export def compose-up [
  --file(-f): path
  --project-directory: path
  --detach(-d) # Start in detached mode
  ...rest
] {
  ^$env.docker-cli compose ...($file | with-flag -f) ...($project_directory | with-flag --project-directory) up ...(if ($detach) { [-d] } else { [] }) ...$rest
}
