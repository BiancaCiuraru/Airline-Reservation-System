package controller;

import javax.swing.*;
import java.awt.*;

public class RegisterFrame extends JFrame {
    Register register;

    public RegisterFrame(){
        super("Register");
        init();
    }

    private void init() {
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setPreferredSize(new Dimension(500, 300));
        setLayout( new BorderLayout() );
        setResizable(false);
        register = new Register(this);
        add(register,BorderLayout.CENTER);
        this.pack();
    }

    public static void main(String[] args) {
        new RegisterFrame().setVisible(true);
    }
}
