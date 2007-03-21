package Ocsinventory::Agent::Backend::OS::Win32::Networks;
# http://techtasks.com/code/viewbookcode/1417

use Win32::OLE qw(in);
use Win32::OLE::Variant;

use Net::IP qw(:PROC);;
use strict;

# No check here. If Win32::OLE and Win32::OLE::Variant not avalaible, the module
# will fail to load.
sub check {1}


sub run {
  my $params = shift;
  my $inventory = $params->{inventory};
	

  my $strComputer = '.';
  my $objWMIService = Win32::OLE->GetObject('winmgmts:' . '{impersonationLevel=impersonate}!\\\\' . $strComputer . '\\root\\cimv2');

  #my $nics = $objWMIService->ExecQuery('SELECT * FROM Win32_NetworkAdapterConfiguration WHERE IPEnabled = True');
  my $nics = $objWMIService->ExecQuery('SELECT * FROM Win32_NetworkAdapterConfiguration');

print "\n";

foreach my $nic (in $nics) {
  my $description;
  my $ipaddress;
  my $ipgateway;
  my $ipmask;
  my $ipdhcp;
  my $ipsubnet;
  my $macaddr;
  my $status;
  my $type;

    $description = $nic->Description;

use Data::Dumper;
print Dumper($nic->IPAddress);
die;
foreach ($nic->IPAddress}) {
    $ipaddress += '/' if $ipaddress;
    $ipaddress += $_;
}
print ">>$ipaddress\n";
    $macaddr = $nic->MACAddress;

    $inventory->addNetworks({
	  DESCRIPTION => $description,
      IPADDRESS => $ipaddress,
      IPDHCP => $ipdhcp,
      IPGATEWAY => $ipgateway,
      IPMASK => $ipmask,
      IPSUBNET => $ipsubnet,
      MACADDR => $macaddr,
      STATUS => $status?"Up":"Down",
      TYPE => $type,
	});		
  }
}

1;