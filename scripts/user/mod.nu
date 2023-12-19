# Templates
export module template {
    export def create [lang:string, project: string, --git (-g)] {
        echo $"Creating New C++ Cmake Project:  ($project)";
        let preset = open "~/.config/nu/templates.json" | get $lang
        mkdir $project
        cd $project
        # run pre project commands
        if ($preset | get pre-commands | length) > 0 {
            for $command in ($preset | get pre-commands) {
                nu -c $command
            }
        }

        # create directories and files
        for $dir in ($preset | get directories) {
            mkdir $"($dir)"
        }
        for $file in ($preset | get files) {
            touch $"($project)/($file)"
        }

        # init git repo
        if $git {
            git init;
            touch ".gitignore";
        }

        # run post project commands
        if ($preset | get post-commands | length) > 0 {
            for $command in ($preset | get post-commands) {
                nu -c $command
            }
        }
    }
}