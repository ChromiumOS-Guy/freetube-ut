# FreeTube UT

FreeTube UT is a privacy-focused YouTube client for Ubuntu Touch, built on top of the popular FreeTube platform. Enjoy ad-free and sponsor-free video streaming, while keeping your personal data safe. As a free and open-source software (FOSS), you can trust that your privacy is respected.


Something in the way i path freetube or pack it breaks OSK, this is consistant and sometimes i get a build that has working OSK and i have no idea how or why this happens.

MESA_LOADER is hardcoded so no wayland until that gets fixed and you can't submit an issue to freetube because they don't allow non-contributors to port new issues on github.

Is affected by this [bug](https://gitlab.com/ubports/development/core/lomiri/-/merge_requests/207), and all the Xwayland bugs and problems.

Can support focal i just opted to use Noble sdk.

## License

Copyright (C) 2025  ChromiumOS-Guy

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License version 3, as published by the
Free Software Foundation.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranties of MERCHANTABILITY, SATISFACTORY
QUALITY, or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
for more details.

You should have received a copy of the GNU General Public License along with
this program. If not, see <http://www.gnu.org/licenses/>.
