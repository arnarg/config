(fn wkmap! [map conf]
  `(let [wk# (require :which-key)]
     (wk#.register ,map ,conf)))

{: wkmap!}
