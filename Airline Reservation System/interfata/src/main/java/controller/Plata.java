package controller;

import database.DataBase;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;

public class Plata extends JPanel {
    private final PlataFrame frame;
    JLabel nrCard;
    JTextField nrCardField;
    JLabel nrCvv;
    JTextField nrCvvField;
    JLabel dataExpirare;
    JTextField dataExpirareField;
    JButton plataBtn, inapoi;
    String nume, prenume, nrTel, dataNast, email1, adresa1, nationalitate1, tip1, gen1;

    public Plata(PlataFrame frame, String nume,String prenume, String nrTel, String dataNast,String email1,String adresa1,String nationalitate1,String tip1,String gen1){
        this.frame=frame;
        this.nume = nume;
        this.prenume = prenume;
        this.nrTel = nrTel;
        this.dataNast = dataNast;
        this.email1 = email1;
        this.adresa1 = adresa1;
        this.nationalitate1 = nationalitate1;
        this.tip1 = tip1;
        this.gen1 = gen1;
        init();
        this.setBackground( new Color( 255, 235, 205));
    }
    public void init(){
        Container gridLayout = new Container();
        gridLayout.setLayout( new GridLayout( 8, 1,5,5 ) );
        gridLayout.setPreferredSize( new Dimension( 250, 300 ) );

        nrCard = new JLabel( "Numar card" );
        nrCard.setBounds(213, 130, 100, 62);
        nrCardField = new JTextField(  );
        nrCardField.setBounds(213, 140, 350, 100);
        gridLayout.add(nrCard);
        gridLayout.add(nrCardField);

        nrCvv = new JLabel( "Numar CVV" );
        nrCvv.setBounds(213, 150, 66, 62);
        nrCvvField = new JTextField(  );
        nrCvvField.setBounds(213, 160, 350, 100);
        gridLayout.add(nrCvv);
        gridLayout.add(nrCvvField);

        dataExpirare = new JLabel( "Data expirare" );
        dataExpirare.setBounds(213, 170, 66, 20);
        dataExpirareField = new JTextField(  );
        dataExpirareField.setBounds(213, 180, 350, 100);
        gridLayout.add(dataExpirare);
        gridLayout.add(dataExpirareField);

        plataBtn = new JButton( "Pay" );
        inapoi = new JButton( "Inapoi" );
        gridLayout.add(plataBtn);
        gridLayout.add(inapoi);

        add(gridLayout);

        plataBtn.addActionListener( new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                try{
                    Connection conn = DataBase.createConnection();
                    CallableStatement statement = conn.prepareCall( "{call adaugaPasager(?,?,?,?,?,?,?,?,?)}" );
                    // statement.registerOutParameter( 1, Types.INTEGER );
                    statement.setString( 1, nume );
                    statement.setString( 2, prenume );
                    statement.setString( 3, nrTel );
                    statement.setString( 4, dataNast );
                    statement.setString( 5, email1 );
                    statement.setString( 6, adresa1 );
                    statement.setString( 7, nationalitate1 );
                    statement.setString( 8, tip1 );
                    statement.setString( 9, gen1 );
                    statement.execute();

//                    CallableStatement statement1 = conn.prepareCall( "{call detaliiPlata(?,?,?,?,?,?)}" );
//                    statement1.setString( 1, nrCardField.getText() );
//                    statement1.setString( 2, nrCvvField.getText() );
//                    statement1.setString( 3, dataExpirareField.getText() );
//                    statement1.execute();

//                    CallableStatement statement2 = conn.prepareCall( "{call creareBilet(?,?,?)}" );

                    frame.setVisible( false );
                    SearchFrame searchFrame = new SearchFrame();
                    searchFrame.setVisible( true );

                } catch (SQLException event) {
                    if(event.getErrorCode() == 20002){
                        JOptionPane.showMessageDialog( frame, "The passager already exist in the database.", "", JOptionPane.WARNING_MESSAGE );
                        return;
                    }
                    else if(event.getErrorCode() == 20003){
                        JOptionPane.showMessageDialog( frame, "There are no more available places.", "", JOptionPane.WARNING_MESSAGE );
                        return;
                    }
                }
            }
        } );

        inapoi.addActionListener( new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                frame.setVisible( false );
                AddPassagerFrame addPassagerFrame = new AddPassagerFrame();
                addPassagerFrame.setVisible(true);
            }
        } );
    }
}
