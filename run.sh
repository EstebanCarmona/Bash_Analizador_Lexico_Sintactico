#! /bin/bash
clear
echo "Generando Parser"
bison -d interpreteBash.y
echo "Generando Lexer"
flex interpreteBash.lex
echo "Compilando Aplicación"
gcc -lm -o interpreteBash  interpreteBash.tab.c lex.yy.c
echo " "
echo "            *************************************************"
echo "            *********** Ejecutando el programa **************"
echo "            *************************************************"
echo "            *************************************************"
echo "            Los numeros para las funciones estan en radianes!"
echo "            *************************************************"
echo " "
./interpreteBash 
