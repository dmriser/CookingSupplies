      subroutine hel_get(evn,hel)
      
      integer ier,off,evn,hel,first
      integer ev0b,ev1b,ev1c,ev2b,ev2c,ev3a,ev3b
      common/helv/ev0b,ev1b,ev1c,ev2b,ev2c,ev3a,ev3b,diff,n
      logical good_diff
      
      integer hel1,hel2,hel3
      common/heli/hel1,hel2,hel3
 
      data off/8/first/1/
      hel = 2
      
                             
      if (first.eq.1) then
                               
         n=1
         call hgnt(13,n,ier)
         ev0b = hel2
         ev1b = hel2
         ev1c = hel3
                            
         call hgntf(13,n+1,ier)
         ev2b = hel2
         ev2c = hel3
                      
         call hgntf(13,n+off,ier)
                            
         ev3a = hel1
         ev3c = hel3
         diff = (ev3c-ev1c)/off
         good_diff = diff.gt.32500.and.diff.lt.35000
         first = 0
      endif
      
      if (evn.lt.ev0b) return
 
                             
      if (evn.ge.ev1b.and.evn.lt.ev2b) then
                              
         hel = 2
         if (good_diff) hel = ev3a
      else
                          
         ev1b=ev2b
         ev1c=ev2c
                           
         n=n+1
         call hgntf(13,n+1,ier)
         ev2b = hel2
         ev2c = hel3
                         
         call hgntf(13,n+off,ier)
                             
         ev3a = hel1
         ev3c = hel3
         diff = (ev3c-ev1c)/off
         good_diff = diff.gt.32500.and.diff.lt.35000
         hel = 2
                             
         if (good_diff) hel = ev3a
      endif
      
                              
      end
      
