package controller;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class Ticket extends JPanel {
    private final TicketFrame frame;
    JLabel ruta1;
    JLabel ruta2;
    JLabel ruta3;
    JLabel data1;
    JLabel data2;
    JLabel data3;
    JButton button1;
    JButton button2;
    JButton button3;

    public Ticket( TicketFrame frame){
        this.frame = frame;
        init();
        this.setBackground( new Color( 255, 192, 203));
    }
    public void init(){

        Container gridLayout = new Container();
        gridLayout.setLayout( new GridLayout( 3, 3,5,5 ) );
        gridLayout.setPreferredSize( new Dimension( 500, 100 ) );

        ruta1 = new JLabel( "Ruta: Iasi-Bucuresti " );
        ruta2 = new JLabel( "Ruta: Bucuresti-Paris " );
        ruta3 = new JLabel( "Ruta: Suceava-Londra" );

        data1 = new JLabel( "Data: 10-NOV-2019 " );
        data2 = new JLabel( "Data: 5-OCT-2019 " );
        data3 = new JLabel( "Data: 30-MAY-2019 " );

        button1 = new JButton( "Buy Ticket" );
        button2 = new JButton( "Buy Ticket" );
        button3 = new JButton( "Buy Ticket" );

        gridLayout.add(ruta1);
        gridLayout.add(data1);
        gridLayout.add(button1);
        gridLayout.add(ruta2);
        gridLayout.add(data2);
        gridLayout.add(button2);
        gridLayout.add(ruta3);
        gridLayout.add(data3);
        gridLayout.add(button3);
        add(gridLayout);

        button1.addActionListener( new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                frame.setVisible( false );
                new AddPassagerFrame().setVisible( true );
            }
        } );
    }
}
