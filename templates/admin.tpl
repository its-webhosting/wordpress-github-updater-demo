<div class="wrap">
    <h2>WordPress GitHub Updater Demo</h2>
    <form method="post" action="<?=($isNetwork ? 'settings.php' : 'options-general.php');?>?page=<?=$_GET['page'];?>">
        <?php wp_nonce_field( 'github-updater-demo', 'github_updater_demo_nonce' ); ?>

        <h3 style="margin-bottom: 0">Upgrade settings for this plugin (WordPress GitHub Updater Demo)</h3>

        <table class="form-table">

            <tr class="ui_choice ui_none">
                <td colspan="2">(no UI / settings)</td>
            </tr>

            <tr class="ui_choice ui_simple">
                <th scope="row">Test Beta Releases</th>
                <td>
                    <label for="ui_simple_prereleases">
                        <input type="checkbox" id="ui_simple_prereleases"
                               name="github_updater_demo_settings[simple_prereleases]"
                               value="true"<?=(true === $guDemoSettings['simple_prereleases'] ? ' checked' : null);?>/>
                        Update to beta versions of this plugin when they become available.
                    </label>
                </td>
            </tr>

            <tr class="ui_choice ui_advanced">
                <th scope="row"><label for="ui_advanced_update_types">When Updating this Plugin, Include</label></th>
                <td>
                    <select id="ui_advanced_update_types" name="github_updater_demo_settings[advanced_update_types]">
                        <option value="stable"<?=($guDemoSettings['advanced_update_types'] === 'stable'
                            ? ' selected="selected"' : null);?>>Stable releases</option>
                        <option value="rc"<?=($guDemoSettings['advanced_update_types'] === 'rc'
                            ? ' selected="selected"' : null);?>>Release candidate releases</option>
                        <option value="beta"<?=($guDemoSettings['advanced_update_types'] === 'beta'
                            ? ' selected="selected"' : null);?>>Stable and beta / release candidate releases</option>
                        <option value="alpha"<?=($guDemoSettings['advanced_update_types'] === 'alpha'
                            ? ' selected="selected"' : null);?>>Stable, beta/rc, and alpha releases</option>
                        <option value="all"<?=($guDemoSettings['advanced_update_types'] === 'all'
                            ? ' selected="selected"' : null);?>>Stable releases and ALL prereleases</option>
                    </select>
                </td>
            </tr>
            <tr class="ui_choice ui_advanced">
                <th scope="row">Major Version Updates</th>
                <td>
                    <label for="ui_advanced_major_version_updates">
                        <input type="checkbox" id="ui_advanced_major_version_updates"
                               name="github_updater_demo_settings[advanced_major_version_updates]"
                               value="true"<?=( true === $guDemoSettings['advanced_major_version_updates']
                                   ? ' checked' : null);?>/>
                        Update to new major versions of the plugin when they become available.
                    </label>
                </td>
            </tr>

            <tr class="ui_choice ui_expert">
                <th scope="row"><label for="ui_expert_regex">Regex for Updates to Include</label></th>
                <td>
                    <code>/</code>
                        <input type="text" size=50 id="ui_expert_regex"
                               name="github_updater_demo_settings[expert_regex]"
                               value="<?=(isset($guDemoSettings['advanced_regex']) ? $guDemoSettings['advanced_regex'] : '');?>"
                               placeholder="Regular expression or blank for only stable releases"/>
                    <code>/i</code>
                    <p class="description">
                        This plugin will update to any published release whose version matches this regular expression.
                        Leave this field blank to update only to stable releases.
                    </p>
                </td>
            </tr>

        </table>

        <hr />
        <h3 style="margin-bottom: 0">Library configuration for <code>wordpress-github-updater</code></h3>
        <p>
            The UI type you select below affects what fields are available above. The values you select in the fields
            above will affect the value for <code>match_releases</code> as well as the regular expression below.
        </p>

        <table class="form-table">
            <tr>
                <th scope="row"><label for="ui_type">UI Type to Demo</label></th>
                <td>
                    <select id="ui_type" name="github_updater_demo_settings[ui_type]">
                        <option value="none"<?=($guDemoSettings['ui_type'] === 'none'
                            ? ' selected="selected"' : null);?>>No UI</option>
                        <option value="simple"<?=($guDemoSettings['ui_type'] === 'simple'
                            ? ' selected="selected"' : null);?>>Simple</option>
                        <option value="advanced"<?=($guDemoSettings['ui_type'] === 'advanced'
                            ? ' selected="selected"' : null);?>>Advanced</option>
                        <option value="expert"<?=($guDemoSettings['ui_type'] === 'expert'
                            ? ' selected="selected"' : null);?>>Expert</option>
                    </select>
                    <p class="ui_choice ui_none description">
                        <b>No UI:</b> Updates will be performed in the way the plugin author has chosen.  Normally, this
                        means only the latest stable release, skipping any pre-releases.
                    </p>
                    <p class="ui_choice ui_simple description">
                        <b>Simple:</b> The site owner can choose whether they want to get only stable releases of the
                        plugin, or also releases with either "beta" or "rc" at the start of their
                        <a href="https://semver.org">SemVer</a> pre-release version component.
                    </p>
                    <p class="ui_choice ui_advanced description">
                        <b>Advanced:</b> The site owner can select between five different types of pre-releases to
                        include when the plugin is upgraded.
                    </p>
                    <p class="ui_choice ui_expert description">
                        <b>Expert:</b> The site owner can specify a regular expression.  The highest version number
                        published GitHub release with a name matching this regular expression will be considered as
                        the latest version of the plugin.
                    </p>

                </td>
            </tr>

            <tr>
                <th scope="row"><label for="ui_match_releases">Value of <code>match_releases</code></label></th>
                <td>
                    <input type="text" readonly size=50 id="ui_match_releases"
                           name="github_updater_demo_settings[match_releases]"
                           value="<?=(isset($guDemoSettings['match_releases'])
                               ? $guDemoSettings['match_releases'] : '');?>" />
                    <div class="description">
                        <p>A site administrator can override this by running</p>
                        <pre>wp option set github-updater-override-<?=GITHUB_UPDATER_DEMO_SLUG?> '${value}'</pre>
                        <p>
                            <code>match_releases</code> can be a comma separated list of case-sensitive keywords in
                            the table below, with the latter keywords overriding earlier ones:
                        </p>
                        <br />
                        <style>
                            .wp-gh-up-settings {
                                border-collapse: collapse;
                                width: 100%;
                            }
                            .wp-gh-up-settings th, .wp-gh-up-settings td {
                                border: 1px solid #ddd;
                                padding: 8px;
                            }
                            .wp-gh-up-settings th {
                                background-color: #ddd;
                                text-align: left;
                            }
                        </style>
                        <table class="wp-gh-up-settings">
                            <thead>
                                <tr>
                                    <th style="width: 15%;">Name</th>
                                    <th>Description</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td><code>stable</code></td>
                                    <td>Upgrade only to published, stable releases</td>
                                </tr>
                                <tr>
                                    <td><code>includeRC</code></td>
                                    <td>Published release candidates (<code>-rc1</code>, ...) and stable releases</td>
                                </tr>
                                <tr>
                                    <td><code>includeBeta</code></td>
                                    <td>Published beta releases, RCs, and stable releases</td>
                                </tr>
                                <tr>
                                    <td><code>includeAlpha</code></td>
                                    <td>Published alphas, betas, RCs, and full releases</td>
                                </tr>
                                <tr>
                                    <td><code>includeAll</code></td>
                                    <td>Upgrade to the published release with the largest version number,
                                        regardless of type</td>
                                </tr>
                                <tr>
                                    <td><code>pinMajor</code></td>
                                    <td>Stay on the major version of the currently installed plugin</td>
                                </tr>
                            </tbody>
                        </table>
                        <br />
                        <p>
                            Otherwise, `match_releases` will be used as a regular expression and the published release
                            with the <i>highest <a href="https://semver.org/">SemVer version number</a></i> (not the
                            latest date!) that matches the regex will be compared against the current version of the
                            plugin to determine if an upgrade is available for the plugin.
                        </p>
                        <p>An empty string is equivalent to 'stable'.</p>
                    </div>
                </td>
            </tr>
            <tr>
                <th scope="row"><label for="ui_match_releases_regex">Equivalent regular expression</code></label></th>
                <td>
                    <input type="text" readonly size=50 id="ui_match_releases_regex"
                           value="<?=(isset($guDemoSettings['match_releases_regex'])
                               ? $guDemoSettings['match_releases_regex'] : '');?>" />
                    <div class="description">
                        <p>
                            The value of <code>match_releases</code> above will select releases that match this
                            regular expression.
                        </p>
                    </div>
                </td>
            </tr>
        </table>

        <?php submit_button(); ?>
    </form>
