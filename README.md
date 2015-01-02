bash-last-logins
================

Show last logins ( Today, Yesterday) and still opened ssh connections. It adds a slight delay login in to your machine. 


Based on the work of IQAndreas : [bash-last-login](https://github.com/IQAndreas/bash-last-login). It now also shows today and yesterday's logins.
It uses the [since](https://github.com/IQAndreas/bash-last-login/blob/master/since) without modifications.

# USAGE 

1. source the file bash-last-logins
  * edit your .bashrc or .bash_profile, 
  * and add the line ``` source /path/to/bash-last-logins ```
2. Make since.bash excutable and copy it to your PATH
  * ``` chmod +x since.bash ```
  * example: copy the file to /usr/local/bin/since

# OUTPUT
![Today with active connections shown, none yesterday](https://raw.githubusercontent.com/LC43/bash-last-logins/master/bash-last-logins-screenshot.png)


# LICENSE

IQAndreas didn't have any license, so i pick this one, if this is ok.

bash-last-logins

Copyright (C) 2014  43LCWebStudio

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
