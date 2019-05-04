#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
  if (argc != 2) // `9cc` + code
  {
    fprintf(stderr, "引数の個数が正しくありません\n");
    return 1;
  }

  printf(".intel_syntax noprefix\n");
  printf(".global main\n");
  printf("main:\n");

  char *p = argv[1];
  printf("  mov rax, %ld\n", strtol(p, &p, 10)); // `strtol` stands for "string to long"
  while (*p)
  {
    switch (*p)
    {
    case '+':
      printf("  add rax, %ld\n", strtol(&p[1], &p, 10));
      break;
    case '-':
      printf("  sub rax, %ld\n", strtol(&p[1], &p, 10));
      break;
    default:
      fprintf(stderr, "予期しない文字です: '%c'\n", *p);
      return 1;
    }
  }
  printf("  ret\n");

  return 0;
}
