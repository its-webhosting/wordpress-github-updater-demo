WordPress GitHub Updater Library Demo
=====================================
[![GitHub release](https://img.shields.io/github/release/its-webhosting/wordpress-github-updater-demo.svg)](https://github.com/its-webhosting/wordpress-github-updater-demo/releases/latest)
[![GitHub issues](https://img.shields.io/github/issues/its-webhosting/wordpress-github-updater-demo.svg)](https://github.com/its-webhosting/wordpress-github-updater-demo/issues)

WordPress plugin for using and testing the [umdigital/wordpress-github-updater](https://github.com/umdigital/wordpress-github-updater) PHP package.

## Install

### WP CLI Method
```bash
plugin_repo="its-webhosting/wordpress-github-updater-demo"

plugin_url=$(curl -s "https://api.github.com/repos/${plugin_repo}/releases/latest | jq -r .zipball_url)

wp plugin install "${plugin_url}" --activate
```
### WP Admin/Dashboard Method
*This requires that your site has write access to the plugins folder.*
1. Download the [latest package](https://github.com/its-webhosting/wordpress-github-updater-demo/releases/latest) *(example: `wordpress-github-updater-demo-x.x.x.zip`)*
2. Go to WP Admin/Dashboard -> Plugins -> Add New -> Upload Plugin
3. Select the downloaded zip file and Upload
4. Activate Plugin
### Manual Method
1. Download the [latest package](https://github.com/its-webhosting/wordpress-github-updater-demo/releases/latest) *(example: `wordpress-github-updater-demo-x.x.x.zip`)*
2. Extract zip
3. Upload the `wordpress-github-updater-demo` folder to `wp-content/plugins/` folder in your site
4. Activate Plugin

## Usage
1. Go to WP Admin/Dashboard -> Settings -> GitHub Updater Demo
2. Pick the settings you want and save them.
3. Future updates of the `wordpress-github-updater-demo` plugin will be made according to those settings.
4. For more details, see the [`umdigital/wordpress-github-updater` library documentation](https://github.com/umdigital/wordpress-github-updater).

## Support
[Open an issue](https://github.com/its-webhosting/wordpress-github-updater-demo/issues), or contact [webmaster@umich.edu](mailto:webmaster@umich.edu).

## Roadmap
### `wordpress-github-updater-demo` plugin
* Support forking and creating releases in the forked repo:
  * Add a setting to specify a fork of the `wordpress-github-updater-demo` plugin repo to check for updates.
  * Add a GitHub Action to easily create a new release of the `wordpress-github-updater-demo` plugin when a new release of the `umdigital/wordpress-github-updater` plugin.
* Add support for non-SemVer version numbers: a checkbox (checked by default) that when unchecked will generate non-SemVer regexes.


### `umdigital/wordpress-github-updater` library
These enhancements will have corresponding changes to the `wordpress-github-updater-demo` plugin to allow them to be tested.
* Allow downgrading to a previous version of a plugin:
  * Save the previously installed version in the options and add a UI button for a two-click undo of an upgrade (first click on the button, second click to confirm the reversion).
  * Allow picking any available version from a dropdown list of all plugin releases.
* Allow substitution variables in the `match_releases` regex:
  * `{{major_version}}` - replace with the major version number of the currently installed plugin. This will allow easier pinning of updates to the current major version (right now, the version number has to be hard-coded in the regex).
* Add PSR-4 compatibility and get rid of the `.autoload.files` hack.  This will probably be a breaking change for a 2.0 release.
