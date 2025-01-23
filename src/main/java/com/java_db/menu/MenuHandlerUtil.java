package com.java_db.menu;

import java.util.List;
import java.util.Scanner;

public class MenuHandlerUtil {

  private final List<MenuOption> menuOptions;
  private final Scanner scanner;

  public MenuHandlerUtil(List<MenuOption> menuOptions, Scanner scanner) {
    this.menuOptions = menuOptions;
    this.scanner = scanner;
    menuOptions.add(new MenuOption("Exit", () -> System.out.println("Exiting...")));
  }

  public int displayMenu() {

    System.out.println("\nSelect an option:");
    for (int i = 0; i < menuOptions.size(); i++) {
      System.out.printf("%d. %s\n", i + 1, menuOptions.get(i).getOptionName());
    }
    System.out.print("Enter your choice: ");
    return scanner.nextInt();
  }

  public void interactWithUser() {
    int choice;
    do {
      choice = displayMenu();
      handleUserChoice(choice);
    } while (choice != menuOptions.size());
  }

  public void handleUserChoice(int choice) {
    if (choice > 0 && choice <= menuOptions.size()) {
      MenuOption selectedOption = menuOptions.get(choice - 1);
      selectedOption.execute();
    } else {
      System.out.println("Invalid choice. Please try again.");
    }
  }
}


