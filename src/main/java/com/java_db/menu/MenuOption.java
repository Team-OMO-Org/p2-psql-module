package com.java_db.menu;

public class MenuOption {

  private final String optionName;
  private final Runnable action;

  public MenuOption(String optionName, Runnable action) {
    this.optionName = optionName;
    this.action = action;
  }

  public String getOptionName() {
    return optionName;
  }

  public void execute() {
    action.run();
  }
}
