package controller;

import javax.swing.*;
import java.awt.*;

public class LoginFrame extends JFrame {
    Login login;

    public LoginFrame() {
        super("Login");
        init();
    }

    private void init() {
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setPreferredSize(new Dimension(500, 300));
        setLayout( new BorderLayout() );
        setResizable(false);
        login = new Login(this);
        add(login,BorderLayout.CENTER);
        this.pack();
    }

    public static void main(String[] args) {
        new LoginFrame().setVisible(true);
    }
}
