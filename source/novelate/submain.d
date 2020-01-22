module novelate.submain;

version (NOVELATE_CUSTOM_MAIN)
{
}
else
{
  /// Entry point when no custom entry point is specified.
  private void main()
  {
    import novelate.core : initialize, run;

    initialize();

    run();
  }
}
