#!/bin/tcsh 

set fvals = (0.75 0.80 0.85 0.90 0.95 1.00 1.05 1.10 1.15 1.20 1.25)

foreach f ($fvals) 
    echo " > jobs current f = $f"
    cp gppjsubtemplate temp.$f.jsub
    sed -i "s/fvalkey/$f/" temp.$f.jsub
    jsub temp.$f.jsub
end

rm temp.*.jsub
