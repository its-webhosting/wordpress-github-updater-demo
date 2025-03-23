<div class="wrap">
    <h2>WordPress GitHub Updater Demo</h2>
    <form method="post" action="<?=($isNetwork ? 'settings.php' : 'options-general.php');?>?page=<?=$_GET['page'];?>">
        <?php wp_nonce_field( 'github-updater-demo', 'github_updater_demo_nonce' ); ?>

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
                        Updates will be performed in the way the plugin author has chosen.  Normally, this means only
                        the latest regular release, skipping any pre-releases.
                    </p>
                    <p class="ui_choice ui_simple description">
                        The site owner can choose whether they want to get only regular releases for the plugin, or
                        also releases with either "beta" or "rc" at the start of their
                        <a href="https://semver.org">SemVer</a> pre-release version component.
                    </p>
                    <p class="ui_choice ui_advanced description">
                        The site owner can select between four different types of pre-releases to include when the
                        plugin is upgraded.
                    </p>
                    <p class="ui_choice ui_expert description">
                        The site owner can specify a regular expression.  The latest GitHub release with a name
                        matching this regular expression will be considered the latest version of the plugin.
                    </p>

                </td>
            </tr>

            <tr>
                <th scope="row"><label>Value of <code>match_releases</code></label></th>
                <td>
                    <input type="text" readonly size=50 id="ui_match_releases"
                           name="github_updater_demo_settings[match_releases]"
                           value="<?=(isset($guDemoSettings['match_releases'])
                               ? $guDemoSettings['match_releases'] : '');?>" />
                    <div class="description">
                        <p>A site administrator can override this by running</p>
                        <pre>wp option set github-updater-override-<?=GITHUB_UPDATER_DEMO_SLUG?> '${upgrade_regex}'</pre>
                        <p>
                            where <code>${upgrade_regex}</code> is the value they want for <code>match_releases</code>:
                            a regular expression that will match release names that the plugin should be upgraded to,
                            or an empty string to upgrade the plugin only to the latest normal/production release.
                        </p>
                    </div>
                </td>
            </tr>
        </table>

        <hr/>
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
                        <option value="normal"<?=($guDemoSettings['advanced_update_types'] === 'normal'
                            ? ' selected="selected"' : null);?>>Normal releases</option>
                        <option value="beta"<?=($guDemoSettings['advanced_update_types'] === 'beta'
                            ? ' selected="selected"' : null);?>>Normal and beta / release candidate releases</option>
                        <option value="alpha"<?=($guDemoSettings['advanced_update_types'] === 'alpha'
                            ? ' selected="selected"' : null);?>>Normal, beta/rc, and alpha releases</option>
                        <option value="all"<?=($guDemoSettings['advanced_update_types'] === 'all'
                            ? ' selected="selected"' : null);?>>Normal releases and ALL prereleases</option>
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
                    <input type="text" size=50 id="ui_expert_regex"
                           name="github_updater_demo_settings[expert_regex]"
                           value="<?=(isset($guDemoSettings['advanced_regex']) ? $guDemoSettings['advanced_regex'] : '');?>"
                           placeholder="Regular expression or blank for only normal releases"/>
                    <p class="description">
                        This plugin will update to any release whose version matches this regular expression.  Leave
                        this field blank to update only to regular/production releases.<br /><br />
                        The regular expression should start and end with delimeters (normally <code>/</code>) and
                        then be followed with any flags (normally <code>i</code>).  Example: <code>/test(ing)?/i</code>
                    </p>
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
            let matchReleases = '';
            // These regex will match things that are not actual version numbers, but that's OK. For example,
            // "...-beta1", "000-rcBLAH", "1.2.3.4.5-beta" will all match for "Simple UI, include beta releases"
            if (uiType === 'none') {
                // do nothing
            } else if (uiType === 'simple') {
                matchReleases = $('#ui_simple_prereleases').is(':checked') ? '^v[0-9.]+(-(beta|rc))?' : '';
            } else if (uiType === 'advanced') {
                let updateTypes = $('#ui_advanced_update_types').val();
                if (!$('#ui_advanced_major_version_updates').is(':checked')) {
                    matchReleases = '^v<?=$pluginMajorVersion;?>\\.[0-9.]+';
                } else {
                    if (updateTypes !== 'normal') {
                        matchReleases = '^v[0-9.]+';
                    }
                }
                if (updateTypes === 'normal') {
                    if (matchReleases !== '') {
                        matchReleases += '[^-]*(+.*)?$';
                    }
                } else if (updateTypes === 'beta') {
                    matchReleases += '(-(beta|rc))?';
                } else if (updateTypes === 'alpha') {
                    matchReleases += '(-(alpha|beta|rc))?';
                } else if (updateTypes === 'all') {
                    // accept anything after the patch version number
                }
            } else if (uiType === 'expert') {
                matchReleases = $('#ui_expert_regex').val();
            }
            if ('' !== matchReleases) {
                matchReleases = '/' + matchReleases + '/i';
            }
            $('#ui_match_releases').val(matchReleases);
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
