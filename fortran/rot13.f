C       http://www.miranda.org/~jkominek/rot13/fortran/rot13.f
	program rot
	character*1 in(52),out(52)
	integer i,j
	integer*2 length
	
	byte bin(52),bout(52)
	equivalence(bin,in)
	equivalence(bout,out)
	character*16384 test
	logical found

	do i=1,26
	   bin(i)=ichar('A')-1 +i
	   bin(i+26) = ichar('a') -1 +i
	end do
	do i=1,13
	   bout(i)=ichar('N')-1 +i
	   bout(i+13) = ichar('A')-1+i
	   bout(i+26)=ichar('n')-1 +i 
	   bout(i+39)=ichar('a')-1+i
	end do
	read (5,'(a)')test
	do i=len(test),1,-1
	  if (test(i:i) .ne. ' ') then
	     length=i
	     goto 101
	  end if
	end do
101	continue ! :)
	do i=1,length
	   found = .false.
	   do j=1,52
		if (test(i:i) .eq. in(j)) then 
		   write(6,'(a,$)')out(j)
		   found = .true.
		end if
	   end do
	   if (.not. found) write(6,'(a,$)')test(i:i)
	end do
	write(6,'(1x)')
	end

