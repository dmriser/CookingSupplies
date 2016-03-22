      subroutine hel_init(runno)

  
      integer iquest,ierr,nentries
      character*12 fname
      character*5 runi
      integer runno
      
      parameter (nwpawc = 5000000)
      common/pawc/ipaw(nwpawc)
      common/quest/iquest(100)
      
      integer hel1,hel2,hel3
      common/heli/hel1,hel2,hel3

      write(runi,'(I5)')runno
    
      fname='hel'//runi//'.rzn'
      call hlimit(nwpawc)
      
      iquest(10) = 65000
      
c     print *, 'hel_init: Opening ntuple ',fname
      call hropen(1,'infile',fname,' ',8191,ierr)
      call hrin(13,999,0)
      
c     print *, 'hel_init: ID13 CLEAR and SET'
      call hbname(13,' ',0,'$CLEAR')
      call hbname(13,'HELI',hel1,'$SET')
      call hnoent(13,nentries)
      
c     print *, 'hel_init: Ntuple has ',nentries,' entries'
      
      end
