#!/bin/sh

cat out/conversations.json out/conv_*__*json | \
	jq -s 'reduce .[] as $i ({"conversations": [], "messages": []}; { "conversations": (.conversations? + $i.conversations), "messages": (.messages? + $i.messages) })' | \
	jq -r 'def pad($str; $len): ($str + (" " * $len))[0:$len-1]; 
		(.conversations | map({(.id): (.threadProperties?.topic)}) | add) as $topics | 
		.messages[] | [ .composetime, 
				pad($topics[.conversationid] // .conversationid; 20),
				pad(.messagetype | gsub("[^A-Z/]"; ""); 5),
				pad(.from | sub("^.*contacts/"; ""); 15),
				(.content | sub("\n"; "\\n"; "gn"))
			] | join(" ")'	

