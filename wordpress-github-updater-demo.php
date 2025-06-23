<?php
/**
 * Plugin Name: WordPress GitHub Updater Demo
 * Plugin URI: https://github.com/its-webhosting/wordpress-github-updater-demo/
 * Description: A WordPress plugin to use and test the umdigital/wordpress-github-updater PHP package.
 * Version: 1.0.0
 * Author: Regents of the University of Michigan
 * Author URI: https://umich.edu/
 * Update URI: https://github.com/its-webhosting/wordpress-github-updater-demo/
 */

namespace UMich\GitHubUpdaterDemo;

define( 'GITHUB_UPDATER_DEMO_PATH', dirname( __FILE__ ) . DIRECTORY_SEPARATOR );
define( 'GITHUB_UPDATER_DEMO_SLUG', dirname( plugin_basename( __FILE__ ) ) );

include_once GITHUB_UPDATER_DEMO_PATH . 'vendor' . DIRECTORY_SEPARATOR . 'autoload.php';


class GitHubUpdaterDemo
{
    static private $_settings = [
        'ui_type'                        => 'none',
        'simple_prereleases'             => false,
        'advanced_update_types'          => 'stable',
        'advanced_major_version_updates' => true,
        'expert_regex'                   => '',
	    'match_releases'                 => '',
    ];

    static public function init()
    {

        self::$_settings = array_merge(
	        self::$_settings,
	        get_option( 'github_updater_demo_settings', array() )
        );
        self::$_settings = apply_filters( 'github_updater_demo_settings', self::$_settings );
        // Initialize GitHub Updater
	    new \Umich\GithubUpdater\Init([
	        'repo'           => 'its-webhosting/wordpress-github-updater-demo',
	        'slug'           => plugin_basename( __FILE__ ),
	        'match_releases' => self::$_settings['match_releases'],
        ]);

	    /** ADMIN SETTINGS **/
        if( is_multisite() ) {
            add_action( 'network_admin_menu', function(){
                self::adminMenu( true );
            });
        } else {
	        add_action( 'admin_menu', array( __CLASS__, 'adminMenu' ) );
        }

        // plugin links
        add_filter( 'plugin_row_meta', function( $links, $pluginFile ){
            if( $pluginFile == plugin_basename( __FILE__ ) ) {
                $links[] = '<a href="https://github.com/umdigital/wordpress-github-updater-demo/issues" ' .
                           'target="_blank" title="' .
                           esc_attr__( 'Support', 'wordpress-github-updater-demo' ) .
                           '">' . esc_html__( 'Support', 'wordpress-github-updater-demo' ) . '</a>';
            }
            return $links;
        }, 10, 2 );

        add_filter( 'plugin_action_links_'. plugin_basename( __FILE__ ), function( $links ){
            $links[] = '<a href="'. admin_url( 'options-general.php?page=github_updater_demo' ) .'">Settings</a>';
            return $links;
        });

        add_filter( 'network_admin_plugin_action_links_'. plugin_basename( __FILE__ ), function( $links ){
            $links[] = '<a href="'. network_admin_url( 'settings.php?page=github_updater_demo' ) .'">Settings</a>';
            return $links;
        });

    }


    /***************************/
    /*** ADMIN FUNCTIONALITY ***/
    /***************************/

