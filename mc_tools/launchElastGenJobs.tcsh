#!/bin/tcsh 

set n_jobs = $1 
set c_job  = 0

# if we want to start at a different number than 0, pass as arg 2
if ($2 != "") then 
    set c_job = $2
    @ n_jobs += $c_job
endif

while ($c_job < $n_jobs)
      sed "s/jobidnum/$c_job/" elasticTemplate.jsub > temp.elast.jsub
      jsub temp.elast.jsub
      rm temp.elast.jsub
      @ c_job++
      echo " > done job $c_job of $n_jobs \n"
end

