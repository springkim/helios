#!/usr/bin/perl
use strict;
use warnings;
use Digest::MD5 ();
use MIME::Base64 ();
use Crypt::CBC ();
my $key = 'tjPT8mH3qafkDLl7sRlEf94wTvIeB1NQ';
my $cipher = Crypt::CBC->new(
        -key         => $key,
        -literal_key => 1,
        -cipher      => 'Crypt::OpenSSL::AES',
        -header      => 'none',
        -iv          => pack('C*', map {0x00} 1..16),
);
sub AES_Encrypt {
    my $plain_text  = $_[0];
    my $cipher_text = $cipher->encrypt($plain_text);
    my $base64_text = MIME::Base64::encode_base64($cipher_text);
    return $base64_text;
}
sub AES_Decrypt {
    my $base64_text = $_[0];
    my $cipher_text = MIME::Base64::decode_base64($base64_text);
    my $plain_text  = $cipher->decrypt($cipher_text);
    return $plain_text;
}
1;