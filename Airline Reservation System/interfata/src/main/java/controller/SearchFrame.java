package controller;

import javax.swing.*;
import java.awt.*;

public class SearchFrame extends JFrame{
    Search search;

    public SearchFrame() {
        super("Search");
        init();
    }

    private void init() {
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setPreferredSize(new Dimension(600, 500));
        setLayout( new BorderLayout() );
        search = new Search(this);
        add(search,BorderLayout.CENTER);
        this.pack();
    }

    public static void main(String[] args) {
        new controller.SearchFrame().setVisible(true);
    }
}