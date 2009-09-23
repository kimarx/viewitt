#!/usr/bin/perl
## viewitt.pl
## This is a very simple Twitter viewer written in Perl.
## Last Update < 2009-09-23 19:36 >
## Kim, Yi-Chul <kimarx@gmail.com>

use warnings;
use strict;
use utf8;

use LWP::UserAgent;
use JSON;
use Encode;
use Term::ANSIColor;


### Configuration
## Set your accout information of twitter to these variables.
my $username = 'your_username';  # your username
my $password = 'your_password';  # your password

## What number of your timeline status do you want this script to
## show?
my $status_number = 200;


### The JSON data received is converted to Perl-data-form.
## The code showed below gets the JSON data of your friend timeline via
## Twitter API.
my $friend_timeline_data = &get_content($username, $password, $status_number);
## Converts the JSON data to Perl data,
my $status = decode_json $friend_timeline_data;


### The timeline data is printed out on your terminal. Things listed
### here are username, status, and status id.
foreach my $status (@$status) {
  my $screen_name = "$status->{user}->{screen_name}";
  my $text = "$status->{text}";
  my $id = "$status->{id}";

  $text = encode('utf8', $text);

  print color 'bold';
  print "$screen_name";
  print color 'reset';
  print "\t";
  print "$text\t";
  print "$id\n";
}


### Subroutines of This Script.
### This gets the JSON data via Twitter API.
sub get_content
{
  my ($uname, $pass, $count) = @_;

  my $api_uri = 'http://twitter.com/statuses/friends_timeline.json?count=';
  $api_uri = $api_uri . $count;


  my $ua = LWP::UserAgent->new;
  $ua->timeout(60);    # The default number of timeout second is 60.
  require HTTP::Request;
  my $req = HTTP::Request->new(GET => $api_uri);
  ## authorization_basic needs your username and password.
  $req->authorization_basic($uname, $pass);

  ## Receives the response from Twitter.
  my $res = $ua->request($req);
  ## From the result, abstracts the JSON data.
  my $content = $res->content;

  return $content;
}
