package controller;

import database.DataBase;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Types;

public class Search extends JPanel {
    private final SearchFrame frame;
    private JLabel title;
    private JLabel titleGol1;
    private JLabel titleGol2;
    private JLabel titleGol3;
    private JLabel flightFrom;
    private JLabel flightTo;
    private JLabel journeyDate;
    private JLabel clasa;
    private JLabel gol;
    private JTextField fromField;
    private JTextField toField;
    private JTextField journeyDateField;
    private JComboBox  clasaField;
    private JButton search;
    private JButton yourTichets;

    DataBase dataBase = new DataBase();

    public Search(SearchFrame frame) {
        this.frame = frame;
        init();
        this.setBackground( new Color( 255, 160, 122) );
    }

    public void init(){
        Container gridLayout=new Container();
        gridLayout.setLayout( new GridLayout( 4, 4, 5, 5) );
        gridLayout.setPreferredSize(new Dimension(500, 170));
        title = new JLabel( "Search for flights" );
        title.setSize( 80, 50 );
        titleGol1 = new JLabel( " " );
        titleGol2 = new JLabel( " " );
        titleGol3 = new JLabel( " " );
        gridLayout.add(title);
        gridLayout.add( titleGol1 );
        gridLayout.add( titleGol2 );
        gridLayout.add( titleGol3 );

        flightFrom = new JLabel("From: ");
        fromField = new JTextField();
        flightTo = new JLabel("To: ");
        toField = new JTextField();
        journeyDate = new JLabel( "Date" );
        journeyDateField = new JTextField(  );
        clasa = new JLabel( "Class" );

        String[] clas = { "Economica", "Intai", "Bussiness" };
        clasaField = new JComboBox( clas );

        gridLayout.add(flightFrom);
        gridLayout.add(flightTo);
        gridLayout.add(journeyDate);
        gridLayout.add(clasa);
        gridLayout.add(fromField);
        gridLayout.add(toField);
        gridLayout.add(journeyDateField);
        gridLayout.add(clasaField);

        search = new JButton( "Search" );
        yourTichets = new JButton( "Your tickets" );
        gridLayout.add(search);
        gridLayout.add(yourTichets);
        add( gridLayout );

        search.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent event1) {
                try {
                    Connection conn = DataBase.createConnection();

                    CallableStatement statement = conn.prepareCall( "{?=call returnRuta(?,?,?,?)}" );
                    statement.registerOutParameter( 1, Types.ARRAY);
                    statement.setString( 2, fromField.getText() );
                    statement.setString( 3, toField.getText() );
                    statement.setString( 4, journeyDateField.getText() );
                    statement.setString( 5, String.valueOf( clasaField.getSelectedItem() ) );
//                    statement.execute();

                    frame.setVisible(false);
                    new TicketFrame().setVisible(true);
                }catch (SQLException e) {
                    if(e.getErrorCode() == 20007) {
                        JOptionPane.showMessageDialog(frame, "There are no results for this search.", "Please Enter Again", JOptionPane.WARNING_MESSAGE);
                        return;
                    }
                    else if(e.getErrorCode() == 20009) {
                        JOptionPane.showMessageDialog(frame, "There are no flights on this route.", "Please Enter Again", JOptionPane.WARNING_MESSAGE);
                        return;
                    }
                    else if(e.getErrorCode() == 20008) {
                        JOptionPane.showMessageDialog(frame, "There are no free seats for this flight.", "Please Enter Again", JOptionPane.WARNING_MESSAGE);
                        return;
                    }
                }
            }
        });

    }

}



