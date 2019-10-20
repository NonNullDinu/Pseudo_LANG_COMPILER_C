/*
 * utils.c
 *
 *  Created on: Oct 20, 2019
 *      Author: dinu
 */

#include "../include/utils.h"

int starts_with(const char *a, const char *b) {
	for (int i = 0; b[i] != '\0'; i++)
		if (a[i] != b[i])
			return 0;
	return 1;
}

int starts_class(const char *a, CHARACTER_CLASS b) {
	return (*b.belongs_to_class)(*a);
}

int is_whitespace(const char a) {
	return a == ' ' || a == '\t';
}

int is_digit(const char a) {
	return a >= '0' && a <= '9';
}

int is_valid_identifier_first_char(const char a) {
	return (a >= 'A' && a <= 'Z') || (a >= 'a' && a <= 'z') || a == '_';
}

int is_valid_identifier_other_char(const char a) {
	return is_valid_identifier_first_char(a) || is_digit(a);
}

void Init_Utils() {
	DIGIT_CLASS.belongs_to_class = is_digit;
	IDENTIFIER_FIRST_CHARS.belongs_to_class = is_valid_identifier_first_char;
	IDENTIFIER_OTHER_CHARS.belongs_to_class = is_valid_identifier_other_char;
}
