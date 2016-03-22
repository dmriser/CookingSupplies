void hel_init_wrapper(int *runno)
{
  hel_init_(runno);
}

int hel_get_wrapper(int *evno, int *ihel) {
  hel_get_(evno,ihel);
}

void hel_close_wrapper() {
  hel_close_();
}

