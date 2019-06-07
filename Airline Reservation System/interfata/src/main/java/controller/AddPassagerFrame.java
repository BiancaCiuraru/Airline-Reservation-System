package controller;

import javax.swing.*;
import java.awt.*;

public class AddPassagerFrame extends JFrame {
    AddPassager addPassager;

    public AddPassagerFrame() {
        super("Add passager");
        init();
    }

    private void init() {
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setPreferredSize(new Dimension(600, 450));

        setLayout( new BorderLayout() );
        addPassager = new AddPassager(this);
        add(addPassager,BorderLayout.CENTER);
        this.pack();
    }

    public static void main(String[] args) {
        new AddPassagerFrame().setVisible(true);
    }
}
