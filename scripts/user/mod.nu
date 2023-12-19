# Templates
export module template {
    export def create [lang:string, project: string, --git (-g), --config(-c)] {
        echo $"Creating new ($lang)  Project named:  ($project)";

        mut temp_path = "";
        if "USER_TEMPLATES" in $env {
            $temp_path = $env.USER_TEMPLATES
        } else {
            $temp_path = "~/.config/nu/templates.json"
        }
        let preset = open $temp_path | get $lang

        #print the config for the lang in the json when the config flag is passed.
        if $config {
            echo "The template used is : \n";
            echo ($preset | to json);
            echo $"the templates are stored in : ($temp_path)";
            echo $"You can change the template.json path by setting the USER_TEMPLATES env variable";
        }

        mkdir $project
        cd $project
        
        # run pre project commands
        if "pre-command" in $preset and ($preset | get pre-commands | length) > 0 {
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
        if "post-command" in $preset and ($preset | get post-commands | length) > 0 {
            for $command in ($preset | get post-commands) {
                nu -c $command
            }
        }
    }
}