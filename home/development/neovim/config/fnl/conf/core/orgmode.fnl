(import-macros {: wkmap! : setup!} :lib.macros)

(local orgmode (require :orgmode))
(local root "~/Documents/org")

(orgmode.setup_ts_grammar)

(setup! orgmode
        {:org_agenda_files [(.. root "/*")]
         :org_default_notes_file (.. root :/notes.org)
         :org_capture_templates {:t {:description :Todo
                                     :template "* TODO %?\n %u"
                                     :target (.. root :/todo.org)}
                                 :e :Event
                                 :eo {:description :one-time
                                      :template "** %?\n %T"
                                      :target (.. root :/calendar.org)
                                      :headline :one-time}
                                 :j {:description :Jornal
                                     :template "
*** %<%Y-%m-%d> %<%A>
**** %U

%?"
                                     :target (.. root :/journal.org)}}})

(wkmap! {:o {:name "Org mode"}} {:prefix :<leader>})

