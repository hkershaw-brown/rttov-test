! Data Assimilation Research Testbed -- DART
! Copyright 2004-2007, Data Assimilation Research Section
! University Corporation for Atmospheric Research
! Licensed under the GPL -- www.gpl.org/licenses/gpl.html

program trans_date_to_dart

! <next few lines under version control, do not edit>
! $URL$
! $Id: trans_date_to_dart.f90 2713 2007-03-26 04:09:04Z thoar $
! $Revision$
! $Date: 2007-03-26 00:09:04 -0400 (Mon, 26 Mar 2007) $

!----------------------------------------------------------------------
! purpose: generate a Gregorian/DART date & time from standard date and time
!
! method: Read ASCII input(/output) file containing yyyy/mm/dd hh:mm:ss . 
!         Reform time and date into form needed by DART.
!         Write out CAM time and date to i/o file for use in input.nlm . 
!
! author: Kevin Raeder 8/18/03
!
!----------------------------------------------------------------------

use utilities_mod,    only : get_unit, initialize_utilities, finalize_utilities
use time_manager_mod, only : time_type, write_time, &
                             get_time, set_time, get_date, set_date, &
                             set_calendar_type, GREGORIAN, get_calendar_type

implicit none

! version controlled file description for error handling, do not edit
character(len=128), parameter :: &
   source   = "$URL$", &
   revision = "$Revision$", &
   revdate  = "$Date: 2007-03-26 00:09:04 -0400 (Mon, 26 Mar 2007) $"

integer               :: calendar_type = GREGORIAN
integer               :: file_unit, seconds, &
                         year, month, day, hour, minute, second, &
                         cam_date, cam_tod
type(time_type)       :: dart_time
character (len = 128) :: file_name = 'date_greg'

call initialize_utilities('Trans_date_to_dart')

call set_calendar_type(calendar_type)
! debug
seconds = get_calendar_type()
PRINT*,'calendar type = ',seconds

file_unit = get_unit()
PRINT*,'file_unit = ',file_unit

! read in date and time 
open(unit = file_unit, file = file_name, status='old',form='formatted')
read(file_unit, '(I4,5(1X,I2))') year, month, day, hour, minute, second
PRINT*,'read in date = ',year, month, day, hour, minute, second

! create and write DART date (Gregorian)
dart_time = set_date(year, month, day, hour, minute, second)
call write_time (file_unit,dart_time)

! create and write CAM date
cam_date = (year)*10000 + month*100 + day
cam_tod  = hour*3600 + minute*60 + second
write (file_unit,'(2I8)') cam_date, cam_tod

close(unit = file_unit)

call finalize_utilities()

end program trans_date_to_dart
