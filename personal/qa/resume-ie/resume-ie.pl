use strict;
use warnings;
use Win32::GuiTest qw(FindWindowLike GetWindowText  SetForegroundWindow SendKeys WaitWindow);


while (1) {
print "Waiting for the [Error] window\n";
my @windows = WaitWindow('^Error$', 30) or next;
for (grep {$_} @windows) {
print "Found window $_\n";
SetForegroundWindow($_);
SendKeys("%y");
sleep 5;
SendKeys("~");
}
}