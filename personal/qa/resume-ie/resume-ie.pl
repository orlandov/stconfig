use strict;
use warnings;
use Win32::GuiTest qw(
    FindWindowLike GetWindowText  SetForegroundWindow SendKeys WaitWindow
);

while (1) {
    print "Waiting for the [Error] window...\n";
    my @windows = WaitWindow( '^Error$', 10 ) or next;
    for ( grep { $_ } @windows ) {
        print "Found window $_\n";
        SetForegroundWindow($_);
        SendKeys("%y");
        sleep 3;
        SendKeys("~");
        sleep 5;
        my @remaining = WaitWindow( '^Microsoft Script Debugger$', 5 ) or next;
        if ( my ($last) = grep { $_ } @remaining ) {
            SetForegroundWindow($last);
            SendKeys("~%fx");
        }
    }
}
