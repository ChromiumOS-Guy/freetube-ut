#!/usr/bin/python3
'''
 Copyright (C) 2022  UBPorts

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; version 3.

 udeb is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
'''
import os
import sys

basedir = os.path.dirname(os.path.abspath(__file__))

#### Functions
def scalingdevidor(GRID_PX : int = int(os.environ["GRID_UNIT_PX"])) -> int:
  if GRID_PX >= 21: # seems to be what most need if above or at 21 grid px
    return 8
  elif GRID_PX <= 16: # this one i know because my phone is 16 so if it seems weird don't worry it works.
    return 12
  else: # throw in the dark but lets hope it works
    return 10


#### freetube-ut variables:
#os.environ["GDK_SCALE"]=str(float(os.environ["GRID_UNIT_PX"]/8)) # old
os.environ["GDK_DPI_SCALE"]=str(float(os.environ["GRID_UNIT_PX"])/scalingdevidor())
os.environ["GTK_IM_MODULE"] = "Maliit"
os.environ["GTK_IM_MODULE_FILE"] = "{basedir}/lib/@CLICK_ARCH@/gtk-3.0/3.0.0/immodules/immodules.cache"
os.environ["PATH"] = f"{os.environ.get('PATH', '')}:/usr/lib/aarch64-linux-gnu/dri:/android/vendor/lib64:lib:lib/@CLICK_ARCH@:{basedir}/app/usr/sbin"
# AppRun script Additions:
#os.environ["PATH"] = f"{os.environ.get('PATH', '')}:{basedir}/app/usr/sbin" # we add this in the above code ^ already.
os.environ["LD_LIBRARY_PATH"] = f"{basedir}/app/usr/lib:{os.environ.get('LD_LIBRARY_PATH', '')}"
os.environ["XDG_DATA_DIRS"] = f"{basedir}/app/usr/share/:./share/:/usr/share/gnome:/usr/local/share/:/usr/share/:{os.environ.get('XDG_DATA_DIRS', '')}:/usr/share/gnome/:/usr/local/share/:/usr/share/"
os.environ["GSETTINGS_SCHEMA_DIR"] =f"{basedir}/app/usr/share/glib-2.0/schemas:{os.environ.get('GSETTINGS_SCHEMA_DIR', '')}"


#HOME = os.environ.get('HOME', '')
#os.environ["HOME"] = HOME + "/.config/freetube-ut.chromiumos-guy"

if len(sys.argv) > 1:
    url_to_open = sys.argv[1]
    # Pass the URL as an argument to freetube
    # The first argument to execlp after the executable name is argv[0] for the new process,
    # so we repeat "app/AppRun" and then add the actual arguments.
    os.execlp(f"{basedir}/app/freetube", "freetube", "--new-window", url_to_open) # "--ozone-platform=wayland" for wayland
else:
    # If no URL is provided, just launch freetube normally
    os.execlp(f"{basedir}/app/freetube","freetube")

#os.environ["HOME"] = HOME 