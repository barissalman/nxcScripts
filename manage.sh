#!/bin/sh

servers=$(cat servers.txt)

actions="
1	restart server
2	restart processing
"

print_servers() {
	echo "Seçmek istediğiniz serverın başındaki sayıyı girip enter'a basın."
	echo "$servers" | sed '/^$/d' | awk -F "\t" '{print $1"\t"$2}'
}

print_actions() {
	echo "Seçmek istediğiniz aksiyonun başındaki sayıyı girip enter'a basın."
	echo "Farklı bir server için 0 seçiniz."
	echo "$actions" | sed '/^$/d' | awk -F "\t" '{print $1"\t"$2}'

}

print_servers
while read -r ss; do
	server=$(echo "$servers" | sed '/^$/d' | awk -F "\t" -v ss="$ss" '{if ($1==ss) {print $2"\t"$3}}')
	if [ -z "$server" ]; then
		echo "$ss indeksinde server bulunamadı."
		print_servers
	else
		echo "Seçilen Server: $server"
		print_actions
		while read -r as; do
			action=$(echo "$actions" | sed '/^$/d' | awk -F "\t" -v as="$as" '{if ($1==as) {print $2}}')
			if [ "$as" = 0 ]; then
				print_servers
				break
			else
				localip=$(echo "$server" | awk '{print $2}')
				case "$action" in
					"restart server" )
						ssh root@"$localip" 'systemctl restart nxcserver.service'
						;;
					"restart processing" )
						ssh root@"$localip" 'systemctl restart nxcprocessing.service'
						;;
				esac
				echo "komut: $action sunucu: $server gönderildi. Program sonlandı..."
				exit 0
			fi
		done
	fi
done