    /**
     * Plugin setting admin
     */
    static public function adminMenu( $isNetwork = false )
    {
        // HANDLE FORM SAVE
        if( $_POST
            && isset( $_POST['github_updater_demo_nonce'] )
            && wp_verify_nonce( $_POST['github_updater_demo_nonce'], 'github-updater-demo' ) ) {
            $settings = array_filter( $_POST['github_updater_demo_settings'] ?: array(), 'trim' );

	        $hasErrors = false;

			foreach ( $settings as $key => $value ) {
				if ( ! isset( self::$_settings[ $key ] ) ) {
					$hasErrors = true;
					add_settings_error(
						'github_updater_demo_settings_key',
						'error',
						'invalid setting key: ' . esc_html( $key )
                    );
				}
			}

	        if ( isset( $settings['ui_type'])
	             && ! in_array( $settings['ui_type'], [ 'none', 'simple', 'advanced', 'expert' ] ) ) {
				$hasErrors = true;
		        add_settings_error(
			        'github_updater_demo_settings_ui_type',
			        'error',
			        'invalid selection for UI Type'
                );
	        }

			$settings['simple_prereleases'] = isset( $settings['simple_prereleases'] )
			                                  && 'true' === $settings['simple_prereleases'];

	        if ( isset( $settings['advanced_update_types'])
	             && ! in_array( $settings['advanced_update_types'], [ 'stable', 'rc', 'beta', 'alpha', 'all' ] ) ) {
		        $hasErrors = true;
		        add_settings_error(
			        'github_updater_demo_settings_advanced_update_types',
			        'error',
			        'invalid selection for advanced UI updates-to-include'
                );
	        }

	        $settings['advanced_major_version_updates'] = isset( $settings['advanced_major_version_updates'] )
	                                                   && 'true' === $settings['advanced_major_version_updates'];

	        if ( ! empty( $settings['expert_regex'] ) ) {
		        set_error_handler(
					function () use (&$hasErrors) {
						$hasErrors = true;
						add_settings_error(
							'github_updater_demo_settings_expert_regex',
							'error',
							'invalid regular expression (expert)'
                        );
					},
			        E_WARNING
		        );
		        preg_match( $settings['expert_regex'], '' );
				restore_error_handler();
	        }

			if ( ! isset( $settings['match_releases'] )  ) {
				$settings['match_releases'] = '';
			} else if ( '' !== $settings['match_releases'] ) {
                // handle match_releases keywords
                $matchType = 'regex';
                $keywords = explode( ',', $settings['match_releases'] );
                foreach ( $keywords as $kw ) {
                    $kw = trim( $kw );
                    switch ( $kw ) {
                        case 'pinMajor':
                            if ( $matchType == 'regex' ) {
                                $matchType = 'stable';
                            }
                            break;
                        case 'stable':
                            $matchType = 'stable';
                            break;
                        case 'includeRC':
                            $matchType = 'includeRC';
                            break;
                        case 'includeBeta':
                            $matchType = 'includeBeta';
                            break;
                        case 'includeAlpha':
                            $matchType = 'includeAlpha';
                            break;
                        case 'includeAll':
                            $matchType = 'includeAll';
                            break;
                        default:
                            $hasErrors = true;
                            add_settings_error(
                                'github_updater_demo_settings_match_releases',
                                'error',
                                'Internal error: unknown match_releases keyword: ' . $kw
                            );
                            break;
                    }
                }
                if ( $matchType == 'regex' ) {
                    set_error_handler(
					function ($errno, $errstr) use (&$hasErrors) {
						$hasErrors = true;
						add_settings_error(
							'github_updater_demo_settings_match_releases',
							'error',
							'Internal error: invalid regular expression: ' . $errstr
                        );
					},
					E_WARNING
				);
				preg_match( $settings['match_releases'], '' );
				restore_error_handler();
                }
			}

            do_action_ref_array( 'github_updater_demo_admin_settings_save', array( &$settings, &$hasErrors ) );

            // No errors, we can save now
            if( !$hasErrors ) {
				$settings = array_merge( self::$_settings, $settings );
	            update_option( 'github_updater_demo_settings', $settings );
				self::$_settings = $settings;
	            add_settings_error(
		            'github_updater_demo_settings_success',
		            'success',
		            'plugin settings saved',
		            'success'
	            );
            }
        }

        add_submenu_page(
            $isNetwork ? 'settings.php' : 'options-general.php',
            'GitHub Updater Demo',
            'GitHub Updater Demo',
            'administrator',
            'github_updater_demo',
            function() use ( $isNetwork ) {
                $guDemoSettings = self::$_settings;
	            $pluginData     = get_plugin_data( __FILE__ );
				$pluginMajorVersion   = explode( '.', $pluginData['Version'] )[0];
                include GITHUB_UPDATER_DEMO_PATH . 'templates' . DIRECTORY_SEPARATOR . 'admin.tpl';
            }
        );
    }

}
GitHubUpdaterDemo::init();
