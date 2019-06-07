package controller;

import javax.swing.*;
import java.awt.*;

public class TicketFrame extends JFrame {
    Ticket ticket;

    public TicketFrame(){
        super("Routes");
        init();
    }

    private void init() {
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setPreferredSize(new Dimension(600, 400));
        setLayout( new BorderLayout() );
        ticket = new Ticket(this);
        add(ticket,BorderLayout.CENTER);
        this.pack();
    }

    public static void main(String[] args) {
        new TicketFrame().setVisible(true);
    }
}
