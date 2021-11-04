# Release process

- Update version number in `DESCRIPTION`.
- Publish a Github release (Octave package will be automatically produced and uploaded on the release page).
- On `debian` branch, update `debian/changelog`.
- Manually trigger the `Release Debian` Github workflow (deb packages will be produced on OBS).
