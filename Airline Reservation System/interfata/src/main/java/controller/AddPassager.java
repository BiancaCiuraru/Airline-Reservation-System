package controller;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class AddPassager extends JPanel {
    private final AddPassagerFrame frame;
    private JLabel fname;
    private JTextField fnameField;
    private JLabel lname;
    private JTextField lnameField;
    private JLabel nrTelefon;
    private JTextField nrTelefonField;
    private JLabel dataNastere;
    private JTextField dataNastereField;
    private JLabel email;
    private JTextField emailField;
    private JLabel adresa;
    private JTextField adresaField;
    private JLabel nationalitate;
    private JTextField nationalitateField;

    private JLabel tip; //spinner
    private JComboBox tipField;
    private JLabel gen; //spinner
    private JComboBox genField;

    private JButton addBtn;
    private JLabel gol;

    String nume, prenume, nrTel, dataNast, email1, adresa1, nationalitate1, tip1, gen1;


    public AddPassager(AddPassagerFrame frame){
        this.frame = frame;
        init();
        this.setBackground( new Color( 150, 200, 100) );
    }
    public  void init(){

        Container gridLayout = new Container();
        gridLayout.setLayout( new GridLayout( 11, 2,10, 5));
        gridLayout.setPreferredSize( new Dimension( 500, 400 ) );

        fname = new JLabel( "Nume" );
        lname = new JLabel( "Prenume" );

        fnameField = new JTextField(  );
        lnameField = new JTextField(  );

        gridLayout.add(fname);
        gridLayout.add(lname);
        gridLayout.add(fnameField);
        gridLayout.add(lnameField);

        nrTelefon = new JLabel( "Numar telefon" );
        nrTelefonField = new JTextField(  );
        dataNastere = new JLabel( "Data nastere" );
        dataNastereField = new JTextField(  );
        gridLayout.add(nrTelefon);
        gridLayout.add(dataNastere);
        gridLayout.add(nrTelefonField);
        gridLayout.add(dataNastereField);

        email = new JLabel( "Email" );
        emailField = new JTextField(  );
        adresa = new JLabel( "Adresa" );
        adresaField = new JTextField(  );
        gridLayout.add(email);
        gridLayout.add(adresa);
        gridLayout.add(emailField);
        gridLayout.add(adresaField);

        nationalitate = new JLabel( "Nationalitate" );
        nationalitateField = new JTextField(  );
        tip = new JLabel( "Tip" );
        String[] tipF = {"adult", "copil", "bebelus"};
        tipField = new JComboBox( tipF );
        gridLayout.add(nationalitate);
        gridLayout.add(tip);
        gridLayout.add(nationalitateField);
        gridLayout.add(tipField);

        gen = new JLabel( "Gen" );
        String[] genF = {"FEMININ", "MASCULIN"};
        genField = new JComboBox( genF );
        gol = new JLabel( " " );
        gridLayout.add(gen);
        gridLayout.add(gol);
        gridLayout.add(genField);

        addBtn = new JButton( "Next" );
        gridLayout.add(addBtn);
        add(gridLayout);

        addBtn.addActionListener( new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {

                nume = fnameField.getText();
                prenume = lnameField.getText();
                nrTel = nrTelefonField.getText();
                dataNast = dataNastereField.getText();
                email1 = emailField.getText();
                adresa1 = adresaField.getText();
                nationalitate1 = nationalitateField.getText();
                tip1 = (String) tipField.getSelectedItem();
                gen1 = (String) genField.getSelectedItem();

                if(nume.compareTo("")== 0 || prenume.compareTo("")== 0 || nrTel.compareTo("")== 0 || dataNast.compareTo("")== 0 || email1.compareTo("")== 0 || adresa1.compareTo("")== 0 || nationalitate1.compareTo("")== 0 || tip1.compareTo("")== 0 || gen1.compareTo("")== 0 ){
                    JOptionPane.showMessageDialog( frame, "This fields are requirement.", "Please check your entries.", JOptionPane.WARNING_MESSAGE );
                    return;
                }else {
                    frame.setVisible( false );
                    PlataFrame plataFrame = new PlataFrame( nume, prenume, nrTel, dataNast, email1, adresa1, nationalitate1, tip1, gen1 );
                    plataFrame.setVisible( true );
                }
            }
        } );
    }
}
