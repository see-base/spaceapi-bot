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
use feature 'say';
use Irssi;                      # Für den Bot
use Config::IniFiles;
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
our $keyword = "space";
our $open = "open"; # to change state to open
our $closed = "closed"; # to change state to closed
# Global Parameters:
our $url = "https://bodensee.space/cgi-bin/togglestate?";


# programm
our $user = getpwuid( $< );
Irssi::signal_add 'message public', 'sig_message_public';
# Konfigurationsdateien einlesen
my $ini = Config::IniFiles->new( -file => "/home/$user/.irssi/spaceapi-bot/config/token.ini" ) or die;
say $ini->val('vars', 'test');

sub sig_message_public {
    my ($server, $msg, $nick, $nick_addr, $target) = @_;
    if ($target =~ m/#(?:$main_channel)/) { # only operate in these channels
        # listen to keyword to do something:
        if ($msg =~ m/!(?:$keyword $open)/i){ # listening for "!$keyword"
            $server->command("msg $target Hey $nick, du wolltest den Space auf 'offen' stellen.");
        }elsif ($msg =~ m/!(?:$keyword $closed)/i){ # listening for "!$keyword"
            $server->command("msg $target Hey $nick, du wolltest den Space auf 'geschlossen' stellen.");
        }elsif ($msg =~ m/!(?:$keyword)/i){ # listening for "!$keyword"
            $server->command("msg $target Hey $nick, du wolltest den Status des Space rausfinden!");
        }
    }
    $server->command("/script load spaceapibot.pl");
}

