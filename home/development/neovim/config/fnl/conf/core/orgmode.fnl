(import-macros {: wkmap! : setup!} :lib.macros)

(local orgmode (require :orgmode))
(local root "~/Documents/org")

(orgmode.setup_ts_grammar)

(setup! orgmode
        {:org_agenda_files [(.. root "/*")]
         :org_default_notes_file (.. root :/notes.org)
         :org_capture_templates {:t {:description :Todo
                                     :template "* TODO %?\n  %U\n"
                                     :target (.. root :/inbox.org)}
                                 :e {:description :Event
                                     :template "* %?\n  %U\n"
                                     :target (.. root :/cal.org)}
                                 :j {:description :Journal
                                     :template "* %<%Y-%m-%d> %<%A>\n** %U\n   %?\n"
                                     :target (.. root :/journal.org)}}})

(wkmap! {:o {:name "Org mode"}} {:prefix :<leader>})

