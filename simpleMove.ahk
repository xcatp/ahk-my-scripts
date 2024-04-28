!h::Left
!j::Down
!k::Up
!l::Right
+!L::End
+!H::Home
+!;:: Send "{End};"
+!,:: Send "{End},"
+!.:: Send "{End}."

^Enter:: Send "{End}{Enter}"
^!Enter:: SendInput '{Home}{Enter}{Up}'

!i:: Send '{BS}'
!o:: Send '{Del}'
+!i:: Send("{Shift Down}{Home}{Shift Up}{BS}")     ; del the content before cursor
+!o:: Send("{Shift Down}{End}{Shift Up}{Del}")     ; del the content after cursor
