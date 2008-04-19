use strict;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME              => 'XMLRPC::Lite::UpdatePing',
    VERSION_FROM      => 'lib/XMLRPC/Lite/UpdatePing.pm', # finds $VERSION
    PREREQ_PM         => { 'XMLRPC::Lite' => '0.60', }, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/XMLRPC/Lite/UpdatePing.pm', # retrieve abstract from module
       AUTHOR         => 'Kazuhiro Sera <webmaster@seratch.ath.cx>') : ()),
);
