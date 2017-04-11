#!/usr/bin/perl
#############################################
#                                           #
#  Anleiten zum Benutzen des spaceapibots:  #
#                                           #
#  Änder die globale Variablen              #
#                          und habe Spaß!   #
#                                           #
#  Für Mehr Details und Abhängigkeiten:     #
#              Lies die README.md           #
#  https://github.com/see-base/spaceapi-bot #
#                                           # 
#############################################
use strict;                     # Good practice
use warnings;                   # Good practice
use Irssi;                      # Für den Bot
use Config::IniFiles;           # From CPAN
use LWP::Simple;                # From CPAN
use JSON qw( decode_json );     # From CPAN
use Switch;
use vars qw($VERSION %IRSSI);
$VERSION = "1.0";
%IRSSI = (
    authors         => "L3D",
    contact         => 'l3d@see-base.de',
    name            => "spaceapi-bot",
    description     => "A irssi bot to change the status of hackerspaces in the spaceapi.",
    version         => "0.1",
    status			=> "alpha",
    license         => "GPL-3.0"
);
## important global Variables:
# For the IRC:
our $main_channel = "see-base|ponyville"; #    Use '|' for multiple channels
our @keyword = ("space", "see-base", "toolbox"); # First parameter is a for the default space!
our @open = ("$keyword[0] open|$keyword[1] open", "$keyword[2] open"); # to change state to open
our @closed = ("$keyword[0] closed|$keyword[1] closed", "$keyword[2] closed"); # to change state to closed
our @show = ("$keyword[0]|$keyword[1]", "$keyword[2]");
# Global Parameters:
our $url = "https://bodensee.space/cgi-bin/togglestate?";


# programm
our $user = getpwuid( $< );
Irssi::signal_add 'message public', 'sig_message_public';
# Konfigurationsdateien einlesen
my $ini = Config::IniFiles->new( -file => "/home/$user/.irssi/spaceapi-bot/config/token.ini" ) or die;

sub sig_message_public {
    my ($server, $msg, $nick, $nick_addr, $target) = @_;
    if ($target =~ m/#(?:$main_channel)/) { # only operate in these channels
        # listen to keyword to do something:
        my $int = 0;
        foreach (@open){
            if ($msg =~ m/!(?:$open[$int])/i){ # listening for "!$keyword open"
                my $answer = space("open", $keyword[$int+1]);
                $server->command("msg $target Hey $nick, $answer.");
            }elsif ($msg =~ m/!(?:$closed[$int])/i){ # listening for "!$keyword closed"
                my $answer = space("closed", $keyword[$int+1]);
                $server->command("msg $target Hey $nick, $answer.");
            }elsif ($msg =~ m/!(?:$show[$int])/i){ # listening for "!$keyword"
                my $answer = space("show", $keyword[$int+1]);
                $server->command("msg $target Hey $nick, $answer");
            }
            $int++;
        }
    }
    $server->command("/script load spaceapibot.pl");
}

sub space {
    my $parameter = $_[0];
    my $param2 = $_[1];
    my $anz = $ini->val('spaces', 'anzahl');
    my @spaces = [];
    my @token = [];
    for (my $i = 0; $i < $anz; $i++) {
        push(@spaces, $ini->val('spaces', "space_$i"));
        push(@token, $ini->val('token', "space_$i"));
    }
    for (my $i = 0; $i < $anz; $i++) {
        if ($spaces[$i] eq $param2){
            if ($parameter eq "open") {
                my $link = "$url$spaces[$i]&token=$token[$i]&state=$parameter";
                return "try to open";
            }
            elsif ($parameter eq "closed") {
                return "try to close";
            }
            elsif ($parameter eq "show") {
                return "try to show state";
            }
            else { return "Error: Ungueltige Parameteruebergabe"; }
        }
    }
    return "foo";
}

