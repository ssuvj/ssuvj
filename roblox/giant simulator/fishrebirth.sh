rebirth_menu_rebirthtab="xdotool mousemove 875 195"
rebirth_menu_rebirthtab_rebirthbutton="xdotool mousemove 1175 780"
rebirth_menu_rebirthtab_rebirthbutton_confirm="xdotool mousemove 925 615"
rebirth_menu_skillstab_massupgradebutton="xdotool mousemove 925 805"

while true; do
	$rebirth_menu_rebirthtab
	sleep 0.05
	$rebirth_menu_rebirthtab_rebirthbutton
	sleep 0.05
	$rebirth_menu_skillstab_massupgradebutton
done
