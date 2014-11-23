#!/usr/bin/perl

use strict;
use Modules::Utils::Base;
use Mail::MboxParser;

package ATTACHMENTS;
    our $name_folder;
    our $with_attachment=0;
    
sub DecodeAttachments{
    my $fcaller     = shift;
    my $fname       = BASE::getFunctionName($fcaller,(caller(0))[3]);
    my $file_name   = shift;
    my $total       = 0;
    my $parseropts = {
        enable_cache    => 1,
        enable_grep     => 1,
        cache_file_name => 'mail/cache-file',
    };
    my $name;
    $name_folder = shift;
    
    BASE::logMsgT($fname,"Decoding Attachments",2,$GLOBAL_VARS::LOG_FH);
    my $mailbox = Mail::MboxParser->new($file_name,decode=>'ALL',parseropts=>$parseropts);
    my @messages_array = $mailbox->get_messages;
    ######################################################################
    # Keep this in mind if you wish to set up a new line delimiter       #
    # my $mb = new Mail::MboxParser ("mbox", newline => '#DELIMITER');   #
    ######################################################################

  
    while (my $msg = $mailbox->get_messages)
    {
        unless(-d "$CONFIG_VARS::attachments_output/$name_folder"){
            mkdir "$CONFIG_VARS::attachments_output/$name_folder";
            print "Created directory $CONFIG_VARS::attachments_output/$name_folder\n" if $CONFIG_VARS::debug == 1;
            BASE::logMsgT($fname,"Created directory $CONFIG_VARS::attachments_output/$name_folder",2,$GLOBAL_VARS::LOG_FH);
        }
        $msg->store_all_attachments(path => "$CONFIG_VARS::attachments_output/$name_folder");
        if ($msg =~ /.*name="([A-z\d\-\.]+)"/){
            $name=$1;
        }
        ++$total;
        print "Decoded file: $name\n" if $CONFIG_VARS::debug == 1;
        BASE::logMsgT($fname,"Decoded file: $name",3,$GLOBAL_VARS::LOG_FH) if $CONFIG_VARS::debug == 2;
    }
    $ATTACHMENTS::with_attachment = 1 if $total != 0;
    print "$total file(s) decoded\n" if $CONFIG_VARS::debug == 1;
    BASE::logMsgT($fname,"$total file(s) decoded",3,$GLOBAL_VARS::LOG_FH) if $CONFIG_VARS::debug == 2;
}
1;
