#!/bin/bash

function Cartella
{
    select COMANDO in "Open" "Copy" "Cut" "Rename" "MOVE to Trash" "PERMANENTLY Delete"
    do
        case "$COMANDO" in
            "Open")
                cd "$1"
                ;;
             "Copy")
                 read -e -p "Copy to? " DESTINAZIONE
                 cp -r "$1" "$DESTINAZIONE"
                 echo "$1 copied into $DESTINAZIONE"
                ;;
             "Cut")
                 read -e -p "Move to? " DESTINAZIONE
                 mv "$1" "$DESTINAZIONE"
                 echo "$1 moved into $DESTINAZIONE"
                ;;
             "Rename")
                 read -e -p "Rename to? " DESTINAZIONE
                 mv "$1" "$DESTINAZIONE"
                 echo "$1 remamed to $DESTINAZIONE"
                ;;
              "MOVE to Trash")
                 mv "$1" "$HOME/.local/share/Trash/files/"
                ;;
               "PERMANENTLY Delete")
                 read -p "ARE YOU SURE WANT TO DELETE PERMANENTLY $1 (Y/n)? " RISPOSTA
                 if [[ "$RISPOSTA" == "Y" ]];
                 then
                     rm --recursive "$1"
                 fi
                ;;
         esac
         break
     done
}

function File
{
    select COMANDO in "Open" "Edit" "Copy" "Cut" "Rename" "MOVE to Trash" "PERMANENTLY Delete"
    do
        case "$COMANDO" in
            "Open")
                if [[ $(file "$1") == *" ASCII "* ]];
                then
                    less "$1"
                elif [[ $(file "$1") == *" image "* ]];
                then
                    jp2a "$1"
                else
                    echo "$1 is not a text file"
                fi
                ;;
            "Edit")
                if [[ $(file "$1") == *"ASCII"* ]];
                then
                    nano "$1"
                else
                    echo "$1 is not a text file"
                fi
                ;;
             "Copy")
                 read -e -p "Copy to? " DESTINAZIONE
                 cp -r "$1" "$DESTINAZIONE"
                 echo "$1 copied into $DESTINAZIONE"
                ;;
             "Cut")
                 read -e -p "Move to? " DESTINAZIONE
                 mv "$1" "$DESTINAZIONE"
                 echo "$1 moved into $DESTINAZIONE"
                ;;
             "Rename")
                 read -e -p "Rename to? " DESTINAZIONE
                 mv "$1" "$DESTINAZIONE"
                 echo "$1 remamed to $DESTINAZIONE"
                ;;
              "MOVE to Trash")
                 mv "$1" "$HOME/.local/share/Trash/files/"
                ;;
               "PERMANENTLY Delete")
                 read -p "ARE YOU SURE WANT TO DELETE PERMANENTLY $1 (Y/n)? " RISPOSTA
                 if [[ "$RISPOSTA" == "Y" ]];
                 then
                     rm "$1"
                 fi
                ;;
         esac
         break
     done
}

function Trash
{
    cd "$HOME/.local/share/Trash/files/"
    while [[ "$SCELTA" != "GO TO Desktop" ]];
    do
        select SCELTA in "GO TO Desktop" *
        do
            if [[ -d "$SCELTA" ]];
            then
                echo "$SCELTA is a folder"
                Cartella "$SCELTA"
            elif [[ -f "$SCELTA" ]];
            then
                echo "$SCELTA is a file"
                File "$SCELTA"
            fi
         break
         done
    done
}

echo "Check dipendencies..."

if [[ ! -f $(which nano) ]];
then
    echo "please install nano"
    PACCHETTI="nano"
fi

if [[ ! -f $(which jp2a) ]];
then
    echo "please install jp2a"
    PACCHETTI="$PACCHETTI jp2a"
fi

if [[ "$PACCHETTI" != "" ]];
then
    echo "sudo apt install " "$PACCHETTI"
fi

cd "$HOME/Desktop"
while true
do
    select SCELTA in ".." $(if [[ "$PWD" == "$HOME/Desktop" ]]; then echo "Trash"; fi) *
    do
        if [[ "$SCELTA" == ".." ]];
        then
            cd ".."
        elif [[ -d "$SCELTA" ]];
        then
            echo "$SCELTA is a folder"
            Cartella "$SCELTA"
        elif [[ -f "$SCELTA" ]];
        then
            echo "$SCELTA is a file"
            File "$SCELTA"
        elif [[ "$SCELTA" == "Trash" ]];
        then
            Trash
        fi
        break
    done
done
