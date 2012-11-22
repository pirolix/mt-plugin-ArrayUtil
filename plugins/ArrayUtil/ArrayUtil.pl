package MT::Plugin::Util::OMV::ArrayUtil;
# ArrayUtil (C) 2012 Piroli YUKARINOMIYA (Open MagicVox.net)
# This program is distributed under the terms of the GNU General Public License, version 3.
# $Id$

use strict;
use warnings;
use MT 4.1;

use vars qw( $VENDOR $MYNAME $FULLNAME $VERSION );
$FULLNAME = join '::',
        (($VENDOR, $MYNAME) = (split /::/, __PACKAGE__)[-2, -1]);
(my $revision = '$Rev$') =~ s/\D//g;
$VERSION = 'v0.10'. ($revision ? ".$revision" : '');

use base qw( MT::Plugin );
my $plugin = __PACKAGE__->new ({
    id => $FULLNAME,
    key => $FULLNAME,
    name => $MYNAME,
    version => $VERSION,
    author_name => 'Open MagicVox.net',
    author_link => 'http://www.magicvox.net/',
    plugin_link => 'http://www.magicvox.net/archive/2012/11222040/', # Blog
    doc_link => "http://lab.magicvox.net/trac/mt-plugins/wiki/$MYNAME", # tracWiki
    description => <<'HTMLHEREDOC',
<__trans phrase="Supply useful template tags for handling Array/Hash variables.">
HTMLHEREDOC
    registry => {
        tags => {
            help_url => "http://lab.magicvox.net/trac/mt-plugins/wiki/$MYNAME#tag-%t",
            block => {
                # Unified from IsInArray plugin
                # @see http://www.magicvox.net/archive/2010/10072217/
                'IsInArray?' => "${FULLNAME}::Tags::IsInArray",
                'IsInHash?' => "${FULLNAME}::Tags::IsInArray",

                'SetHashVars' => "${FULLNAME}::Tags::SetHashVars",
                'SetArrayVars' => "${FULLNAME}::Tags::SetArrayVars",
                'SetForeachArrayVars' => "${FULLNAME}::Tags::SetForeachArrayVars",
            },
        },
    },
});
MT->add_plugin ($plugin);

1;