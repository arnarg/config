(fn wkmap! [map conf]
  `(let [wk# (require :which-key)]
     (wk#.register ,map ,conf)))

(fn setup! [plugin conf?]
  `((. ,plugin :setup) ,conf?))

{: wkmap!
 : setup!}
