# wordpress-to-kharites #

Disclaimer: this is just a test for a Kharites sequel branch (may be for DB agnosticism).

Take Wordpress entries and import them into Kharites. All that is needed is Kharites and an exported XML file from your Wordpress blog.

'import.rb' takes a command-line argument: the XML file to be imported into Kharites.

In order to preserve your comments, I'd recommend installing the Disqus plugin for Wordpress and exporting all of your comments to it.

It uses the default sqlite3 database at 'blog.db'. Modify import.rb to change this to your approriate database, though I would recommend trying it out on a small sqlite3 database before using it on your live code.

[ http://www.opensource.org/licenses/mit-license.php](Released under the MIT License:)