</div>

<script>
    (function($){
        function updateMatchReleases() {
            let uiType = $('#ui_type').val();
            let matchReleases = 'stable';
            let matchReleasesRegex = '^v?[0-9.]+\+?';
            // These regex will match things that are not actual version numbers, but that's OK. For example,
            // "...-beta1", "000-rcBLAH", "1.2.3.4.5-beta" will all match for "Simple UI, include beta releases"
            if (uiType === 'none') {
                // do nothing
            } else if (uiType === 'simple') {
                if ($('#ui_simple_prereleases').is(':checked')) {
                    matchReleases = 'includeBeta';
                    matchReleasesRegex = '^v?[0-9.]+(-(beta|rc))?';
                }
            } else if (uiType === 'advanced') {
                let updateTypes = $('#ui_advanced_update_types').val();
                let pinMajor = ''
                if (!$('#ui_advanced_major_version_updates').is(':checked')) {
                    pinMajor = ',pinMajor';
                    matchReleasesRegex = '^v?<?=$pluginMajorVersion;?>\\.[0-9.]+';
                } else {
                    if (updateTypes !== 'stable') {
                        matchReleasesRegex = '^v?[0-9.]+';
                    }
                }
                if (updateTypes === 'stable') {
                    matchReleases = 'stable';
                    if (matchReleasesRegex !== '') {
                        matchReleasesRegex += '[^-]*(+.*)?$';
                    }
                } else if (updateTypes === 'rc') {
                    matchReleases = 'includeRC';
                    matchReleasesRegex += '(-rc)?';
                } else if (updateTypes === 'beta') {
                    matchReleases = 'includeBeta';
                    matchReleasesRegex += '(-(beta|rc))?';
                } else if (updateTypes === 'alpha') {
                    matchReleases = 'includeAlpha';
                    matchReleasesRegex += '(-(alpha|beta|rc))?';
                } else if (updateTypes === 'all') {
                    matchReleases = 'includeAll';
                    // accept anything after the patch version number
                }
                matchReleases += pinMajor;
            } else if (uiType === 'expert') {
                matchReleasesRegex = $('#ui_expert_regex').val();
                matchReleases = '/' + matchReleasesRegex + '/i';
            }
            if ('' !== matchReleasesRegex) {
                matchReleasesRegex = '/' + matchReleasesRegex + '/i';
            }
            $('#ui_match_releases').val(matchReleases);
            $('#ui_match_releases_regex').val(matchReleasesRegex);
        }
        $(document).ready(function() {
            $('#ui_type').on('change', function() {
                // Hide all sections
                $('.ui_choice').hide();

                // Show the UI for the selected value
                let selectedUI = $(this).val();
                if (selectedUI === 'none') {
                    $('.ui_none').show();
                } else if (selectedUI === 'simple') {
                    $('.ui_simple').show();
                } else if (selectedUI === 'advanced') {
                    $('.ui_advanced').show();
                } else if (selectedUI === 'expert') {
                    $('.ui_expert').show();
                }
                updateMatchReleases();
            }).trigger('change');
            // call updateMatchReleases when the other fields change
            $('#ui_simple_prereleases, #ui_advanced_update_types, #ui_advanced_major_version_updates')
                .on('change', updateMatchReleases);
            $('#ui_expert_regex').on('input', updateMatchReleases);
        });
    })(jQuery);
</script>
